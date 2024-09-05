Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A1318EFF8
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 23:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725577490; cv=none; b=uGKZy+81T8qjCyPT1wX3SjOhbX6MzuMxH3Hj76/d2b6JpxIog2N1GQ/ogRDlxOd2Pa09tKlZJ3EKWbK22zDavWHZri+veUyq7RAxhSi3JdQSc3NnMCfY5BprIaGNBWQO+IvfI8cSRhOW7OrEwWuUqTEn7VIQWPRYwGsbdbqUbn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725577490; c=relaxed/simple;
	bh=tovqW4HkgmGgWj0vdTpABAdBksQrY6fPujfPkjJav6M=;
	h=Date:To:From:Subject:Message-Id; b=jzm6/UDpetDGwBMwquFJce9F/dNeSrW5QZZ2mOlVHe7AJRyauHn6fWZ+Vo3I2SyxnjF9tMuMo9CFCA1cQOXOkjfavrKbZcLKoJQcoc92eHq7vnqNAL0VIO99S9ry15ZesT+ulUADQPraO6LQhyumUQcsuBs8qqKKl7mYY4kBkeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pGgD7nBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pGgD7nBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B772BC4CEC3;
	Thu,  5 Sep 2024 23:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725577489;
	bh=tovqW4HkgmGgWj0vdTpABAdBksQrY6fPujfPkjJav6M=;
	h=Date:To:From:Subject:From;
	b=pGgD7nBJ3YWGBGzDm8FckihHlhDwsJo3c6tosaq2S7pAyMYROpSnazJbAIr9AoJgU
	 JbsMSoxdvulrWL7khwZfPLVZGA1UJj6JNKvZ0T7bsr3G276xhZU5qIhYT33wpODfsU
	 MeDjcAQAUjBoL+Ffaig7p0TG7rxTVGi/Mj1SR4ng=
Date: Thu, 05 Sep 2024 16:04:49 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hughd@google.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-hold-css-refcnt-during-traversal.patch added to mm-unstable branch
Message-Id: <20240905230449.B772BC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't hold css->refcnt during traversal
has been added to the -mm mm-unstable branch.  Its filename is
     mm-dont-hold-css-refcnt-during-traversal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-hold-css-refcnt-during-traversal.patch

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
From: Kinsey Ho <kinseyho@google.com>
Subject: mm: don't hold css->refcnt during traversal
Date: Thu, 5 Sep 2024 00:30:51 +0000

To obtain the pointer to the next memcg position, mem_cgroup_iter()
currently holds css->refcnt during memcg traversal only to put css->refcnt
at the end of the routine.  This isn't necessary as an rcu_read_lock is
already held throughout the function.  The use of the RCU read lock with
css_next_descendant_pre() guarantees that sibling linkage is safe without
holding a ref on the passed-in @css.

Remove css->refcnt usage during traversal by leveraging RCU.

Link: https://lkml.kernel.org/r/20240905003058.1859929-3-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/mm/memcontrol.c~mm-dont-hold-css-refcnt-during-traversal
+++ a/mm/memcontrol.c
@@ -1015,20 +1015,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		else if (reclaim->generation != iter->generation)
 			goto out_unlock;
 
-		while (1) {
-			pos = READ_ONCE(iter->position);
-			if (!pos || css_tryget(&pos->css))
-				break;
-			/*
-			 * css reference reached zero, so iter->position will
-			 * be cleared by ->css_released. However, we should not
-			 * rely on this happening soon, because ->css_released
-			 * is called from a work queue, and by busy-waiting we
-			 * might block it. So we clear iter->position right
-			 * away.
-			 */
-			(void)cmpxchg(&iter->position, pos, NULL);
-		}
+		pos = READ_ONCE(iter->position);
 	} else if (prev) {
 		pos = prev;
 	}
@@ -1069,9 +1056,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		 */
 		(void)cmpxchg(&iter->position, pos, memcg);
 
-		if (pos)
-			css_put(&pos->css);
-
 		if (!memcg)
 			iter->generation++;
 	}
_

Patches currently in -mm which might be from kinseyho@google.com are

cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch
mm-dont-hold-css-refcnt-during-traversal.patch
mm-increment-gen-before-restarting-traversal.patch
mm-restart-if-multiple-traversals-raced.patch
mm-clean-up-mem_cgroup_iter.patch

