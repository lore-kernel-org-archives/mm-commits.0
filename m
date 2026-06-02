Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742E03C4178
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439221; cv=none; b=EyDCvw5+TrjsTa20ok7e1iPGkn5ZRFe35gFLx/wY/n9B1mTD8x0xitV//5A7lD67cSffLWZsSZa9oz5HMkKDyXbWmII3xm2gNBki9jIqXy8mzqPGvvAiqQpsFn7LYHXUHtJVcqKmcWbEDifH6uvCmSO8HtV2AXZGgr6fje2lb/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439221; c=relaxed/simple;
	bh=+5rtpL2YO2PaAgrqihOdzeoDCUYO+nfdubuD04WKQ0E=;
	h=Date:To:From:Subject:Message-Id; b=jDutWxvga52taTBr7apNyFFL0LCAs5yyvV5OGqQwVIHoy1Xr0F6T2X4bcSD3FEsW43XNurZBZU4n371fY+ezqbrhbn0b4pTWUYDuOWoUMyUVy6vHH5/dWHNn7WbB7I+CaifT0GkdTCOrkl9Ndc/gvW3IqtT4RH+7gHSpvV58VGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j/efCjb5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j/efCjb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4741F00893;
	Tue,  2 Jun 2026 22:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439220;
	bh=cO2J2aqzhSLwPnP3PUP2LN8pZEd3uhKAAyxko6AlN+g=;
	h=Date:To:From:Subject;
	b=j/efCjb5qhtjuI0ogkkduhjV+BQzHAdOLuqmGvFIGQ8uAvt3zNd0xyFOPqZU6ZOqP
	 1C0nxwVtnc71uc5kWIb/y6Xicgea8y7YKZA19spgPJnHtbCJBBjtOiYoLlCQffFMAz
	 hWoWt55fWI+DXSv1kVl0BZJCkgV0QTil/uJBruN8=
Date: Tue, 02 Jun 2026 15:26:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-the-folio-refcount-a-little-better.patch removed from -mm tree
Message-Id: <20260602222700.4E4741F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: document the folio refcount a little better
has been removed from the -mm tree.  Its filename was
     mm-document-the-folio-refcount-a-little-better.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: document the folio refcount a little better
Date: Tue, 26 May 2026 21:00:30 +0100

Expand the documentation of folio_ref_count() to talk about expected,
temporary and spurious refcounts as well as the concept of freezing.

Link: https://lore.kernel.org/20260526200032.353868-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/page_ref.h~mm-document-the-folio-refcount-a-little-better
+++ a/include/linux/page_ref.h
@@ -71,6 +71,12 @@ static inline int page_ref_count(const s
  * folio_ref_count - The reference count on this folio.
  * @folio: The folio.
  *
+ * Folios contain a reference count.  When that reference count reaches
+ * zero, the folio is referred to as frozen.  At this point, it will
+ * usually be returned to the memory allocator, but some parts of the
+ * kernel freeze folios in order to perform unusual operations on them
+ * such as splitting or migration.
+ *
  * The refcount is usually incremented by calls to folio_get() and
  * decremented by calls to folio_put().  Some typical users of the
  * folio refcount:
@@ -82,6 +88,18 @@ static inline int page_ref_count(const s
  * - Pipes
  * - Direct IO which references this page in the process address space
  *
+ * The reference count has three components: expected, temporary and
+ * spurious.  The expected reference count of a folio is that which
+ * we would logically expect it to be from just reading the code.
+ * Temporary refcounts are gained by threads which need a temporary
+ * reference to make sure the folio isn't reallocated while they use it.
+ * Spurious refcounts are gained by threads which, thanks to RCU walks
+ * of the page tables or file cache, find a stale pointer to a folio.
+ * These threads will drop the refcount after discoveering the pointer
+ * is stale, but it can surprise other users to see the spurious refcount
+ * on a freshly allocated folio (eg they may see a refcount of 2 instead
+ * of 1).
+ *
  * Return: The number of references to this folio.
  */
 static inline int folio_ref_count(const struct folio *folio)
_

Patches currently in -mm which might be from willy@infradead.org are


