Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51682E413
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 00:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772066571; cv=none; b=TrUMqqxeN92gvqH6T7KUXe9/VRveSVA6oLuzrE7+YE9qEi7NlsHTijIXA6Yqme+/uFHVRDvc4SnW6oBRA26oFCkL1SfrjGaUQSx257XzKDf9s7n/3mW3CgrRebjadAtJYwzfg/VQ2KXC/RYWar3MnS3XXxl5QAwdxXutk5VeQGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772066571; c=relaxed/simple;
	bh=Ws9fruBFzh0r+jKKTiCDF9vbACialSqrvbDbp2hPBoE=;
	h=Date:To:From:Subject:Message-Id; b=mlITMj/a1UUFPJ6yqCw6zOqnDlkjxGP0ZFUotv0MqY1i11xrbTyqeoEw+YBrqmX6O2KRTZ9rYQBfZB5f/ZD8SDlD4pDLACEP5hjIVt0Ymh+IowrWBJGUxc188DHe5t/QctDzJM+uPXHKCVoNdXVG88nVqtiRZyWeVwUdkW+62fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OGdVNz0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OGdVNz0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A27C116D0;
	Thu, 26 Feb 2026 00:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772066571;
	bh=Ws9fruBFzh0r+jKKTiCDF9vbACialSqrvbDbp2hPBoE=;
	h=Date:To:From:Subject:From;
	b=OGdVNz0/5SypbGWrheGQNHKVH8wkZsSCAfYfrn+mLkab4FBqkCrzXezpM0gGiNtSi
	 /MTtXR7t5Nsd/8wnoj3IgctSGcZ2z6B8TnXBLcZdQ7sc08Q9aDBHOHSJ6qU83Ghexc
	 2HNXQqqb5vNsduc+S7DFrEf+CAuiRfHMomw6O70g=
Date: Wed, 25 Feb 2026 16:42:50 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@kernel.org,chrisl@kernel.org,brauner@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + folio_batch-rename-pagevec_size-to-folio_batch_size.patch added to mm-new branch
Message-Id: <20260226004251.73A27C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: folio_batch: rename PAGEVEC_SIZE to FOLIO_BATCH_SIZE
has been added to the -mm mm-new branch.  Its filename is
     folio_batch-rename-pagevec_size-to-folio_batch_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/folio_batch-rename-pagevec_size-to-folio_batch_size.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: folio_batch: rename PAGEVEC_SIZE to FOLIO_BATCH_SIZE
Date: Wed, 25 Feb 2026 18:44:28 -0500

struct pagevec no longer exists.  Rename the macro appropriately.

Link: https://lkml.kernel.org/r/20260225-pagevec_cleanup-v2-4-716868cc2d11@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/extent_io.c        |    4 ++--
 include/linux/folio_batch.h |    6 +++---
 include/linux/folio_queue.h |    6 +++---
 mm/shmem.c                  |    4 ++--
 mm/swap.c                   |    2 +-
 mm/swap_state.c             |    2 +-
 mm/truncate.c               |    6 +++---
 7 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/btrfs/extent_io.c~folio_batch-rename-pagevec_size-to-folio_batch_size
+++ a/fs/btrfs/extent_io.c
@@ -2095,13 +2095,13 @@ static void buffer_tree_tag_for_writebac
 struct eb_batch {
 	unsigned int nr;
 	unsigned int cur;
-	struct extent_buffer *ebs[PAGEVEC_SIZE];
+	struct extent_buffer *ebs[FOLIO_BATCH_SIZE];
 };
 
 static inline bool eb_batch_add(struct eb_batch *batch, struct extent_buffer *eb)
 {
 	batch->ebs[batch->nr++] = eb;
-	return (batch->nr < PAGEVEC_SIZE);
+	return (batch->nr < FOLIO_BATCH_SIZE);
 }
 
 static inline void eb_batch_init(struct eb_batch *batch)
--- a/include/linux/folio_batch.h~folio_batch-rename-pagevec_size-to-folio_batch_size
+++ a/include/linux/folio_batch.h
@@ -12,7 +12,7 @@
 #include <linux/types.h>
 
 /* 31 pointers + header align the folio_batch structure to a power of two */
-#define PAGEVEC_SIZE	31
+#define FOLIO_BATCH_SIZE	31
 
 struct folio;
 
@@ -29,7 +29,7 @@ struct folio_batch {
 	unsigned char nr;
 	unsigned char i;
 	bool percpu_pvec_drained;
-	struct folio *folios[PAGEVEC_SIZE];
+	struct folio *folios[FOLIO_BATCH_SIZE];
 };
 
 /**
@@ -58,7 +58,7 @@ static inline unsigned int folio_batch_c
 
 static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
 {
-	return PAGEVEC_SIZE - fbatch->nr;
+	return FOLIO_BATCH_SIZE - fbatch->nr;
 }
 
 /**
--- a/include/linux/folio_queue.h~folio_batch-rename-pagevec_size-to-folio_batch_size
+++ a/include/linux/folio_queue.h
@@ -29,12 +29,12 @@
  */
 struct folio_queue {
 	struct folio_batch	vec;		/* Folios in the queue segment */
-	u8			orders[PAGEVEC_SIZE]; /* Order of each folio */
+	u8			orders[FOLIO_BATCH_SIZE]; /* Order of each folio */
 	struct folio_queue	*next;		/* Next queue segment or NULL */
 	struct folio_queue	*prev;		/* Previous queue segment of NULL */
 	unsigned long		marks;		/* 1-bit mark per folio */
 	unsigned long		marks2;		/* Second 1-bit mark per folio */
-#if PAGEVEC_SIZE > BITS_PER_LONG
+#if FOLIO_BATCH_SIZE > BITS_PER_LONG
 #error marks is not big enough
 #endif
 	unsigned int		rreq_id;
@@ -70,7 +70,7 @@ static inline void folioq_init(struct fo
  */
 static inline unsigned int folioq_nr_slots(const struct folio_queue *folioq)
 {
-	return PAGEVEC_SIZE;
+	return FOLIO_BATCH_SIZE;
 }
 
 /**
--- a/mm/shmem.c~folio_batch-rename-pagevec_size-to-folio_batch_size
+++ a/mm/shmem.c
@@ -1113,7 +1113,7 @@ static void shmem_undo_range(struct inod
 	pgoff_t start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	pgoff_t end = (lend + 1) >> PAGE_SHIFT;
 	struct folio_batch fbatch;
-	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t indices[FOLIO_BATCH_SIZE];
 	struct folio *folio;
 	bool same_folio;
 	long nr_swaps_freed = 0;
@@ -1510,7 +1510,7 @@ static int shmem_unuse_inode(struct inod
 	struct address_space *mapping = inode->i_mapping;
 	pgoff_t start = 0;
 	struct folio_batch fbatch;
-	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t indices[FOLIO_BATCH_SIZE];
 	int ret = 0;
 
 	do {
--- a/mm/swap.c~folio_batch-rename-pagevec_size-to-folio_batch_size
+++ a/mm/swap.c
@@ -1024,7 +1024,7 @@ EXPORT_SYMBOL(folios_put_refs);
 void release_pages(release_pages_arg arg, int nr)
 {
 	struct folio_batch fbatch;
-	int refs[PAGEVEC_SIZE];
+	int refs[FOLIO_BATCH_SIZE];
 	struct encoded_page **encoded = arg.encoded_pages;
 	int i;
 
--- a/mm/swap_state.c~folio_batch-rename-pagevec_size-to-folio_batch_size
+++ a/mm/swap_state.c
@@ -385,7 +385,7 @@ void free_folio_and_swap_cache(struct fo
 void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
 {
 	struct folio_batch folios;
-	unsigned int refs[PAGEVEC_SIZE];
+	unsigned int refs[FOLIO_BATCH_SIZE];
 
 	folio_batch_init(&folios);
 	for (int i = 0; i < nr; i++) {
--- a/mm/truncate.c~folio_batch-rename-pagevec_size-to-folio_batch_size
+++ a/mm/truncate.c
@@ -369,7 +369,7 @@ void truncate_inode_pages_range(struct a
 	pgoff_t		start;		/* inclusive */
 	pgoff_t		end;		/* exclusive */
 	struct folio_batch fbatch;
-	pgoff_t		indices[PAGEVEC_SIZE];
+	pgoff_t		indices[FOLIO_BATCH_SIZE];
 	pgoff_t		index;
 	int		i;
 	struct folio	*folio;
@@ -534,7 +534,7 @@ EXPORT_SYMBOL(truncate_inode_pages_final
 unsigned long mapping_try_invalidate(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_failed)
 {
-	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t indices[FOLIO_BATCH_SIZE];
 	struct folio_batch fbatch;
 	pgoff_t index = start;
 	unsigned long ret;
@@ -672,7 +672,7 @@ failed:
 int invalidate_inode_pages2_range(struct address_space *mapping,
 				  pgoff_t start, pgoff_t end)
 {
-	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t indices[FOLIO_BATCH_SIZE];
 	struct folio_batch fbatch;
 	pgoff_t index;
 	int i;
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-stray-references-to-struct-pagevec.patch
fs-remove-unncessary-pagevech-includes.patch
folio_batch-rename-pagevech-to-folio_batchh.patch
folio_batch-rename-pagevec_size-to-folio_batch_size.patch

