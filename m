From: akpm@linux-foundation.org
Subject: [alternative-merged] sunrpc-fix-build-time-warning.patch removed from -mm tree
Date: Thu, 07 Jan 2010 12:59:47 -0800
Message-ID: <201001072059.o07KxlHU017200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab0AGVAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 16:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, sfr@canb.auug.org.au, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sunrpc: fix build-time warning
has been removed from the -mm tree.  Its filename was
     sunrpc-fix-build-time-warning.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: fix build-time warning
From: Jeff Layton <jlayton@redhat.com>

Commit 486bad2e40e938cd68fd853b7a9fa3115a9d3a4a ("sunrpc: on successful
gss error pipe write, don't return error") introduced this warning at
build time on some 32-bit architectures:

net/sunrpc/auth_gss/auth_gss.c: In function 'gss_pipe_downcall':
net/sunrpc/auth_gss/auth_gss.c:660: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t

...fix it by changing the length modifier in the printk.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/auth_gss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sunrpc/auth_gss/auth_gss.c~sunrpc-fix-build-time-warning net/sunrpc/auth_gss/auth_gss.c
--- a/net/sunrpc/auth_gss/auth_gss.c~sunrpc-fix-build-time-warning
+++ a/net/sunrpc/auth_gss/auth_gss.c
@@ -657,7 +657,7 @@ gss_pipe_downcall(struct file *filp, con
 			break;
 		default:
 			printk(KERN_CRIT "%s: bad return from "
-				"gss_fill_context: %ld\n", __func__, err);
+				"gss_fill_context: %Zd\n", __func__, err);
 			BUG();
 		}
 		goto err_release_msg;
_

Patches currently in -mm which might be from jlayton@redhat.com are

linux-next.patch
sunrpc-fix-build-time-warning.patch

