From: akpm@linux-foundation.org
Subject: + mmots-memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch added to -mm tree
Date: Fri, 11 Jan 2013 12:50:38 -0800
Message-ID: <20130111205040.6AA3C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:35063 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3AKUun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Jan 2013 15:50:43 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so132237wgb.3
        for <mm-commits@vger.kernel.org>; Fri, 11 Jan 2013 12:50:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, linfeng@cn.fujitsu.com


The patch titled
     Subject: mmots-memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix
has been added to the -mm tree.  Its filename is
     mmots-memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch

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
Subject: mmots-memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix

put register_page_bootmem_memmap inside CONFIG_MEMORY_HOTPLUG_SPARSE

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/mm/init_64.c~mmots-memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mmots-memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix
+++ a/arch/x86/mm/init_64.c
@@ -1000,6 +1000,7 @@ vmemmap_populate(struct page *start_page
 	return 0;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
@@ -1057,6 +1058,7 @@ void register_page_bootmem_memmap(unsign
 		}
 	}
 }
+#endif
 
 void __meminit vmemmap_populate_print_last(void)
 {
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
mmots-memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

