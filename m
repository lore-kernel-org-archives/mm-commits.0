From: akpm@linux-foundation.org
Subject: + kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch added to -mm tree
Date: Wed, 26 Sep 2012 13:40:12 -0700
Message-ID: <20120926204012.BD780100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36967 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2IZUkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 16:40:14 -0400
Received: by qaea16 with SMTP id a16so225280qae.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 13:40:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: kpageflags: fix wrong KPF_THP on non-huge compound pages
has been added to the -mm tree.  Its filename is
     kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch

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

kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch

