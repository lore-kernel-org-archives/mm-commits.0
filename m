From: akpm@linux-foundation.org
Subject: [merged]
 net-xfrm_user-use-in_compat_syscall-to-deny-compat-syscalls.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 10:40:49 -0700
Message-ID: <56f2d521.FB1KaZncmxzi/G+v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbcCWRku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, davem@davemloft.net, herbert@gondor.apana.org.au, steffen.klassert@secunet.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/xfrm_user: use in_compat_syscall to deny compat syscalls
has been removed from the -mm tree.  Its filename was
     net-xfrm_user-use-in_compat_syscall-to-deny-compat-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: net/xfrm_user: use in_compat_syscall to deny compat syscalls

The code wants to prevent compat code from receiving messages.  Use
in_compat_syscall for this.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/xfrm/xfrm_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/xfrm/xfrm_user.c~net-xfrm_user-use-in_compat_syscall-to-deny-compat-syscalls net/xfrm/xfrm_user.c
--- a/net/xfrm/xfrm_user.c~net-xfrm_user-use-in_compat_syscall-to-deny-compat-syscalls
+++ a/net/xfrm/xfrm_user.c
@@ -2449,7 +2449,7 @@ static int xfrm_user_rcv_msg(struct sk_b
 	int type, err;
 
 #ifdef CONFIG_COMPAT
-	if (is_compat_task())
+	if (in_compat_syscall())
 		return -ENOTSUPP;
 #endif
 
_

Patches currently in -mm which might be from luto@kernel.org are


