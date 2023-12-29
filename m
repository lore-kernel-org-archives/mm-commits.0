Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4493C14010
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q3wPzvPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B800BC433CA;
	Fri, 29 Dec 2023 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881408;
	bh=CdC7sc02Jo5Le5JARbTSsJ0Eo8j64aX6pptfmtbqkSY=;
	h=Date:To:From:Subject:From;
	b=Q3wPzvPRGvmrAtSMA48Q3z9kCglSrYaPN8e6/+Cb5N35ZVnXSrQT9i1HSuKdTy26+
	 0QglAHflfTqpk1/3/3St9GIY7tcZUPsyC60F7e7fossp1aVShLBhmQ8W5qm/AK6paR
	 ssgsJ0BVZI83QODtCd48pyU8DvIwzZxH2YK/clQc=
Date: Fri, 29 Dec 2023 12:23:28 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-cpfile-fix-some-kernel-doc-warnings.patch removed from -mm tree
Message-Id: <20231229202328.B800BC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: cpfile: fix some kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


