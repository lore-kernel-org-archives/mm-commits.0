Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F84BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 22:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiD0WHT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 18:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiD0WHQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 18:07:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696E582D39
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 15:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11A70B82B07
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 22:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7690C385AA;
        Wed, 27 Apr 2022 22:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651097041;
        bh=+ETEnZ8WfuFTRiBXcVaZGKwqmOSnwkZCEQPo0P+egj8=;
        h=Date:To:From:Subject:From;
        b=Ad6o0PidsNMl8VWCyHENLqbK77/uveY4Cde688ax40Cl1IVSqPBGmq+p3WT54p4Ho
         qKAMhUkLVWSL+2M8eczjr2bHfycGwCG0cmOZGwGfiEdu38e8JmiBnlAaTobQEtwF4m
         Dv1OK6B10fh3BPlFKIZ8GTz4BzjYo8pxGOY9eMIA=
Date:   Wed, 27 Apr 2022 15:04:01 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, xu.xin16@zte.com.cn, willy@infradead.org,
        vbabka@suse.cz, stephen.s.brennan@oracle.com, sfr@canb.auug.org.au,
        ran.xiaokai@zte.com.cn, ohoono.kwon@samsung.com, lkp@intel.com,
        keescook@chromium.org, feng.tang@intel.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ksm-count-ksm-merging-pages-for-each-process-fix.patch removed from -mm tree
Message-Id: <20220427220401.A7690C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-count-ksm-merging-pages-for-each-process-fix
has been removed from the -mm tree.  Its filename was
     ksm-count-ksm-merging-pages-for-each-process-fix.patch

This patch was dropped because it was folded into ksm-count-ksm-merging-pages-for-each-process.patch

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
@@ -657,8 +657,8 @@ struct mm_struct {
 #endif
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
@@ -2027,7 +2025,6 @@ static void stable_tree_append(struct rm
 	else
 		ksm_pages_shared++;
 
-	BUG_ON(rmap_item->mm == NULL);
 	rmap_item->mm->ksm_merging_pages++;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ksm-count-ksm-merging-pages-for-each-process.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mapletree-vs-khugepaged.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

