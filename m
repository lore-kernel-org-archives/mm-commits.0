From: akpm@linux-foundation.org
Subject: [merged] ramoops-update-module-parameters.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:40 -0700
Message-ID: <201108161847.p7GIllqN015148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1HPSsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergiu@chromium.org, marco.stornelli@gmail.com, seiji.aguchi@hds.com, mm-commits@vger.kernel.org


The patch titled
     ramoops: update module parameters
has been removed from the -mm tree.  Its filename was
     ramoops-update-module-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

