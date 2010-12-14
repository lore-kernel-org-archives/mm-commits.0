From: akpm@linux-foundation.org
Subject: [merged] jfs-dont-overwrite-dentry-name-in-d_revalidate.patch removed from -mm tree
Date: Tue, 14 Dec 2010 11:15:51 -0800
Message-ID: <201012141918.oBEJINXf004613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758723Ab0LNTSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 14:18:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@kernel.dk, shaggy@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jfs: don't overwrite dentry name in d_revalidate
has been removed from the -mm tree.  Its filename was
     jfs-dont-overwrite-dentry-name-in-d_revalidate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jfs: don't overwrite dentry name in d_revalidate
From: Nick Piggin <npiggin@kernel.dk>

Instead use fatfs's method for dealing with negative dentries to
preserve case, rather than overwrite dentry name in d_revalidate, which
is a bit ugly and also gets in the way of doing lock-free path walking.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/namei.c |   43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff -puN fs/jfs/namei.c~jfs-dont-overwrite-dentry-name-in-d_revalidate fs/jfs/namei.c
--- a/fs/jfs/namei.c~jfs-dont-overwrite-dentry-name-in-d_revalidate
+++ a/fs/jfs/namei.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/quotaops.h>
 #include <linux/exportfs.h>
@@ -1597,21 +1598,47 @@ static int jfs_ci_compare(struct dentry 
 			goto out;
 	}
 	result = 0;
+out:
+	return result;
+}
 
+static int jfs_ci_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
 	/*
-	 * We want creates to preserve case.  A negative dentry, a, that
-	 * has a different case than b may cause a new entry to be created
-	 * with the wrong case.  Since we can't tell if a comes from a negative
-	 * dentry, we blindly replace it with b.  This should be harmless if
-	 * a is not a negative dentry.
+	 * This is not negative dentry. Always valid.
+	 *
+	 * Note, rename() to existing directory entry will have ->d_inode,
+	 * and will use existing name which isn't specified name by user.
+	 *
+	 * We may be able to drop this positive dentry here. But dropping
+	 * positive dentry isn't good idea. So it's unsupported like
+	 * rename("filename", "FILENAME") for now.
 	 */
-	memcpy((unsigned char *)a->name, b->name, a->len);
-out:
-	return result;
+	if (dentry->d_inode)
+		return 1;
+
+	/*
+	 * This may be nfsd (or something), anyway, we can't see the
+	 * intent of this. So, since this can be for creation, drop it.
+	 */
+	if (!nd)
+		return 0;
+
+	/*
+	 * Drop the negative dentry, in order to make sure to use the
+	 * case sensitive name which is specified by user if this is
+	 * for creation.
+	 */
+	if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
+		if (nd->flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET))
+			return 0;
+	}
+	return 1;
 }
 
 const struct dentry_operations jfs_ci_dentry_operations =
 {
 	.d_hash = jfs_ci_hash,
 	.d_compare = jfs_ci_compare,
+	.d_revalidate = jfs_ci_revalidate,
 };
_

Patches currently in -mm which might be from npiggin@kernel.dk are

linux-next.patch
mm-find_get_pages_contig-fixlet.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch

