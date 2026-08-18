Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DAE3DA5B6
	for <mm-commits@vger.kernel.org>; Tue, 18 Aug 2026 18:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076090; cv=none; b=mEQjDzlOSSJQzGBTA7R9a+Fu1GKAPzoQJxVOORw5JDbgPIVcPdChUCmmICRYCoUxQrGeat+EmQAGQzQJPKdoAluGOV3GFLYiMnKc01S5SXgVteoL1wPxR63QeDVherd6cBSKLLDBLejYQJmi2Cg91QT96VdZeOCGoRzUiJzNpek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076090; c=relaxed/simple;
	bh=aPk5R8k7WQsrDjqhp7UHVKQPEXRDUzY4Fs43PFXlFEA=;
	h=Date:To:From:Subject:Message-Id; b=YLW8YbyEvkdzB+K9RsrzjzAaM6QsZBQMasKpBvPWvSOC40EN4M4Je2NfRJN1Dt99js9PSfiucUxlzmvsn+dtUAyN1xnFAQMPGVUBm6skaJ1r7oHIkHyckAMepxahRvv9IDSEW7qHJXpkSQvX2bnspf2NOadx+0JsgtKEsHw0jRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AJJzzYrd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJJzzYrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E729B1F000E9;
	Tue, 18 Aug 2026 18:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787076089;
	bh=sneldPVd8OjEBZlug7xFaUaBAJkk+eajGTw2CsdRp9Y=;
	h=Date:To:From:Subject;
	b=AJJzzYrdrmJhZsqtJvjyGofdmM5lBZgOmiA1UrnjjIIkx/OaOMoIb0LSir/3dpF/Q
	 S56DZKae2+s46osBvfZyp9D/EpiJcRclG7hpr2YJMQ9femnMzVDQ0ygzqVtKwuFXXJ
	 IVOTbbXEvpKAx5dxf0U9aVXwD1VtkAnZ5CAoBjBo=
Date: Tue, 18 Aug 2026 11:01:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,audra@redhat.com,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-release-the-css-reference-when-a-stock-slot-empties.patch added to mm-unstable branch
Message-Id: <20260818180128.E729B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: release the css reference when a stock slot empties
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-release-the-css-reference-when-a-stock-slot-empties.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-release-the-css-reference-when-a-stock-slot-empties.patch

This patch will later appear in the mm-unstable branch at
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
Cc: Audra Mitchell <audra@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
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

docs-mm-fix-outdated-radix-tree-in-page_migration.patch
mm-memcg-release-the-css-reference-when-a-stock-slot-empties.patch

