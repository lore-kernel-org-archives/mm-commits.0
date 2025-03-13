Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFD91F872D
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741906260; cv=none; b=uZ+9OxZPqFjJisElCaf9TWiQadGpUJC0uMijehR563CajKDVo0QW1HFmdnaPyoH5gUtsYJOLKILw+qalgrFTkTKvTOYqIUq8IEJg8TsUeEh1VfuppaGIpsyyrbI8+22m3Qm1UxVxZCHqWxOh9NtD6IEXcFo2WYjgsNZIrv3zcaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741906260; c=relaxed/simple;
	bh=934+Foq6dUdVaw6H4jUNpNXv0VGuv2WphrfLOGjgmuM=;
	h=Date:To:From:Subject:Message-Id; b=btcKqgF1pRISoALwyol05hRpp1CLPjcLZnOj+a3bryQKjEQgq+Ykm1Jk1j78hIufDU7wifcXcnL/P7Vj2jZ1rMBRogMvdktW2nx2owBXOVKGnOMjU8CFtm58WXF5UiJ5UZNSOuMjWUk4ExVCjKeq0g20po5vtHgy3+E0NJy6NXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Us7O6wsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Us7O6wsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB77C4CEDD;
	Thu, 13 Mar 2025 22:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741906260;
	bh=934+Foq6dUdVaw6H4jUNpNXv0VGuv2WphrfLOGjgmuM=;
	h=Date:To:From:Subject:From;
	b=Us7O6wsChy/NfzKk+UiH7+VC9WBiQ69khld2mXnuC3fjU3cJ9MTHUebL7NwRdHjY5
	 MLQsQ7zdEJoUP1iFNPeGnR8RGowjYwhLZ13qOUqK5C1jnC1mBycmwvSq7csnBM8QYG
	 sYeFxYBdcs7p6LWAARHEJFQ8OxzKP5eC/yK0o80Q=
Date: Thu, 13 Mar 2025 15:50:59 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-do_memsw_account-to-config_memcg_v1.patch added to mm-unstable branch
Message-Id: <20250313225100.8DB77C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move do_memsw_account() to CONFIG_MEMCG_V1
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-move-do_memsw_account-to-config_memcg_v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-do_memsw_account-to-config_memcg_v1.patch

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

memcg-drain-obj-stock-on-cpu-hotplug-teardown.patch
memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-dont-call-propagate_protected_usage-for-v1.patch
page_counter-track-failcnt-only-for-legacy-cgroups.patch
page_counter-reduce-struct-page_counter-size.patch
memcg-bypass-root-memcg-check-for-skmem-charging.patch
memcg-avoid-refill_stock-for-root-memcg.patch
memcg-move-do_memsw_account-to-config_memcg_v1.patch

