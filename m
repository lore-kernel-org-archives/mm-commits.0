From: akpm@linux-foundation.org
Subject: - sctp-fix-use-of-uninitialized-pointer.patch removed from -mm tree
Date: Wed, 14 May 2008 14:22:08 -0700
Message-ID: <200805142122.m4ELM8sm021571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbYENVWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 17:22:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     sctp: fix use of uninitialized pointer
has been removed from the -mm tree.  Its filename was
     sctp-fix-use-of-uninitialized-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sctp: fix use of uninitialized pointer
From: Patrick McHardy <kaber@trash.net>

Introduced by c4492586 (sctp: Add address type check while process
paramaters of ASCONF chunk):

net/sctp/sm_make_chunk.c: In function 'sctp_process_asconf':
net/sctp/sm_make_chunk.c:2828: warning: 'addr_param' may be used uninitialized in this function
net/sctp/sm_make_chunk.c:2828: note: 'addr_param' was declared here

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/sm_make_chunk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/sctp/sm_make_chunk.c~sctp-fix-use-of-uninitialized-pointer net/sctp/sm_make_chunk.c
--- a/net/sctp/sm_make_chunk.c~sctp-fix-use-of-uninitialized-pointer
+++ a/net/sctp/sm_make_chunk.c
@@ -2827,6 +2827,9 @@ static __be16 sctp_process_asconf_param(
 	union sctp_addr	addr;
 	union sctp_addr_param *addr_param;
 
+	addr_param = (union sctp_addr_param *)
+			((void *)asconf_param + sizeof(sctp_addip_param_t));
+
 	switch (addr_param->v4.param_hdr.type) {
 	case SCTP_PARAM_IPV6_ADDRESS:
 		if (!asoc->peer.ipv6_address)
@@ -2840,9 +2843,6 @@ static __be16 sctp_process_asconf_param(
 		return SCTP_ERROR_INV_PARAM;
 	}
 
-	addr_param = (union sctp_addr_param *)
-			((void *)asconf_param + sizeof(sctp_addip_param_t));
