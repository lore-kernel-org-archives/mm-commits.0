From: akpm@linux-foundation.org
Subject: [merged] kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:32 -0700
Message-ID: <20121009181432.B4A42100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36966 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab2JISOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:33 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so662965qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kpageflags: fix wrong KPF_THP on non-huge compound pages
has been removed from the -mm tree.  Its filename was
     kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: kpageflags: fix wrong KPF_THP on non-huge compound pages

KPF_THP can be set on non-huge compound pages (like slab pages or pages
allocated by drivers with __GFP_COMP) because PageTransCompound only
checks PG_head and PG_tail.  Obviously this is a bug and breaks user space
applications which look for thp via /proc/kpageflags.

This patch rules out setting KPF_THP wrongly by additionally checking
PageLRU on the head pages.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/proc/page.c~kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages fs/proc/page.c
--- a/fs/proc/page.c~kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages
+++ a/fs/proc/page.c
@@ -115,7 +115,13 @@ u64 stable_page_flags(struct page *page)
 		u |= 1 << KPF_COMPOUND_TAIL;
 	if (PageHuge(page))
 		u |= 1 << KPF_HUGE;
-	else if (PageTransCompound(page))
+	/*
+	 * PageTransCompound can be true for non-huge compound pages (slab
+	 * pages or pages allocated by drivers with __GFP_COMP) because it
+	 * just checks PG_head/PG_tail, so we need to check PageLRU to make
+	 * sure a given page is a thp, not a non-huge compound page.
+	 */
+	else if (PageTransCompound(page) && PageLRU(compound_trans_head(page)))
 		u |= 1 << KPF_THP;
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

