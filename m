From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch removed from -mm tree
Date: Thu, 31 May 2012 12:13:38 -0700
Message-ID: <20120531191338.5B3AFA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58308 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab2EaTNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:13:40 -0400
Received: by eeit10 with SMTP id t10so76221eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:13:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: use enum value MPOL_REBIND_ONCE in mpol_rebind_policy()
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from shhuiw@gmail.com are

origin.patch

