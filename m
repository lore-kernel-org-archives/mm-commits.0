Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D33C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 21:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhLUVti (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 16:49:38 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35832 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhLUVth (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 16:49:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 88FE6CE1A90
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 21:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDEDC36AE8;
        Tue, 21 Dec 2021 21:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640123373;
        bh=LniAjryaEdY7sW0nwkSzFWu7HS0cK23YpGMQgvH5vz4=;
        h=Date:From:To:Subject:From;
        b=lfGAPWnjCM8mS5/4O0tteq2SXsj/eirvsCV6YEQ1lkMYu66qfbAt8hg9y09UbDQOt
         25nTH0hI4zecNuZRLJhpB5gnPVNUBAlhuVyYXORgA2hb0vIsiQQDskHqy+2xPTCRiK
         crW64v5dBN+qlsoE8rUIyKiG9ce1v1laQJN0O2lE=
Date:   Tue, 21 Dec 2021 13:49:32 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, weixugc@google.com,
        tglx@linutronix.de, songmuchun@bytedance.com,
        samitolvanen@google.com, rppt@kernel.org, rientjes@google.com,
        pjt@google.com, peterz@infradead.org, mingo@redhat.com,
        masahiroy@kernel.org, keescook@chromium.org, jirislaby@kernel.org,
        hughd@google.com, hpa@zytor.com, gthelen@google.com,
        frederic@kernel.org, dave.hansen@linux.intel.com, corbet@lwn.net,
        aneesh.kumar@linux.ibm.com, pasha.tatashin@soleen.com
Subject:  + mm-ptep_clear-page-table-helper.patch added to -mm tree
Message-ID: <20211221214932.iKX4w%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ptep_clear() page table helper
has been added to the -mm tree.  Its filename is
     mm-ptep_clear-page-table-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-ptep_clear-page-table-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-ptep_clear-page-table-helper.patch

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
Subject: mm: ptep_clear() page table helper

We have ptep_get_and_clear() and ptep_get_and_clear_full() helpers to
clear PTE from user page tables, but there is no variant for simple clear
of a present PTE from user page tables without using a low level
pte_clear() which can be either native or para-virtualised.

Add a new ptep_clear() that can be used in common code to clear PTEs from
page table.  We will need this call later in order to add a hook for page
table check.

Link: https://lkml.kernel.org/r/20211221154650.1047963-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/arch_pgtable_helpers.rst |    6 ++++--
 include/linux/pgtable.h                   |    8 ++++++++
 mm/debug_vm_pgtable.c                     |    2 +-
 mm/khugepaged.c                           |   12 ++----------
 4 files changed, 15 insertions(+), 13 deletions(-)

--- a/Documentation/vm/arch_pgtable_helpers.rst~mm-ptep_clear-page-table-helper
+++ a/Documentation/vm/arch_pgtable_helpers.rst
@@ -66,9 +66,11 @@ PTE Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_mknotpresent          | Invalidates a mapped PTE                         |
 +---------------------------+--------------------------------------------------+
-| ptep_get_and_clear        | Clears a PTE                                     |
+| ptep_clear                | Clears a PTE                                     |
 +---------------------------+--------------------------------------------------+
-| ptep_get_and_clear_full   | Clears a PTE                                     |
+| ptep_get_and_clear        | Clears and returns PTE                           |
++---------------------------+--------------------------------------------------+
+| ptep_get_and_clear_full   | Clears and returns PTE (batched PTE unmap)       |
 +---------------------------+--------------------------------------------------+
 | ptep_test_and_clear_young | Clears young from a PTE                          |
 +---------------------------+--------------------------------------------------+
--- a/include/linux/pgtable.h~mm-ptep_clear-page-table-helper
+++ a/include/linux/pgtable.h
@@ -258,6 +258,14 @@ static inline int pmdp_clear_flush_young
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
+#ifndef __HAVE_ARCH_PTEP_CLEAR
+static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep)
+{
+	pte_clear(mm, addr, ptep);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
--- a/mm/debug_vm_pgtable.c~mm-ptep_clear-page-table-helper
+++ a/mm/debug_vm_pgtable.c
@@ -652,7 +652,7 @@ static void __init pte_clear_tests(struc
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
 	flush_dcache_page(page);
 	barrier();
-	pte_clear(args->mm, args->vaddr, args->ptep);
+	ptep_clear(args->mm, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
 	WARN_ON(!pte_none(pte));
 }
--- a/mm/khugepaged.c~mm-ptep_clear-page-table-helper
+++ a/mm/khugepaged.c
@@ -756,11 +756,7 @@ static void __collapse_huge_page_copy(pt
 				 * ptl mostly unnecessary.
 				 */
 				spin_lock(ptl);
-				/*
-				 * paravirt calls inside pte_clear here are
-				 * superfluous.
-				 */
-				pte_clear(vma->vm_mm, address, _pte);
+				ptep_clear(vma->vm_mm, address, _pte);
 				spin_unlock(ptl);
 			}
 		} else {
@@ -774,11 +770,7 @@ static void __collapse_huge_page_copy(pt
 			 * inside page_remove_rmap().
 			 */
 			spin_lock(ptl);
-			/*
-			 * paravirt calls inside pte_clear here are
-			 * superfluous.
-			 */
-			pte_clear(vma->vm_mm, address, _pte);
+			ptep_clear(vma->vm_mm, address, _pte);
 			page_remove_rmap(src_page, false);
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-change-page-type-prior-to-adding-page-table-entry.patch
mm-ptep_clear-page-table-helper.patch
mm-page-table-check.patch
x86-mm-add-x86_64-support-for-page-table-check.patch

