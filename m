From: akpm@linux-foundation.org
Subject: [merged] nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:29 -0700
Message-ID: <20120801201630.5259020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:52066 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2HAUQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:33 -0400
Received: by bkcjc3 with SMTP id jc3so345257bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: set SOCK_MEMALLOC for access to PFMEMALLOC reserves
has been removed from the -mm tree.  Its filename was
     nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: nbd: set SOCK_MEMALLOC for access to PFMEMALLOC reserves

Set SOCK_MEMALLOC on the NBD socket to allow access to PFMEMALLOC reserves
so pages backed by NBD, particularly if swap related, can be cleaned to
prevent the machine being deadlocked.  It is still possible that the
PFMEMALLOC reserves get depleted resulting in deadlock but this can be
resolved by the administrator by increasing min_free_kbytes.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/block/nbd.c~nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves
+++ a/drivers/block/nbd.c
@@ -154,6 +154,7 @@ static int sock_xmit(struct nbd_device *
 	struct msghdr msg;
 	struct kvec iov;
 	sigset_t blocked, oldset;
+	unsigned long pflags = current->flags;
 
 	if (unlikely(!sock)) {
 		dev_err(disk_to_dev(nbd->disk),
@@ -167,8 +168,9 @@ static int sock_xmit(struct nbd_device *
 	siginitsetinv(&blocked, sigmask(SIGKILL));
 	sigprocmask(SIG_SETMASK, &blocked, &oldset);
 
+	current->flags |= PF_MEMALLOC;
 	do {
-		sock->sk->sk_allocation = GFP_NOIO;
+		sock->sk->sk_allocation = GFP_NOIO | __GFP_MEMALLOC;
 		iov.iov_base = buf;
 		iov.iov_len = size;
 		msg.msg_name = NULL;
@@ -214,6 +216,7 @@ static int sock_xmit(struct nbd_device *
 	} while (size > 0);
 
 	sigprocmask(SIG_SETMASK, &oldset, NULL);
+	tsk_restore_flags(current, pflags, PF_MEMALLOC);
 
 	return result;
 }
@@ -405,6 +408,7 @@ static int nbd_do_it(struct nbd_device *
 
 	BUG_ON(nbd->magic != NBD_MAGIC);
 
+	sk_set_memalloc(nbd->sock->sk);
 	nbd->pid = task_pid_nr(current);
 	ret = device_create_file(disk_to_dev(nbd->disk), &pid_attr);
 	if (ret) {
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

