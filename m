From: akpm@linux-foundation.org
Subject: + netns-fix-ip_rt_frag_needed-rt_is_expired.patch added to -mm tree
Date: Sat, 26 Jul 2008 12:27:44 -0700
Message-ID: <200807261927.m6QJRipN015710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbYGZT1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 15:27:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     netns: fix ip_rt_frag_needed rt_is_expired
has been added to the -mm tree.  Its filename is
     netns-fix-ip_rt_frag_needed-rt_is_expired.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86-implement-pte_special.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
netns-fix-ip_rt_frag_needed-rt_is_expired.patch
git-unionfs.patch
vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
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

