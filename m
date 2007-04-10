From: akpm@linux-foundation.org
Subject: + dtlk-fix-error-checks-in-module_init.patch added to -mm tree
Date: Mon, 09 Apr 2007 22:02:43 -0700
Message-ID: <200704100502.l3A52h2m031822@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44175 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbXDJFCu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 01:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, chris@allmedia.com, jrv@vanzandt.mv.com


The patch titled
     dtlk: fix error checks in module_init()
has been added to the -mm tree.  Its filename is
     dtlk-fix-error-checks-in-module_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dtlk: fix error checks in module_init()
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch fixes two things in module_init.

- fix register_chrdev() error check

  Currently dtlk doesn't check register_chrdev() failure correctly.
  register_chrdev() returns a errno on failure.

- check probe failure

  dtlk ignores probe failure and allows the module loading without
  such device. I got "Trying to free nonexistent resource" message
  by release_region() when unloading module without device.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Pallotta <chris@allmedia.com>
Cc: Jim Van Zandt <jrv@vanzandt.mv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/dtlk.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/char/dtlk.c~dtlk-fix-error-checks-in-module_init drivers/char/dtlk.c
--- a/drivers/char/dtlk.c~dtlk-fix-error-checks-in-module_init
+++ a/drivers/char/dtlk.c
@@ -324,16 +324,22 @@ static int dtlk_release(struct inode *in
 
 static int __init dtlk_init(void)
 {
+	int err;
+
 	dtlk_port_lpc = 0;
 	dtlk_port_tts = 0;
 	dtlk_busy = 0;
 	dtlk_major = register_chrdev(0, "dtlk", &dtlk_fops);
-	if (dtlk_major == 0) {
+	if (dtlk_major < 0) {
 		printk(KERN_ERR "DoubleTalk PC - cannot register device\n");
-		return 0;
+		return -EBUSY;
+	}
+	err = dtlk_dev_probe();
+	if (err) {
+		unregister_chrdev(dtlk_major, "dtlk");
+		return err;
 	}
-	if (dtlk_dev_probe() == 0)
-		printk(", MAJOR %d\n", dtlk_major);
+	printk(", MAJOR %d\n", dtlk_major);
 
 	init_waitqueue_head(&dtlk_process_list);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

auth_gss-unregister-gss_domain-when-unloading-module.patch
slob-handle-slab_panic-flag.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
dtlk-fix-error-checks-in-module_init-fix.patch
