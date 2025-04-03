Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA798828
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743647487; cv=none; b=ObZZrJheb3BOChndoxW5XAb3hIdMomezmg7zuQXdra+RFrscCyx734bBwzHXxaxGEQxKPFiWRq8aEH0eUXwVvjDN8YL11qx4N2kFomCGF5O/S31ViTyOnZVPJeaDk/jge+a3yQx3jlSN3mCVltQIwczLdQq4z+1yQb/V+n7yeaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743647487; c=relaxed/simple;
	bh=jJG1tVrLEe/zBHyLaq0I8Yl1hcsCw4CdJHnb7s70iY4=;
	h=Date:To:From:Subject:Message-Id; b=ILjyXQLTxZZw5MmnNF8f14WQX7gfkqbtzHh3IWu0NnPe5nDhqgsPG0Fcf/a6p+iyf6UUW/GvTMwZAsrxtLqxW1SkVHEc77C4d1/81DTw4WmdzOpzsaC4JsmB/hYSG0eavCSxHwb7dAbYKBppqM9VOdWDf2HdCDtKDqF4tymzjkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TDEqLb6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TDEqLb6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29BDC4CEDD;
	Thu,  3 Apr 2025 02:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743647487;
	bh=jJG1tVrLEe/zBHyLaq0I8Yl1hcsCw4CdJHnb7s70iY4=;
	h=Date:To:From:Subject:From;
	b=TDEqLb6H4nUPofPDhrT8nCR1O5B5qmWyorbmxMUnTW2lOQMkvrh6uRvs4PtT8OAZy
	 wy3ei9iyFPotS4FqDjfcYpOC6KCgEtpv7EIt4rv8+ysXBO0zx8+M1EFTJKgVQcTQDG
	 OlDwT6s9QdO21rf02FZqK/8ZlhnQhxH0pLN8t72c=
Date: Wed, 02 Apr 2025 19:31:25 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,hannes@cmpxchg.org,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-oom-do-not-bypass-oom-killer-for-dying-tasks.patch added to mm-new branch
Message-Id: <20250403023126.E29BDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg, oom: do not bypass oom killer for dying tasks
has been added to the -mm mm-new branch.  Its filename is
     memcg-oom-do-not-bypass-oom-killer-for-dying-tasks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-oom-do-not-bypass-oom-killer-for-dying-tasks.patch

This patch will later appear in the mm-new branch at
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
From: Michal Hocko <mhocko@suse.com>
Subject: memcg, oom: do not bypass oom killer for dying tasks
Date: Wed, 2 Apr 2025 11:01:17 +0200

7775face2079 ("memcg: killed threads should not invoke memcg OOM killer")
has added a bypass of the oom killer path for dying threads because a very
specific workload (described in the changelog) could hit "no killable
tasks" path.  This itself is not fatal condition but it could be annoying
if this was a common case.

On the other hand the bypass has some issues on its own.  Without
triggering oom killer we won't be able to trigger async oom reclaim
(oom_reaper) which can operate on killed tasks as well as long as they
still have their mm available.  This could be the case during futex
cleanup when the memory as pointed out by Johannes in [1].  The said case
is still not fully understood but let's drop this bypass that was mostly
driven by an artificial workload and allow dying tasks to go into oom
path.  This will make the code easier to reason about and also help corner
cases where oom_reaper could help to release memory.

Link: https://lore.kernel.org/all/20241212183012.GB1026@cmpxchg.org/T/#u [1]
Link: https://lkml.kernel.org/r/20250402090117.130245-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-oom-do-not-bypass-oom-killer-for-dying-tasks
+++ a/mm/memcontrol.c
@@ -1664,7 +1664,7 @@ static bool mem_cgroup_out_of_memory(str
 	 * A few threads which were not waiting at mutex_lock_killable() can
 	 * fail to bail out. Therefore, check again after holding oom_lock.
 	 */
-	ret = task_is_dying() || out_of_memory(&oc);
+	ret = out_of_memory(&oc);
 
 unlock:
 	mutex_unlock(&oom_lock);
_

Patches currently in -mm which might be from mhocko@suse.com are

memcg-oom-do-not-bypass-oom-killer-for-dying-tasks.patch

