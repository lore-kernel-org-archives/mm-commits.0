From: akpm@linux-foundation.org
Subject: - coda-add-static-to-functions-in-dirc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:00 -0700
Message-ID: <200804300539.m3U5d0GQ028792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbYD3FjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: add static to functions in dir.c
has been removed from the -mm tree.  Its filename was
     coda-add-static-to-functions-in-dirc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

