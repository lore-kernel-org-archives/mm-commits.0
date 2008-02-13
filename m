From: akpm@linux-foundation.org
Subject: + smack-check-for-struct-socket-with-null-sk.patch added to -mm tree
Date: Wed, 13 Feb 2008 00:10:02 -0800
Message-ID: <200802130811.m1D8BOx9015575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725AbYBMIL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 03:11:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, casey@schuafler-ca.com


The patch titled
     Smack: check for 'struct socket' with NULL sk
has been added to the -mm tree.  Its filename is
     smack-check-for-struct-socket-with-null-sk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Smack: check for 'struct socket' with NULL sk
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

There's a small problem with smack and NFS. A similar report was also
sent here: http://lkml.org/lkml/2007/10/27/85

I've also added similar checks in inode_{get/set}security().  Cheating from
SELinux post_create_socket(), it does the same.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Casey Schaufler <casey@schuafler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

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
@@ -1280,10 +1280,12 @@ static void smack_to_secattr(char *smack
  */
 static int smack_netlabel(struct sock *sk)
 {
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp;
 	struct netlbl_lsm_secattr secattr;
 	int rc = 0;
 
+	BUG_ON(sk == NULL);
+	ssp = sk->sk_security;
 	netlbl_secattr_init(&secattr);
 	smack_to_secattr(ssp->smk_out, &secattr);
 	if (secattr.flags != NETLBL_SECATTR_NONE)
@@ -1331,7 +1333,7 @@ static int smack_inode_setsecurity(struc
 		return -EOPNOTSUPP;
 
 	sock = SOCKET_I(inode);
-	if (sock == NULL)
+	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
 	ssp = sock->sk->sk_security;
@@ -1362,7 +1364,7 @@ static int smack_inode_setsecurity(struc
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
smack-check-for-struct-socket-with-null-sk.patch
smack-check-for-struct-socket-with-null-sk-fix.patch
git-kvm.patch
git-x86.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
