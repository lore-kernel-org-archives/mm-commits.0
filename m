From: akpm@linux-foundation.org
Subject: + net-sunrpc-svcsockc-dont-print-uninitialised-string.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:00:49 -0700
Message-ID: <200709110500.l8B50nMp026395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47102 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbXIKFBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:01:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wolfgang.walter@studentenwerk.mhn.de, akpm@linux-foundation.org, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     net/sunrpc/svcsock.c: don't print uninitialised string
has been added to the -mm tree.  Its filename is
     net-sunrpc-svcsockc-dont-print-uninitialised-string.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

net-sunrpc-svcsockc-dont-print-uninitialised-string.patch
