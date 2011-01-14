From: akpm@linux-foundation.org
Subject: + loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit.patch added to -mm tree
Date: Fri, 14 Jan 2011 15:21:50 -0800
Message-ID: <201101142321.p0ENLpjE006902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752967Ab1ANXVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 18:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, axboe@kernel.dk


The patch titled
     loop: queue_lock NULL pointer derefence in blk_throtl_exit
has been added to the -mm tree.  Its filename is
     loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: loop: queue_lock NULL pointer derefence in blk_throtl_exit
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
 Process modprobe (pid: 6189, threadinfo ffff88009a898000, task ffff880154a88000)
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

because of an attempt to acquire NULL queue_lock.
I added the same lines as in blk_queue_make_request -
index 44e18c0..49e6a54 100644`fall back to embedded per-queue lock'.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/block/loop.c~loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit drivers/block/loop.c
--- a/drivers/block/loop.c~loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit
+++ a/drivers/block/loop.c
@@ -1641,6 +1641,9 @@ out:
 
 static void loop_free(struct loop_device *lo)
 {
+	if (!lo->lo_queue->queue_lock)
+		lo->lo_queue->queue_lock = &lo->lo_queue->__queue_lock;
+
 	blk_cleanup_queue(lo->lo_queue);
 	put_disk(lo->lo_disk);
 	list_del(&lo->lo_list);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit.patch

