Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F1CC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiESW0e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245520AbiESW0O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C92230F71
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2152B828C1
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65267C385AA;
        Thu, 19 May 2022 22:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999158;
        bh=EMioJ76OqHT6N2n3BJ6jLg/xmrqzHYMoYmUy+nsxkM8=;
        h=Date:To:From:Subject:From;
        b=0Z4qBkauXvdqGFgvgO27kK0827nDZtbNwPbUE2HOfkSh5bSFhhZR3uyVNp+DCsFic
         44ycDV/U50f6v+L1vuh/tM47qjG9BCt5H9KZkuVJGMiXXtGloTlOD1f3QBjITwrnrA
         WVvbrMsC/oePya92JxK4Ui9XXFeqa4N+iuW46S40=
Date:   Thu, 19 May 2022 15:25:57 -0700
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com, hughd@google.com,
        luomeng12@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tmpfs-fix-undefined-behaviour-in-shmem_reconfigure.patch removed from -mm tree
Message-Id: <20220519222558.65267C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tmpfs: fix undefined-behaviour in shmem_reconfigure()
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-undefined-behaviour-in-shmem_reconfigure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luo Meng <luomeng12@huawei.com>
Subject: tmpfs: fix undefined-behaviour in shmem_reconfigure()
Date: Fri, 13 May 2022 10:52:25 +0800

When shmem_reconfigure() calls __percpu_counter_compare(), the second
parameter is unsigned long long.  But in the definition of
__percpu_counter_compare(), the second parameter is s64.  So when
__percpu_counter_compare() executes abs(count - rhs), UBSAN shows the
following warning:

================================================================================
UBSAN: Undefined behaviour in lib/percpu_counter.c:209:6
signed integer overflow:
0 - -9223372036854775808 cannot be represented in type 'long long int'
CPU: 1 PID: 9636 Comm: syz-executor.2 Tainted: G                 ---------r-  - 4.18.0 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack home/install/linux-rh-3-10/lib/dump_stack.c:77 [inline]
 dump_stack+0x125/0x1ae home/install/linux-rh-3-10/lib/dump_stack.c:117
 ubsan_epilogue+0xe/0x81 home/install/linux-rh-3-10/lib/ubsan.c:159
 handle_overflow+0x19d/0x1ec home/install/linux-rh-3-10/lib/ubsan.c:190
 __percpu_counter_compare+0x124/0x140 home/install/linux-rh-3-10/lib/percpu_counter.c:209
 percpu_counter_compare home/install/linux-rh-3-10/./include/linux/percpu_counter.h:50 [inline]
 shmem_remount_fs+0x1ce/0x6b0 home/install/linux-rh-3-10/mm/shmem.c:3530
 do_remount_sb+0x11b/0x530 home/install/linux-rh-3-10/fs/super.c:888
 do_remount home/install/linux-rh-3-10/fs/namespace.c:2344 [inline]
 do_mount+0xf8d/0x26b0 home/install/linux-rh-3-10/fs/namespace.c:2844
 ksys_mount+0xad/0x120 home/install/linux-rh-3-10/fs/namespace.c:3075
 __do_sys_mount home/install/linux-rh-3-10/fs/namespace.c:3089 [inline]
 __se_sys_mount home/install/linux-rh-3-10/fs/namespace.c:3086 [inline]
 __x64_sys_mount+0xbf/0x160 home/install/linux-rh-3-10/fs/namespace.c:3086
 do_syscall_64+0xca/0x5c0 home/install/linux-rh-3-10/arch/x86/entry/common.c:298
 entry_SYSCALL_64_after_hwframe+0x6a/0xdf
RIP: 0033:0x46b5e9
Code: 5d db fa ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b db fa ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f54d5f22c68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000000000077bf60 RCX: 000000000046b5e9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000000
RBP: 000000000077bf60 R08: 0000000020000140 R09: 0000000000000000
R10: 00000000026740a4 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd1fb1592f R14: 00007f54d5f239c0 R15: 000000000077bf6c
================================================================================

[akpm@linux-foundation.org: tweak error message text]
Link: https://lkml.kernel.org/r/20220513025225.2678727-1-luomeng12@huawei.com
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/shmem.c~tmpfs-fix-undefined-behaviour-in-shmem_reconfigure
+++ a/mm/shmem.c
@@ -3476,6 +3476,10 @@ static int shmem_reconfigure(struct fs_c
 
 	raw_spin_lock(&sbinfo->stat_lock);
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
+	if (ctx->blocks > S64_MAX) {
+		err = "Number of blocks too large";
+		goto out;
+	}
 	if ((ctx->seen & SHMEM_SEEN_BLOCKS) && ctx->blocks) {
 		if (!sbinfo->max_blocks) {
 			err = "Cannot retroactively limit size";
_

Patches currently in -mm which might be from luomeng12@huawei.com are


