From: akpm@linux-foundation.org
Subject: + memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
 added to -mm tree
Date: Wed, 15 Jul 2015 13:58:29 -0700
Message-ID: <55a6c975.iFSdMVl/ibXTYs9H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbbGOU6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 16:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: get rid of extern for functions in memcontrol.h
has been added to the -mm tree.  Its filename is
     memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch

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
Subject: memcg: get rid of extern for functions in memcontrol.h

Most of the exported functions in this header are not marked extern so
change the rest to follow the same style.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-get-rid-of-extern-for-functions-in-memcontrolh include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-get-rid-of-extern-for-functions-in-memcontrolh
+++ a/include/linux/memcontrol.h
@@ -306,10 +306,10 @@ struct lruvec *mem_cgroup_page_lruvec(st
 
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg);
 
-extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
-extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
+struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
+struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
-extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
+struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
@@ -344,7 +344,7 @@ static inline bool mm_match_cgroup(struc
 	return match;
 }
 
-extern struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
+struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
 
 static inline bool mem_cgroup_disabled(void)
 {
@@ -403,8 +403,8 @@ static inline int mem_cgroup_inactive_an
 	return inactive * inactive_ratio < active;
 }
 
-extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
-					struct task_struct *p);
+void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
+				struct task_struct *p);
 
 static inline void mem_cgroup_oom_enable(void)
 {
@@ -719,8 +719,8 @@ static inline void sock_release_memcg(st
 extern struct static_key memcg_kmem_enabled_key;
 
 extern int memcg_nr_cache_ids;
-extern void memcg_get_cache_ids(void);
-extern void memcg_put_cache_ids(void);
+void memcg_get_cache_ids(void);
+void memcg_put_cache_ids(void);
 
 /*
  * Helper macro to loop through all memcg-specific caches. Callers must still
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

