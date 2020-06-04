From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 046/127] mm/memory_hotplug: handle memblocks only
 with CONFIG_ARCH_KEEP_MEMBLOCK
Date: Thu, 04 Jun 2020 16:48:38 -0700
Message-ID: <20200604234838.DDi7I5qR9%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:48:39 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, bhe@redhat.com, david@redhat.com, linux-mm@kvack.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pankaj.gupta.linux@gmail.com, rppt@linux.ibm.com, torvalds@linux-foundation.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: handle memblocks only with CONFIG_ARCH_KEEP_MEMBLOCK

The comment in add_memory_resource() is stale: hotadd_new_pgdat() will no
longer call get_pfn_range_for_nid(), as a hotadded pgdat will simply span
no pages at all, until memory is moved to the zone/node via
move_pfn_range_to_zone() - e.g., when onlining memory blocks.

The only archs that care about memblocks for hotplugged memory (either for
iterating over all system RAM or testing for memory validity) are arm64,
s390x, and powerpc - due to CONFIG_ARCH_KEEP_MEMBLOCK.  Without
CONFIG_ARCH_KEEP_MEMBLOCK, we can simply stop messing with memblocks.

Link: http://lkml.kernel.org/r/20200422155353.25381-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig          |    3 +++
 mm/memory_hotplug.c |   20 ++++++++++----------
 2 files changed, 13 insertions(+), 10 deletions(-)

--- a/mm/Kconfig~mm-memory_hotplug-handle-memblocks-only-with-config_arch_keep_memblock
+++ a/mm/Kconfig
@@ -133,6 +133,9 @@ config HAVE_FAST_GUP
 	depends on MMU
 	bool
 
+# Don't discard allocated memory used to track "memory" and "reserved" memblocks
+# after early boot, so it can still be used to test for validity of memory.
+# Also, memblocks are updated with memory hot(un)plug.
 config ARCH_KEEP_MEMBLOCK
 	bool
 
--- a/mm/memory_hotplug.c~mm-memory_hotplug-handle-memblocks-only-with-config_arch_keep_memblock
+++ a/mm/memory_hotplug.c
@@ -1021,13 +1021,8 @@ int __ref add_memory_resource(int nid, s
 
 	mem_hotplug_begin();
 
-	/*
-	 * Add new range to memblock so that when hotadd_new_pgdat() is called
-	 * to allocate new pgdat, get_pfn_range_for_nid() will be able to find
-	 * this new range and calculate total pages correctly.  The range will
-	 * be removed at hot-remove time.
-	 */
-	memblock_add_node(start, size, nid);
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
+		memblock_add_node(start, size, nid);
 
 	ret = __try_online_node(nid, false);
 	if (ret < 0)
@@ -1076,7 +1071,8 @@ error:
 	/* rollback pgdat allocation and others */
 	if (new_node)
 		rollback_node_hotadd(nid);
-	memblock_remove(start, size);
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
+		memblock_remove(start, size);
 	mem_hotplug_done();
 	return ret;
 }
@@ -1673,8 +1669,12 @@ static int __ref try_remove_memory(int n
 	mem_hotplug_begin();
 
 	arch_remove_memory(nid, start, size, NULL);
-	memblock_free(start, size);
-	memblock_remove(start, size);
+
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
+		memblock_free(start, size);
+		memblock_remove(start, size);
+	}
+
 	__release_memory_resource(start, size);
 
 	try_offline_node(nid);
_
