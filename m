From: akpm@linux-foundation.org
Subject: - autofs4-fix-string-validation-check-order.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:47 -0800
Message-ID: <200901072218.n07MIlZH018190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763147AbZAGWgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:36:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix string validation check order
has been removed from the -mm tree.  Its filename was
     autofs4-fix-string-validation-check-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix string validation check order
From: Ian Kent <raven@themaw.net>

In function validate_dev_ioctl() we check that the string we've been sent
is a valid path.  The function that does this check assumes the string is
NULL terminated but our NULL termination check isn't done until after this
call.  This patch changes the order of the check.

Signed-off-by: Ian Kent <raven@themaw.net>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs4-fix-string-validation-check-order fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-fix-string-validation-check-order
+++ a/fs/autofs4/dev-ioctl.c
@@ -124,7 +124,7 @@ static inline void free_dev_ioctl(struct
 
 /*
  * Check sanity of parameter control fields and if a path is present
- * check that it has a "/" and is terminated.
+ * check that it is terminated and contains at least one "/".
  */
 static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 {
@@ -138,15 +138,16 @@ static int validate_dev_ioctl(int cmd, s
 	}
 
 	if (param->size > sizeof(*param)) {
-		err = check_name(param->path);
+		err = invalid_str(param->path,
+				 (void *) ((size_t) param + param->size));
 		if (err) {
-			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
-				    cmd);
+			AUTOFS_WARN(
+			  "path string terminator missing for cmd(0x%08x)",
+			  cmd);
 			goto out;
 		}
 
-		err = invalid_str(param->path,
-				 (void *) ((size_t) param + param->size));
+		err = check_name(param->path);
 		if (err) {
 			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
 				    cmd);
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch

