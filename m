From: akpm@linux-foundation.org
Subject: + coda-add-static-to-functions-in-dirc.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:09:04 -0800
Message-ID: <200802152109.m1FL94bR024095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757980AbYBOVJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:09:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, jaharkes@cs.cmu.edu


The patch titled
     coda: add static to functions in dir.c
has been added to the -mm tree.  Its filename is
     coda-add-static-to-functions-in-dirc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coda: add static to functions in dir.c
From: Harvey Harrison <harvey.harrison@gmail.com>

coda_unlink, coda_rmdir, coda_readdir can all be static, the forward
declarations already were.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/coda/dir.c~coda-add-static-to-functions-in-dirc fs/coda/dir.c
--- a/fs/coda/dir.c~coda-add-static-to-functions-in-dirc
+++ a/fs/coda/dir.c
@@ -345,7 +345,7 @@ static int coda_symlink(struct inode *di
 }
 
 /* destruction routines: unlink, rmdir */
-int coda_unlink(struct inode *dir, struct dentry *de)
+static int coda_unlink(struct inode *dir, struct dentry *de)
 {
         int error;
 	const char *name = de->d_name.name;
@@ -365,7 +365,7 @@ int coda_unlink(struct inode *dir, struc
 	return 0;
 }
 
-int coda_rmdir(struct inode *dir, struct dentry *de)
+static int coda_rmdir(struct inode *dir, struct dentry *de)
 {
 	const char *name = de->d_name.name;
 	int len = de->d_name.len;
@@ -424,7 +424,7 @@ static int coda_rename(struct inode *old
 
 
 /* file operations for directories */
-int coda_readdir(struct file *coda_file, void *buf, filldir_t filldir)
+static int coda_readdir(struct file *coda_file, void *buf, filldir_t filldir)
 {
 	struct coda_file_info *cfi;
 	struct file *host_file;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
