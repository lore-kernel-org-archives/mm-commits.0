From: akpm@linux-foundation.org
Subject: + ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch added to -mm tree
Date: Mon, 20 Jun 2011 12:55:41 -0700
Message-ID: <201106201955.p5KJtff0015001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab1FTTzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 15:55:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marco.stornelli@gmail.com, joe@perches.com, kyungmin.park@samsung.com, stevie.trujillo@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     ramoops: use module parameters instead of platform data if not ava=
ilable
has been added to the -mm tree.  Its filename is
     ramoops-use-module-parameters-instead-of-platform-data-if-not-avai=
lable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: ramoops: use module parameters instead of platform data if not=
 available
=46rom: Marco Stornelli <marco.stornelli@gmail.com>

Use generic module parameters instead of platform data, if platform dat=
a
are not available.  This limitation has been introduced with commit
c3b92ce9e75 ("ramoops: use the platform data structure instead of modul=
e
params").

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |   48 +++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-use-module-parameters-instead-=
of-platform-data-if-not-available drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-use-module-parameters-instead-of-p=
latform-data-if-not-available
+++ a/drivers/char/ramoops.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/ramoops.h>
=20
 #define RAMOOPS_KERNMSG_HDR "=3D=3D=3D=3D"
@@ -56,6 +57,9 @@ static struct ramoops_context {
 	int max_count;
 } oops_cxt;
=20
+static struct platform_device *dummy;
+static struct ramoops_platform_data *dummy_data;
+
 static void ramoops_do_dump(struct kmsg_dumper *dumper,
 		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
 		const char *s2, unsigned long l2)
@@ -105,27 +109,22 @@ static int __init ramoops_probe(struct p
 	struct ramoops_context *cxt =3D &oops_cxt;
 	int err =3D -EINVAL;
=20
-	if (pdata) {
-		mem_size =3D pdata->mem_size;
-		mem_address =3D pdata->mem_address;
-	}
-
-	if (!mem_size) {
+	if (!pdata->mem_size) {
 		printk(KERN_ERR "ramoops: invalid size specification");
 		goto fail3;
 	}
=20
-	rounddown_pow_of_two(mem_size);
+	rounddown_pow_of_two(pdata->mem_size);
=20
-	if (mem_size < RECORD_SIZE) {
+	if (pdata->mem_size < RECORD_SIZE) {
 		printk(KERN_ERR "ramoops: size too small");
 		goto fail3;
 	}
=20
-	cxt->max_count =3D mem_size / RECORD_SIZE;
+	cxt->max_count =3D pdata->mem_size / RECORD_SIZE;
 	cxt->count =3D 0;
-	cxt->size =3D mem_size;
-	cxt->phys_addr =3D mem_address;
+	cxt->size =3D pdata->mem_size;
+	cxt->phys_addr =3D pdata->mem_address;
=20
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		printk(KERN_ERR "ramoops: request mem region failed");
@@ -178,12 +177,37 @@ static struct platform_driver ramoops_dr
=20
 static int __init ramoops_init(void)
 {
-	return platform_driver_probe(&ramoops_driver, ramoops_probe);
+	int ret;
+	ret =3D platform_driver_probe(&ramoops_driver, ramoops_probe);
+	if (ret =3D=3D -ENODEV)
+	{
+		/*
+		 * if we didn't find a platform device, we use module parameters
+		 * building platform data on the fly.
+		 */
+		dummy_data =3D kzalloc(sizeof(struct ramoops_platform_data),
+				     GFP_KERNEL);
+		if (!dummy_data)
+			return -ENOMEM;
+		dummy_data->mem_size =3D mem_size;
+		dummy_data->mem_address =3D mem_address;
+		dummy =3D platform_create_bundle(&ramoops_driver, ramoops_probe,
+			NULL, 0, dummy_data,
+			sizeof(struct ramoops_platform_data));
+
+		if (IS_ERR(dummy))
+			ret =3D PTR_ERR(dummy);
+		else
+			ret =3D 0;
+	}
+
+	return ret;
 }
=20
 static void __exit ramoops_exit(void)
 {
 	platform_driver_unregister(&ramoops_driver);
+	kfree(dummy_data);
 }
=20
 module_init(ramoops_init);
_

Patches currently in -mm which might be from marco.stornelli@gmail.com =
are

ramoops-use-module-parameters-instead-of-platform-data-if-not-available=
=2Epatch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available=
-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
