Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4994B1B7F6
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709761595; cv=none; b=jldYgj/Fo9AT44OLm3aAfDaGW2OfElctpBBKylUdfeh8ioTT0xIaL/d3CzenCnxVdB1kdC4mkYnvN/yA0fCHNH3ylzy98lg743mf6e5ET6C+NoY8epnMKzHhaJS+n0go0EpdyQ3LZaZ0VflbaZaI6YKgx2Ned1r/hjC+Ksz1+wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709761595; c=relaxed/simple;
	bh=vUeDkZ+OLpFoDuqSoQHnZJPi94rAJmx9T4A172XIy3c=;
	h=Date:To:From:Subject:Message-Id; b=tt+XkhUhcDh6LA+c7vw9yAUkU9ImJR8AOV3/rxLoo0RsuxqdjpO5t17gKOg+QOifo1UsfOgcFABnJHjlzRvoHqFmkai4rsL/OriHrHvsgjvpspk6WdJ3ee5uDhz3x2iemTmPJSOYAUDEn2fAQu/joH7IaYpanv6fHQrZvNosOI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=llM43Zc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="llM43Zc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3515C433C7;
	Wed,  6 Mar 2024 21:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709761594;
	bh=vUeDkZ+OLpFoDuqSoQHnZJPi94rAJmx9T4A172XIy3c=;
	h=Date:To:From:Subject:From;
	b=llM43Zc0sXXAEcrdaNR5nAFlQzMHf2d/K3Ojd+UyTqOD/RKVuo8Ol9bvQrRJp1UqO
	 kR+UKKf7pcmV8q9R3oFEM1mMbGWcQUm7mrVURu7rtnFWZrUu75ctb3IMp9UF8SpKYI
	 k7eCsQzJfaqs0WaxW2EKLTVEeKnkcUgKJBxQaxjE=
Date: Wed, 06 Mar 2024 13:46:34 -0800
To: mm-commits@vger.kernel.org,chaitanya.kumar.borah@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-list-corruption-in-put_pages_list.patch added to mm-unstable branch
Message-Id: <20240306214634.B3515C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix list corruption in put_pages_list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-list-corruption-in-put_pages_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-list-corruption-in-put_pages_list.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix list corruption in put_pages_list
Date: Wed, 6 Mar 2024 21:27:30 +0000

My recent change to put_pages_list() dereferences folio->lru.next after
returning the folio to the page allocator.  Usually this is now on the pcp
list with other free folios, so we try to free an already-free folio. 
This only happens with lists that have more than 15 entries, so it wasn't
immediately discovered.  Revert to using list_for_each_safe() so we
dereference lru.next before disposing of the folio.

Link: https://lkml.kernel.org/r/20240306212749.1823380-1-willy@infradead.org
Fixes: 24835f899c01 ("mm: use free_unref_folios() in put_pages_list()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-fix-list-corruption-in-put_pages_list
+++ a/mm/swap.c
@@ -152,10 +152,10 @@ EXPORT_SYMBOL(__folio_put);
 void put_pages_list(struct list_head *pages)
 {
 	struct folio_batch fbatch;
-	struct folio *folio;
+	struct folio *folio, *next;
 
 	folio_batch_init(&fbatch);
-	list_for_each_entry(folio, pages, lru) {
+	list_for_each_entry_safe(folio, next, pages, lru) {
 		if (!folio_put_testzero(folio))
 			continue;
 		if (folio_test_large(folio)) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-list-corruption-in-put_pages_list.patch

