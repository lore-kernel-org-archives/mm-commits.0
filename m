Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E0437998A
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622957; cv=none; b=pel0hreRRhZi7zVOfpoBtZYGVWjqKsQvqYbg6bTSMhqSL4IL4bYLJmcp/ouwHixddBOMQKLnPJQxxsENKsMN+OOcBvNN/5bREiSOkbaQmyfB5Zlacx2IBr9/PkGZCO9+pl2QitZ17dt/VYdyLMWMXqZNv7svpExWCxoEasNxhxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622957; c=relaxed/simple;
	bh=quAtvGp1ZF3q7LleQ534xAVJdVKG7iqAeLI9UemT1Wg=;
	h=Date:To:From:Subject:Message-Id; b=psZGTMvWgYNQywdue4p9tYb2OE+MVpqBlqlZiACq3aPqrCVAAbX//FVrGLlnSE9b6heQxqMmWiHhpx7irurZA3MH9g+Jsz4ZqKpy0zL20NFUCtx1Ha/KImKU9Q+WwfMjHaIbv/IvJJ92zQqy1E4Nb3ArCJhN0mYiIVHzvJ30JLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OdE5s8im; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OdE5s8im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAE91F00A3A;
	Tue, 25 Aug 2026 01:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622956;
	bh=I8CPbvjy18I0WGk4osK1ZSICPd2XBppJgLOI4PYyjP8=;
	h=Date:To:From:Subject;
	b=OdE5s8imc7wQxMt5WUQM10uBAz3HZf563tvECMI45npMrEDgf88Mwot8hKZi0+Nnq
	 dV12EYCEqi6zF0LODo/v83/9ZHJZTLFd0nH189gfLgUEIweiC7C4k1zxOTkkxSVyne
	 NdtD2dyyS5hOHK7MeT+zS2Mjj8F/M0nV0n+faWgY=
Date: Mon, 24 Aug 2026 18:55:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,audra@redhat.com,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-release-the-css-reference-when-a-stock-slot-empties.patch removed from -mm tree
Message-Id: <20260825015556.7BAE91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: release the css reference when a stock slot empties
has been removed from the -mm tree.  Its filename was
     mm-memcg-release-the-css-reference-when-a-stock-slot-empties.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: mm: memcg: release the css reference when a stock slot empties
Date: Tue, 18 Aug 2026 21:01:35 +0800

consume_stock() can drive a stock slot's nr_pages to zero while its
cached[] pointer stays set, so the slot keeps pinning the css reference
that refill_stock() took.  The offlining drain only flushes slots with
cached pages, so the reference is never released unless the slot happens
to be displaced by an unrelated charge or by CPU hotplug, and the memcg
lingers in the dying state - up to NR_MEMCG_STOCK (7) of them per CPU
under container churn.

Keeping the slot populated past the last page only saves a
css_get()/css_put() pair on the next charge of the same memcg, and costs
more than that: the offlining drain has to know about empty slots, and
refill_stock() cannot reuse them either, so a charge under a different
memcg evicts a live batch through the drain_idx rotation instead.

Drop the reference in consume_stock() when the slot empties.  Empty slots
stop existing, so is_memcg_drain_needed() and the drain path stay as they
are, and refill_stock() reuses emptied slots directly.  The cost is one
refcount pair per emptied slot, at most once per MEMCG_CHARGE_BATCH pages.

Link: https://lore.kernel.org/20260818130135.154315-1-husong@kylinos.cn
Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
Signed-off-by: Song Hu <husong@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Audra Mitchell <audra@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-release-the-css-reference-when-a-stock-slot-empties
+++ a/mm/memcontrol.c
@@ -2140,7 +2140,12 @@ static bool consume_stock(struct mem_cgr
 
 		stock_pages = READ_ONCE(stock->nr_pages[i]);
 		if (stock_pages >= nr_pages) {
-			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
+			stock_pages -= nr_pages;
+			WRITE_ONCE(stock->nr_pages[i], stock_pages);
+			if (!stock_pages) {
+				css_put(&memcg->css);
+				WRITE_ONCE(stock->cached[i], NULL);
+			}
 			ret = true;
 		}
 		break;
_

Patches currently in -mm which might be from husong@kylinos.cn are


