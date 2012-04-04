From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch added to -mm tree
Date: Wed, 04 Apr 2012 14:18:37 -0700
Message-ID: <20120404211837.AA15DA001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:46746 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2DDVSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 17:18:38 -0400
Received: by ghbz15 with SMTP id z15so93464ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 14:18:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shhuiw@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/mempolicy.c: use enum value MPOL_REBIND_ONCE in mpol_rebind_policy()
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm/mempolicy.c: use enum value MPOL_REBIND_ONCE in mpol_rebind_policy()

We have enum definition in mempolicy.h: MPOL_REBIND_ONCE.  It should
replace the magic number 0 for step comparison in function
mpol_rebind_policy.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy
+++ a/mm/mempolicy.c
@@ -390,7 +390,7 @@ static void mpol_rebind_policy(struct me
 {
 	if (!pol)
 		return;
-	if (!mpol_store_user_nodemask(pol) && step == 0 &&
+	if (!mpol_store_user_nodemask(pol) && step == MPOL_REBIND_ONCE &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
 
_
Subject: Subject: mm/mempolicy.c: use enum value MPOL_REBIND_ONCE in mpol_rebind_policy()

Patches currently in -mm which might be from shhuiw@gmail.com are

mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch
mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch

