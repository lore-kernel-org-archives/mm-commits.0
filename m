From: akpm@linux-foundation.org
Subject: - smack-getpeercred_stream-fix-for-so_peersec-and-tcp.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:59:56 -0800
Message-ID: <200802040359.m143xbjW012808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260AbYBDEAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 23:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: casey@schaufler-ca.com, mm-commits@vger.kernel.org


The patch titled
     Smack getpeercred_stream fix for SO_PEERSEC and TCP
has been removed from the -mm tree.  Its filename was
     smack-getpeercred_stream-fix-for-so_peersec-and-tcp.patch

This patch was dropped because it was folded into smack-version-11c-simplified-mandatory-access-control-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Smack getpeercred_stream fix for SO_PEERSEC and TCP
From: Casey Schaufler <casey@schaufler-ca.com>

Collect the Smack label of the other end on connection so that
getsockopt(..., SO_PEERSEC, ...) can report it.  This is done in
smack_inet_conn_request().  Report the correct value in
smack_socket_getpeersec_stream().  Initialize the smk_packet field in the
socket blob.  Comment on the purpose of smk_packet in the header file and
remove the unused smk_depth field from the blob.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack.h     |    7 +++----
 security/smack/smack_lsm.c |   14 +++++++++++---
 2 files changed, 14 insertions(+), 7 deletions(-)

diff -puN security/smack/smack.h~smack-getpeercred_stream-fix-for-so_peersec-and-tcp security/smack/smack.h
--- a/security/smack/smack.h~smack-getpeercred_stream-fix-for-so_peersec-and-tcp
+++ a/security/smack/smack.h
@@ -44,10 +44,9 @@ struct superblock_smack {
 };
 
 struct socket_smack {
-	char		*smk_out;	/* outbound label */
-	char		*smk_in;	/* inbound label */
-	char		smk_packet[SMK_LABELLEN];
-	int		smk_depth;
+	char		*smk_out;			/* outbound label */
+	char		*smk_in;			/* inbound label */
+	char		smk_packet[SMK_LABELLEN];	/* TCP peer label */
 };
 
 /*
diff -puN security/smack/smack_lsm.c~smack-getpeercred_stream-fix-for-so_peersec-and-tcp security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-getpeercred_stream-fix-for-so_peersec-and-tcp
+++ a/security/smack/smack_lsm.c
@@ -1232,6 +1232,7 @@ static int smack_sk_alloc_security(struc
 
 	ssp->smk_in = csp;
 	ssp->smk_out = csp;
+	ssp->smk_packet[0] = '\0';
 
 	sk->sk_security = ssp;
 
@@ -2115,11 +2116,11 @@ static int smack_socket_getpeersec_strea
 	int rc = 0;
 
 	ssp = sock->sk->sk_security;
-	slen = strlen(ssp->smk_out);
+	slen = strlen(ssp->smk_packet) + 1;
 
 	if (slen > len)
 		rc = -ERANGE;
-	else if (copy_to_user(optval, ssp->smk_out, slen) != 0)
+	else if (copy_to_user(optval, ssp->smk_packet, slen) != 0)
 		rc = -EFAULT;
 
 	if (put_user(slen, optlen) != 0)
@@ -2251,8 +2252,15 @@ static int smack_inet_conn_request(struc
 	/*
 	 * Receiving a packet requires that the other end
 	 * be able to write here. Read access is not required.
+	 *
+	 * If the request is successful save the peer's label
+	 * so that SO_PEERCRED can report it.
 	 */
-	return smk_access(smack, ssp->smk_in, MAY_WRITE);
+	rc = smk_access(smack, ssp->smk_in, MAY_WRITE);
+	if (rc == 0)
+		strncpy(ssp->smk_packet, smack, SMK_MAXLEN);
+
+	return rc;
 }
 
 /*
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
capabilities-introduce-per-process-capability-bounding-set.patch
netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch
smack-version-11c-simplified-mandatory-access-control-kernel.patch
smack-getpeercred_stream-fix-for-so_peersec-and-tcp.patch
smack-socket-label-setting-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
