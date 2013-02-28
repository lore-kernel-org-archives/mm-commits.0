From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-fix-wrong-sp_node-insertion.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:52:47 -0800
Message-ID: <20130228235247.BE21F31C26C__31761.6962166086$1362095626$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:47226 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3B1Xwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:52:49 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so273655yen.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:52:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, davej@redhat.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, sasha.levin@oracle.com, stable@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: fix wrong sp_node insertion
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-fix-wrong-sp_node-insertion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/mempolicy.c: fix wrong sp_node insertion

n->end is accessed in sp_insert(). Thus it should be update
before calling sp_insert(). This mistake may make kernel panic.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Dave Jones <davej@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-fix-wrong-sp_node-insertion mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-fix-wrong-sp_node-insertion
+++ a/mm/mempolicy.c
@@ -2391,8 +2391,8 @@ restart:
 				*mpol_new = *n->policy;
 				atomic_set(&mpol_new->refcnt, 1);
 				sp_node_init(n_new, n->end, end, mpol_new);
-				sp_insert(sp, n_new);
 				n->end = start;
+				sp_insert(sp, n_new);
 				n_new = NULL;
 				mpol_new = NULL;
 				break;
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-mempolicyc-fix-wrong-sp_node-insertion.patch

