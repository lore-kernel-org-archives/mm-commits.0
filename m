Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93CF15853B
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622309; cv=none; b=Kd+OFCVfv1q5pXP0pZkSQhp39X8bHjOyhKU7vZngo2MLHiBB8yMUUUsS5+TVsob7VDe5QBUmGiuSCYMEfG1viSXOUkLNaqHRy09t08crbHH1wMmCMogpPhO1f9LRsWEXnfzkbqeAMj0k4iUcR0Rw8yFoFh9+ZffC2YLIqVYJ40Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622309; c=relaxed/simple;
	bh=D/Ivr/24QENJoK98oe9En0scDjfUK8LC9Ju405vKDDc=;
	h=Date:To:From:Subject:Message-Id; b=ecsZc1phfGa16sLf+zlG3vKxT9HqnSCLqHLrRmO8roRD/OsJ6G/QIbIlPOAHfT7IcgLNFzvHbrpObQ9nTRYJuYZXwatUUxgTLz3306QkrHwmSxTZTE+nhZjocoak6zVV2+kYkxfyvmeklqTra8BcmRHLRSujFXpHOkAgYvfmd/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l6X5Nq2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l6X5Nq2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB4E1F000E9;
	Tue, 25 Aug 2026 01:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622307;
	bh=5jDqg5k1StuT1Uu718TRuU0D9I/R3/4kItgl4/2aA9Q=;
	h=Date:To:From:Subject;
	b=l6X5Nq2dJe5wv21Ro+DMhH4dlfto4C2IggWMTYjYCvfg2Z+zw3nagbNT650ShSQd1
	 W+AyXdT4PzJWqaNd7FM3cIo9KZxcVMOepsIr8BlobxQEsy+Bhds9im73Nk8L+TSSd2
	 Z4kDSPh3NB81pF/tBzy6NQtVILvYpp2bPAgrtcNI=
Date: Mon, 24 Aug 2026 18:45:07 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch removed from -mm tree
Message-Id: <20260825014507.8BB4E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: add a helper to identify file-backed executable folios
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Barry Song <baohua@kernel.org>
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
@@ -2119,7 +2125,7 @@ static void shrink_active_list(unsigned
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

mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch

