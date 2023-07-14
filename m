Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F8CEB64DC
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 18:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbjGNSKi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 14:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbjGNSKh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 14:10:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6503C22
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 11:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44AA961BFB
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 18:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A759C433C7;
        Fri, 14 Jul 2023 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689358188;
        bh=+G8gi2VT9ezl5EK8rT2hVpIdaAa+mSdBFmidyi5+8GU=;
        h=Date:To:From:Subject:From;
        b=PHHdQZlQCgOzmHXgK57yD7cISTGcn+6Y0kMRqjcmgtnCF0z+9txdgqk3fGVfqMYR3
         Aef9uCG4Wpuwj2y/cFXXD6ZSatyS7x3esm+81vqC2ZmGASEFO1ZKRk7LsiHp4VWiRb
         bYif1jzSAieSOsnH3Yt5j3QMTTYbYmz5CBjVoy2A=
Date:   Fri, 14 Jul 2023 11:09:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        anshuman.khandual@arm.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-rename-hwp_walk-to-hwpoison_walk.patch added to mm-unstable branch
Message-Id: <20230714180948.9A759C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: rename hwp_walk* to hwpoison_walk*
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-rename-hwp_walk-to-hwpoison_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-rename-hwp_walk-to-hwpoison_walk.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/hwpoison: rename hwp_walk* to hwpoison_walk*
Date: Thu, 13 Jul 2023 23:55:53 +0000

In the discussion of "Improve hugetlbfs read on HWPOISON hugepages" [1],
Matthew Wilcox suggests hwp is a bad abbreviation of hwpoison, as hwp is
already used as "an acronym by acpi, intel_pstate, some clock drivers, an
ethernet driver, and a scsi driver"[1].

So rename hwp_walk and hwp_walk_ops to hwpoison_walk and
hwpoison_walk_ops respectively.

raw_hwp_(page|list), *_raw_hwp, and raw_hwp_unreliable flag are other
major appearances of "hwp".  However, given the "raw" hint in the name, it
is easy to differentiate them from other "hwp" acronyms.  Since renaming
them is not as straightforward as renaming hwp_walk*, they are not covered
by this commit.

[1] https://lore.kernel.org/lkml/20230707201904.953262-5-jiaqiyan@google.com/T/#me6fecb8ce1ad4d5769199c9e162a44bc88f7bdec

Link: https://lkml.kernel.org/r/20230713235553.4121855-1-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-rename-hwp_walk-to-hwpoison_walk
+++ a/mm/memory-failure.c
@@ -717,7 +717,7 @@ static void collect_procs(struct page *p
 		collect_procs_file(page, tokill, force_early);
 }
 
-struct hwp_walk {
+struct hwpoison_walk {
 	struct to_kill tk;
 	unsigned long pfn;
 	int flags;
@@ -752,7 +752,7 @@ static int check_hwpoisoned_entry(pte_t
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static int check_hwpoisoned_pmd_entry(pmd_t *pmdp, unsigned long addr,
-				      struct hwp_walk *hwp)
+				      struct hwpoison_walk *hwp)
 {
 	pmd_t pmd = *pmdp;
 	unsigned long pfn;
@@ -770,7 +770,7 @@ static int check_hwpoisoned_pmd_entry(pm
 }
 #else
 static int check_hwpoisoned_pmd_entry(pmd_t *pmdp, unsigned long addr,
-				      struct hwp_walk *hwp)
+				      struct hwpoison_walk *hwp)
 {
 	return 0;
 }
@@ -779,7 +779,7 @@ static int check_hwpoisoned_pmd_entry(pm
 static int hwpoison_pte_range(pmd_t *pmdp, unsigned long addr,
 			      unsigned long end, struct mm_walk *walk)
 {
-	struct hwp_walk *hwp = walk->private;
+	struct hwpoison_walk *hwp = walk->private;
 	int ret = 0;
 	pte_t *ptep, *mapped_pte;
 	spinlock_t *ptl;
@@ -813,7 +813,7 @@ static int hwpoison_hugetlb_range(pte_t
 			    unsigned long addr, unsigned long end,
 			    struct mm_walk *walk)
 {
-	struct hwp_walk *hwp = walk->private;
+	struct hwpoison_walk *hwp = walk->private;
 	pte_t pte = huge_ptep_get(ptep);
 	struct hstate *h = hstate_vma(walk->vma);
 
@@ -824,7 +824,7 @@ static int hwpoison_hugetlb_range(pte_t
 #define hwpoison_hugetlb_range	NULL
 #endif
 
-static const struct mm_walk_ops hwp_walk_ops = {
+static const struct mm_walk_ops hwpoison_walk_ops = {
 	.pmd_entry = hwpoison_pte_range,
 	.hugetlb_entry = hwpoison_hugetlb_range,
 };
@@ -846,7 +846,7 @@ static int kill_accessing_process(struct
 				  int flags)
 {
 	int ret;
-	struct hwp_walk priv = {
+	struct hwpoison_walk priv = {
 		.pfn = pfn,
 	};
 	priv.tk.tsk = p;
@@ -855,7 +855,7 @@ static int kill_accessing_process(struct
 		return -EFAULT;
 
 	mmap_read_lock(p->mm);
-	ret = walk_page_range(p->mm, 0, TASK_SIZE, &hwp_walk_ops,
+	ret = walk_page_range(p->mm, 0, TASK_SIZE, &hwpoison_walk_ops,
 			      (void *)&priv);
 	if (ret == 1 && priv.tk.addr)
 		kill_proc(&priv.tk, pfn, flags);
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-hwpoison-delete-all-entries-before-traversal-in-__folio_free_raw_hwp.patch
mm-hwpoison-check-if-a-raw-page-in-a-hugetlb-folio-is-raw-hwpoison.patch
hugetlbfs-improve-read-hwpoison-hugepage.patch
selftests-mm-add-tests-for-hwpoison-hugetlbfs-read.patch
mm-hwpoison-rename-hwp_walk-to-hwpoison_walk.patch

