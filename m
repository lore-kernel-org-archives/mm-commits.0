Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A571802AB
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307354; cv=none; b=MzGz58CDEHa4BA0cIZnmGzsPrGv91ffuJaPPfh83VMVbX3jty2AE+FXR7ru+0ZoTw19eD5kf1qbYDfOwqP4PFTD8VIV+N4XSJAOD42t+7XmxVuHxj/0y1rN+VX7UE/MF8D4ae3TOCe7u2UPIK2a+0M3I+yn4Rco0jKVRKID1/6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307354; c=relaxed/simple;
	bh=fjWkWESPwOarCRZ/tQbJ0ALRGspA+Iv/88Mt2r815Mc=;
	h=Date:To:From:Subject:Message-Id; b=n0XPtEU7Jmp6RQc1GDnXJMcoITfHsZqdlbBYC4e3ou+pwEKjKlPCJ6RVulg/NWqozqmP7GUHmg2YxuK9oyWAs+6MkPWsaaA3/bv6GJf5Ja3dTfrWnSrSI917hhAz32SDJw2OKVqYowyTMXNXIXXOAUpkOBf+JMPZ6CL1Y4hTJ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K1ExWWXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K1ExWWXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FE9C4CED0;
	Wed,  8 Jan 2025 03:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307353;
	bh=fjWkWESPwOarCRZ/tQbJ0ALRGspA+Iv/88Mt2r815Mc=;
	h=Date:To:From:Subject:From;
	b=K1ExWWXIxlL2uOF2y0VrC6xcnnke8ZALiJPROQ/ZB950s2nDGCuduUHt7D7Sypd2W
	 8KE2Y0a1IJNyBExRTdFHJAsultGtMjWTE7rz3mrFJoAH2vwy+l1jFSD226Kzm6bsSA
	 sAscrkQX9a7P7DkRykffNldmcGYK9AZlI2jnDHUY=
Date: Tue, 07 Jan 2025 19:35:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-add-folio-allocation-helper.patch added to mm-unstable branch
Message-Id: <20250108033553.90FE9C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: add folio allocation helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-readahead-add-folio-allocation-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-add-folio-allocation-helper.patch

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
Subject: mm/readahead: add folio allocation helper
Date: Fri, 20 Dec 2024 08:47:41 -0700

Just a wrapper around filemap_alloc_folio() for now, but add it in
preparation for modifying the folio based on the 'ractl' being passed in.

No functional changes in this patch.

Link: https://lkml.kernel.org/r/20241220154831.1086649-4-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/readahead.c~mm-readahead-add-folio-allocation-helper
+++ a/mm/readahead.c
@@ -178,6 +178,12 @@ static void read_pages(struct readahead_
 	BUG_ON(readahead_count(rac));
 }
 
+static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
+				       gfp_t gfp_mask, unsigned int order)
+{
+	return filemap_alloc_folio(gfp_mask, order);
+}
+
 /**
  * page_cache_ra_unbounded - Start unchecked readahead.
  * @ractl: Readahead control.
@@ -255,8 +261,8 @@ void page_cache_ra_unbounded(struct read
 			continue;
 		}
 
-		folio = filemap_alloc_folio(gfp_mask,
-					    mapping_min_folio_order(mapping));
+		folio = ractl_alloc_folio(ractl, gfp_mask,
+					mapping_min_folio_order(mapping));
 		if (!folio)
 			break;
 
@@ -426,7 +432,7 @@ static inline int ra_alloc_folio(struct
 		pgoff_t mark, unsigned int order, gfp_t gfp)
 {
 	int err;
-	struct folio *folio = filemap_alloc_folio(gfp, order);
+	struct folio *folio = ractl_alloc_folio(ractl, gfp, order);
 
 	if (!folio)
 		return -ENOMEM;
@@ -751,7 +757,7 @@ void readahead_expand(struct readahead_c
 		if (folio && !xa_is_value(folio))
 			return; /* Folio apparently present */
 
-		folio = filemap_alloc_folio(gfp_mask, min_order);
+		folio = ractl_alloc_folio(ractl, gfp_mask, min_order);
 		if (!folio)
 			return;
 
@@ -780,7 +786,7 @@ void readahead_expand(struct readahead_c
 		if (folio && !xa_is_value(folio))
 			return; /* Folio apparently present */
 
-		folio = filemap_alloc_folio(gfp_mask, min_order);
+		folio = ractl_alloc_folio(ractl, gfp_mask, min_order);
 		if (!folio)
 			return;
 
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

