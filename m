Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D2D6F2EB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423492; cv=none; b=lomhh9v1BOL1ONLKU//pvmeWM6kulNPyTJYelp0xX25/UNe0DWC35QkMe+SkhXDsMf3hZDgCeOlHbA3fRZ+5Z6674ggwt2wKVYVas2OL7iwI/kBH9V6o0opiFSwyFwQWE9bgIt8FtPl+k2MemkHTBoAkX4zOofFNYYjqwv1AMC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423492; c=relaxed/simple;
	bh=ARt+daV58oKXCUkGj28zXmCqXd1HhrfRYNsoszXQzb4=;
	h=Date:To:From:Subject:Message-Id; b=Lf1SEaJB3FOAfAMR8lVtvVmGInC/E2nX5hQixrwEgy0HNV/CCgJvKm1cBAwD0XXhQ9ayPP/ZGPOqRZwQe8KjEOA2S2OBsDqE9dpHz+nKyTWNH6th7m2w5txB9lVr+xV8JAnUMW4falG6mVm0Pz0sU6uGaYBNFs4v0QvPmQhS0+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QjXaoFbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QjXaoFbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69A1C4CEC2;
	Wed,  4 Sep 2024 04:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423491;
	bh=ARt+daV58oKXCUkGj28zXmCqXd1HhrfRYNsoszXQzb4=;
	h=Date:To:From:Subject:From;
	b=QjXaoFbtCnFRYFH8umpv9UQzVIhGkErnLsymrVt9CKSOR6HPFy89SY007oNWNbX+b
	 bsXLI7SrzQ/BwXDy4YpH1ACLNM1bPRMq4aCJwP0YbMDjv9IahdB6wYTpxfZADTGyrE
	 zgsc8eRsNe6gRCaVEN8mhLtcexVmfqRPbHiuV/0s=
Date: Tue, 03 Sep 2024 21:18:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-use-folio-_mapcount-for-small-folios.patch removed from -mm tree
Message-Id: <20240904041811.C69A1C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: use folio->_mapcount for small folios
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-folio-_mapcount-for-small-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: use folio->_mapcount for small folios
Date: Fri, 16 Aug 2024 12:32:46 +0200

We have some cases left whereby we operate on small folios and still refer
to page->_mapcount.  Let's just use folio->_mapcount instead, which
currently still overlays page->_mapcount, so no change.

This change will make it easier to later spot any remaining users of
page->_mapcount that target tail pages.

Link: https://lkml.kernel.org/r/20240816103246.719209-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 mm/rmap.c            |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-use-folio-_mapcount-for-small-folios
+++ a/include/linux/rmap.h
@@ -331,7 +331,7 @@ static __always_inline void __folio_dup_
 	switch (level) {
 	case RMAP_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
-			atomic_inc(&page->_mapcount);
+			atomic_inc(&folio->_mapcount);
 			break;
 		}
 
@@ -425,7 +425,7 @@ static __always_inline int __folio_try_d
 		if (!folio_test_large(folio)) {
 			if (PageAnonExclusive(page))
 				ClearPageAnonExclusive(page);
-			atomic_inc(&page->_mapcount);
+			atomic_inc(&folio->_mapcount);
 			break;
 		}
 
--- a/mm/rmap.c~mm-rmap-use-folio-_mapcount-for-small-folios
+++ a/mm/rmap.c
@@ -1165,7 +1165,7 @@ static __always_inline unsigned int __fo
 	switch (level) {
 	case RMAP_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
-			nr = atomic_inc_and_test(&page->_mapcount);
+			nr = atomic_inc_and_test(&folio->_mapcount);
 			break;
 		}
 
@@ -1535,7 +1535,7 @@ static __always_inline void __folio_remo
 	switch (level) {
 	case RMAP_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
-			nr = atomic_add_negative(-1, &page->_mapcount);
+			nr = atomic_add_negative(-1, &folio->_mapcount);
 			break;
 		}
 
_

Patches currently in -mm which might be from david@redhat.com are


