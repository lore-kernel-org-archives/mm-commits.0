Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D579A292928
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746048279; cv=none; b=DfJ8OPZwxFCd3LimPvaVE7ccjwLpknt5dgTZtxbwmpExiQE47swZakZqZnIZhm9kT+Np2vLLXHopL18pm7jEaS7mSgak/ZafE/lAZGVoCOFuZ4L6ufSJuKgNXB08YB5P9XiFLFjqxXOWS/lqUHuNLuLV2E3/S0PtQA6XYkhmeYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746048279; c=relaxed/simple;
	bh=ksakA10PzMjnMLiDFjITs30gBKHvFm27vvYA9Vrk5HE=;
	h=Date:To:From:Subject:Message-Id; b=Fg1cS+ePVU9FtED9ODHJi0Fy6aoQzQfkAGrSqtBg4v86lR9cAWxdjcBC1rV3/kgVUJ9xRdIuY3ol5gx/gcPsEJA6wXlWQ3fvxmZycgJN1OKN3tWKK19MtMsSM5tTxhrlIu7rzR1fJjULvbv6Rgrtw4PMdEJ7TbW3ltHLE0I+7WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jjNlhJmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jjNlhJmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E807C4CEE7;
	Wed, 30 Apr 2025 21:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746048279;
	bh=ksakA10PzMjnMLiDFjITs30gBKHvFm27vvYA9Vrk5HE=;
	h=Date:To:From:Subject:From;
	b=jjNlhJmAMyovUerO1W3HcCk3vea5CxlZb5IhUWR98b0uOhUkv6ZqZmdydDsCSZ/0i
	 ATSsALOgQL9uhNCwJ0mPTlU5WQJjv/qWPB2azvZOuAZMV3/7FNthEhLDfDsM1Oew7e
	 1LaYmTxIcdw7MWmvQ5mpFKMy5ouknnWA21VbVzH4=
Date: Wed, 30 Apr 2025 14:24:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,shaggy@kernel.org,jane.chu@oracle.com,donettom@linux.ibm.com,david@redhat.com,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_expected_ref_count-for-reference-count-calculation.patch added to mm-unstable branch
Message-Id: <20250430212439.2E807C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add folio_expected_ref_count() for reference count calculation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_expected_ref_count-for-reference-count-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_expected_ref_count-for-reference-count-calculation.patch

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm: add folio_expected_ref_count() for reference count calculation
Date: Wed, 30 Apr 2025 10:01:51 +0000

Patch series " JFS: Implement migrate_folio for jfs_metapage_aops" v5.

This patchset addresses a warning that occurs during memory compaction due
to JFS's missing migrate_folio operation.  The warning was introduced by
commit 7ee3647243e5 ("migrate: Remove call to ->writepage") which added
explicit warnings when filesystem don't implement migrate_folio.

The syzbot reported following [1]:
  jfs_metapage_aops does not implement migrate_folio
  WARNING: CPU: 1 PID: 5861 at mm/migrate.c:955 fallback_migrate_folio mm/migrate.c:953 [inline]
  WARNING: CPU: 1 PID: 5861 at mm/migrate.c:955 move_to_new_folio+0x70e/0x840 mm/migrate.c:1007
  Modules linked in:
  CPU: 1 UID: 0 PID: 5861 Comm: syz-executor280 Not tainted 6.15.0-rc1-next-20250411-syzkaller #0 PREEMPT(full) 
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
  RIP: 0010:fallback_migrate_folio mm/migrate.c:953 [inline]
  RIP: 0010:move_to_new_folio+0x70e/0x840 mm/migrate.c:1007

To fix this issue, this series implement metapage_migrate_folio() for JFS
which handles both single and multiple metapages per page configurations.

While most filesystems leverage existing migration implementations like
filemap_migrate_folio(), buffer_migrate_folio_norefs() or
buffer_migrate_folio() (which internally used folio_expected_refs()),
JFS's metapage architecture requires special handling of its private data
during migration.  To support this, this series introduce the
folio_expected_ref_count(), which calculates external references to a
folio from page/swap cache, private data, and page table mappings.

This standardized implementation replaces the previous ad-hoc
folio_expected_refs() function and enables JFS to accurately determine
whether a folio has unexpected references before attempting migration.




Implement folio_expected_ref_count() to calculate expected folio reference
counts from:
- Page/swap cache (1 per page)
- Private data (1)
- Page table mappings (1 per map)

While originally needed for page migration operations, this improved
implementation standardizes reference counting by consolidating all
refcount contributors into a single, reusable function that can benefit
any subsystem needing to detect unexpected references to folios.

The folio_expected_ref_count() returns the sum of these external
references without including any reference the caller itself might hold. 
Callers comparing against the actual folio_ref_count() must account for
their own references separately.

