From: akpm@osdl.org
Subject: + 9p-null-terminate-error-strings-for-debug-print.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:15:54 -0800
Message-ID: <200701240715.l0O7Fstu011378@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933118AbXAXHP4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:15:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ericvh@gmail.com


The patch titled
     9p: null terminate error strings for debug print
has been added to the -mm tree.  Its filename is
     9p-null-terminate-error-strings-for-debug-print.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

9p-fix-bogus-return-code-checks-during-initialization.patch
9p-fix-rename-return-code.patch
9p-update-documentation-regarding-server-applications.patch
9p-fix-segfault-caused-by-race-condition-in-meta-data-operations.patch
9p-null-terminate-error-strings-for-debug-print.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
