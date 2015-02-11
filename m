From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix.patch removed
 from -mm tree
Date: Wed, 11 Feb 2015 15:15:24 -0800
Message-ID: <54dbe28c.0/sEi6dVa2gcB2uT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbbBKXPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:15:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix.patch

This patch was dropped because it was folded into mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch

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

origin.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch
docs-procs-describe-proc-pid-map_files-entry.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch

