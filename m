Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8885FC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 20:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B6420EDD
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 20:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602621697;
	bh=3LkPIss7+0/JPjVNMlR8a1P9WY4xGNvCtlyoTtL7esU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=C1A63yEPjtYqyujoqzpt4Y90rbKY3r+0W6G8TttcENN406ZWEWU8D/lEZTvRESfTW
	 aJGy5BiF6JWssM8T6Etcn2INUXM9DLCtjgWZ4q1f4H/SAfopTBCKtq0kpcmawra4ke
	 2cQirYPqDlrEHQ1nbwHn6KrmgF6NT4YEaQlbnIl8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgJMUlg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 16:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJMUlg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 16:41:36 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 140A7208D5;
        Tue, 13 Oct 2020 20:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602621695;
        bh=3LkPIss7+0/JPjVNMlR8a1P9WY4xGNvCtlyoTtL7esU=;
        h=Date:From:To:Subject:From;
        b=JUfb+YfSRJhx72eA8BLE/l2KhscYhJwSTUX9FGFk3bdWAMje2KT+C2Manpv4EToCo
         53mWRDbztZo8WYKfPz87fYERRm/AlFvwWdgFzj08iweAS+1hO5qIdNEr1nIjz0bzqO
         zxcSCCKgsffXEJOLjHxMQOB2nKdse515PJKUSWSU=
Date:   Tue, 13 Oct 2020 13:41:34 -0700
From:   akpm@linux-foundation.org
To:     airlied@redhat.com, chris@chris-wilson.co.uk,
        ckoenig.leichtzumerken@gmail.com, daniel@ffwll.ch,
        jhubbard@nvidia.com, linmiaohe@huawei.com, louhongxiang@huawei.com,
        mm-commits@vger.kernel.org, sumit.semwal@linaro.org,
        willy@infradead.org
Subject:  [merged]
 mm-mmap-fix-general-protection-fault-in-unlink_file_vma.patch removed from
 -mm tree
Message-ID: <20201013204134.XL4SZgh3S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: fix general protection fault in unlink_file_vma()
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-general-protection-fault-in-unlink_file_vma.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: mmap: Fix general protection fault in unlink_file_vma()

The syzbot reported the below general protection fault:

general protection fault, probably for non-canonical address
0xe00eeaee0000003b: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range
[0x00777770000001d8-0x00777770000001df]
CPU: 1 PID: 10488 Comm: syz-executor721 Not tainted 5.9.0-rc3-syzkaller #0
RIP: 0010:unlink_file_vma+0x57/0xb0 mm/mmap.c:164
Code: 4c 8b a5 a0 00 00 00 4d 85 e4 74 4e e8 92 d7 cd ff 49 8d bc 24
d8 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c
02 00 75 3d 4d 8b b4 24 d8 01 00 00 4d 8d 6e 78 4c 89 ef e8
RSP: 0018:ffffc9000ac0f9b0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88800010ceb0 RCX: ffffffff81592421
RDX: 000eeeee0000003b RSI: ffffffff81a6736e RDI: 00777770000001d8
RBP: ffff88800010ceb0 R08: 0000000000000001 R09: ffff88801291a50f
R10: ffffed10025234a1 R11: 0000000000000001 R12: 0077777000000000
R13: 00007f1eea0da000 R14: 00007f1eea0d9000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1eea11a9d0 CR3: 000000000007e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 free_pgtables+0x1b3/0x2f0 mm/memory.c:415
 exit_mmap+0x2c0/0x530 mm/mmap.c:3184
 __mmput+0x122/0x470 kernel/fork.c:1076
 mmput+0x53/0x60 kernel/fork.c:1097
 exit_mm kernel/exit.c:483 [inline]
 do_exit+0xa8b/0x29f0 kernel/exit.c:793
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x428/0x1f00 kernel/signal.c:2757
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:136 [inline]
 exit_to_user_mode_prepare+0x1ae/0x200 kernel/entry/common.c:167
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:242
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

It's because the ->mmap() callback can change vma->vm_file and fput the
original file. But the commit d70cec898324 ("mm: mmap: merge vma after
call_mmap() if possible") failed to catch this case and always fput() the
original file, hence add an extra fput().

[ Thanks Hillf for pointing this extra fput() out. ]

Link: https://lkml.kernel.org/r/20200916090733.31427-1-linmiaohe@huawei.com
Fixes: d70cec898324 ("mm: mmap: merge vma after call_mmap() if possible")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: syzbot+c5d5a51dcbb558ca0cb5@syzkaller.appspotmail.com
Cc: Christian K=C3=B6nig <ckoenig.leichtzumerken@gmail.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-fix-general-protection-fault-in-unlink_file_vma
+++ a/mm/mmap.c
@@ -1781,7 +1781,11 @@ unsigned long mmap_region(struct file *f
 			merge =3D vma_merge(mm, prev, vma->vm_start, vma->vm_end, vma->vm_flags,
 				NULL, vma->vm_file, vma->vm_pgoff, NULL, NULL_VM_UFFD_CTX);
 			if (merge) {
-				fput(file);
+				/* ->mmap() can change vma->vm_file and fput the original file. So
+				 * fput the vma->vm_file here or we would add an extra fput for file
+				 * and cause general protection fault ultimately.
+				 */
+				fput(vma->vm_file);
 				vm_area_free(vma);
 				vma =3D merge;
 				/* Update vm_flags and possible addr to pick up the change. We don't
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_sl=
ots_cache.patch
mm-remove-useless-out-label-in-__swap_writepage.patch
mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch
mm-remove-unnecessary-goto-out-in-_swap_info_get.patch
mm-fix-potential-memory-leak-in-sys_swapon.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_count=
er_try_charge.patch
mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct=
.patch
mm-mempool-add-else-to-split-mutually-exclusive-case.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pa=
ges.patch

