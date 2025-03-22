Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE36E12F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619827; cv=none; b=EfdX27os8Y6ji1HVwLE3CKKAADMu4OQXAFhQdHTr51Xl0OlmULbB4fRfYefOIuQyqQJZ2L1nklLJ/+KJEZoKT3Yjdhbnv0ELBaVUsG5VZOcVsGUhUEwJMBZvuR25aCbKnyxo+8cwHeVoLrvaMAr2CfbpV/E4AMNnJl8evCYg9Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619827; c=relaxed/simple;
	bh=q3sEZllzr1kxemMRruslnY4o0Zr1aGB3XuOHNSwaL1I=;
	h=Date:To:From:Subject:Message-Id; b=nS88eDsqxGPevntMeDf1c12sLLVWimGzpfNMG//WWx9qm9JFUgu0TigwwUbHJJX1MaZa1fRlYDudpITI/rPhq9sEIxUroTGBzGEK96k0GJ7NWSK/1IevCE97sWpK/ZGtDYndQVow4CltW8pUn1HHlkUl0YedTqzKvK4iWCwGXSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l+Almame; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l+Almame"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2314C4CEDD;
	Sat, 22 Mar 2025 05:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619827;
	bh=q3sEZllzr1kxemMRruslnY4o0Zr1aGB3XuOHNSwaL1I=;
	h=Date:To:From:Subject:From;
	b=l+Almame9r9On7NPyM5JpleeXwJlIK4bJEOtYbVU+K3Jq8mUAs1eITJyw0UcZKHvu
	 fZoXYfOVxC2RzZGPfCgI7JqEKvtxOxmqg3JRL86/4zwIwfhfXy5rhSLyaQCZf8hnwK
	 4IUFzWTdqaBCXoF3qXpNwW7X1PLDcDZX+gvNMZrk=
Date: Fri, 21 Mar 2025 22:03:47 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-move-do_memsw_account-to-config_memcg_v1.patch removed from -mm tree
Message-Id: <20250322050347.A2314C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: move do_memsw_account() to CONFIG_MEMCG_V1
has been removed from the -mm tree.  Its filename was
     memcg-move-do_memsw_account-to-config_memcg_v1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: move do_memsw_account() to CONFIG_MEMCG_V1
Date: Wed, 12 Mar 2025 15:25:52 -0700

The do_memsw_account() is used to enable or disable legacy memory+swap
accounting in memory cgroup.  However with disabled CONFIG_MEMCG_V1, we
don't need to keep checking it.  So, let's always return false for
!CONFIG_MEMCG_V1 configs.

Before the patch:

$ size mm/memcontrol.o
   text    data     bss     dec     hex filename
  49928   10736    4172   64836    fd44 mm/memcontrol.o

After the patch:

$ size mm/memcontrol.o
   text    data     bss     dec     hex filename
  49430   10480    4172   64082    fa52 mm/memcontrol.o

Link: https://lkml.kernel.org/r/20250312222552.3284173-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/memcontrol-v1.h~memcg-move-do_memsw_account-to-config_memcg_v1
+++ a/mm/memcontrol-v1.h
@@ -22,12 +22,6 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-/* Whether legacy memory+swap accounting is active */
-static inline bool do_memsw_account(void)
-{
-	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
-}
-
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 
 void drain_all_stock(struct mem_cgroup *root_memcg);
@@ -42,6 +36,12 @@ struct mem_cgroup *mem_cgroup_id_get_onl
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
+/* Whether legacy memory+swap accounting is active */
+static inline bool do_memsw_account(void)
+{
+	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
+}
+
 unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
@@ -94,6 +94,7 @@ extern struct cftype mem_cgroup_legacy_f
 
 #else	/* CONFIG_MEMCG_V1 */
 
+static inline bool do_memsw_account(void) { return false; }
 static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true; }
 static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


