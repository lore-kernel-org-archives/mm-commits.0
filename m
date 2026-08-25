Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8278437F309
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622972; cv=none; b=P0dOxHrqqJCqfX1sx1JQ1coYbNIzzVBgemavGrVeCjthVJOh9joN+HBEdiYeobiLdlkacq0U+ntxTIYGDOXKxYcgnCrlm1ZeSHsJ7EIZmrBuB1jZ4t8n5X9gqwkMDeAPOq1n3jvT6bYkj+QtfnccF3yNq0VgwPo7Dm2fNsOn8k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622972; c=relaxed/simple;
	bh=0+Uo6enXITClD6YBS+JOxWdhrr2wk7bxc4liCGeRFTU=;
	h=Date:To:From:Subject:Message-Id; b=ObpeO/+8cIdqO6zf54xnVivRGXm9NykeHeMyMFyBCQP61stpAYkG2ZdHhFuaj3sUZB5+8dJ/zom/sjchayrD91/YmxHxnOIYabI1lWOTCT2VpiLpvgDjdSxMRiAdS16g+F0wkwvpEhMtd9k7wfGZxZ2yh+qia3q/QIblrlhl130=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JDD1W/lc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JDD1W/lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C391F000E9;
	Tue, 25 Aug 2026 01:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622971;
	bh=Vr+rxTwX9fLaB2fFCR7qwY1pTSso2q4QTWl836OoBdg=;
	h=Date:To:From:Subject;
	b=JDD1W/lcC5H3tS+zuYl5CHJbqsuM9NXz5VIpo1EejNRNyvpzkbWrHcT4xCxvDT/Ci
	 qR1oBEsctzxbWLMU6I8y/cmt7ZtoC70YfaoluXsk+WKmx4g68HNzF42hBIRv/ecLi1
	 FsTpuvlfQXLXygfT61H4Khqw+vuTiAP3tCx2ra08=
Date: Mon, 24 Aug 2026 18:56:10 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-clarify-comments-on-mas_nomem.patch removed from -mm tree
Message-Id: <20260825015611.12C391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: clarify comments on mas_nomem()
has been removed from the -mm tree.  Its filename was
     maple_tree-clarify-comments-on-mas_nomem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: clarify comments on mas_nomem()
Date: Fri, 21 Aug 2026 15:26:15 -0400

When an allocation completely fails, the return is false.  If the
allocation succeeds or partially succeeds, return true to indicate a retry
of the operation.  Note that since the lock may have been dropped, the
operation is retried from the start - including potentially allocating
more memory.

Link: https://lore.kernel.org/20260821192627.4085470-8-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clarify-comments-on-mas_nomem
+++ a/lib/maple_tree.c
@@ -5677,10 +5677,11 @@ EXPORT_SYMBOL_GPL(mas_erase);
 
 /**
  * mas_nomem() - Check if there was an error allocating and do the allocation
- * if necessary If there are allocations, then free them.
+ * if necessary.
+ *
  * @mas: The maple state
  * @gfp: The GFP_FLAGS to use for allocations
- * Return: true on allocation, false otherwise.
+ * Return: False on no memory.  True otherwise (partial success as well)
  */
 bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	__must_hold(mas->tree->ma_lock)
@@ -5696,6 +5697,10 @@ bool mas_nomem(struct ma_state *mas, gfp
 		mas_alloc_nodes(mas, gfp);
 	}
 
+	/*
+	 * Return false on zero forward progress.  Partial allocations are kept
+	 * so the retry path will attempt to get the rest.
+	 */
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
_

Patches currently in -mm which might be from liam@infradead.org are


