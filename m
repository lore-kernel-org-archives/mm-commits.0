Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B0078297
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 22:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846744; cv=none; b=dcuyiYxCltBx1P8FDEBuu3WhI7AniyanCIDRX4tJOQ2WqtQN8ox9G9U4bhJuBCH+s6SuZ5JCShH4sKpNobEt7EC+ZIcYP7jCkXtx5MCFxaw9Xkl5gPenvrbCFCIqlOPwKqyEzf4QZCgZcQ8JejM4DSNlZv94Fc53n9DZNoNCcm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846744; c=relaxed/simple;
	bh=c1Qgnw55enJ8FBhlQsUM67gM/1ZW68ITtsYdzN9Grl8=;
	h=Date:To:From:Subject:Message-Id; b=Q18Ui0U/qGKIc5xyj3dEn4r6BbtKxcjb9h9s8IQrHDNN3u1ivovaKIDQamwCJ0rMkB2ER/o9Ag+z2IP1oG2f1CRclfORjJnaIJtw+97wcjqRLlz9niyOismJ+SffPW/blYl1Xg3lXgxeAqkuB2ByLbBHh/S1RMC9z2kOcrZ939M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WO1TxEZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WO1TxEZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CF3C32782;
	Fri, 16 Aug 2024 22:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723846744;
	bh=c1Qgnw55enJ8FBhlQsUM67gM/1ZW68ITtsYdzN9Grl8=;
	h=Date:To:From:Subject:From;
	b=WO1TxEZIvWrLrR0Q7RNFHteYCuyRjfIYAkAAtjWCyLSeVK1NrKiQlD9v/KXUq+wBv
	 mgcYMPS4OraTvD7bX/TORSQnefD/aBOl42TzPckRW26bQ2KDnnZP8SS6iJj485zhX8
	 /n/ZJM2uoliFytw5Tn7MGXKc5e33KIxQfCiO/b8s=
Date: Fri, 16 Aug 2024 15:19:03 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch added to mm-nonmm-unstable branch
Message-Id: <20240816221904.45CF3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix incorrect kernel-doc declaration of nilfs_palloc_req structure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch

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
Subject: nilfs2: fix incorrect kernel-doc declaration of nilfs_palloc_req structure
Date: Fri, 16 Aug 2024 16:43:15 +0900

The "struct" keyword is missing from the kernel-doc comment of the
nilfs_palloc_req structure, so add it to eliminate the following warning
output by the kernel-doc script:

 fs/nilfs2/alloc.h:46: warning: cannot understand function prototype:
  'struct nilfs_palloc_req '

Link: https://lkml.kernel.org/r/20240816074319.3253-5-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/alloc.h~nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure
+++ a/fs/nilfs2/alloc.h
@@ -37,7 +37,7 @@ void *nilfs_palloc_block_get_entry(const
 int nilfs_palloc_count_max_entries(struct inode *, u64, u64 *);
 
 /**
- * nilfs_palloc_req - persistent allocator request and reply
+ * struct nilfs_palloc_req - persistent allocator request and reply
  * @pr_entry_nr: entry number (vblocknr or inode number)
  * @pr_desc_bh: buffer head of the buffer containing block group descriptors
  * @pr_bitmap_bh: buffer head of the buffer containing a block group bitmap
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

