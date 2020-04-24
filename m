From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-memory=5Fhotplug-handle-memblocks-only-with-config=5Farch?=
 =?US-ASCII?Q?=5Fkeep=5Fmemblock.patch?= added to -mm tree
Date: Thu, 23 Apr 2020 17:29:12 -0700
Message-ID: <20200424002912.iqa-knoPA%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgDXA3O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 20:29:14 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, bhe@redhat.com, david@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pankaj.gupta.linux@gmail.com, rppt@linux.ibm.com


The patch titled
     Subject: mm/memory_hotplug: handle memblocks only with CONFIG_ARCH_KEEP_MEMBLOCK
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-handle-memblocks-only-with-config_arch_keep_memblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-handle-memblocks-only-with-config_arch_keep_memblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-handle-memblocks-only-with-config_arch_keep_memblock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-fix-watchdog-soft-lockups-during-set_zone_contiguous.patch
drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
powerpc-pseries-hotplug-memory-stop-checking-is_mem_section_removable.patch
mm-memory_hotplug-remove-is_mem_section_removable.patch
mm-memory_hotplug-set-node_start_pfn-of-hotadded-pgdat-to-0.patch
mm-memory_hotplug-handle-memblocks-only-with-config_arch_keep_memblock.patch
