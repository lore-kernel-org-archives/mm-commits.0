From: akpm@linux-foundation.org
Subject: + ramoops-update-module-parameters.patch added to -mm tree
Date: Mon, 01 Aug 2011 14:57:39 -0700
Message-ID: <201108012157.p71LvdfX016949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab1HAV6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 17:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergiu@chromium.org, marco.stornelli@gmail.com, seiji.aguchi@hds.com


The patch titled
     ramoops: update module parameters
has been added to the -mm tree.  Its filename is
     ramoops-update-module-parameters.patch

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
Subject: ramoops: update module parameters
From: Sergiu Iordache <sergiu@chromium.org>

Update the module parameters when platform data is used.  This means that
they can be read from /sys/module/ramoops/parameters in order to parse the
memory area.

Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/char/ramoops.c~ramoops-update-module-parameters drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-update-module-parameters
+++ a/drivers/char/ramoops.c
@@ -147,6 +147,14 @@ static int __init ramoops_probe(struct p
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
+	/*
+	 * Update the module parameter variables as well so they are visible
+	 * through /sys/module/ramoops/parameters/
+	 */
+	mem_size = pdata->mem_size;
+	mem_address = pdata->mem_address;
+	record_size = pdata->record_size;
+	dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		pr_err("request mem region failed\n");
_

Patches currently in -mm which might be from sergiu@chromium.org are

origin.patch
ramoops-update-module-parameters.patch

