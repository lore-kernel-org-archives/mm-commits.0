From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-fix-sp_node_init-argument-ordering.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:16:36 -0700
Message-ID: <20130311201636.81A5531C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:49072 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3CKUQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:16:37 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so225271qah.2
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:16:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, davej@redhat.com, dhillf@gmail.com, hughd@google.com, mgorman@suse.de, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: fix sp_node_init() argument ordering
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-fix-sp_node_init-argument-ordering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm/mempolicy.c: fix sp_node_init() argument ordering

Currently, n_new is wrongly initialized.  start and end parameter are
inverted.  Let's fix it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-fix-sp_node_init-argument-ordering mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-fix-sp_node_init-argument-ordering
+++ a/mm/mempolicy.c
@@ -2390,7 +2390,7 @@ restart:
 
 				*mpol_new = *n->policy;
 				atomic_set(&mpol_new->refcnt, 1);
-				sp_node_init(n_new, n->end, end, mpol_new);
+				sp_node_init(n_new, end, n->end, mpol_new);
 				n->end = start;
 				sp_insert(sp, n_new);
 				n_new = NULL;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-remove_memory-fix-end_pfn-setting.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
drop_caches-add-some-documentation-and-info-messsge.patch

