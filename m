From: akpm@linux-foundation.org
Subject: [patch 04/12] stackdepot: fix mempolicy use-after-free
Date: Thu, 25 Aug 2016 15:16:54 -0700
Message-ID: <57bf6e56.oTFKip6ell2mR8QO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59252 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932754AbcHYWmQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 18:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vegard.nossum@oracle.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com

From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: stackdepot: fix mempolicy use-after-free

This patch fixes the following:

    BUG: KASAN: use-after-free in alloc_pages_current+0x363/0x370 at addr ffff88010b48102c
    Read of size 2 by task trinity-c2/15425
    CPU: 0 PID: 15425 Comm: trinity-c2 Not tainted 4.8.0-rc2+ #140
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-proje
    ct.org 04/01/2014
     ffff88010b481040 ffff88010b557650 ffffffff81f08d11 ffff88011a40d380
     ffff88010b481028 ffff88010b557678 ffffffff815dac7c ffff88010b557708
     ffff88010b481028 ffff88011a40d380 ffff88010b5576f8 ffffffff815daf15
    Call Trace:
     [<ffffffff81f08d11>] dump_stack+0x65/0x84
     [<ffffffff815dac7c>] kasan_object_err+0x1c/0x70
     [<ffffffff815daf15>] kasan_report_error+0x1f5/0x4c0
     [<ffffffff815db2fe>] __asan_report_load2_noabort+0x3e/0x40
     [<ffffffff815cb903>] alloc_pages_current+0x363/0x370    <---- use-after-free
     [<ffffffff81fa9954>] depot_save_stack+0x3f4/0x490
     [<ffffffff815d9bb5>] save_stack+0xb5/0xd0
     [<ffffffff815da211>] kasan_slab_free+0x71/0xb0
     [<ffffffff815d6643>] kmem_cache_free+0xa3/0x290
     [<ffffffff815c8149>] __mpol_put+0x19/0x20               <---- free
     [<ffffffff81260635>] do_exit+0x1515/0x2b70
     [<ffffffff81261dc4>] do_group_exit+0xf4/0x2f0
     [<ffffffff81281c5d>] get_signal+0x53d/0x1120
     [<ffffffff8119e993>] do_signal+0x83/0x1e20
     [<ffffffff810027af>] exit_to_usermode_loop+0xaf/0x140
     [<ffffffff810051e4>] syscall_return_slowpath+0x144/0x170
     [<ffffffff83ae406f>] ret_from_fork+0x2f/0x40
    Read of size 2 by task trinity-c2/15425

The problem is that we may be calling alloc_pages() in a code path where
current->mempolicy has already been freed.

By passing __GFP_THISNODE we will always use default_mempolicy (which
cannot be freed).

Link: https://lkml.org/lkml/2016/7/29/277
Link: https://github.com/google/kasan/issues/35
Link: http://lkml.kernel.org/r/1471603265-31804-1-git-send-email-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN lib/stackdepot.c~stackdepot-fix-mempolicy-use-after-free lib/stackdepot.c
--- a/lib/stackdepot.c~stackdepot-fix-mempolicy-use-after-free
+++ a/lib/stackdepot.c
@@ -243,6 +243,12 @@ depot_stack_handle_t depot_save_stack(st
 		alloc_flags &= ~GFP_ZONEMASK;
 		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
 		alloc_flags |= __GFP_NOWARN;
+		/*
+		 * Avoid using current->mempolicy which may already have
+		 * been freed -- we may be in the process of saving the
+		 * stack for exactly that __mpol_put() call.
+		 */
+		alloc_flags |= __GFP_THISNODE;
 		page = alloc_pages(alloc_flags, STACK_ALLOC_ORDER);
 		if (page)
 			prealloc = page_address(page);
_
