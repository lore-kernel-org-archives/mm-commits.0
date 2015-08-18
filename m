From: akpm@linux-foundation.org
Subject: + zpool-remove-no-op-module-init-exit.patch added to -mm tree
Date: Tue, 18 Aug 2015 15:38:55 -0700
Message-ID: <55d3b3ff.dhCR0H/RCxAQdVrD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbbHRWiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 18:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: remove no-op module init/exit
has been added to the -mm tree.  Its filename is
     zpool-remove-no-op-module-init-exit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zpool-remove-no-op-module-init-exit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zpool-remove-no-op-module-init-exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zpool: remove no-op module init/exit

Remove zpool_init() and zpool_exit(); they do nothing other than print
"loaded" and "unloaded".

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN mm/zpool.c~zpool-remove-no-op-module-init-exit mm/zpool.c
--- a/mm/zpool.c~zpool-remove-no-op-module-init-exit
+++ a/mm/zpool.c
@@ -353,20 +353,6 @@ u64 zpool_get_total_size(struct zpool *z
 	return zpool->driver->total_size(zpool->pool);
 }
 
-static int __init init_zpool(void)
-{
-	pr_info("loaded\n");
-	return 0;
-}
-
-static void __exit exit_zpool(void)
-{
-	pr_info("unloaded\n");
-}
-
-module_init(init_zpool);
-module_exit(exit_zpool);
