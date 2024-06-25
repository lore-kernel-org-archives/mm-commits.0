Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AFE17D345
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 20:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348636; cv=none; b=HUxrgbEWbOaHABPTjkAcZvTSVPLcX+lPOTTPMcbqNWpe1a2KK0WGIAOWZJCaTVD2yiQ4ehiUaybvLsaK9y6aBSM7XQfZQyQhvzwKle8FUsu+BAZpq/WAOhGfFY52kbgzUXVA8askuAI1pZtgnokknEcpQEEFBxFd8mUzexxvDrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348636; c=relaxed/simple;
	bh=En55tbAWUVUlxratsEMF1bta/v6WDtjwxYR65HQQqzI=;
	h=Date:To:From:Subject:Message-Id; b=Q9Q17mkGfahmH7goO2oIwR8CzX4GdmLOpgI1o/Zb9EzxaDWUxangpe7NZI7fMlrTSxcA8BkmikYhzdWZP6/MulwVBQyxaNGR2037dIzsjQ6AvGso7nWOE0R5nzncx9CSOlvfHZQC9h3/jrWzVzSUgalkKfjFNFmll/NmhzldiOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J/56Mta/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J/56Mta/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57799C32781;
	Tue, 25 Jun 2024 20:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719348636;
	bh=En55tbAWUVUlxratsEMF1bta/v6WDtjwxYR65HQQqzI=;
	h=Date:To:From:Subject:From;
	b=J/56Mta/5JCbrXcfEu8P2KeQdlwe0bIbbjVLohABOV+3sIuK5agghAsy2ZY3EFe/4
	 hKy3vMwDiIV1IS8+1HJuVj9bbvpkwosxqwvDvuchXQWQJJH4EKcJj9hqEzYJcvbVQn
	 BCqu6+KosNWqJCe4nUszvyq4MHwbpQRLCz+uACdw=
Date: Tue, 25 Jun 2024 13:50:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-rename-memcg_oom_recover.patch added to mm-unstable branch
Message-Id: <20240625205036.57799C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: rename memcg_oom_recover()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-rename-memcg_oom_recover.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-rename-memcg_oom_recover.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: rename memcg_oom_recover()
Date: Mon, 24 Jun 2024 17:59:01 -0700

Rename memcg_oom_recover() into memcg1_oom_recover() for consistency with
other memory cgroup v1-related functions.

Move the declaration in mm/memcontrol-v1.h to be nearby other memcg v1 oom
handling functions.

Link: https://lkml.kernel.org/r/20240625005906.106920-10-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    6 +++---
 mm/memcontrol-v1.h |    2 +-
 mm/memcontrol.c    |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-rename-memcg_oom_recover
+++ a/mm/memcontrol.c
@@ -3165,7 +3165,7 @@ static int mem_cgroup_resize_max(struct
 	} while (true);
 
 	if (!ret && enlarge)
-		memcg_oom_recover(memcg);
+		memcg1_oom_recover(memcg);
 
 	return ret;
 }
@@ -3750,7 +3750,7 @@ static int mem_cgroup_oom_control_write(
 
 	WRITE_ONCE(memcg->oom_kill_disable, val);
 	if (!val)
-		memcg_oom_recover(memcg);
+		memcg1_oom_recover(memcg);
 
 	return 0;
 }
@@ -5444,7 +5444,7 @@ static void uncharge_batch(const struct
 			page_counter_uncharge(&ug->memcg->memsw, ug->nr_memory);
 		if (ug->nr_kmem)
 			memcg_account_kmem(ug->memcg, -ug->nr_kmem);
-		memcg_oom_recover(ug->memcg);
+		memcg1_oom_recover(ug->memcg);
 	}
 
 	local_irq_save(flags);
--- a/mm/memcontrol-v1.c~mm-memcg-rename-memcg_oom_recover
+++ a/mm/memcontrol-v1.c
@@ -1090,8 +1090,8 @@ static void __mem_cgroup_clear_mc(void)
 
 		mc.moved_swap = 0;
 	}
-	memcg_oom_recover(from);
-	memcg_oom_recover(to);
+	memcg1_oom_recover(from);
+	memcg1_oom_recover(to);
 	wake_up_all(&mc.waitq);
 }
 
@@ -2067,7 +2067,7 @@ static int memcg_oom_wake_function(wait_
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
 
-void memcg_oom_recover(struct mem_cgroup *memcg)
+void memcg1_oom_recover(struct mem_cgroup *memcg)
 {
 	/*
 	 * For the following lockless ->under_oom test, the only required
--- a/mm/memcontrol-v1.h~mm-memcg-rename-memcg_oom_recover
+++ a/mm/memcontrol-v1.h
@@ -13,7 +13,6 @@ static inline void memcg1_soft_limit_res
 
 void mem_cgroup_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
 void memcg1_check_events(struct mem_cgroup *memcg, int nid);
-void memcg_oom_recover(struct mem_cgroup *memcg);
 int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		     unsigned int nr_pages);
 
@@ -92,5 +91,6 @@ ssize_t memcg_write_event_control(struct
 
 bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked);
 void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked);
+void memcg1_oom_recover(struct mem_cgroup *memcg);
 
 #endif	/* __MM_MEMCONTROL_V1_H */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

