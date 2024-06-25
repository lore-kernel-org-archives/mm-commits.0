Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5516C142E7A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291691; cv=none; b=hi6RZadhvHprhZsUES1qpZUIhZET9cj+/mZxm/wyBMGoiICFwrjMYb1htdHdzJ1UPgDifu1UvmL87xkf8PEmlSJjiOdINNrmGnXCeGJZcFSxsAJhG47bfK9TkxRM1AJuHDHAIInWovogvzgPHxb4lvCwhc7D6am+zmLGb91ZnU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291691; c=relaxed/simple;
	bh=hSrB9ZjDzldjCmv+j7q2ls3pusc3hLh6VK72KQIbBFA=;
	h=Date:To:From:Subject:Message-Id; b=oKBuv5yxeFp5PwQwIUQeTLsxQVGFbm8THvGLchk2a7QF/gaOg9ygP/QhSyC/VaWYrTTGO/oLaflt1mB1zHyGAng/XYPqc8x71RIgpLBwrzwhoTvAoFacpqsh4F27aKX8ZpvODLDguJ0sr1dWxsELyy7Up0/cMofA9mTUYKj4HEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vMmLy7W+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vMmLy7W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3F4C32782;
	Tue, 25 Jun 2024 05:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291691;
	bh=hSrB9ZjDzldjCmv+j7q2ls3pusc3hLh6VK72KQIbBFA=;
	h=Date:To:From:Subject:From;
	b=vMmLy7W+pNC0OLicCoEACr/NbEXC/6kRcVe4mcuPKm2Kx72AqInk8khbWUwsafMHa
	 T1pskR+RR6ogTmPQOAt5qRZSnBBkIjNeBupwjVbJ07yq+9r9/Rcg07O7EscTo7Cu90
	 aid9j8F7aEdOCxBzsWqq1mtAKs8QtvJbyzZBgzBo=
Date: Mon, 24 Jun 2024 22:01:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-handle-incorrect-attempts-to-load-large-folios.patch removed from -mm tree
Message-Id: <20240625050130.EB3F4C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: handle incorrect attempts to load large folios
has been removed from the -mm tree.  Its filename was
     mm-zswap-handle-incorrect-attempts-to-load-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Barry Song <baohua@kernel.org>
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


