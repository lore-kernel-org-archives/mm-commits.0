From: akpm@linux-foundation.org
Subject: + memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
 added to -mm tree
Date: Wed, 15 Jul 2015 13:58:33 -0700
Message-ID: <55a6c979.O18eqclUzfoNpyNe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbbGOU6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 16:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, tcp_kmem: check for cg_proto in sock_update_memcg
has been added to the -mm tree.  Its filename is
     memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, tcp_kmem: check for cg_proto in sock_update_memcg

sk_prot->proto_cgroup is allowed to return NULL but sock_update_memcg
doesn't check for NULL.  The function relies on the mem_cgroup_is_root
check because we shouldn't get NULL otherwise because mem_cgroup_from_task
will always return !NULL.

All other callers are checking for NULL and we can safely replace
mem_cgroup_is_root() check by cg_proto != NULL which will be more
straightforward (proto_cgroup returns NULL for the root memcg already).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg
+++ a/mm/memcontrol.c
@@ -315,8 +315,7 @@ void sock_update_memcg(struct sock *sk)
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
 		cg_proto = sk->sk_prot->proto_cgroup(memcg);
-		if (!mem_cgroup_is_root(memcg) &&
-		    memcg_proto_active(cg_proto) &&
+		if (cg_proto && memcg_proto_active(cg_proto) &&
 		    css_tryget_online(&memcg->css)) {
 			sk->sk_cgrp = cg_proto;
 		}
_

Patches currently in -mm which might be from mhocko@suse.cz are

maintainers-change-my-email-address-to-kernelorg.patch
mm-vmscan-do-not-wait-for-page-writeback-for-gfp_nofs-allocations.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
selftests-vm-add-tests-for-lock-on-fault.patch
fs-do-not-prefault-sys_write-user-buffer-pages.patch
mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch
mm-oom-organize-oom-context-into-struct.patch
mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch
mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch
mm-oom-add-description-of-struct-oom_control.patch
memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-swap-zswap-maybe_preload-refactoring.patch

