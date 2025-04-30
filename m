Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E2F25E454
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047256; cv=none; b=D8iRzNUaJjxKj/6gNTmNrDZ+QS9mJuxSuLSEapwhnlTvYQI0yi1P3W1NofzsSZMQqqfiX4qPJ6bKFazIrW3WSVFdLUgnXfJh0ujtMy6DWpXitfPcQl+SmjG3b11++6iPSuWBOOatuupRLTsxzpPH//AUiyYVwFiAEH1f5wqZip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047256; c=relaxed/simple;
	bh=OXZY6vUAiN9/W1w0A+6eslM1exWdohI4y71RlNHNPO4=;
	h=Date:To:From:Subject:Message-Id; b=ZItAUL5ueKwbwdvitq2A8QpX8GMA61jTgCVnqmGeUsXxwhu7AYbxG7jF3oZ3jzcO58T9v5OwdG/X5rUVvPOYrZfWqaquFPsMosKiT0Hs4gZyUZZDSgSimimUAOA2V2LzW8IF09JQobvSQMsS9L983mBXxfE0WD/9IlLEPZLtVVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2e87A3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2e87A3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560A1C4CEE7;
	Wed, 30 Apr 2025 21:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746047255;
	bh=OXZY6vUAiN9/W1w0A+6eslM1exWdohI4y71RlNHNPO4=;
	h=Date:To:From:Subject:From;
	b=x2e87A3pJ8U8BrhJqcnUtEi+7MoEAXjk0LwvID2Sf0p5zwpDanQ+XfefYye2VOoqa
	 6w/OT9NxAZLn6e2lIzQ+hN2UJdsBUfN0+vTtpURS64e4xZoBBxb7GbHCtxKCVNlmYE
	 M/SvizG5sEldzZTc1Gfl54P9fayiFUQDvMAUg3ZU=
Date: Wed, 30 Apr 2025 14:07:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,kuba@kernel.org,hughd@google.com,hannes@cmpxchg.org,edumazet@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-multi-memcg-percpu-charge-cache-fix-4.patch added to mm-unstable branch
Message-Id: <20250430210735.560A1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: multi-memcg percpu charge cache - fix 4
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-multi-memcg-percpu-charge-cache-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-multi-memcg-percpu-charge-cache-fix-4.patch

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
Subject: memcg: multi-memcg percpu charge cache - fix 4
Date: Wed, 30 Apr 2025 08:28:23 -0700

Add comment suggested by Michal and use DEFINE_PER_CPU_ALIGNED instead of
DEFINE_PER_CPU suggested by Vlastimil.

Link: https://lkml.kernel.org/r/dieeei3squ2gcnqxdjayvxbvzldr266rhnvtl3vjzsqevxkevf@ckui5vjzl2qg
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache-fix-4
+++ a/mm/memcontrol.c
@@ -1771,6 +1771,10 @@ void mem_cgroup_print_oom_group(struct m
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
+/*
+ * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and their
+ * nr_pages in a single cacheline. This may change in future.
+ */
 #define NR_MEMCG_STOCK 7
 struct memcg_stock_pcp {
 	local_trylock_t stock_lock;
@@ -1787,7 +1791,7 @@ struct memcg_stock_pcp {
 	unsigned long flags;
 #define FLUSHING_CACHED_CHARGE	0
 };
-static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock) = {
+static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
 	.stock_lock = INIT_LOCAL_TRYLOCK(stock_lock),
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch
memcg-optimize-memcg_rstat_updated.patch
memcg-multi-memcg-percpu-charge-cache.patch
memcg-multi-memcg-percpu-charge-cache-fix.patch
memcg-multi-memcg-percpu-charge-cache-fix-2.patch
memcg-multi-memcg-percpu-charge-cache-fix-4.patch
memcg-introduce-non-blocking-limit-setting-option.patch

