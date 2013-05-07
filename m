From: akpm@linux-foundation.org
Subject: [merged] kernel-relayc-move-remove_buf_file-inside-relay_close_buf.patch removed from -mm tree
Date: Tue, 07 May 2013 10:52:39 -0700
Message-ID: <20130507175239.A8E845A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:53748 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759621Ab3EGRwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:52:40 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so86596ggl.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:52:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, axboe@kernel.dk, edumazet@google.com, jovi.zhangwei@huawei.com, mingo@elte.hu, rostedt@goodmis.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: move remove_buf_file inside relay_close_buf()
has been removed from the -mm tree.  Its filename was
     kernel-relayc-move-remove_buf_file-inside-relay_close_buf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: kernel/relay.c: move remove_buf_file inside relay_close_buf()

Currently remove_buf_file callback is called from from kobject
release method. This result in follow issue:
# blktrace -d /dev/sda1 -d /dev/sda -o test

blktrace_setup()
 dir = create_dir()
 rchan = relay_open(dir,...)
 ->create_buf_file_callback
    buf_file  = debugfs_create_file(dir, )

Userspace will open buf_file.
Later we make a decision to stop tracing
blktrace_down()
  relay_close(rhcan)  /* just decrement kobj reference  */
                      /* since it is not zero then callback not called */
  debugfs_remove(dir) /* FAIL due to non empty dir   */

Later user space will close the file and file will be deleted,
but directory still exist.
user_space_close()
 ->file_release
   ->release_buf_file_callback
     ->debugfs_remove(buf_file
## TESTCASE:
# blktrace -d /dev/sda1 -d /dev/sda -o test
# After that blktrace infrastructure will remain broken in
# an unusable state so: blktrace -d /dev/sda1 will not work.

In fact this is general issue, blktrace is just one of examples.
We can not reliably remove parent dir until all users close the
buf_file.

Solution: We don't have to wait that long. File should be deleted inside
relay_close_buf().

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/relay.c~kernel-relayc-move-remove_buf_file-inside-relay_close_buf kernel/relay.c
--- a/kernel/relay.c~kernel-relayc-move-remove_buf_file-inside-relay_close_buf
+++ a/kernel/relay.c
@@ -234,7 +234,6 @@ static void relay_destroy_buf(struct rch
 static void relay_remove_buf(struct kref *kref)
 {
 	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
-	buf->chan->cb->remove_buf_file(buf->dentry);
 	relay_destroy_buf(buf);
 }
 
@@ -489,6 +488,7 @@ static void relay_close_buf(struct rchan
 {
 	buf->finalized = 1;
 	del_timer_sync(&buf->timer);
+	buf->chan->cb->remove_buf_file(buf->dentry);
 	kref_put(&buf->kref, relay_remove_buf);
 }
 
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
linux-next.patch

