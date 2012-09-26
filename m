From: akpm@linux-foundation.org
Subject: [to-be-updated] pagemap-fix-wrong-kpf_thp-on-slab-pages.patch removed from -mm tree
Date: Wed, 26 Sep 2012 13:37:17 -0700
Message-ID: <20120926203718.1EB3620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43754 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2IZUhU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 16:37:20 -0400
Received: by wgbdt11 with SMTP id dt11so76531wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 13:37:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: pagemap: fix wrong KPF_THP on slab pages
has been removed from the -mm tree.  Its filename was
     pagemap-fix-wrong-kpf_thp-on-slab-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: pagemap: fix wrong KPF_THP on slab pages

KPF_THP can be set on non-huge compound pages like slab pages, because
PageTransCompound only sees PG_head and PG_tail. Obviously this is a bug
and breaks user space applications which look for thp via /proc/kpageflags.
Currently thp is constructed only on anonymous pages, so this patch makes
KPF_THP be set when both of PageAnon and PageTransCompound are true.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/proc/page.c~pagemap-fix-wrong-kpf_thp-on-slab-pages fs/proc/page.c
--- a/fs/proc/page.c~pagemap-fix-wrong-kpf_thp-on-slab-pages
+++ a/fs/proc/page.c
@@ -115,7 +115,12 @@ u64 stable_page_flags(struct page *page)
 		u |= 1 << KPF_COMPOUND_TAIL;
 	if (PageHuge(page))
 		u |= 1 << KPF_HUGE;
-	else if (PageTransCompound(page))
+	/*
+	 * Since THP is relevant only for anonymous pages so far, we check it
+	 * explicitly with PageAnon. Otherwise thp is confounded with non-huge
+	 * compound pages like slab pages.
+	 */
+	else if (PageTransCompound(page) && PageAnon(page))
 		u |= 1 << KPF_THP;
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


