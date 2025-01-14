Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0756E230999
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836931; cv=none; b=MKgpYpWTDDPVJ3oMNjWXRR74KIqm7v4WyuENvPOi2MdMSO4T5FmW6DgfGyVHI5e1BY1+XG9qwNg2IqFv+8TeIbHRp+RQT0l4wiu4hB+rmgJXICgAAPFJExybK09kTWYX/gzG3DiE5aVWfqJUNaeXvtd8VZvZYupdloBy2utoLW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836931; c=relaxed/simple;
	bh=IAupg3t+/1lt0FNpcJu0h2JJEAZYXyakzMlzm18iVGc=;
	h=Date:To:From:Subject:Message-Id; b=YejK+eICpL3PLLqSd4Q9hl0eT5qfR3ogyYbqjkXCIHzxwsemz5HH8Ug6UmV8QTAz6XkYZIRWJXTr2F6tSjF2aRwm+oHzu1UvvRJyCAyMZis8gTYCTuJ5ZYdAdonAocBYFua+HOBDtcigAzflAVwTlJWREFheZO12zZ4gdAKlhbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sPMJ2p64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sPMJ2p64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F51CC4CEDF;
	Tue, 14 Jan 2025 06:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836930;
	bh=IAupg3t+/1lt0FNpcJu0h2JJEAZYXyakzMlzm18iVGc=;
	h=Date:To:From:Subject:From;
	b=sPMJ2p64f6dS9MnRu6Cgf2cq0B0orTpW8uRzmqGwI+cptI9D5SXB1grIGEpFRrNk6
	 5uycsHmi6qmXZBQpRuN6lVOmxoK4iJc6XPQ1wnsBorkO0YtmqxHXEVaPXSX7O9cNh0
	 c3MlDDMhqk/6xUflkWaChtfaB5WW9O9x+OjXlXqE=
Date: Mon, 13 Jan 2025 22:42:09 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] slab-allocate-frozen-pages.patch removed from -mm tree
Message-Id: <20250114064210.6F51CC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: slab: allocate frozen pages
has been removed from the -mm tree.  Its filename was
     slab-allocate-frozen-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: slab: allocate frozen pages
Date: Mon, 25 Nov 2024 21:01:47 +0000

Since slab does not use the page refcount, it can allocate and free frozen
pages, saving one atomic operation per free.

Link: https://lkml.kernel.org/r/20241125210149.2976098-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slub.c~slab-allocate-frozen-pages
+++ a/mm/slub.c
@@ -2420,9 +2420,9 @@ static inline struct slab *alloc_slab_pa
 	unsigned int order = oo_order(oo);
 
 	if (node == NUMA_NO_NODE)
-		folio = (struct folio *)alloc_pages(flags, order);
+		folio = (struct folio *)alloc_frozen_pages(flags, order);
 	else
-		folio = (struct folio *)__alloc_pages_node(node, flags, order);
+		folio = (struct folio *)__alloc_frozen_pages(flags, order, node, NULL);
 
 	if (!folio)
 		return NULL;
@@ -2656,7 +2656,7 @@ static void __free_slab(struct kmem_cach
 	__folio_clear_slab(folio);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
-	__free_pages(&folio->page, order);
+	free_frozen_pages(&folio->page, order);
 }
 
 static void rcu_free_slab(struct rcu_head *h)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

