Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0999ECAAD3
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIKX26 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIKX2z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:28:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6AD255B4
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35407B80BFE
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F6BC43470;
        Sun, 11 Sep 2022 23:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938930;
        bh=qWjCz78fZzjUcKTKhFxS+M6pqT8B0KDOJ7blSMGzQg4=;
        h=Date:To:From:Subject:From;
        b=PLezzdAYoWbDm5D08kGdDOAKIR3hSb1oYMICXHonHW58v5sjprfuksrf22mmODueV
         sx1aD70jVR13k0x9TiUdlnSH2uAucXG1d4+ftvxpO59HdclhmMwrJPgYAjA1ZAfPoq
         m7jcejDstixL3aQzJe1DAJhmtk6d7jq+DEsnxmZA=
Date:   Sun, 11 Sep 2022 16:28:50 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, kaleshsingh@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] procfs-add-path-to-proc-pid-fdinfo-fix.patch removed from -mm tree
Message-Id: <20220911232850.C3F6BC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: procfs-add-path-to-proc-pid-fdinfo-fix
has been removed from the -mm tree.  Its filename was
     procfs-add-path-to-proc-pid-fdinfo-fix.patch

This patch was dropped because it was folded into procfs-add-size-to-proc-pid-fdinfo.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-add-path-to-proc-pid-fdinfo-fix
Date: Wed Aug 17 10:04:52 AM PDT 2022

warning: Local variable 'anon_aops' shadows outer variable

Reported-by: kernel test robot <lkp@intel.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/libfs.c~procfs-add-path-to-proc-pid-fdinfo-fix
+++ a/fs/libfs.c
@@ -1228,7 +1228,7 @@ bool is_anon_inode(struct inode *inode)
 
 struct inode *alloc_anon_inode(struct super_block *s)
 {
-	static const struct address_space_operations anon_aops = {
+	static const struct address_space_operations aops = {
 		.dirty_folio	= noop_dirty_folio,
 	};
 	struct inode *inode = new_inode_pseudo(s);
@@ -1237,7 +1237,7 @@ struct inode *alloc_anon_inode(struct su
 		return ERR_PTR(-ENOMEM);
 
 	inode->i_ino = get_next_ino();
-	inode->i_mapping->a_ops = &anon_aops;
+	inode->i_mapping->a_ops = &aops;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-add-size-to-proc-pid-fdinfo.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch
fs-uninline-inode_maybe_inc_iversion.patch

