Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7BC14830F
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011001; cv=none; b=AgCMJH6lEdFyk//u87K83MtEcpTD7dt+S+gceBQM2BRV4ocfGqDnKG+iaj7jA1mEXDJpHZzBlW8jeRudZAxjKTCgxOVKPQu/IlB0F0Ze+n9GB0EKEH7le/53lM3awHgDuLa22t8cl4oOOhZw2eZB9nYiSmgmz1WHwC5cwJz+P0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011001; c=relaxed/simple;
	bh=Clh91WekQCAfAoy1ij88Y9LZu5XCLK1lqOOWPxZ1BhQ=;
	h=Date:To:From:Subject:Message-Id; b=c9lGwTn52+m858WFRqljtbGjQLEUuP8W0w/jd7AcdQARrbnRmAva08n9k7Ix4QpzXSVZh4/pDeg/yQ1XrJQjmR8RvvQ8G0dYYR34PIpS7LG+VQp6PPiZ9fnERGL4Ac9kGj5fh7FsnRE0B6OVdJ2mxlomA/ZT5N1yJGTOCVnQfH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JltEXZU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JltEXZU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DAEC4CEE4;
	Mon, 12 May 2025 00:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011001;
	bh=Clh91WekQCAfAoy1ij88Y9LZu5XCLK1lqOOWPxZ1BhQ=;
	h=Date:To:From:Subject:From;
	b=JltEXZU5UhN4SPpb29JXWmaJmaRFOJAAH96EjFakL5z+6TG/m9HY3J/oulVdfHyvr
	 GrwjSbl7hCYNJPnOh32oVlNjGQtCTPBKDY0/wVxFtr5j4BWCZaDyqHaC/pw9f2PzgB
	 91bXU7sgxBsaliApD1Shd7Ol0ZtOl6wfTIB7LAEs=
Date: Sun, 11 May 2025 17:50:00 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,riel@surriel.com,muchun.song@linux.dev,hannes@cmpxchg.org,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-oom-do-not-bypass-oom-killer-for-dying-tasks.patch removed from -mm tree
Message-Id: <20250512005001.29DAEC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg, oom: do not bypass oom killer for dying tasks
has been removed from the -mm tree.  Its filename was
     memcg-oom-do-not-bypass-oom-killer-for-dying-tasks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Rientjes <rientjes@google.com>
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


