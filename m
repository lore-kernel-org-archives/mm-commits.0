From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-hotplug-print-the-last-vmemmap-region-at-the-end-of-hot-add-memory.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:28 -0700
Message-ID: <5591ad00.v3EyuSZfzdVtcDoL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbbF2Uj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhugh.fnst@cn.fujitsu.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory hotplug: print the last vmemmap region at the end of hot add memory
has been removed from the -mm tree.  Its filename was
     mm-memory-hotplug-print-the-last-vmemmap-region-at-the-end-of-hot-add-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhu Guihua <zhugh.fnst@cn.fujitsu.com>
Subject: mm/memory hotplug: print the last vmemmap region at the end of hot add memory

When hot add two nodes continuously, we found the vmemmap region info is a
bit messed. The last region of node 2 is printed when node 3 hot added,
like the following:
Initmem setup node 2 [mem 0x0000000000000000-0xffffffffffffffff]
 On node 2 totalpages: 0
 Built 2 zonelists in Node order, mobility grouping on.  Total pages: 16090539
 Policy zone: Normal
 init_memory_mapping: [mem 0x40000000000-0x407ffffffff]
  [mem 0x40000000000-0x407ffffffff] page 1G
  [ffffea1000000000-ffffea10001fffff] PMD -> [ffff8a077d800000-ffff8a077d9fffff] on node 2
  [ffffea1000200000-ffffea10003fffff] PMD -> [ffff8a077de00000-ffff8a077dffffff] on node 2
...
  [ffffea101f600000-ffffea101f9fffff] PMD -> [ffff8a074ac00000-ffff8a074affffff] on node 2
  [ffffea101fa00000-ffffea101fdfffff] PMD -> [ffff8a074a800000-ffff8a074abfffff] on node 2
Initmem setup node 3 [mem 0x0000000000000000-0xffffffffffffffff]
 On node 3 totalpages: 0
 Built 3 zonelists in Node order, mobility grouping on.  Total pages: 16090539
 Policy zone: Normal
 init_memory_mapping: [mem 0x60000000000-0x607ffffffff]
  [mem 0x60000000000-0x607ffffffff] page 1G
  [ffffea101fe00000-ffffea101fffffff] PMD -> [ffff8a074a400000-ffff8a074a5fffff] on node 2 <=== node 2 ???
  [ffffea1800000000-ffffea18001fffff] PMD -> [ffff8a074a600000-ffff8a074a7fffff] on node 3
  [ffffea1800200000-ffffea18005fffff] PMD -> [ffff8a074a000000-ffff8a074a3fffff] on node 3
  [ffffea1800600000-ffffea18009fffff] PMD -> [ffff8a0749c00000-ffff8a0749ffffff] on node 3
...

The cause is the last region was missed at the and of hot add memory, and
p_start, p_end, node_start were not reset, so when hot add memory to a new
node, it will consider they are not contiguous blocks and print the
previous one. So we print the last vmemmap region at the end of hot add
memory to avoid the confusion.

Signed-off-by: Zhu Guihua <zhugh.fnst@cn.fujitsu.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory_hotplug.c~mm-memory-hotplug-print-the-last-vmemmap-region-at-the-end-of-hot-add-memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hotplug-print-the-last-vmemmap-region-at-the-end-of-hot-add-memory
+++ a/mm/memory_hotplug.c
@@ -513,6 +513,7 @@ int __ref __add_pages(int nid, struct zo
 			break;
 		err = 0;
 	}
+	vmemmap_populate_print_last();
 
 	return err;
 }
_

Patches currently in -mm which might be from zhugh.fnst@cn.fujitsu.com are

origin.patch

