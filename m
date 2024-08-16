Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BEE78297
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 22:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846742; cv=none; b=XnjwLus1/FB2hEksi7evDrggS9ozbwTkRevdKfmjVDBQbfOVVwc0wH9FoZTsr19F+QxcAnjLdTb/QKslQbAx7KSu+HUqtRRDHhXi6HWoTg8Ul2k0fhIbrzmxeYhDPfDH9dFO5Ju8D0PQeKRB79HtQt4yd7PjjYA/wijpY4/zhds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846742; c=relaxed/simple;
	bh=202IXjKKtPMfuAliEsn7XuNi9eNtHN959GVmLpeSu5E=;
	h=Date:To:From:Subject:Message-Id; b=ti2y/kKW/gh+wR9HeOhnwrbGVhUul4kwFe5C5jn7rrSp0YyoZ0DeaTex/4rmVgKQnpYjFWo2L2Y9WF6CQWbZn1nOy3uds3RtolSuSZphPsAd99CwkU1OQ6l0h0+3NnUeLVV+t2Wq+/UYgFkGoI/ZNUf7aXuX5LxBMMK5vL7IVpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J42UeBX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J42UeBX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61854C32782;
	Fri, 16 Aug 2024 22:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723846742;
	bh=202IXjKKtPMfuAliEsn7XuNi9eNtHN959GVmLpeSu5E=;
	h=Date:To:From:Subject:From;
	b=J42UeBX5et4eFVzc3dtshsDe0wGBdg+L0xvMQD32qxSypp3OqTMEOdxuMli2PzVdR
	 nydEVyjEflbegQbmKIrvth/5ut0kEDc7odoriEf6CZx0mRryscOX+szlVvr207hKQN
	 iEJsddJRLLTqQna+NSEVm06b2o1EHZHpXSKnbCGE=
Date: Fri, 16 Aug 2024 15:19:01 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch added to mm-nonmm-unstable branch
Message-Id: <20240816221902.61854C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: improve kernel-doc comments for b-tree node helpers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch

