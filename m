From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 062/128] mm/swapfile.c: explicitly show
 ssd/non-ssd is handled mutually exclusive
Date: Mon, 01 Jun 2020 21:48:49 -0700
Message-ID: <20200602044849.LMWYsBkqh%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgFBEsu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:48:50 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org

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
