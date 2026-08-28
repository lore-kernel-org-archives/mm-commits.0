Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B711684B0
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 03:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787888612; cv=none; b=rsZHJqqviH8toAfaXS6KIYOD7QEzw0/nic+CyVg6BQQ7sEnTpdthGKsUIsYhU4s7LpqITVuA9oCrGkC2RnrUwnrWy9Qsgr1j2uffwm2sMEUna6ySVBPRrIsSFxoLtIYYTcotbV9AqDqsQIiJqGCL1RMp1ZoKYEDVYfJnmVCNxgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787888612; c=relaxed/simple;
	bh=lDgXaQwlPczc9SPAnJhEbEXMzJkCmQPuECnwkaU/AGQ=;
	h=Date:To:From:Subject:Message-Id; b=KNz90u6SUY6Ddial8iEPyUlo5GyZVysxyi0kCFCHq0F0k3qx89OAib0eyitKdwqyUco0iQdyuCoOQZ2BTYTFtO4+d7T+GychxbCnNW46MI3rosLBqb9BStuBS/GPOnLqAmARbQqhs3pj2sYE69fwemFlN+9VZ7y8f+Ox1beJnNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oUmeAEh0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oUmeAEh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DE11F000E9;
	Fri, 28 Aug 2026 03:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787888610;
	bh=liqYt4XKzX0UNN+Dik2MUlI8UXhZk7ArDnHqduEmdNo=;
	h=Date:To:From:Subject;
	b=oUmeAEh0VHHhjX8HzJnAX5ILezzLt7rw4bf6r8RHTOGdjQBeJv/XxvSm0kIkUSUmW
	 otp4HWKQzb3V8tzQJ2qXuvocu1HAJ5IiTy64m6bp9da3KQoTIve+hcFzaiDnnZBqWN
	 fOcIgrOnzYGnui5tnaJYMamGRtX8BWbAFtHFTo88=
Date: Thu, 27 Aug 2026 20:43:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,mhocko@suse.com,gourry@gourry.net,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch added to mm-new branch
Message-Id: <20260828034330.53DE11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: remove unused memcg parameter in calculate_high_delay()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/memcontrol: remove unused memcg parameter in calculate_high_delay()
Date: Tue, 25 Aug 2026 20:01:53 +0800

The memcg argument of calculate_high_delay() is never referenced in its
function body.  The delay calculation only depends on nr_pages and
max_overage, and both callers have already obtained max_overage from the
same memcg.

Drop this unused parameter and update the two call sites inside
__mem_cgroup_handle_over_high().

Link: https://lore.kernel.org/20260825120153.1405-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay
+++ a/mm/memcontrol.c
@@ -2515,8 +2515,7 @@ static u64 swap_find_max_overage(struct
  * Get the number of jiffies that we should penalise a mischievous cgroup which
  * is exceeding its memory.high by checking both it and its ancestors.
  */
-static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
-					  unsigned int nr_pages,
+static unsigned long calculate_high_delay(unsigned int nr_pages,
 					  u64 max_overage)
 {
 	unsigned long penalty_jiffies;
@@ -2594,10 +2593,10 @@ retry_reclaim:
 	 * memory.high is breached and reclaim is unable to keep up. Throttle
 	 * allocators proactively to slow down excessive growth.
 	 */
-	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
+	penalty_jiffies = calculate_high_delay(nr_pages,
 					       mem_find_max_overage(memcg));
 
-	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
+	penalty_jiffies += calculate_high_delay(nr_pages,
 						swap_find_max_overage(memcg));
 
 	/*
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch
mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch

