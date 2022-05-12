Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95F6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 22:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359204AbiELWiX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 18:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359235AbiELWiW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 18:38:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12D8261943
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 15:38:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D0AA61F5E
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 22:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BD2C385B8;
        Thu, 12 May 2022 22:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652395100;
        bh=N5frJrVh0stbdgpOVlMjPdFnMTVQoFkCvv4HvvrvqOA=;
        h=Date:To:From:Subject:From;
        b=erA4c+mX378zYva6Mk5A9mFK4sFs6tM+Levac2ji6xfeQMdkHskzIAgUCP3avhxsR
         09eiYJODdInkGhDHtt/6oFyfPFOP4nRslmxSxXHO02ed9oMmBUhAOLrBEa865ejU4o
         nA2gtUqsod0+gIeC4GEQ5WcsDjgg8dYFJ93CAYt0=
Date:   Thu, 12 May 2022 15:38:20 -0700
To:     mm-commits@vger.kernel.org, zhang.yunkai@zte.com.cn,
        yang.yang29@zte.com.cn, xu.xin16@zte.com.cn, willy@infradead.org,
        wang.yong12@zte.com.cn, ran.xiaokai@zte.com.cn,
        ammarfaizi2@gnuweeb.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-ksm-introduce-ksm_force-for-each-process-fix.patch removed from -mm tree
Message-Id: <20220512223820.D5BD2C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-ksm-introduce-ksm_force-for-each-process-fix
has been removed from the -mm tree.  Its filename was
     mm-ksm-introduce-ksm_force-for-each-process-fix.patch

This patch was dropped because it was folded into mm-ksm-introduce-ksm_force-for-each-process.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ksm-introduce-ksm_force-for-each-process-fix

rename ksm_vma_check() to vma_scannable()

Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: wangyong <wang.yong12@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-introduce-ksm_force-for-each-process-fix
+++ a/mm/ksm.c
@@ -335,7 +335,7 @@ static void __init ksm_slab_free(void)
 }
 
 /* Check if vma is qualified for ksmd scanning */
-static bool ksm_vma_check(struct vm_area_struct *vma)
+static bool vma_scannable(struct vm_area_struct *vma)
 {
 	unsigned long vm_flags = vma->vm_flags;
 
@@ -551,7 +551,7 @@ static struct vm_area_struct *find_merge
 	if (ksm_test_exit(mm))
 		return NULL;
 	vma = vma_lookup(mm, addr);
-	if (!vma || !ksm_vma_check(vma) || !vma->anon_vma)
+	if (!vma || !vma_scannable(vma) || !vma->anon_vma)
 		return NULL;
 	return vma;
 }
@@ -2328,7 +2328,7 @@ next_mm:
 		goto no_vmas;
 
 	for_each_vma(vmi, vma) {
-		if (!ksm_vma_check(vma))
+		if (!vma_scannable(vma))
 			continue;
 		if (ksm_scan.address < vma->vm_start)
 			ksm_scan.address = vma->vm_start;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-ksm-introduce-ksm_force-for-each-process.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

