Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF1F39ADB
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716582574; cv=none; b=TdqPy1QeldYFzRVEPdXLBr6pqX+wXdwuzVBnlzFu6Qxml/+rHP5GN51H702aOwTPxwzgA1qEDBUNfaNG8YrabprDfSJ9wV0DJPXU0+m1kYv/9SgIs4VjZt8zMckdkZfymSt5/7KALYD6/4uXNDXmY1tsxzzv/X9c0KxZNmbAp/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716582574; c=relaxed/simple;
	bh=LgwtCTN2dDrt4tOTN+hhM1pN4sQQRtuTeiBIFq5kMtE=;
	h=Date:To:From:Subject:Message-Id; b=M05XNA7l3CHZYs1DV6EVHZUlc7iPsslAiEjnpG1OEMLxtdY602kbMx2ONxRxYnjj5JcJYk2J4MQeuhjh5zXr9ago2eidU7Us1zXEEpe2PRvqZpL5BUiQTBrHhcQhMANTAlRXWpQqSSLpsxYJAQCao+xQF22M/YYSzhC+bHdgS0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HJvNfJ2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HJvNfJ2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DFEC2BBFC;
	Fri, 24 May 2024 20:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716582574;
	bh=LgwtCTN2dDrt4tOTN+hhM1pN4sQQRtuTeiBIFq5kMtE=;
	h=Date:To:From:Subject:From;
	b=HJvNfJ2oDOe9Lu+kRFUyTSH3ZkgFc2vOxWS24H1j5QtbNd1pvrCf5VK8PmkyJzr1s
	 QcqqzDnqbPW0HSuskZ8wpSnqy4c2hQmpGDsLdh07OZY1TTUqI3rO68fDc4Pm361iNT
	 ObgxP/cu9PobACpifoUaxHLWjL/83ISaUhki5GPo=
Date: Fri, 24 May 2024 13:29:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-make-same_filled-functions-folio-friendly.patch added to mm-unstable branch
Message-Id: <20240524202933.F2DFEC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: make same_filled functions folio-friendly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-make-same_filled-functions-folio-friendly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-make-same_filled-functions-folio-friendly.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: make same_filled functions folio-friendly
Date: Fri, 24 May 2024 03:38:18 +0000

A variable name 'page' is used in zswap_is_folio_same_filled() and
zswap_fill_page() to point at the kmapped data in a folio. Use 'data'
instead to avoid confusion and stop it from showing up when searching
for 'page' references in mm/zswap.c.

While we are at it, move the kmap/kunmap calls into zswap_fill_page(),
make it take in a folio, and rename it to zswap_fill_folio().

Link: https://lkml.kernel.org/r/20240524033819.1953587-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/mm/zswap.c~mm-zswap-make-same_filled-functions-folio-friendly
+++ a/mm/zswap.c
@@ -1375,35 +1375,35 @@ resched:
 **********************************/
 static bool zswap_is_folio_same_filled(struct folio *folio, unsigned long *value)
 {
-	unsigned long *page;
+	unsigned long *data;
 	unsigned long val;
-	unsigned int pos, last_pos = PAGE_SIZE / sizeof(*page) - 1;
+	unsigned int pos, last_pos = PAGE_SIZE / sizeof(*data) - 1;
 	bool ret = false;
 
-	page = kmap_local_folio(folio, 0);
-	val = page[0];
+	data = kmap_local_folio(folio, 0);
+	val = data[0];
 
-	if (val != page[last_pos])
+	if (val != data[last_pos])
 		goto out;
 
 	for (pos = 1; pos < last_pos; pos++) {
-		if (val != page[pos])
+		if (val != data[pos])
 			goto out;
 	}
 
 	*value = val;
 	ret = true;
 out:
-	kunmap_local(page);
+	kunmap_local(data);
 	return ret;
 }
 
-static void zswap_fill_page(void *ptr, unsigned long value)
+static void zswap_fill_folio(struct folio *folio, unsigned long value)
 {
-	unsigned long *page;
+	unsigned long *data = kmap_local_folio(folio, 0);
 
-	page = (unsigned long *)ptr;
-	memset_l(page, value, PAGE_SIZE / sizeof(unsigned long));
+	memset_l(data, value, PAGE_SIZE / sizeof(unsigned long));
+	kunmap_local(data);
 }
 
 /*********************************
@@ -1554,7 +1554,6 @@ bool zswap_load(struct folio *folio)
 	bool swapcache = folio_test_swapcache(folio);
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
-	u8 *dst;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
@@ -1580,11 +1579,8 @@ bool zswap_load(struct folio *folio)
 
 	if (entry->length)
 		zswap_decompress(entry, folio);
-	else {
-		dst = kmap_local_folio(folio, 0);
-		zswap_fill_page(dst, entry->value);
-		kunmap_local(dst);
-	}
+	else
+		zswap_fill_folio(folio, entry->value);
 
 	count_vm_event(ZSWPIN);
 	if (entry->objcg)
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch

