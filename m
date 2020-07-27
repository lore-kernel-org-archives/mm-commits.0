Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA55C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 18:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FC0F2070B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 18:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595873748;
	bh=MWaFu39Xgu4QuUxSD7qzsUPxkiIDcYR4WoyIkUuIvnI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CKN+LrL7mJhzrbMbsRA6dkx7m6eYqbSxzAHjUKSaDyvl8M3aVtTWP6RMjnMulRng5
	 SiAsW0Y79mu3RhtZP8nEtM72VjgCKitwmmlCR0GpyZSEgxd/28EccUw3xOXNrOJK2w
	 nv34RFkeKy0jxTdCrzXMtmfaqBxB6V4fmwPcD3YM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgG0SPr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 14:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgG0SPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 14:15:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E376B2070B;
        Mon, 27 Jul 2020 18:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595873747;
        bh=MWaFu39Xgu4QuUxSD7qzsUPxkiIDcYR4WoyIkUuIvnI=;
        h=Date:From:To:Subject:From;
        b=x7Yd+3rvLCWyJ2Qw1S9KW5qs7zEyw6VIDk0ypEK+WF/4wF3kJjIzrOdhXsVWbcZuH
         SLuTFfxsj/PFdC2hrA/3WxsQpyhtg+RpY75Vs27NoEbd1WD23SgNegTgrwCmomveGv
         ZzqIgARK7DYe7TPGiYT7ghyPjswtH0Z5PIpS68M0=
Date:   Mon, 27 Jul 2020 11:15:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20200727181546.jE5003SMo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
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

 fs/btrfs/inode.c |    4 ----
 fs/io_uring.c    |   30 ------------------------------
 2 files changed, 34 deletions(-)

--- a/fs/btrfs/inode.c~linux-next-git-rejects
+++ a/fs/btrfs/inode.c
@@ -8176,11 +8176,7 @@ again:
 	 *    bit of its io_tree, and free the qgroup reserved data space.
 	 *    Since the IO will never happen for this page.
 	 */
-<<<<<<< HEAD
-	btrfs_qgroup_free_data(inode, NULL, page_start, PAGE_SIZE);
-=======
 	btrfs_qgroup_free_data(BTRFS_I(inode), NULL, page_start, PAGE_SIZE);
->>>>>>> linux-next/akpm-base
 	if (!inode_evicting) {
 		clear_extent_bit(tree, page_start, page_end, EXTENT_LOCKED |
 				 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -4644,31 +4644,6 @@ static void io_async_queue_proc(struct f
 	struct async_poll *apoll = pt->req->apoll;
 
 	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
-<<<<<<< HEAD
-}
-
-static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
-{
-	struct mm_struct *mm = current->mm;
-
-	if (mm) {
-		kthread_unuse_mm(mm);
-		mmput(mm);
-	}
-}
-
-static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
-				   struct io_kiocb *req)
-{
-	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
-			return -EFAULT;
-		kthread_use_mm(ctx->sqo_mm);
-	}
-
-	return 0;
-=======
->>>>>>> linux-next/akpm-base
 }
 
 static void io_async_task_func(struct callback_head *cb)
@@ -4694,11 +4669,6 @@ static void io_async_task_func(struct ca
 	/* restore ->work in case we need to retry again */
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
-<<<<<<< HEAD
-	kfree(apoll->double_poll);
-	kfree(apoll);
-=======
->>>>>>> linux-next/akpm-base
 
 	if (!READ_ONCE(apoll->poll.canceled))
 		__io_req_task_submit(req);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