Link: https://syzkaller.appspot.com/bug?extid=8bb6fd945af4e0ad9299 [1]
Link: https://lkml.kernel.org/r/20250430100150.279751-1-shivankg@amd.com
Link: https://lkml.kernel.org/r/20250430100150.279751-2-shivankg@amd.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Co-developed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   55 +++++++++++++++++++++++++++++++++++++++++++
 mm/migrate.c       |   22 +++--------------
 2 files changed, 59 insertions(+), 18 deletions(-)

--- a/include/linux/mm.h~mm-add-folio_expected_ref_count-for-reference-count-calculation
+++ a/include/linux/mm.h
@@ -2114,6 +2114,61 @@ static inline bool folio_maybe_mapped_sh
 	return test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids);
 }
 
+/**
+ * folio_expected_ref_count - calculate the expected folio refcount
+ * @folio: the folio
+ *
+ * Calculate the expected folio refcount, taking references from the pagecache,
+ * swapcache, PG_private and page table mappings into account. Useful in
+ * combination with folio_ref_count() to detect unexpected references (e.g.,
+ * GUP or other temporary references).
+ *
+ * Does currently not consider references from the LRU cache. If the folio
+ * was isolated from the LRU (which is the case during migration or split),
+ * the LRU cache does not apply.
+ *
+ * Calling this function on an unmapped folio -- !folio_mapped() -- that is
+ * locked will return a stable result.
+ *
+ * Calling this function on a mapped folio will not result in a stable result,
+ * because nothing stops additional page table mappings from coming (e.g.,
+ * fork()) or going (e.g., munmap()).
+ *
+ * Calling this function without the folio lock will also not result in a
+ * stable result: for example, the folio might get dropped from the swapcache
+ * concurrently.
+ *
+ * However, even when called without the folio lock or on a mapped folio,
+ * this function can be used to detect unexpected references early (for example,
+ * if it makes sense to even lock the folio and unmap it).
+ *
+ * The caller must add any reference (e.g., from folio_try_get()) it might be
+ * holding itself to the result.
+ *
+ * Returns the expected folio refcount.
+ */
+static inline int folio_expected_ref_count(const struct folio *folio)
+{
+	const int order = folio_order(folio);
+	int ref_count = 0;
+
+	if (WARN_ON_ONCE(folio_test_slab(folio)))
+		return 0;
+
+	if (folio_test_anon(folio)) {
+		/* One reference per page from the swapcache. */
+		ref_count += folio_test_swapcache(folio) << order;
+	} else if (!((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS)) {
+		/* One reference per page from the pagecache. */
+		ref_count += !!folio->mapping << order;
+		/* One reference from PG_private. */
+		ref_count += folio_test_private(folio);
+	}
+
+	/* One reference per page table mapping. */
+	return ref_count + folio_mapcount(folio);
+}
+
 #ifndef HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
 static inline int arch_make_folio_accessible(struct folio *folio)
 {
--- a/mm/migrate.c~mm-add-folio_expected_ref_count-for-reference-count-calculation
+++ a/mm/migrate.c
@@ -445,20 +445,6 @@ unlock:
 }
 #endif
 
-static int folio_expected_refs(struct address_space *mapping,
-		struct folio *folio)
-{
-	int refs = 1;
-	if (!mapping)
-		return refs;
-
-	refs += folio_nr_pages(folio);
-	if (folio_test_private(folio))
-		refs++;
-
-	return refs;
-}
-
 /*
  * Replace the folio in the mapping.
  *
@@ -601,7 +587,7 @@ static int __folio_migrate_mapping(struc
 int folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int extra_count)
 {
-	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
+	int expected_count = folio_expected_ref_count(folio) + extra_count + 1;
 
 	if (folio_ref_count(folio) != expected_count)
 		return -EAGAIN;
@@ -618,7 +604,7 @@ int migrate_huge_page_move_mapping(struc
 				   struct folio *dst, struct folio *src)
 {
 	XA_STATE(xas, &mapping->i_pages, folio_index(src));
-	int rc, expected_count = folio_expected_refs(mapping, src);
+	int rc, expected_count = folio_expected_ref_count(src) + 1;
 
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
@@ -749,7 +735,7 @@ static int __migrate_folio(struct addres
 			   struct folio *src, void *src_private,
 			   enum migrate_mode mode)
 {
-	int rc, expected_count = folio_expected_refs(mapping, src);
+	int rc, expected_count = folio_expected_ref_count(src) + 1;
 
 	/* Check whether src does not have extra refs before we do more work */
 	if (folio_ref_count(src) != expected_count)
@@ -837,7 +823,7 @@ static int __buffer_migrate_folio(struct
 		return migrate_folio(mapping, dst, src, mode);
 
 	/* Check whether page does not have extra refs before we do more work */
-	expected_count = folio_expected_refs(mapping, src);
+	expected_count = folio_expected_ref_count(src) + 1;
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-add-folio_expected_ref_count-for-reference-count-calculation.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops.patch

