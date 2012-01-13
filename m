From: akpm@linux-foundation.org
Subject: [merged] ramoops-update-parameters-only-after-successful-init.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:37 -0800
Message-ID: <20120113203738.149D420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42927 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:40 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25473eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees@outflux.net, keescook@chromium.org, marco.stornelli@gmail.com, seiji.aguchi@hds.com, sergiu@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ramoops: update parameters only after successful init
has been removed from the -mm tree.  Its filename was
     ramoops-update-parameters-only-after-successful-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kees Cook <kees@outflux.net>
Subject: ramoops: update parameters only after successful init

If a platform device exists on the system, but ramoops fails to attach to
it, the module parameters are overridden before ramoops can fall back and
try to use passed module parameters.  Move update to end of init routine.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Sergiu Iordache <sergiu@chromium.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-update-parameters-only-after-successful-init drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-update-parameters-only-after-successful-init
+++ a/drivers/char/ramoops.c
@@ -147,14 +147,6 @@ static int __init ramoops_probe(struct p
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
-	/*
-	 * Update the module parameter variables as well so they are visible
-	 * through /sys/module/ramoops/parameters/
-	 */
-	mem_size = pdata->mem_size;
-	mem_address = pdata->mem_address;
-	record_size = pdata->record_size;
-	dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		pr_err("request mem region failed\n");
@@ -175,6 +167,15 @@ static int __init ramoops_probe(struct p
 		goto fail1;
 	}
 
+	/*
+	 * Update the module parameter variables as well so they are visible
+	 * through /sys/module/ramoops/parameters/
+	 */
+	mem_size = pdata->mem_size;
+	mem_address = pdata->mem_address;
+	record_size = pdata->record_size;
+	dump_oops = pdata->dump_oops;
+
 	return 0;
 
 fail1:
_

Patches currently in -mm which might be from kees@outflux.net are

origin.patch

