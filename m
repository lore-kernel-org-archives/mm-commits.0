Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06A3254A9
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 03:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357927; cv=none; b=n84NikmVsWyQ5a4zsnLLsi9WE9qxFPa2FUE6jHjFgoR9glFXSt+hqU7/huXmidUo05GGiXk+nhPG/fHtqgyT47qS6L8E6iW8nUn4AjLmtkwD4hLrTHiFwuTjJHfUE0I80KTioOweNCx0siBCvmURFdcs+UjsRFA7+6xI9y/ny9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357927; c=relaxed/simple;
	bh=ITl2fnf8GthyaDDFnLemOiYRaUqglGXPZgIZt1UkNH4=;
	h=Date:To:From:Subject:Message-Id; b=m1gfxkG7zzaMd3OFIMF+U8YiLgqO7+gAq6zOYHMx6GmOUkaLBRaz4Iy+ThPRUlBmboU0KxeS5RDQoCXpR9dsw9WFENyKlGnzbVXK90t+qjIKCCMzk+vOxlGyCd+sgu8HS5U8PyvJGAyrZqqmg5s24lcLYutR6nk0+GEwqvxKIUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yFNkKxCu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yFNkKxCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40F11F000FF;
	Mon, 14 Sep 2026 03:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357924;
	bh=WG/Wlu69F8LloKjL4Lt4qlGjDlr6uMTys+aNnxXQCXU=;
	h=Date:To:From:Subject;
	b=yFNkKxCuRilBPWrM43cQYNw9QQ9H//EP7cpKu6stfHu1+QyGcu0hDFoTdu9gwm2kI
	 bYFOXXGAhA0ORbRDk+IiIUShoJQMY9mRIMV0oumXxlC2dPzANLiVChlB+VjgrW6+VS
	 Gzqa+pU8+irLpv4W/WJWLX9qcUwRSaHFaPUFtC/E=
Date: Sun, 13 Sep 2026 20:52:04 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,jaegeuk@kernel.org,david@kernel.org,chao@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + f2fs-convert-the-private-flag-helpers-to-folio-only.patch added to mm-new branch
Message-Id: <20260914035204.A40F11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: f2fs: convert the ->private flag helpers to folio-only
has been added to the -mm mm-new branch.  Its filename is
     f2fs-convert-the-private-flag-helpers-to-folio-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/f2fs-convert-the-private-flag-helpers-to-folio-only.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Zi Yan <ziy@nvidia.com>
Subject: f2fs: convert the ->private flag helpers to folio-only
Date: Sun, 13 Sep 2026 22:24:05 -0400

page-based ->private flag helpers are used in the compression path, where
large folios are not enabled.  They can use folio versions with
page_folio().  The two remaining users in data.c and segment.c can use
fio->folio instead of fio->page (two are in a union).

Drop page-based helpers after the conversion and rename
PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC() and the PAGE_PRIVATE_* flags to
F2FS_FOLIO_PRIVATE_* to match.  Convert the folio/page union from
f2fs_io_info union to folio only, since no page user is left.

The folio helpers do a plain read-modify-write where the page ones used
set_bit()/clear_bit().  It is fine because the converted code either holds
folio lock or, in f2fs_compress_write_end_io(), matches what the
non-compressed code does in f2fs_write_end_bio().

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-7-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
---

 fs/f2fs/compress.c |   35 ++++++++------
 fs/f2fs/data.c     |    2 
 fs/f2fs/f2fs.h     |  107 +++++++++++++++++--------------------------
 fs/f2fs/segment.c  |    2 
 4 files changed, 67 insertions(+), 79 deletions(-)

--- a/fs/f2fs/compress.c~f2fs-convert-the-private-flag-helpers-to-folio-only
+++ a/fs/f2fs/compress.c
@@ -1064,13 +1064,15 @@ static void cancel_cluster_writeback(str
 
 	/* Cancel writeback and stay locked. */
 	for (i = 0; i < cc->cluster_size; i++) {
+		struct folio *folio = page_folio(cc->rpages[i]);
+
 		if (i < submitted) {
 			inode_inc_dirty_pages(cc->inode);
-			lock_page(cc->rpages[i]);
+			folio_lock(folio);
 		}
-		clear_page_private_gcing(cc->rpages[i]);
-		if (folio_test_writeback(page_folio(cc->rpages[i])))
-			end_page_writeback(cc->rpages[i]);
+		folio_clear_f2fs_gcing(folio);
+		if (folio_test_writeback(folio))
+			folio_end_writeback(folio);
 	}
 }
 
@@ -1078,11 +1080,15 @@ static void set_cluster_dirty(struct com
 {
 	int i;
 
-	for (i = 0; i < cc->cluster_size; i++)
-		if (cc->rpages[i]) {
-			set_page_dirty(cc->rpages[i]);
-			set_page_private_gcing(cc->rpages[i]);
-		}
+	for (i = 0; i < cc->cluster_size; i++) {
+		struct folio *folio;
+
+		if (!cc->rpages[i])
+			continue;
+		folio = page_folio(cc->rpages[i]);
+		folio_mark_dirty(folio);
+		folio_set_f2fs_gcing(folio);
+	}
 }
 
 static int prepare_compress_overwrite(struct compress_ctx *cc,
@@ -1281,7 +1287,7 @@ static int f2fs_write_compressed_pages(s
 		.op = REQ_OP_WRITE,
 		.op_flags = wbc_to_write_flags(wbc),
 		.old_blkaddr = NEW_ADDR,
-		.page = NULL,
+		.folio = NULL,
 		.encrypted_page = NULL,
 		.compressed_page = NULL,
 		.io_type = io_type,
@@ -1370,7 +1376,7 @@ static int f2fs_write_compressed_pages(s
 		block_t blkaddr;
 
 		blkaddr = f2fs_data_blkaddr(&dn);
-		fio.page = cc->rpages[i];
+		fio.folio = page_folio(cc->rpages[i]);
 		fio.old_blkaddr = blkaddr;
 
 		/* cluster header */
@@ -1476,9 +1482,12 @@ void f2fs_compress_write_end_io(struct b
 	}
 
 	for (i = 0; i < cic->nr_rpages; i++) {
+		struct folio *rfolio;
+
 		WARN_ON(!cic->rpages[i]);
-		clear_page_private_gcing(cic->rpages[i]);
-		end_page_writeback(cic->rpages[i]);
+		rfolio = page_folio(cic->rpages[i]);
+		folio_clear_f2fs_gcing(rfolio);
+		folio_end_writeback(rfolio);
 	}
 
 	page_array_free(sbi, cic->rpages, cic->nr_rpages);
--- a/fs/f2fs/data.c~f2fs-convert-the-private-flag-helpers-to-folio-only
+++ a/fs/f2fs/data.c
@@ -2923,7 +2923,7 @@ bool f2fs_should_update_outplace(struct
 		return true;
 
 	if (fio) {
-		if (page_private_gcing(fio->page))
+		if (folio_test_f2fs_gcing(fio->folio))
 			return true;
 		if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED) &&
 			f2fs_is_checkpointed_data(sbi, fio->old_blkaddr)))
--- a/fs/f2fs/f2fs.h~f2fs-convert-the-private-flag-helpers-to-folio-only
+++ a/fs/f2fs/f2fs.h
@@ -1357,10 +1357,7 @@ struct f2fs_io_info {
 	blk_opf_t op_flags;	/* req_flag_bits */
 	block_t new_blkaddr;	/* new block address to be written */
 	block_t old_blkaddr;	/* old block address before Cow */
-	union {
-		struct page *page;	/* page to be written */
-		struct folio *folio;
-	};
+	struct folio *folio;	/* folio to be written */
 	struct page *encrypted_page;	/* encrypted page */
 	struct page *compressed_page;	/* compressed page */
 	struct list_head list;		/* serialize IOs */
@@ -1613,27 +1610,27 @@ static inline void f2fs_set_bit(unsigned
 static inline void f2fs_clear_bit(unsigned int nr, char *addr);
 
 /*
- * Layout of f2fs page.private:
+ * Layout of f2fs folio->private:
  *
  * Layout A: lowest bit should be 1
  * | bit0 = 1 | bit1 | bit2 | ... | bit MAX | private data .... |
- * bit 0	PAGE_PRIVATE_NOT_POINTER
- * bit 1	PAGE_PRIVATE_ONGOING_MIGRATION
- * bit 2	PAGE_PRIVATE_INLINE_INODE
- * bit 3	PAGE_PRIVATE_REF_RESOURCE
- * bit 4	PAGE_PRIVATE_ATOMIC_WRITE
+ * bit 0	F2FS_FOLIO_PRIVATE_NOT_POINTER
+ * bit 1	F2FS_FOLIO_PRIVATE_ONGOING_MIGRATION
+ * bit 2	F2FS_FOLIO_PRIVATE_INLINE_INODE
+ * bit 3	F2FS_FOLIO_PRIVATE_REF_RESOURCE
+ * bit 4	F2FS_FOLIO_PRIVATE_ATOMIC_WRITE
  * bit 5-	f2fs private data
  *
  * Layout B: lowest bit should be 0
- * page.private is a wrapped pointer.
+ * folio->private is a wrapped pointer.
  */
 enum {
-	PAGE_PRIVATE_NOT_POINTER,		/* private contains non-pointer data */
-	PAGE_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating */
-	PAGE_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
-	PAGE_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
-	PAGE_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
-	PAGE_PRIVATE_MAX
+	F2FS_FOLIO_PRIVATE_NOT_POINTER,		/* private contains non-pointer data */
+	F2FS_FOLIO_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating */
+	F2FS_FOLIO_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
+	F2FS_FOLIO_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
+	F2FS_FOLIO_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
+	F2FS_FOLIO_PRIVATE_MAX
 };
 
 /* For compression */
@@ -2681,86 +2678,68 @@ release_quota:
 	return -ENOSPC;
 }
 
-#define PAGE_PRIVATE_GET_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_GET_FUNC(name, flagname) \
 static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
 {									\
 	unsigned long priv = (unsigned long)folio->private;		\
-	unsigned long v = (1UL << PAGE_PRIVATE_NOT_POINTER) |		\
-			     (1UL << PAGE_PRIVATE_##flagname);		\
+	unsigned long v = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |	\
+			     (1UL << F2FS_FOLIO_PRIVATE_##flagname);	\
 	return (priv & v) == v;						\
-}									\
-static inline bool page_private_##name(struct page *page) \
-{ \
-	return page_private(page) && \
-		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
-		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
-#define PAGE_PRIVATE_SET_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_SET_FUNC(name, flagname) \
 static inline void folio_set_f2fs_##name(struct folio *folio)		\
 {									\
-	unsigned long v = (1UL << PAGE_PRIVATE_NOT_POINTER) |		\
-			     (1UL << PAGE_PRIVATE_##flagname);		\
+	unsigned long v = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |	\
+			     (1UL << F2FS_FOLIO_PRIVATE_##flagname);	\
 	if (!folio->private)						\
 		folio_attach_private(folio, (void *)v);			\
 	else {								\
 		v |= (unsigned long)folio->private;			\
 		folio->private = (void *)v;				\
 	}								\
-}									\
-static inline void set_page_private_##name(struct page *page) \
-{ \
-	if (!page_private(page)) \
-		attach_page_private(page, \
-				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
-	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
-#define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_CLEAR_FUNC(name, flagname) \
 static inline void folio_clear_f2fs_##name(struct folio *folio)		\
 {									\
 	unsigned long v = (unsigned long)folio->private;		\
 									\
-	v &= ~(1UL << PAGE_PRIVATE_##flagname);				\
-	if (v == (1UL << PAGE_PRIVATE_NOT_POINTER))			\
+	v &= ~(1UL << F2FS_FOLIO_PRIVATE_##flagname);			\
+	if (v == (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER))		\
 		folio_detach_private(folio);				\
 	else								\
 		folio->private = (void *)v;				\
-}									\
-static inline void clear_page_private_##name(struct page *page) \
-{ \
-	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
-	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) \
-		detach_page_private(page); \
-}
-
-PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
-PAGE_PRIVATE_GET_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
-
-PAGE_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
-PAGE_PRIVATE_SET_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
-
-PAGE_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
-PAGE_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
+}
+
+F2FS_FOLIO_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
+F2FS_FOLIO_PRIVATE_GET_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
+
+F2FS_FOLIO_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
+
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
 
 static inline unsigned long folio_get_f2fs_data(struct folio *folio)
 {
 	unsigned long data = (unsigned long)folio->private;
 
-	if (!test_bit(PAGE_PRIVATE_NOT_POINTER, &data))
+	if (!test_bit(F2FS_FOLIO_PRIVATE_NOT_POINTER, &data))
 		return 0;
-	return data >> PAGE_PRIVATE_MAX;
+	return data >> F2FS_FOLIO_PRIVATE_MAX;
 }
 
 static inline void folio_set_f2fs_data(struct folio *folio, unsigned long data)
 {
-	data = (1UL << PAGE_PRIVATE_NOT_POINTER) | (data << PAGE_PRIVATE_MAX);
+	data = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |
+	       (data << F2FS_FOLIO_PRIVATE_MAX);
 
 	if (!folio_test_private(folio))
 		folio_attach_private(folio, (void *)data);
--- a/fs/f2fs/segment.c~f2fs-convert-the-private-flag-helpers-to-folio-only
+++ a/fs/f2fs/segment.c
@@ -3803,7 +3803,7 @@ static int __get_segment_type_6(struct f
 		if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
 			return CURSEG_COLD_DATA_PINNED;
 
-		if (page_private_gcing(fio->page)) {
+		if (folio_test_f2fs_gcing(fio->folio)) {
 			if (fio->sbi->am.atgc_enabled &&
 				(fio->io_type == FS_DATA_IO) &&
 				(fio->sbi->gc_mode != GC_URGENT_HIGH) &&
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch
perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch
xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch
fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

