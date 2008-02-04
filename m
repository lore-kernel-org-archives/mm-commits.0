From: akpm@linux-foundation.org
Subject: - add-mm-argument-to-pte-pmd-pud-pgd_free-fix.patch removed from -mm tree
Date: Sun, 03 Feb 2008 20:15:29 -0800
Message-ID: <200802040415.m144FAHx013382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754805AbYBDEPO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 23:15:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     2.6.24-mm1 Build Faliure on pgtable_32.c
has been removed from the -mm tree.  Its filename was
     add-mm-argument-to-pte-pmd-pud-pgd_free-fix.patch

This patch was dropped because it was folded into add-mm-argument-to-pte-pmd-pud-pgd_free.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 2.6.24-mm1 Build Faliure on pgtable_32.c
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Hi Andrew,

The 2.6.24-mm1 kernel build fails with

arch/x86/mm/pgtable_32.c: In function `pgd_mop_up_pmds':
arch/x86/mm/pgtable_32.c:302: warning: passing arg 1 of `pmd_free' from incompatible pointer type
arch/x86/mm/pgtable_32.c:302: error: too few arguments to function `pmd_free'

I have tested the patch for the build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable_32.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/pgtable_32.c~add-mm-argument-to-pte-pmd-pud-pgd_free-fix arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c~add-mm-argument-to-pte-pmd-pud-pgd_free-fix
+++ a/arch/x86/mm/pgtable_32.c
@@ -286,7 +286,7 @@ static void pgd_dtor(void *pgd)
  * preallocate which never got a corresponding vma will need to be
  * freed manually.
  */
-static void pgd_mop_up_pmds(pgd_t *pgdp)
+static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
 {
 	int i;
 
@@ -299,7 +299,7 @@ static void pgd_mop_up_pmds(pgd_t *pgdp)
 			pgdp[i] = native_make_pgd(0);
 
 			paravirt_release_pd(pgd_val(pgd) >> PAGE_SHIFT);
-			pmd_free(pmd);
+			pmd_free(mm, pmd);
 		}
 	}
 }
@@ -327,7 +327,7 @@ static int pgd_prepopulate_pmd(struct mm
 		pmd_t *pmd = pmd_alloc_one(mm, addr);
 
 		if (!pmd) {
-			pgd_mop_up_pmds(pgd);
+			pgd_mop_up_pmds(mm, pgd);
 			return 0;
 		}
 
@@ -347,7 +347,7 @@ static int pgd_prepopulate_pmd(struct mm
 	return 1;
 }
 
-static void pgd_mop_up_pmds(pgd_t *pgd)
+static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
 {
 }
 #endif	/* CONFIG_X86_PAE */
@@ -368,7 +368,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	pgd_mop_up_pmds(pgd);
+	pgd_mop_up_pmds(mm,pgd);
 	quicklist_free(0, pgd_dtor, pgd);
 }
 
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

origin.patch
add-mm-argument-to-pte-pmd-pud-pgd_free.patch
add-mm-argument-to-pte-pmd-pud-pgd_free-fix.patch
add-mm-argument-to-pte-pmd-pud-pgd_free-fix-checkpatch-fixes.patch
scsi-fix-isa-pcmcia-compile-problem.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
