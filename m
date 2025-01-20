Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03211DF78
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337154; cv=none; b=SyjsFClJ9WQE5p9O5RSV3GojzHKYFgZ46co1TiEAQaJo1R/ykbJxDVQ1CxJfiBs41qq4/m2uDSm8POYg9jmWEVpHCZK+MUCcEdamawxO7Mo4LP0g78NOGEyy8QMII4dFFmgRnIZhQb7qhJZdaphj6CtCDx/CkytqsIuxFs/+j3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337154; c=relaxed/simple;
	bh=WVoe3B7GRhaloUzGoLTosEb0ztN2eFOoPw93i/EqWug=;
	h=Date:To:From:Subject:Message-Id; b=eCXDwTgm3ZsGv8cs8+E0DQ+/xK8vD16VhVZCoSGscAcXANqJxSIfFie7iXuXM3QBw5504xhWPHj2B1s1HKmSv2lQ4171tTClcB82aAnN+jopcOBze/x0/z8/OKa98E//Ecn5vX4C0ZDcljLl9dQHmmwo1feyLEtfoL5iA/m5h7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jTy2HRiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jTy2HRiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABE8C4CED6;
	Mon, 20 Jan 2025 01:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337153;
	bh=WVoe3B7GRhaloUzGoLTosEb0ztN2eFOoPw93i/EqWug=;
	h=Date:To:From:Subject:From;
	b=jTy2HRiTtL1mFvhCu47NILiGnGFx8UH2KzLOVXwGFAoKs7yXVnsAaJ4wUWa5nBYhm
	 PAKT4XkfTcGsLj4qgU05TN5akUGY7kX/FEFC9jImGMBEP+TcAbIUX6wmgbGaSnfr2a
	 uuGOq7qiAI2uV56IUigHDdKgYxp6oDh8fDIiZ0+E=
Date: Sun, 19 Jan 2025 17:39:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-fgp_dontcache-folio-creation-flag.patch removed from -mm tree
Message-Id: <20250120013913.CABE8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add FGP_DONTCACHE folio creation flag
has been removed from the -mm tree.  Its filename was
     mm-add-fgp_dontcache-folio-creation-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -710,6 +710,7 @@ pgoff_t page_cache_prev_miss(struct addr
  * * %FGP_NOFS - __GFP_FS will get cleared in gfp.
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
+ * * %FGP_DONTCACHE - Uncached buffered IO
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -723,6 +724,7 @@ typedef unsigned int __bitwise fgf_t;
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


