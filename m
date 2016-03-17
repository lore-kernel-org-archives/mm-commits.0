From: akpm@linux-foundation.org
Subject: [folded-merged]
 proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch removed
 from -mm tree
Date: Thu, 17 Mar 2016 13:48:57 -0700
Message-ID: <56eb1839.ZStwbHgwbAIw+nTD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbcCQUs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:48:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: kpageflags: do not report buddy and balloon pages as mapped
has been removed from the -mm tree.  Its filename was
     proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch

This patch was dropped because it was folded into proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: proc: kpageflags: do not report buddy and balloon pages as mapped

PageBuddy and PageBalloon are not usual page flags - they are identified
by a special negative (so as not to confuse with mapped pages) value of
page->_mapcount.  Since /proc/kpageflags uses page_mapcount helper to
check if a page is mapped, it reports pages of these kinds as being
mapped, which is confusing.  Fix that by replacing page_mapcount with
page_mapped.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/page.c~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix fs/proc/page.c
--- a/fs/proc/page.c~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix
+++ a/fs/proc/page.c
@@ -105,7 +105,7 @@ u64 stable_page_flags(struct page *page)
 	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
 	 * simple test in page_mapcount() is not enough.
 	 */
-	if (!PageSlab(page) && page_mapcount(page))
+	if (!PageSlab(page) && page_mapped(page))
 		u |= 1 << KPF_MMAP;
 	if (PageAnon(page))
 		u |= 1 << KPF_ANON;
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch
tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix.patch
mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch
mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch
mm-memcontrol-zap-memcg_kmem_online-helper.patch
radix-tree-account-radix_tree_node-to-memory-cgroup.patch
mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch
mm-workingset-make-shadow-node-shrinker-memcg-aware.patch
mm-memcontrol-cleanup-css_reset-callback.patch
mm-memcontrol-zap-oom_info_lock.patch

