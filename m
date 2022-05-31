Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F2DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 19:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiEaTcJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 15:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344286AbiEaTcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 15:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9B79A9A2
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 12:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED727611F9
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 19:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E08C385A9;
        Tue, 31 May 2022 19:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654025526;
        bh=V3+gs3qbKfZgOUMoF5u1UXRLM/8ApaT6CHMqLtwsw+k=;
        h=Date:To:From:Subject:From;
        b=p6ZjXF/J9GTqzJCqD9UQsvW11/t2qiPbt8BQtSjHhfs2TBLfSEKIDEemjYLxpl+QJ
         AEISkaTskcWePZ82Ge0Cn1vstviN2RG6phhYB7XA7eQZ7i+AOBrTua5VMeuHeag2LJ
         wVBmtA5WXHIEfP4VcJ39/seLy9xClUHfyyPZPaqw=
Date:   Tue, 31 May 2022 12:32:05 -0700
To:     mm-commits@vger.kernel.org, chenzhongjin@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + profiling-fix-shift-too-large-makes-kernel-panic.patch added to mm-nonmm-unstable branch
Message-Id: <20220531193206.45E08C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: profiling: fix shift too large makes kernel panic
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     profiling-fix-shift-too-large-makes-kernel-panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/profiling-fix-shift-too-large-makes-kernel-panic.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Chen Zhongjin <chenzhongjin@huawei.com>
Subject: profiling: fix shift too large makes kernel panic
Date: Tue, 31 May 2022 09:28:54 +0800

2d186afd04d6 ("profiling: fix shift-out-of-bounds bugs") limits shift
value by [0, BITS_PER_LONG -1], which means [0, 63].

However, syzbot found that the max shift value should be the bit number of
(_etext - _stext).  If shift is outside of this, the "buffer_bytes" will
be zero and will cause kzalloc(0).  Then the kernel panics due to
dereferencing the returned pointer 16.

This can be easily reproduced by passing a large number like 60 to enable
profiling and then run readprofile.

LOGS:
 BUG: kernel NULL pointer dereference, address: 0000000000000010
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 6148067 P4D 6148067 PUD 6142067 PMD 0
 PREEMPT SMP
 CPU: 4 PID: 184 Comm: readprofile Not tainted 5.18.0+ #162
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
 RIP: 0010:read_profile+0x104/0x220
 RSP: 0018:ffffc900006fbe80 EFLAGS: 00000202
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: ffff888006150000 RSI: 0000000000000001 RDI: ffffffff82aba4a0
 RBP: 000000000188bb60 R08: 0000000000000010 R09: ffff888006151000
 R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff82aba4a0
 R13: 0000000000000000 R14: ffffc900006fbf08 R15: 0000000000020c30
 FS:  000000000188a8c0(0000) GS:ffff88803ed00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000010 CR3: 0000000006144000 CR4: 00000000000006e0
 Call Trace:
  <TASK>
  proc_reg_read+0x56/0x70
  vfs_read+0x9a/0x1b0
  ksys_read+0xa1/0xe0
  ? fpregs_assert_state_consistent+0x1e/0x40
  do_syscall_64+0x3a/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
 RIP: 0033:0x4d4b4e
 RSP: 002b:00007ffebb668d58 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
 RAX: ffffffffffffffda RBX: 000000000188a8a0 RCX: 00000000004d4b4e
 RDX: 0000000000000400 RSI: 000000000188bb60 RDI: 0000000000000003
 RBP: 0000000000000003 R08: 000000000000006e R09: 0000000000000000
 R10: 0000000000000041 R11: 0000000000000246 R12: 000000000188bb60
 R13: 0000000000000400 R14: 0000000000000000 R15: 000000000188bb60
  </TASK>
 Modules linked in:
 CR2: 0000000000000010
Killed
 ---[ end trace 0000000000000000 ]---

Check prof_len in profile_init() to prevent it be zero.

Link: https://lkml.kernel.org/r/20220531012854.229439-1-chenzhongjin@huawei.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/profile.c~profiling-fix-shift-too-large-makes-kernel-panic
+++ a/kernel/profile.c
@@ -109,6 +109,13 @@ int __ref profile_init(void)
 
 	/* only text is profiled */
 	prof_len = (_etext - _stext) >> prof_shift;
+
+	if (!prof_len) {
+		pr_warn("profiling shift: %u too large\n", prof_shift);
+		prof_on = 0;
+		return -EINVAL;
+	}
+
 	buffer_bytes = prof_len*sizeof(atomic_t);
 
 	if (!alloc_cpumask_var(&prof_cpu_mask, GFP_KERNEL))
_

Patches currently in -mm which might be from chenzhongjin@huawei.com are

profiling-fix-shift-too-large-makes-kernel-panic.patch

