Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794275588;
	b=20jMZW96asw7E1ExJ/F0HYA/CFz+ar3xUplql8P1q9L3qE04GuD6+2BxXrl+msoSBWZp
	 17+xoefoA/o3skFxb+CYRIxDitpFjBGjjnCB+q8FBiQWyflVQa1TrdCKvoOkT39q24OsN
	 IIt7jy1P4tf5/kNpl2aXUUXToHTSlF8IaEvbxHFjspG1ERhkXlSBDxvLwnqCJTx4Ua1of
	 Ksy1RvGOIS/NCVOE5Mha+rBI0676L74sdmRU2ptWRJcS2NlFHQd9WXI3AplqBy3PVLyXy
	 e2+bDVUrU/szCbwjUfa+oaHk+1mGoj/TtmYVHrqjrW9CVJDiwYTARLVmKMdVYfStMLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794275588;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1/g/MfUV3OJlVmpCgQkJ7HDA7Jwin4jF5iq9XHLLmAo=;
	b=2OtNu/QnXvxM6fyToKC9U22rPT+wIWEbgAEeIduDCBiJWofV8Bo1Ih/CQyoZe/t7Eud1
	 lcrrrLc5g42SOw8LsPQJhTm6viX8j/7v3Y2L1yvgkYLdRuhorVIaQrPSUSt3sH/XrzmZg
	 MB1W4k5bqASuqh47gfAc/EMFa345XdRnGHRvj/lMFwveoL3lTBY5vFgPOVWkapn0bAZnm
	 Xnp+P/TIPOGpQczFmNL039ZRC32vhCtMW0HyBYXO9fnCkRwgBiUvGP2VB0ECIszd01TMM
	 pxTMAoJ2I3hP2IGR42IzujGPgh/CGxbd2IczaN8RQ4wIMcB1YCiTGGYdTKDBJSlX9Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wENXKlPA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C272606A31C
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 01:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wENXKlPA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7201F0089F;
	Tue, 10 Nov 2026 01:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794275587;
	bh=1/g/MfUV3OJlVmpCgQkJ7HDA7Jwin4jF5iq9XHLLmAo=;
	h=Date:To:From:Subject;
	b=wENXKlPAgqtQYo7bYWtNsr/1/QkNwjtEkPXmtED0a5E/OlSLKcQa7rc5GIuc08eA6
	 rxm0zctLKxvPwZLd9ZO2H1DP2q7SSnzH9ZPzr8bvuhBIN0LFjIom4BpjK8LHcuTtZd
	 4baQHJYivFUozN+hnmjZAFzPJ1rvdJrutGRwl4D4=
Date: Mon, 09 Nov 2026 17:53:07 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,manuelebnerli@mailbox.org,
	jm5905938@gmail.com,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-list_nextprev_entry-in-damon_nextprev_region.patch added to mm-new branch
Message-Id: <20261110015307.BC7201F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: use list_{next,prev}_entry() in damon_{next,prev}_region()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-use-list_nextprev_entry-in-damon_nextprev_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-list_nextprev_entry-in-damon_nextprev_region.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/core: use list_{next,prev}_entry() in damon_{next,prev}_region()
Date: Mon, 09 Nov 2026 17:05:56 -0800

Patch series "mm/damon: cleanup region iterator and damon_reclaim user
doc".

Two simple cleanups.  Use dedicated next/prev list entry accessors in
damon_{next,prev}_region() for code maintainability (patch 1, Enze Li). 
Fix typos, grammars and improve overall readability of DAMON_RECLAIM user
document (patch 2, Manuel Ebner).


This patch (of 2):

damon_next_region() and damon_prev_region() manually do container_of()
type casting to fetch the next and previous region from the linked
list.  Use the dedicated list.h helpers, list_next_entry() and
list_prev_entry(), as damon_first_region() and damon_last_region() do.

Link: https://lore.kernel.org/20261110010558.104905-1-sj@kernel.org
Link: https://lore.kernel.org/20261110010558.104905-2-sj@kernel.org
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Aveline Noir <jm5905938@gmail.com>
---

 include/linux/damon.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-use-list_nextprev_entry-in-damon_nextprev_region
+++ a/include/linux/damon.h
@@ -992,12 +992,12 @@ static inline unsigned long damon_rand(s
 
 static inline struct damon_region *damon_next_region(struct damon_region *r)
 {
-	return container_of(r->list.next, struct damon_region, list);
+	return list_next_entry(r, list);
 }
 
 static inline struct damon_region *damon_prev_region(struct damon_region *r)
 {
-	return container_of(r->list.prev, struct damon_region, list);
+	return list_prev_entry(r, list);
 }
 
 static inline struct damon_region *damon_last_region(struct damon_target *t)
_

Patches currently in -mm which might be from lienze@kylinos.cn are

docs-hugetlbpagerst-clarify-hugepages_total-in-hugetlbpagerst.patch
mm-hugetlb-drop-unused-mm-parameter-from-unmap_ref_private.patch
mm-hugetlb_cma-remove-two-unused-include-files.patch
mm-damon-core-use-list_nextprev_entry-in-damon_nextprev_region.patch

