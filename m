From: akpm@linux-foundation.org
Subject: - smack-check-for-struct-socket-with-null-sk.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:11 -0500
Message-ID: <200802150226.m1F2QUgQ015228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762230AbYBOC0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, casey@schuafler-ca.com, mm-commits@vger.kernel.org


The patch titled
     Smack: check for 'struct socket' with NULL sk
has been removed from the -mm tree.  Its filename was
     smack-check-for-struct-socket-with-null-sk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Smack: check for 'struct socket' with NULL sk
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

There's a small problem with smack and NFS. A similar report was also
sent here: http://lkml.org/lkml/2007/10/27/85

I've also added similar checks in inode_{get/set}security().  Cheating from
SELinux post_create_socket(), it does the same.

[akpm@linux-foundation.org: remove uneeded BUG_ON()]
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Casey Schaufler <casey@schuafler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN security/smack/smack_lsm.c~smack-check-for-struct-socket-with-null-sk security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-check-for-struct-socket-with-null-sk
+++ a/security/smack/smack_lsm.c
@@ -701,7 +701,7 @@ static int smack_inode_getsecurity(const
 		return -EOPNOTSUPP;
 
 	sock = SOCKET_I(ip);
-	if (sock == NULL)
+	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
 	ssp = sock->sk->sk_security;
@@ -1280,10 +1280,11 @@ static void smack_to_secattr(char *smack
  */
 static int smack_netlabel(struct sock *sk)
 {
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp;
 	struct netlbl_lsm_secattr secattr;
 	int rc = 0;
 
+	ssp = sk->sk_security;
 	netlbl_secattr_init(&secattr);
 	smack_to_secattr(ssp->smk_out, &secattr);
 	if (secattr.flags != NETLBL_SECATTR_NONE)
@@ -1331,7 +1332,7 @@ static int smack_inode_setsecurity(struc
 		return -EOPNOTSUPP;
 
 	sock = SOCKET_I(inode);
-	if (sock == NULL)
+	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
 	ssp = sock->sk->sk_security;
@@ -1362,7 +1363,7 @@ static int smack_inode_setsecurity(struc
 static int smack_socket_post_create(struct socket *sock, int family,
 				    int type, int protocol, int kern)
 {
-	if (family != PF_INET)
+	if (family != PF_INET || sock->sk == NULL)
 		return 0;
 	/*
 	 * Set the outbound netlbl.
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-kvm.patch
