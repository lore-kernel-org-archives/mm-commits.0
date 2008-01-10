From: akpm@linux-foundation.org
Subject: + allow-executables-larger-than-2gb.patch added to -mm tree
Date: Thu, 10 Jan 2008 11:05:55 -0800
Message-ID: <200801101905.m0AJ5ZwI004561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYAJTGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 14:06:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@suse.de, anderson@redhat.com


The patch titled
     Allow executables larger than 2GB
has been added to the -mm tree.  Its filename is
     allow-executables-larger-than-2gb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

allow-executables-larger-than-2gb.patch
