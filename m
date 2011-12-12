From: akpm@linux-foundation.org
Subject: + ceph-cifs-nfs-fuse-boolean-and-or-confusion.patch added to -mm tree
Date: Mon, 12 Dec 2011 15:30:51 -0800
Message-ID: <201112122330.pBCNUpA9010353@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:61220 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1LLXa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2011 18:30:56 -0500
Received: by qadb14 with SMTP id b14so949078qad.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2011 15:30:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, Trond.Myklebust@netapp.com, miklos@szeredi.hu, sage@newdream.net, sfrench@samba.org


The patch titled
     Subject: ceph, cifs, nfs, fuse: boolean and / or confusion
has been added to the -mm tree.  Its filename is
     ceph-cifs-nfs-fuse-boolean-and-or-confusion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: roel <roel.kluin@gmail.com>
Subject: ceph, cifs, nfs, fuse: boolean and / or confusion

The test not SEEK_CUR or not SEEK_SET always evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Sage Weil <sage@newdream.net>
Cc: Steve French <sfrench@samba.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/file.c   |    2 +-
 fs/cifs/cifsfs.c |    2 +-
 fs/fuse/file.c   |    2 +-
 fs/nfs/file.c    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ceph/file.c~ceph-cifs-nfs-fuse-boolean-and-or-confusion fs/ceph/file.c
--- a/fs/ceph/file.c~ceph-cifs-nfs-fuse-boolean-and-or-confusion
+++ a/fs/ceph/file.c
@@ -797,7 +797,7 @@ static loff_t ceph_llseek(struct file *f
 
 	mutex_lock(&inode->i_mutex);
 	__ceph_do_pending_vmtruncate(inode);
-	if (origin != SEEK_CUR || origin != SEEK_SET) {
+	if (origin != SEEK_CUR && origin != SEEK_SET) {
 		ret = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE);
 		if (ret < 0) {
 			offset = ret;
diff -puN fs/cifs/cifsfs.c~ceph-cifs-nfs-fuse-boolean-and-or-confusion fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~ceph-cifs-nfs-fuse-boolean-and-or-confusion
+++ a/fs/cifs/cifsfs.c
@@ -703,7 +703,7 @@ static loff_t cifs_llseek(struct file *f
 	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
 	 * the cached file length
 	 */
-	if (origin != SEEK_SET || origin != SEEK_CUR) {
+	if (origin != SEEK_SET && origin != SEEK_CUR) {
 		int rc;
 		struct inode *inode = file->f_path.dentry->d_inode;
 
diff -puN fs/fuse/file.c~ceph-cifs-nfs-fuse-boolean-and-or-confusion fs/fuse/file.c
--- a/fs/fuse/file.c~ceph-cifs-nfs-fuse-boolean-and-or-confusion
+++ a/fs/fuse/file.c
@@ -1556,7 +1556,7 @@ static loff_t fuse_file_llseek(struct fi
 	struct inode *inode = file->f_path.dentry->d_inode;
 
 	mutex_lock(&inode->i_mutex);
-	if (origin != SEEK_CUR || origin != SEEK_SET) {
+	if (origin != SEEK_CUR && origin != SEEK_SET) {
 		retval = fuse_update_attributes(inode, NULL, file, NULL);
 		if (retval)
 			goto exit;
diff -puN fs/nfs/file.c~ceph-cifs-nfs-fuse-boolean-and-or-confusion fs/nfs/file.c
--- a/fs/nfs/file.c~ceph-cifs-nfs-fuse-boolean-and-or-confusion
+++ a/fs/nfs/file.c
@@ -147,7 +147,7 @@ static loff_t nfs_file_llseek(struct fil
 	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
 	 * the cached file length
 	 */
-	if (origin != SEEK_SET || origin != SEEK_CUR) {
+	if (origin != SEEK_SET && origin != SEEK_CUR) {
 		struct inode *inode = filp->f_mapping->host;
 
 		int retval = nfs_revalidate_file_size(inode, filp);
_
Subject: Subject: ceph, cifs, nfs, fuse: boolean and / or confusion

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
ceph-cifs-nfs-fuse-boolean-and-or-confusion.patch

