Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34014C47420
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037612076B
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601502923;
	bh=SAGbDCwBaI7zW0lPV+gox0v1bkArr7HnK3WKOz7OUBY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cE1fuW5nsorsdk2/VsABAb8v1Me1aisr40VylPOUnLYSKw7TUg6i/sF77IR41x46i
	 oGPTXzBT5VoV2t0DBxg48r2ulzGZgfyv42euqmHAx4v1RbaUkLlVhlm875A+Hafjp8
	 +x4q5MyQ0p2cUc4u6nliJTj+o0Kcsp/aeKGL9968=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgI3VzW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731212AbgI3VzS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 17:55:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A297620848;
        Wed, 30 Sep 2020 21:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601502917;
        bh=SAGbDCwBaI7zW0lPV+gox0v1bkArr7HnK3WKOz7OUBY=;
        h=Date:From:To:Subject:From;
        b=Cm809tXk6GNukYDTnaM9Xjl0mcqWgENmYI1Nb/y3YQMLUOfoCbnp1IfjYYrVeAkg+
         nzdfYY4QnHdGwbTB8otwo20tzC+LvQOgdAZkZ89zkZqeg8zfuF+X7vkkIPsMIk4BwJ
         Apw8VPdjOYdrGOYnoQoqPrdM31WH0IeZSP+bzl2k=
Date:   Wed, 30 Sep 2020 14:55:17 -0700
From:   akpm@linux-foundation.org
To:     darrick.wong@oracle.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  + mm-fix-potential-memory-leak-in-sys_swapon.patch added
 to -mm tree
Message-ID: <20200930215517.LYYnFStCv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: fix potential memory leak in sys_swapon
has been added to the -mm tree.  Its filename is
     mm-fix-potential-memory-leak-in-sys_swapon.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-potential-memory-leak-in-sys_swapon.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-potential-memory-leak-in-sys_swapon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3338,7 +3338,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto bad_swap_unlock_inode;
+		goto free_swap_address_space;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3363,6 +3363,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = 0;
 	goto out;
+free_swap_address_space:
+	exit_swap_address_space(p->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
mm-remove-useless-out-label-in-__swap_writepage.patch
mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch
mm-remove-unnecessary-goto-out-in-_swap_info_get.patch
mm-fix-potential-memory-leak-in-sys_swapon.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
mm-mempool-add-else-to-split-mutually-exclusive-case.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

