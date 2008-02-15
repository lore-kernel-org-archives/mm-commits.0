From: akpm@linux-foundation.org
Subject: - smack-unlabeled-outgoing-ambient-packets.patch removed from -mm tree
Date: Fri, 15 Feb 2008 11:18:33 -0800
Message-ID: <200802151918.m1FJIX5g019663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761381AbYBOTTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 14:19:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: casey@schaufler-ca.com, davem@davemloft.net, jmorris@namei.org, mingo@elte.hu, paul.moore@hp.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     Smack: unlabeled outgoing ambient packets
has been removed from the -mm tree.  Its filename was
     smack-unlabeled-outgoing-ambient-packets.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Smack: unlabeled outgoing ambient packets
From: Casey Schaufler <casey@schaufler-ca.com>

Smack uses CIPSO labeling, but allows for unlabeled packets by specifying
an "ambient" label that is applied to incoming unlabeled packets.  Because
the other end of the connection may dislike IP options, and ssh is one know
application that behaves thus, it is prudent to respond in kind.  This
patch changes the network labeling behavior such that an outgoing packet
that would be given a CIPSO label that matches the ambient label is left
unlabeled.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Paul Moore <paul.moore@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN security/smack/smack_lsm.c~smack-unlabeled-outgoing-ambient-packets security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-unlabeled-outgoing-ambient-packets
+++ a/security/smack/smack_lsm.c
@@ -1276,6 +1276,12 @@ static void smack_to_secattr(char *smack
  * Convert the outbound smack value (smk_out) to a
  * secattr and attach it to the socket.
  *
+ * If the label is the ambient label do not set the secattr.
+ * Thus, all ambient packets are unlabeled and all unlabeled
+ * packets are ambient. This permits unlabeled responces to
+ * unlabeled requests without knowing on a per-packet basis
+ * if the packet was labeled ambient or was unlabeled.
+ *
  * Returns 0 on success or an error code
  */
 static int smack_netlabel(struct sock *sk)
@@ -1285,6 +1291,8 @@ static int smack_netlabel(struct sock *s
 	int rc = 0;
 
 	ssp = sk->sk_security;
+	if (strncmp(ssp->smk_out, smack_net_ambient, SMK_MAXLEN) == 0)
+		return 0;
 	netlbl_secattr_init(&secattr);
 	smack_to_secattr(ssp->smk_out, &secattr);
 	if (secattr.flags != NETLBL_SECATTR_NONE)
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

origin.patch
smack-unlabeled-outgoing-ambient-packets.patch
