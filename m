From: akpm@linux-foundation.org
Subject: - net-sunrpc-svcsockc-dont-print-uninitialised-string.patch removed from -mm tree
Date: Tue, 11 Sep 2007 13:21:11 -0700
Message-ID: <200709112021.l8BKLBC0027767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760528AbXIKUWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 16:22:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wolfgang.walter@studentenwerk.mhn.de, bfields@fieldses.org, davem@davemloft.net, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     net/sunrpc/svcsock.c: don't print uninitialised string
has been removed from the -mm tree.  Its filename was
     net-sunrpc-svcsockc-dont-print-uninitialised-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/sunrpc/svcsock.c: don't print uninitialised string
From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>

Random characters are printed by svc_tcp_accept:

	lockd: last TCP connect from <some random chars>

because buf is used unitialized:

printk(KERN_NOTICE
	"%s: last TCP connect from %s\n",
	serv->sv_name, buf);

Probably it should be

printk(KERN_NOTICE
	"%s: last TCP connect from %s\n",
	serv->sv_name, __svc_print_addr(sin, buf, sizeof(buf)));

Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/sunrpc/svcsock.c~net-sunrpc-svcsockc-dont-print-uninitialised-string net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~net-sunrpc-svcsockc-dont-print-uninitialised-string
+++ a/net/sunrpc/svcsock.c
@@ -1111,7 +1111,8 @@ svc_tcp_accept(struct svc_sock *svsk)
 						   serv->sv_name);
 				printk(KERN_NOTICE
 				       "%s: last TCP connect from %s\n",
-				       serv->sv_name, buf);
+				       serv->sv_name,
+				       __svc_print_addr(sin, buf, sizeof(buf)));
 			}
 			/*
 			 * Always select the oldest socket. It's not fair,
_

Patches currently in -mm which might be from wolfgang.walter@studentenwerk.mhn.de are

git-nfsd.patch
