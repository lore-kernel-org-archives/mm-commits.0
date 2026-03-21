Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EB3225417
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774056072; cv=none; b=GjoymksjoPvvIFW1gQTTRj7/IwKZDFiKasM00sRnI2oDEKoCA/fWqpkBP2nqMNha5fYB1bAN1uu1M+LlKMCCjmhkQ8nCzymGNCdujtaQh2AML6Gvk3nJP+rHIyoAImno5c5kh1tfV/surICrPNqALL9hWQ00nSpfuXncG1w1YJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774056072; c=relaxed/simple;
	bh=WxqN67UcacsroUgxL2xNqkjk9VjkKorqv6BhRT1Upg8=;
	h=Date:To:From:Subject:Message-Id; b=RDNerQrtKdBclFtZ9NbuWGQ778xgxf3g59bFzhYz5CMDMI2G9Xb93KGzsVv6vMWMadVkhcPffTmvKklAphcpuEMVIjcIgne/+nkAJbHaa8iCq3+iqOfsqwZQ7K8c45nTULC2X+zRz8axQqD1nJb8sXJ4Aido04E8tNnoCfVfGjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LkKhwrs2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LkKhwrs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02D3C4CEF7;
	Sat, 21 Mar 2026 01:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774056072;
	bh=WxqN67UcacsroUgxL2xNqkjk9VjkKorqv6BhRT1Upg8=;
	h=Date:To:From:Subject:From;
	b=LkKhwrs216AyL4RmnAR+xYjXjcLXHVkbKAVRaoB4FgCG/lx7aMe1PU+WjtD3rF8Ju
	 Hp/CM12Wy+RMTkfZamXmBVtJyqtEW8mThL39V+8JcbDySKOImzy3cn+VUVQWltzMIb
	 pHE9wT9kkgseK6UKdFwKhT1NNGbIiKL3BK1Jtprc=
Date: Fri, 20 Mar 2026 18:21:12 -0700
To: mm-commits@vger.kernel.org,richard@nod.at,marscheng@google.com,jserv@ccns.ncku.edu.tw,hch@infradead.org,eleanor15x@gmail.com,chengzhihao1@huawei.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final.patch added to mm-nonmm-unstable branch
Message-Id: <20260321012112.B02D3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/list_sort: Remove dummy cmp() calls to speed up merge_final()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/list_sort: Remove dummy cmp() calls to speed up merge_final()
Date: Fri, 20 Mar 2026 18:09:38 +0000

Historically, list_sort() implemented a hack in merge_final():
    if (unlikely(!++count))
        cmp(priv, b, b);

This was introduced 16 years ago in commit 835cc0c8477f ("lib: more
scalable list_sort()") so that callers could periodically invoke
cond_resched() within their comparison functions when merging highly
unbalanced lists.

An audit of the kernel tree reveals that fs/ubifs/ was the sole user of
this mechanism.  Recent discussions and inspections by Richard Weinberger
confirm that UBIFS lists are strictly bounded in size (a few thousand
elements at most), meaning it does not strictly rely on these dummy
callbacks to prevent soft lockups.

For the vast majority of list_sort() users (such as block layer IO
schedulers and file systems), this hack results in completely wasted
function calls.  In the worst-case scenario (merging an already sorted
list where 'a' is exhausted quickly), it results in approximately
(N/2)/256 unnecessary cmp() invocations.

Remove the dummy cmp(priv, b, b) fallback from merge_final().  This saves
unnecessary function calls, avoids branching overhead in the tight loop,
and slightly speeds up the final merge step for all generic list_sort()
users.

Link: https://lkml.kernel.org/r/20260320180938.1827148-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mars Cheng <marscheng@google.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Yu-Chun Lin <eleanor15x@gmail.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/lib/list_sort.c~lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final
+++ a/lib/list_sort.c
@@ -76,15 +76,6 @@ static void merge_final(void *priv, list
 	/* Finish linking remainder of list b on to tail */
 	tail->next = b;
 	do {
-		/*
-		 * If the merge is highly unbalanced (e.g. the input is
-		 * already sorted), this loop may run many iterations.
-		 * Continue callbacks to the client even though no
-		 * element comparison is needed, so the client's cmp()
-		 * routine can invoke cond_resched() periodically.
-		 */
-		if (unlikely(!++count))
-			cmp(priv, b, b);
 		b->prev = tail;
 		tail = b;
 		b = b->next;
_

Patches currently in -mm which might be from visitorckw@gmail.com are

ubifs-remove-unnecessary-cond_resched-from-list_sort-compare.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final.patch

