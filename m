From: akpm@linux-foundation.org
Subject: + proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch added to -mm tree
Date: Thu, 04 Feb 2016 15:47:35 -0800
Message-ID: <56b3e317.9bRG2DLO6stbbcQ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbcBDXrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:47:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: kpageflags: do not report buddy and balloon pages as mapped
has been added to the -mm tree.  Its filename is
     proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch

