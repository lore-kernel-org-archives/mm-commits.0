Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89C5155303
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664161; cv=none; b=LpZic2N6noX72cwfvzL5RHrjVFHISBM5Kp6VovFxOj8QNWKY3aWIIPqxk3ZlSJhRaFyU+jpK6Dk4v2F8qOUZls0nLUxJ/LEsj4g/DSAXcytQAnsjSWogSft+mIcHJo6dCaKzGiiPyaPloZja5zxmtZFHxuCyv0DTqrxa/kBrWVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664161; c=relaxed/simple;
	bh=3F40kkCBgsZDy3p8WTf2xQmhFre8fmL4hHFDzxv0lWY=;
	h=Date:To:From:Subject:Message-Id; b=X6cJ4mVNZQMFKp79YWIyq5gC+L78G0/mFfN9FAViw0Fr84es0cahpo1nHPiKiklSxyTwIXZODySFYbD3rZzQuBF9HOJGhkvxVFws7AS2RmyhRsDMoX7Y5adrqVMTrRO7vSQV9TI6FSSdz1hlAiRMfvhi8Tpexx5txJaUEdkN3pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YO/f3keY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YO/f3keY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68092C113CC;
	Thu,  2 May 2024 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714664161;
	bh=3F40kkCBgsZDy3p8WTf2xQmhFre8fmL4hHFDzxv0lWY=;
	h=Date:To:From:Subject:From;
	b=YO/f3keYkZgoeV4e304LZ3tNHtQwbqEHhjuEeQbvlELTgMeeeBnc+16d8GRlVNl9u
	 wOPoAqY8YLMWmGBe+bEHVAb+AWF+AaE76v+upMX3pLnXjGHwUh8HG9S7QIQnc4oPhI
	 Do6AOq0GCfKuIr543vUFzEXDjSYEvXr+X+OMWSgw=
Date: Thu, 02 May 2024 08:36:00 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-cleanup-__mod_memcg_lruvec_state.patch added to mm-unstable branch
Message-Id: <20240502153601.68092C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: cleanup __mod_memcg_lruvec_state
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-cleanup-__mod_memcg_lruvec_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-cleanup-__mod_memcg_lruvec_state.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: cleanup __mod_memcg_lruvec_state
Date: Wed, 1 May 2024 10:26:14 -0700

There are no memcg specific stats for NR_SHMEM_PMDMAPPED and
NR_FILE_PMDMAPPED.  Let's remove them.

Link: https://lkml.kernel.org/r/20240501172617.678560-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~memcg-cleanup-__mod_memcg_lruvec_state
+++ a/mm/memcontrol.c
@@ -1009,8 +1009,6 @@ static void __mod_memcg_lruvec_state(str
 		case NR_ANON_MAPPED:
 		case NR_FILE_MAPPED:
 		case NR_ANON_THPS:
-		case NR_SHMEM_PMDMAPPED:
-		case NR_FILE_PMDMAPPED:
 			WARN_ON_ONCE(!in_task());
 			break;
 		default:
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-simple-cleanup-of-stats-update-functions.patch
memcg-reduce-memory-size-of-mem_cgroup_events_index.patch
memcg-dynamically-allocate-lruvec_stats.patch
memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch
memcg-cleanup-__mod_memcg_lruvec_state.patch
mm-cleanup-workingset_nodes-in-workingset.patch
memcg-warn-for-unexpected-events-and-stats.patch
memcg-use-proper-type-for-mod_memcg_state.patch

