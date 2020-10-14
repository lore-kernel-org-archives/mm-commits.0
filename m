Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FD2C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDA8922248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709196;
	bh=bwlSwXoZ2N+kAJFjb6z4THvTQ3PWNsQKmqPVuAPNHBs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cw0s1xPCLoihjH6/dFBAaQoFt48LdrkTEUsg4lZRz+LEQw81b2yeKy2f4vM7rsIed
	 H85bytCOXvrhVm957P9EifK9kM2Iw2TmaUbBsMN+4imtYf92spm1750/vODKnmE/kM
	 Wu5c5ilc1J0VHjrXh/KwhDn2Ihq+6dX2wgIz3ggk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgJNU74 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNU74 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6C302068E;
        Wed, 14 Oct 2020 20:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709195;
        bh=bwlSwXoZ2N+kAJFjb6z4THvTQ3PWNsQKmqPVuAPNHBs=;
        h=Date:From:To:Subject:From;
        b=iLXdEoHDiMHCbRyHMroAJDwnhU7tRDZlZTXi6d8beqfFmfU/90AxzXiZ3LtnJmKl0
         FYxAfMJpmHoW+7HpeGs8dX3nBbPszsEKXQOiaOFHV4/Rmh7zqn3/008Qh+Qwx9bmHJ
         TXl8TBAiVYlxnFAfbHU1sUixqlo0veB6BSYem/jY=
Date:   Wed, 14 Oct 2020 13:59:55 -0700
From:   akpm@linux-foundation.org
To:     darrick.wong@oracle.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-fix-potential-memory-leak-in-sys_swapon.patch
 removed from -mm tree
Message-ID: <20201014205955.bKcstxpJM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: fix potential memory leak in sys_swapon
has been removed from the -mm tree.  Its filename was
     mm-fix-potential-memory-leak-in-sys_swapon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile.c: fix potential memory leak in sys_swapon

If we failed to drain inode, we would forget to free the swap address
space allocated by init_swap_address_space() above.

Link: https://lkml.kernel.org/r/20200930101803.53884-1-linmiaohe@huawei.com
Fixes: dc617f29dbe5 ("vfs: don't allow writes to swap files")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-fix-potential-memory-leak-in-sys_swapon
+++ a/mm/swapfile.c
@@ -3342,7 +3342,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto bad_swap_unlock_inode;
+		goto free_swap_address_space;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3367,6 +3367,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = 0;
 	goto out;
+free_swap_address_space:
+	exit_swap_address_space(p->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

