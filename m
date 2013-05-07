From: akpm@linux-foundation.org
Subject: [merged] zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:45 -0700
Message-ID: <20130507174645.8C54F5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:64930 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab3EGRqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:46 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so84938yen.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konrad.wilk@oracle.com, andor.daam@googlemail.com, dan.magenheimer@oracle.com, fschmaus@gmail.com, ilendir@googlemail.com, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zcache/tmem: Better error checking on frontswap_register_ops return value.
has been removed from the -mm tree.  Its filename was
     zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: zcache/tmem: Better error checking on frontswap_register_ops return value.

In the past it either used to be NULL or the "older" backend. Now we
also return -Exx error codes.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/zcache-main.c |    5 ++++-
 drivers/xen/tmem.c                   |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/staging/zcache/zcache-main.c~zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value drivers/staging/zcache/zcache-main.c
--- a/drivers/staging/zcache/zcache-main.c~zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value
+++ a/drivers/staging/zcache/zcache-main.c
@@ -1886,8 +1886,11 @@ static int __init zcache_init(void)
 			namestr, frontswap_has_exclusive_gets,
 			!disable_frontswap_ignore_nonactive);
 #endif
-		if (old_ops != NULL)
+		if (IS_ERR(old_ops) || old_ops) {
+			if (IS_ERR(old_ops))
+				return PTR_RET(old_ops);
 			pr_warn("%s: frontswap_ops overridden\n", namestr);
+		}
 	}
 	if (ramster_enabled)
 		ramster_init(!disable_cleancache, !disable_frontswap,
diff -puN drivers/xen/tmem.c~zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value drivers/xen/tmem.c
--- a/drivers/xen/tmem.c~zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value
+++ a/drivers/xen/tmem.c
@@ -397,8 +397,11 @@ static int xen_tmem_init(void)
 			frontswap_register_ops(&tmem_frontswap_ops);
 
 		tmem_frontswap_poolid = -1;
-		if (old_ops)
+		if (IS_ERR(old_ops) || old_ops) {
+			if (IS_ERR(old_ops))
+				return PTR_ERR(old_ops);
 			s = " (WARNING: frontswap_ops overridden)";
+		}
 		printk(KERN_INFO "frontswap enabled, RAM provided by "
 				 "Xen Transcendent Memory%s\n", s);
 	}
_

Patches currently in -mm which might be from konrad.wilk@oracle.com are

origin.patch
linux-next.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

