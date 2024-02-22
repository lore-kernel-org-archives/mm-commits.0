Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166724685
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560104; cv=none; b=efWT4KSO9iSpsjyto+vxXmiKbf++y+A0nkVUpZBZUcKYBh7i81yJ2HktWMjpiHlMCBq+xLQn4Lw6XJHQ6N0pAS1iNnAyV6Av9dXXm5DpIFu1rCdRO50zQIWNiQ/No7wG1KEN/0bAxnRw7/CHf2IzCEVilHjbCyqwCu7Y8YC1qHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560104; c=relaxed/simple;
	bh=5J93fvX0rBqynYhzOULyJXp/xzOzpe+TU3W2+B5t/zM=;
	h=Date:To:From:Subject:Message-Id; b=sxOxY1FV6+qzRN8SDy9F7azG5CRgr7L3GFzz4LowzCEKlWMEadaX05Y66BOAuyo1faQfxcb8OvbmjLHuKOl5h+MvrJtpH5NeL43bj8UKKOw+91mFsi4zWbNMY/0lFPkEMkxSdcUVMwQT4zOYGrA5lU7oblB+ReHc0RTWFRZIqLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jWJJEWIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jWJJEWIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE197C43394;
	Thu, 22 Feb 2024 00:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560104;
	bh=5J93fvX0rBqynYhzOULyJXp/xzOzpe+TU3W2+B5t/zM=;
	h=Date:To:From:Subject:From;
	b=jWJJEWIrCel8rAfjRAdUUgVIIaBmhxyUBO0OtEvdxZsW2N/3qHasTCdkqPkzgJOeJ
	 QFXivI7DzIj5LwHF2aHX58Gw0v/O+LxMMrwBTM4CYGzXaTqo0jkysPXiWgDt70GZS4
	 k1Bv5DC0G3BnHL/PWOZC5lnj4Rz/U7j+uDsdfup8=
Date: Wed, 21 Feb 2024 16:01:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] highmem-add-kernel-doc-for-memcpy__folio.patch removed from -mm tree
Message-Id: <20240222000143.DE197C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: highmem: add kernel-doc for memcpy_*_folio()
has been removed from the -mm tree.  Its filename was
     highmem-add-kernel-doc-for-memcpy__folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: highmem: add kernel-doc for memcpy_*_folio()
Date: Wed, 24 Jan 2024 18:12:15 +0000

This was inadvertently skipped when adding the new functions.

Link: https://lkml.kernel.org/r/20240124181217.1761674-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/highmem.h~highmem-add-kernel-doc-for-memcpy__folio
+++ a/include/linux/highmem.h
@@ -439,6 +439,13 @@ static inline void memzero_page(struct p
 	kunmap_local(addr);
 }
 
+/**
+ * memcpy_from_folio - Copy a range of bytes from a folio.
+ * @to: The memory to copy to.
+ * @folio: The folio to read from.
+ * @offset: The first byte in the folio to read.
+ * @len: The number of bytes to copy.
+ */
 static inline void memcpy_from_folio(char *to, struct folio *folio,
 		size_t offset, size_t len)
 {
@@ -460,6 +467,13 @@ static inline void memcpy_from_folio(cha
 	} while (len > 0);
 }
 
+/**
+ * memcpy_to_folio - Copy a range of bytes to a folio.
+ * @folio: The folio to write to.
+ * @offset: The first byte in the folio to store to.
+ * @from: The memory to copy from.
+ * @len: The number of bytes to copy.
+ */
 static inline void memcpy_to_folio(struct folio *folio, size_t offset,
 		const char *from, size_t len)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

