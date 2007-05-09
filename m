From: akpm@linux-foundation.org
Subject: - dtlk-fix-error-checks-in-module_init.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:25 -0700
Message-ID: <200705090249.l492nPgY009220@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967369AbXEICtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, chris@allmedia.com, jrv@vanzandt.mv.com, mm-commits@vger.kernel.org


The patch titled
     dtlk: fix error checks in module_init()
has been removed from the -mm tree.  Its filename was
     dtlk-fix-error-checks-in-module_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix error code return]
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
+		return dtlk_major;
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

origin.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch
