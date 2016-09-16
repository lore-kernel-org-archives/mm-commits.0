From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-memcontrol-consolidate-cgroup-socket-tracking-fix.patch removed from -mm tree
Date: Fri, 16 Sep 2016 16:04:58 -0700
Message-ID: <57dc7a9a.vQDWlQxpcxbOZriZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58959 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758080AbcIPXE7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:04:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, hannes@cmpxchg.org, lkp@intel.com, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-consolidate-cgroup-socket-tracking-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-consolidate-cgroup-socket-tracking-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-consolidate-cgroup-socket-tracking-fix

fix CONFIG_MEMCG=n build

Reported-by: kbuild test robot <lkp@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 net/core/sock.c |    9 ++++++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking-fix
+++ a/mm/memcontrol.c
@@ -5655,9 +5655,6 @@ void mem_cgroup_sk_alloc(struct sock *sk
 {
 	struct mem_cgroup *memcg;
 
-	if (!mem_cgroup_sockets_enabled)
-		return;
-
 	/*
 	 * Socket cloning can throw us here with sk_memcg already
 	 * filled. It won't however, necessarily happen from
diff -puN net/core/sock.c~mm-memcontrol-consolidate-cgroup-socket-tracking-fix net/core/sock.c
--- a/net/core/sock.c~mm-memcontrol-consolidate-cgroup-socket-tracking-fix
+++ a/net/core/sock.c
@@ -1385,7 +1385,8 @@ static void sk_prot_free(struct proto *p
 	slab = prot->slab;
 
 	cgroup_sk_free(&sk->sk_cgrp_data);
-	mem_cgroup_sk_free(sk);
+	if (mem_cgroup_sockets_enabled)
+		mem_cgroup_sk_free(sk);
 	security_sk_free(sk);
 	if (slab != NULL)
 		kmem_cache_free(slab, sk);
@@ -1422,7 +1423,8 @@ struct sock *sk_alloc(struct net *net, i
 		sock_net_set(sk, net);
 		atomic_set(&sk->sk_wmem_alloc, 1);
 
-		mem_cgroup_sk_alloc(sk);
+		if (mem_cgroup_sockets_enabled)
+			mem_cgroup_sk_alloc(sk);
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
 		sock_update_classid(&sk->sk_cgrp_data);
 		sock_update_netprioidx(&sk->sk_cgrp_data);
@@ -1569,7 +1571,8 @@ struct sock *sk_clone_lock(const struct
 		newsk->sk_incoming_cpu = raw_smp_processor_id();
 		atomic64_set(&newsk->sk_cookie, 0);
 
-		mem_cgroup_sk_alloc(newsk);
+		if (mem_cgroup_sockets_enabled)
+			mem_cgroup_sk_alloc(newsk);
 		cgroup_sk_alloc(&newsk->sk_cgrp_data);
 
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
lib-bitmapc-enhance-bitmap-syntax-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

