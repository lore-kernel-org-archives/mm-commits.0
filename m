Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58966C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 02:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13926235F8
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 02:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbhAMWaR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jan 2021 17:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbhAMW3E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Jan 2021 17:29:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A365C23136;
        Wed, 13 Jan 2021 22:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610576873;
        bh=4R28s4RskL3wZRbbfTzVoE1GtGr60GuD5wEYWATQwOs=;
        h=Date:From:To:Subject:From;
        b=13tqKqe9LzME1JA9HnQzLZ40/oiYc/P0nil+hx5JtJFOxj+CN0+FhljY177tBtkSI
         mj0oIdx9l+/9mkuGlodoib3kfc8SpMXuIkBnF1UHzadcP0YtbHScRnZN+8ojXGa/it
         mx4zmkxaqe92j+pDEJVTWEpTbrJCyqxE+76Fg7ts=
Date:   Wed, 13 Jan 2021 14:27:53 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210113222753.BjFivWHEE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/space-info.c |    4 ----
 fs/io_uring.c         |    9 ---------
 2 files changed, 13 deletions(-)

--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -9011,15 +9011,6 @@ static void io_uring_del_task_file(struc
 		fput(file);
 }
 
-static void io_uring_remove_task_files(struct io_uring_task *tctx)
-{
-	struct file *file;
-	unsigned long index;
-
-	xa_for_each(&tctx->xa, index, file)
-		io_uring_del_task_file(file);
-}
-
 void __io_uring_files_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
--- a/fs/btrfs/space-info.c~linux-next-git-rejects
+++ a/fs/btrfs/space-info.c
@@ -527,11 +527,7 @@ static void shrink_delalloc(struct btrfs
 		wait_ordered = true;
 
 	loops = 0;
-<<<<<<< HEAD
-	while ((delalloc_bytes || dio_bytes) && loops < 3) {
-=======
 	while ((delalloc_bytes || ordered_bytes) && loops < 3) {
->>>>>>> linux-next/akpm-base
 		u64 nr_pages = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
 
 		btrfs_start_delalloc_roots(fs_info, nr_pages, true);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-process_vm_accessc-include-compath.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

