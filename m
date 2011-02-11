From: akpm@linux-foundation.org
Subject: [to-be-updated] loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v3.patch removed from -mm tree
Date: Fri, 11 Feb 2011 09:13:58 -0800
Message-ID: <201102111713.p1BHDwc3004678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757114Ab1BKROl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Feb 2011 12:14:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, jaxboe@fusionio.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     loop: queue_lock NULL pointer dereference in blk_throtl_exit
has been removed from the -mm tree.  Its filename was
     loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v3.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: loop: queue_lock NULL pointer dereference in blk_throtl_exit
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Performing
$ sudo mount -o loop -o umask=0 /dev/sdb1 /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

$ sudo modprobe -r loop

results in oops:

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
 IP: [<ffffffff812479d4>] do_raw_spin_lock+0x14/0x122
 Process modprobe (pid: 6189, threadinfo ffff88009a898000, task
 ffff880154a88000)
 Call Trace:
  [<ffffffff81486788>] _raw_spin_lock_irq+0x4a/0x51
  [<ffffffff8123404b>] ? blk_throtl_exit+0x3b/0xa0
  [<ffffffff8105b120>] ? cancel_delayed_work_sync+0xd/0xf
  [<ffffffff8123404b>] blk_throtl_exit+0x3b/0xa0
  [<ffffffff81229bc8>] blk_release_queue+0x21/0x65
  [<ffffffff8123bb06>] kobject_release+0x51/0x66
  [<ffffffff8123bab5>] ? kobject_release+0x0/0x66
  [<ffffffff8123ce1e>] kref_put+0x43/0x4d
  [<ffffffff8123ba27>] kobject_put+0x47/0x4b
  [<ffffffff8122717c>] blk_cleanup_queue+0x56/0x5b
  [<ffffffffa01c3824>] loop_exit+0x68/0x844 [loop]
  [<ffffffff8107cccc>] sys_delete_module+0x1e8/0x25b
  [<ffffffff814864c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff81002112>] system_call_fastpath+0x16/0x1b

because of an attempt to acquire NULL queue_lock.  Added the same lines as
in blk_queue_make_request - `fall back to embedded per-queue lock' - when
call blk_release_queue on allocated but not initialized queue.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-sysfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN block/blk-sysfs.c~loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v3 block/blk-sysfs.c
--- a/block/blk-sysfs.c~loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v3
+++ a/block/blk-sysfs.c
@@ -471,6 +471,12 @@ static void blk_release_queue(struct kob
 
 	blk_sync_queue(q);
 
+	/* It's possible that blk_release_queue will be called on allocated
+	 * but never initilalized queue. Fall back to our embedded per-queue
+	 * locks in this case. */
+	if (!q->queue_lock)
+		q->queue_lock = &q->__queue_lock;
+
 	blk_throtl_exit(q);
 
 	if (rl->rq_pool)
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
block-fix-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v4.patch

