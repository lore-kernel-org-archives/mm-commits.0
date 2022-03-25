Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400CDC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 19:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiCYTcj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiCYTcc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 15:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738992D812D
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 12:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E154161C32
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 18:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468A2C004DD;
        Fri, 25 Mar 2022 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648234685;
        bh=PrWAjbfLIa8hEazQ6hVi/Hs2wSKjjBxMZmduc41k7/g=;
        h=Date:To:From:Subject:From;
        b=WqfayVNGxOs1nlOT6crXxKN0GS4gnmvHyh3EmhE56Q6SZ+7QyleuHXcZvk/995El/
         oLvmmat455S28w2ad354dL1rkyfXtG+geqlDhqlXSPdu6592HYy8F3QHQubpGmyHCZ
         oJfZklvYzXVUyOCVIZhr/pe5cWL88Jgzs3gr22f0=
Date:   Fri, 25 Mar 2022 11:58:04 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, xu.xin16@zte.com.cn, willy@infradead.org,
        vbabka@suse.cz, stephen.s.brennan@oracle.com, sfr@canb.auug.org.au,
        ran.xiaokai@zte.com.cn, ohoono.kwon@samsung.com, lkp@intel.com,
        keescook@chromium.org, feng.tang@intel.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-count-ksm-merging-pages-for-each-process-fix.patch added to -mm tree
Message-Id: <20220325185805.468A2C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-count-ksm-merging-pages-for-each-process-fix
has been added to the -mm tree.  Its filename is
     ksm-count-ksm-merging-pages-for-each-process-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ksm-count-ksm-merging-pages-for-each-process-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ksm-count-ksm-merging-pages-for-each-process-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ksm-count-ksm-merging-pages-for-each-process-fix

fix comment typo, remove BUG_ON()s

Cc: kernel test robot <lkp@intel.com>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ohhoon Kwon <ohoono.kwon@samsung.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 mm/ksm.c                 |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/mm_types.h~ksm-count-ksm-merging-pages-for-each-process-fix
+++ a/include/linux/mm_types.h
@@ -658,8 +658,8 @@ struct mm_struct {
 
 #ifdef CONFIG_KSM
 		/*
-		 * Represet how many pages of this process are
-		 * involved in KSM merging.
+		 * Represent how many pages of this process are involved in KSM
+		 * merging.
 		 */
 		unsigned long ksm_merging_pages;
 #endif
--- a/mm/ksm.c~ksm-count-ksm-merging-pages-for-each-process-fix
+++ a/mm/ksm.c
@@ -639,7 +639,6 @@ static void remove_node_from_stable_tree
 		else
 			ksm_pages_shared--;
 
-		BUG_ON(rmap_item->mm == NULL);
 		rmap_item->mm->ksm_merging_pages--;
 
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
@@ -790,7 +789,6 @@ static void remove_rmap_item_from_tree(s
 		else
 			ksm_pages_shared--;
 
-		BUG_ON(rmap_item->mm == NULL);
 		rmap_item->mm->ksm_merging_pages--;
 
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
@@ -2016,7 +2014,6 @@ static void stable_tree_append(struct rm
 	else
 		ksm_pages_shared++;
 
-	BUG_ON(rmap_item->mm == NULL);
 	rmap_item->mm->ksm_merging_pages++;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

