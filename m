Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C3F241690
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768345006; cv=none; b=afSJVoRgMfucksbCJ11Z+zX3Ko8tRdkMjkJ3OcgDmpiKa71sFXPjqr7r2DK+7mHQtcvqb/64Wy5MZsd2diCI1Sj+fB/G1USF9l+Z/+UNma43k7nKvQQhoBkMk4i8V8k7TQqU9yBasNz2t16vWZ09ukWz8SMB8vq3e2JufbmGST0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768345006; c=relaxed/simple;
	bh=ay3WG2YSu96BMxLe6+/ACCgE9b/hefnQ0h2UwQ6bgDg=;
	h=Date:To:From:Subject:Message-Id; b=dFjGg+Y7A7lm4dOZRM7rjM0wwXidSythWjPPGVZSzPNZQSHRAsLii4Hd5rNUWXzrv12DCzWP6J7Mm93GNw0DvfIOkVtQ4oG8hosqkHWSAmY25Xwt+yyEJoEM7EHoBEczrNhPhWvRGzBIpsxNq1N5fQ6Qh05fVUqREGlXT5QYYic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xUlUAqgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xUlUAqgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D99C116C6;
	Tue, 13 Jan 2026 22:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768345006;
	bh=ay3WG2YSu96BMxLe6+/ACCgE9b/hefnQ0h2UwQ6bgDg=;
	h=Date:To:From:Subject:From;
	b=xUlUAqgiGbrhV7yETeBizvIbQgHpIENG7adY1cDKpm8rOAr9JT5f/k53t8HWHidE4
	 KGZHcHgnylbP3UYDE2VKF/YDTIVXy270+5BZUQJV5CvEV6Vpi35HO0sd2TtdoO3AlD
	 U5B2dOq7PLZ/i2/Ccg6OD3jUQTBfcuQqvurdzu4o=
Date: Tue, 13 Jan 2026 14:56:45 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jiangshanlai@gmail.com,hannes@cmpxchg.org,glider@google.com,frederic@kernel.org,elver@google.com,dvyukov@google.com,david@kernel.org,bigeasy@linutronix.de,marco.crivellari@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-use-of-system_wq-with-system_percpu_wq.patch added to mm-new branch
Message-Id: <20260113225646.28D99C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: replace use of system_wq with system_percpu_wq
has been added to the -mm mm-new branch.  Its filename is
     mm-replace-use-of-system_wq-with-system_percpu_wq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-use-of-system_wq-with-system_percpu_wq.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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

mm-replace-use-of-system_unbound_wq-with-system_dfl_wq.patch
mm-replace-use-of-system_wq-with-system_percpu_wq.patch
mm-add-wq_percpu-to-alloc_workqueue-users.patch

