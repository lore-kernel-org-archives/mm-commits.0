From: akpm@linux-foundation.org
Subject: + net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch added to -mm tree
Date: Wed, 13 Jan 2010 12:54:35 -0800
Message-ID: <201001132054.o0DKsZON027880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755618Ab0AMUz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 15:55:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, Trond.Myklebust@netapp.com, bfields@fieldses.org, neilb@suse.de


The patch titled
     net/sunrpc: remove uses of NIPQUAD, use %pI4
has been added to the -mm tree.  Its filename is
     net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/sunrpc: remove uses of NIPQUAD, use %pI4
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/transport.c |    3 +--
 net/sunrpc/xprtsock.c           |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN net/sunrpc/xprtrdma/transport.c~net-sunrpc-remove-uses-of-nipquad-use-%pi4 net/sunrpc/xprtrdma/transport.c
--- a/net/sunrpc/xprtrdma/transport.c~net-sunrpc-remove-uses-of-nipquad-use-%pi4
+++ a/net/sunrpc/xprtrdma/transport.c
@@ -165,8 +165,7 @@ xprt_rdma_format_addresses(struct rpc_xp
 
 	xprt->address_strings[RPC_DISPLAY_PROTO] = "rdma";
 
-	(void)snprintf(buf, sizeof(buf), "%02x%02x%02x%02x",
-				NIPQUAD(sin->sin_addr.s_addr));
+	(void)snprintf(buf, sizeof(buf), "%08x", ntohl(sin->sin_addr.s_addr));
 	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] = kstrdup(buf, GFP_KERNEL);
 
 	(void)snprintf(buf, sizeof(buf), "%4hx", rpc_get_port(sap));
diff -puN net/sunrpc/xprtsock.c~net-sunrpc-remove-uses-of-nipquad-use-%pi4 net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~net-sunrpc-remove-uses-of-nipquad-use-%pi4
+++ a/net/sunrpc/xprtsock.c
@@ -297,12 +297,11 @@ static void xs_format_common_peer_addres
 	switch (sap->sa_family) {
 	case AF_INET:
 		sin = xs_addr_in(xprt);
-		(void)snprintf(buf, sizeof(buf), "%02x%02x%02x%02x",
-					NIPQUAD(sin->sin_addr.s_addr));
+		snprintf(buf, sizeof(buf), "%08x", ntohl(sin->sin_addr.s_addr));
 		break;
 	case AF_INET6:
 		sin6 = xs_addr_in6(xprt);
-		(void)snprintf(buf, sizeof(buf), "%pi6", &sin6->sin6_addr);
+		snprintf(buf, sizeof(buf), "%pi6", &sin6->sin6_addr);
 		break;
 	default:
 		BUG();
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch

