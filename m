From: akpm@linux-foundation.org
Subject: + reiser4-new-export_ops-fixup.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:17:55 -0700
Message-ID: <200803101917.m2AJHtC7001130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109AbYCJTSa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com, musv@gmx.de


The patch titled
     reiser4: new export_ops fixup
has been added to the -mm tree.  Its filename is
     reiser4-new-export_ops-fixup.patch

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
Subject: reiser4: new export_ops fixup
From: Edward Shishkin <edward.shishkin@gmail.com>

Added missed reiser4_{init, exit}_context()

Cc: Sven Muller <musv@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/export_ops.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN fs/reiser4/export_ops.c~reiser4-new-export_ops-fixup fs/reiser4/export_ops.c
--- a/fs/reiser4/export_ops.c~reiser4-new-export_ops-fixup
+++ a/fs/reiser4/export_ops.c
@@ -257,19 +257,28 @@ static struct dentry *reiser4_get_dentry
 {
 	struct inode *dir;
 	dir_plugin *dplug;
+	struct dentry *result;
+	reiser4_context *ctx;
 
 	assert("nikita-3527", child != NULL);
-	/* see comment in reiser4_get_dentry() about following assertion */
-	assert("nikita-3528", is_in_reiser4_context());
 
 	dir = child->d_inode;
 	assert("nikita-3529", dir != NULL);
+
+	ctx = reiser4_init_context(dir->i_sb);
+	if (IS_ERR(ctx))
+		return (void *)ctx;
+
 	dplug = inode_dir_plugin(dir);
 	assert("nikita-3531", ergo(dplug != NULL, dplug->get_parent != NULL));
-	if (dplug != NULL)
-		return dplug->get_parent(dir);
-	else
+
+	if (unlikely(dplug == NULL)) {
+		reiser4_exit_context(ctx);
 		return ERR_PTR(RETERR(-ENOTDIR));
+	}
+	result = dplug->get_parent(dir);
+	reiser4_exit_context(ctx);
+	return result;
 }
 
 /**
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiser4-replace-uid==0-check-with-capability.patch
reiser4-new-export_ops-fixup.patch
reiser4-specify-splice-file-operations.patch
reiser4-fix-dummy-ioctl_cryptcompress.patch
reiser4-granulate-rw-serialization-when-accessing-file-conversion-set.patch
reiser4-fix-disk-cluster-synchronization.patch
reiser4-use-balance_dirty_pages_ratelimited_nr.patch
reiser4-correct-references-to-filemap_nopage.patch
reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch
reiser4-code-cleanups.patch

