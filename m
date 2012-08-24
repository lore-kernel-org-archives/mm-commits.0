From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-error-number-for-failed-kthread.patch added to -mm tree
Date: Fri, 24 Aug 2012 14:53:37 -0700
Message-ID: <20120824215337.969DD1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36058 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2HXVxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 17:53:38 -0400
Received: by yenq13 with SMTP id q13so336622yen.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 14:53:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, liwanp@linux.vnet.ibm.com


The patch titled
     From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-error-number-for-failed-kthread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/vmscan: fix error number for failed kthread

Fix the return value while failing to create the kswapd kernel thread. 
Also, the error message is prioritized as KERN_ERR.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-error-number-for-failed-kthread mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-error-number-for-failed-kthread
+++ a/mm/vmscan.c
@@ -3111,9 +3111,9 @@ int kswapd_run(int nid)
 	if (IS_ERR(pgdat->kswapd)) {
 		/* failure at boot is fatal */
 		BUG_ON(system_state == SYSTEM_BOOTING);
-		printk("Failed to start kswapd on node %d\n",nid);
 		pgdat->kswapd = NULL;
-		ret = -1;
+		pr_err("Failed to start kswapd on node %d\n", nid);
+		ret = PTR_ERR(pgdat->kswapd);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

mm-slab-remove-duplicate-check.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
mm-memblock-truncate-memblock-if-necessary.patch
mm-memblock-rename-get_allocated_memblock_reserved_regions_info.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-vmscan-fix-error-number-for-failed-kthread.patch

