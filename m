Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F3E298CCF
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489846; cv=none; b=gx6mv24bJxZ5GJPRq3toAe8047w1pYyP9cnJc7mW4kjSugQSJ+g/lMgn9V6/ojzC7+KlUMJY3Asedx0ufwWv7rSxHTT1LWnZbJ821x80BTTBN6rPKBaZz5Z9Nu06olgSKL2ByGq1Ki9/FxcFg/5hIAJvZxFwpsdVPhbiVVl0FXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489846; c=relaxed/simple;
	bh=idXPRZ4/YGwR5ManeQBluJ8n+UT8tQKPPS1rHkEGqCA=;
	h=Date:To:From:Subject:Message-Id; b=dkvfDcLZmfWvrgRYeM/hZ+dZlgtzGRVnXwGIZB85bAHaQuysvkSm/mydaz4gSy1DgaActJj7zv/U0obkTJAks/xHDtsbXloOTlRTdqDugtLttA9waPritwg6KXOAoH/Eb1B2umgPlFD28S8bCxkUvtpFHoL6lojqQ5flfznV1Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNuPLzqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNuPLzqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA66C4CEE7;
	Sun, 21 Sep 2025 21:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489846;
	bh=idXPRZ4/YGwR5ManeQBluJ8n+UT8tQKPPS1rHkEGqCA=;
	h=Date:To:From:Subject:From;
	b=LNuPLzqGUeHG7O3ByypLtLR2GX+pPOMzizcTBA4CKqkI2Smjr1lHNwDihNDcW8/nq
	 fKlT93086r3YPbsxV9+BkpcIFhYHXxNS0PFfm1fLhd5Ybx4dh87wnD8N0Z09e+22uz
	 h0++Vw2yaFcgIQ3gyPl8R/D68qRuqDox5KvKu3iY=
Date: Sun, 21 Sep 2025 14:24:05 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,herbert@gondor.apana.org.au,davem@davemloft.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] crypto-remove-nth_page-usage-within-sg-entry.patch removed from -mm tree
Message-Id: <20250921212406.6BA66C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crypto: remove nth_page() usage within SG entry
has been removed from the -mm tree.  Its filename was
     crypto-remove-nth_page-usage-within-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: crypto: remove nth_page() usage within SG entry
Date: Mon, 1 Sep 2025 17:03:54 +0200

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-34-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/ahash.c               |    4 ++--
 crypto/scompress.c           |    8 ++++----
 include/crypto/scatterwalk.h |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/crypto/ahash.c~crypto-remove-nth_page-usage-within-sg-entry
+++ a/crypto/ahash.c
@@ -88,7 +88,7 @@ static int hash_walk_new_entry(struct cr
 
 	sg = walk->sg;
 	walk->offset = sg->offset;
-	walk->pg = nth_page(sg_page(walk->sg), (walk->offset >> PAGE_SHIFT));
+	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
 	walk->offset = offset_in_page(walk->offset);
 	walk->entrylen = sg->length;
 
@@ -226,7 +226,7 @@ int shash_ahash_digest(struct ahash_requ
 	if (!IS_ENABLED(CONFIG_HIGHMEM))
 		return crypto_shash_digest(desc, data, nbytes, req->result);
 
-	page = nth_page(page, offset >> PAGE_SHIFT);
+	page += offset >> PAGE_SHIFT;
 	offset = offset_in_page(offset);
 
 	if (nbytes > (unsigned int)PAGE_SIZE - offset)
--- a/crypto/scompress.c~crypto-remove-nth_page-usage-within-sg-entry
+++ a/crypto/scompress.c
@@ -198,7 +198,7 @@ static int scomp_acomp_comp_decomp(struc
 		} else
 			return -ENOSYS;
 
-		dpage = nth_page(dpage, doff / PAGE_SIZE);
+		dpage += doff / PAGE_SIZE;
 		doff = offset_in_page(doff);
 
 		n = (dlen - 1) / PAGE_SIZE;
@@ -220,12 +220,12 @@ static int scomp_acomp_comp_decomp(struc
 			} else
 				break;
 
-			spage = nth_page(spage, soff / PAGE_SIZE);
+			spage = spage + soff / PAGE_SIZE;
 			soff = offset_in_page(soff);
 
 			n = (slen - 1) / PAGE_SIZE;
 			n += (offset_in_page(slen - 1) + soff) / PAGE_SIZE;
-			if (PageHighMem(nth_page(spage, n)) &&
+			if (PageHighMem(spage + n) &&
 			    size_add(soff, slen) > PAGE_SIZE)
 				break;
 			src = kmap_local_page(spage) + soff;
@@ -270,7 +270,7 @@ static int scomp_acomp_comp_decomp(struc
 			if (dlen <= PAGE_SIZE)
 				break;
 			dlen -= PAGE_SIZE;
-			dpage = nth_page(dpage, 1);
+			dpage++;
 		}
 	}
 
--- a/include/crypto/scatterwalk.h~crypto-remove-nth_page-usage-within-sg-entry
+++ a/include/crypto/scatterwalk.h
@@ -159,7 +159,7 @@ static inline void scatterwalk_map(struc
 	if (IS_ENABLED(CONFIG_HIGHMEM)) {
 		struct page *page;
 
-		page = nth_page(base_page, offset >> PAGE_SHIFT);
+		page = base_page + (offset >> PAGE_SHIFT);
 		offset = offset_in_page(offset);
 		addr = kmap_local_page(page) + offset;
 	} else {
@@ -259,7 +259,7 @@ static inline void scatterwalk_done_dst(
 		end += (offset_in_page(offset) + offset_in_page(nbytes) +
 			PAGE_SIZE - 1) >> PAGE_SHIFT;
 		for (i = start; i < end; i++)
-			flush_dcache_page(nth_page(base_page, i));
+			flush_dcache_page(base_page + i);
 	}
 	scatterwalk_advance(walk, nbytes);
 }
_

Patches currently in -mm which might be from david@redhat.com are


