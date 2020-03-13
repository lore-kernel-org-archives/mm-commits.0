From: Andrew Morton <akpm@linux-foundation.org>
Subject: + a.patch added to -mm tree
Date: Thu, 12 Mar 2020 20:05:17 -0700
Message-ID: <20200313030517.AuVc-daHF%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgCMDFU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 23:05:20 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, guro@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup cmdline_parse_hugetlb_cma()
has been added to the -mm tree.  Its filename is
     a.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/a.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/a.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: cleanup cmdline_parse_hugetlb_cma()

Remove unused code.

Link: http://lkml.kernel.org/r/20200313005500.GB5764@carbon.DHCP.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/hugetlb.c~a
+++ a/mm/hugetlb.c
@@ -5411,13 +5411,6 @@ static unsigned long hugetlb_cma_size __
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
 {
-	unsigned long long val;
-	char *endptr;
-
-	if (!p)
-		return -EINVAL;
