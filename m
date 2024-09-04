Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4F5770FD
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423533; cv=none; b=D0X/5z2VGfqN6BdlPBjKicNSURzNmDLRcnGKf5BOdIibeHRDsLrJbTdNnR1QxgEpi0zU1xQ01Lwe4n5hAIQyslfgwYMuBRAf5GWXxxJq+K40z/dxc3skuEcgIMp92k9jAP600yEC/a2ogiCkZD6+10eA5VFvZHnKaMf8uxALQLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423533; c=relaxed/simple;
	bh=VWVFG9BTofnJJk34YQ2xjQWJO9tCNShM66yP0Vg9MM4=;
	h=Date:To:From:Subject:Message-Id; b=B7dyD5yaoLBbB1rqZhi1xnN1CCUg+Ufznsaard3dD65VvdNOVnjnHmgHREGKS6EEjcZJySR+P6WAETQohtHZAtmwQsLQFNspNaXpNg65ZR17+FzbhAC8CQh6tXhvsZi7nhkCnTd4P/wUM+fszqYk21Yq540Bn/0Owr+a2mpa58g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lxjPuwap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lxjPuwap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867CCC4CEC2;
	Wed,  4 Sep 2024 04:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423533;
	bh=VWVFG9BTofnJJk34YQ2xjQWJO9tCNShM66yP0Vg9MM4=;
	h=Date:To:From:Subject:From;
	b=lxjPuwap0ZuKJJq9rGPTinHHrbCqrfOenDuo40gqEaO7WFjBBW3eVVMEiqDeGkDLd
	 NHozkB0MT1xeu24wLYdTKfMImLwdf8AEUHkKXGSrad2/TdOrs6MwBk2ZNhyyxYXm3x
	 8pdg3TpR/jbeu+3gDMlI0xHQQDNomWN7xYYvindM=
Date: Tue, 03 Sep 2024 21:18:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_has_private.patch removed from -mm tree
Message-Id: <20240904041853.867CCC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_has_private()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_has_private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_has_private()
Date: Wed, 21 Aug 2024 20:34:41 +0100

This function has no more callers, except folio_has_private().  Combine
the two functions.

Link: https://lkml.kernel.org/r/20240821193445.2294269-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-page_has_private
+++ a/include/linux/page-flags.h
@@ -1175,20 +1175,15 @@ static __always_inline void __ClearPageA
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
 /**
- * page_has_private - Determine if page has private stuff
- * @page: The page to be checked
+ * folio_has_private - Determine if folio has private stuff
+ * @folio: The folio to be checked
  *
- * Determine if a page has private stuff, indicating that release routines
+ * Determine if a folio has private stuff, indicating that release routines
  * should be invoked upon it.
  */
-static inline int page_has_private(const struct page *page)
+static inline int folio_has_private(const struct folio *folio)
 {
-	return !!(page->flags & PAGE_FLAGS_PRIVATE);
-}
-
-static inline bool folio_has_private(const struct folio *folio)
-{
-	return page_has_private(&folio->page);
+	return !!(folio->flags & PAGE_FLAGS_PRIVATE);
 }
 
 #undef PF_ANY
_

Patches currently in -mm which might be from willy@infradead.org are

swap-convert-swapon-to-use-a-folio.patch

