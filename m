From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-fix-nodes-for-reclaim-in-fast-path.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:27:41 -0800
Message-ID: <58b48bbd.cEX25x6g0OunKM1P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdB0U2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gwshan@linux.vnet.ibm.com, anton@samba.org, mgorman@suse.de, mhocko@suse.com, mpe@ellerman.id.au, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix nodes for reclaim in fast path
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-nodes-for-reclaim-in-fast-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <gwshan@linux.vnet.ibm.com>
Subject: mm/page_alloc: fix nodes for reclaim in fast path

When @node_reclaim_node isn't 0, the page allocator tries to reclaim pages
if the amount of free memory in the zones are below the low watermark.  On
Power platform, none of NUMA nodes are scanned for page reclaim because no
nodes match the condition in zone_allows_reclaim().  On Power platform,
RECLAIM_DISTANCE is set to 10 which is the distance of Node-A to Node-A. 
So the preferred node even won't be scanned for page reclaim.

   __alloc_pages_nodemask()
   get_page_from_freelist()
      zone_allows_reclaim()

Anton proposed the test code as below:

   # cat alloc.c
      :
   int main(int argc, char *argv[])
   {
	void *p;
	unsigned long size;
	unsigned long start, end;

	start = time(NULL);
	size = strtoul(argv[1], NULL, 0);
	printf("To allocate %ldGB memory\n", size);

	size <<= 30;
	p = malloc(size);
	assert(p);
	memset(p, 0, size);

	end = time(NULL);
	printf("Used time: %ld seconds\n", end - start);
	sleep(3600);
	return 0;
   }

The system I use for testing has two NUMA nodes.  Both have 128GB memory. 
In below scnario, the page caches on node#0 should be reclaimed when it
encounters pressure to accommodate request of allocation.

   # echo 2 > /proc/sys/vm/zone_reclaim_mode; \
     sync; \
     echo 3 > /proc/sys/vm/drop_caches; \
   # taskset -c 0 cat file.32G > /dev/null; \
     grep FilePages /sys/devices/system/node/node0/meminfo
     Node 0 FilePages:       33619712 kB
   # taskset -c 0 ./alloc 128
   # grep FilePages /sys/devices/system/node/node0/meminfo
     Node 0 FilePages:       33619840 kB
   # grep MemFree /sys/devices/system/node/node0/meminfo
     Node 0 MemFree:          186816 kB

With the patch applied, the pagecache on node-0 is reclaimed when
its free memory is running out. It's the expected behaviour.

   # echo 2 > /proc/sys/vm/zone_reclaim_mode; \
     sync; \
     echo 3 > /proc/sys/vm/drop_caches
   # taskset -c 0 cat file.32G > /dev/null; \
     grep FilePages /sys/devices/system/node/node0/meminfo
     Node 0 FilePages:       33605568 kB
   # taskset -c 0 ./alloc 128
   # grep FilePages /sys/devices/system/node/node0/meminfo
     Node 0 FilePages:        1379520 kB
   # grep MemFree /sys/devices/system/node/node0/meminfo
     Node 0 MemFree:           317120 kB

Fixes: 5f7a75acdb24 ("mm: page_alloc: do not cache reclaim distances")
Link: http://lkml.kernel.org/r/1486532455-29613-1-git-send-email-gwshan@linux.vnet.ibm.com
Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>	[3.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-nodes-for-reclaim-in-fast-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-nodes-for-reclaim-in-fast-path
+++ a/mm/page_alloc.c
@@ -2944,7 +2944,7 @@ bool zone_watermark_ok_safe(struct zone
 #ifdef CONFIG_NUMA
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
-	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <
+	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <=
 				RECLAIM_DISTANCE;
 }
 #else	/* CONFIG_NUMA */
_

Patches currently in -mm which might be from gwshan@linux.vnet.ibm.com are


