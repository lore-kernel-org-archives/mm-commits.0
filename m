Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F92D315D51
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 03:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486147; cv=none; b=qB4eU6tR6+TwNOquIVD55zRszv5fNWR/ge+eJbpNpJ/xgphSMzq24KaCirWgQ0bpE0cOQGn9mOMvMQWa4cjR+muC/YVPPM07+3ZVPL7cIiJMZyzI0YFmk3Z0Eg4qu6fjI32HmVY/CMRr+InlG+UvUcp/m4j621XnWkkJ0ucQ6yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486147; c=relaxed/simple;
	bh=i2Wo+sJcC1b+bOvBtQkEyHWv9IdyP5PhGfaYWkVIwL8=;
	h=Date:To:From:Subject:Message-Id; b=hIN8Xa5EfpwRg/gC90Y3vXhCR55Tq3Y83jr6/8+po7ScPzuQ8IF6folS09whaZWOGUly1mFL6rS7jJBgcDhGxDfyyKfeI8cih7/qdGNiEUozYptHcSef79h2w+foA8gXia+aza5cKJy9IYC4lF11BHIpw5TrlWX4nyUf7W83Zb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tcLhvjuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tcLhvjuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98510C116C6;
	Tue, 27 Jan 2026 03:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486146;
	bh=i2Wo+sJcC1b+bOvBtQkEyHWv9IdyP5PhGfaYWkVIwL8=;
	h=Date:To:From:Subject:From;
	b=tcLhvjuwspdcgb81HYVxv9y7jpX24dPcg1bFmV/C25fGzvGD4yoJtKZHMfXyfoDcJ
	 QMMhQSK2AlrmGI59Jo1pMMdtGlmpKaZmkzS/Pv2q+hJVfrk7g7Kq2/ASTgJtO4fmJ/
	 12fs+RnO5jovBM1y3fmqSPcWCHsIId4ibohcInUk=
Date: Mon, 26 Jan 2026 19:55:46 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch removed from -mm tree
Message-Id: <20260127035546.98510C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-mem_cgroup_get_from_ino-returns-null-on-error-fix
has been removed from the -mm tree.  Its filename was
     memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch

This patch was dropped because it was folded into memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-mem_cgroup_get_from_ino-returns-null-on-error-fix
Date: Mon Jan 12 03:36:40 PM PST 2026

build fix

mm/memcontrol.c: In function 'mem_cgroup_get_from_id':
mm/memcontrol.c:3624:35: error: 'ino' undeclared (first use in this function); did you mean 'int'?
 3624 |         cgrp = cgroup_get_from_id(ino);
      |                                   ^~~
      |                                   int

Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix
+++ a/mm/memcontrol.c
@@ -3621,7 +3621,7 @@ struct mem_cgroup *mem_cgroup_get_from_i
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg = NULL;
 
-	cgrp = cgroup_get_from_id(ino);
+	cgrp = cgroup_get_from_id(id);
 	if (IS_ERR(cgrp))
 		return NULL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

