From: akpm@linux-foundation.org
Subject: [patch 10/12] fs/seq_file: fix out-of-bounds read
Date: Thu, 25 Aug 2016 15:17:11 -0700
Message-ID: <57bf6e67.9U2tKLAw+fxscU9y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758557AbcHYW2j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 18:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vegard.nossum@oracle.com, davej@codemonkey.org.uk, stable@vger.kernel.org, viro@zeniv.linux.org.uk

From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: fs/seq_file: fix out-of-bounds read

seq_read() is a nasty piece of work, not to mention buggy.

It has (I think) an old bug which allows unprivileged userspace to read
beyond the end of m->buf.

I was getting these:

    BUG: KASAN: slab-out-of-bounds in seq_read+0xcd2/0x1480 at addr ffff880116889880
    Read of size 2713 by task trinity-c2/1329
    CPU: 2 PID: 1329 Comm: trinity-c2 Not tainted 4.8.0-rc1+ #96
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
     0000000000000000 ffff880110ebf8c0 ffffffff82344770 0000000041b58ab3
     ffffffff84f97be8 ffffffff823446c4 0000000000000001 ffffffff00000028
     ffff880110ebf8f8 ffff880110ebf8a8 ffff880110ebf998 0000000025843ea1
    Call Trace:
     [<ffffffff82344770>] dump_stack+0xac/0xfc
     [<ffffffff823446c4>] ? _atomic_dec_and_lock+0xc4/0xc4
     [<ffffffff817964dc>] kasan_object_err+0x1c/0x80
     [<ffffffff8179687b>] kasan_report_error+0x2cb/0x7e0
     [<ffffffff81796e3e>] kasan_report+0x4e/0x80
     [<ffffffff81410e00>] ? down_trylock+0x40/0x90
     [<ffffffff81886522>] ? seq_read+0xcd2/0x1480
     [<ffffffff817952be>] check_memory_region+0x13e/0x1a0
     [<ffffffff817954e1>] kasan_check_read+0x11/0x20
     [<ffffffff81886522>] seq_read+0xcd2/0x1480
     [<ffffffff81410e15>] ? down_trylock+0x55/0x90
     [<ffffffff81435f51>] ? vprintk_emit+0x151/0x740
     [<ffffffff81435fd4>] ? vprintk_emit+0x1d4/0x740
     [<ffffffff81435172>] ? console_trylock+0x12/0x100
     [<ffffffff845f7d4c>] ? _raw_spin_unlock+0x2c/0x50
     [<ffffffff81885850>] ? seq_open+0x220/0x220
     [<ffffffff8199ccc0>] ? proc_reg_write+0x260/0x260
     [<ffffffff814368fa>] ? vprintk_default+0x1a/0x20
     [<ffffffff81631e8d>] ? printk+0x94/0xb0
     [<ffffffff81631df9>] ? cpumask_weight.constprop.26+0x34/0x34
     [<ffffffff8199cdcb>] proc_reg_read+0x10b/0x260
     [<ffffffff8199ccc0>] ? proc_reg_write+0x260/0x260
     [<ffffffff817fca00>] do_loop_readv_writev.part.5+0x140/0x2c0
     [<ffffffff817ffac9>] do_readv_writev+0x589/0x860
     [<ffffffff817ff540>] ? rw_verify_area+0x370/0x370
     [<ffffffff845eebef>] ? mutex_lock_nested+0x49f/0x8e0
     [<ffffffff81871624>] ? __fdget_pos+0x94/0xe0
     [<ffffffff845ee750>] ? ww_mutex_unlock+0x390/0x390
     [<ffffffff8180480b>] vfs_readv+0x7b/0xd0
     [<ffffffff81871624>] ? __fdget_pos+0x94/0xe0
     [<ffffffff81804938>] do_readv+0xd8/0x2c0
     [<ffffffff81804860>] ? vfs_readv+0xd0/0xd0
     [<ffffffff823c7143>] ? __this_cpu_preempt_check+0x13/0x20
     [<ffffffff81805220>] ? do_pwritev+0x1b0/0x1b0
     [<ffffffff8180522b>] SyS_readv+0xb/0x10
     [<ffffffff81007bd3>] do_syscall_64+0x1b3/0x4b0
     [<ffffffff845f85aa>] entry_SYSCALL64_slow_path+0x25/0x25
    Object at ffff880116889100, in cache kmalloc-4096 size: 4096
    Allocated:
    PID = 1329
     [<ffffffff81235f26>] save_stack_trace+0x26/0x80
     [<ffffffff81795366>] save_stack+0x46/0xd0
     [<ffffffff81795b1d>] kasan_kmalloc+0xad/0xe0
     [<ffffffff8179094a>] __kmalloc+0x1aa/0x4a0
     [<ffffffff81884bc5>] seq_buf_alloc+0x35/0x40
     [<ffffffff81886028>] seq_read+0x7d8/0x1480
     [<ffffffff8199cdcb>] proc_reg_read+0x10b/0x260
     [<ffffffff817fca00>] do_loop_readv_writev.part.5+0x140/0x2c0
     [<ffffffff817ffac9>] do_readv_writev+0x589/0x860
     [<ffffffff8180480b>] vfs_readv+0x7b/0xd0
     [<ffffffff81804938>] do_readv+0xd8/0x2c0
     [<ffffffff8180522b>] SyS_readv+0xb/0x10
     [<ffffffff81007bd3>] do_syscall_64+0x1b3/0x4b0
     [<ffffffff845f85aa>] return_from_SYSCALL_64+0x0/0x6a
    Freed:
    PID = 0
    (stack is not available)
    Memory state around the buggy address:
     ffff88011688a000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     ffff88011688a080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    >ffff88011688a100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
		       ^
     ffff88011688a180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
     ffff88011688a200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    ==================================================================
    Disabling lock debugging due to kernel taint

This seems to be the same thing that Dave Jones was seeing here:

  https://lkml.org/lkml/2016/8/12/334

There are multiple issues here:

  1) If we enter the function with a non-empty buffer, there is an attempt
     to flush it. But it was not clearing m->from after doing so, which
     means that if we try to do this flush twice in a row without any call
     to traverse() in between, we are going to be reading from the wrong
     place -- the splat above, fixed by this patch.

  2) If there's a short write to userspace because of page faults, the
     buffer may already contain multiple lines (i.e. pos has advanced by
     more than 1), but we don't save the progress that was made so the
     next call will output what we've already returned previously. Since
     that is a much less serious issue (and I have a headache after
     staring at seq_read() for the past 8 hours), I'll leave that for now.

Link: http://lkml.kernel.org/r/1471447270-32093-1-git-send-email-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/seq_file.c~fs-seq_file-fix-out-of-bounds-read fs/seq_file.c
--- a/fs/seq_file.c~fs-seq_file-fix-out-of-bounds-read
+++ a/fs/seq_file.c
@@ -223,8 +223,10 @@ ssize_t seq_read(struct file *file, char
 		size -= n;
 		buf += n;
 		copied += n;
-		if (!m->count)
+		if (!m->count) {
+			m->from = 0;
 			m->index++;
+		}
 		if (!size)
 			goto Done;
 	}
_
