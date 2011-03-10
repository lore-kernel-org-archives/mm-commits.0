From: akpm@linux-foundation.org
Subject: [merged] sunrpc-propagate-errors-from-xs_bind-through-xs_create_sock.patch removed from -mm tree
Date: Thu, 10 Mar 2011 13:56:47 -0800
Message-ID: <201103102158.p2ALw39Y030781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082Ab1CJV6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Mar 2011 16:58:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, bfields@fieldses.org, davem@davemloft.net, maciej.rutecki@gmail.com, rjw@sisk.pl, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sunrpc: propagate errors from xs_bind() through xs_create_sock()
has been removed from the -mm tree.  Its filename was
     sunrpc-propagate-errors-from-xs_bind-through-xs_create_sock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: propagate errors from xs_bind() through xs_create_sock()
From: Ben Hutchings <bhutchings@solarflare.com>

xs_create_sock() is supposed to return a pointer or an ERR_PTR-encoded
error, but it currently returns 0 if xs_bind() fails.  This causes the
kernel to go BUG, as described in
https://bugzilla.kernel.org/show_bug.cgi?id=30322.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtsock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/sunrpc/xprtsock.c~sunrpc-propagate-errors-from-xs_bind-through-xs_create_sock net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~sunrpc-propagate-errors-from-xs_bind-through-xs_create_sock
+++ a/net/sunrpc/xprtsock.c
@@ -1631,7 +1631,8 @@ static struct socket *xs_create_sock(str
 	}
 	xs_reclassify_socket(family, sock);
 
-	if (xs_bind(transport, sock)) {
+	err = xs_bind(transport, sock);
+	if (err) {
 		sock_release(sock);
 		goto out;
 	}
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

linux-next.patch

