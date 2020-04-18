From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually?=
 =?US-ASCII?Q?-exclusive.patch?= added to -mm tree
Date: Fri, 17 Apr 2020 17:14:46 -0700
Message-ID: <20200418001446.9dMCgZNN_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgDRAOr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 20:14:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com


The patch titled
     Subject: mm/swapfile.c: explicitly show ssd/non-ssd is handled mutually exclusive
has been added to the -mm tree.  Its filename is
     mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: explicitly show ssd/non-ssd is handled mutually exclusive

The code shows if this is ssd, it will jump to specific tag and skip the
following code for non-ssd.

Let's use "else if" to explicitly show the mutually exclusion for
ssd/non-ssd to reduce ambiguity.

Link: http://lkml.kernel.org/r/20200328060520.31449-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive
+++ a/mm/swapfile.c
@@ -763,9 +763,7 @@ static int scan_swap_map_slots(struct sw
 			goto checks;
 		else
 			goto scan;
-	}
-
-	if (unlikely(!si->cluster_nr--)) {
+	} else if (unlikely(!si->cluster_nr--)) {
 		if (si->pages - si->inuse_pages < SWAPFILE_CLUSTER) {
 			si->cluster_nr = SWAPFILE_CLUSTER - 1;
 			goto checks;
@@ -873,10 +871,8 @@ checks:
 			goto checks;
 		else
 			goto done;
-	}
