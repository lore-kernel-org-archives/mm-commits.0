Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D6E1870
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719343838; cv=none; b=ElP/GR1A+IZDc5skiQ+x4zmZJTggznfRK9Oa9dgi+tvEZznhtXAERvnDXLczdk6lTVNbL/Bpb/Lu9Hipywim+FLImw0MMI8ZdC+a7MzCNfQwT/8i4rL2i8/5xwz7a+RMJ/dTqWe12Bid3qS3ujeD66HA5PtCpKXBCdCrPbvH+U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719343838; c=relaxed/simple;
	bh=4OuVqqIFY0/ckU6r3iFhYyLLz5f1FiIxCjIsKVxZtRY=;
	h=Date:To:From:Subject:Message-Id; b=HoTl3TVWjOxcPMXDv1Pg6VuJ6SG9Tp6tUGz8VI8/Qgawyf7EdkzkDEKd3RIlbSKy+FQ08dsGr3gDwGJ+eE0fDWO1PrQdQS82EUdwI+jrsxvf2XX5895yu5QF5SnkOHjzh/4R1figYdiWjWIh85MKrAPh9gmkbD/VRnqjzLPXh5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z8KBIkH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z8KBIkH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4278DC32781;
	Tue, 25 Jun 2024 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719343837;
	bh=4OuVqqIFY0/ckU6r3iFhYyLLz5f1FiIxCjIsKVxZtRY=;
	h=Date:To:From:Subject:From;
	b=Z8KBIkH8KRtW1WLFDwWlqQ1sk1ja1rv0Yl3/VYYlxEAunAODC7+EFQQTEMuXAq5l8
	 w0Zu7PT2H7ZvH6Ua/i72zzpCoPETiH3G3x7W8TKgVDbRNh5nd396A4AOotNjDCDk5S
	 9Ut83ZIwtNeKlyO4XEgQwMrWQsQW8+b8aR5dCWfY=
Date: Tue, 25 Jun 2024 12:30:36 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-3.patch added to mm-unstable branch
Message-Id: <20240625193037.4278DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: folio_add_new_anon_rmap() careful __folio_set_swapbacked()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-3.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: folio_add_new_anon_rmap() careful __folio_set_swapbacked()
Date: Mon, 24 Jun 2024 22:00:24 -0700 (PDT)

Commit "mm: use folio_add_new_anon_rmap() if folio_test_anon(folio)==
false" has extended folio_add_new_anon_rmap() to use on non-exclusive
folios, already visible to others in swap cache and on LRU.

That renders its non-atomic __folio_set_swapbacked() unsafe: it risks
overwriting concurrent atomic operations on folio->flags, losing bits
added or restoring bits cleared.  Since it's only used in this risky way
when folio_test_locked and !folio_test_anon, many such races are excluded;
but, for example, isolations by folio_test_clear_lru() are vulnerable, and
setting or clearing active.

It could just use the atomic folio_set_swapbacked(); but this function
does try to avoid atomics where it can, so use a branch instead: just
avoid setting swapbacked when it is already set, that is good enough. 
(Swapbacked is normally stable once set: lazyfree can undo it, but only
later, when found anon in a page table.)

This fixes a lot of instability under compaction and swapping loads:
assorted "Bad page"s, VM_BUG_ON_FOLIO()s, apparently even page double
frees - though I've not worked out what races could lead to the latter.

Link: https://lkml.kernel.org/r/f3599b1d-8323-0dc5-e9e0-fdb3cfc3dd5a@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-3
+++ a/mm/rmap.c
@@ -1422,7 +1422,9 @@ void folio_add_new_anon_rmap(struct foli
 	VM_WARN_ON_FOLIO(!exclusive && !folio_test_locked(folio), folio);
 	VM_BUG_ON_VMA(address < vma->vm_start ||
 			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
-	__folio_set_swapbacked(folio);
+
+	if (!folio_test_swapbacked(folio))
+		__folio_set_swapbacked(folio);
 	__folio_set_anon(folio, vma, address, exclusive);
 
 	if (likely(!folio_test_large(folio))) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-migrate-folio_ref_freeze-under-xas_lock_irq.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-3.patch

