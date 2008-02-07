From: akpm@linux-foundation.org
Subject: + smack-unlabeled-outgoing-ambient-packets.patch added to -mm tree
Date: Thu, 07 Feb 2008 11:02:06 -0800
Message-ID: <200802071901.m17J1lAY016751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758803AbYBGTDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2008 14:03:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: casey@schaufler-ca.com, davem@davemloft.net, jmorris@namei.org, mingo@elte.hu, paul.moore@hp.com, sds@tycho.nsa.gov


The patch titled
     Smack: unlabeled outgoing ambient packets
has been added to the -mm tree.  Its filename is
     smack-unlabeled-outgoing-ambient-packets.patch

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

 security/smack/smack_lsm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

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
@@ -1284,6 +1290,9 @@ static int smack_netlabel(struct sock *s
 	struct netlbl_lsm_secattr secattr;
 	int rc = 0;
 
+	if (strncmp(ssp->smk_out, smack_net_ambient, SMK_MAXLEN) == 0)
+		return 0;
+
 	netlbl_secattr_init(&secattr);
 	smack_to_secattr(ssp->smk_out, &secattr);
 	if (secattr.flags != NETLBL_SECATTR_NONE)
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

origin.patch
smack-unlabeled-outgoing-ambient-packets.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
