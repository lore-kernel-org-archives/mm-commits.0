From: akpm@linux-foundation.org
Subject: + zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch added to -mm tree
Date: Wed, 06 Mar 2013 13:10:16 -0800
Message-ID: <20130306211016.E268831C1B6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:41151 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3CFVKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 16:10:18 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so918292yhr.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 13:10:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konrad.wilk@oracle.com, andor.daam@googlemail.com, dan.magenheimer@oracle.com, fschmaus@gmail.com, ilendir@googlemail.com, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, minchan@kernel.org


The patch titled
     Subject: zcache/tmem: Better error checking on frontswap_register_ops return value.
has been added to the -mm tree.  Its filename is
     zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1794,8 +1794,11 @@ static int __init zcache_init(void)
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
@@ -395,8 +395,11 @@ static int xen_tmem_init(void)
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
mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch
mm-frontswap-cleanup-code.patch
mm-cleancache-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch
mm-cleancache-clean-up-cleancache_enabled.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

