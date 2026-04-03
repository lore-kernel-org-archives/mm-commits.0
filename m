Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B43F34D91F
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198542; cv=none; b=gs0mKpFeffCP8JYTX/qD0U5EcV/hRyovnOc+o1Z2dr/UajyeNPXLP0JK2Lul0rLxUUL+rnhq72bFO1YjUGnv19XQ89p7BPoeiwct/Zt4F7gT3hh3aPWC6dtTPyoMerdwmpPtvD0QWoSbqs9++pFryE+a/Jo8rhTCXuXYPze4sEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198542; c=relaxed/simple;
	bh=/AlPS4pPnoDIbGf8btk9fN7lqwy4Cerx2tksNWC67BA=;
	h=Date:To:From:Subject:Message-Id; b=kKAeCgoL9lKfri+VPgphGI4BdD23XRH16a4sa6ZgUFnhUJ5M5wawJX5ZWQXD1oyK2pAEdKnRmt4rxZYRsVzRiE6CGtAu9IZxhe9Pol+CMccU2VzWD4j23X/QuVYrVz80N+YZvS1GHxHJ2UX2msjX9RqTfB77ayElEo+Ib1nxIvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ecBMwepp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecBMwepp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588BBC4CEF7;
	Fri,  3 Apr 2026 06:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198542;
	bh=/AlPS4pPnoDIbGf8btk9fN7lqwy4Cerx2tksNWC67BA=;
	h=Date:To:From:Subject:From;
	b=ecBMweppa6eY1yUuMQ4VXe1qRMmCUuVXtnWO8bnHAquPndIadsvX9NxKtmwhRLIjK
	 9BONRS4tWteZ8stoAlvfKKmB2WfewfO3hFaqhyLetph3Mu1dCXG3RnIG0AvyM99WsJ
	 qy6T3wXagQq7CqH1eW95pV7BwGxLc/bxQX2TTERc=
Date: Thu, 02 Apr 2026 23:42:21 -0700
To: mm-commits@vger.kernel.org,richard@nod.at,marscheng@google.com,jserv@ccns.ncku.edu.tw,hch@lst.de,eleanor15x@gmail.com,chengzhihao1@huawei.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final.patch removed from -mm tree
Message-Id: <20260403064222.588BBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/list_sort: remove dummy cmp() calls to speed up merge_final()
has been removed from the -mm tree.  Its filename was
     lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/list_sort: remove dummy cmp() calls to speed up merge_final()
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

[akpm@linux-foundation.org: remove now-unused local]
Link: https://lkml.kernel.org/r/20260320180938.1827148-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Mars Cheng <marscheng@google.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Yu-Chun Lin <eleanor15x@gmail.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/lib/list_sort.c~lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final
+++ a/lib/list_sort.c
@@ -50,7 +50,6 @@ static void merge_final(void *priv, list
 			struct list_head *a, struct list_head *b)
 {
 	struct list_head *tail = head;
-	u8 count = 0;
 
 	for (;;) {
 		/* if equal, take 'a' -- important for sort stability */
@@ -76,15 +75,6 @@ static void merge_final(void *priv, list
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


