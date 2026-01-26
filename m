Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34072D8799
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460867; cv=none; b=MUPnh7HzhtLCs1cpgtl6b4+lYyLB2qtT9C6Sj1ayjZoyUcdqP6uJO4eUIjBbbBRNNR/cL46i6PxhID/5SmTBCUgo5ud2lPPgPsZwzmuIZsESA8taGL+Rq2aNefxdkQMEJUXlXLWSiRLpz144WNQOb0VEabB7e1jsaSsMM8B/bNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460867; c=relaxed/simple;
	bh=FVla9CEzVk9QzPVDb5dNoURHESP+ZVXB3lDnZBn58N4=;
	h=Date:To:From:Subject:Message-Id; b=OgFdS+a6VsVcsj1kWZi40mIJ9wisDlFztHcMkg6S34SE5Z5DpbOTn8z18eRynWpW+raa8IzYrxFMj5+rIFVDnc89ut3VQIbegDJLzucYXhc3ztEIM2N6O3t29+z7JeAwbqdWOqCyg2H0PPH21zHJHp1MJjILI/axTTRj/CW6Pl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HC1R6ANE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HC1R6ANE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC52C116C6;
	Mon, 26 Jan 2026 20:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769460867;
	bh=FVla9CEzVk9QzPVDb5dNoURHESP+ZVXB3lDnZBn58N4=;
	h=Date:To:From:Subject:From;
	b=HC1R6ANEn7BTRteXwiwGlMT8tpl4LzzZ45y4+GymZyN8lTQo0QLcqt2h45XGI/tuJ
	 xF6pi5t1M20Q+cQrgE8Mwz7NrRcoChfj4BD+Gzoyg+PWN5DaNDppKwa2o1IyzQwyu3
	 TSS+jYGNpAh6xSsH1f7kFd2ODON4BqtlZwveGoJ4=
Date: Mon, 26 Jan 2026 12:54:26 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + netclassid-use-thread_group_leaderp-in-update_classid_task.patch added to mm-nonmm-unstable branch
Message-Id: <20260126205427.5FC52C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: netclassid: use thread_group_leader(p) in update_classid_task()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     netclassid-use-thread_group_leaderp-in-update_classid_task.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/netclassid-use-thread_group_leaderp-in-update_classid_task.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: netclassid: use thread_group_leader(p) in update_classid_task()
Date: Sun, 25 Jan 2026 17:08:00 +0100

Cleanup and preparation to simplify planned future changes.

Link: https://lkml.kernel.org/r/aXY_4NSP094-Cf-2@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netclassid_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/netclassid_cgroup.c~netclassid-use-thread_group_leaderp-in-update_classid_task
+++ a/net/core/netclassid_cgroup.c
@@ -93,7 +93,7 @@ static void update_classid_task(struct t
 	/* Only update the leader task, when many threads in this task,
 	 * so it can avoid the useless traversal.
 	 */
-	if (p != p->group_leader)
+	if (!thread_group_leader(p))
 		return;
 
 	do {
_

Patches currently in -mm which might be from oleg@redhat.com are

android-binder-dont-abuse-current-group_leader.patch
android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch
drm-amdgpu-dont-abuse-current-group_leader.patch
drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch
drm-pan-dont-abuse-current-group_leader.patch
rdma-umem-dont-abuse-current-group_leader.patch
netclassid-use-thread_group_leaderp-in-update_classid_task.patch

