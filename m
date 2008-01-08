From: akpm@linux-foundation.org
Subject: - hfs-handle-more-on-disk-corruptions-without-oopsing-fix.patch removed from -mm tree
Date: Tue, 08 Jan 2008 14:56:37 -0800
Message-ID: <200801082304.m08N4qCG004309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbYAHXFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 18:05:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs-handle-more-on-disk-corruptions-without-oopsing update
has been removed from the -mm tree.  Its filename was
     hfs-handle-more-on-disk-corruptions-without-oopsing-fix.patch

This patch was dropped because it was folded into hfs-handle-more-on-disk-corruptions-without-oopsing.patch

------------------------------------------------------
Subject: hfs-handle-more-on-disk-corruptions-without-oopsing update
From: Eric Sandeen <sandeen@redhat.com>

I double-issued warnings in some cases.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bfind.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/hfs/bfind.c~hfs-handle-more-on-disk-corruptions-without-oopsing-fix fs/hfs/bfind.c
--- a/fs/hfs/bfind.c~hfs-handle-more-on-disk-corruptions-without-oopsing-fix
+++ a/fs/hfs/bfind.c
@@ -53,7 +53,6 @@ int __hfs_brec_find(struct hfs_bnode *bn
 		len = hfs_brec_lenoff(bnode, rec, &off);
 		keylen = hfs_brec_keylen(bnode, rec);
 		if (keylen == HFS_BAD_KEYLEN) {
-			printk(KERN_ERR "hfs: keylen %d too long\n", keylen);
 			res = -EINVAL;
 			goto done;
 		}
@@ -73,7 +72,6 @@ int __hfs_brec_find(struct hfs_bnode *bn
 		len = hfs_brec_lenoff(bnode, e, &off);
 		keylen = hfs_brec_keylen(bnode, e);
 		if (keylen == HFS_BAD_KEYLEN) {
-			printk(KERN_ERR "hfs: keylen %d too long\n", keylen);
 			res = -EINVAL;
 			goto done;
 		}
@@ -209,7 +207,6 @@ int hfs_brec_goto(struct hfs_find_data *
 	len = hfs_brec_lenoff(bnode, fd->record, &off);
 	keylen = hfs_brec_keylen(bnode, fd->record);
 	if (keylen == HFS_BAD_KEYLEN) {
-		printk(KERN_ERR "hfs: keylen %d too long\n", keylen);
 		res = -EINVAL;
 		goto out;
 	}
_

Patches currently in -mm which might be from sandeen@redhat.com are

ecryptfs-fix-dentry-handling-on-create-error-unlink-and-inode-destroy.patch
hfs-handle-more-on-disk-corruptions-without-oopsing.patch
hfs-handle-more-on-disk-corruptions-without-oopsing-fix.patch
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
