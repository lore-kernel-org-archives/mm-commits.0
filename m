From: akpm@osdl.org
Subject: - 9p-null-terminate-error-strings-for-debug-print.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:32:11 -0800
Message-ID: <200701270132.l0R1WBa4031906@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35536 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbXA0BcN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ericvh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     9p: null terminate error strings for debug print
has been removed from the -mm tree.  Its filename was
     9p-null-terminate-error-strings-for-debug-print.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 9p: null terminate error strings for debug print
From: Eric Van Hensbergen <ericvh@gmail.com>

We weren't properly NULL terminating protocol error strings for our debug
printk resulting in garbage being included in the output when debug was
enabled.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/9p/error.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/9p/error.c~9p-null-terminate-error-strings-for-debug-print fs/9p/error.c
--- a/fs/9p/error.c~9p-null-terminate-error-strings-for-debug-print
+++ a/fs/9p/error.c
@@ -83,6 +83,7 @@ int v9fs_errstr2errno(char *errstr, int 
 
 	if (errno == 0) {
 		/* TODO: if error isn't found, add it dynamically */
+		errstr[len] = 0;
 		printk(KERN_ERR "%s: errstr :%s: not found\n", __FUNCTION__,
 		       errstr);
 		errno = 1;
_

Patches currently in -mm which might be from ericvh@gmail.com are

origin.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
