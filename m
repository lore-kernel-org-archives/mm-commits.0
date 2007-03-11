From: akpm@linux-foundation.org
Subject: + 3c59x-fix-several-modpost-warnings.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:46:12 -0800
Message-ID: <200703110946.l2B9kCtY009142@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41826 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXCKJta (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     3c59x: fix several modpost warnings
has been added to the -mm tree.  Its filename is
     3c59x-fix-several-modpost-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 3c59x: fix several modpost warnings
From: Ralf Baechle <ralf@linux-mips.org>

WARNING: drivers/net/3c59x.o - Section mismatch: reference to .init.text: from .text between 'vortex_eisa_probe' (at offset 0x4580) and 'vortex_eisa_remove'
WARNING: drivers/net/3c59x.o - Section mismatch: reference to .init.text: from .text between 'vortex_eisa_probe' (at offset 0x4584) and 'vortex_eisa_remove'
WARNING: drivers/net/3c59x.o - Section mismatch: reference to .init.text: from .text between 'vortex_eisa_probe' (at offset 0x4588) and 'vortex_eisa_remove'
WARNING: drivers/net/3c59x.o - Section mismatch: reference to .init.text: from .text between 'vortex_eisa_probe' (at offset 0x458c) and 'vortex_eisa_remove'

Fixed by:

 o move definition of vortex_eisa_driver below the functions it references.
 o remove now unnecessary prototypes for vortex_eisa_probe and
   vortex_eisa_remove.
 o Make vortex_eisa_probe an __init function.
 o Make vortex_eisa_remove a __devexit function.
 o Wrap vortex_eisa_driver reference to vortex_eisa_remove with
   __devexit_p().

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN drivers/net/3c59x.c~3c59x-fix-several-modpost-warnings drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3c59x-fix-several-modpost-warnings
+++ a/drivers/net/3c59x.c
@@ -857,19 +857,7 @@ static struct eisa_device_id vortex_eisa
 };
 MODULE_DEVICE_TABLE(eisa, vortex_eisa_ids);
 
-static int vortex_eisa_probe(struct device *device);
-static int vortex_eisa_remove(struct device *device);
-
-static struct eisa_driver vortex_eisa_driver = {
-	.id_table = vortex_eisa_ids,
-	.driver   = {
-		.name    = "3c59x",
-		.probe   = vortex_eisa_probe,
-		.remove  = vortex_eisa_remove
-	}
-};
-
-static int vortex_eisa_probe(struct device *device)
+static int __init vortex_eisa_probe(struct device *device)
 {
 	void __iomem *ioaddr;
 	struct eisa_device *edev;
@@ -892,7 +880,7 @@ static int vortex_eisa_probe(struct devi
 	return 0;
 }
 
-static int vortex_eisa_remove(struct device *device)
+static int __devexit vortex_eisa_remove(struct device *device)
 {
 	struct eisa_device *edev;
 	struct net_device *dev;
@@ -917,7 +905,17 @@ static int vortex_eisa_remove(struct dev
 	free_netdev(dev);
 	return 0;
 }
-#endif
+
+static struct eisa_driver vortex_eisa_driver = {
+	.id_table = vortex_eisa_ids,
+	.driver   = {
+		.name    = "3c59x",
+		.probe   = vortex_eisa_probe,
+		.remove  = __devexit_p(vortex_eisa_remove)
+	}
+};
+
+#endif /* CONFIG_EISA */
 
 /* returns count found (>= 0), or negative on error */
 static int __init vortex_eisa_init(void)
_

Patches currently in -mm which might be from ralf@linux-mips.org are

git-netdev-all.patch
netxen-fix-warnings.patch
3c59x-fix-several-modpost-warnings.patch
div64_64-common-code.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
hda_intel-build-fix.patch
ice1712-build-fixes.patch
simplify-the-stacktrace-code.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
tgafb-turbochannel-support.patch
