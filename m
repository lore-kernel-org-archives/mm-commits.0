From: akpm@linux-foundation.org
Subject: + sctp-prevent-reading-out-of-bounds-memory.patch added to -mm tree
Date: Mon, 13 Sep 2010 16:42:24 -0700
Message-ID: <201009132342.o8DNgOBJ028151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab0IMXm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 19:42:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.rosenberg@gmail.com, davem@davemloft.net, vladislav.yasevich@hp.com


The patch titled
     sctp: prevent reading out-of-bounds memory
has been added to the -mm tree.  Its filename is
     sctp-prevent-reading-out-of-bounds-memory.patch

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
Subject: sctp: prevent reading out-of-bounds memory
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

Two user-controlled allocations in SCTP are subsequently dereferenced as
sockaddr structs, without checking if the dereferenced struct members fall
beyond the end of the allocated chunk.  There doesn't appear to be any
information leakage here based on how these members are used and
additional checking, but it's still worth fixing.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/socket.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN net/sctp/socket.c~sctp-prevent-reading-out-of-bounds-memory net/sctp/socket.c
--- a/net/sctp/socket.c~sctp-prevent-reading-out-of-bounds-memory
+++ a/net/sctp/socket.c
@@ -918,6 +918,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
+
+               if (walk_size + sizeof(sa_family_t) > addrs_size) {
+                       kfree(kaddrs);
+                       return -EINVAL;
+               }
+
 		sa_addr = (struct sockaddr *)addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa_family);
 
@@ -1004,9 +1010,14 @@ static int __sctp_connect(struct sock* s
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
+
+               if (walk_size + sizeof(sa_family_t) > addrs_size) {
+                       err = -EINVAL;
+                       goto out_free;
+               }
+
 		sa_addr = (union sctp_addr *)addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa.sa_family);
-		port = ntohs(sa_addr->v4.sin_port);
 
 		/* If the address family is not supported or if this address
 		 * causes the address buffer to overflow return EINVAL.
@@ -1016,6 +1027,8 @@ static int __sctp_connect(struct sock* s
 			goto out_free;
 		}
 
+               port = ntohs(sa_addr->v4.sin_port);
+
 		/* Save current address so we can work with it */
 		memcpy(&to, sa_addr, af->sockaddr_len);
 
_

Patches currently in -mm which might be from dan.j.rosenberg@gmail.com are

linux-next.patch
sctp-prevent-reading-out-of-bounds-memory.patch
sctp-prevent-reading-out-of-bounds-memory-cleanup.patch

