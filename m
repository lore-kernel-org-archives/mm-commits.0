Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A6BC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 01:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbiA0Bwi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 20:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbiA0Bwg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 20:52:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC45C061747
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 17:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5879461C11
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 01:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376FFC340E7;
        Thu, 27 Jan 2022 01:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643248354;
        bh=8c/NCEpU1cQ0ORhDzJZKKXdCaFY0eAhIQ5bApyWxbjg=;
        h=Date:From:To:Subject:From;
        b=h4TARSPNpm4eCnh0BbtxC1s9dQn4nkqPwhsSnzwEyTL1puedJUMYsUcZocR+oxAY4
         duB3WI2XjUMgmTjQne7+h10gz7PO4ukerGgXBrHLZffAgHf6sTj/puNhI8N2ysdayp
         n8t5rK0pCfjW20XMDjGgkDMy1O4Cyjhe8movcZa0=
Date:   Wed, 26 Jan 2022 17:52:33 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        dave.hansen@linux.intel.com, gthelen@google.com, hpa@zytor.com,
        hughd@google.com, jirislaby@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        pjt@google.com, rientjes@google.com, rppt@kernel.org,
        songmuchun@bytedance.com, weixugc@google.com, will@kernel.org,
        ziy@nvidia.com
Subject:  + mm-page_table_check-check-entries-at-pmd-levels.patch
 added to -mm tree
Message-ID: <20220127015233.agxKoBWv6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: check entries at pmd levels
has been added to the -mm tree.  Its filename is
     mm-page_table_check-check-entries-at-pmd-levels.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_table_check-check-entries-at-pmd-levels.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_table_check-check-entries-at-pmd-levels.patch

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
Subject: mm/page_table_check: check entries at pmd levels

syzbot detected a case where the page table counters were not properly
updated.

syzkaller login:  ------------[ cut here ]------------
kernel BUG at mm/page_table_check.c:162!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3099 Comm: pasha Not tainted 5.16.0+ #48
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO4
RIP: 0010:__page_table_check_zero+0x159/0x1a0
Code: 7d 3a b2 ff 45 39 f5 74 2a e8 43 38 b2 ff 4d 85 e4 01
RSP: 0018:ffff888010667418 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000
RDX: ffff88800cea8680 RSI: ffffffff81becaf9 RDI: 0000000003
RBP: ffff888010667450 R08: 0000000000000001 R09: 0000000000
R10: ffffffff81becaab R11: 0000000000000001 R12: ffff888008
R13: 0000000000000001 R14: 0000000000000200 R15: dffffc0000
FS:  0000000000000000(0000) GS:ffff888035e00000(0000) knlG0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd875cad00 CR3: 00000000094ce000 CR4: 0000000000
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000
Call Trace:
 <TASK>
 free_pcp_prepare+0x3be/0xaa0
 free_unref_page+0x1c/0x650
 ? trace_hardirqs_on+0x6a/0x1d0
 free_compound_page+0xec/0x130
 free_transhuge_page+0x1be/0x260
 __put_compound_page+0x90/0xd0
 release_pages+0x54c/0x1060
 ? filemap_remove_folio+0x161/0x210
 ? lock_downgrade+0x720/0x720
 ? __put_page+0x150/0x150
 ? filemap_free_folio+0x164/0x350
 __pagevec_release+0x7c/0x110
 shmem_undo_range+0x85e/0x1250
...

The repro involved having a huge page that is split due to uprobe event
temporarily replacing one of the pages in the huge page.  Later the huge
page was combined again, but the counters were off, as the PTE level was
not properly updated.

Make sure that when PMD is cleared and prior to freeing the level the PTEs
are updated.

Link: https://lkml.kernel.org/r/20220126183637.1840960-5-pasha.tatashin@soleen.com
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Paul Turner <pjt@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_table_check.h |   18 ++++++++++++++++++
 mm/khugepaged.c                  |    3 +++
 mm/page_table_check.c            |   21 +++++++++++++++++++++
 3 files changed, 42 insertions(+)

--- a/include/linux/page_table_check.h~mm-page_table_check-check-entries-at-pmd-levels
+++ a/include/linux/page_table_check.h
@@ -26,6 +26,8 @@ void __page_table_check_pmd_set(struct m
 				pmd_t *pmdp, pmd_t pmd);
 void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud);
+void __page_table_check_pmd_clear_full(struct mm_struct *mm, unsigned long addr,
+				       pmd_t pmd);
 
 static inline void page_table_check_alloc(struct page *page, unsigned int order)
 {
@@ -100,6 +102,16 @@ static inline void page_table_check_pud_
 	__page_table_check_pud_set(mm, addr, pudp, pud);
 }
 
+static inline void page_table_check_pmd_clear_full(struct mm_struct *mm,
+						   unsigned long addr,
+						   pmd_t pmd)
+{
+	if (static_branch_likely(&page_table_check_disabled))
+		return;
+
+	__page_table_check_pmd_clear_full(mm, addr, pmd);
+}
+
 #else
 
 static inline void page_table_check_alloc(struct page *page, unsigned int order)
@@ -143,5 +155,11 @@ static inline void page_table_check_pud_
 {
 }
 
+static inline void page_table_check_pmd_clear_full(struct mm_struct *mm,
+						   unsigned long addr,
+						   pmd_t pmd)
+{
+}
+
 #endif /* CONFIG_PAGE_TABLE_CHECK */
 #endif /* __LINUX_PAGE_TABLE_CHECK_H */
--- a/mm/khugepaged.c~mm-page_table_check-check-entries-at-pmd-levels
+++ a/mm/khugepaged.c
@@ -16,6 +16,7 @@
 #include <linux/hashtable.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/page_idle.h>
+#include <linux/page_table_check.h>
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
 
@@ -1422,10 +1423,12 @@ static void collapse_and_free_pmd(struct
 	spinlock_t *ptl;
 	pmd_t pmd;
 
+	mmap_assert_write_locked(mm);
 	ptl = pmd_lock(vma->vm_mm, pmdp);
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
 	spin_unlock(ptl);
 	mm_dec_nr_ptes(mm);
+	page_table_check_pmd_clear_full(mm, addr, pmd);
 	pte_free(mm, pmd_pgtable(pmd));
 }
 
--- a/mm/page_table_check.c~mm-page_table_check-check-entries-at-pmd-levels
+++ a/mm/page_table_check.c
@@ -247,3 +247,24 @@ void __page_table_check_pud_set(struct m
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pud_set);
+
+void __page_table_check_pmd_clear_full(struct mm_struct *mm, unsigned long addr,
+				       pmd_t pmd)
+{
+	if (&init_mm == mm)
+		return;
+
+	if (!pmd_bad(pmd) && !pmd_leaf(pmd)) {
+		pte_t *ptep = pte_offset_map(&pmd, addr);
+		unsigned long i;
+
+		pte_unmap(ptep);
+		for (i = 0; i < PTRS_PER_PTE; i++) {
+			__page_table_check_pte_clear(mm, addr, *ptep);
+			addr += PAGE_SIZE;
+			ptep++;
+		}
+	} else {
+		__page_table_check_pmd_clear(mm, addr, pmd);
+	}
+}
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table.patch
mm-page_table_check-use-unsigned-long-for-page-counters-and-cleanup.patch
mm-khugepaged-unify-collapse-pmd-clear-flush-and-free.patch
mm-page_table_check-check-entries-at-pmd-levels.patch

