Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD27CC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 26 Dec 2021 22:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhLZWT4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 17:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbhLZWT4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 17:19:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC79C06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 14:19:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B5FF60E2D
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 22:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F3AC36AE9;
        Sun, 26 Dec 2021 22:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640557194;
        bh=MpGf9bjtiVaCcICluYqZekl6opUTDnT/670XRh0tb8A=;
        h=Date:From:To:Subject:From;
        b=NyPiHPsYrHx2nEmYt9EKZMwafOCSJR6cpkvxex6g2VQaeZgP9E4HqmjgbZEeD6lkh
         xPy87MMIHPx6MO8OAkJ/Sn9cMWPzI2oPY98RgpUNGxm6/31iOaUlAJYZtwVk9/dsm2
         tEd2d8EJw1uwuD0EtlvjAXqlkhK2jTldtDSysYjo=
Date:   Sun, 26 Dec 2021 14:19:53 -0800
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        hulkci@huawei.com, libaokun1@huawei.com,
        mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        yukuai3@huawei.com
Subject:  [merged]
 kfence-fix-memory-leak-when-cat-kfence-objects.patch removed from -mm tree
Message-ID: <20211226221953.Pw0Ccywvn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: fix memory leak when cat kfence objects
has been removed from the -mm tree.  Its filename was
     kfence-fix-memory-leak-when-cat-kfence-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baokun Li <libaokun1@huawei.com>
Subject: kfence: fix memory leak when cat kfence objects

Hulk robot reported a kmemleak problem:
-----------------------------------------------------------------------
unreferenced object 0xffff93d1d8cc02e8 (size 248):
  comm "cat", pid 23327, jiffies 4624670141 (age 495992.217s)
  hex dump (first 32 bytes):
    00 40 85 19 d4 93 ff ff 00 10 00 00 00 00 00 00  .@..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000db5610b3>] seq_open+0x2a/0x80
    [<00000000d66ac99d>] full_proxy_open+0x167/0x1e0
    [<00000000d58ef917>] do_dentry_open+0x1e1/0x3a0
    [<0000000016c91867>] path_openat+0x961/0xa20
    [<00000000909c9564>] do_filp_open+0xae/0x120
    [<0000000059c761e6>] do_sys_openat2+0x216/0x2f0
    [<00000000b7a7b239>] do_sys_open+0x57/0x80
    [<00000000e559d671>] do_syscall_64+0x33/0x40
    [<000000000ea1fbfd>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff93d419854000 (size 4096):
  comm "cat", pid 23327, jiffies 4624670141 (age 495992.217s)
  hex dump (first 32 bytes):
    6b 66 65 6e 63 65 2d 23 32 35 30 3a 20 30 78 30  kfence-#250: 0x0
    30 30 30 30 30 30 30 37 35 34 62 64 61 31 32 2d  0000000754bda12-
  backtrace:
    [<000000008162c6f2>] seq_read_iter+0x313/0x440
    [<0000000020b1b3e3>] seq_read+0x14b/0x1a0
    [<00000000af248fbc>] full_proxy_read+0x56/0x80
    [<00000000f97679d1>] vfs_read+0xa5/0x1b0
    [<000000000ed8a36f>] ksys_read+0xa0/0xf0
    [<00000000e559d671>] do_syscall_64+0x33/0x40
    [<000000000ea1fbfd>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
-----------------------------------------------------------------------

I find that we can easily reproduce this problem with the following
commands:
	`cat /sys/kernel/debug/kfence/objects`
	`echo scan > /sys/kernel/debug/kmemleak`
	`cat /sys/kernel/debug/kmemleak`

The leaked memory is allocated in the stack below:
----------------------------------
do_syscall_64
  do_sys_open
    do_dentry_open
      full_proxy_open
        seq_open            ---> alloc seq_file
  vfs_read
    full_proxy_read
      seq_read
        seq_read_iter
          traverse          ---> alloc seq_buf
----------------------------------

And it should have been released in the following process:
----------------------------------
do_syscall_64
  syscall_exit_to_user_mode
    exit_to_user_mode_prepare
      task_work_run
        ____fput
          __fput
            full_proxy_release  ---> free here
----------------------------------

However, the release function corresponding to file_operations is not
implemented in kfence. As a result, a memory leak occurs. Therefore,
the solution to this problem is to implement the corresponding
release function.

Link: https://lkml.kernel.org/r/20211206133628.2822545-1-libaokun1@huawei.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/core.c~kfence-fix-memory-leak-when-cat-kfence-objects
+++ a/mm/kfence/core.c
@@ -683,6 +683,7 @@ static const struct file_operations obje
 	.open = open_objects,
 	.read = seq_read,
 	.llseek = seq_lseek,
+	.release = seq_release,
 };
 
 static int __init kfence_debugfs_init(void)
_

Patches currently in -mm which might be from libaokun1@huawei.com are

sysctl-returns-einval-when-a-negative-value-is-passed-to-proc_doulongvec_minmax.patch

