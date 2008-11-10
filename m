From: akpm@linux-foundation.org
Subject: - fujitsu-laptop-fix-section-mismatch-warning.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:51 -0800
Message-ID: <200811102033.mAAKXpxP024736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438AbYKJUei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jwoithe@physics.adelaide.edu.au, mm-commits@vger.kernel.org


The patch titled
     fujitsu-laptop: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     fujitsu-laptop-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fujitsu-laptop: fix section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Could fix a bug in a hotplug add scenario.

WARNING: drivers/misc/fujitsu-laptop.o(.text+0xbde): Section mismatch in reference from the function acpi_fujitsu_add() to the variable .init.data:fujitsu_dmi_table
The function acpi_fujitsu_add() references
the variable __initdata fujitsu_dmi_table.
This is often because acpi_fujitsu_add lacks a __initdata
annotation or the annotation of fujitsu_dmi_table is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/fujitsu-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/fujitsu-laptop.c~fujitsu-laptop-fix-section-mismatch-warning drivers/misc/fujitsu-laptop.c
--- a/drivers/misc/fujitsu-laptop.c~fujitsu-laptop-fix-section-mismatch-warning
+++ a/drivers/misc/fujitsu-laptop.c
@@ -473,7 +473,7 @@ static int dmi_check_cb_p8010(const stru
 	return 0;
 }
 
-static struct dmi_system_id __initdata fujitsu_dmi_table[] = {
+static struct dmi_system_id fujitsu_dmi_table[] = {
 	{
 	 .ident = "Fujitsu Siemens S6410",
 	 .matches = {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
doc-add-printk-formatstxt.patch
doc-add-printk-formatstxt-fix.patch
doc-update-xip-method-info.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch

