Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1531802AB
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307374; cv=none; b=ibJSjDSsJ5Bb/mYSj0aSPi8MZFxEUEHQfbHs91HOx5/RJjxOsU0HIUx5TLT9ZZPcC/FQZMn5AnVb7CvauaQvcbYW9SlKPb7NFj3idVmI0nu0OdyHoRmR3H6ZHuOVf+UYYoprAGKa0DTsyc7QPEBXh2/yjjy/5COnLHCflBdx9ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307374; c=relaxed/simple;
	bh=5gdbl0+BCDBOLG2xsP9wkpuBGxvFuEC45AfOF2426Jg=;
	h=Date:To:From:Subject:Message-Id; b=STHzK1FswQO7wlts0Ku+CBTaTGGqzi/kcUhpmBpFu9PdyS5BGs8vUc/S1K4nptWqriN0Ck6T5XZyvlS1WM/wQ7h2Lbaq/Cp/JrfCIL0J4FWFtlknYxskSaBHpqtHU80PeM7JVedQh54pS6xo2ARvQaM9tlQ4LyOGNGBKyHPw9Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w/3MUddb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w/3MUddb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6D0C4CED0;
	Wed,  8 Jan 2025 03:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307373;
	bh=5gdbl0+BCDBOLG2xsP9wkpuBGxvFuEC45AfOF2426Jg=;
	h=Date:To:From:Subject:From;
	b=w/3MUddbFrxNI0YpVM9MMuWE1t+Gt0ldTXOQz9uVa8csDk9kzQC7zybtLJOr8cGD5
	 UwzG7nhiBR4TfWS9Z3zswxzmPhxjgM3umAyvCY7SvNA7/BJ7cXo8F89m8skByoJXjY
	 cSyudUJVGotNP5wmK/ueXQHAQQCrAL/y/yBB5Lzo=
Date: Tue, 07 Jan 2025 19:36:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-fgp_dontcache-folio-creation-flag.patch added to mm-unstable branch
Message-Id: <20250108033613.DA6D0C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add FGP_DONTCACHE folio creation flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-fgp_dontcache-folio-creation-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-fgp_dontcache-folio-creation-flag.patch

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
From: Jens Axboe <axboe@kernel.dk>
Subject: mm: add FGP_DONTCACHE folio creation flag
Date: Fri, 20 Dec 2024 08:47:50 -0700

Callers can pass this in for uncached folio creation, in which case if a
folio is newly created it gets marked as uncached.  If a folio exists for
this index and lookup succeeds, then it will not get marked as uncached. 
If an !uncached lookup finds a cached folio, clear the flag.  For that
case, there are competeting uncached and cached users of the folio, and it
should not get pruned.

Link: https://lkml.kernel.org/r/20241220154831.1086649-13-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 ++
 mm/filemap.c            |    5 +++++
 2 files changed, 7 insertions(+)

--- a/include/linux/pagemap.h~mm-add-fgp_dontcache-folio-creation-flag
+++ a/include/linux/pagemap.h
@@ -721,6 +721,7 @@ pgoff_t page_cache_prev_miss(struct addr
  * * %FGP_NOFS - __GFP_FS will get cleared in gfp.
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
+ * * %FGP_DONTCACHE - Uncached buffered IO
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -734,6 +735,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_NOWAIT		((__force fgf_t)0x00000020)
 #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
 #define FGP_STABLE		((__force fgf_t)0x00000080)
+#define FGP_DONTCACHE		((__force fgf_t)0x00000100)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
--- a/mm/filemap.c~mm-add-fgp_dontcache-folio-creation-flag
+++ a/mm/filemap.c
@@ -1973,6 +1973,8 @@ no_page:
 			/* Init accessed so avoid atomic mark_page_accessed later */
 			if (fgp_flags & FGP_ACCESSED)
 				__folio_set_referenced(folio);
+			if (fgp_flags & FGP_DONTCACHE)
+				__folio_set_dropbehind(folio);
 
 			err = filemap_add_folio(mapping, folio, index, gfp);
 			if (!err)
@@ -1995,6 +1997,9 @@ no_page:
 
 	if (!folio)
 		return ERR_PTR(-ENOENT);
+	/* not an uncached lookup, clear uncached if set */
+	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
+		folio_clear_dropbehind(folio);
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio);
_

Patches currently in -mm which might be from axboe@kernel.dk are

mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb.patch
mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch
mm-readahead-add-folio-allocation-helper.patch
mm-add-pg_dropbehind-folio-flag.patch
mm-readahead-add-readahead_control-dropbehind-member.patch
mm-truncate-add-folio_unmap_invalidate-helper.patch
fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch
mm-filemap-add-read-support-for-rwf_dontcache.patch
mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch
mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch
mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch
mm-add-fgp_dontcache-folio-creation-flag.patch

