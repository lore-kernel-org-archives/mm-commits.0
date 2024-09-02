Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B1F13B582
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248820; cv=none; b=TCcTR1tQPSjrjO+rnGFhjoKD1NHsIj8Rt2PTYqzEMK8jLWZ+lpuApTsG5aX9JGO6GRVT1e7uXebF4iIhoO7v5kO3pZ/fcSHzsYBMRMm3EQAJeQySIy5JXjpVD8yrtS19V6xkTrF4mh7heqj2HmSGTN/+ZleY1R/AkmNim4xP2PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248820; c=relaxed/simple;
	bh=1bx8Bgky4u+kTeESK1M7mkdcHxwC+yN2wIMNbfXAWeo=;
	h=Date:To:From:Subject:Message-Id; b=A2G6/7Z2BM6Hyt/fFXNQZ8OKFZjY/mqMNIcBNNKa5GB5zArW0DdSoQXyfpxtXiosFlZyMLlaEx3/zdegyxYCwav1e/h0XlRJmcRa21nFMIadB8iBh/QveSw3k2Rnr4dnPuKO79Q8jdojq62AnU+cv7qam6fhjG+DTMa+WK1b0bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZYbp8Mg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZYbp8Mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31125C4CEC2;
	Mon,  2 Sep 2024 03:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248820;
	bh=1bx8Bgky4u+kTeESK1M7mkdcHxwC+yN2wIMNbfXAWeo=;
	h=Date:To:From:Subject:From;
	b=cZYbp8MgPIPZqgql3+sJe6ER2ki0WOkoaqLPh4whuAEjlqALRhQn6G526UL/bh7GU
	 2uOyMjypjazh8zFMcIfFhnftJRLc3eQMME6qEFAuGSjKJEbw9N70q2lTN/UiNm2Hex
	 Gf5NKp3xv5xnpf2Jvbdo2dzhw55voSKh40bFDQGE=
Date: Sun, 01 Sep 2024 20:46:59 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-missing-argument-description-for-__nilfs_error.patch removed from -mm tree
Message-Id: <20240902034700.31125C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add missing argument description for __nilfs_error()
has been removed from the -mm tree.  Its filename was
     nilfs2-add-missing-argument-description-for-__nilfs_error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


