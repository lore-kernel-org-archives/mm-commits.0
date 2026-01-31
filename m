Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D8620CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898297; cv=none; b=AiFM9ZRqKUQVQX/hzM/bzeV6/aYkxlSt8JXQ0MQTiyPVZ4xzBCwAaXhvyfhD3eYjRKZn0CwWLuf2j6LxZSuv12/86tds0OOWXVSd5/lIQXQTliMhb3NcLnSq5qZM4QMYRrTimbz488baL0GQn9SYRyHSfu5hd2oxST1SmKxzwtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898297; c=relaxed/simple;
	bh=z/gX/62pYLkgmQ/7/3FS6d0GcQVyYa2jjC7WIipx3uQ=;
	h=Date:To:From:Subject:Message-Id; b=BjU97WpiTFb3i4lS/1PlJsq6mYy4iYVvkfP7AepHBf65kMq7KaVFk1jOnIyFxoESfKo2fwPZICxIeOB/qBhZtgLgOTuL8eUws+pArLuwjf7teLRcsYHTxiQ5Vhg7au5R9doZG02Ycb+b2zHwK1KoJj3Wl/QyWhn0qr4/MJw8mEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SaPITwyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SaPITwyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D39BC4CEF1;
	Sat, 31 Jan 2026 22:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898297;
	bh=z/gX/62pYLkgmQ/7/3FS6d0GcQVyYa2jjC7WIipx3uQ=;
	h=Date:To:From:Subject:From;
	b=SaPITwyhWv+EifHyTkIV9zjLGjiDlROeDd2WNpm1mlOFoMMeLK6CkzQBqd82SjBoe
	 HVOp66O0pIQE/NbiFyesA1N2yWsmLPbgbExP4FAu6eDBEb3R8cNyUE65P6K7IeHwCT
	 3cRBmTYdfQML8V2NT5O9TzRNxX1KI1fdlq+inFyM=
Date: Sat, 31 Jan 2026 14:24:56 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jiangshanlai@gmail.com,hannes@cmpxchg.org,glider@google.com,frederic@kernel.org,elver@google.com,dvyukov@google.com,david@kernel.org,bigeasy@linutronix.de,marco.crivellari@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-use-of-system_wq-with-system_percpu_wq.patch removed from -mm tree
Message-Id: <20260131222457.7D39BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: replace use of system_wq with system_percpu_wq
has been removed from the -mm tree.  Its filename was
     mm-replace-use-of-system_wq-with-system_percpu_wq.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Crivellari <marco.crivellari@suse.com>
Subject: mm: replace use of system_wq with system_percpu_wq
Date: Tue, 13 Jan 2026 12:46:29 +0100

This patch continues the effort to refactor workqueue APIs, which has
begun with the changes introducing new workqueues and a new
alloc_workqueue flag:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The point of the refactoring is to eventually alter the default behavior
of workqueues to become unbound by default so that their workload
placement is optimized by the scheduler.

Before that to happen, workqueue users must be converted to the better
named new workqueues with no intended behaviour changes:

   system_wq -> system_percpu_wq
   system_unbound_wq -> system_dfl_wq

This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
removed in the future.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Link: https://lkml.kernel.org/r/20260113114630.152942-3-marco.crivellari@suse.com
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/backing-dev.c~mm-replace-use-of-system_wq-with-system_percpu_wq
+++ a/mm/backing-dev.c
@@ -971,7 +971,7 @@ static int __init cgwb_init(void)
 {
 	/*
 	 * There can be many concurrent release work items overwhelming
-	 * system_wq.  Put them in a separate wq and limit concurrency.
+	 * system_percpu_wq.  Put them in a separate wq and limit concurrency.
 	 * There's no point in executing many of these in parallel.
 	 */
 	cgwb_release_wq = alloc_workqueue("cgwb_release", 0, 1);
_

Patches currently in -mm which might be from marco.crivellari@suse.com are


