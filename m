Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241E5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 22:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiEMWep (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 18:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiEMWeo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 18:34:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED33413F28
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 15:34:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FEFD6111B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 22:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8369C34100;
        Fri, 13 May 2022 22:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652481281;
        bh=fbjPNX3F4ZR1M2pu1XMiXEio0XLEC9A+EONpZKC6iw0=;
        h=Date:To:From:Subject:From;
        b=fBPQlpSgSxd1pRkN0C1/l5xoXPa1hkrM8nDAI7ZFlZ0txGRi+q7AhyHu+fYPc6p/m
         LZA31c16vjXKvoBPrN8bUDbhMZWvM/n6kveCiSwBLWYKX2aTgbXXalNSgoUi4M2YfX
         ikxY6PyoLPJBxFBqwWy8DnblMJtqvk9gbzdqYvtk=
Date:   Fri, 13 May 2022 15:34:41 -0700
To:     mm-commits@vger.kernel.org, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch removed from -mm tree
Message-Id: <20220513223441.C8369C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch

This patch was dropped because it was folded into mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix

fix nommu build

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/hugetlb.h~mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix
+++ a/include/linux/hugetlb.h
@@ -1094,6 +1094,7 @@ static inline void set_huge_swap_pte_at(
 {
 }
 
+#ifdef CONFIG_MMU
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
@@ -1104,6 +1105,7 @@ static inline void set_huge_pte_at(struc
 				   pte_t *ptep, pte_t pte)
 {
 }
+#endif
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

