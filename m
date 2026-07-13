Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB385358381
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 20:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783973179; cv=none; b=g+XqH9pu7X8aDqY3CjNvI6fIe6RIq8vYRhgiw8dBCkGQ47bZtOBUXt4frOlqjSK404S4uhhUY114YogAOPdCK+DAgJGcb7WgW2KEQaWBzK5znrSdysQ4OrUvYP+H/sKXkX+zpnxGdFhWcxYujYRcr+bmB78wRKZMov6m3bj5nGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783973179; c=relaxed/simple;
	bh=eWFyQBCc1tzpMAHNQ+hwNLEFKooueM+rE5azpI7r7xA=;
	h=Date:To:From:Subject:Message-Id; b=t9+PAZqAuJkSnep/bJw8a/LRzbZDetqq3mGvI9WQ/v5VZGt25XkMGq4O43JEKVzjUKsOe1RBqgzqXZ6dSe+JhJQLrYVziht6ns7zxSvz8Ka48uHxFBwYKLQQ8lyucouZk5XseFtGot8mIXgNS4jLXC7QWXq+++9VrIH5XyYSnVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qBVBsSt6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qBVBsSt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C2F1F000E9;
	Mon, 13 Jul 2026 20:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783973177;
	bh=Z+WoLPm9VmhX3vhf4DqpjLefD0jo9DPzeeeOGAqR7O8=;
	h=Date:To:From:Subject;
	b=qBVBsSt6IThcntuZmcrDBlylG+jhoS6FgMlEALp1/kZY8KVBzhNxuN/l3EPT1yln2
	 5/T6DO99a3LxQ4LLhSkkoTdJNRjCeAU76C6g3O1UD+yYrOaUQS8s3frpdVHodE+tDZ
	 zRXualwbY4rurUNh5G+BYHtzMknPFwAz27wSc8Pg=
Date: Mon, 13 Jul 2026 13:06:17 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch added to mm-new branch
Message-Id: <20260713200617.88C2F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: factor out memcg kmem uncharge sequence
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch

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
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcontrol: factor out memcg kmem uncharge sequence
Date: Mon, 13 Jul 2026 17:03:04 +0800

The kmem-uncharge sequence (mod_memcg_state(MEMCG_KMEM) +
memcg1_account_kmem + conditional memcg_uncharge) is duplicated verbatim
in obj_cgroup_release() and drain_obj_stock_slot().  Factor it into a
small memcg_uncharge_kmem() helper.  The reference get/put stays at the
call sites, as they differ.

No functional change.

Link: https://lore.kernel.org/20260713090304.3015329-1-guopeng.zhang@linux.dev
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence
+++ a/mm/memcontrol.c
@@ -137,6 +137,14 @@ bool mem_cgroup_kmem_disabled(void)
 
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
 
+static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+	memcg1_account_kmem(memcg, -nr_pages);
+	if (!mem_cgroup_is_root(memcg))
+		memcg_uncharge(memcg, nr_pages);
+}
+
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
 	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
@@ -172,10 +180,7 @@ static void obj_cgroup_release(struct pe
 		struct mem_cgroup *memcg;
 
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
-		memcg1_account_kmem(memcg, -nr_pages);
-		if (!mem_cgroup_is_root(memcg))
-			memcg_uncharge(memcg, nr_pages);
+		memcg_uncharge_kmem(memcg, nr_pages);
 		mem_cgroup_put(memcg);
 	}
 
@@ -3329,10 +3334,7 @@ static void drain_obj_stock_slot(struct
 
 			memcg = get_mem_cgroup_from_objcg(old);
 
-			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
-			memcg1_account_kmem(memcg, -nr_pages);
-			if (!mem_cgroup_is_root(memcg))
-				memcg_uncharge(memcg, nr_pages);
+			memcg_uncharge_kmem(memcg, nr_pages);
 
 			css_put(&memcg->css);
 		}
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch
mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch
mm-memcg-v1-account-vmpressure-event-allocations.patch
mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch
mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch
mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch

