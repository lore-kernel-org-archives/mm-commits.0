Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035E910A24
	for <mm-commits@vger.kernel.org>; Sat,  7 Sep 2024 03:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725678837; cv=none; b=lwjTTYiDH8CiDyb+2mQPApQm+69UpT1hOeYSbyP+1XdCj8wvD6fi1tLlrUCzzxDoIRCpHYTUBjhVWF0gdp17kPfByPkgOLxKQxIBUmChpN0q+ls34gPuwUQLk6FuB5t/fgf5tp8dX/H2NS4qvIDqlbmRj6Az53PjnxZU84EaPZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725678837; c=relaxed/simple;
	bh=cp21SUWcDLZckCVFPFUuTgokE4JE/UWjRolN057QcK8=;
	h=Date:To:From:Subject:Message-Id; b=AfKc18xnePSCrYOgcSl1orVlU8gzjbfXgWMyDEoJZ4NgYxdUQARmrggrxIxNDAzYsFnRJX640/Y1byb6//nFU+Yf7zy2m4VPBeyZ0JQ0lBObdJvCdLj4uz0ERXBwmgpXbiBM2u1SgUXlIQso3C7OfR7BVrMaE8AQpd4LE9Gfva0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NRU3sGsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NRU3sGsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68708C4CEC4;
	Sat,  7 Sep 2024 03:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725678836;
	bh=cp21SUWcDLZckCVFPFUuTgokE4JE/UWjRolN057QcK8=;
	h=Date:To:From:Subject:From;
	b=NRU3sGsZDvMhmsH+el7OMsh6PeEqplGahtqfkBWfeVwZnop8/i+Rw9TNebq0a9zLq
	 eTe/h2zOlQEhjTZ8tD44/P2cmR3yyjdpykblCAXWjKHGaA99Y2CISfY6YWaIHudskD
	 9yVLmcCRZSsJFJRR98e96BiXKbvrDZYB5LQiSt5w=
Date: Fri, 06 Sep 2024 20:13:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,liam.howlett@oracle.com,hughd@google.com,baolin.wang@linux.alibaba.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-xa_get_order-with-xas_get_order-where-appropriate.patch added to mm-unstable branch
Message-Id: <20240907031356.68708C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: replace xa_get_order with xas_get_order where appropriate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-xa_get_order-with-xas_get_order-where-appropriate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-xa_get_order-with-xas_get_order-where-appropriate.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: replace xa_get_order with xas_get_order where appropriate
Date: Fri, 6 Sep 2024 16:05:12 -0700

The tracing of invalidation and truncation operations on large files
showed that xa_get_order() is among the top functions where kernel spends
a lot of CPUs.  xa_get_order() needs to traverse the tree to reach the
right node for a given index and then extract the order of the entry. 
However it seems like at many places it is being called within an already
happening tree traversal where there is no need to do another traversal. 
Just use xas_get_order() at those places.

Link: https://lkml.kernel.org/r/20240906230512.124643-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 +++---
 mm/shmem.c   |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-replace-xa_get_order-with-xas_get_order-where-appropriate
+++ a/mm/filemap.c
@@ -2112,7 +2112,7 @@ unsigned find_lock_entries(struct addres
 			VM_BUG_ON_FOLIO(!folio_contains(folio, xas.xa_index),
 					folio);
 		} else {
-			nr = 1 << xa_get_order(&mapping->i_pages, xas.xa_index);
+			nr = 1 << xas_get_order(&xas);
 			base = xas.xa_index & ~(nr - 1);
 			/* Omit order>0 value which begins before the start */
 			if (base < *start)
@@ -3005,7 +3005,7 @@ unlock:
 static inline size_t seek_folio_size(struct xa_state *xas, struct folio *folio)
 {
 	if (xa_is_value(folio))
-		return PAGE_SIZE << xa_get_order(xas->xa, xas->xa_index);
+		return PAGE_SIZE << xas_get_order(xas);
 	return folio_size(folio);
 }
 
@@ -4301,7 +4301,7 @@ static void filemap_cachestat(struct add
 		if (xas_retry(&xas, folio))
 			continue;
 
-		order = xa_get_order(xas.xa, xas.xa_index);
+		order = xas_get_order(&xas);
 		nr_pages = 1 << order;
 		folio_first_index = round_down(xas.xa_index, 1 << order);
 		folio_last_index = folio_first_index + nr_pages - 1;
--- a/mm/shmem.c~mm-replace-xa_get_order-with-xas_get_order-where-appropriate
+++ a/mm/shmem.c
@@ -890,7 +890,7 @@ unsigned long shmem_partial_swap_usage(s
 		if (xas_retry(&xas, page))
 			continue;
 		if (xa_is_value(page))
-			swapped += 1 << xa_get_order(xas.xa, xas.xa_index);
+			swapped += 1 << xas_get_order(&xas);
 		if (xas.xa_index == max)
 			break;
 		if (need_resched()) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-replace-xa_get_order-with-xas_get_order-where-appropriate.patch

