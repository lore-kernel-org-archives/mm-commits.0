Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8DCC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiANWGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiANWGh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:06:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DDFC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:06:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDEC1B8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD29FC36AEC;
        Fri, 14 Jan 2022 22:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197994;
        bh=yFxuP4qqe798e6LZgS0TqBwAyKW6JB39G52ANX9xKRg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AToy7468ngIjzcsdQAuHeYRO+nFhqo+pMG0aa0FOj3vOhYvhozpSOgUqp5UoVnNJr
         HLifuNPz9yCCchXoNOrbTKC8U1WRdyaSVphFs1C6xDhXzv/Imaf8fCdc2wi/tgFnyz
         26Cscga4oRYHUUlYEBS+9treN4hSaL70UBF6gMwk=
Date:   Fri, 14 Jan 2022 14:06:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        corbet@lwn.net, dave.hansen@linux.intel.com, frederic@kernel.org,
        gthelen@google.com, hpa@zytor.com, hughd@google.com,
        jirislaby@kernel.org, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, peterz@infradead.org, pjt@google.com,
        rientjes@google.com, rppt@kernel.org, samitolvanen@google.com,
        songmuchun@bytedance.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, weixugc@google.com, will@kernel.org
Subject:  [patch 066/146] mm: ptep_clear() page table helper
Message-ID: <20220114220633.tueCIXFno%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
