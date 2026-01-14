Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665053B52FA
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 22:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768428310; cv=none; b=uX7TGJza4FxUE2XlKQEr5QKXEr77n/1mgwVw++tAk7fXSbmXgBWMtueZfAXamrUdkKBg5EKHGYB1cFdk9EdmVBPjDa8ldp6odzGjfmNHndglDrdxVh8HSXXZGJOW1pZuCeND8kTQt2KxegQFblWhxI7XaKbUss6VaKZot7aylgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768428310; c=relaxed/simple;
	bh=Mp9w0obwD8ro8x0UR3QW3k2NygBusZulsvpR5yxXuK0=;
	h=Date:To:From:Subject:Message-Id; b=bcBmHAEzvIbGLxIiLkPSxX0L0Jq1W+F7KNef4bvQ+ckoRWsWEgaYdU9I9VJrJthMZwiL/2lFfhjnTh0hZpuYdea0u7NCFyuS+I35uU7RFTTo6yhGJ1XlbPRYqy6faMn27SDVhiqILexrQcewHNJJYYt5Nfy2106pl2+r78nXoTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c7CR+1U8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c7CR+1U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9367C19421;
	Wed, 14 Jan 2026 22:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768428309;
	bh=Mp9w0obwD8ro8x0UR3QW3k2NygBusZulsvpR5yxXuK0=;
	h=Date:To:From:Subject:From;
	b=c7CR+1U8sO+egfHgorlNj9IwS8kZF2PVdkrisRCLWAl2Tb/ionRLp4ihlflW0wbpa
	 uE6nbPmUqOkaOLxE+bcM2IfU7k+NUzVmW9ZIAENg7oWhWCe2VqKi9ZlCajSSo0tW1W
	 bM1GVqTvvMVq7PRx/3NY097w1ByinKDw3bvGdrsk=
Date: Wed, 14 Jan 2026 14:05:08 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mkoutny@suse.com,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,longman@redhat.com,linux@rasmusvillemoes.dk,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-use-nodes_and-output-where-appropriate.patch added to mm-new branch
Message-Id: <20260114220509.B9367C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cgroup: use nodes_and() output where appropriate
has been added to the -mm mm-new branch.  Its filename is
     cgroup-use-nodes_and-output-where-appropriate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cgroup-use-nodes_and-output-where-appropriate.patch

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
From: Yury Norov <ynorov@nvidia.com>
Subject: cgroup: use nodes_and() output where appropriate
Date: Wed, 14 Jan 2026 12:22:15 -0500

Now that nodes_and() returns true if the result nodemask is not empty,
drop useless nodes_intersects() in guarantee_online_mems() and
nodes_empty() in update_nodemasks_hier(), which both are O(N).

Link: https://lkml.kernel.org/r/20260114172217.861204-4-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/cgroup/cpuset.c~cgroup-use-nodes_and-output-where-appropriate
+++ a/kernel/cgroup/cpuset.c
@@ -456,9 +456,8 @@ static void guarantee_active_cpus(struct
  */
 static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 {
-	while (!nodes_intersects(cs->effective_mems, node_states[N_MEMORY]))
+	while (!nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]))
 		cs = parent_cs(cs);
-	nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]);
 }
 
 /**
@@ -2862,13 +2861,13 @@ static void update_nodemasks_hier(struct
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
 		struct cpuset *parent = parent_cs(cp);
 
-		nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
+		bool has_mems = nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
 
 		/*
 		 * If it becomes empty, inherit the effective mask of the
 		 * parent, which is guaranteed to have some MEMs.
 		 */
-		if (is_in_v2_mode() && nodes_empty(*new_mems))
+		if (is_in_v2_mode() && !has_mems)
 			*new_mems = parent->effective_mems;
 
 		/* Skip the whole subtree if the nodemask remains the same. */
_

Patches currently in -mm which might be from ynorov@nvidia.com are

nodemask-propagate-boolean-for-nodes_andnot.patch
mm-use-nodes_and-return-value-to-simplify-client-code.patch
cgroup-use-nodes_and-output-where-appropriate.patch

