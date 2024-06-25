Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8805A11D
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291604; cv=none; b=lLV4plMCsZKWBI43wGVol/8q3fLhCBEMn0art8Yq6kFdgeKz60+w8xpNhbv1TLd7vjPksnh2At/HgrY66GDgtAKMltn1bG/uK7ggeu6dpQm2tTZPfIHMNs+EnXGFQwpZbRLVkELa/q9MmjyCDfYuXrpH9vbE9v9uJRm+MkBXuag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291604; c=relaxed/simple;
	bh=76EWH/+rkLIpILps5G77toE5XSuULTusRcyRaw84Ayo=;
	h=Date:To:From:Subject:Message-Id; b=ny4eaWMIRp+hbiII09FjecbUiuFJPRrn2cFnNaUO2QUa2eIUi3zpa4SexoNiv41prVDVR6GXNrplFyyXa6zfNt6Mb0WV2lFdeZiJPNQ7dKvv5VZOPHhUuQCadOPd2xjl1ZSGsJFK+y9u4sGgq7nhVnI1tjkd9gKjutqbTh2D/n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m77GGhiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m77GGhiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5131FC32782;
	Tue, 25 Jun 2024 05:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291604;
	bh=76EWH/+rkLIpILps5G77toE5XSuULTusRcyRaw84Ayo=;
	h=Date:To:From:Subject:From;
	b=m77GGhiVLMoCNXlbg87CIkodhBhPuVYmpng7z6GEjQiRynH1plfnS3L4Q5K1uPv3B
	 /YV0/2q7j10Gh42HDxAaGBkR9qdTOKOpsvrqKOHYrnMvGbKwn/4Ge9o6VnR/6ucFg/
	 iguXMXXHlT0Ol6ym4W4WFalrjz6DemRH2KsCixRU=
Date: Mon, 24 Jun 2024 22:00:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-make-same_filled-functions-folio-friendly.patch removed from -mm tree
Message-Id: <20240625050004.5131FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: make same_filled functions folio-friendly
has been removed from the -mm tree.  Its filename was
     mm-zswap-make-same_filled-functions-folio-friendly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
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


