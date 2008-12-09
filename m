From: akpm@linux-foundation.org
Subject: - exportfs-handle-null-returns-from-fh_to_dentry-fh_to_parent.patch removed from -mm tree
Date: Tue, 09 Dec 2008 10:46:00 -0800
Message-ID: <200812091846.mB9Ik045027238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754185AbYLISqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 13:46:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, dhowells@redhat.com, hch@infradead.org, hugh@veritas.com, neilb@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     exportfs: handle NULL returns from fh_to_dentry()/fh_to_parent()
has been removed from the -mm tree.  Its filename was
     exportfs-handle-null-returns-from-fh_to_dentry-fh_to_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exportfs: handle NULL returns from fh_to_dentry()/fh_to_parent()
From: J. Bruce Fields <bfields@citi.umich.edu>

While 440037287c5 "[PATCH] switch all filesystems over to d_obtain_alias"
removed some cases where fh_to_dentry() and fh_to_parent() could return
NULL, there are still a few NULL returns left in individual filesystems. 
Thus it was a mistake for that commit to remove the handling of NULL
returns in the callers.

Revert those parts of 440037287c5 which removed the NULL handling.

(We could, alternatively, modify all implementations to return -ESTALE
instead of NULL, but that proves to require fixing a number of
filesystems, and in some cases it's arguably more natural to return NULL.)

Thanks to David for original patch and Linus, Christoph, and Hugh for
review.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exportfs/expfs.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/exportfs/expfs.c~exportfs-handle-null-returns-from-fh_to_dentry-fh_to_parent fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~exportfs-handle-null-returns-from-fh_to_dentry-fh_to_parent
+++ a/fs/exportfs/expfs.c
@@ -369,6 +369,8 @@ struct dentry *exportfs_decode_fh(struct
 	 * Try to get any dentry for the given file handle from the filesystem.
 	 */
 	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
+	if (!result)
+		result = ERR_PTR(-ESTALE);
 	if (IS_ERR(result))
 		return result;
 
@@ -422,6 +424,8 @@ struct dentry *exportfs_decode_fh(struct
 
 		target_dir = nop->fh_to_parent(mnt->mnt_sb, fid,
 				fh_len, fileid_type);
+		if (!target_dir)
+			goto err_result;
 		err = PTR_ERR(target_dir);
 		if (IS_ERR(target_dir))
 			goto err_result;
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
linux-next.patch
reiser4.patch

