Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C854AF8F
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F2DMnBwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E9AC433C8;
	Wed, 20 Dec 2023 22:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703111257;
	bh=1rftV9TV1WtxGX2GI8U16BSXEmmQL2YLssaRpQGfQMU=;
	h=Date:To:From:Subject:From;
	b=F2DMnBwPFFZj4PM5ul4t7EXkgcCaSjwlLHutkeXecxDZJLfs2gpmTHaRUzbpWQtJz
	 ZAb1K+QZ64Uqtyo4up5ePitORm9tdoiXI8KSW9H0Cr8EsUflT4NzmkPSszk9IwPdIn
	 tNiEIKF3Su9jCaQeYFe3DYU++bmvBVqw6YSINNyM=
Date: Wed, 20 Dec 2023 14:27:36 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-cpfile-fix-some-kernel-doc-warnings.patch added to mm-nonmm-unstable branch
Message-Id: <20231220222737.82E9AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: cpfile: fix some kernel-doc warnings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: nilfs2: cpfile: fix some kernel-doc warnings
Date: Thu, 21 Dec 2023 07:13:42 +0900

Correct the function parameter names for nilfs_cpfile_get_info():

cpfile.c:564: warning: Function parameter or member 'cnop' not described in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Function parameter or member 'mode' not described in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Function parameter or member 'buf' not described in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Function parameter or member 'cisz' not described in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Excess function parameter 'cno' description in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Excess function parameter 'ci' description in 'nilfs_cpfile_get_cpinfo'

Also add missing descriptions of the function's specification.

[ konishi.ryusuke@gmail.com: filled in missing descriptions ]

Link: https://lkml.kernel.org/r/20231220065931.2372-1-rdunlap@infradead.org
Link: https://lkml.kernel.org/r/20231220221342.11505-1-konishi.ryusuke@gmail.com
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--- a/fs/nilfs2/cpfile.c~nilfs2-cpfile-fix-some-kernel-doc-warnings
+++ a/fs/nilfs2/cpfile.c
@@ -552,11 +552,29 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 }
 
 /**
- * nilfs_cpfile_get_cpinfo -
- * @cpfile:
- * @cno:
- * @ci:
- * @nci:
+ * nilfs_cpfile_get_cpinfo - get information on checkpoints
+ * @cpfile: checkpoint file inode
+ * @cnop:   place to pass a starting checkpoint number and receive a
+ *          checkpoint number to continue the search
+ * @mode:   mode of checkpoints that the caller wants to retrieve
+ * @buf:    buffer for storing checkpoints' information
+ * @cisz:   byte size of one checkpoint info item in array
+ * @nci:    number of checkpoint info items to retrieve
+ *
+ * nilfs_cpfile_get_cpinfo() searches for checkpoints in @mode state
+ * starting from the checkpoint number stored in @cnop, and stores
+ * information about found checkpoints in @buf.
+ * The buffer pointed to by @buf must be large enough to store information
+ * for @nci checkpoints.  If at least one checkpoint information is
+ * successfully retrieved, @cnop is updated to point to the checkpoint
+ * number to continue searching.
+ *
+ * Return: Count of checkpoint info items stored in the output buffer on
+ * success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid checkpoint mode.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Invalid checkpoint number specified.
  */
 
 ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maple_tree-fix-typos-spellos-etc.patch
gfp-gfp_typesh-fix-typos-punctuation.patch
rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch
init-kconfig-move-more-items-into-the-expert-menu.patch
usr-kconfig-fix-typos-of-its.patch
stacktrace-fix-kernel-doc-typo.patch
nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

