Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57862430B99
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772393542; cv=none; b=ASOZO9Ya1ZTEyQBvLjC2V2YaogqhPq65ytlgTYCCaaTl4n3BLHsVYcmRt7EE59buwCYYLOoTM+6vhRJcO8tWwBT51QMevs16YCq5p/Sc4V+dDbhy1AcrNWQ34gYiWQ+RmYEIUTsyFS98x0zwjuvJpeRjUX+L5jNONYdjWY8QuxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772393542; c=relaxed/simple;
	bh=W+BMSgU2VSSXDS3zmd/5zYIE9t9tV+EWBP9K4camp1E=;
	h=Date:To:From:Subject:Message-Id; b=JFOQ59rSZZfDcgTJEbopjQWkQlSYzZ9l5JXQI5FnCJ41R+Eyg+pJoEQLABqO1i4snEdd5bpvoLLF8AZ4/HnMBNYFqI2Ndv9M4BNUDC6cSJ+oW5JjjRXEsnhtxFnAUO6U8TkMihirJThuxUHypOT68T7FCulo0KwZcSn09/FaVHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jR6UnJsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jR6UnJsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F57C116C6;
	Sun,  1 Mar 2026 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772393541;
	bh=W+BMSgU2VSSXDS3zmd/5zYIE9t9tV+EWBP9K4camp1E=;
	h=Date:To:From:Subject:From;
	b=jR6UnJsELC66qptR8xjWEx7sQd7XSePMLQDOSj5YQrHuqrIDflBhauSCQ85f9JGj5
	 XkQsZIYwoL9GssOA39AW35dc5o4wFKID+iVzNHcxAVw7pDOH49LFbw/RQ6DNb7scrV
	 xXRJsF4Gffn914aZTxLGFgiUqs3u1kgWTxz2jqUM=
Date: Sun, 01 Mar 2026 11:32:21 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,will@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kas@kernel.org,gorbunov.ivan@h-partners.com,david@kernel.org,gladyshev.ilya1@h-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-ref_unless-functions-unless_zero-only.patch added to mm-new branch
Message-Id: <20260301193221.C0F57C116C6@smtp.kernel.org>
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
Date: Sun, 1 Mar 2026 13:19:39 +0000

There are no users of (folio/page)_ref_add_unless(page, nr, u) with u != 0
[1] and all current users are "internal" for page refcounting API.  This
allows us to safely drop this parameter and reduce function semantics to
the "unless zero" cases only.

If needed, these functions for the u!=0 cases can be trivially
reintroduced later using the same atomic_add_unless operations as before.

[1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f ("mm:
remove the extra ZONE_DEVICE struct page refcount").  There is no trace of
discussion as to why this cleanup wasn't done earlier.

Link: https://lkml.kernel.org/r/a0c89b49d38c671a0bdd35069d15ee13e08314d2.1772370066.git.gladyshev.ilya1@h-partners.com
Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    2 +-
 include/linux/page_ref.h |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-make-ref_unless-functions-unless_zero-only
+++ a/include/linux/mm.h
@@ -1506,7 +1506,7 @@ static inline int folio_put_testzero(str
  */
 static inline bool get_page_unless_zero(struct page *page)
 {
-	return page_ref_add_unless(page, 1, 0);
+	return page_ref_add_unless_zero(page, 1);
 }
 
 static inline struct folio *folio_get_nontail_page(struct page *page)
--- a/include/linux/page_ref.h~mm-make-ref_unless-functions-unless_zero-only
+++ a/include/linux/page_ref.h
@@ -228,18 +228,18 @@ static inline int folio_ref_dec_return(s
 	return page_ref_dec_return(&folio->page);
 }
 
-static inline bool page_ref_add_unless(struct page *page, int nr, int u)
+static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
-	bool ret = atomic_add_unless(&page->_refcount, nr, u);
+	bool ret = atomic_add_unless(&page->_refcount, nr, 0);
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
 	return ret;
 }
 
-static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
+static inline bool folio_ref_add_unless_zero(struct folio *folio, int nr)
 {
-	return page_ref_add_unless(&folio->page, nr, u);
+	return page_ref_add_unless_zero(&folio->page, nr);
 }
 
 /**
@@ -255,12 +255,12 @@ static inline bool folio_ref_add_unless(
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

