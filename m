From: akpm@linux-foundation.org
Subject: + cm4000_cs-fix-error-paths.patch added to -mm tree
Date: Thu, 03 May 2007 13:49:24 -0700
Message-ID: <200705032049.l43KnOHn019174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031206AbXECUwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 16:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, laforge@gnumonks.org, linux@dominikbrodowski.net


The patch titled
     cm4000_cs: fix error paths
has been added to the -mm tree.  Its filename is
     cm4000_cs-fix-error-paths.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cm4000_cs: fix error paths
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch fixes error paths in module_init and probe functions in cm4000_cs
and cm4040_cs drivers.

Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/cm4000_cs.c |    9 +++++++--
 drivers/char/pcmcia/cm4040_cs.c |    7 ++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/char/pcmcia/cm4000_cs.c~cm4000_cs-fix-error-paths drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~cm4000_cs-fix-error-paths
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -1881,8 +1881,11 @@ static int cm4000_probe(struct pcmcia_de
 	init_waitqueue_head(&dev->readq);
 
 	ret = cm4000_config(link, i);
-	if (ret)
+	if (ret) {
+		dev_table[i] = NULL;
+		kfree(dev);
 		return ret;
+	}
 
 	class_device_create(cmm_class, NULL, MKDEV(major, i), NULL,
 			    "cmm%d", i);
@@ -1907,7 +1910,7 @@ static void cm4000_detach(struct pcmcia_
 	cm4000_release(link);
 
 	dev_table[devno] = NULL;
- 	kfree(dev);
+	kfree(dev);
 
 	class_device_destroy(cmm_class, MKDEV(major, devno));
 
@@ -1956,12 +1959,14 @@ static int __init cmm_init(void)
 	if (major < 0) {
 		printk(KERN_WARNING MODULE_NAME
 			": could not get major number\n");
+		class_destroy(cmm_class);
 		return major;
 	}
 
 	rc = pcmcia_register_driver(&cm4000_driver);
 	if (rc < 0) {
 		unregister_chrdev(major, DEVICE_NAME);
+		class_destroy(cmm_class);
 		return rc;
 	}
 
diff -puN drivers/char/pcmcia/cm4040_cs.c~cm4000_cs-fix-error-paths drivers/char/pcmcia/cm4040_cs.c
--- a/drivers/char/pcmcia/cm4040_cs.c~cm4000_cs-fix-error-paths
+++ a/drivers/char/pcmcia/cm4040_cs.c
@@ -636,8 +636,11 @@ static int reader_probe(struct pcmcia_de
 	setup_timer(&dev->poll_timer, cm4040_do_poll, 0);
 
 	ret = reader_config(link, i);
-	if (ret)
+	if (ret) {
+		dev_table[i] = NULL;
+		kfree(dev);
 		return ret;
+	}
 
 	class_device_create(cmx_class, NULL, MKDEV(major, i), NULL,
 			    "cmx%d", i);
@@ -708,12 +711,14 @@ static int __init cm4040_init(void)
 	if (major < 0) {
 		printk(KERN_WARNING MODULE_NAME
 			": could not get major number\n");
+		class_destroy(cmx_class);
 		return major;
 	}
 
 	rc = pcmcia_register_driver(&reader_driver);
 	if (rc < 0) {
 		unregister_chrdev(major, DEVICE_NAME);
+		class_destroy(cmx_class);
 		return rc;
 	}
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
slob-handle-slab_panic-flag.patch
fault-injection-fix-failslab-with-config_numa.patch
hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch
slob-fix-page-order-calculation-on-not-4kb-page.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
fault-injection-enable-stacktrace-with-dwarf2-unwinder.patch
use-slab_panic-flag-cleanup.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
procfs-use-simple_read_from_buffer.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch
