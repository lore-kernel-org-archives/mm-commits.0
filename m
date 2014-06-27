From: akpm@linux-foundation.org
Subject: + mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
 added to -mm tree
Date: Fri, 27 Jun 2014 12:47:24 -0700
Message-ID: <53adca4c.5AdqVim3Sy5M/9Rm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:44878 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaF0TrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jun 2014 15:47:25 -0400
Received: by mail-pd0-f202.google.com with SMTP id r10so764836pdi.5
        for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2014 12:47:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export NR_SHMEM via sysinfo(2) / si_meminfo() interfaces
has been added to the -mm tree.  Its filename is
     mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: export NR_SHMEM via sysinfo(2) / si_meminfo() interfaces

Historically, we exported shared pages to userspace via sysinfo(2)
sharedram and /proc/meminfo's "MemShared" fields.  With the advent of
tmpfs, from kernel v2.4 onward, that old way for accounting shared mem was
deemed inaccurate and we started to export a hard-coded 0 for
sysinfo.sharedram.  Later on, during the 2.6 timeframe, "MemShared" got
re-introduced to /proc/meminfo re-branded as "Shmem", but we're still
reporting sysinfo.sharedmem as that old hard-coded zero, which makes the
"shared memory" report inconsistent across interfaces.

This patch leverages the addition of explicit accounting for pages used by
shmem/tmpfs -- "4b02108 mm: oom analysis: add shmem vmstat" -- in order to
make the users of sysinfo(2) and si_meminfo*() friends aware of that
vmstat entry and make them report it consistently across the interfaces,
as well to make sysinfo(2) returned data consistent with our current API
documentation states.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 fs/proc/meminfo.c   |    2 +-
 mm/page_alloc.c     |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/base/node.c~mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces drivers/base/node.c
--- a/drivers/base/node.c~mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces
+++ a/drivers/base/node.c
@@ -126,7 +126,7 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
-		       nid, K(node_page_state(nid, NR_SHMEM)),
+		       nid, K(i.sharedram),
 		       nid, node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
 		       nid, K(node_page_state(nid, NR_PAGETABLE)),
diff -puN fs/proc/meminfo.c~mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces
+++ a/fs/proc/meminfo.c
@@ -168,7 +168,7 @@ static int meminfo_proc_show(struct seq_
 		K(global_page_state(NR_WRITEBACK)),
 		K(global_page_state(NR_ANON_PAGES)),
 		K(global_page_state(NR_FILE_MAPPED)),
-		K(global_page_state(NR_SHMEM)),
+		K(i.sharedram),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
diff -puN mm/page_alloc.c~mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces mm/page_alloc.c
--- a/mm/page_alloc.c~mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces
+++ a/mm/page_alloc.c
@@ -3047,7 +3047,7 @@ static inline void show_node(struct zone
 void si_meminfo(struct sysinfo *val)
 {
 	val->totalram = totalram_pages;
-	val->sharedram = 0;
+	val->sharedram = global_page_state(NR_SHMEM);
 	val->freeram = global_page_state(NR_FREE_PAGES);
 	val->bufferram = nr_blockdev_pages();
 	val->totalhigh = totalhigh_pages;
@@ -3067,6 +3067,7 @@ void si_meminfo_node(struct sysinfo *val
 	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
 		managed_pages += pgdat->node_zones[zone_type].managed_pages;
 	val->totalram = managed_pages;
+	val->sharedram = node_page_state(nid, NR_SHMEM);
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
 	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].managed_pages;
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch

