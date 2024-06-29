Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAD3816
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627744; cv=none; b=SuX01QdtyWmotIKgWgAXgoyoCoHdT4Vc4YinLLH5AofFr5sJ9dYkvHBRViS4qhd/HMOYBF4TJCEGZ4QroZLuWbwJXX1Fjf70+2oZhCa/8jTDcqxm5nWD3EiwI0kJuSnS8rsGnCQYuS2VtnQIczzdS1ELSFz8Y9wGG7BkwhWSNQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627744; c=relaxed/simple;
	bh=SjUKIooIS+w744NooJqOuqePU8rHpDJG78qmGGPOfgs=;
	h=Date:To:From:Subject:Message-Id; b=e7934PwQblGojp1zvJJJuEzJ94EfdydHbRE8sX1kjzWKrHGkPG6zBQdzDnl0+z72bqFZ+S3NnjJkEwEbpYDybOAHRi+HSQzkGW+PHfhCeB6ZkGhvxbCVGWnU8QBtVtVhzloa8uaxL+sokrijddH14g4bZ7658B+AeJ9C679j0/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mEIntBuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mEIntBuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48AEC32781;
	Sat, 29 Jun 2024 02:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627743;
	bh=SjUKIooIS+w744NooJqOuqePU8rHpDJG78qmGGPOfgs=;
	h=Date:To:From:Subject:From;
	b=mEIntBuwtBHfrbb9LqTOIA0JbVy2Y8Z03KBPh+v7qbbo5vh+QaMxHEysshCLQqGGm
	 bQWxd+buDKhFLdvwj9ybpH1IOiiNBVrYtA3yvqQ6I5Sz+fPAcLHuzM+h4kAomWLHhx
	 A7fjcI3P5Yr2tQIuu/TwKqCTU3Fw5epvCPAc6SJc=
Date: Fri, 28 Jun 2024 19:22:23 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-3.patch removed from -mm tree
Message-Id: <20240629022223.D48AEC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: folio_add_new_anon_rmap() careful __folio_set_swapbacked()
has been removed from the -mm tree.  Its filename was
     mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-3.patch

This patch was dropped because it was folded into mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch

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

mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch

