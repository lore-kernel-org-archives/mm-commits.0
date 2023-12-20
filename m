Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88424CE17
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NgUcn+T+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23882C433CA;
	Wed, 20 Dec 2023 22:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112564;
	bh=xdI/Ax1Lc2Z/ykb4UcQlMx7krZZnqQynowvQfBmw9CA=;
	h=Date:To:From:Subject:From;
	b=NgUcn+T+FPlflP3tACEYuJOpZwNj6kHSHPZNCDEj3DVhok8sDPlh53A+y5NNpqFbw
	 R/LJ+XsQs6OoQhs7DpYSzeUnvLCmA6HygLX1CGfDunxSjIj9h5jOQ3hIRHQPya+YkE
	 8AlaEs1e9/9D61ROD0P55aqB3dFp3YOr9lmuLHU0=
Date: Wed, 20 Dec 2023 14:49:23 -0800
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@ucw.cz,david@redhat.com,aarcange@redhat.com,haokexin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-remove-unnecessary-try_to_freeze.patch removed from -mm tree
Message-Id: <20231220224924.23882C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ksm: remove unnecessary try_to_freeze()
has been removed from the -mm tree.  Its filename was
     mm-ksm-remove-unnecessary-try_to_freeze.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: mm: ksm: remove unnecessary try_to_freeze()
Date: Wed, 13 Dec 2023 17:09:06 +0800

A freezable kernel thread can enter frozen state during freezing by
either calling try_to_freeze() or using wait_event_freezable() and its
variants. However, there is no need to use both methods simultaneously.

Link: https://lkml.kernel.org/r/20231213090906.1070985-1-haokexin@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-remove-unnecessary-try_to_freeze
+++ a/mm/ksm.c
@@ -2604,11 +2604,9 @@ static int ksm_scan_thread(void *nothing
 			ksm_do_scan(ksm_thread_pages_to_scan);
 		mutex_unlock(&ksm_thread_mutex);
 
-		try_to_freeze();
-
 		if (ksmd_should_run()) {
 			sleep_ms = READ_ONCE(ksm_thread_sleep_millisecs);
-			wait_event_interruptible_timeout(ksm_iter_wait,
+			wait_event_freezable_timeout(ksm_iter_wait,
 				sleep_ms != READ_ONCE(ksm_thread_sleep_millisecs),
 				msecs_to_jiffies(sleep_ms));
 		} else {
_

Patches currently in -mm which might be from haokexin@gmail.com are

mm-khugepaged-remove-redundant-try_to_freeze.patch
fork-remove-redundant-task_uninterruptible.patch
nilfs2-add-missing-set_freezable-for-freezable-kthread.patch

