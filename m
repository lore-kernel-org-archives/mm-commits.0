Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818C4154C00
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 22:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143748; cv=none; b=kkYLSchYMf2gAq9RDm2sb7kmF3WuPqQE6dZLodbwFeR7EsazNJ2qp6pjGWm+BlIJbF42JU73fPWTn+/DbkKmGaUJCmheBLEWT9fY88tcs+ZYuKFnuT6tn2WepamRAwY9pRRppttBkasA3mkWNx/Xz05nZbO/7IydyQ9zCd8pRyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143748; c=relaxed/simple;
	bh=LRcZ6fEzm44qf3WxOVc4Ny3WbIvqjNEvff5gV0vms0M=;
	h=Date:To:From:Subject:Message-Id; b=sViH1uAg38QtfnQxSthh7L4iVet3aOqblm6uesNYWEQ+o4xBDMCNjw7PWm7cNXjnvGy1Jr5ygIk/htwUEhJRkdVe4nDuZ9hGPqkMYjD3ldbd73Uwx7wHcLEEiZPejvFiZhr4HvfZbUTx9XRDPX87WG2xn8AEAj3bvhYMQzqWOWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QaqZzcsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QaqZzcsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F023CC2BD10;
	Tue, 11 Jun 2024 22:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718143748;
	bh=LRcZ6fEzm44qf3WxOVc4Ny3WbIvqjNEvff5gV0vms0M=;
	h=Date:To:From:Subject:From;
	b=QaqZzcsZt9m4YZxF+DyOLq8Ia8qcRAX21dCmNzIMbGfqwrUa+2Tfpm1TCAKoatjGw
	 k4TsH+RSCwmHcnvY9p61Xp7LopcDJ7rqCKztHndp5vjQ7vHFBrzRWppOZM8ml5LgQL
	 3OS/DEGRGWrOoxUuhZ3RtPbtakQ/NkXXuv/mW8J0=
Date: Tue, 11 Jun 2024 15:09:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-handle-incorrect-attempts-to-load-large-folios.patch added to mm-unstable branch
Message-Id: <20240611220907.F023CC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: handle incorrect attempts to load large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-handle-incorrect-attempts-to-load-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-handle-incorrect-attempts-to-load-large-folios.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: handle incorrect attempts to load large folios
Date: Tue, 11 Jun 2024 02:45:16 +0000

Zswap does not support storing or loading large folios.  Until proper
support is added, attempts to load large folios from zswap are a bug.

For example, if a swapin fault observes that contiguous PTEs are pointing
to contiguous swap entries and tries to swap them in as a large folio,
swap_read_folio() will pass in a large folio to zswap_load(), but
zswap_load() will only effectively load the first page in the folio.  If
the first page is not in zswap, the folio will be read from disk, even
though other pages may be in zswap.

In both cases, this will lead to silent data corruption.  Proper support
needs to be added before large folio swapins and zswap can work together.

Looking at callers of swap_read_folio(), it seems like they are either
allocated from __read_swap_cache_async() or do_swap_page() in the
SWP_SYNCHRONOUS_IO path.  Both of which allocate order-0 folios, so
everything is fine for now.

However, there is ongoing work to add to support large folio swapins [1]. 
To make sure new development does not break zswap (or get broken by
zswap), add minimal handling of incorrect loads of large folios to zswap. 
First, move the call folio_mark_uptodate() inside zswap_load().

If a large folio load is attempted, and zswap was ever enabled on the
system, return 'true' without calling folio_mark_uptodate().  This will
prevent the folio from being read from disk, and will emit an IO error
because the folio is not uptodate (e.g.  do_swap_fault() will return
VM_FAULT_SIGBUS).  It may not be reliable recovery in all cases, but it is
better than nothing.

This was tested by hacking the allocation in __read_swap_cache_async() to
use order 2 and __GFP_COMP.

In the future, to handle this correctly, the swapin code should:

(a) Fall back to order-0 swapins if zswap was ever used on the
    machine, because compressed pages remain in zswap after it is
    disabled.

(b) Add proper support to swapin large folios from zswap (fully or
    partially).

Probably start with (a) then followup with (b).

[1]https://lore.kernel.org/linux-mm/20240304081348.197341-6-21cnbao@gmail.com/

Link: https://lkml.kernel.org/r/20240611024516.1375191-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    1 -
 mm/zswap.c   |   12 ++++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/mm/page_io.c~mm-zswap-handle-incorrect-attempts-to-load-large-folios
+++ a/mm/page_io.c
@@ -515,7 +515,6 @@ void swap_read_folio(struct folio *folio
 	delayacct_swapin_start();
 
 	if (zswap_load(folio)) {
-		folio_mark_uptodate(folio);
 		folio_unlock(folio);
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
 		swap_read_folio_fs(folio, plug);
--- a/mm/zswap.c~mm-zswap-handle-incorrect-attempts-to-load-large-folios
+++ a/mm/zswap.c
@@ -1567,6 +1567,17 @@ bool zswap_load(struct folio *folio)
 		return false;
 
 	/*
+	 * Large folios should not be swapped in while zswap is being used, as
+	 * they are not properly handled. Zswap does not properly load large
+	 * folios, and a large folio may only be partially in zswap.
+	 *
+	 * Return true without marking the folio uptodate so that an IO error is
+	 * emitted (e.g. do_swap_page() will sigbus).
+	 */
+	if (WARN_ON_ONCE(folio_test_large(folio)))
+		return true;
+
+	/*
 	 * When reading into the swapcache, invalidate our entry. The
 	 * swapcache can be the authoritative owner of the page and
 	 * its mappings, and the pressure that results from having two
@@ -1600,6 +1611,7 @@ bool zswap_load(struct folio *folio)
 		folio_mark_dirty(folio);
 	}
 
+	folio_mark_uptodate(folio);
 	return true;
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch
mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch
mm-swap-remove-synchronous-argument-to-swap_read_folio.patch
mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled.patch
mm-zswap-add-zswap_never_enabled.patch
mm-zswap-handle-incorrect-attempts-to-load-large-folios.patch

