Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0001FC110
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 03:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788318009; cv=none; b=rs0YbYFryQEJdU/lexUjpex4QCN6OaUCsqE86Ew1g24eyX2xh8wVvaqQn/ho5TaPcw7thDQsmBmdx2hPG9oTMIbseweUnXA38UhBpBInrNq/M4WJT8NtPAhK7gb34+NPxUnUDjGD/QHc6s2HqlkVuKpEik7oOzeQYIa9BzbftD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788318009; c=relaxed/simple;
	bh=LZURQQ9frKH4+ivvCKRnOJAoiY87s0g7rXKYx9AoXao=;
	h=Date:To:From:Subject:Message-Id; b=OGtOlVhMG1CFAsCkMFz45rYF4fR7yJlqTxdAHnlvfirStAJTBY46MdFRKDiVf91Uq6yzVxENzBX6cENH88ucPPqj5mKcJy9njZWn/s5LD/e0jE/MSTvbdZEZrACN43NgvgHVHQqQC1rFw6+/AmZUWzwIkSe+1IbBp3s7FhMN2Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=By7X9KEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="By7X9KEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B001F000E9;
	Wed,  2 Sep 2026 03:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788318007;
	bh=/lLtj/8B1wMscpRpDwoSUK46zcRSyNknsKD7h/QBdkY=;
	h=Date:To:From:Subject;
	b=By7X9KELl+2dLVICSkb9spPii3FtaONY0/tVq5VgyN3oEpG+eJBGB+iBPYp5siNb0
	 cJJJgjxgkxUsjfraMzLJmXEHu0KG08I4NqOKPr+I65YfsySqE5CYTvti7ll21Xe7jW
	 I/FaM5bFcxGnoaD8VUC+M0rxY8LJlqk1Y3BoGWbw=
Date: Tue, 01 Sep 2026 20:00:06 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch added to mm-new branch
Message-Id: <20260902030007.54B001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: batch move folios to the second-oldest gen's LRU
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch

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
Subject: mm/mglru: batch move folios to the second-oldest gen's LRU
Date: Wed, 2 Sep 2026 07:24:21 +0800

Detect folios that need to move from the oldest generation to the
second-oldest generation, and batch-move them together.  This can
significantly reduce the sys time of inc_min_seq(), especially when the
other type is significantly behind the preferred type.

Assisted-by: gemini:gemini-3.6-flash
Link: https://lore.kernel.org/20260901232421.40157-8-baohua@kernel.org
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

 mm/vmscan.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru
+++ a/mm/vmscan.c
@@ -3936,6 +3936,19 @@ static void clear_mm_walk(void)
 		kfree(walk);
 }
 
+static inline void flush_lru_batch(struct list_head *head, struct list_head **batch_end,
+				   struct list_head *dst)
+{
+	LIST_HEAD(movable);
+
+	if (!*batch_end)
+		return;
+
+	list_cut_position(&movable, head, *batch_end);
+	list_splice_tail_init(&movable, dst);
+	*batch_end = NULL;
+}
+
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
@@ -3958,8 +3971,10 @@ static bool inc_min_seq(struct lruvec *l
 			lru_gen_is_active(lruvec, target_gen));
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		struct list_head *target_list = &lrugen->folios[target_gen][type][zone];
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
 		struct list_head *pos = head->next;
+		struct list_head *batch_end = NULL;
 		long delta = 0;
 
 		while (pos != head) {
@@ -3984,7 +3999,7 @@ static bool inc_min_seq(struct lruvec *l
 			 */
 			if (gen_increased) {
 				delta += nr_pages;
-				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+				batch_end = &folio->lru;
 
 				/* don't count the workingset being lazily promoted */
 				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
@@ -3994,11 +4009,14 @@ static bool inc_min_seq(struct lruvec *l
 						   lrugen->protected[hist][type][tier] + nr_pages);
 				}
 			} else {
+				flush_lru_batch(head, &batch_end, target_list);
 				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 			}
 			if (!--remaining)
 				break;
 		}
+		flush_lru_batch(head, &batch_end, target_list);
+
 		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
 			   lrugen->nr_pages[old_gen][type][zone] - delta);
 		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
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

