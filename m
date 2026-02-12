Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B932E8B9F
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939841; cv=none; b=j+ttOI+oGYxWmL452KugRyRAyMqJuOp1Ax9InqpQ6dL/fgUhke4MRYXMHAIre2U2OnsZ1lv6vrRn1nb6Ahyx5ZSmtKSRr0snE0qjODgpGVfw65h05l2Su13cSGq3AnNXC1GC8jvRE23dKD0Ue7KFi9tHnd8jK5vWtVk+JdwwwWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939841; c=relaxed/simple;
	bh=0v06fySjE5nenZroch/SEmV7SiDfIWhVuUwSDoY6ras=;
	h=Date:To:From:Subject:Message-Id; b=GZWQxF+nrVamwUwHuXPHfuN8BM+CEqmhpQyb4uRWqc+6ulzdpXPMcaMlvxq0Vz956Qw8eQGAOUxbUFJgT7R6Qm5woJNGI6KqYQOBqCogBzPm06S0sRNepcj6hwe+OG3UD1XX8SeLY0kjI1j96V9N1KyuLh+Ni32GkzVTZl06S+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DVzxB+N2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DVzxB+N2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF20C4CEF7;
	Thu, 12 Feb 2026 23:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939841;
	bh=0v06fySjE5nenZroch/SEmV7SiDfIWhVuUwSDoY6ras=;
	h=Date:To:From:Subject:From;
	b=DVzxB+N2MpKw07r5iIBo2jZicyD3bUjJ+wJcJpDJXRRqIfj3hcp14Mnx9XnJqI5u+
	 4vzv39LETuuXQE/bFz5dpSzZ6wv6vC0La6fJkAE2xZHT/kovyXueSEJROcPJrogZuh
	 e1HOrfM4uncqXtTMDlRLPoe9rED41llCue3pxkEE=
Date: Thu, 12 Feb 2026 15:44:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,Liam.Howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-bitmap-add-missing-bitmap_.patch removed from -mm tree
Message-Id: <20260212234401.0FF20C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: bitmap: add missing bitmap_[subset(), andnot()]
has been removed from the -mm tree.  Its filename was
     tools-bitmap-add-missing-bitmap_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools: bitmap: add missing bitmap_[subset(), andnot()]
Date: Thu, 22 Jan 2026 16:06:13 +0000

The bitmap_subset() and bitmap_andnot() functions are not present in the
tools version of include/linux/bitmap.h, so add them as subsequent patches
implement test code that requires them.

We also add the missing __bitmap_subset() to tools/lib/bitmap.c.

Link: https://lkml.kernel.org/r/0fd0d4ec868297f522003cb4b5898b53b498805b.1769097829.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Chris Mason <clm@fb.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/bitmap.h |   22 ++++++++++++++++++++++
 tools/lib/bitmap.c           |   29 +++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

--- a/tools/include/linux/bitmap.h~tools-bitmap-add-missing-bitmap_
+++ a/tools/include/linux/bitmap.h
@@ -24,6 +24,10 @@ void __bitmap_set(unsigned long *map, un
 void __bitmap_clear(unsigned long *map, unsigned int start, int len);
 bool __bitmap_intersects(const unsigned long *bitmap1,
 			 const unsigned long *bitmap2, unsigned int bits);
+bool __bitmap_subset(const unsigned long *bitmap1,
+		     const unsigned long *bitmap2, unsigned int nbits);
+bool __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
+		    const unsigned long *bitmap2, unsigned int nbits);
 
 #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
 #define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
@@ -81,6 +85,15 @@ static inline void bitmap_or(unsigned lo
 		__bitmap_or(dst, src1, src2, nbits);
 }
 
+static __always_inline
+bool bitmap_andnot(unsigned long *dst, const unsigned long *src1,
+		   const unsigned long *src2, unsigned int nbits)
+{
+	if (small_const_nbits(nbits))
+		return (*dst = *src1 & ~(*src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
+	return __bitmap_andnot(dst, src1, src2, nbits);
+}
+
 static inline unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags __maybe_unused)
 {
 	return malloc(bitmap_size(nbits));
@@ -157,6 +170,15 @@ static inline bool bitmap_intersects(con
 		return __bitmap_intersects(src1, src2, nbits);
 }
 
+static __always_inline
+bool bitmap_subset(const unsigned long *src1, const unsigned long *src2, unsigned int nbits)
+{
+	if (small_const_nbits(nbits))
+		return ! ((*src1 & ~(*src2)) & BITMAP_LAST_WORD_MASK(nbits));
+	else
+		return __bitmap_subset(src1, src2, nbits);
+}
+
 static inline void bitmap_set(unsigned long *map, unsigned int start, unsigned int nbits)
 {
 	if (__builtin_constant_p(nbits) && nbits == 1)
--- a/tools/lib/bitmap.c~tools-bitmap-add-missing-bitmap_
+++ a/tools/lib/bitmap.c
@@ -140,3 +140,32 @@ void __bitmap_clear(unsigned long *map,
 		*p &= ~mask_to_clear;
 	}
 }
+
+bool __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
+				const unsigned long *bitmap2, unsigned int bits)
+{
+	unsigned int k;
+	unsigned int lim = bits/BITS_PER_LONG;
+	unsigned long result = 0;
+
+	for (k = 0; k < lim; k++)
+		result |= (dst[k] = bitmap1[k] & ~bitmap2[k]);
+	if (bits % BITS_PER_LONG)
+		result |= (dst[k] = bitmap1[k] & ~bitmap2[k] &
+			   BITMAP_LAST_WORD_MASK(bits));
+	return result != 0;
+}
+
+bool __bitmap_subset(const unsigned long *bitmap1,
+		     const unsigned long *bitmap2, unsigned int bits)
+{
+	unsigned int k, lim = bits/BITS_PER_LONG;
+	for (k = 0; k < lim; ++k)
+		if (bitmap1[k] & ~bitmap2[k])
+			return false;
+
+	if (bits % BITS_PER_LONG)
+		if ((bitmap1[k] & ~bitmap2[k]) & BITMAP_LAST_WORD_MASK(bits))
+			return false;
+	return true;
+}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


