From: akpm@linux-foundation.org
Subject: +
 mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch added to -mm tree
Date: Tue, 20 Dec 2016 14:34:44 -0800
Message-ID: <5859b204.QcPJuV4c/XXYhqoD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753370AbcLTWdn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 17:33:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, andreyknvl@google.com, ast@kernel.org, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab: make sure that KMALLOC_MAX_SIZE will fit into MAX_ORDER
has been added to the -mm tree.  Its filename is
     mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, slab: make sure that KMALLOC_MAX_SIZE will fit into MAX_ORDER

Andrey Konovalov has reported the following warning triggered by the
syzkaller fuzzer.

WARNING: CPU: 1 PID: 9935 at mm/page_alloc.c:3511
__alloc_pages_nodemask+0x159c/0x1e20
Kernel panic - not syncing: panic_on_warn set ...

CPU: 1 PID: 9935 Comm: syz-executor0 Not tainted 4.9.0-rc7+ #34
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 ffff88006949f2c8 ffffffff81f96b8a ffffffff00000200 1ffff1000d293dec
 ffffed000d293de4 0000000000000a06 0000000041b58ab3 ffffffff8598b510
 ffffffff81f968f8 0000000041b58ab3 ffffffff85942a58 ffffffff81432860
Call Trace:
 [<     inline     >] __dump_stack lib/dump_stack.c:15
 [<ffffffff81f96b8a>] dump_stack+0x292/0x398 lib/dump_stack.c:51
 [<ffffffff8168c88e>] panic+0x1cb/0x3a9 kernel/panic.c:179
 [<ffffffff812b80b4>] __warn+0x1c4/0x1e0 kernel/panic.c:542
 [<ffffffff812b831c>] warn_slowpath_null+0x2c/0x40 kernel/panic.c:585
 [<     inline     >] __alloc_pages_slowpath mm/page_alloc.c:3511
 [<ffffffff816c08ac>] __alloc_pages_nodemask+0x159c/0x1e20 mm/page_alloc.c:3781
 [<ffffffff817cde17>] alloc_pages_current+0x1c7/0x6b0 mm/mempolicy.c:2072
 [<     inline     >] alloc_pages include/linux/gfp.h:469
 [<ffffffff8172fd8f>] kmalloc_order+0x1f/0x70 mm/slab_common.c:1015
 [<ffffffff8172fdff>] kmalloc_order_trace+0x1f/0x160 mm/slab_common.c:1026
 [<     inline     >] kmalloc_large include/linux/slab.h:422
 [<ffffffff817e01f0>] __kmalloc+0x210/0x2d0 mm/slub.c:3723
 [<     inline     >] kmalloc include/linux/slab.h:495
 [<ffffffff832262a7>] ep_write_iter+0x167/0xb50 drivers/usb/gadget/legacy/inode.c:664
 [<     inline     >] new_sync_write fs/read_write.c:499
 [<ffffffff817fdcd3>] __vfs_write+0x483/0x760 fs/read_write.c:512
 [<ffffffff817ff720>] vfs_write+0x170/0x4e0 fs/read_write.c:560
 [<     inline     >] SYSC_write fs/read_write.c:607
 [<ffffffff81803b2b>] SyS_write+0xfb/0x230 fs/read_write.c:599
 [<ffffffff84f47ec1>] entry_SYSCALL_64_fastpath+0x1f/0xc2

The issue is caused by a lack of size check for the request size in
ep_write_iter which should be fixed.  It, however, points to another
problem, that SLUB defines KMALLOC_MAX_SIZE too large because the its
KMALLOC_SHIFT_MAX is (MAX_ORDER + PAGE_SHIFT) which means that the
resulting page allocator request might be MAX_ORDER which is too large
(see __alloc_pages_slowpath).  The same applies to the SLOB allocator
which allows even larger sizes.  Make sure that they are capped properly
and never request more than MAX_ORDER order.

Link: http://lkml.kernel.org/r/20161220130659.16461-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/slab.h~mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order include/linux/slab.h
--- a/include/linux/slab.h~mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order
+++ a/include/linux/slab.h
@@ -226,7 +226,7 @@ static inline const char *__check_heap_o
  * (PAGE_SIZE*2).  Larger requests are passed to the page allocator.
  */
 #define KMALLOC_SHIFT_HIGH	(PAGE_SHIFT + 1)
-#define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT)
+#define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT - 1)
 #ifndef KMALLOC_SHIFT_LOW
 #define KMALLOC_SHIFT_LOW	3
 #endif
@@ -239,7 +239,7 @@ static inline const char *__check_heap_o
  * be allocated from the same page.
  */
 #define KMALLOC_SHIFT_HIGH	PAGE_SHIFT
-#define KMALLOC_SHIFT_MAX	30
+#define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT - 1)
 #ifndef KMALLOC_SHIFT_LOW
 #define KMALLOC_SHIFT_LOW	3
 #endif
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch
bpf-do-not-use-kmalloc_shift_max.patch
mm-throttle-show_mem-from-warn_alloc.patch

