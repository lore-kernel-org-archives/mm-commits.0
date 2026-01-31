Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1661376479
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896438; cv=none; b=JqyJCVvasrwS4rdYf3GhpjdhcaukLTQVI6G5I51iR0787l77NwWOoL6c1JOhIMZME6xmyQg7vSqY0EmjIaBpcyMFB6fTZj3FD52pi5OtlkqiNUaFxm0/Vlf18YKm0hoa6Fbl9uU59E6/15etwJXw6sGClYtURWu8gmIH65+XwVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896438; c=relaxed/simple;
	bh=5Bo01pyFn13r8KytcXWBDbBAK6Ly9XvQTUxNigrWrkg=;
	h=Date:To:From:Subject:Message-Id; b=m0l8WAVc+MKkUNhBnhgajEBgTJ3JINsovrGKlmksTwGGk59yGuubF+rlvZ1WJ0vOyixMEUczeiL4XEIOgAcTwuItrol/hz616bc1Odhm9FUL8gl+IO5vNyJw/MAp6iBuqhlDe+Lvpmu3+szG5pqYm+PN6wFI9OfxsXn9L/hioJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ci7FRrbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ci7FRrbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BEAC19421;
	Sat, 31 Jan 2026 21:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896438;
	bh=5Bo01pyFn13r8KytcXWBDbBAK6Ly9XvQTUxNigrWrkg=;
	h=Date:To:From:Subject:From;
	b=Ci7FRrbb0BgRYuvsPbMt55g7xk6A8QiYhhMA0tagqNix4zSC0DDu7mZqr+NKAdEPa
	 Cn0vMk2mll6REEpFje53gHDSsUjYXPLy1WOP0eaBjTADh6736TZBk8f2WEWYciG5Jg
	 lceYkpko3tQXnHhKiESUNWfEXgvNp0yDeeHbhg4s=
Date: Sat, 31 Jan 2026 13:53:56 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,marco.crivellari@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jiangshanlai@gmail.com,hannes@cmpxchg.org,glider@google.com,frederic@kernel.org,elver@google.com,dvyukov@google.com,david@kernel.org,bigeasy@linutronix.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch removed from -mm tree
Message-Id: <20260131215358.49BEAC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix
has been removed from the -mm tree.  Its filename was
     mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch

This patch was dropped because it was folded into mm-add-wq_percpu-to-alloc_workqueue-users.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix
Date: Tue Jan 13 05:59:13 PM PST 2026

fix mm/slub.c

Cc: Marco Crivellari <marco.crivellari@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users-fix
+++ a/mm/slub.c
@@ -8546,6 +8546,7 @@ void __init kmem_cache_init_late(void)
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
 				  0);
 	WARN_ON(!flushwq);
+#endif
 }
 
 struct kmem_cache *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

