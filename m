From: akpm@linux-foundation.org
Subject: + ramoops-make-record_size-a-module-parameter.patch added to -mm tree
Date: Thu, 07 Jul 2011 13:01:52 -0700
Message-ID: <201107072001.p67K1qc4010657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624Ab1GGUCB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2011 16:02:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergiu@chromium.org, Artem.Bityutskiy@nokia.com, darwish.07@gmail.com, kyungmin.park@samsung.com, marco.stornelli@gmail.com


The patch titled
     ramoops: make record_size a module parameter
has been added to the -mm tree.  Its filename is
     ramoops-make-record_size-a-module-parameter.patch

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
Subject: ramoops: make record_size a module parameter
From: Sergiu Iordache <sergiu@chromium.org>

The size of the dump is currently set using the RECORD_SIZE macro which is
set to a page size.  This patch makes the record size a module parameter
and allows it to be set through platform data as well to allow larger
dumps if needed.

Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c  |   37 +++++++++++++++++++++++++++----------
 include/linux/ramoops.h |    1 +
 2 files changed, 28 insertions(+), 10 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-make-record_size-a-module-parameter drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-make-record_size-a-module-parameter
+++ a/drivers/char/ramoops.c
@@ -32,8 +32,12 @@
 #include <linux/ramoops.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
+#define MIN_MEM_SIZE 4096UL
 
-#define RECORD_SIZE 4096UL
+static ulong record_size = MIN_MEM_SIZE;
+module_param(record_size, ulong, 0400);
+MODULE_PARM_DESC(record_size,
+		"size of each dump done on oops/panic");
 
 static ulong mem_address;
 module_param(mem_address, ulong, 0400);
@@ -55,6 +59,7 @@ static struct ramoops_context {
 	void *virt_addr;
 	phys_addr_t phys_addr;
 	unsigned long size;
+	unsigned long record_size;
 	int dump_oops;
 	int count;
 	int max_count;
@@ -83,10 +88,10 @@ static void ramoops_do_dump(struct kmsg_
 	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
 		return;
 
-	buf = cxt->virt_addr + (cxt->count * RECORD_SIZE);
+	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
 	buf_orig = buf;
 
-	memset(buf, '\0', RECORD_SIZE);
+	memset(buf, '\0', cxt->record_size);
 	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
 	buf += res;
 	do_gettimeofday(&timestamp);
@@ -94,8 +99,8 @@ static void ramoops_do_dump(struct kmsg_
 	buf += res;
 
 	hdr_size = buf - buf_orig;
-	l2_cpy = min(l2, RECORD_SIZE - hdr_size);
-	l1_cpy = min(l1, RECORD_SIZE - hdr_size - l2_cpy);
+	l2_cpy = min(l2, cxt->record_size - hdr_size);
+	l1_cpy = min(l1, cxt->record_size - hdr_size - l2_cpy);
 
 	s2_start = l2 - l2_cpy;
 	s1_start = l1 - l1_cpy;
@@ -112,22 +117,33 @@ static int __init ramoops_probe(struct p
 	struct ramoops_context *cxt = &oops_cxt;
 	int err = -EINVAL;
 
-	if (!pdata->mem_size) {
-		pr_err("invalid size specification\n");
+	if (!pdata->mem_size || !pdata->record_size) {
+		pr_err("The memory size and the record size must be "
+			"non-zero\n");
 		goto fail3;
 	}
 
 	rounddown_pow_of_two(pdata->mem_size);
+	rounddown_pow_of_two(pdata->record_size);
 
-	if (pdata->mem_size < RECORD_SIZE) {
-		pr_err("size too small\n");
+	/* Check for the minimum memory size */
+	if (pdata->mem_size < MIN_MEM_SIZE &&
+			pdata->record_size < MIN_MEM_SIZE) {
+		pr_err("memory size too small, minium is %lu\n", MIN_MEM_SIZE);
 		goto fail3;
 	}
 
-	cxt->max_count = pdata->mem_size / RECORD_SIZE;
+	if (pdata->mem_size < pdata->record_size) {
+		pr_err("The memory size must be larger than the "
+			"records size\n");
+		goto fail3;
+	}
+
+	cxt->max_count = pdata->mem_size / pdata->record_size;
 	cxt->count = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
+	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
@@ -195,6 +211,7 @@ static int __init ramoops_init(void)
 			return -ENOMEM;
 		dummy_data->mem_size = mem_size;
 		dummy_data->mem_address = mem_address;
+		dummy_data->record_size = record_size;
 		dummy_data->dump_oops = dump_oops;
 		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
 			NULL, 0, dummy_data,
diff -puN include/linux/ramoops.h~ramoops-make-record_size-a-module-parameter include/linux/ramoops.h
--- a/include/linux/ramoops.h~ramoops-make-record_size-a-module-parameter
+++ a/include/linux/ramoops.h
@@ -10,6 +10,7 @@
 struct ramoops_platform_data {
 	unsigned long	mem_size;
 	unsigned long	mem_address;
+	unsigned long	record_size;
 	int		dump_oops;
 };
 
_

Patches currently in -mm which might be from sergiu@chromium.org are

ramoops-move-dump_oops-into-platform-data.patch
ramoops-make-record_size-a-module-parameter.patch
ramoops-add-debugfs-entry.patch

