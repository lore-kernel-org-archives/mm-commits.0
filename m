From: akpm@linux-foundation.org
Subject: - d_path-kerneldoc-cleanup.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:55 -0500
Message-ID: <200802150720.m1F7KHv5025807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763588AbYBOH3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, bfields@fieldses.org, hch@infradead.org, neilb@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     d_path: kerneldoc cleanup
has been removed from the -mm tree.  Its filename was
     d_path-kerneldoc-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1843,9 +1843,22 @@ Elong:
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

origin.patch
introduce-path_put-unionfs.patch
