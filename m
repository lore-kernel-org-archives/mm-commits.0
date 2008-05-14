From: akpm@linux-foundation.org
Subject: + sctp-fix-use-of-uninitialized-pointer.patch added to -mm tree
Date: Tue, 13 May 2008 19:55:53 -0700
Message-ID: <200805140255.m4E2truq013046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757817AbYENCz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 22:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaber@trash.net


The patch titled
     sctp: fix use of uninitialized pointer
has been added to the -mm tree.  Its filename is
     sctp-fix-use-of-uninitialized-pointer.patch

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
