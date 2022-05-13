Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FE8C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 21:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384648AbiEMVSo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 17:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240772AbiEMVSn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 17:18:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652F45373D
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 14:18:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1564AB83132
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 21:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBD9C34100;
        Fri, 13 May 2022 21:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652476718;
        bh=aUV4mekpIaYjiHsqQojukF6LHrdIt9TURdy1I9Zuj/8=;
        h=Date:To:From:Subject:From;
        b=hFiAVxap6gwcTR16qq6cAWdknXqbdqhAfDQq50MXDTjR29V7UrVEueA8pbjUMSfbi
         bx3kOqfXw8W0D7OJOoIBrCreL4GPNC4CSkUpIV+WXo1CTbyQuL4kRPlMp0NgGPaEX8
         Xt+n+jXJHlJJLE5HE1RO0EpLIsxs2f0otBQBJdj8=
Date:   Fri, 13 May 2022 14:18:37 -0700
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com, hughd@google.com,
        luomeng12@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-fix-undefined-behaviour-in-shmem_reconfigure.patch added to mm-unstable branch
Message-Id: <20220513211838.9EBD9C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: fix undefined-behaviour in shmem_reconfigure()
has been added to the -mm mm-unstable branch.  Its filename is
     tmpfs-fix-undefined-behaviour-in-shmem_reconfigure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-fix-undefined-behaviour-in-shmem_reconfigure.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
+		err = "The number of blocks too large";
+		goto out;
+	}
 	if ((ctx->seen & SHMEM_SEEN_BLOCKS) && ctx->blocks) {
 		if (!sbinfo->max_blocks) {
 			err = "Cannot retroactively limit size";
_

Patches currently in -mm which might be from luomeng12@huawei.com are

tmpfs-fix-undefined-behaviour-in-shmem_reconfigure.patch

