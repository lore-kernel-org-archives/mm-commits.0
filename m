From: akpm@linux-foundation.org
Subject: + hfs-fix-coverity-found-null-deref.patch added to -mm tree
Date: Mon, 14 Jan 2008 17:19:24 -0800
Message-ID: <200801150119.m0F1JOkd024931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYAOBUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jan 2008 20:20:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, bunk@stusta.de, zippel@linux-m68k.org


The patch titled
     hfs: fix coverity-found null deref
has been added to the -mm tree.  Its filename is
     hfs-fix-coverity-found-null-deref.patch

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
Subject: hfs: fix coverity-found null deref
From: Eric Sandeen <sandeen@redhat.com>

Fix potential null deref introduced by commit
cf0594625083111ae522496dc1c256f7476939c2
http://bugzilla.kernel.org/show_bug.cgi?id=9748

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Reported-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/btree.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/hfs/btree.c~hfs-fix-coverity-found-null-deref fs/hfs/btree.c
--- a/fs/hfs/btree.c~hfs-fix-coverity-found-null-deref
+++ a/fs/hfs/btree.c
@@ -61,7 +61,7 @@ struct hfs_btree *hfs_btree_open(struct 
 	mapping = tree->inode->i_mapping;
 	page = read_mapping_page(mapping, 0, NULL);
 	if (IS_ERR(page))
-		goto free_tree;
+		goto free_inode;
 
 	/* Load the header */
 	head = (struct hfs_btree_header_rec *)(kmap(page) + sizeof(struct hfs_bnode_desc));
@@ -99,11 +99,12 @@ struct hfs_btree *hfs_btree_open(struct 
 	page_cache_release(page);
 	return tree;
 
- fail_page:
+fail_page:
 	page_cache_release(page);
- free_tree:
+free_inode:
 	tree->inode->i_mapping->a_ops = &hfs_aops;
 	iput(tree->inode);
+free_tree:
 	kfree(tree);
 	return NULL;
 }
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
hfs-fix-coverity-found-null-deref.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
address-hfs-on-disk-corruption-robustness-review-comments-checkpatch-fixes.patch
git-kbuild.patch
ext2-change-the-default-behaviour-on-error.patch
export-iov_shorten-for-ext4s-use.patch
export-iov_shorten-for-ext4s-use-fix.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ecryptfs-check-for-existing-key_tfm-at-mount-time.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
ext3-change-the-default-behaviour-on-error.patch
