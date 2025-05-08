Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F461FC8
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 01:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746667759; cv=none; b=Iu7W8IKW99JkDXHwMvMiv4myh6fAQ8h779ItathgN9bNGPShUlD6S9LOD9BBzKNyOoT+cx9Uoh2mkpUsl/0k6vi4njf6DsVb+gs1tn8Bt1JED3p2vRd8BszNP7ZyyvpUACNQN5ilNVU+mXnY5cqf2Xx7f6av/b5zfLJEZNpZ4OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746667759; c=relaxed/simple;
	bh=cq8BizsjYjj3RT6r3a3ACXCqe5fLhaRsCMMWz964YdY=;
	h=Date:To:From:Subject:Message-Id; b=C9mZhw+z9TzbQP3IR8rRkhrM/Dkiuks93GSM/xLmkPcjlYaosvzEWOTw/I+1e71MIcZDI1qrw61s+BLsClw7myN7eHWfvQmb+wgoOp+QNNi4CgXvTf9+das2c6Peu8jivp6grD/4KvTDDYiOCEHfHUCxHldpzDzW2LcHfsJGdIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJxYE8HR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJxYE8HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7945CC4CEE2;
	Thu,  8 May 2025 01:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746667758;
	bh=cq8BizsjYjj3RT6r3a3ACXCqe5fLhaRsCMMWz964YdY=;
	h=Date:To:From:Subject:From;
	b=WJxYE8HRwosCKQAiO0pLb/pbisMzqVOS9oWPy3ADKpqtFcP1oLCkq6KqwobUk1wIt
	 /5yYOD/Rke9K+IJI5JKaEsbC3FdGuaHO9PpRFeqLwCUOC4fw2eqUk3rbfyJRd2qwI3
	 BOSF1uz1/Sk+jYIgCl1C6SGvPYW/ZHhVH+rI/Fpc=
Date: Wed, 07 May 2025 18:29:17 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hezhongkun.hzk@bytedance.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch added to mm-unstable branch
Message-Id: <20250508012918.7945CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix
Date: Wed May  7 06:27:25 PM PDT 2025

tweak coding style

Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix
+++ a/mm/vmscan.c
@@ -5606,9 +5606,9 @@ static ssize_t lru_gen_seq_write(struct
 			break;
 		}
 
-		if (n == 4)
+		if (n == 4) {
 			swappiness = -1;
-		else if (!strcmp("max", swap_string)) {
+		} else if (!strcmp("max", swap_string)) {
 			/* set by userspace for anonymous memory only */
 			swappiness = SWAPPINESS_ANON_ONLY;
 		} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-config_page_block_order-to-select-page-block-order-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

