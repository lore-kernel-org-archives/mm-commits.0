Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634131C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836947; cv=none; b=BU68Hoc1QtHBPhM5ngyI3Q3k+UHqih1tMg+Sx28rXqsfU9TCDhINmhx0a+dHcqpUOS5vNxliyO2cTjbtHsrBaYPqfnfJ0gsOWYtndwNPenoBvizNipV5er0smyJaIKo7OC2c89CrkuLWgXwEhFsqf1A9dOKVu3GjsPYeNZgz41M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836947; c=relaxed/simple;
	bh=xuoQ8Co/hyG6+1AJ3ysdLPKJxq/Y2NI8B0UJFgT7QwI=;
	h=Date:To:From:Subject:Message-Id; b=CUAc80Os2r+r0iBUGrNUMYrilKVXlN+jDORkjiR5y5y6mM9tbM3s3OWpNx3AJ0UxuI0VW1z2Au/TskPiDodPiBI38JE6W0nwgxqddCmw5x8hreZF3/kVjquu4IPumTxT97b3n7+Fi1ssKFtRlt+c0Tvd1ZAldHgwZ7KkhPPBgs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HdbW5ij5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HdbW5ij5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37526C4CEDD;
	Tue, 14 Jan 2025 06:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836947;
	bh=xuoQ8Co/hyG6+1AJ3ysdLPKJxq/Y2NI8B0UJFgT7QwI=;
	h=Date:To:From:Subject:From;
	b=HdbW5ij56DkX+IdreBBNwh2XGOkq99b7W/2fNKNNuXWIIo9ZxIP/YdeslNIGHnq+G
	 EhmSo7eLCabOQ6AnbT0B8VPu9L5JDz0fJOb/pX05oRj9XI04EVH42Xyb8bzdyxyIry
	 Q5mi4zZQtZf2I16A7ILtDiWUvhgOA/hCMJWYiFyM=
Date: Mon, 13 Jan 2025 22:42:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-tmpfs-drop-fadvise-from-the-documentation.patch removed from -mm tree
Message-Id: <20250114064227.37526C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: tmpfs: drop 'fadvise()' from the documentation
has been removed from the -mm tree.  Its filename was
     docs-tmpfs-drop-fadvise-from-the-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: docs: tmpfs: drop 'fadvise()' from the documentation
Date: Thu, 28 Nov 2024 15:40:44 +0800

Drop 'fadvise()' from the doc, since fadvise() has no HUGEPAGE advise
currently.

Link: https://lkml.kernel.org/r/3a10bb49832f6d9827dc2c76aec0bf43a892876b.1732779148.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-tmpfs-drop-fadvise-from-the-documentation
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -382,10 +382,10 @@ never
 
 within_size
     Only allocate huge page if it will be fully within i_size.
-    Also respect fadvise()/madvise() hints;
+    Also respect madvise() hints;
 
 advise
-    Only allocate huge pages if requested with fadvise()/madvise();
+    Only allocate huge pages if requested with madvise();
 
 Remember, that the kernel may use huge pages of all available sizes, and
 that no fine control as for the internal tmpfs mount is available.
@@ -438,10 +438,10 @@ never
 
 within_size
     Only allocate <size> huge page if it will be fully within i_size.
-    Also respect fadvise()/madvise() hints;
+    Also respect madvise() hints;
 
 advise
-    Only allocate <size> huge pages if requested with fadvise()/madvise();
+    Only allocate <size> huge pages if requested with madvise();
 
 Need of application restart
 ===========================
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


