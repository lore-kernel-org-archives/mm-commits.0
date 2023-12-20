Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4179E4F5E3
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J/V5L2UW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0998BC433C7;
	Wed, 20 Dec 2023 23:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113419;
	bh=3cmZCuSjAdHY2mHWmvfXDr1gHgEiuNvYqj9fC5IdCsc=;
	h=Date:To:From:Subject:From;
	b=J/V5L2UWru4XkcGbwl/6bxahXwrNQ54bhPxAr6WNMaOdg+SF27arMMfzff0BvKj4C
	 SNcLBgrrpX4EKOlpVqe9q0OVUErCjsYF1xWjP9sVZkguzKPV+LVc+TKhmQ1GKovPxZ
	 jAhmqMifGxm1PAYHt1ZX6/ZaQlHPu3K8/HXZIVeI=
Date: Wed, 20 Dec 2023 15:03:38 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] freevxfs-immed-fix-kernel-doc-param-name.patch removed from -mm tree
Message-Id: <20231220230339.0998BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: freevxfs: immed: fix kernel-doc param name
has been removed from the -mm tree.  Its filename was
     freevxfs-immed-fix-kernel-doc-param-name.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: freevxfs: immed: fix kernel-doc param name
Date: Thu, 7 Dec 2023 13:20:34 -0800

Correct the function parameter name to prevent kernel-doc warnings:

vxfs_immed.c:32: warning: Function parameter or member 'fp' not described in 'vxfs_immed_read_folio'
vxfs_immed.c:32: warning: Excess function parameter 'file' description in 'vxfs_immed_read_folio'

Link: https://lkml.kernel.org/r/20231207212035.25345-2-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_immed.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/freevxfs/vxfs_immed.c~freevxfs-immed-fix-kernel-doc-param-name
+++ a/fs/freevxfs/vxfs_immed.c
@@ -15,7 +15,7 @@
 
 /**
  * vxfs_immed_read_folio - read part of an immed inode into pagecache
- * @file:	file context (unused)
+ * @fp:		file context (unused)
  * @folio:	folio to fill in.
  *
  * Description:
_

Patches currently in -mm which might be from rdunlap@infradead.org are

stacktrace-fix-kernel-doc-typo.patch
nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

