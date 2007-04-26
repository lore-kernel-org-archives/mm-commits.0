From: akpm@linux-foundation.org
Subject: - netlink-dont-reinitialize-callback-mutex.patch removed from -mm tree
Date: Wed, 25 Apr 2007 23:59:22 -0700
Message-ID: <200704260659.l3Q6xMfN023136@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933187AbXDZG71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 02:59:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     netlink: don't reinitialize callback mutex
has been removed from the -mm tree.  Its filename was
     netlink-dont-reinitialize-callback-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netlink: don't reinitialize callback mutex
From: Patrick McHardy <kaber@trash.net>

Don't reinitialize the callback mutex the netlink_kernel_create caller
handed in, it is supposed to already be initialized and could already be
held by someone.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netlink/af_netlink.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN net/netlink/af_netlink.c~netlink-dont-reinitialize-callback-mutex net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c~netlink-dont-reinitialize-callback-mutex
+++ a/net/netlink/af_netlink.c
@@ -388,8 +388,12 @@ static int __netlink_create(struct socke
 	sock_init_data(sock, sk);
 
 	nlk = nlk_sk(sk);
-	nlk->cb_mutex = cb_mutex ? : &nlk->cb_def_mutex;
-	mutex_init(nlk->cb_mutex);
+	if (cb_mutex)
+		nlk->cb_mutex = cb_mutex;
+	else {
+		nlk->cb_mutex = &nlk->cb_def_mutex;
+		mutex_init(nlk->cb_mutex);
+	}
 	init_waitqueue_head(&nlk->wait);
 
 	sk->sk_destruct = netlink_sock_destruct;
_

Patches currently in -mm which might be from kaber@trash.net are

networking-fix-sending-netlink-message-when-replace-route.patch
git-net.patch
