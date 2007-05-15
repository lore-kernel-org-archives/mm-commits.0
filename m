From: akpm@linux-foundation.org
Subject: + knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch added to -mm tree
Date: Tue, 15 May 2007 11:59:17 -0700
Message-ID: <200705151859.l4FIxHXg015116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760936AbXEOTAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@infradead.org, hch@lst.de, neilb@suse.de


The patch titled
     knfsd: exportfs: move acceptable check into find_acceptable_alias
has been added to the -mm tree.  Its filename is
     knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: exportfs: move acceptable check into find_acceptable_alias
From: Christoph Hellwig <hch@infradead.org>

All callers of find_acceptable_alias check if the current dentry is acceptable
before looking for other acceptable aliases using find_acceptable_alias.  Move
the check into find_acceptable_alias to make the code a little more dense and
add a comment to find_acceptable_alias that documents its intent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exportfs/expfs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/exportfs/expfs.c~knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias
+++ a/fs/exportfs/expfs.c
@@ -37,6 +37,9 @@ static int exportfs_get_name(struct dent
 		return get_name(dir, name, child);
 }
 
+/*
+ * Check if the dentry or any of it's aliases is acceptable.
+ */
 static struct dentry *
 find_acceptable_alias(struct dentry *result,
 		int (*acceptable)(void *context, struct dentry *dentry),
@@ -44,6 +47,9 @@ find_acceptable_alias(struct dentry *res
 {
 	struct dentry *dentry, *toput = NULL;
 
+	if (acceptable(context, result))
+		return result;
+
 	spin_lock(&dcache_lock);
 	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
 		dget_locked(dentry);
@@ -126,9 +132,6 @@ find_exported_dentry(struct super_block 
 
 		target_dir = dget(result);
 	} else {
-		if (acceptable(context, result))
-			return result;
-
 		alias = find_acceptable_alias(result, acceptable, context);
 		if (alias)
 			return alias;
@@ -289,9 +292,6 @@ find_exported_dentry(struct super_block 
 		}
 	}
 	dput(target_dir);
-	/* now result is properly connected, it is our best bet */
-	if (acceptable(context, result))
-		return result;
 
 	alias = find_acceptable_alias(result, acceptable, context);
 	if (alias)
_

Patches currently in -mm which might be from hch@infradead.org are

dvb_en_50221-convert-to-kthread-api.patch
git-nfs.patch
git-nfs-server-cluster-locking-api.patch
remove-pci_dac_dma_-apis.patch
git-xfs.patch
tidy-up-usermode-helper-waiting-a-bit.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
