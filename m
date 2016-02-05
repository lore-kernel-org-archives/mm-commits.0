From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2.patch added to
 -mm tree
Date: Fri, 05 Feb 2016 11:40:09 -0800
Message-ID: <56b4fa99.LGN48imLlA+g7LjD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbcBETkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 14:40:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2
has been added to the -mm tree.  Its filename is
     mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2

Update also arch-specific code as Kirill pointed out.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2 arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2
+++ a/arch/x86/mm/hugetlbpage.c
@@ -173,10 +173,10 @@ static __init int setup_hugepagesz(char
 }
 __setup("hugepagesz=", setup_hugepagesz);
 
-#ifdef CONFIG_CMA
+#if (defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA)
 static __init int gigantic_pages_init(void)
 {
-	/* With CMA we can allocate gigantic pages at runtime */
+	/* With compaction or CMA we can allocate gigantic pages at runtime */
 	if (cpu_has_gbpages && !size_to_hstate(1UL << PUD_SHIFT))
 		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 	return 0;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kconfig-correct-description-of-deferred_struct_page_init.patch
mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch
mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2.patch
mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2.patch
tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch
mm-use-radix_tree_iter_retry-fix.patch

