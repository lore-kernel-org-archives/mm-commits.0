Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ABE140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189532; cv=none; b=lrLZK41el+2PmoatU62CMJ/fkmWG7gogI5zySfsgfPTIN8bZ+jaMP3y1tIxH8mEcb+fDkStIJlCTrEPmSQLrMpgdnEdN7MsoUANqS81mugAxPCzzZron7z/GzwvxY7jELyg7gMwXwOYDZxLxQu06BtV4E7nsTMTmhAMeA70cuwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189532; c=relaxed/simple;
	bh=FHB1JlTeiSVwOCOVbmFCEV5sVRErITf7PIm5rTwZrP8=;
	h=Date:To:From:Subject:Message-Id; b=p1ooVyNDtFzo7/70zVlp3ZZZjmzN2WehwKdmkp1Vc9YBjPeX1eUzgfYaE0T85pEGTD6NPMZtUXXqrNivkXag0PmxjHSnFJlI07kEAD2JFzc/ByuujEqGBpRFu9uyI86zESMWbFloFcKgcdQqZ5/MCHTwgpKtOsg83ubFsyA6+Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hicChaUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hicChaUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097FEC4CEEC;
	Mon, 17 Mar 2025 05:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189532;
	bh=FHB1JlTeiSVwOCOVbmFCEV5sVRErITf7PIm5rTwZrP8=;
	h=Date:To:From:Subject:From;
	b=hicChaUVKh2+8YGMcggNyQP9hb+iwfC/GD48gnrxBRnfYQo5rM7nBbdX6BwWoqYVa
	 5mgxCbUO/BiUfcx97h5WykkIObQlp7Hhw14AcU7INa8QnfzYBD816y6ylgmnUEB/qO
	 Pw0GVVkB3EsEWneIpwQfL0uD1/XIs9zZ9sX7NjDM=
Date: Sun, 16 Mar 2025 22:32:11 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-use-size_t-for-array-size-and-index-variables.patch removed from -mm tree
Message-Id: <20250317053212.097FEC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: use size_t for array size and index variables
has been removed from the -mm tree.  Its filename was
     lib-min_heap-use-size_t-for-array-size-and-index-variables.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: use size_t for array size and index variables
Date: Sun, 16 Feb 2025 00:56:18 +0800

Replace the int type with size_t for variables representing array sizes
and indices in the min-heap implementation.  Using size_t aligns with
standard practices for size-related variables and avoids potential issues
on platforms where int may be insufficient to represent all valid sizes or
indices.

Link: https://lkml.kernel.org/r/20250215165618.1757219-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |   12 ++++++------
 lib/min_heap.c           |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-use-size_t-for-array-size-and-index-variables
+++ a/include/linux/min_heap.h
@@ -218,7 +218,7 @@ static size_t parent(size_t i, unsigned
 
 /* Initialize a min-heap. */
 static __always_inline
-void __min_heap_init_inline(min_heap_char *heap, void *data, int size)
+void __min_heap_init_inline(min_heap_char *heap, void *data, size_t size)
 {
 	heap->nr = 0;
 	heap->size = size;
@@ -254,7 +254,7 @@ bool __min_heap_full_inline(min_heap_cha
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down_inline(min_heap_char *heap, size_t pos, size_t elem_size,
 				 const struct min_heap_callbacks *func, void *args)
 {
 	const unsigned long lsbit = elem_size & -elem_size;
@@ -324,7 +324,7 @@ static __always_inline
 void __min_heapify_all_inline(min_heap_char *heap, size_t elem_size,
 			      const struct min_heap_callbacks *func, void *args)
 {
-	int i;
+	ssize_t i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
 		__min_heap_sift_down_inline(heap, i, elem_size, func, args);
@@ -379,7 +379,7 @@ bool __min_heap_push_inline(min_heap_cha
 			    const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
-	int pos;
+	size_t pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
 		return false;
@@ -428,10 +428,10 @@ bool __min_heap_del_inline(min_heap_char
 	__min_heap_del_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
 			      __minheap_obj_size(_heap), _idx, _func, _args)
 
-void __min_heap_init(min_heap_char *heap, void *data, int size);
+void __min_heap_init(min_heap_char *heap, void *data, size_t size);
 void *__min_heap_peek(struct min_heap_char *heap);
 bool __min_heap_full(min_heap_char *heap);
-void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down(min_heap_char *heap, size_t pos, size_t elem_size,
 			  const struct min_heap_callbacks *func, void *args);
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args);
--- a/lib/min_heap.c~lib-min_heap-use-size_t-for-array-size-and-index-variables
+++ a/lib/min_heap.c
@@ -2,7 +2,7 @@
 #include <linux/export.h>
 #include <linux/min_heap.h>
 
-void __min_heap_init(min_heap_char *heap, void *data, int size)
+void __min_heap_init(min_heap_char *heap, void *data, size_t size)
 {
 	__min_heap_init_inline(heap, data, size);
 }
@@ -20,7 +20,7 @@ bool __min_heap_full(min_heap_char *heap
 }
 EXPORT_SYMBOL(__min_heap_full);
 
-void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down(min_heap_char *heap, size_t pos, size_t elem_size,
 			  const struct min_heap_callbacks *func, void *args)
 {
 	__min_heap_sift_down_inline(heap, pos, elem_size, func, args);
_

Patches currently in -mm which might be from visitorckw@gmail.com are


