Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9192DAFA0
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 20:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750884195; cv=none; b=B3xTNCy2MeY+rIe3F6JoYFYSkLCPqWAs7LlUbqIEqggp32aKhNGm9keCJVIti/TncQc8DzSxNh6EGeNP9VychsUwpwJa7NirVOQb+WFDHawGRIdC/8Q4D5Q/1mrGvMKQgDAAwidzter5UBQzqLIqTTopJ5u0SZDsSA3txy9kn04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750884195; c=relaxed/simple;
	bh=plBWpXsmkAzFYPaoiy7d4VQuOn/amlulNjSpSZWXc4M=;
	h=Date:To:From:Subject:Message-Id; b=aN8D85K60hSRR+Ng9gd1EaGAK5ONd7EcAfiCmPYbozQeNCPOnXoRKpHi/y5LfpWjcHv/4q65/PMedoTGuY4M73BTVGmv8CfLsRF3gxuxKXQISd5IoWC34PbpHXaX7YvEk7GiprIWHn/Ae+rBivmm6g8zwL5a1wH4928XOp5absQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q4JC8Xdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q4JC8Xdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D21C4CEEA;
	Wed, 25 Jun 2025 20:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750884195;
	bh=plBWpXsmkAzFYPaoiy7d4VQuOn/amlulNjSpSZWXc4M=;
	h=Date:To:From:Subject:From;
	b=q4JC8XdoZcDC88d4rewCQLpLmd613Q7zFGz/6VSMJcLmzPA+U3267CxCQZj81FDI/
	 E6lDyi6t1yH4cQdTQlnMeRcnhkTGWyw1/2jaQJS1ZVNaxlsLVkB+3Qxh1435hT+sg6
	 0hEqSaKF6O7Dqr8srjA9jZGKCR+i7WyKOkkAzF3g=
Date: Wed, 25 Jun 2025 13:43:14 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,willy@infradead.org,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,axboe@kernel.dk,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ceph-convert-ceph_zero_partial_page-to-use-a-folio-fix.patch added to mm-unstable branch
Message-Id: <20250625204315.45D21C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ceph: fix NULL vs IS_ERR() bug in ceph_zero_partial_page()
has been added to the -mm mm-unstable branch.  Its filename is
     ceph-convert-ceph_zero_partial_page-to-use-a-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ceph-convert-ceph_zero_partial_page-to-use-a-folio-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: ceph: fix NULL vs IS_ERR() bug in ceph_zero_partial_page()
Date: Wed, 25 Jun 2025 10:22:11 -0500

The filemap_lock_folio() never returns NULL.  It returns error pointers.
Update the checking to match.

Link: https://lkml.kernel.org/r/685c1424.050a0220.baa8.d6a1@mx.google.com
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/file.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/ceph/file.c~ceph-convert-ceph_zero_partial_page-to-use-a-folio-fix
+++ a/fs/ceph/file.c
@@ -2536,12 +2536,13 @@ static inline void ceph_zero_partial_pag
 	struct folio *folio;
 
 	folio = filemap_lock_folio(inode->i_mapping, offset >> PAGE_SHIFT);
-	if (folio) {
-		folio_wait_writeback(folio);
-		folio_zero_range(folio, offset_in_folio(folio, offset), size);
-		folio_unlock(folio);
-		folio_put(folio);
-	}
+	if (IS_ERR(folio))
+		return;
+
+	folio_wait_writeback(folio);
+	folio_zero_range(folio, offset_in_folio(folio, offset), size);
+	folio_unlock(folio);
+	folio_put(folio);
 }
 
 static void ceph_zero_pagecache_range(struct inode *inode, loff_t offset,
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

mmmemory_hotplug-implement-numa-node-notifier-fix.patch
ceph-convert-ceph_zero_partial_page-to-use-a-folio-fix.patch

