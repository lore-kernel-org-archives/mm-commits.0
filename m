From: akpm@linux-foundation.org
Subject: +
 mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix.patch added to
 -mm tree
Date: Thu, 29 Jan 2015 13:19:27 -0800
Message-ID: <54caa3df.Ugg6Tv2cX3QgMu0c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845AbbA2VT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jan 2015 16:19:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix
has been added to the -mm tree.  Its filename is
     mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix

unicore32: missed semicolon


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/mm/pgd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/unicore32/mm/pgd.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix arch/unicore32/mm/pgd.c
--- a/arch/unicore32/mm/pgd.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix
+++ a/arch/unicore32/mm/pgd.c
@@ -99,7 +99,7 @@ void free_pgd_slow(struct mm_struct *mm,
 	pte_free(mm, pte);
 	atomic_long_dec(&mm->nr_ptes);
 	pmd_free(mm, pmd);
-	mm_dec_nr_pmds(mm)
+	mm_dec_nr_pmds(mm);
 free:
 	free_pages((unsigned long) pgd, 0);
 }
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-replace-remap_file_pages-syscall-with-emulation.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
docs-procs-describe-proc-pid-map_files-entry.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

