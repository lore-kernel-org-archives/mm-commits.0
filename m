Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA61BC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 00:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242724AbhLHAJG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:09:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58456 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242720AbhLHAJF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 19:09:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4491B81751
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 00:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B97C341C3;
        Wed,  8 Dec 2021 00:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638921932;
        bh=7nB7MpdSGncwE6Jn0WtfYBpqMC5I6jPMWy3gZb2utN0=;
        h=Date:From:To:Subject:From;
        b=Tr0QBlXPzwCxeV68lxjq/XfKu8/S4yrO/ojlO9XFIBsfFXh1286uryyVepL8TCMPJ
         2Ys5KvX8O9Xs74D/L+PNHUjOEEREQL+ia72EpJO6/v51MjevWOPMbi8P+6mwRdku2u
         m5mOej3aCyD/I+pDJ/U715ssJxQyIDkiLwy9Bv9I=
Date:   Tue, 07 Dec 2021 16:05:31 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, frederic@kernel.org,
        gthelen@google.com, hpa@zytor.com, jirislaby@kernel.org,
        keescook@chromium.org, masahiroy@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        peterz@infradead.org, pjt@google.com, rientjes@google.com,
        rppt@kernel.org, samitolvanen@google.com, songmuchun@bytedance.com,
        tglx@linutronix.de, weixugc@google.com, will@kernel.org
Subject:  + x86-mm-add-x86_64-support-for-page-table-check.patch
 added to -mm tree
Message-ID: <20211208000531.xs32yOUS7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: mm: add x86_64 support for page table check
has been added to the -mm tree.  Its filename is
     x86-mm-add-x86_64-support-for-page-table-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-mm-add-x86_64-support-for-page-table-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-add-x86_64-support-for-page-table-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: x86: mm: add x86_64 support for page table check

Add page table check hooks into routines that modify user page tables.

Link: https://lkml.kernel.org/r/20211204182314.1470076-5-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/pgtable.h |   29 +++++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-mm-add-x86_64-support-for-page-table-check
+++ a/arch/x86/include/asm/pgtable.h
@@ -26,6 +26,7 @@
 #include <asm/pkru.h>
 #include <asm/fpu/api.h>
 #include <asm-generic/pgtable_uffd.h>
+#include <linux/page_table_check.h>
 
 extern pgd_t early_top_pgt[PTRS_PER_PGD];
 bool __init __early_make_pgtable(unsigned long address, pmdval_t pmd);
@@ -1006,18 +1007,21 @@ static inline pud_t native_local_pudp_ge
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
+	page_table_check_pte_set(mm, addr, ptep, pte);
 	set_pte(ptep, pte);
 }
 
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
 	set_pmd(pmdp, pmd);
 }
 
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud)
 {
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	native_set_pud(pudp, pud);
 }
 
@@ -1048,6 +1052,7 @@ static inline pte_t ptep_get_and_clear(s
 				       pte_t *ptep)
 {
 	pte_t pte = native_ptep_get_and_clear(ptep);
+	page_table_check_pte_clear(mm, addr, pte);
 	return pte;
 }
 
@@ -1063,12 +1068,23 @@ static inline pte_t ptep_get_and_clear_f
 		 * care about updates and native needs no locking
 		 */
 		pte = native_local_ptep_get_and_clear(ptep);
+		page_table_check_pte_clear(mm, addr, pte);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
 	return pte;
 }
 
+#define __HAVE_ARCH_PTEP_CLEAR
+static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep)
+{
+	if (IS_ENABLED(CONFIG_PAGE_TABLE_CHECK))
+		ptep_get_and_clear(mm, addr, ptep);
+	else
+		pte_clear(mm, addr, ptep);
+}
+
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pte_t *ptep)
@@ -1109,14 +1125,22 @@ static inline int pmd_write(pmd_t pmd)
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pmd_t *pmdp)
 {
-	return native_pmdp_get_and_clear(pmdp);
+	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
+
+	page_table_check_pmd_clear(mm, addr, pmd);
+
+	return pmd;
 }
 
 #define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
 static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 					unsigned long addr, pud_t *pudp)
 {
-	return native_pudp_get_and_clear(pudp);
+	pud_t pud = native_pudp_get_and_clear(pudp);
+
+	page_table_check_pud_clear(mm, addr, pud);
+
+	return pud;
 }
 
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
@@ -1137,6 +1161,7 @@ static inline int pud_write(pud_t pud)
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	if (IS_ENABLED(CONFIG_SMP)) {
 		return xchg(pmdp, pmd);
 	} else {
--- a/arch/x86/Kconfig~x86-mm-add-x86_64-support-for-page-table-check
+++ a/arch/x86/Kconfig
@@ -104,6 +104,7 @@ config X86
 	select ARCH_SUPPORTS_ACPI
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
 	select ARCH_SUPPORTS_LTO_CLANG
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-change-page-type-prior-to-adding-page-table-entry.patch
mm-ptep_clear-page-table-helper.patch
mm-page-table-check.patch
x86-mm-add-x86_64-support-for-page-table-check.patch

