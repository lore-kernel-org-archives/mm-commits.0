From: akpm@linux-foundation.org
Subject: + ehea-fix-workqueue-handling.patch added to -mm tree
Date: Tue, 07 Aug 2007 16:20:07 -0700
Message-ID: <200708072320.l77NK72x010113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbXHGXUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 19:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: osstklei@de.ibm.com, tklein@de.ibm.com


The patch titled
     ehea: fix workqueue handling
has been added to the -mm tree.  Its filename is
     ehea-fix-workqueue-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehea: fix workqueue handling
From: Thomas Klein <osstklei@de.ibm.com>

Fix: Workqueue ehea_driver_wq was not destroyed

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/ehea/ehea.h~ehea-fix-workqueue-handling drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~ehea-fix-workqueue-handling
+++ a/drivers/net/ehea/ehea.h
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0072"
+#define DRV_VERSION	"EHEA_0073"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
diff -puN drivers/net/ehea/ehea_main.c~ehea-fix-workqueue-handling drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-fix-workqueue-handling
+++ a/drivers/net/ehea/ehea_main.c
@@ -3099,6 +3099,7 @@ out:
 
 static void __exit ehea_module_exit(void)
 {
+	destroy_workqueue(ehea_driver_wq);
 	driver_remove_file(&ehea_driver.driver, &driver_attr_capabilities);
 	ibmebus_unregister_driver(&ehea_driver);
 	ehea_destroy_busmap();
_

Patches currently in -mm which might be from osstklei@de.ibm.com are

ehea-fix-workqueue-handling.patch
ehea-simplify-resource-usage-check.patch
ehea-eliminated-some-compiler-warnings.patch
