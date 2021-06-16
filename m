Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416C4C48BDF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 01:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A7246137D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 01:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhFPBZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 21:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231835AbhFPBZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 21:25:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F71861356;
        Wed, 16 Jun 2021 01:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806613;
        bh=5vvt6dQdqnMn/3BBdU1MAi2Tx/HWOlAus5gQOe/kOzk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=evOYMYHXYKi+i48c5dsWTJ3ni9YkSpYksM8CaCSOGOUTFO+CErKsr4FndzJNJtG+q
         94JuIs8bj5z+6Kko5Vl8T72wHRLey8yh784TS53dT7CIbilqvN060vSUGFVkzUcSNZ
         tfVrpI5FXc8PMG10wuH13CdYx0/dYb4e0uzrYwuc=
Date:   Tue, 15 Jun 2021 18:23:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jack@suse.cz, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, torvalds@linux-foundation.org, tytso@mit.edu,
        yangerkun@huawei.com, yukuai3@huawei.com
Subject:  [patch 07/18] mm/memory-failure: make sure wait for page
 writeback in memory_failure
Message-ID: <20210616012332.bPPCzBRm4%akpm@linux-foundation.org>
In-Reply-To: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>
Subject: mm/memory-failure: make sure wait for page writeback in memory_failure

Our syzkaller trigger the "BUG_ON(!list_empty(&inode->i_wb_list))" in
clear_inode:

[  292.016156] ------------[ cut here ]------------
[  292.017144] kernel BUG at fs/inode.c:519!
[  292.017860] Internal error: Oops - BUG: 0 [#1] SMP
[  292.018741] Dumping ftrace buffer:
[  292.019577]    (ftrace buffer empty)
[  292.020430] Modules linked in:
[  292.021748] Process syz-executor.0 (pid: 249, stack limit =
0x00000000a12409d7)
[  292.023719] CPU: 1 PID: 249 Comm: syz-executor.0 Not tainted 4.19.95
[  292.025206] Hardware name: linux,dummy-virt (DT)
[  292.026176] pstate: 80000005 (Nzcv daif -PAN -UAO)
[  292.027244] pc : clear_inode+0x280/0x2a8
[  292.028045] lr : clear_inode+0x280/0x2a8
[  292.028877] sp : ffff8003366c7950
[  292.029582] x29: ffff8003366c7950 x28: 0000000000000000
[  292.030570] x27: ffff80032b5f4708 x26: ffff80032b5f4678
[  292.031863] x25: ffff80036ae6b300 x24: ffff8003689254d0
[  292.032902] x23: ffff80036ae69d80 x22: 0000000000033cc8
[  292.033928] x21: 0000000000000000 x20: ffff80032b5f47a0
[  292.034941] x19: ffff80032b5f4678 x18: 0000000000000000
[  292.035958] x17: 0000000000000000 x16: 0000000000000000
[  292.037102] x15: 0000000000000000 x14: 0000000000000000
[  292.038103] x13: 0000000000000004 x12: 0000000000000000
[  292.039137] x11: 1ffff00066cd8f52 x10: 1ffff00066cd8ec8
[  292.040216] x9 : dfff200000000000 x8 : ffff10006ac1e86a
[  292.041432] x7 : dfff200000000000 x6 : ffff100066cd8f1e
[  292.042516] x5 : dfff200000000000 x4 : ffff80032b5f47a0
[  292.043525] x3 : ffff200008000000 x2 : ffff200009867000
[  292.044560] x1 : ffff8003366bb000 x0 : 0000000000000000
[  292.045569] Call trace:
[  292.046083]  clear_inode+0x280/0x2a8
[  292.046828]  ext4_clear_inode+0x38/0xe8
[  292.047593]  ext4_free_inode+0x130/0xc68
[  292.048383]  ext4_evict_inode+0xb20/0xcb8
[  292.049162]  evict+0x1a8/0x3c0
[  292.049761]  iput+0x344/0x460
[  292.050350]  do_unlinkat+0x260/0x410
[  292.051042]  __arm64_sys_unlinkat+0x6c/0xc0
[  292.051846]  el0_svc_common+0xdc/0x3b0
[  292.052570]  el0_svc_handler+0xf8/0x160
[  292.053303]  el0_svc+0x10/0x218
[  292.053908] Code: 9413f4a9 d503201f f90017b6 97f4d5b1 (d4210000)
[  292.055471] ---[ end trace 01b339dd07795f8d ]---
[  292.056443] Kernel panic - not syncing: Fatal exception
[  292.057488] SMP: stopping secondary CPUs
[  292.058419] Dumping ftrace buffer:
[  292.059078]    (ftrace buffer empty)
[  292.059756] Kernel Offset: disabled
[  292.060443] CPU features: 0x10,a1006000
[  292.061195] Memory Limit: none
[  292.061794] Rebooting in 86400 seconds..

Crash of this problem show that someone call __munlock_pagevec to clear
page LRU without lock_page.

 #0 [ffff80035f02f4c0] __switch_to at ffff20000808d020
 #1 [ffff80035f02f4f0] __schedule at ffff20000985102c
 #2 [ffff80035f02f5e0] schedule at ffff200009851d1c
 #3 [ffff80035f02f600] io_schedule at ffff2000098525c0
 #4 [ffff80035f02f620] __lock_page at ffff20000842d2d4
 #5 [ffff80035f02f710] __munlock_pagevec at ffff2000084c4600
 #6 [ffff80035f02f870] munlock_vma_pages_range at ffff2000084c5928
 #7 [ffff80035f02fa60] do_munmap at ffff2000084cbdf4
 #8 [ffff80035f02faf0] mmap_region at ffff2000084ce20c
 #9 [ffff80035f02fb90] do_mmap at ffff2000084cf018

So memory_failure will call identify_page_state without
wait_on_page_writeback.  And after truncate_error_page clear the mapping
of this page.  end_page_writeback won't call sb_clear_inode_writeback to
clear inode->i_wb_list.  That will trigger BUG_ON in clear_inode!

Fix it by checking PageWriteback too to help determine should we skip
wait_on_page_writeback.

Link: https://lkml.kernel.org/r/20210604084705.3729204-1-yangerkun@huawei.com
Fixes: 0bc1f8b0682c ("hwpoison: fix the handling path of the victimized page frame that belong to non-LRU")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-make-sure-wait-for-page-writeback-in-memory_failure
+++ a/mm/memory-failure.c
@@ -1552,7 +1552,12 @@ try_again:
 		return 0;
 	}
 
-	if (!PageTransTail(p) && !PageLRU(p))
+	/*
+	 * __munlock_pagevec may clear a writeback page's LRU flag without
+	 * page_lock. We need wait writeback completion for this page or it
+	 * may trigger vfs BUG while evict inode.
+	 */
+	if (!PageTransTail(p) && !PageLRU(p) && !PageWriteback(p))
 		goto identify_page_state;
 
 	/*
_
