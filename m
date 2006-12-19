From: akpm@osdl.org
Subject: - ata-fix-platform_device_register_simple-error-check.patch removed from -mm tree
Date: Tue, 19 Dec 2006 12:31:38 -0800
Message-ID: <200612192031.kBJKVcQO009506@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60860 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbWLSUfS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:35:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, alan@lxorguk.ukuu.org.uk, jgarzik@pobox.com, mm-commits@vger.kernel.org


The patch titled
     ata: fix platform_device_register_simple() error check
has been removed from the -mm tree.  Its filename was
     ata-fix-platform_device_register_simple-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata: fix platform_device_register_simple() error check
From: Akinobu Mita <akinobu.mita@gmail.com>

The return value of platform_device_register_simple() should be checked
by IS_ERR().

Cc: Jeff Garzik <jgarzik@pobox.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/pata_legacy.c  |    4 +++-
 drivers/ata/pata_qdi.c     |    4 ++--
 drivers/ata/pata_winbond.c |    4 ++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/ata/pata_legacy.c~ata-fix-platform_device_register_simple-error-check drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~ata-fix-platform_device_register_simple-error-check
+++ a/drivers/ata/pata_legacy.c
@@ -698,8 +698,10 @@ static __init int legacy_init_one(int po
 		goto fail_io;
 
 	pdev = platform_device_register_simple(DRV_NAME, nr_legacy_host, NULL, 0);
-	if (pdev == NULL)
+	if (IS_ERR(pdev)) {
+		ret = PTR_ERR(pdev);
 		goto fail_dev;
+	}
 
 	if (ht6560a & mask) {
 		ops = &ht6560a_port_ops;
diff -puN drivers/ata/pata_qdi.c~ata-fix-platform_device_register_simple-error-check drivers/ata/pata_qdi.c
--- a/drivers/ata/pata_qdi.c~ata-fix-platform_device_register_simple-error-check
+++ a/drivers/ata/pata_qdi.c
@@ -247,8 +247,8 @@ static __init int qdi_init_one(unsigned 
 	 */
 
 	pdev = platform_device_register_simple(DRV_NAME, nr_qdi_host, NULL, 0);
-	if (pdev == NULL)
-		return -ENOMEM;
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
 
 	memset(&ae, 0, sizeof(struct ata_probe_ent));
 	INIT_LIST_HEAD(&ae.node);
diff -puN drivers/ata/pata_winbond.c~ata-fix-platform_device_register_simple-error-check drivers/ata/pata_winbond.c
--- a/drivers/ata/pata_winbond.c~ata-fix-platform_device_register_simple-error-check
+++ a/drivers/ata/pata_winbond.c
@@ -206,8 +206,8 @@ static __init int winbond_init_one(unsig
 			 */
 
 			pdev = platform_device_register_simple(DRV_NAME, nr_winbond_host, NULL, 0);
-			if (pdev == NULL)
-				return -ENOMEM;
+			if (IS_ERR(pdev))
+				return PTR_ERR(pdev);
 
 			memset(&ae, 0, sizeof(struct ata_probe_ent));
 			INIT_LIST_HEAD(&ae.node);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
acpi-fix-single-linked-list-manipulation.patch
acpi-processor-prevent-loading-module-on-failures.patch
git-alsa.patch
audit-fix-kstrdup-error-check.patch
git-drm.patch
ata-fix-platform_device_register_simple-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
gss_spkm3-fix-error-handling-in-module-init.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch

