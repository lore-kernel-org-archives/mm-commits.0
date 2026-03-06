Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6272D2BEC3F
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 21:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772832431; cv=none; b=txxf2NKt9CqKYWK2S94p5HbVAAKNI/oMM8UkVsN2dWt5tuqM3qbVCGGqfasKsRdcQWHTpphOKnMo8UQ24OLGpCY34gpsb3DnYiWD5XtV8Pf6neKV4PxKk60C5hj7I4knnSYyGehsJpNmn+ABe8Mc0cBuCufnky9k4VhwkTaJ95Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772832431; c=relaxed/simple;
	bh=SV9nGRRpUFfw0uXIJu+VcGB9KQZE3bqczj6W35FT6Vk=;
	h=Date:To:From:Subject:Message-Id; b=WMWo0ubiBHSnyowyE0q7Rj+p4NP04Opqs15M2N+DoBz9XBkIZm8J0QLsUbchdlLLiTYqoMXi3G9n/B7IgcdwfbmmYlCcV3KDv5PVorAGl5a3H1QtlgdPIKJP2DB69UqMaVTDrfIUeMShW2d8xsieJF98JUYxZxE23OY5P+u/T6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L2DNsGQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L2DNsGQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07DBC4CEF7;
	Fri,  6 Mar 2026 21:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772832431;
	bh=SV9nGRRpUFfw0uXIJu+VcGB9KQZE3bqczj6W35FT6Vk=;
	h=Date:To:From:Subject:From;
	b=L2DNsGQaa/RhDmoq/50Xv9ILOPmkKvO9MwK5h5pKl7Sui6utRVM9pt1CYtFlDN8Tb
	 rJI7LL2TUtHxeY1I3xDZNIsD7S3ec1A0TE7qTsIamfuOWYExVwko7h2V4QKBUgEAWV
	 02uZtbLTQVW3EVxlRnrtX34Xtgc02yA2kFuQNNtw=
Date: Fri, 06 Mar 2026 13:27:10 -0800
To: mm-commits@vger.kernel.org,yi.l.liu@intel.com,willy@infradead.org,kevin.tian@intel.com,jgg@ziepe.ca,jgg@nvidia.com,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch added to mm-nonmm-unstable branch
Message-Id: <20260306212710.E07DBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/idr: fix ida_find_first_range() missing IDs across chunk boundaries
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

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
From: Josh Law <objecting@objecting.org>
Subject: lib/idr: fix ida_find_first_range() missing IDs across chunk boundaries
Date: Fri, 6 Mar 2026 20:30:47 +0000

ida_find_first_range() only examines the first XArray entry returned by
xa_find().  If that entry does not contain a set bit at or above the
requested offset, the function returns -ENOENT without searching
subsequent entries, even though later chunks may contain allocated IDs
within the requested range.

For example, a DRM driver using IDA to manage connector IDs may allocate
IDs across multiple 1024-bit IDA chunks.  If early IDs are freed and the
driver calls ida_find_first_range() with a min that falls into a sparsely
populated first chunk, valid IDs in higher chunks are silently missed. 
This can cause the driver to incorrectly conclude no connectors exist in
the queried range, leading to stale connector state or failed hotplug
detection.

Fix this by looping over xa_find()/xa_find_after() to continue searching
subsequent entries when the current one has no matching bit.

Link: https://lkml.kernel.org/r/20260306203047.2821852-1-objecting@objecting.org
Fixes: 7fe6b987166b ("ida: Add ida_find_first_range()")
Signed-off-by: Josh Law <objecting@objecting.org>
Cc: Yi Liu <yi.l.liu@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liu Yi L <yi.l.liu@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c      |   57 ++++++++++++++++++++---------------------------
 lib/test_ida.c |   14 +++++++++++
 2 files changed, 39 insertions(+), 32 deletions(-)

--- a/lib/idr.c~lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries
+++ a/lib/idr.c
@@ -495,10 +495,9 @@ int ida_find_first_range(struct ida *ida
 	unsigned long index = min / IDA_BITMAP_BITS;
 	unsigned int offset = min % IDA_BITMAP_BITS;
 	unsigned long *addr, size, bit;
-	unsigned long tmp = 0;
+	unsigned long tmp;
 	unsigned long flags;
 	void *entry;
-	int ret;
 
 	if ((int)min < 0)
 		return -EINVAL;
@@ -508,40 +507,34 @@ int ida_find_first_range(struct ida *ida
 	xa_lock_irqsave(&ida->xa, flags);
 
 	entry = xa_find(&ida->xa, &index, max / IDA_BITMAP_BITS, XA_PRESENT);
-	if (!entry) {
-		ret = -ENOENT;
-		goto err_unlock;
-	}
-
-	if (index > min / IDA_BITMAP_BITS)
-		offset = 0;
-	if (index * IDA_BITMAP_BITS + offset > max) {
-		ret = -ENOENT;
-		goto err_unlock;
-	}
+	while (entry) {
+		if (index > min / IDA_BITMAP_BITS)
+			offset = 0;
+		if (index * IDA_BITMAP_BITS + offset > max)
+			break;
+
+		if (xa_is_value(entry)) {
+			tmp = xa_to_value(entry);
+			addr = &tmp;
+			size = BITS_PER_XA_VALUE;
+		} else {
+			addr = ((struct ida_bitmap *)entry)->bitmap;
+			size = IDA_BITMAP_BITS;
+		}
+
+		bit = find_next_bit(addr, size, offset);
+		if (bit < size &&
+		    index * IDA_BITMAP_BITS + bit <= max) {
+			xa_unlock_irqrestore(&ida->xa, flags);
+			return index * IDA_BITMAP_BITS + bit;
+		}
 
-	if (xa_is_value(entry)) {
-		tmp = xa_to_value(entry);
-		addr = &tmp;
-		size = BITS_PER_XA_VALUE;
-	} else {
-		addr = ((struct ida_bitmap *)entry)->bitmap;
-		size = IDA_BITMAP_BITS;
+		entry = xa_find_after(&ida->xa, &index,
+				      max / IDA_BITMAP_BITS, XA_PRESENT);
 	}
 
-	bit = find_next_bit(addr, size, offset);
-
-	xa_unlock_irqrestore(&ida->xa, flags);
-
-	if (bit == size ||
-	    index * IDA_BITMAP_BITS + bit > max)
-		return -ENOENT;
-
-	return index * IDA_BITMAP_BITS + bit;
-
-err_unlock:
 	xa_unlock_irqrestore(&ida->xa, flags);
-	return ret;
+	return -ENOENT;
 }
 EXPORT_SYMBOL(ida_find_first_range);
 
--- a/lib/test_ida.c~lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries
+++ a/lib/test_ida.c
@@ -256,6 +256,20 @@ static void ida_check_find_first(struct
 	ida_free(ida, (1 << 20) - 1);
 
 	IDA_BUG_ON(ida, !ida_is_empty(ida));
+
+	/* 
+	 * Test cross-chunk search.
+	 * Allocate ID in chunk 0 and ID in chunk 1.
+	 * Search for ID >= 1. min=1 maps to chunk 0. Chunk 0 has no IDs >= 1.
+	 * It should continue to chunk 1 and return 1024.
+	 */
+	IDA_BUG_ON(ida, ida_alloc_min(ida, 0, GFP_KERNEL) != 0);
+	IDA_BUG_ON(ida, ida_alloc_min(ida, 1024, GFP_KERNEL) != 1024);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 1, INT_MAX) != 1024);
+	ida_free(ida, 0);
+	ida_free(ida, 1024);
+
+	IDA_BUG_ON(ida, !ida_is_empty(ida));
 }
 
 static DEFINE_IDA(ida);
_

Patches currently in -mm which might be from objecting@objecting.org are

lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
lib-bug-remove-unnecessary-variable-initializations.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

