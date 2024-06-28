Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85422ED8;
	Fri, 28 Jun 2024 00:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719533202; cv=none; b=bZwHzN+SQCTM9fP8TKOddKHt8mqid57/s7X+DMVZs5zaklBl54YlkTFJRQJkG05n8NcjLA7DjRvwvjedGN4sHQd5GTeq9aqq5UlMtVhjzMpZW78ySVCQWBdpMBpymIdw5pvLiCOFfY0UzGOj5XQ0ekm3JysuS7CAxdpvLyTJ+mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719533202; c=relaxed/simple;
	bh=6jdOp5YTjUw/QVCCo5K1+CU3ZqFVbxCeWAaGgr/1HjI=;
	h=Date:To:From:Subject:Message-Id; b=ahKXD9nufeO91cVKpQvMDz5nMUEe1tBeqCR72Mc9Al5SRjd2DEP9FNIJY5rIMKQeMup1Vmym1Hvy7TXFVcjo/1/R/cVxHnlIg/zljdLyN8+6BPLowtJV0dcskLB9DUy/K549cSzk8bWWW7+VqABQ13fcORQfSWX695/V9/Fg5ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OH5zvnNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OH5zvnNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01995C2BBFC;
	Fri, 28 Jun 2024 00:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719533202;
	bh=6jdOp5YTjUw/QVCCo5K1+CU3ZqFVbxCeWAaGgr/1HjI=;
	h=Date:To:From:Subject:From;
	b=OH5zvnNj+0IvY8jcCOZ37S/PsiIEN05O1y/5qrZgw1TBTYoIkmrXl37GkP0Y0O1lM
	 m0NxV4ulEx4N381anUdR+ozPnkhTno7RIEEmPHjypwL/0DLwm/tisPsUlDHNWx4N5K
	 JgD30uisTyTASzeG47Zofr2FxfEYPJoLWGGfe44w=
Date: Thu, 27 Jun 2024 17:06:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tandersen@netflix.com,stable@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,mhocko@suse.com,brauner@kernel.org,axboe@kernel.dk,alexjlzheng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-optimize-the-redundant-loop-of-mm_update_owner_next.patch removed from -mm tree
Message-Id: <20240628000642.01995C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize the redundant loop of mm_update_owner_next()
has been removed from the -mm tree.  Its filename was
     mm-optimize-the-redundant-loop-of-mm_update_owner_next.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinliang Zheng <alexjlzheng@tencent.com>
Subject: mm: optimize the redundant loop of mm_update_owner_next()
Date: Thu, 20 Jun 2024 20:21:24 +0800

When mm_update_owner_next() is racing with swapoff (try_to_unuse()) or
/proc or ptrace or page migration (get_task_mm()), it is impossible to
find an appropriate task_struct in the loop whose mm_struct is the same as
the target mm_struct.

If the above race condition is combined with the stress-ng-zombie and
stress-ng-dup tests, such a long loop can easily cause a Hard Lockup in
write_lock_irq() for tasklist_lock.

Recognize this situation in advance and exit early.

Link: https://lkml.kernel.org/r/20240620122123.3877432-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tycho Andersen <tandersen@netflix.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/exit.c~mm-optimize-the-redundant-loop-of-mm_update_owner_next
+++ a/kernel/exit.c
@@ -484,6 +484,8 @@ retry:
 	 * Search through everything else, we should not get here often.
 	 */
 	for_each_process(g) {
+		if (atomic_read(&mm->mm_users) <= 1)
+			break;
 		if (g->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(g, c) {
_

Patches currently in -mm which might be from alexjlzheng@tencent.com are


