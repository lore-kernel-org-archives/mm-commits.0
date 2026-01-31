Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A52F376479
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896440; cv=none; b=qMbsfNN7A213P9U2ZXuzp2u4Dw6XQB9ikTrmsTQxFoW60xSEf/2+ZfcSEJDGpoOdOobrWC9O/DZCAP8fTIiNMZ3ymeHibM8Z7nZLX3fPIvarXpjCOTBqGuwCl4+/WcUEM5sb0vnwSmbnvQM+UoRSubeQFU+MVlT8QEBRru5TdQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896440; c=relaxed/simple;
	bh=9cIahVcb3kPe5SKaDGHHXm759jCp135lH9/A5fTArNs=;
	h=Date:To:From:Subject:Message-Id; b=JDu2j+RJVvWcvdspI90neSZFP61ggXYr2uBoRdIWHwDD6N7mnnUuhG5ClVRPkfCitz+2sgVQRpVJa9NSuG1SmkPzT9tgSznJ48PRfE7RVCBREyKm/JbpV4KJn1uTME+1Q04Iw1mIgETj+w4H0A10qcz3635AadJtWMK069WKq4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=alxEScu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="alxEScu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAC5C4CEF1;
	Sat, 31 Jan 2026 21:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896439;
	bh=9cIahVcb3kPe5SKaDGHHXm759jCp135lH9/A5fTArNs=;
	h=Date:To:From:Subject:From;
	b=alxEScu3GTTJYoVhivrct5dO0TSvfR1PgMFDFlcSzfRMli8n7+wz/W1Z/Wi9yoN61
	 ENbv+Yrm6XpGpIdu0jbNA77pqA270Yz/S1dniQBXvyQd4gVXNcbwJ3Mdc7n6sfOvm0
	 Dx6LvLoGS9F5B76bZGlPXFKr8Vb+P7Els/CzbajI=
Date: Sat, 31 Jan 2026 13:53:59 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,marco.crivellari@suse.com,bigeasy@linutronix.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch removed from -mm tree
Message-Id: <20260131215359.BFAC5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch

This patch was dropped because it was folded into mm-add-wq_percpu-to-alloc_workqueue-users.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix
Date: Sat Jan 24 03:20:32 PM PST 2026

fix kmem_cache_init_late() properly, per Sebastian

Cc: Marco Crivellari <marco.crivellari@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix
+++ a/mm/slub.c
@@ -8542,11 +8542,9 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
-#ifndef CONFIG_SLUB_TINY
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
 				  0);
 	WARN_ON(!flushwq);
-#endif
 }
 
 struct kmem_cache *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

