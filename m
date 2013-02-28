From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-fix-sp_node_init-argument-ordering.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:55:58 -0800
Message-ID: <20130228235558.AE63F5A432E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60664 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3B1X4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:56:00 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so273598vcd.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:55:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, davej@redhat.com, dhillf@gmail.com, hughd@google.com, mgorman@suse.de, sasha.levin@oracle.com


The patch titled
     Subject: mm/mempolicy.c: fix sp_node_init() argument ordering
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-fix-sp_node_init-argument-ordering.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
mm-mempolicyc-fix-wrong-sp_node-insertion.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
mm-mempolicyc-fix-sp_node_init-argument-ordering.patch
drop_caches-add-some-documentation-and-info-messsge.patch

