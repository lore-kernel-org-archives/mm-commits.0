From: akpm@linux-foundation.org
Subject: + d_path-kerneldoc-cleanup.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:04:16 -0800
Message-ID: <200711052104.lA5L4GTJ019644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795AbXKEVEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:04:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, bfields@fieldses.org, hch@infradead.org, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     d_path: kerneldoc cleanup
has been added to the -mm tree.  Its filename is
     d_path-kerneldoc-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: d_path: kerneldoc cleanup
From: Jan Blunck <jblunck@suse.de>

Move and update d_path() kernel API documentation.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN fs/dcache.c~d_path-kerneldoc-cleanup fs/dcache.c
--- a/fs/dcache.c~d_path-kerneldoc-cleanup
+++ a/fs/dcache.c
@@ -1846,9 +1846,22 @@ Elong:
 	return ERR_PTR(-ENAMETOOLONG);
 }
 
-/* write full pathname into buffer and return start of pathname */
-char * d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-				char *buf, int buflen)
+/**
+ * d_path - return the path of a dentry
+ * @dentry: dentry to report
+ * @vfsmnt: vfsmnt to which the dentry belongs
+ * @buf: buffer to return value in
+ * @buflen: buffer length
+ *
+ * Convert a dentry into an ASCII path name. If the entry has been deleted
+ * the string " (deleted)" is appended. Note that this is ambiguous.
+ *
+ * Returns the buffer or an error code if the path was too long.
+ *
+ * "buflen" should be positive. Caller holds the dcache_lock.
+ */
+char *d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+	     char *buf, int buflen)
 {
 	char *res;
 	struct path root;
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
