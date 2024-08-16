Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABD778297
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 22:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846739; cv=none; b=pt/+sm16Jtv1B9sZ+Y2ZFm8QLgnC0yOhIh04EKjnw4qi+xF57z9rSGy7ssW5Qy+Aa2t3lHGg4eKhFoD6pACoyJgAdbTH4kb8Y6vDe6eh3OFYo1ITjslZP7uMt3OUvq7UBV8tvr2mdWYLPe5dH04GCQzsUeyxj92ztwF5dG8PQ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846739; c=relaxed/simple;
	bh=Wep+3VoPpjSK5qf1HDEaEO3eQWyanI6lXvpfIfoOOOs=;
	h=Date:To:From:Subject:Message-Id; b=gkaC7fJsy8o0l+93jBAr6d2QctvjJRsQWDz12DROwViuah66+SndVYYQS+m4CegPDiCfsbcMHaIdDfQiITCHgfGaWVEPq9TjHcKvs2RhE6WQd2WJJLABLK9gxQHCv13rESXVEUhAVtgkBJhvDj16f/iHt2LJm/bRY+t2g7YsUSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cGxdx8RP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cGxdx8RP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7D2C32782;
	Fri, 16 Aug 2024 22:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723846738;
	bh=Wep+3VoPpjSK5qf1HDEaEO3eQWyanI6lXvpfIfoOOOs=;
	h=Date:To:From:Subject:From;
	b=cGxdx8RPMAAZlgQVi8971JLgn5xkwSUeqbzealn0dZlH63locdjut1SHNF+1/AfFa
	 rtkjy+fBrG3PveVzjRAwkJ4IHdw+9O0psrMrhaU9WdyTonuR3hwxNmPzRL0k2vqC5M
	 IFrgrC8f0ZVXrs6HryoOvTlbF5Wp+RD+ZF2UyXEA=
Date: Fri, 16 Aug 2024 15:18:58 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-missing-argument-description-for-__nilfs_error.patch added to mm-nonmm-unstable branch
Message-Id: <20240816221858.9E7D2C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add missing argument description for __nilfs_error()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-missing-argument-description-for-__nilfs_error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-missing-argument-description-for-__nilfs_error.patch

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
Subject: nilfs2: add missing argument description for __nilfs_error()
Date: Fri, 16 Aug 2024 16:43:12 +0900

Patch series "This series fixes a number of formatting issues in kernel
doc comments"


This series fixes a number of formatting issues in kernel doc comments
that were detected as warnings by the kernel-doc script, making violations
more noticeable when adding or modifying kernel doc.

There are still warnings output by "kernel-doc -Wall", but they are
widespread, so I plan to fix them at another time while considering
priorities.


This patch (of 8):

Add missing argument description to __nilfs_error function and remove the
following warnings from kernel-doc script output:

 fs/nilfs2/super.c:121: warning: Function parameter or struct member 'sb'
  not described in '__nilfs_error'
 fs/nilfs2/super.c:121: warning: Function parameter or struct member
  'function' not described in '__nilfs_error'
 fs/nilfs2/super.c:121: warning: Function parameter or struct member 'fmt'
  not described in '__nilfs_error'

Link: https://lkml.kernel.org/r/20240816074319.3253-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240816074319.3253-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nilfs2/super.c~nilfs2-add-missing-argument-description-for-__nilfs_error
+++ a/fs/nilfs2/super.c
@@ -105,6 +105,10 @@ static void nilfs_set_error(struct super
 
 /**
  * __nilfs_error() - report failure condition on a filesystem
+ * @sb:       super block instance
+ * @function: name of calling function
+ * @fmt:      format string for message to be output
+ * @...:      optional arguments to @fmt
  *
  * __nilfs_error() sets an ERROR_FS flag on the superblock as well as
  * reporting an error message.  This function should be called when
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

