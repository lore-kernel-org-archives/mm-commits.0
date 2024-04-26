Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282DB7C6EB
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103948; cv=none; b=TmBsKlljD5oRXmMGTnLyO7zO6SZ0f9Y+J5q7xLmTM3B2CCV6RD4fYBsLFWtRBGLKGw6g6p4FPb2kkDn76wo0VI+h74pxBW0lphTV6s1TV5ECvBM5EVLS/Rpdj7zOkkqzlXiWUsH/ciXbMawu4gr54MoVaFcKFsmdgeT7Pk3+ONI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103948; c=relaxed/simple;
	bh=N43x8URpHWLnxx+T5HA8O0Gy6MPmbuMLq/H8geVP7ew=;
	h=Date:To:From:Subject:Message-Id; b=dtVHSGouLVXAO87Emcztf+OknOR5IlgBcFHnmTdbu0fFmfnLwkEmP8/gLkxPh3XVgvMkFzll09cST7sHwyYPFCs4sKa0pBffI8hqeFCuSQzf5ZnNy4EnIc83Om9KdgnUGoBU8zQrGQ784iEaAOslyzZqDvlCfImh5C+0w10nmtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNp54vCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNp54vCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5FAC116B1;
	Fri, 26 Apr 2024 03:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103948;
	bh=N43x8URpHWLnxx+T5HA8O0Gy6MPmbuMLq/H8geVP7ew=;
	h=Date:To:From:Subject:From;
	b=SNp54vCctdUNqmEyczwYT/PCYJQX100pnxZYm7KUIf8UPmvpxtfPB2x1saxZBuVsY
	 N5IcYFQKJtqAJkpIux5dovoDnw3eA2HFmfLOsmIL3Myi+ZXIpWoC/6ZxttDrf9JSaw
	 O2wwVCG2HNwqAfMIcoXw0ucH7lDXFg19yre69oWI=
Date: Thu, 25 Apr 2024 20:59:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-flags-make-pagemappingflags-return-bool.patch removed from -mm tree
Message-Id: <20240426035907.EF5FAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-flags: make PageMappingFlags return bool
has been removed from the -mm tree.  Its filename was
     mm-page-flags-make-pagemappingflags-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/page-flags: make PageMappingFlags return bool
Date: Thu, 21 Mar 2024 11:07:12 +0800

Make PageMappingFlags() return bool like folio_mapping_flags().

Link: https://lkml.kernel.org/r/20240321030712.80618-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-page-flags-make-pagemappingflags-return-bool
+++ a/include/linux/page-flags.h
@@ -686,7 +686,7 @@ static __always_inline bool folio_mappin
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) != 0;
 }
 
-static __always_inline int PageMappingFlags(const struct page *page)
+static __always_inline bool PageMappingFlags(const struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) != 0;
 }
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-mmap-make-vma_wants_writenotify-return-bool.patch
mm-mmap-make-accountable_mapping-return-bool.patch
mm-page-flags-make-pageuptodate-return-bool.patch

