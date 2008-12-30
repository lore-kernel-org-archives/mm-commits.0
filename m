From: akpm@linux-foundation.org
Subject: + reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:12:18 -0800
Message-ID: <200812302312.mBUNCIjE020821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049AbYL3XMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: handling error returned by d_obtain_alias fixup
has been added to the -mm tree.  Its filename is
     reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch

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
Subject: reiser4: handling error returned by d_obtain_alias fixup
From: Edward Shishkin <edward.shishkin@gmail.com>

. Fix up incorrect handling errors reterned by d_obtain_alias.
. Make quilt, checkpatch happy:
  remove comment with "joke not for everyone".

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/dir_plugin_common.c  |   10 +---------
 fs/reiser4/plugin/file_plugin_common.c |    5 +----
 2 files changed, 2 insertions(+), 13 deletions(-)

diff -puN fs/reiser4/plugin/dir_plugin_common.c~reiser4-handling-error-returned-by-d_obtain_alias-fixup fs/reiser4/plugin/dir_plugin_common.c
--- a/fs/reiser4/plugin/dir_plugin_common.c~reiser4-handling-error-returned-by-d_obtain_alias-fixup
+++ a/fs/reiser4/plugin/dir_plugin_common.c
@@ -56,10 +56,7 @@ struct dentry *get_parent_common(struct 
 		check_light_weight(parent, child);
 		reiser4_iget_complete(parent);
 		dentry = d_obtain_alias(parent);
-		if (dentry == NULL) {
-			iput(parent);
-			dentry = ERR_PTR(RETERR(-ENOMEM));
-		} else
+		if (!IS_ERR(dentry))
 			dentry->d_op = &get_super_private(s)->ops.dentry;
 	} else if (PTR_ERR(parent) == -ENOENT)
 		dentry = ERR_PTR(RETERR(-ESTALE));
@@ -353,11 +350,6 @@ int reiser4_dir_done_common(struct inode
 	result = reiser4_rem_entry_common(object, &goodby_dots, &entry);
 	reiser4_free_dentry_fsdata(&goodby_dots);
 	if (unlikely(result != 0 && result != -ENOMEM && result != -ENOENT))
-		/* only worth a warning
-
-		   "values of B will give rise to dom!\n"
-		   -- v6src/s2/mv.c:89
-		 */
 		warning("nikita-2252", "Cannot remove dot of %lli: %i",
 			(unsigned long long)get_inode_oid(object), result);
 	return 0;
diff -puN fs/reiser4/plugin/file_plugin_common.c~reiser4-handling-error-returned-by-d_obtain_alias-fixup fs/reiser4/plugin/file_plugin_common.c
--- a/fs/reiser4/plugin/file_plugin_common.c~reiser4-handling-error-returned-by-d_obtain_alias-fixup
+++ a/fs/reiser4/plugin/file_plugin_common.c
@@ -476,10 +476,7 @@ struct dentry *wire_get_common(struct su
 	if (!IS_ERR(inode)) {
 		reiser4_iget_complete(inode);
 		dentry = d_obtain_alias(inode);
-		if (dentry == NULL) {
-			iput(inode);
-			dentry = ERR_PTR(-ENOMEM);
-		} else
+		if (!IS_ERR(dentry))
 			dentry->d_op = &get_super_private(sb)->ops.dentry;
 	} else if (PTR_ERR(inode) == -ENOENT)
 		/*
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch

