From: akpm@linux-foundation.org
Subject: - netlink-remove-bogus-bug_on.patch removed from -mm tree
Date: Sun, 06 May 2007 23:49:55 -0700
Message-ID: <200705070649.l476ntxN020506@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089AbXEGGuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     NETLINK: Remove bogus BUG_ON
has been removed from the -mm tree.  Its filename was
     netlink-remove-bogus-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NETLINK: Remove bogus BUG_ON
From: Patrick McHardy <kaber@trash.net>

Remove bogus BUG_ON(mutex_is_locked(nlk_sk(sk)->cb_mutex)), when the
netlink_kernel_create caller specifies an external mutex it might
validly be locked.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netlink/af_netlink.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN net/netlink/af_netlink.c~netlink-remove-bogus-bug_on net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c~netlink-remove-bogus-bug_on
+++ a/net/netlink/af_netlink.c
@@ -142,7 +142,6 @@ static void netlink_sock_destruct(struct
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
 
-	BUG_ON(mutex_is_locked(nlk_sk(sk)->cb_mutex));
 	if (nlk->cb) {
 		if (nlk->cb->done)
 			nlk->cb->done(nlk->cb);
_

Patches currently in -mm which might be from kaber@trash.net are

origin.patch
networking-fix-sending-netlink-message-when-replace-route.patch
