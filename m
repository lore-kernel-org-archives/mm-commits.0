From: akpm@linux-foundation.org
Subject: + proc-remove-useless-checks-in-proc_register.patch added to -mm tree
Date: Fri, 16 Nov 2007 13:50:58 -0800
Message-ID: <200711162150.lAGLow7v005315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759283AbXKPVvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 16:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     proc: remove useless checks in proc_register()
has been added to the -mm tree.  Its filename is
     proc-remove-useless-checks-in-proc_register.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: remove useless checks in proc_register()
From: Alexey Dobriyan <adobriyan@sw.ru>

Before proc_register() all PDEs are created by proc_create() which doesn't set
->proc_iops and ->proc_fops -- they're NULL.  So those branches in
proc_register() are always taken.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN fs/proc/generic.c~proc-remove-useless-checks-in-proc_register fs/proc/generic.c
--- a/fs/proc/generic.c~proc-remove-useless-checks-in-proc_register
+++ a/fs/proc/generic.c
@@ -526,19 +526,14 @@ static int proc_register(struct proc_dir
 	dp->low_ino = i;
 
 	if (S_ISDIR(dp->mode)) {
-		if (dp->proc_iops == NULL) {
-			dp->proc_fops = &proc_dir_operations;
-			dp->proc_iops = &proc_dir_inode_operations;
-		}
+		dp->proc_fops = &proc_dir_operations;
+		dp->proc_iops = &proc_dir_inode_operations;
 		dir->nlink++;
 	} else if (S_ISLNK(dp->mode)) {
-		if (dp->proc_iops == NULL)
-			dp->proc_iops = &proc_link_inode_operations;
+		dp->proc_iops = &proc_link_inode_operations;
 	} else if (S_ISREG(dp->mode)) {
-		if (dp->proc_fops == NULL)
-			dp->proc_fops = &proc_file_operations;
-		if (dp->proc_iops == NULL)
-			dp->proc_iops = &proc_file_inode_operations;
+		dp->proc_fops = &proc_file_operations;
+		dp->proc_iops = &proc_file_inode_operations;
 	}
 
 	spin_lock(&proc_subdir_lock);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
proc-remove-module_license.patch
proc-less-lock-operations-during-lookup.patch
proc-simplify-function-prototypes.patch
proc-remove-useless-check-on-symlink-removal.patch
proc-remove-useless-checks-in-proc_register.patch
single_open-seq_release-leak-diagnostics.patch
