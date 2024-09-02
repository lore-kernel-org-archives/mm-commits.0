Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F6613B582
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248822; cv=none; b=FhvFa2OgNIRPzeBiM7DSt3flRIxIl2U0DE/rdOGggIGop3brl2AuPowJ/YeZLD+RX1PdVVPBiXE8L6+osNdyMp7fRB7Cv9YTsbmItPXUu2ApejXpNNKsyAPCePxBm3Cgz2hgZLbWlna8y3XH1B+RPtsFlQ20ptPH1dw18JBFLdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248822; c=relaxed/simple;
	bh=Yoc3CoTyfTt2msX/G+0C45UBD7sW+YMszzqOz6rIfp8=;
	h=Date:To:From:Subject:Message-Id; b=FrJoyMLgojSEMhDfzX+Qhsn3t/59WnetLijOW60G8drMQEF7hFQa3B2Lq2E6xQm6KqDASYr8T2kH6t2JLYlbUDjKDS1i7IbJ6Z9p7/uqfxyxoAOLikwueaMNQedbC66oSkKnv32hlKtjHPNeWH2DjqlL3Ops8hH1Wut+QqvrZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hT/bpK4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hT/bpK4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C373C4CEC7;
	Mon,  2 Sep 2024 03:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248822;
	bh=Yoc3CoTyfTt2msX/G+0C45UBD7sW+YMszzqOz6rIfp8=;
	h=Date:To:From:Subject:From;
	b=hT/bpK4fOd15ZpxiJIJbHwj/JXedt2f6DeFDsp3s1pLFsI5u6BLw81mYWvNXtqo5H
	 q+ThRFDgZ4lhJtdJbEkr/ojQ5rraKukkXVFnswS9lLbD99q5+DKY9pxJ7xWBME4mZv
	 NlHdMvZA8YINBwzkdk4o0JckNMxhum3IwdNZB7IA=
Date: Sun, 01 Sep 2024 20:47:01 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch removed from -mm tree
Message-Id: <20240902034702.4C373C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: improve kernel-doc comments for b-tree node helpers
has been removed from the -mm tree.  Its filename was
     nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: improve kernel-doc comments for b-tree node helpers
Date: Fri, 16 Aug 2024 16:43:14 +0900

Revise kernel-doc comments for helper functions related to changing the
search key for b-tree node blocks, and eliminate the following warnings
output by the kernel-doc script:

 fs/nilfs2/btnode.c:175: warning: Function parameter or struct member 'btnc'
  not described in 'nilfs_btnode_prepare_change_key'
 fs/nilfs2/btnode.c:175: warning: Function parameter or struct member 'ctxt'
  not described in 'nilfs_btnode_prepare_change_key'
 fs/nilfs2/btnode.c:238: warning: Function parameter or struct member 'btnc'
  not described in 'nilfs_btnode_commit_change_key'
 fs/nilfs2/btnode.c:238: warning: Function parameter or struct member 'ctxt'
  not described in 'nilfs_btnode_commit_change_key'
 fs/nilfs2/btnode.c:278: warning: Function parameter or struct member 'btnc'
  not described in 'nilfs_btnode_abort_change_key'
 fs/nilfs2/btnode.c:278: warning: Function parameter or struct member 'ctxt'
  not described in 'nilfs_btnode_abort_change_key'

Link: https://lkml.kernel.org/r/20240816074319.3253-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |   63 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 9 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers
+++ a/fs/nilfs2/btnode.c
@@ -179,11 +179,32 @@ void nilfs_btnode_delete(struct buffer_h
 }
 
 /**
- * nilfs_btnode_prepare_change_key
- *  prepare to move contents of the block for old key to one of new key.
- *  the old buffer will not be removed, but might be reused for new buffer.
- *  it might return -ENOMEM because of memory allocation errors,
- *  and might return -EIO because of disk read errors.
+ * nilfs_btnode_prepare_change_key - prepare to change the search key of a
+ *                                   b-tree node block
+ * @btnc: page cache in which the b-tree node block is buffered
+ * @ctxt: structure for exchanging context information for key change
+ *
+ * nilfs_btnode_prepare_change_key() prepares to move the contents of the
+ * b-tree node block of the old key given in the "oldkey" member of @ctxt to
+ * the position of the new key given in the "newkey" member of @ctxt in the
+ * page cache @btnc.  Here, the key of the block is an index in units of
+ * blocks, and if the page and block sizes match, it matches the page index
+ * in the page cache.
+ *
+ * If the page size and block size match, this function attempts to move the
+ * entire folio, and in preparation for this, inserts the original folio into
+ * the new index of the cache.  If this insertion fails or if the page size
+ * and block size are different, it falls back to a copy preparation using
+ * nilfs_btnode_create_block(), inserts a new block at the position
+ * corresponding to "newkey", and stores the buffer head pointer in the
+ * "newbh" member of @ctxt.
+ *
+ * Note that the current implementation does not support folio sizes larger
+ * than the page size.
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 				    struct nilfs_btnode_chkey_ctxt *ctxt)
@@ -245,8 +266,21 @@ retry:
 }
 
 /**
- * nilfs_btnode_commit_change_key
- *  commit the change_key operation prepared by prepare_change_key().
+ * nilfs_btnode_commit_change_key - commit the change of the search key of
+ *                                  a b-tree node block
+ * @btnc: page cache in which the b-tree node block is buffered
+ * @ctxt: structure for exchanging context information for key change
+ *
+ * nilfs_btnode_commit_change_key() executes the key change based on the
+ * context @ctxt prepared by nilfs_btnode_prepare_change_key().  If no valid
+ * block buffer is prepared in "newbh" of @ctxt (i.e., a full folio move),
+ * this function removes the folio from the old index and completes the move.
+ * Otherwise, it copies the block data and inherited flag states of "oldbh"
+ * to "newbh" and clears the "oldbh" from the cache.  In either case, the
+ * relocated buffer is marked as dirty.
+ *
+ * As with nilfs_btnode_prepare_change_key(), the current implementation does
+ * not support folio sizes larger than the page size.
  */
 void nilfs_btnode_commit_change_key(struct address_space *btnc,
 				    struct nilfs_btnode_chkey_ctxt *ctxt)
@@ -285,8 +319,19 @@ void nilfs_btnode_commit_change_key(stru
 }
 
 /**
- * nilfs_btnode_abort_change_key
- *  abort the change_key operation prepared by prepare_change_key().
+ * nilfs_btnode_abort_change_key - abort the change of the search key of a
+ *                                 b-tree node block
+ * @btnc: page cache in which the b-tree node block is buffered
+ * @ctxt: structure for exchanging context information for key change
+ *
+ * nilfs_btnode_abort_change_key() cancels the key change associated with the
+ * context @ctxt prepared via nilfs_btnode_prepare_change_key() and performs
+ * any necessary cleanup.  If no valid block buffer is prepared in "newbh" of
+ * @ctxt, this function removes the folio from the destination index and aborts
+ * the move.  Otherwise, it clears "newbh" from the cache.
+ *
+ * As with nilfs_btnode_prepare_change_key(), the current implementation does
+ * not support folio sizes larger than the page size.
  */
 void nilfs_btnode_abort_change_key(struct address_space *btnc,
 				   struct nilfs_btnode_chkey_ctxt *ctxt)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


