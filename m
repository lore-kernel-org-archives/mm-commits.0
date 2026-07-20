Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A1B3DB31F
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784588756; cv=none; b=TnhRY+YESMPdqz34B1cJ9OpgLi5isTxccaYXtLqBLODnFlsSIVtTnPqvTWqr8/d8ZMtvJfEJGh018WPywfzIV/doGw3EsZTwY2z8c9W1AupaKnLAVHUq3uj/tdFICqkTgv5ARd3CoNoBa6vE/WbuNRYmX7pbdgHXm/6z36+rX3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784588756; c=relaxed/simple;
	bh=E9LhdNds3asRTm3X+rvzioFdJCQMYmwUlsCVNky3KXU=;
	h=Date:To:From:Subject:Message-Id; b=UaypnGk8onG4qlXePIq/4fMZT+GnVY8qZdCfI01F6TPNbVOpkgqp97TVI4ygsgalqEeJurJPyGf0BTYwmGUGTElbDmv9kI7m0Oa+Chev1XJfCqR6fI6zszCz4+o/FDnP8TEriqAKJ8eP/R/8sNK9j7oxNZ2CN7Oy+Z3C+1LnH1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ykjLNU2P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ykjLNU2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ECC1F000E9;
	Mon, 20 Jul 2026 23:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784588754;
	bh=5Odp/2KGX/U4YY71f/jJZ6p1Cmojnl2550CtWo7LLqs=;
	h=Date:To:From:Subject;
	b=ykjLNU2PiOcghOFR4Z+1ILiuVqRRnaz7xS63+f0BaPklP8VcTA6pyd/uFbg7Vjw3J
	 o+w1g/7e+KSJ2CgIiDH8owmSDsNrixEjyxniF3bunkOCgEG8zsNdaMVp+P1Serjt+9
	 e8RJVkfczBxDPgRR2cEdSNJ7cgeIzZVkOMZ4unrM=
Date: Mon, 20 Jul 2026 16:05:54 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch added to mm-new branch
Message-Id: <20260720230554.A9ECC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: add a helper to identify file-backed executable folios
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: add a helper to identify file-backed executable folios
Date: Mon, 20 Jul 2026 19:12:01 +0800

Add a helper to identify file-backed executable folios to avoid duplicate
code.

No functional changes.

Link: https://lore.kernel.org/2ee74f9f98ac45a2f0db0ceb018e086bdb671d17.1784509721.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios
+++ a/mm/vmscan.c
@@ -268,6 +268,12 @@ static int sc_swappiness(struct scan_con
 }
 #endif
 
+static inline bool is_exec_file_folio(const struct folio *folio,
+		const vma_flags_t *vma_flags)
+{
+	return vma_flags_test(vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio);
+}
+
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
@@ -914,7 +920,7 @@ static enum folio_references folio_check
 		/*
 		 * Activate file-backed executable folios after first usage.
 		 */
-		if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio))
+		if (is_exec_file_folio(folio, &vma_flags))
 			return FOLIOREF_ACTIVATE;
 
 		return FOLIOREF_KEEP;
@@ -2117,7 +2123,7 @@ static void shrink_active_list(unsigned
 			 * IO, plus JVM can create lots of anon VM_EXEC folios,
 			 * so we ignore them here.
 			 */
-			if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio)) {
+			if (is_exec_file_folio(folio, &vma_flags)) {
 				nr_rotated += folio_nr_pages(folio);
 				list_add(&folio->lru, &l_active);
 				continue;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch
mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch
mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch
mm-mglru-promote-mapped-executable-folios-after-first-usage.patch

