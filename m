Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDDD62809
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 03:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788318007; cv=none; b=GCkvYQLvkw6ToT+qVmbrw6/HkWipXqV8JOl//zRKmxpzRIBcTjkUtwR6wG/+uR7M8hll6Pccpqk96ACkMzTiJEh7LkYe2jqvlvOHY0g0ZAKKOp3Kesb/zmlD2XVFUobF5x/PIdUoIbIdkJuugvFlYdYTunUkk0VhgjfaN1pMQ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788318007; c=relaxed/simple;
	bh=m4NW+I+Z/7oPSO8QiTZN8LH4g6Qmu8btm66IH64m5T0=;
	h=Date:To:From:Subject:Message-Id; b=jChzYlrvL3ZSZqQKf3k2quOYw5Ip7ll3nS5xgLfb+lpCVccZleBajX/Yd1ylow44H73y29Qr1VwuvMeAxs38Rx45/GNrJsoay9GeAcwe/LesGREbc37O+tfWC1MNaY6jq2XgBJhWL7viU5b0y7gTuCXLB0zi3OWfHjCj9tX6YiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=leHtAfCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="leHtAfCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE441F00A3A;
	Wed,  2 Sep 2026 03:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788318005;
	bh=TY/wP0kYgdEaBCo8R7RDTx19hK/7QNBYyPV0DY9ndRo=;
	h=Date:To:From:Subject;
	b=leHtAfCcPKg6LTs/8+w5m7P5pRf/7XRZ96+6YwMAQKsUz52KLolsMu/htJWB6KiEv
	 Umot00I9kG13sUpiOLeyqw5bKnBOG0jspic9IiH0eliw3vgB5P8HeE2qYXvfT5AiIY
	 Gs5Nk1IQ4sl5MKhbtX3A08zTm5y4LKPdVJIAw3fE=
Date: Tue, 01 Sep 2026 20:00:04 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch added to mm-new branch
Message-Id: <20260902030005.2AE441F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
Date: Wed, 2 Sep 2026 07:24:20 +0800

For reclamation, it makes sense to reclaim folios from tail to head, as
folios near the head are relatively hot.  However, when moving folios from
the oldest generation to the second-oldest generation, using the
tail-to-head order would effectively cause a cold/hot inversion.

Link: https://lore.kernel.org/20260901232421.40157-7-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail
+++ a/mm/vmscan.c
@@ -192,11 +192,27 @@ static inline void prefetchw_prev_lru_fo
 		prefetchw(&prev->flags);
 	}
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+	if (folio->lru.next != base) {
+		struct folio *next;
+
+		next = list_entry(folio->lru.next, struct folio, lru);
+		prefetchw(&next->flags);
+	}
+}
 #else
 static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		struct list_head *base)
 {
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+}
 #endif
 
 /*
@@ -3943,10 +3959,11 @@ static bool inc_min_seq(struct lruvec *l
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		struct list_head *pos = head->next;
 		long delta = 0;
 
-		while (!list_empty(head)) {
-			struct folio *folio = lru_to_folio(head);
+		while (pos != head) {
+			struct folio *folio = list_entry(pos, struct folio, lru);
 			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
@@ -3957,6 +3974,8 @@ static bool inc_min_seq(struct lruvec *l
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
+			prefetchw_next_lru_folio(folio, head);
+			pos = pos->next;
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			/*
 			 * If gen_increased is false, this is a promotion. Put folios
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch
mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch
mm-mglru-separate-folio-generation-update-from-lru-accounting.patch
mm-mglru-batch-update-lrugen-nr_pages-in-inc_min_seq.patch
mm-mglru-enhance-cold-hot-inversion-handling-in-inc_min_seq.patch
mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch
mm-mglru-make-lru-folio-prefetch-helper-an-inline-function.patch
mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch
mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch

