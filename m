Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509167478
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 23:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771629323; cv=none; b=LEYqRo4NlyHydbSsgWWf3ayV7lGV1sa3p9dYnNmpgz05jcIwL5kFGMjsvrqpOauXxl6nlRuoSBTfqMH+n4ZlPjKR4XCXMA1UFYQAlPOSz2BrQip4DoBWDhhVNvt1WNwJOF4ApxgdSu2IC6ygT2UDCKyhIch7irVvZi8R2PNv2Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771629323; c=relaxed/simple;
	bh=LqA2z2XOXSvFBVTbooOnfqNqoLdONuP3Riqly9i1CIc=;
	h=Date:To:From:Subject:Message-Id; b=QoYjPTHaR4eNRLw4ZtM6OMk+3m9O7aO+bmR+JmgAEoN8snKwuJTEyLjotzYscxOTPbzL1gTTcOnjVeus7NdG1Bs/F4Go9JepM8zsVpMyvqEFXgClQ8R25Bo6SEt9T5ekNVLqMYOEktiVE6vNTSPO6ROy44xfjYshRZv0GlgGWqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rv7fmL8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rv7fmL8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FDDC116C6;
	Fri, 20 Feb 2026 23:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771629322;
	bh=LqA2z2XOXSvFBVTbooOnfqNqoLdONuP3Riqly9i1CIc=;
	h=Date:To:From:Subject:From;
	b=rv7fmL8MAQaytlztJqtqh+eFZ15jz/jEUYwelRrNJAWG60np4BzrBSx7QaN7ik1Gp
	 Gl9r+tiNm6kalYzFMrqkWw7jQgxr0Sz5g6Xn3oG12tfFi2h9UKLjAHPYXSjCVYOXUn
	 ndwFQVMWTG1Je7O9JSKzSLjIC0uA1UUIiWbfg6Fs=
Date: Fri, 20 Feb 2026 15:15:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,liam.howlett@oracle.com,kas@kernel.org,gorbunov.ivan@h-partners.com,david@kernel.org,baolin.wang@linux.alibaba.com,gladyshev.ilya1@h-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-ref_unless-functions-unless_zero-only.patch added to mm-new branch
Message-Id: <20260220231522.C4FDDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make ref_unless functions unless_zero only
has been added to the -mm mm-new branch.  Its filename is
     mm-make-ref_unless-functions-unless_zero-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-ref_unless-functions-unless_zero-only.patch

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
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Subject: mm: make ref_unless functions unless_zero only
Date: Fri, 6 Feb 2026 13:33:02 +0000

There are no users of (folio/page)_ref_add_unless(page, nr, u) with u != 0
[1] and all current users are "internal" for page refcounting API.  This
allows us to safely drop this parameter and reduce function semantics to
the "unless zero" cases only, which will be optimized in the following
patch.

If needed, these functions for the u!=0 cases can be trivially
reintroduced later using the same atomic_add_unless operations as before.

[1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f ("mm:
remove the extra ZONE_DEVICE struct page refcount").  There is no trace of
discussion as to why this cleanup wasn't done earlier.

Link: https://lkml.kernel.org/r/20260206133328.426921-1-gladyshev.ilya1@h-partners.com
Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |    2 +-
 include/linux/page-flags.h |    6 +++---
 include/linux/page_ref.h   |   14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-make-ref_unless-functions-unless_zero-only
+++ a/include/linux/mm.h
@@ -1507,7 +1507,7 @@ static inline int folio_put_testzero(str
  */
 static inline bool get_page_unless_zero(struct page *page)
 {
-	return page_ref_add_unless(page, 1, 0);
+	return page_ref_add_unless_zero(page, 1);
 }
 
 static inline struct folio *folio_get_nontail_page(struct page *page)
--- a/include/linux/page-flags.h~mm-make-ref_unless-functions-unless_zero-only
+++ a/include/linux/page-flags.h
@@ -231,7 +231,7 @@ static __always_inline const struct page
 	return page;
 }
 
-static __always_inline bool page_count_writable(const struct page *page, int u)
+static __always_inline bool page_count_writable(const struct page *page)
 {
 	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
 		return true;
@@ -257,7 +257,7 @@ static __always_inline bool page_count_w
 	 * The refcount check also prevents modification attempts to other (r/o)
 	 * tail pages that are not fake heads.
 	 */
-	if (atomic_read_acquire(&page->_refcount) == u)
+	if (!atomic_read_acquire(&page->_refcount))
 		return false;
 
 	return page_fixed_fake_head(page) == page;
@@ -268,7 +268,7 @@ static inline const struct page *page_fi
 	return page;
 }
 
-static inline bool page_count_writable(const struct page *page, int u)
+static inline bool page_count_writable(const struct page *page)
 {
 	return true;
 }
--- a/include/linux/page_ref.h~mm-make-ref_unless-functions-unless_zero-only
+++ a/include/linux/page_ref.h
@@ -228,14 +228,14 @@ static inline int folio_ref_dec_return(s
 	return page_ref_dec_return(&folio->page);
 }
 
-static inline bool page_ref_add_unless(struct page *page, int nr, int u)
+static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
 	bool ret = false;
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (page_count_writable(page, u))
-		ret = atomic_add_unless(&page->_refcount, nr, u);
+	if (page_count_writable(page))
+		ret = atomic_add_unless(&page->_refcount, nr, 0);
 	rcu_read_unlock();
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
@@ -243,9 +243,9 @@ static inline bool page_ref_add_unless(s
 	return ret;
 }
 
-static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
+static inline bool folio_ref_add_unless_zero(struct folio *folio, int nr)
 {
-	return page_ref_add_unless(&folio->page, nr, u);
+	return page_ref_add_unless_zero(&folio->page, nr);
 }
 
 /**
@@ -261,12 +261,12 @@ static inline bool folio_ref_add_unless(
  */
 static inline bool folio_try_get(struct folio *folio)
 {
-	return folio_ref_add_unless(folio, 1, 0);
+	return folio_ref_add_unless_zero(folio, 1);
 }
 
 static inline bool folio_ref_try_add(struct folio *folio, int count)
 {
-	return folio_ref_add_unless(folio, count, 0);
+	return folio_ref_add_unless_zero(folio, count);
 }
 
 static inline int page_ref_freeze(struct page *page, int count)
_

Patches currently in -mm which might be from gladyshev.ilya1@h-partners.com are

mm-make-ref_unless-functions-unless_zero-only.patch

