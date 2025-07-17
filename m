Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D717E881E;
	Thu, 17 Jul 2025 23:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752794570; cv=none; b=WgO8FdhVcqepTWwPmCU3a5COA8cwU8Ji2WKu3H9E5D95+3Co3rQx1CMjIn/MBvgJ0QM5my/rrHkuu9kLeMCCQ49O86nlWnVShzgjo1NJ7+CZgBImqV6AxKq4lBiwcOiCyI8CEga+UvU80cQ96w5+8KJ1TtyQBLicjaLa2aSEACA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752794570; c=relaxed/simple;
	bh=B/lgGQV312uPxL90EJFxfIVXucA+aSOdebAnyPTe8Z0=;
	h=Date:To:From:Subject:Message-Id; b=A59nTw8ezyQ6X6tgDMWnyGOULH6FOcYNwoxOqaLvBSRO9fNQAy/B8QiySTIY0NH42sSBJlV3pp/5GDKXREI8ekfcTWUjpQUID8OTv900CRhbZUapzB4kmM6JB11njsNyzi8k2l3xjrldD2CoNkORjXYSh3HTC+ZgC1kbvcbjwa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XFZG67eO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XFZG67eO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564DDC4CEE3;
	Thu, 17 Jul 2025 23:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752794569;
	bh=B/lgGQV312uPxL90EJFxfIVXucA+aSOdebAnyPTe8Z0=;
	h=Date:To:From:Subject:From;
	b=XFZG67eOYUXa1FX13gnj1rRc1lj7S4xVVEfWRywtc/tTddrBJjXopIAL1KglU3G/f
	 el9YyV5BYzIBgq5Mo8LKxoQFNJWZ3BtAq78kdDF/dD/htzCLHACzHlwQxbYT/zxjMf
	 TifpfkB7N0V30mQ9GklwQAy0FMkJ3ySA5ijNZNY0=
Date: Thu, 17 Jul 2025 16:22:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,cl@gentwo.org,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-check-if-folio-has-valid-mapcount-before-folio_test_anonksm-when-necessary.patch removed from -mm tree
Message-Id: <20250717232249.564DDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: check if folio has valid mapcount before folio_test_{anon,ksm}() when necessary
has been removed from the -mm tree.  Its filename was
     mm-check-if-folio-has-valid-mapcount-before-folio_test_anonksm-when-necessary.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Harry Yoo <harry.yoo@oracle.com>
Subject: mm: check if folio has valid mapcount before folio_test_{anon,ksm}() when necessary
Date: Mon, 7 Jul 2025 21:07:40 +0900

folio_test_anon() and folio_test_ksm() may return false positives when the
folio is a typed page (except hugetlb), because lower bits of
folio->mapping field can be set even if it doesn't mean FOLIO_MAPPING_*
flags.

To avoid false positives, folio_test_{anon,ksm}() should be called only if
!page_has_type(&folio->page) || folio_test_hugetlb(folio).  However, the
check can be skipped if a folio is or will be mapped to userspace because
typed pages that are not hugetlb folios cannot be mapped to userspace.

As folio_expected_ref_count() already does the check, introduce a helper
function folio_has_mapcount() and use it in folio_expected_ref_count() and
stable_page_flags().

Update the comment in FOLIO_MAPPING_* flags accordingly.

This fixes tools/mm/page-types reporting pages with
KPF_SLAB, KPF_ANON and KPF_SLAB (with flags, page-counts, MB omitted):
  $ sudo ./page-types | grep slab
  _______S___________________________________	slab
  _______S____a________x_____________________	slab,anonymous,ksm

Link: https://lkml.kernel.org/r/20250707120740.4413-1-harry.yoo@oracle.com
Fixes: 130d4df57390 ("mm/sl[au]b: rearrange struct slab fields to allow larger rcu_head")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c             |   19 +++++++++++--------
 include/linux/mm.h         |    2 +-
 include/linux/page-flags.h |   20 ++++++++++++++------
 3 files changed, 26 insertions(+), 15 deletions(-)

--- a/fs/proc/page.c~mm-check-if-folio-has-valid-mapcount-before-folio_test_anonksm-when-necessary
+++ a/fs/proc/page.c
@@ -148,18 +148,21 @@ u64 stable_page_flags(const struct page
 	folio = page_folio(page);
 
 	k = folio->flags;
-	mapping = (unsigned long)folio->mapping;
-	is_anon = mapping & FOLIO_MAPPING_ANON;
 
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 */
-	if (page_mapped(page))
-		u |= 1 << KPF_MMAP;
-	if (is_anon) {
-		u |= 1 << KPF_ANON;
-		if (mapping & FOLIO_MAPPING_KSM)
-			u |= 1 << KPF_KSM;
+	if (folio_has_mapcount(folio)) {
+		mapping = (unsigned long)folio->mapping;
+		is_anon = mapping & FOLIO_MAPPING_ANON;
+
+		if (page_mapped(page))
+			u |= 1 << KPF_MMAP;
+		if (is_anon) {
+			u |= 1 << KPF_ANON;
+			if (mapping & FOLIO_MAPPING_KSM)
+				u |= 1 << KPF_KSM;
+		}
 	}
 
 	/*
--- a/include/linux/mm.h~mm-check-if-folio-has-valid-mapcount-before-folio_test_anonksm-when-necessary
+++ a/include/linux/mm.h
@@ -2169,7 +2169,7 @@ static inline int folio_expected_ref_cou
 	const int order = folio_order(folio);
 	int ref_count = 0;
 
-	if (WARN_ON_ONCE(page_has_type(&folio->page) && !folio_test_hugetlb(folio)))
+	if (WARN_ON_ONCE(!folio_has_mapcount(folio)))
 		return 0;
 
 	if (folio_test_anon(folio)) {
--- a/include/linux/page-flags.h~mm-check-if-folio-has-valid-mapcount-before-folio_test_anonksm-when-necessary
+++ a/include/linux/page-flags.h
@@ -706,12 +706,15 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemma
  * address_space which maps the folio from disk; whereas "folio_mapped"
  * refers to user virtual address space into which the folio is mapped.
  *
- * For slab pages, since slab reuses the bits in struct page to store its
- * internal states, the folio->mapping does not exist as such, nor do
- * these flags below.  So in order to avoid testing non-existent bits,
- * please make sure that folio_test_slab(folio) actually evaluates to
- * false before calling the following functions (e.g., folio_test_anon).
- * See mm/slab.h.
+ * For certain typed pages like slabs, since they reuse bits in struct page
+ * to store internal states, folio->mapping does not point to a valid
+ * mapping, nor do these flags exist. To avoid testing non-existent bits,
+ * make sure folio_has_mapcount() actually evaluates to true before calling
+ * the following functions (e.g., folio_test_anon).
+ *
+ * The folio_has_mapcount() check can be skipped if the folio is mapped
+ * to userspace, since a folio with !folio_has_mapcount() cannot be mapped
+ * to userspace at all.
  */
 #define FOLIO_MAPPING_ANON	0x1
 #define FOLIO_MAPPING_ANON_KSM	0x2
@@ -1092,6 +1095,11 @@ static inline bool PageHuge(const struct
 	return folio_test_hugetlb(page_folio(page));
 }
 
+static inline bool folio_has_mapcount(const struct folio *folio)
+{
+	return !page_has_type(&folio->page) || folio_test_hugetlb(folio);
+}
+
 /*
  * Check if a page is currently marked HWPoisoned. Note that this check is
  * best effort only and inherently racy: there is no way to synchronize with
_

Patches currently in -mm which might be from harry.yoo@oracle.com are

mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n.patch

