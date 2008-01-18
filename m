From: akpm@linux-foundation.org
Subject: + aha152x-fix-isa-pcmcia-compile-problem.patch added to -mm tree
Date: Thu, 17 Jan 2008 17:13:10 -0800
Message-ID: <200801180113.m0I1DAZ7024015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbYARBNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 20:13:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     git-scsi-misc: aha152x: fix isa/pcmcia compile problem
has been added to the -mm tree.  Its filename is
     aha152x-fix-isa-pcmcia-compile-problem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-scsi-misc: aha152x: fix isa/pcmcia compile problem
From: Tejun Heo <htejun@gmail.com>

aha152x.c is built twice - once for the isa driver and once for the
PCMCIA one.  Through #ifdefs, the compiled codes are slightly
depending on which flavor is being built.  This patch adds GLOBAL()
macro to aha152x.h which changes the symbol depending on PCMCIA.

This bug has always existed but has been masked by the fact the
drivers/scsi/pcmcia used subdir-(y|m) instead of obj-(y|m) which made
drivers/scsi/pcmcia/built_in.o not linked into the kernel and thus
avoided the duplicate symbols during compilation.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aha152x.c             |   12 ++++++------
 drivers/scsi/aha152x.h             |   20 +++++++++++++++++---
 drivers/scsi/pcmcia/aha152x_stub.c |   10 ++++++----
 3 files changed, 29 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/aha152x.c~aha152x-fix-isa-pcmcia-compile-problem drivers/scsi/aha152x.c
--- a/drivers/scsi/aha152x.c~aha152x-fix-isa-pcmcia-compile-problem
+++ a/drivers/scsi/aha152x.c
@@ -768,7 +768,7 @@ static irqreturn_t swintr(int irqno, voi
 	return IRQ_HANDLED;
 }
 
-struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
+struct Scsi_Host *GLOBAL(aha152x_probe_one)(struct aha152x_setup *setup)
 {
 	struct Scsi_Host *shpnt;
 
@@ -904,7 +904,7 @@ out_host_put:
 	return NULL;
 }
 
-void aha152x_release(struct Scsi_Host *shpnt)
+void GLOBAL(aha152x_release)(struct Scsi_Host *shpnt)
 {
 	if (!shpnt)
 		return;
@@ -1320,7 +1320,7 @@ static void reset_ports(struct Scsi_Host
  * Reset the host (bus and controller)
  *
  */
-int aha152x_host_reset_host(struct Scsi_Host *shpnt)
+int GLOBAL(aha152x_host_reset_host)(struct Scsi_Host *shpnt)
 {
 	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: host reset\n", shpnt->host_no);
 
@@ -1338,7 +1338,7 @@ int aha152x_host_reset_host(struct Scsi_
  */
 static int aha152x_host_reset(Scsi_Cmnd *SCpnt)
 {
-	return aha152x_host_reset_host(SCpnt->device->host);
+	return GLOBAL(aha152x_host_reset_host)(SCpnt->device->host);
 }
 
 /*
@@ -3894,7 +3894,7 @@ static int __init aha152x_init(void)
 
 	for (i=0; i<setup_count; i++) {
 		if ( request_region(setup[i].io_port, IO_RANGE, "aha152x") ) {
-			struct Scsi_Host *shpnt = aha152x_probe_one(&setup[i]);
+			struct Scsi_Host *shpnt = GLOBAL(aha152x_probe_one)(&setup[i]);
 
 			if( !shpnt ) {
 				release_region(setup[i].io_port, IO_RANGE);
@@ -3924,7 +3924,7 @@ static void __exit aha152x_exit(void)
 	list_for_each_entry(hd, &aha152x_host_list, host_list) {
 		struct Scsi_Host *shost = container_of((void *)hd, struct Scsi_Host, hostdata);
 
-		aha152x_release(shost);
+		GLOBAL(aha152x_release)(shost);
 	}
 }
 
diff -puN drivers/scsi/aha152x.h~aha152x-fix-isa-pcmcia-compile-problem drivers/scsi/aha152x.h
--- a/drivers/scsi/aha152x.h~aha152x-fix-isa-pcmcia-compile-problem
+++ a/drivers/scsi/aha152x.h
@@ -330,8 +330,22 @@ struct aha152x_setup {
 	char *conf;
 };
 
-struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *);
-void aha152x_release(struct Scsi_Host *);
-int aha152x_host_reset_host(struct Scsi_Host *);
+/*
+ * This file and aha152x.c are compiled in two different ways - for
+ * the isa driver and pcmcia one.  When building the pcmcia one, the
+ * file is slightly modified, so they can't share the same object
+ * file.  The following macro alters a symbol depending on whether
+ * pcmcia driver is being built or not and should be used for any
+ * global symbol.
+ */
+#if defined(PCMCIA)
+#define GLOBAL(x)	CS_##x
+#else
+#define GLOBAL(x)	x
+#endif
+
+struct Scsi_Host *GLOBAL(aha152x_probe_one)(struct aha152x_setup *);
+void GLOBAL(aha152x_release)(struct Scsi_Host *);
+int GLOBAL(aha152x_host_reset_host)(struct Scsi_Host *);
 
 #endif /* _AHA152X_H */
diff -puN drivers/scsi/pcmcia/aha152x_stub.c~aha152x-fix-isa-pcmcia-compile-problem drivers/scsi/pcmcia/aha152x_stub.c
--- a/drivers/scsi/pcmcia/aha152x_stub.c~aha152x-fix-isa-pcmcia-compile-problem
+++ a/drivers/scsi/pcmcia/aha152x_stub.c
@@ -47,13 +47,15 @@
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
-#include "aha152x.h"
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
 
+#define PCMCIA	1
+#include "aha152x.h"
+
 #ifdef PCMCIA_DEBUG
 static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0644);
@@ -194,7 +196,7 @@ static int aha152x_config_cs(struct pcmc
     if (ext_trans)
         s.ext_trans = ext_trans;
 
-    host = aha152x_probe_one(&s);
+    host = GLOBAL(aha152x_probe_one)(&s);
     if (host == NULL) {
 	printk(KERN_INFO "aha152x_cs: no SCSI devices found\n");
 	goto cs_failed;
@@ -216,7 +218,7 @@ static void aha152x_release_cs(struct pc
 {
 	scsi_info_t *info = link->priv;
 
-	aha152x_release(info->host);
+	GLOBAL(aha152x_release)(info->host);
 	pcmcia_disable_device(link);
 }
 
@@ -224,7 +226,7 @@ static int aha152x_resume(struct pcmcia_
 {
 	scsi_info_t *info = link->priv;
 
-	aha152x_host_reset_host(info->host);
+	GLOBAL(aha152x_host_reset_host)(info->host);
 
 	return 0;
 }
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-kbuild.patch
git-libata-all.patch
git-scsi-misc.patch
aha152x-fix-isa-pcmcia-compile-problem.patch
