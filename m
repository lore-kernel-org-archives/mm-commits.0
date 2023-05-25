Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CD8C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjEYT5B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbjEYT47 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0409E
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:56:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F23FD64AC5
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B34FC433EF;
        Thu, 25 May 2023 19:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685044617;
        bh=lLo2yOCnXNeC5X7pqkpn2il1D5D2x/Zfd5REkAXhP4Q=;
        h=Date:To:From:Subject:From;
        b=k7pCSwLeKS7nlnGGvp9WFICObxGzvR3raqnoestz6kPunjaKdryLo+aPDckHQbruY
         zmnEGm8RHtC9uvgyw3tAEm9YL6xDkm2/HEggIm2fr4NjeKLvmLdU2+LSywRg6h2Voc
         GY9QrcniVoaiQrK136mTW2fBVphkOAaoouJAxsrs=
Date:   Thu, 25 May 2023 12:56:56 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, hughd@google.com, tujinjiang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-uaf-bug-in-shmem_show_options.patch added to mm-unstable branch
Message-Id: <20230525195657.5B34FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: fix UAF bug in shmem_show_options()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fix-uaf-bug-in-shmem_show_options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-uaf-bug-in-shmem_show_options.patch

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
From: Tu Jinjiang <tujinjiang@huawei.com>
Subject: mm: shmem: fix UAF bug in shmem_show_options()
Date: Thu, 25 May 2023 11:16:40 +0800

shmem_show_options() uses sbinfo->mpol without adding it's refcnt. This
may lead to race with replacement of the mpol by remount. The execution
sequence is as follows.

       CPU0                                   CPU1
shmem_show_options()                        shmem_reconfigure()
    shmem_show_mpol(seq, sbinfo->mpol)          mpol = sbinfo->mpol
                                                mpol_put(mpol)
        mpol->mode

The KASAN report is as follows.

BUG: KASAN: slab-use-after-free in shmem_show_options+0x21b/0x340
Read of size 2 at addr ffff888124324004 by task mount/2388

CPU: 2 PID: 2388 Comm: mount Not tainted 6.4.0-rc3-00017-g9d646009f65d-dirty #8
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x37/0x50
 print_report+0xd0/0x620
 ? shmem_show_options+0x21b/0x340
 ? __virt_addr_valid+0xf4/0x180
 ? shmem_show_options+0x21b/0x340
 kasan_report+0xb8/0xe0
 ? shmem_show_options+0x21b/0x340
 shmem_show_options+0x21b/0x340
 ? __pfx_shmem_show_options+0x10/0x10
 ? strchr+0x2c/0x50
 ? strlen+0x23/0x40
 ? seq_puts+0x7d/0x90
 show_vfsmnt+0x1e6/0x260
 ? __pfx_show_vfsmnt+0x10/0x10
 ? __kasan_kmalloc+0x7f/0x90
 seq_read_iter+0x57a/0x740
 vfs_read+0x2e2/0x4a0
 ? __pfx_vfs_read+0x10/0x10
 ? down_write_killable+0xb8/0x140
 ? __pfx_down_write_killable+0x10/0x10
 ? __fget_light+0xa9/0x1e0
 ? up_write+0x3f/0x80
 ksys_read+0xb8/0x150
 ? __pfx_ksys_read+0x10/0x10
 ? fpregs_assert_state_consistent+0x55/0x60
 ? exit_to_user_mode_prepare+0x2d/0x120
 do_syscall_64+0x3c/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

 </TASK>

Allocated by task 2387:
 kasan_save_stack+0x22/0x50
 kasan_set_track+0x25/0x30
 __kasan_slab_alloc+0x59/0x70
 kmem_cache_alloc+0xdd/0x220
 mpol_new+0x83/0x150
 mpol_parse_str+0x280/0x4a0
 shmem_parse_one+0x364/0x520
 vfs_parse_fs_param+0xf8/0x1a0
 vfs_parse_fs_string+0xc9/0x130
 shmem_parse_options+0xb2/0x110
 path_mount+0x597/0xdf0
 do_mount+0xcd/0xf0
 __x64_sys_mount+0xbd/0x100
 do_syscall_64+0x3c/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

Freed by task 2389:
 kasan_save_stack+0x22/0x50
 kasan_set_track+0x25/0x30
 kasan_save_free_info+0x2e/0x50
 __kasan_slab_free+0x10e/0x1a0
 kmem_cache_free+0x9c/0x350
 shmem_reconfigure+0x278/0x370
 reconfigure_super+0x383/0x450
 path_mount+0xcc5/0xdf0
 do_mount+0xcd/0xf0
 __x64_sys_mount+0xbd/0x100
 do_syscall_64+0x3c/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

The buggy address belongs to the object at ffff888124324000
 which belongs to the cache numa_policy of size 32
The buggy address is located 4 bytes inside of
 freed 32-byte region [ffff888124324000, ffff888124324020)
==================================================================

To fix the bug, shmem_get_sbmpol() / mpol_put() needs to be called
before / after shmem_show_mpol() call.

Link: https://lkml.kernel.org/r/20230525031640.593733-1-tujinjiang@huawei.com
Signed-off-by: Tu Jinjiang <tujinjiang@huawei.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-uaf-bug-in-shmem_show_options
+++ a/mm/shmem.c
@@ -3741,6 +3741,7 @@ out:
 static int shmem_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(root->d_sb);
+	struct mempolicy *mpol;
 
 	if (sbinfo->max_blocks != shmem_default_max_blocks())
 		seq_printf(seq, ",size=%luk",
@@ -3783,7 +3784,9 @@ static int shmem_show_options(struct seq
 	if (sbinfo->huge)
 		seq_printf(seq, ",huge=%s", shmem_format_huge(sbinfo->huge));
 #endif
-	shmem_show_mpol(seq, sbinfo->mpol);
+	mpol = shmem_get_sbmpol(sbinfo);
+	shmem_show_mpol(seq, mpol);
+	mpol_put(mpol);
 	if (sbinfo->noswap)
 		seq_printf(seq, ",noswap");
 	return 0;
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-shmem-fix-uaf-bug-in-shmem_show_options.patch

