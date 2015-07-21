From: akpm@linux-foundation.org
Subject: + hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch added to -mm tree
Date: Tue, 21 Jul 2015 16:33:55 -0700
Message-ID: <55aed6e3.qu3c81snhTol4s0M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958AbbGUXd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 19:33:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison: use page_cgroup_ino for filtering by memcg
has been added to the -mm tree.  Its filename is
     hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: hwpoison: use page_cgroup_ino for filtering by memcg

Hwpoison allows to filter pages by memory cgroup ino.  Currently, it calls
try_get_mem_cgroup_from_page to obtain the cgroup from a page and then its
ino using cgroup_ino, but now we have a helper method for that,
page_cgroup_ino(), so use it instead.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    5 +----
 mm/memory-failure.c  |   16 ++--------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff -puN mm/hwpoison-inject.c~hwpoison-use-page_cgroup_ino-for-filtering-by-memcg mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~hwpoison-use-page_cgroup_ino-for-filtering-by-memcg
+++ a/mm/hwpoison-inject.c
@@ -45,12 +45,9 @@ static int hwpoison_inject(void *data, u
 	/*
 	 * do a racy check with elevated page count, to make sure PG_hwpoison
 	 * will only be set for the targeted owner (or on a free page).
-	 * We temporarily take page lock for try_get_mem_cgroup_from_page().
 	 * memory_failure() will redo the check reliably inside page lock.
 	 */
-	lock_page(hpage);
 	err = hwpoison_filter(hpage);
-	unlock_page(hpage);
 	if (err)
 		goto put_out;
 
@@ -126,7 +123,7 @@ static int pfn_inject_init(void)
 	if (!dentry)
 		goto fail;
 
-#ifdef CONFIG_MEMCG_SWAP
+#ifdef CONFIG_MEMCG
 	dentry = debugfs_create_u64("corrupt-filter-memcg", 0600,
 				    hwpoison_dir, &hwpoison_filter_memcg);
 	if (!dentry)
diff -puN mm/memory-failure.c~hwpoison-use-page_cgroup_ino-for-filtering-by-memcg mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-use-page_cgroup_ino-for-filtering-by-memcg
+++ a/mm/memory-failure.c
@@ -130,27 +130,15 @@ static int hwpoison_filter_flags(struct
  * can only guarantee that the page either belongs to the memcg tasks, or is
  * a freed page.
  */
-#ifdef	CONFIG_MEMCG_SWAP
+#ifdef CONFIG_MEMCG
 u64 hwpoison_filter_memcg;
 EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
 static int hwpoison_filter_task(struct page *p)
 {
-	struct mem_cgroup *mem;
-	struct cgroup_subsys_state *css;
-	unsigned long ino;
-
 	if (!hwpoison_filter_memcg)
 		return 0;
 
-	mem = try_get_mem_cgroup_from_page(p);
-	if (!mem)
-		return -EINVAL;
-
-	css = &mem->css;
-	ino = cgroup_ino(css->cgroup);
-	css_put(css);
-
-	if (ino != hwpoison_filter_memcg)
+	if (page_cgroup_ino(p) != hwpoison_filter_memcg)
 		return -EINVAL;
 
 	return 0;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch

