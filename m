From: akpm@linux-foundation.org
Subject: - netns-fix-ip_rt_frag_needed-rt_is_expired.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:35 -0700
Message-ID: <200807282111.m6SLBZXH027690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762123AbYG1VRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:17:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     netns: fix ip_rt_frag_needed rt_is_expired
has been removed from the -mm tree.  Its filename was
     netns-fix-ip_rt_frag_needed-rt_is_expired.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netns: fix ip_rt_frag_needed rt_is_expired
From: Hugh Dickins <hugh@veritas.com>

Running recent kernels, and using a particular vpn gateway, I've been
having to edit my mails down to get them accepted by the smtp server.

Git bisect led to commit e84f84f276473dcc673f360e8ff3203148bdf0e2 -
netns: place rt_genid into struct net.  The conversion from a != test
to rt_is_expired() put one negative too many: and now my mail works.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/route.c~netns-fix-ip_rt_frag_needed-rt_is_expired net/ipv4/route.c
--- a/net/ipv4/route.c~netns-fix-ip_rt_frag_needed-rt_is_expired
+++ a/net/ipv4/route.c
@@ -1502,7 +1502,7 @@ unsigned short ip_rt_frag_needed(struct 
 				    rth->fl.iif != 0 ||
 				    dst_metric_locked(&rth->u.dst, RTAX_MTU) ||
 				    !net_eq(dev_net(rth->u.dst.dev), net) ||
-				    !rt_is_expired(rth))
+				    rt_is_expired(rth))
 					continue;
 
 				if (new_mtu < 68 || new_mtu >= old_mtu) {
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exec-include-pagemaph-again-to-fix-build.patch
tmpfs-fix-kernel-bug-in-shmem_delete_inode.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
git-unionfs.patch
vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
mmu-notifiers-add-mm_take_all_locks-operation-fix.patch
powerpc-lockless-get_user_pages.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mmapc-deinline-a-few-functions.patch
prio_tree-debugging-patch.patch

