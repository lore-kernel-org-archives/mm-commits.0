From: akpm@linux-foundation.org
Subject: [merged] ramoops-move-dump_oops-into-platform-data.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:31 -0700
Message-ID: <201107271928.p6RJSIT0003293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab1G0T2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergiu@chromium.org, Artem.Bityutskiy@nokia.com, darwish.07@gmail.com, kyungmin.park@samsung.com, marco.stornelli@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ramoops: move dump_oops into platform data
has been removed from the -mm tree.  Its filename was
     ramoops-move-dump_oops-into-platform-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramoops: move dump_oops into platform data
From: Sergiu Iordache <sergiu@chromium.org>

The platform driver currently allows setting the mem_size and mem_address.
 Since dump_oops is also a module parameter it would be more consistent if
it could be set through platform data as well.

Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c  |    5 ++++-
 include/linux/ramoops.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/char/ramoops.c~ramoops-move-dump_oops-into-platform-data drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-move-dump_oops-into-platform-data
+++ a/drivers/char/ramoops.c
@@ -55,6 +55,7 @@ static struct ramoops_context {
 	void *virt_addr;
 	phys_addr_t phys_addr;
 	unsigned long size;
+	int dump_oops;
 	int count;
 	int max_count;
 } oops_cxt;
@@ -80,7 +81,7 @@ static void ramoops_do_dump(struct kmsg_
 		return;
 
 	/* Only dump oopses if dump_oops is set */
-	if (reason == KMSG_DUMP_OOPS && !dump_oops)
+	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
 		return;
 
 	buf = cxt->virt_addr + (cxt->count * RECORD_SIZE);
@@ -128,6 +129,7 @@ static int __init ramoops_probe(struct p
 	cxt->count = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
+	cxt->dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		pr_err("request mem region failed\n");
@@ -194,6 +196,7 @@ static int __init ramoops_init(void)
 			return -ENOMEM;
 		dummy_data->mem_size = mem_size;
 		dummy_data->mem_address = mem_address;
+		dummy_data->dump_oops = dump_oops;
 		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
 			NULL, 0, dummy_data,
 			sizeof(struct ramoops_platform_data));
diff -puN include/linux/ramoops.h~ramoops-move-dump_oops-into-platform-data include/linux/ramoops.h
--- a/include/linux/ramoops.h~ramoops-move-dump_oops-into-platform-data
+++ a/include/linux/ramoops.h
@@ -10,6 +10,7 @@
 struct ramoops_platform_data {
 	unsigned long	mem_size;
 	unsigned long	mem_address;
+	int		dump_oops;
 };
 
 #endif
_

Patches currently in -mm which might be from sergiu@chromium.org are

origin.patch

