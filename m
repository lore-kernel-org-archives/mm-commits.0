From: akpm@linux-foundation.org
Subject: [to-be-updated] ipc-msgc-fix-memory-leak-in-do_msgsnd.patch
 removed from -mm tree
Date: Mon, 01 Aug 2016 17:23:27 -0700
Message-ID: <579fe7ff.s5C4KTFgIKileXjV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbcHBAY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 20:24:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg.c: fix memory leak in do_msgsnd()
has been removed from the -mm tree.  Its filename was
     ipc-msgc-fix-memory-leak-in-do_msgsnd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ipc/msg.c: fix memory leak in do_msgsnd()

Running LTP msgsnd06 with kmemleak gives the following:

cat /sys/kernel/debug/kmemleak

unreferenced object 0xffff88003c0a11f8 (size 8):
  comm "msgsnd06", pid 1645, jiffies 4294672526 (age 6.549s)
  hex dump (first 8 bytes):
    1b 00 00 00 01 00 00 00                          ........
  backtrace:
    [<ffffffff818e2c43>] kmemleak_alloc+0x23/0x40
    [<ffffffff81177f31>] kmem_cache_alloc_trace+0xe1/0x180
    [<ffffffff812d42af>] selinux_msg_queue_alloc_security+0x3f/0xd0
    [<ffffffff812cc6be>] security_msg_queue_alloc+0x2e/0x40
    [<ffffffff812b94ee>] newque+0x4e/0x150
    [<ffffffff812b8cb9>] ipcget+0x159/0x1b0
    [<ffffffff812b98d9>] SyS_msgget+0x39/0x40
    [<ffffffff818e7bdb>] entry_SYSCALL_64_fastpath+0x13/0x8f
    [<ffffffffffffffff>] 0xffffffffffffffff

ipc_rcu_free() was given to ipc_rcu_putref() instead of msg_rcu_free()
which does security cleaning.

Link: http://lkml.kernel.org/r/1469780120-315-1-git-send-email-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/msg.c~ipc-msgc-fix-memory-leak-in-do_msgsnd ipc/msg.c
--- a/ipc/msg.c~ipc-msgc-fix-memory-leak-in-do_msgsnd
+++ a/ipc/msg.c
@@ -680,7 +680,7 @@ long do_msgsnd(int msqid, long mtype, vo
 		rcu_read_lock();
 		ipc_lock_object(&msq->q_perm);
 
-		ipc_rcu_putref(msq, ipc_rcu_free);
+		ipc_rcu_putref(msq, msg_rcu_free);
 		/* raced with RMID? */
 		if (!ipc_valid_object(&msq->q_perm)) {
 			err = -EIDRM;
_

Patches currently in -mm which might be from fabf@skynet.be are

sysv-ipc-fix-security-layer-leaking.patch
treewide-replace-obsolete-_refok-by-__ref.patch

