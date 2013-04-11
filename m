From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-error-return-in-kswapd_run.patch added to -mm tree
Date: Thu, 11 Apr 2013 15:50:55 -0700
Message-ID: <20130411225055.73D7231C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:60418 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3DKWu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 18:50:56 -0400
Received: by mail-gg0-f202.google.com with SMTP id q1so195933ggn.3
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 15:50:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiuxishi@huawei.com, liwanp@linux.vnet.ibm.com, riel@redhat.com


The patch titled
     Subject: mm/vmscan: fix error return in kswapd_run()
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-error-return-in-kswapd_run.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm/vmscan: fix error return in kswapd_run()

Fix the error return value in kswapd_run().  The bug was introduced by
d5dc0ad928fb9 ("mm/vmscan: fix error number for failed kthread").

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-error-return-in-kswapd_run mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-error-return-in-kswapd_run
+++ a/mm/vmscan.c
@@ -3192,9 +3192,9 @@ int kswapd_run(int nid)
 	if (IS_ERR(pgdat->kswapd)) {
 		/* failure at boot is fatal */
 		BUG_ON(system_state == SYSTEM_BOOTING);
-		pgdat->kswapd = NULL;
 		pr_err("Failed to start kswapd on node %d\n", nid);
 		ret = PTR_ERR(pgdat->kswapd);
+		pgdat->kswapd = NULL;
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

linux-next.patch
arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch
mm-vmscan-fix-error-return-in-kswapd_run.patch

