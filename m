From: akpm@linux-foundation.org
Subject: + netlink-dont-reinitialize-callback-mutex.patch added to -mm tree
Date: Wed, 25 Apr 2007 15:48:30 -0700
Message-ID: <200704252248.l3PMmUjp014956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423396AbXDYWsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 18:48:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaber@trash.net


The patch titled
     netlink: don't reinitialize callback mutex
has been added to the -mm tree.  Its filename is
     netlink-dont-reinitialize-callback-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
networking-fix-sending-netlink-message-when-replace-route.patch
git-net.patch
netlink-dont-reinitialize-callback-mutex.patch
