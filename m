Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC74C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379881AbiFQC7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379274AbiFQC66 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:58:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A179965D05
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47B99B826F2
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86B9C3411C;
        Fri, 17 Jun 2022 02:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434734;
        bh=e3iuauelqusVI92Sk0/1yf41nQn9Jb86lhTgXECk6nA=;
        h=Date:To:From:Subject:From;
        b=RNj2GbbJ9qxxhT1ByL+HxBydhN5QddHaDFy3o9/6SE03gOI5dfk59xQAXdLNzrvmq
         0gjBotrJhkpd21aNQ5y0yGjLlJ9HY0UWtjeAVckhqvy2jtJakj8SHX6+gq9mkaFISp
         sLUnclExX5TJloFPA2mta3FwvnMokDWWkNSVoZ/A=
Date:   Thu, 16 Jun 2022 19:58:54 -0700
To:     mm-commits@vger.kernel.org, chenzhongjin@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] profiling-fix-shift-too-large-makes-kernel-panic.patch removed from -mm tree
Message-Id: <20220617025854.D86B9C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: profiling: fix shift too large makes kernel panic
has been removed from the -mm tree.  Its filename was
     profiling-fix-shift-too-large-makes-kernel-panic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


