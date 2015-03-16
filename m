From: akpm@linux-foundation.org
Subject: + nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch added to -mm tree
Date: Mon, 16 Mar 2015 15:51:39 -0700
Message-ID: <55075e7b.FvvkMDnpMuqRpxvH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155AbbCPWvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 18:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add helper to find existent block on metadata file
has been added to the -mm tree.  Its filename is
     nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: add helper to find existent block on metadata file

Add a new metadata file function, nilfs_mdt_find_block(), which finds
an existent block on a metadata file in a given range of blocks.  This
function skips continuous hole blocks efficiently by using
nilfs_bmap_seek_key().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/mdt.h |    3 ++
 2 files changed, 57 insertions(+)

diff -puN fs/nilfs2/mdt.c~nilfs2-add-helper-to-find-existent-block-on-metadata-file fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-add-helper-to-find-existent-block-on-metadata-file
+++ a/fs/nilfs2/mdt.c
@@ -261,6 +261,60 @@ int nilfs_mdt_get_block(struct inode *in
 }
 
 /**
+ * nilfs_mdt_find_block - find and get a buffer on meta data file.
+ * @inode: inode of the meta data file
+ * @start: start block offset (inclusive)
+ * @end: end block offset (inclusive)
+ * @blkoff: block offset
+ * @out_bh: place to store a pointer to buffer_head struct
+ *
+ * nilfs_mdt_find_block() looks up an existing block in range of
+ * [@start, @end] and stores pointer to a buffer head of the block to
+ * @out_bh, and block offset to @blkoff, respectively.  @out_bh and
+ * @blkoff are substituted only when zero is returned.
+ *
+ * Return Value: On success, it returns 0. On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOENT - no block was found in the range
+ */
+int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
+			 unsigned long end, unsigned long *blkoff,
+			 struct buffer_head **out_bh)
+{
+	__u64 next;
+	int ret;
+
+	if (unlikely(start > end))
+		return -ENOENT;
+
+	ret = nilfs_mdt_read_block(inode, start, true, out_bh);
+	if (!ret) {
+		*blkoff = start;
+		goto out;
+	}
+	if (unlikely(ret != -ENOENT || start == ULONG_MAX))
+		goto out;
+
+	ret = nilfs_bmap_seek_key(NILFS_I(inode)->i_bmap, start + 1, &next);
+	if (!ret) {
+		if (next <= end) {
+			ret = nilfs_mdt_read_block(inode, next, true, out_bh);
+			if (!ret)
+				*blkoff = next;
+		} else {
+			ret = -ENOENT;
+		}
+	}
+out:
+	return ret;
+}
+
+/**
  * nilfs_mdt_delete_block - make a hole on the meta data file.
  * @inode: inode of the meta data file
  * @block: block offset
diff -puN fs/nilfs2/mdt.h~nilfs2-add-helper-to-find-existent-block-on-metadata-file fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~nilfs2-add-helper-to-find-existent-block-on-metadata-file
+++ a/fs/nilfs2/mdt.h
@@ -78,6 +78,9 @@ int nilfs_mdt_get_block(struct inode *,
 			void (*init_block)(struct inode *,
 					   struct buffer_head *, void *),
 			struct buffer_head **);
+int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
+			 unsigned long end, unsigned long *blkoff,
+			 struct buffer_head **out_bh);
 int nilfs_mdt_delete_block(struct inode *, unsigned long);
 int nilfs_mdt_forget_block(struct inode *, unsigned long);
 int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch
nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap.patch
nilfs2-use-bgl_lock_ptr.patch
nilfs2-unify-type-of-key-arguments-in-bmap-interface.patch
nilfs2-add-bmap-function-to-seek-a-valid-key.patch
nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch
nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl.patch

