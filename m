From: akpm@linux-foundation.org
Subject: - export-iov_shorten-for-ext4s-use.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:28 -0800
Message-ID: <200802012230.m11MUSfH001912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756335AbYBAWon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, cmm@us.ibm.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     export iov_shorten for ext4's use
has been removed from the -mm tree.  Its filename was
     export-iov_shorten-for-ext4s-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: export iov_shorten for ext4's use
From: Eric Sandeen <sandeen@redhat.com>

ext4 needs to deal with 2 different max file offsets for block- and
extent-allocated file formats, whereas the s_maxbytes scheme can only deal
with one.  So, for block-allocated files, we must catch and fix up
too-large offsets from within the filesystem.

Having iov_shorten exported allows such things as:

		if (pos + length > sbi->s_bitmap_maxbytes) {
			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
					      sbi->s_bitmap_maxbytes - pos);
		}

to fix up too-large writes to these files in ext4_file_write().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/read_write.c~export-iov_shorten-for-ext4s-use fs/read_write.c
--- a/fs/read_write.c~export-iov_shorten-for-ext4s-use
+++ a/fs/read_write.c
@@ -446,6 +446,7 @@ unsigned long iov_shorten(struct iovec *
 	}
 	return seg;
 }
+EXPORT_SYMBOL(iov_shorten)
 
 ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn)
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ext2-change-the-default-behaviour-on-error.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ecryptfs-check-for-existing-key_tfm-at-mount-time.patch
ext3-change-the-default-behaviour-on-error.patch
