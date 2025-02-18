Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7CB4C7C
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847384; cv=none; b=fVzO5xo0+185cUbusMKCBK9gLFwmiDJoNBYBEcP9kjHtrhtbtVZ2zdfT45r7SA+5Ju2kMZUxO+Tl8uNylyR72CsE199oFk9V1APwFDCK3a1y4TgOIWQmIyq+7Nr7aE9ggXpbRmBnUQ/dMJPD3QAuJm7jdUEGsIIBhYvN5hhqMuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847384; c=relaxed/simple;
	bh=40EJp7DBkCgrBj6rBLRwfYDFr6BqJRb/xw73BP7UMM4=;
	h=Date:To:From:Subject:Message-Id; b=jp1uAiFd1mTV0Bu+48tStlnyMMgUZTjtFtr0g1nigyNeqOwqwNZXVbfgfiYZJmGS1004oPYKc7VaYlvqOfJI2PKVrUmTHRWx5Jzq11nwCOFGynvpRUAvjoiHnJJNkkO+kZLykMBsyAuq2IPSiGbxsYc4ecOXODKz+2x8FroXBwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wkGT4lhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wkGT4lhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8D9C4CED1;
	Tue, 18 Feb 2025 02:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847383;
	bh=40EJp7DBkCgrBj6rBLRwfYDFr6BqJRb/xw73BP7UMM4=;
	h=Date:To:From:Subject:From;
	b=wkGT4lhSL7UGDFz+CcIDRJ0503iBi6G/Y4IplJ/3HE7l0ySijATyqQeu9NeGJoS8d
	 m2hIgAU0EeKNph8EeHDhBWjldoDxMKNG3AI33zTor2CwnmWFv/4/b5/SJbXmyEsXVg
	 ugi1jm2/bckjIr9xEzCMtVW2cgaRl5XOn+ehONyw=
Date: Mon, 17 Feb 2025 18:56:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-remove-page_file_mapping.patch added to mm-unstable branch
Message-Id: <20250218025623.CE8D9C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: remove page_file_mapping()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-remove-page_file_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-remove-page_file_mapping.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: remove page_file_mapping()
Date: Mon, 17 Feb 2025 19:20:07 +0000

This wrapper has no more callers.  Delete it.

Link: https://lkml.kernel.org/r/20250217192009.437916-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/pagemap.h~fs-remove-page_file_mapping
+++ a/include/linux/pagemap.h
@@ -575,11 +575,6 @@ static inline struct address_space *foli
 	return folio_mapping(folio);
 }
 
-static inline struct address_space *page_file_mapping(struct page *page)
-{
-	return folio_file_mapping(page_folio(page));
-}
-
 /**
  * folio_inode - Get the host inode for this folio.
  * @folio: The folio.
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
fs-convert-block_commit_write-to-take-a-folio.patch
fs-remove-page_file_mapping.patch
fs-remove-folio_file_mapping.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

