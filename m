Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9234C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 21:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiINVHO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 17:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiINVHN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 17:07:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CC27A526
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 14:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9F3B61F02
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 21:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1431DC433D6;
        Wed, 14 Sep 2022 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663189631;
        bh=1+JlefMQxVnTxANw6esokVyZVfUkq3LEOdNDdYZKHYM=;
        h=Date:To:From:Subject:From;
        b=GGNBbhYWXxe4F5NDVoI/Uxyklf8YGiJZYpHJkC7VNsWKV3pfV7OIB/q3KmgVSUOCd
         X888tT5DhFa5KVlhG7pHojcpYD5ooN2Hjc1JzloLEWgjrzHNnsraQW8RMLYrixpsqS
         nCgNn8vn3zxTPCZ9ag/bwNTV88bDxcDZgIBBPdqc=
Date:   Wed, 14 Sep 2022 14:07:10 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madv_collapse-refetch-vm_end-after-reacquiring-mmap_lock.patch added to mm-unstable branch
Message-Id: <20220914210711.1431DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: MADV_COLLAPSE: refetch vm_end after reacquiring mmap_lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madv_collapse-refetch-vm_end-after-reacquiring-mmap_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madv_collapse-refetch-vm_end-after-reacquiring-mmap_lock.patch

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
From: Yang Shi <shy828301@gmail.com>
Subject: mm: MADV_COLLAPSE: refetch vm_end after reacquiring mmap_lock
Date: Wed, 14 Sep 2022 09:22:20 -0700

The syzbot reported the below problem:

BUG: Bad page map in process syz-executor198  pte:8000000071c00227 pmd:74b30067
addr:0000000020563000 vm_flags:08100077 anon_vma:ffff8880547d2200 mapping:0000000000000000 index:20563
file:(null) fault:0x0 mmap:0x0 read_folio:0x0
CPU: 1 PID: 3614 Comm: syz-executor198 Not tainted 6.0.0-rc3-next-20220901-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_bad_pte.cold+0x2a7/0x2d0 mm/memory.c:565
 vm_normal_page+0x10c/0x2a0 mm/memory.c:636
 hpage_collapse_scan_pmd+0x729/0x1da0 mm/khugepaged.c:1199
 madvise_collapse+0x481/0x910 mm/khugepaged.c:2433
 madvise_vma_behavior+0xd0a/0x1cc0 mm/madvise.c:1062
 madvise_walk_vmas+0x1c7/0x2b0 mm/madvise.c:1236
 do_madvise.part.0+0x24a/0x340 mm/madvise.c:1415
 do_madvise mm/madvise.c:1428 [inline]
 __do_sys_madvise mm/madvise.c:1428 [inline]
 __se_sys_madvise mm/madvise.c:1426 [inline]
 __x64_sys_madvise+0x113/0x150 mm/madvise.c:1426
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f770ba87929
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f770ba18308 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f770bb0f3f8 RCX: 00007f770ba87929
RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000000020000000
RBP: 00007f770bb0f3f0 R08: 00007f770ba18700 R09: 0000000000000000
R10: 00007f770ba18700 R11: 0000000000000246 R12: 00007f770bb0f3fc
R13: 00007ffc2d8b62ef R14: 00007f770ba18400 R15: 0000000000022000

Basically the test program does the below conceptually:
1. mmap 0x2000000 - 0x21000000 as anonymous region
2. mmap io_uring SQ stuff at 0x20563000 with MAP_FIXED, io_uring_mmap()
   actually remaps the pages with special PTEs
3. call MADV_COLLAPSE for 0x20000000 - 0x21000000

It actually triggered the below race:

             CPU A                                          CPU B
mmap 0x20000000 - 0x21000000 as anon
                                           madvise_collapse is called on this area
                                             Retrieve start and end address from the vma (NEVER updated later!)
                                             Collapsed the first 2M area and dropped mmap_lock
Acquire mmap_lock
mmap io_uring file at 0x20563000
Release mmap_lock
                                             Reacquire mmap_lock
                                             revalidate vma pass since 0x20200000 + 0x200000 > 0x20563000
                                             scan the next 2M (0x20200000 - 0x20400000), but due to whatever reason it didn't release mmap_lock
                                             scan the 3rd 2M area (start from 0x20400000)
                                               get into the vma created by io_uring

The hend should be updated after MADV_COLLAPSE reacquire mmap_lock since
the vma may be shrunk.  We don't have to worry about shink from the other
direction since it could be caught by hugepage_vma_revalidate().  Either
no valid vma is found or the vma doesn't fit anymore.

Link: https://lkml.kernel.org/r/20220914162220.787703-1-shy828301@gmail.com
Fixes: 7d8faaf155454f8 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Reported-by: syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/khugepaged.c~mm-madv_collapse-refetch-vm_end-after-reacquiring-mmap_lock
+++ a/mm/khugepaged.c
@@ -2438,6 +2438,8 @@ int madvise_collapse(struct vm_area_stru
 				last_fail = result;
 				goto out_nolock;
 			}
+
+			hend = vma->vm_end & HPAGE_PMD_MASK;
 		}
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-gup-fix-the-fast-gup-race-against-thp-collapse.patch
powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush.patch
mm-madv_collapse-refetch-vm_end-after-reacquiring-mmap_lock.patch

