Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9540814037F
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 22:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846746; cv=none; b=nL0r+kBRSMJojMGoa/PioBORdSkXOSg0UZRSXSXDkcGDFLcZmnDsCB1zzi3xUAwxyAg6pDQv7WSPV3z7aNyQEymX9QLmzBrSvRecBi6SH4u1JTrAlmZ73hdWlk/lB6zx44YE3CDYZpKYS+24A9voK3pvOAJdREsrFkXvY4qCH1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846746; c=relaxed/simple;
	bh=azwOAMldrx7dGUI0e8NRjHttA7HGSkB5PA2I7+JdrLI=;
	h=Date:To:From:Subject:Message-Id; b=uq3UlDWiiJUQ+x5LIQhQxJ7UT5bHmrX0ri4hpfhlkmrI4jiAnxk27k9JM+aYj5C4NLWxAoooh65rkfAq2Eu3enXXkSGKpbwPAAluDwRnOvnA9DwTESY3FJE7jO7XOx6YwvpS2GfM5xtMs68+VzMyatqYqL9hw2igAeYcsLOOF4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1CwG52ja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1CwG52ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19872C32782;
	Fri, 16 Aug 2024 22:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723846746;
	bh=azwOAMldrx7dGUI0e8NRjHttA7HGSkB5PA2I7+JdrLI=;
	h=Date:To:From:Subject:From;
	b=1CwG52jamkfr8GfHSNpPJo56czSlC+kDqXUhXTH3M06+2rz91aSVzpG/hEkrwJoZA
	 d6TFwwYbcF/KFm0iTYlF2pQZMs/UMiyd+jv4TRM70MClJvJp00f6pYMQQ1e/X3lc0O
	 QKbBdv5g3w4T2/ixpCSHna7qfjxRh6bh3StEjkZs=
Date: Fri, 16 Aug 2024 15:19:05 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch added to mm-nonmm-unstable branch
Message-Id: <20240816221906.19872C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add missing description of nilfs_btree_path structure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch

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
Subject: nilfs2: add missing description of nilfs_btree_path structure
Date: Fri, 16 Aug 2024 16:43:16 +0900

Add missing kernel-doc comment for the 'bp_ctxt' member variable of the
nilfs_btree_path structure, and eliminate the following warning output by
the kenrel-doc script:

 fs/nilfs2/btree.h:39: warning: Function parameter or struct member
  'bp_ctxt' not described in 'nilfs_btree_path'

Link: https://lkml.kernel.org/r/20240816074319.3253-6-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/btree.h~nilfs2-add-missing-description-of-nilfs_btree_path-structure
+++ a/fs/nilfs2/btree.h
@@ -24,6 +24,7 @@
  * @bp_index: index of child node
  * @bp_oldreq: ptr end request for old ptr
  * @bp_newreq: ptr alloc request for new ptr
+ * @bp_ctxt: context information for changing the key of a b-tree node block
  * @bp_op: rebalance operation
  */
 struct nilfs_btree_path {
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

