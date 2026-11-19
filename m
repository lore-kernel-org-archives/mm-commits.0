Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066533;
	b=GXavrsk2+2vQXuS0OGLpOFeVOv2f3VvnTEYcREJWstm3kRpG1QkSVlkO2FDhxRxs1gj6
	 Xb1S2ug5GcZf4NjsuVV4MWFPMt6XLYESLY+qLUwUL6fqn+miFO/NQUBwyyu8RJ9L7i3jf
	 ETt7fgf+/wJpE+OHUcZOxXKjTFm71tjiKklv7jScqVMcwA1FoXPiNgspKUBx10b0lDeSL
	 M9jUkRILuMc42dwWCzpWP/qmyjasnpHb4i/ia3nUkYc+wT2NBWpmO0GywQiMvEKXd6tcG
	 qzwgM3PQdm2ZREO/0mLRdvnRHoOVvQwLyJPWccuB+jGCCheVSkgc8Er8emers/HN7nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066533;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=bjWG2bMG1cmryud9Z6TSj/cJSp8GgtKHvNFmLevhlXI=;
	b=3zLPKfGMbFcLPlozWSHfdz6RVsL33X++56PLpM2IjQigZdRIadXOn2WObOaK7cgJ36cY
	 zd/ueXroy8m8MoNHMtCxx5yIfL/+Tne8EYcxX8Tp62Z01EeOU0e8gNdX0kGhXdb5410iR
	 xCstQtkeAOio07lNuL1jfM7zV3xVI4NjqYpYoBbhNDjMf8LjgZPX3BChGgARaqh4b7hmu
	 /0fe7B5ojUs+w80TwaR+s0hNGtwC8pOhcPOSBaCS/ZpKbmLl8p6tnnRNpSyeEtp4Mx/qe
	 H0wZzYxIJfSSIxcS7apgmTFvqBo8vxccorYcXuXWy6P6QDOyUJ0Ucd1zGJD7LC+4qHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o+13RTNl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D5B606A334
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o+13RTNl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679801F000C6;
	Thu, 19 Nov 2026 05:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795066532;
	bh=bjWG2bMG1cmryud9Z6TSj/cJSp8GgtKHvNFmLevhlXI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=o+13RTNlARmJ4jkKapKQTHe6XrYxiEHdm3NIW9l/0R65Jhokj1cvLOpStmvt7ScF5
	 SIs+M249p4Nl2xbuMC9mbmUoqMypNhtcadNIDDbqtfMxuIBH0egUlNh0iequTycgmJ
	 0v8JyE6Ii4YiTqo01JblSB16Iig5/EqNG1lLbuMQ=
Date: Wed, 18 Nov 2026 21:35:31 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,willy@infradead.org,
	vbabka@kernel.org,shikemeng@huaweicloud.com,senozhatsky@chromium.org,
	pfalcato@suse.de,nphamcs@gmail.com,minchan@kernel.org,ljs@kernel.org,
	liam@infradead.org,kasong@tencent.com,jannh@google.com,jack@suse.cz,
	dev.jain@arm.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,
	shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-unused-sym-mm-v2-1-2f845e94dd50@amd.com>
References: <20261117-unused-sym-mm-v2-1-2f845e94dd50@amd.com>
Subject: + mm-remove-unused-helpers-from-pagemaph.patch added to mm-nonmm-unstable branch
Message-Id: <20261119053532.679801F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove unused helpers from pagemap.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-remove-unused-helpers-from-pagemaph.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-helpers-from-pagemaph.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm: remove unused helpers from pagemap.h
Date: Tue, 17 Nov 2026 07:16:48 +0000

Patch series "mm: remove unused functions", v2.

This series removes five functions and one variable in mm that have no
users left anywhere in the tree. I found them with the kunused scripts
[1], which I wrote with LLM's help. The v1 cover letter [2] has more
details on the scripts and how LLM was used.


This patch (of 5):

invalidate_remote_inode() lost its last user in commit d73065e60dcc
("afs: Use alternative invalidation to using launder_folio").
mapping_clear_release_always() has no callers.

Link: https://lore.kernel.org/20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com
Link: https://patch.msgid.link/20261117-unused-sym-mm-v2-1-2f845e94dd50@amd.com
Link: https://github.com/AMDESE/linux-mm/tree/shivank/kunused [1]
Link: https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com [2]
Signed-off-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>

 include/linux/pagemap.h |   11 -----------
 1 file changed, 11 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-unused-helpers-from-pagemaph
+++ a/include/linux/pagemap.h
@@ -20,12 +20,6 @@ struct folio_batch;
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
 
-static inline void invalidate_remote_inode(struct inode *inode)
-{
-	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-	    S_ISLNK(inode->i_mode))
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
-}
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
@@ -298,11 +292,6 @@ static inline void mapping_set_release_a
 	set_bit(AS_RELEASE_ALWAYS, &mapping->flags);
 }
 
-static inline void mapping_clear_release_always(struct address_space *mapping)
-{
-	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
-}
-
 static inline bool mapping_stable_writes(const struct address_space *mapping)
 {
 	return test_bit(AS_STABLE_WRITES, &mapping->flags);
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-remove-unused-helpers-from-pagemaph.patch
mm-swapops-remove-unused-make_guard_swp_entry.patch
mm-swap-remove-unused-folio_to_swp_tb.patch
mm-zsmalloc-remove-unused-zpdesc_lock.patch
mm-nommu-remove-unused-heap_stack_gap.patch

