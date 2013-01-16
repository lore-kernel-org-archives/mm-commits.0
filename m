From: akpm@linux-foundation.org
Subject: + memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch added to -mm tree
Date: Wed, 16 Jan 2013 14:39:41 -0800
Message-ID: <20130116223942.370E0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:63963 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab3APWjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 17:39:43 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so232213yen.1
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 14:39:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, linfeng@cn.fujitsu.com


The patch titled
     Subject: memory-hotplug: cleanup: removing the arch specific functions without any implementation
has been added to the -mm tree.  Its filename is
     memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memory-hotplug: cleanup: removing the arch specific functions without any implementation

After introducing CONFIG_HAVE_BOOTMEM_INFO_NODE Kconfig option, the
related arch specific functions become confusing, remove them.

Guys who want to implement memory-hotplug feature on such archs for this
part should look into register_page_bootmem_info_node() and flesh out from
top to end.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/discontig.c  |    5 -----
 arch/powerpc/mm/init_64.c |    5 -----
 arch/s390/mm/vmem.c       |    6 ------
 arch/sparc/mm/init_64.c   |    5 -----
 4 files changed, 21 deletions(-)

diff -puN arch/ia64/mm/discontig.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix
+++ a/arch/ia64/mm/discontig.c
@@ -823,9 +823,4 @@ int __meminit vmemmap_populate(struct pa
 	return vmemmap_populate_basepages(start_page, size, node);
 }
 
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-	/* TODO */
-}
 #endif
diff -puN arch/powerpc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix
+++ a/arch/powerpc/mm/init_64.c
@@ -298,10 +298,5 @@ int __meminit vmemmap_populate(struct pa
 	return 0;
 }
 
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-	/* TODO */
-}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
diff -puN arch/s390/mm/vmem.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix
+++ a/arch/s390/mm/vmem.c
@@ -272,12 +272,6 @@ out:
 	return ret;
 }
 
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-	/* TODO */
-}
-
 /*
  * Add memory segment to the segment list if it doesn't overlap with
  * an already present segment.
diff -puN arch/sparc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix
+++ a/arch/sparc/mm/init_64.c
@@ -2232,11 +2232,6 @@ void __meminit vmemmap_populate_print_la
 	}
 }
 
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-	/* TODO */
-}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 static void prot_init_common(unsigned long page_none,
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

