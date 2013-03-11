From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-fix-wrong-sp_node-insertion.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:16:33 -0700
Message-ID: <20130311201633.85F935A41E9__27434.5221034766$1363033025$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:64851 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3CKUQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:16:35 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so352094qcr.0
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:16:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, davej@redhat.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: fix wrong sp_node insertion
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-fix-wrong-sp_node-insertion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

rmap-recompute-pgoff-for-unmapping-huge-page.patch

