From: akpm@linux-foundation.org
Subject: - relayfs-fix-infinite-loop-with-splice.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:28:36 -0800
Message-ID: <200812101928.mBAJSaTp021267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381AbYLJT3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 14:29:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zanussi@comcast.net, mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi, tzanussi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     relayfs: fix infinite loop with splice()
has been removed from the -mm tree.  Its filename was
     relayfs-fix-infinite-loop-with-splice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relayfs: fix infinite loop with splice()
From: Tom Zanussi <zanussi@comcast.net>

Running kmemtraced, which uses splice() on relayfs, causes a hard lock on
x86-64 SMP.  As described by Tom Zanussi:

  It looks like you hit the same problem as described here:

  commit 8191ecd1d14c6914c660dfa007154860a7908857

      splice: fix infinite loop in generic_file_splice_read()

  relay uses the same loop but it never got noticed or fixed.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/relay.c~relayfs-fix-infinite-loop-with-splice kernel/relay.c
--- a/kernel/relay.c~relayfs-fix-infinite-loop-with-splice
+++ a/kernel/relay.c
@@ -1317,12 +1317,9 @@ static ssize_t relay_file_splice_read(st
 		if (ret < 0)
 			break;
 		else if (!ret) {
-			if (spliced)
-				break;
-			if (flags & SPLICE_F_NONBLOCK) {
+			if (flags & SPLICE_F_NONBLOCK)
 				ret = -EAGAIN;
-				break;
-			}
+			break;
 		}
 
 		*ppos += ret;
_

Patches currently in -mm which might be from zanussi@comcast.net are

origin.patch

