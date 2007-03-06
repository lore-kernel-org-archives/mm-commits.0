From: akpm@linux-foundation.org
Subject: - slim-secfs-inode-i_private-build-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:14:19 -0800
Message-ID: <200703060214.l262EJjG009086@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47226 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbXCFCOr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: secfs inode->i_private build fix
has been removed from the -mm tree.  Its filename was
     slim-secfs-inode-i_private-build-fix.patch

This patch was dropped because it was folded into slim-debug-output.patch

------------------------------------------------------
Subject: slim: secfs inode->i_private build fix
From: Kylene Jo Hall <kjhall@us.ibm.com>

Due to the change from inode->u.generic_ip to inode->i_private in the mm
tree.  The slim securityfs file had a compilation error.  This minor patch
fixes this issue.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_secfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/slim/slm_secfs.c~slim-secfs-inode-i_private-build-fix security/slim/slm_secfs.c
--- a/security/slim/slm_secfs.c~slim-secfs-inode-i_private-build-fix
+++ a/security/slim/slm_secfs.c
@@ -44,8 +44,8 @@ static ssize_t slm_read_level(struct fil
 
 static int slm_open_debug(struct inode *inode, struct file *file)
 {
-	if (inode->u.generic_ip)
-		file->private_data = inode->u.generic_ip;
+	if (inode->i_private)
+		file->private_data = inode->i_private;
 	return 0;
 }
 
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-secfs-inode-i_private-build-fix.patch
slim-documentation.patch
panic-on-slim-selinux.patch
