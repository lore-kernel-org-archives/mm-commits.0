Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F7641760
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803044; cv=none; b=MjzjaDYdX0dUdNJyHZBVPRLuusQtbtfEotUfDqmcbnzVX0mdw/sr4BIED9UfYaUG0ozvgxoTSJViBKBUtiYxqrEjz/PT0g1H1ey8j2tRYzx35gGioKkKMx3pYp7shmnJV2P00VyYs3jbpszgy7j5lW51vp4zHUgwTeTbo1oLBYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803044; c=relaxed/simple;
	bh=lo7I7kZ6xHlwCMhhEamU6Erxa/RuezJnlcQc30sj2FE=;
	h=Date:To:From:Subject:Message-Id; b=Z7JRTI+2xlEpZaQQQZ9PRCFKciJ4HcjOSAryeSqFLj/fkvhE3BnuLe8ru2djeSsiobRiIVcnXBQMBYi+02bhwkUaZP8/lRpuZkX5X8okPpRev/FdbA/vax3yIGYCZfPFauAVXG8OGb91XvpMRmppZ4jxuXdQ268wb4iR3hQTcLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WcLpcJWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WcLpcJWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6638C32782;
	Tue, 27 Aug 2024 23:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803043;
	bh=lo7I7kZ6xHlwCMhhEamU6Erxa/RuezJnlcQc30sj2FE=;
	h=Date:To:From:Subject:From;
	b=WcLpcJWlE1OVI6xpIpyVL4Mbfn5Zkdw7AmkDXNwC/c+I1PSJ3hNP/oZWj4uXzHHXS
	 hQBreNd8N9fdB8U5bNSEywPDAPP2P7bsTgtLU7Wx80E28Gm9hVwSgV3TZeKExBCTmh
	 o2yFp1i/8EWepP8QX4TE5R7HXvfsF3+XKVaD5reQ=
Date: Tue, 27 Aug 2024 16:57:23 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-hold-css-refcnt-during-traversal.patch added to mm-unstable branch
Message-Id: <20240827235723.A6638C32782@smtp.kernel.org>
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
Date: Tue, 27 Aug 2024 23:07:39 +0000

To obtain the pointer to the next memcg position, mem_cgroup_iter()
currently holds css->refcnt during memcg traversal only to put css->refcnt
at the end of the routine.  This isn't necessary as an rcu_read_lock is
already held throughout the function.  The use of the RCU read lock with
css_next_descendant_pre() guarantees that sibling linkage is safe without
holding a ref on the passed-in @css.

Remove css->refcnt usage during traversal by leveraging RCU.

Link: https://lkml.kernel.org/r/20240827230753.2073580-3-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/mm/memcontrol.c~mm-dont-hold-css-refcnt-during-traversal
+++ a/mm/memcontrol.c
@@ -1013,20 +1013,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
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
@@ -1067,9 +1054,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
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

