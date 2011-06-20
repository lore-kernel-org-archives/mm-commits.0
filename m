From: akpm@linux-foundation.org
Subject: + ramoops-add-new-line-to-each-print.patch added to -mm tree
Date: Mon, 20 Jun 2011 12:24:23 -0700
Message-ID: <201106201924.p5KJONr6013455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139Ab1FTTY7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 15:24:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marco.stornelli@gmail.com, joe@perches.com, kyungmin.park@samsung.com, stevie.trujillo@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     ramoops: add new line to each print
has been added to the -mm tree.  Its filename is
     ramoops-add-new-line-to-each-print.patch

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
Subject: ramoops: add new line to each print
=46rom: Marco Stornelli <marco.stornelli@gmail.com>

Add new line to each print.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-add-new-line-to-each-print dri=
vers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-add-new-line-to-each-print
+++ a/drivers/char/ramoops.c
@@ -19,6 +19,8 @@
  *
  */
=20
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kmsg_dump.h>
@@ -110,14 +112,14 @@ static int __init ramoops_probe(struct p
 	int err =3D -EINVAL;
=20
 	if (!pdata->mem_size) {
-		printk(KERN_ERR "ramoops: invalid size specification");
+		pr_err("invalid size specification\n");
 		goto fail3;
 	}
=20
 	rounddown_pow_of_two(pdata->mem_size);
=20
 	if (pdata->mem_size < RECORD_SIZE) {
-		printk(KERN_ERR "ramoops: size too small");
+		pr_err("size too small\n");
 		goto fail3;
 	}
=20
@@ -127,21 +129,21 @@ static int __init ramoops_probe(struct p
 	cxt->phys_addr =3D pdata->mem_address;
=20
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
-		printk(KERN_ERR "ramoops: request mem region failed");
+		pr_err("request mem region failed\n");
 		err =3D -EINVAL;
 		goto fail3;
 	}
=20
 	cxt->virt_addr =3D ioremap(cxt->phys_addr,  cxt->size);
 	if (!cxt->virt_addr) {
-		printk(KERN_ERR "ramoops: ioremap failed");
+		pr_err("ioremap failed\n");
 		goto fail2;
 	}
=20
 	cxt->dump.dump =3D ramoops_do_dump;
 	err =3D kmsg_dump_register(&cxt->dump);
 	if (err) {
-		printk(KERN_ERR "ramoops: registering kmsg dumper failed");
+		pr_err("registering kmsg dumper failed\n");
 		goto fail1;
 	}
=20
@@ -160,7 +162,7 @@ static int __exit ramoops_remove(struct=20
 	struct ramoops_context *cxt =3D &oops_cxt;
=20
 	if (kmsg_dump_unregister(&cxt->dump) < 0)
-		printk(KERN_WARNING "ramoops: could not unregister kmsg_dumper");
+		pr_warn("could not unregister kmsg_dumper\n");
=20
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);
@@ -184,6 +186,7 @@ static int __init ramoops_init(void)
 		 * If we didn't find a platform device, we use module parameters
 		 * building platform data on the fly.
 		 */
+		pr_info("platform device not found, using module parameters\n");
 		dummy_data =3D kzalloc(sizeof(struct ramoops_platform_data),
 				     GFP_KERNEL);
 		if (!dummy_data)
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
