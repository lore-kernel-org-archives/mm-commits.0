Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236024F897
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LEH0IUje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08CDC433C7;
	Wed, 20 Dec 2023 23:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113420;
	bh=miui/dI2v1ZTiieQi0JpBxexUeXEzDKtY3895nCoVjg=;
	h=Date:To:From:Subject:From;
	b=LEH0IUjeN9YZFzpbG1hLPsOe1AOi/0Ok1VhteZzW2/lJWXzWcWSfIdcCAWFt2Z5Ay
	 fNuVctMcb+hTe9l7q0/5Zc0XJRi5G1PvgoPK0FgINajLKdk9R67E26McZLhE+D75Wj
	 XyUZxcz0KZ1blO7EMGaZ9/O5cNsu8Z1tKRd0WxMs=
Date: Wed, 20 Dec 2023 15:03:39 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] freevxfs-lookup-fix-function-params-kernel-doc.patch removed from -mm tree
Message-Id: <20231220230339.E08CDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: freevxfs: lookup: fix function params kernel-doc
has been removed from the -mm tree.  Its filename was
     freevxfs-lookup-fix-function-params-kernel-doc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: freevxfs: lookup: fix function params kernel-doc
Date: Thu, 7 Dec 2023 13:20:35 -0800

Correct the function parameter kernel-doc notation to prevent warnings:

vxfs_lookup.c:192: warning: Function parameter or member 'ctx' not described in 'vxfs_readdir'
vxfs_lookup.c:192: warning: Excess function parameter 'retp' description in 'vxfs_readdir'
vxfs_lookup.c:192: warning: Excess function parameter 'filler' description in 'vxfs_readdir'

Link: https://lkml.kernel.org/r/20231207212035.25345-3-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_lookup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/freevxfs/vxfs_lookup.c~freevxfs-lookup-fix-function-params-kernel-doc
+++ a/fs/freevxfs/vxfs_lookup.c
@@ -177,8 +177,7 @@ vxfs_lookup(struct inode *dip, struct de
 /**
  * vxfs_readdir - read a directory
  * @fp:		the directory to read
- * @retp:	return buffer
- * @filler:	filldir callback
+ * @ctx:	dir_context for filldir/readdir
  *
  * Description:
  *   vxfs_readdir fills @retp with directory entries from @fp
_

Patches currently in -mm which might be from rdunlap@infradead.org are

stacktrace-fix-kernel-doc-typo.patch
nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

