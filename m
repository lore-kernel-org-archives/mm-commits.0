Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2C4256C9B
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597487; cv=none; b=AAV14/xlPHEk2Ci/7kmGp3vn2HDbP2QGcSqXoZ19pDhBUTasAFeGVYm6uu3gpthEHk47oEXuLfITuJgyX+ekxzfmcpz7D+/Qt0a6Wl3UtpXQ/luHIYBm6nyyYNF3dcmbUQnjLzFmWjdG0JBc4IXY18MtX1JDOIJBeFFxm5GnEkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597487; c=relaxed/simple;
	bh=yLgkHtQYSqSHeDBo5WbBPLar28qdfaP1yStgblM+Mjc=;
	h=Date:To:From:Subject:Message-Id; b=g9p/21VnsM5dyGynIlrbR4fiQgZaYr4Vpp28bV+DcpgFYauu52CfkElJRqRBP6UYitvM/9grMTG7rRDub+r+vLqefB4RWNlTM/3JGpfWpzs93dmzhExd1sQcx2IVh/ptTagGWvq8YL3mpvHBjA0BGvTLdwnqEVotc3NE2fk4ztI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yncRxHi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yncRxHi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FA2C113D0;
	Tue, 23 Sep 2025 03:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597487;
	bh=yLgkHtQYSqSHeDBo5WbBPLar28qdfaP1yStgblM+Mjc=;
	h=Date:To:From:Subject:From;
	b=yncRxHi4VWvmZnrxqS9jpdmwb+NcCcTv0Bvh2WkR1i7TXSwBnSg/UJ84a9dRqVJEw
	 fS1AAM/JmQ8+ZJ5vy7FE0N/BMQvwYsc4J+YyfCXzNHSYrZR/OhZSCXgr9ns1ASMIYU
	 P4dIkOvUUPFzGjqpLN740SxP04Ho7kseDjBb0qyU=
Date: Mon, 22 Sep 2025 20:18:06 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-io_remap_pfn_range_-fix.patch removed from -mm tree
Message-Id: <20250923031807.51FA2C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup io_remap_pfn_range_[prepare, complete]
has been removed from the -mm tree.  Its filename was
     mm-introduce-io_remap_pfn_range_-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fixup io_remap_pfn_range_[prepare, complete]
Date: Thu, 18 Sep 2025 07:43:21 +0100

propagate the fact that we don't need io_remap_pfn_range_prot()

Link: https://lkml.kernel.org/r/2cf129c4-627b-4a78-9ec3-cf43c95cf17d@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-introduce-io_remap_pfn_range_-fix
+++ a/mm/internal.h
@@ -1670,7 +1670,7 @@ static inline int io_remap_pfn_range_com
 		pgprot_t orig_prot)
 {
 	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
-	const pgprot_t prot = io_remap_pfn_range_prot(orig_prot);
+	const pgprot_t prot = pgprot_decrypted(orig_prot);
 
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


