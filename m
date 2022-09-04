Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8A6ECAAD3
	for <mm-commits@archiver.kernel.org>; Sun,  4 Sep 2022 18:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiIDSi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 4 Sep 2022 14:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiIDSi6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 4 Sep 2022 14:38:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AA530575
        for <mm-commits@vger.kernel.org>; Sun,  4 Sep 2022 11:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE559B80D5A
        for <mm-commits@vger.kernel.org>; Sun,  4 Sep 2022 18:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7432CC433C1;
        Sun,  4 Sep 2022 18:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662316734;
        bh=UlK2BXeKLTQT1X2LNB1iEgBSsO5Gzzgs1y0xEQ6pv0M=;
        h=Date:To:From:Subject:From;
        b=qRbFFZFfpQe8LA8eSSggrPhDCWSgpugsRUok7xGr9Gf2zNZM8NJQR2ek4jwN9+42b
         q0ep2jy2mAdx4TdD0kmXE8nb90t1wnhCRjZtE7d8GdleTJVlYcVIaHz41h0pbvbgMr
         3MQ2H2LZAPa7Sy3QYfl3DbprweRFiXOcb0TxBI1k=
Date:   Sun, 04 Sep 2022 11:38:53 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-add-struct-collapse_control-fix-fix-fix.patch added to mm-unstable branch
Message-Id: <20220904183854.7432CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: fix struct collapse_control load_node definition
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-add-struct-collapse_control-fix-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-add-struct-collapse_control-fix-fix-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/khugepaged: fix struct collapse_control load_node definition
Date: Fri, 2 Sep 2022 19:12:21 -0700

HPAGE_PMD_ORDER is used to determine a minimal amount of bits needed to
store per-node counters in struct collapse_control, defining the array to
be either a u16[HPAGE_PMD_ORDER] or u32[HPAGE_PMD_ORDER].

For some architectures/configs, HPAGE_PMD_ORDER isn't resolved at
preprocessor time (suitable for resolving preprocessor directives) but
rather expands into a compiler built-in that is resolved at compile-time. 
E.g.  for 32-bit MIPS (see link for full config):

---8<--
>> arch/mips/include/asm/pgtable.h:238:26: warning: "__builtin_ffs" is not defined, evaluates to 0 [-Wundef]
     238 | #define PTE_T_LOG2      (__builtin_ffs(sizeof(pte_t)) - 1)
         |                          ^~~~~~~~~~~~~
   arch/mips/include/asm/pgtable-32.h:65:43: note: in expansion of macro 'PTE_T_LOG2'
      65 | # define PGDIR_SHIFT    (2 * PAGE_SHIFT - PTE_T_LOG2 - 1)
         |                                           ^~~~~~~~~~
   include/asm-generic/pgtable-nop4d.h:11:33: note: in expansion of macro 'PGDIR_SHIFT'
      11 | #define P4D_SHIFT               PGDIR_SHIFT
         |                                 ^~~~~~~~~~~
   include/asm-generic/pgtable-nopud.h:18:25: note: in expansion of macro 'P4D_SHIFT'
      18 | #define PUD_SHIFT       P4D_SHIFT
         |                         ^~~~~~~~~
   include/asm-generic/pgtable-nopmd.h:20:25: note: in expansion of macro 'PUD_SHIFT'
      20 | #define PMD_SHIFT       PUD_SHIFT
         |                         ^~~~~~~~~
   include/linux/huge_mm.h:109:25: note: in expansion of macro 'PMD_SHIFT'
     109 | #define HPAGE_PMD_SHIFT PMD_SHIFT
         |                         ^~~~~~~~~
   include/linux/huge_mm.h:105:26: note: in expansion of macro 'HPAGE_PMD_SHIFT'
     105 | #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
         |                          ^~~~~~~~~~~~~~~
   mm/khugepaged.c:90:5: note: in expansion of macro 'HPAGE_PMD_ORDER'
      90 | #if HPAGE_PMD_ORDER < 16
         |     ^~~~~~~~~~~~~~~
>> arch/mips/include/asm/pgtable.h:238:39: error: missing binary operator before token "("
     238 | #define PTE_T_LOG2      (__builtin_ffs(sizeof(pte_t)) - 1)
         |                                       ^
   arch/mips/include/asm/pgtable-32.h:65:43: note: in expansion of macro 'PTE_T_LOG2'
      65 | # define PGDIR_SHIFT    (2 * PAGE_SHIFT - PTE_T_LOG2 - 1)
         |                                           ^~~~~~~~~~
   include/asm-generic/pgtable-nop4d.h:11:33: note: in expansion of macro 'PGDIR_SHIFT'
      11 | #define P4D_SHIFT               PGDIR_SHIFT
         |                                 ^~~~~~~~~~~
   include/asm-generic/pgtable-nopud.h:18:25: note: in expansion of macro 'P4D_SHIFT'
      18 | #define PUD_SHIFT       P4D_SHIFT
         |                         ^~~~~~~~~
   include/asm-generic/pgtable-nopmd.h:20:25: note: in expansion of macro 'PUD_SHIFT'
      20 | #define PMD_SHIFT       PUD_SHIFT
         |                         ^~~~~~~~~
   include/linux/huge_mm.h:109:25: note: in expansion of macro 'PMD_SHIFT'
     109 | #define HPAGE_PMD_SHIFT PMD_SHIFT
         |                         ^~~~~~~~~
   include/linux/huge_mm.h:105:26: note: in expansion of macro 'HPAGE_PMD_SHIFT'
     105 | #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
         |                          ^~~~~~~~~~~~~~~
   mm/khugepaged.c:90:5: note: in expansion of macro 'HPAGE_PMD_ORDER'
      90 | #if HPAGE_PMD_ORDER < 16
         |     ^~~~~~~~~~~~~~~
---8<--

load_node is already special-cased for CONFIG_PPC64 in
"mm-khugepaged-add-struct-collapse_control-fix-fix", and we could continue
down that path by #define'ing away edge cases, but I think at this point
it easier to just let load_node be an array of u32s.  If it's ever an
issue, we can revisit.

This essentially rolls back both:

"mm/khugepaged: use minimal bits to store num page < HPAGE_PMD_NR"
"mm-khugepaged-add-struct-collapse_control-fix-fix"

(though we'll leave it as a u32 vs an int).

Link: https://lore.kernel.org/linux-mm/202209021349.F73i5d6X-lkp@intel.com/
Link: https://lkml.kernel.org/r/20220903021221.1130021-1-zokeefe@google.com
Fixes: 5f7bb00bd9cd ("mm/khugepaged: use minimal bits to store num page < HPAGE_PMD_NR")
Fixes: 03053c821af2 ("mm-khugepaged-add-struct-collapse_control-fix-fix")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-struct-collapse_control-fix-fix-fix
+++ a/mm/khugepaged.c
@@ -87,13 +87,8 @@ static struct kmem_cache *mm_slot_cache
 
 struct collapse_control {
 	/* Num pages scanned per node */
-#if defined(CONFIG_PPC64)
 	u32 node_load[MAX_NUMNODES];
-#elif HPAGE_PMD_ORDER < 16
-	u16 node_load[MAX_NUMNODES];
-#else
-	u32 node_load[MAX_NUMNODES];
-#endif
+
 	/* Last target selected in khugepaged_find_target_node() */
 	int last_target_node;
 };
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-add-struct-collapse_control-fix.patch
mm-khugepaged-add-struct-collapse_control-fix-fix-fix.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-3.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
mm-madvise-add-madv_collapse-to-process_madvise-fix.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

