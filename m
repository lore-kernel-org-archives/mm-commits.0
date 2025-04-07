Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0417329A5
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987024; cv=none; b=DAJtVedDkfybZjyGf+aDquhFaEOIqa+mAdPoy3e8UFFa+M9WQWeVyVY6Vk40K9XAvP2VTUTB6Shod46CPHfvHhh/QQFoMoDqY/HkLKeizbZBgikyURnwC9umSSMBolSl/AIOZaA5YzzVdvwRdP5EN/tIZcHg/2W1UC+LIuS2aWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987024; c=relaxed/simple;
	bh=6TSc8wOINfHOEZr9tSzXvC24nZqOR2KEZeIvdmctT44=;
	h=Date:To:From:Subject:Message-Id; b=rzUTum5iJAdyGNK8wc2UM5fIgvBmW1jve24fOh7V0J6MzwNrqcaV+o9vEJkAoZdJjntUthhCG+jKWueOEjekT0UpY0PgSZy/ugkgF7gFC4YrU2PWQ6y5jIZ+4pAI6D9udwAr2Uosgd75Ub9wZfftuNcWKqEAZ4d2y7saEqz77jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uPfmMtUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uPfmMtUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D19DC4CEE3;
	Mon,  7 Apr 2025 00:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987023;
	bh=6TSc8wOINfHOEZr9tSzXvC24nZqOR2KEZeIvdmctT44=;
	h=Date:To:From:Subject:From;
	b=uPfmMtUnxe+zkVD8BDdrUrYfPw0o56rr6kNpoEqRVAtUqzJZ7nKF35kXkRxR0OxdO
	 JRMZ0A6QktbESczSMbnhEIacAJfRkojo4P4gnrJoHQ2lZQKRYPYfvKPmI2nYKk01hx
	 25IlJKtM8n8hpoqc5FtRCZ0XhpqR/qUXaObktsWg=
Date: Sun, 06 Apr 2025 17:50:22 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-__mod_memcg_state-in-drain_obj_stock.patch added to mm-new branch
Message-Id: <20250407005023.5D19DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: use __mod_memcg_state in drain_obj_stock
has been added to the -mm mm-new branch.  Its filename is
     memcg-use-__mod_memcg_state-in-drain_obj_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-__mod_memcg_state-in-drain_obj_stock.patch

This patch will later appear in the mm-new branch at
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
Subject: memcg: use __mod_memcg_state in drain_obj_stock
Date: Thu, 3 Apr 2025 18:39:11 -0700

For non-PREEMPT_RT kernels, drain_obj_stock() is always called with irq
disabled, so we can use __mod_memcg_state() instead of mod_memcg_state(). 
For PREEMPT_RT, we need to add memcg_stats_[un]lock in
__mod_memcg_state().

Link: https://lkml.kernel.org/r/20250404013913.1663035-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-use-__mod_memcg_state-in-drain_obj_stock
+++ a/mm/memcontrol.c
@@ -710,10 +710,12 @@ void __mod_memcg_state(struct mem_cgroup
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
+	memcg_stats_lock();
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
 	val = memcg_state_val_in_pages(idx, val);
 	memcg_rstat_updated(memcg, val);
 	trace_mod_memcg_state(memcg, idx, val);
+	memcg_stats_unlock();
 }
 
 #ifdef CONFIG_MEMCG_V1
@@ -2866,7 +2868,7 @@ static void drain_obj_stock(struct memcg
 
 			memcg = get_mem_cgroup_from_objcg(old);
 
-			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+			__mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
 			memcg1_account_kmem(memcg, -nr_pages);
 			if (!mem_cgroup_is_root(memcg))
 				memcg_uncharge(memcg, nr_pages);
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

