From: akpm@linux-foundation.org
Subject: + ramoops-update-parameters-only-after-successful-init.patch added to -mm tree
Date: Tue, 18 Oct 2011 14:45:21 -0700
Message-ID: <201110182145.p9ILjL6r013719@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:2351 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab1JRVpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 17:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kees@outflux.net, keescook@chromium.org, marco.stornelli@gmail.com, seiji.aguchi@hds.com, sergiu@chromium.org


The patch titled
     Subject: ramoops: update parameters only after successful init
has been added to the -mm tree.  Its filename is
     ramoops-update-parameters-only-after-successful-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: ramoops: update parameters only after successful init

Patches currently in -mm which might be from kees@outflux.net are

ramoops-update-parameters-only-after-successful-init.patch

