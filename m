Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832264;
	b=dnOgybTTomi451EHZZb+UVTYBG9QmWtIRHSlX2y8yrSbbHcS0PuCRKHSCD2q5n+5rqcz
	 XtIee2DTrW9CtmWwEDbdF0NhqLV/GYp39X1FxVYvEB+/SFO4Fz5QFv5xlAqnjlBB9c15q
	 HDiOfFsOR0XeEpitrSFVZQqwRQ3itUXjQIDx9Spkm3g+RkJaBKpIeaqRB4hSMpW8XNGoz
	 uc9+msuLovZGb/rKHlitDaTzPGpdmoQXodQSSm3qZCYYQZ8A9ENcbCk2FnjjXYZBzhPj/
	 /s0sU5wyErP0okMjfwZLuARF51H8uCrQYSOiZwV4v6AGY5t4JX3YB1PQabbhR2FiArg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832264;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/hR/Cy1kNQaNRw7GxeaSj0BGiS+csPdoUcEVeM2Tt1g=;
	b=qMIptHEVLAM9DHxzFAXcStaUE3sE2Lp/7oIFmdNYtSWxvvUkvgJrSHaM1FJtfXw7T2Li
	 8kS0XDpq8k71VRv7eqGhky+351Ik/nwxhpviYXui6yErNJwDSzqW29Fm4up0bh06Z9ZE6
	 riQfsTJSQeVkprndb4YYQnd79RI0RC/DBloWtbE/5cN3hX5Ahb+AiPf4gUInXdyTUtIdn
	 HzSzQ9gm105Y6ZHb1bPEhBnqPGvcyfnhrIU9Jijew0tXYZeSEkkgBUbns01Yejh1pZFDA
	 uQWAGtAHqeYObl8o74GfhllbtadrCCE0a8qDSkO7xAQ8kVcs8+/OB0Nser1Osh69ODw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WKP9rZvE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0006606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WKP9rZvE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFCB1F031E0;
	Sat, 24 Oct 2026 08:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832263;
	bh=/hR/Cy1kNQaNRw7GxeaSj0BGiS+csPdoUcEVeM2Tt1g=;
	h=Date:To:From:Subject;
	b=WKP9rZvEWPS9+6UPr93SU/3ecQrsNV08lLDB2OtsFAmosj53e/wVuDnlp6pfrlHFq
	 c10Hcq2qMoiMVfeAUmr8SiNs+CRBNRqQUZ3dBRg+qq8DGkmKRdWPLHtrkNn+GHmv48
	 4VGuVj+jOctxjBfdPvBOiC0WmrGg0j8OwYyc5JB0=
Date: Sat, 24 Oct 2026 01:57:43 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,bfguo@icloud.com,baohua@kernel.org,axelrasmussen@google.com,bingfangguo@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-base-swap-charge-accounting-on-memcgid-root-status.patch removed from -mm tree
Message-Id: <20261024085743.9EFCB1F031E0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: memcg: base swap charge accounting on memcgid root status
has been removed from the -mm tree.  Its filename was
     memcg-base-swap-charge-accounting-on-memcgid-root-status.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bingfang Guo <bingfangguo@tencent.com>
Subject: memcg: base swap charge accounting on memcgid root status
Date: Mon, 21 Sep 2026 14:16:25 +0800

A private ID currently pins its original memcg, so testing whether the ID
belongs to root is equivalent to testing whether the resolved memcg is
root.

That equivalence will no longer hold when IDs refer to objcgs.  A non-root
ID may resolve to root after reparenting, but its swap entries still carry
counter charges inherited by root.  Skipping their uncharge based on the
resolved memcg would leave those charges behind.

Use the private ID's root status to decide whether a swap entry carries a
counter charge.  A root-ID entry carries none, while a non-root-ID entry
must release its charge even if its current accounting memcg has become
root.

This patch adds a new helper to check if the memcgid equals to that of the
root memcg.  For swap uncharging and v2 swap charging, simply decide
whether to charge/uncharge memsw or swap counter based on the swap memcgid
is root or not.  For v1 swapout, don't recharge the memsw counter, just
cancel the charge if the swap memcg ID refers to the root memcg.

This makes memory and swap charging have similar semantics: one relys on
the objcg's root status, and the other relys on the memcgid's root status.

Link: https://lore.kernel.org/20260921-bingfangguo-memcgid-rework-v2-2-6c0637dc0edb@tencent.com
Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Bingfang Guo <bfguo@icloud.com>
---

 mm/memcontrol-v1.c |   16 ++++++++--------
 mm/memcontrol-v1.h |    5 +++++
 mm/memcontrol.c    |    4 ++--
 3 files changed, 15 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-base-swap-charge-accounting-on-memcgid-root-status
+++ a/mm/memcontrol.c
@@ -5975,7 +5975,7 @@ int __mem_cgroup_try_charge_swap(struct
 		/* memcg is pined by memcg ID. */
 		private_id = mem_cgroup_private_id(memcg);
 
-		if (!mem_cgroup_is_root(memcg) &&
+		if (!mem_cgroup_private_id_is_root(private_id) &&
 		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -6004,7 +6004,7 @@ void __mem_cgroup_uncharge_swap(unsigned
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
 	if (memcg) {
-		if (!mem_cgroup_is_root(memcg)) {
+		if (!mem_cgroup_private_id_is_root(id)) {
 			if (do_memsw_account())
 				page_counter_uncharge(&memcg->memsw, nr_pages);
 			else
--- a/mm/memcontrol-v1.c~memcg-base-swap-charge-accounting-on-memcgid-root-status
+++ a/mm/memcontrol-v1.c
@@ -271,6 +271,7 @@ void __memcg1_swapout(struct folio *foli
 	struct mem_cgroup *memcg, *swap_memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
+	unsigned short private_id;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -293,25 +294,24 @@ void __memcg1_swapout(struct folio *foli
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
-	 * ancestor for the swap instead and transfer the memory+swap charge.
+	 * ancestor for the swap instead and cancel the memory+swap charge
+	 * if the ID refers to the root memcg.
 	 */
 	nr_entries = folio_nr_pages(folio);
 	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
+	private_id = mem_cgroup_private_id(swap_memcg);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
-			  mem_cgroup_private_id(swap_memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
 
-	if (!obj_cgroup_is_root(objcg))
+	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (memcg != swap_memcg) {
-		if (!mem_cgroup_is_root(swap_memcg))
-			page_counter_charge(&swap_memcg->memsw, nr_entries);
-		page_counter_uncharge(&memcg->memsw, nr_entries);
+		if (mem_cgroup_private_id_is_root(private_id))
+			page_counter_uncharge(&memcg->memsw, nr_entries);
 	}
 
 	/*
--- a/mm/memcontrol-v1.h~memcg-base-swap-charge-accounting-on-memcgid-root-status
+++ a/mm/memcontrol-v1.h
@@ -22,6 +22,11 @@ void drain_all_stock(struct mem_cgroup *
 
 int memory_stat_show(struct seq_file *m, void *v);
 
+static inline bool mem_cgroup_private_id_is_root(unsigned short id)
+{
+	return id == mem_cgroup_private_id(root_mem_cgroup);
+}
+
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
_

Patches currently in -mm which might be from bingfangguo@tencent.com are


