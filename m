From: akpm@linux-foundation.org
Subject: +
 mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect.patch
 added to -mm tree
Date: Tue, 21 Feb 2017 14:06:34 -0800
Message-ID: <58acb9ea.ZjSIazXC1PhdGeJb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdBUWGf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2017 17:06:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: Handle protnone saved writes when making page write protect
has been added to the -mm tree.  Its filename is
     mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/ksm: Handle protnone saved writes when making page write protect

Without this KSM will consider the page write protected, but a numa fault can
later mark the page writable. This can result in memory corruption.

Link: http://lkml.kernel.org/r/1487498625-10891-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

index b6f3a8a4b738..8c8ba48bef0b 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    8 ++++++++
 mm/ksm.c                      |    9 +++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/pgtable.h~mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect
+++ a/include/asm-generic/pgtable.h
@@ -233,6 +233,10 @@ static inline void ptep_set_wrprotect(st
 #define pte_mk_savedwrite pte_mkwrite
 #endif
 
+#ifndef pte_clear_savedwrite
+#define pte_clear_savedwrite pte_wrprotect
+#endif
+
 #ifndef pmd_savedwrite
 #define pmd_savedwrite pmd_write
 #endif
@@ -241,6 +245,10 @@ static inline void ptep_set_wrprotect(st
 #define pmd_mk_savedwrite pmd_mkwrite
 #endif
 
+#ifndef pmd_clear_savedwrite
+#define pmd_clear_savedwrite pmd_wrprotect
+#endif
+
 #ifndef __HAVE_ARCH_PMDP_SET_WRPROTECT
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
diff -puN mm/ksm.c~mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect mm/ksm.c
--- a/mm/ksm.c~mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect
+++ a/mm/ksm.c
@@ -880,7 +880,8 @@ static int write_protect_page(struct vm_
 	if (WARN_ONCE(!pvmw.pte, "Unexpected PMD mapping?"))
 		goto out_unlock;
 
-	if (pte_write(*pvmw.pte) || pte_dirty(*pvmw.pte)) {
+	if (pte_write(*pvmw.pte) || pte_dirty(*pvmw.pte) ||
+	    (pte_protnone(*pvmw.pte) && pte_savedwrite(*pvmw.pte))) {
 		pte_t entry;
 
 		swapped = PageSwapCache(page);
@@ -905,7 +906,11 @@ static int write_protect_page(struct vm_
 		}
 		if (pte_dirty(entry))
 			set_page_dirty(page);
-		entry = pte_mkclean(pte_wrprotect(entry));
+
+		if (pte_protnone(entry))
+			entry = pte_mkclean(pte_clear_savedwrite(entry));
+		else
+			entry = pte_mkclean(pte_wrprotect(entry));
 		set_pte_at_notify(mm, pvmw.address, pvmw.pte, entry);
 	}
 	*orig_pte = *pvmw.pte;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch
mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch
mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3.patch
mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3.patch

