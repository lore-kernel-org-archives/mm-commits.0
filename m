Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574A931A81F
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486757; cv=none; b=rj3rF/6JmxTo/OxMqud+l6y4Ax2v8P7RxWQpaZHC2Jk28cf6LWeyte+aNaLbNuSLhHVxk93l8Czc3QiQxCHvlrAy8Tk0BQlNVszMN7kCvExD7kKLvFHvh9rptMBjuXmrYAZJOQZy7hCKHV6NBaK9r5FAIe4g1fveFJ9CZacFR4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486757; c=relaxed/simple;
	bh=Y5600A1kAeU3hpGUBpFUMa2hmxe7IsTb+ya5dWr5nBo=;
	h=Date:To:From:Subject:Message-Id; b=sqDSCcoFu/eKiim6fD7f7lQ4lVlo2iRXlX85BbU4XqSw3Ye0WQuA2suhFUuemKrfzYpU1lkGZ0Q6EGrLPKVhreQIkPA/5E9ktQE8JVL0w2wHP//lZN/qQTOAi7D/8NYkjwkNAe3mL2+XSnuaaie8wc1qin4vadaEU7emuUUjn1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FFuNYm3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FFuNYm3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30117C116C6;
	Tue, 27 Jan 2026 04:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486757;
	bh=Y5600A1kAeU3hpGUBpFUMa2hmxe7IsTb+ya5dWr5nBo=;
	h=Date:To:From:Subject:From;
	b=FFuNYm3aPKs6UMXNlRD9ozmIrs5jkwLeqI3zMd/KkehMD9PfbUjsFiJo642TVgttC
	 4K9clEAfDBZYpiR+olc+E30TcKtDnacDFAgHdRjRHHSvy6wT5ebJexEiegIwZ3qCsZ
	 5Od+0ONvMI6j8o1mfkaFAAdiY1bFhM8BWcXXZCek=
Date: Mon, 26 Jan 2026 20:05:56 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mkoutny@suse.com,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,longman@redhat.com,linux@rasmusvillemoes.dk,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-use-nodes_and-output-where-appropriate.patch removed from -mm tree
Message-Id: <20260127040557.30117C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cgroup: use nodes_and() output where appropriate
has been removed from the -mm tree.  Its filename was
     cgroup-use-nodes_and-output-where-appropriate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Tejun Heo <tj@kernel.org>
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
@@ -453,9 +453,8 @@ static void guarantee_active_cpus(struct
  */
 static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 {
-	while (!nodes_intersects(cs->effective_mems, node_states[N_MEMORY]))
+	while (!nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]))
 		cs = parent_cs(cs);
-	nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]);
 }
 
 /**
@@ -2859,13 +2858,13 @@ static void update_nodemasks_hier(struct
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

kernelh-drop-stack_magic-macro.patch
moduleparam-include-required-headers-explicitly.patch
kernelh-move-verify_octal_permissions-to-sysfsh.patch
kernelh-include-linux-instruction_pointerh-explicitly.patch
tracing-move-tracing-declarations-from-kernelh-to-a-dedicated-header.patch

