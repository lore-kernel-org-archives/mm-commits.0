From: akpm@linux-foundation.org
Subject: - allow-executables-larger-than-2gb.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:38 -0800
Message-ID: <200802082016.m18KGJsG010706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490AbYBHUyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:54:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@suse.de, anderson@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Allow executables larger than 2GB
has been removed from the -mm tree.  Its filename was
     allow-executables-larger-than-2gb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Allow executables larger than 2GB
From: Andi Kleen <andi@firstfloor.org>

This allows us to use executables >2GB.

Based on a patch by Dave Anderson

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Dave Anderson <anderson@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~allow-executables-larger-than-2gb fs/exec.c
--- a/fs/exec.c~allow-executables-larger-than-2gb
+++ a/fs/exec.c
@@ -119,7 +119,7 @@ asmlinkage long sys_uselib(const char __
 	if (error)
 		goto exit;
 
-	file = nameidata_to_filp(&nd, O_RDONLY);
+	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out;
@@ -658,7 +658,8 @@ struct file *open_exec(const char *name)
 			int err = vfs_permission(&nd, MAY_EXEC);
 			file = ERR_PTR(err);
 			if (!err) {
-				file = nameidata_to_filp(&nd, O_RDONLY);
+				file = nameidata_to_filp(&nd,
+							O_RDONLY|O_LARGEFILE);
 				if (!IS_ERR(file)) {
 					err = deny_write_access(file);
 					if (err) {
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
git-x86.patch
