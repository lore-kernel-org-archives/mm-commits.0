From: akpm@linux-foundation.org
Subject: + pagemap-fix-wrong-kpf_thp-on-slab-pages.patch added to -mm tree
Date: Tue, 25 Sep 2012 12:27:49 -0700
Message-ID: <20120925192750.26A925C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:36067 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2IYT1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 15:27:52 -0400
Received: by faet1 with SMTP id t1so468554fae.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 12:27:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: Re: pagemap: fix wrong KPF_THP on slab pages
has been added to the -mm tree.  Its filename is
     pagemap-fix-wrong-kpf_thp-on-slab-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

pagemap-fix-wrong-kpf_thp-on-slab-pages.patch

