From: akpm@linux-foundation.org
Subject: + acpi-dock-use-null-for-pointer.patch added to -mm tree
Date: Wed, 21 Mar 2007 22:17:19 -0800
Message-ID: <200703220617.l2M6HJLd013765@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbXCVGSf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 02:18:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, lenb@kernel.org


The patch titled
     acpi/dock: use NULL for pointer
has been added to the -mm tree.  Its filename is
     acpi-dock-use-null-for-pointer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi/dock: use NULL for pointer
From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointers:
drivers/acpi/dock.c:677:75: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/dock.c~acpi-dock-use-null-for-pointer drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-use-null-for-pointer
+++ a/drivers/acpi/dock.c
@@ -29,6 +29,7 @@
 #include <linux/notifier.h>
 #include <linux/platform_device.h>
 #include <linux/jiffies.h>
+#include <linux/stddef.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -674,7 +675,7 @@ static ssize_t show_dock_uid(struct devi
 			     struct device_attribute *attr, char *buf)
 {
 	unsigned long lbuf;
-	acpi_status status = acpi_evaluate_integer(dock_station->handle, "_UID", 0, &lbuf);
+	acpi_status status = acpi_evaluate_integer(dock_station->handle, "_UID", NULL, &lbuf);
 	if(ACPI_FAILURE(status)) {
 	    return 0;
 	}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-drm.patch
git-libata-all.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
unionfs-sioq-not-__exit.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
ptrace-needs-proc_fs.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
ipwireless-use-ansi-func-decl.patch
cpuidle-unsigned-bitfield.patch
acpi-dock-use-null-for-pointer.patch
ext4-use-null-for-pointers.patch
nozomi-use-null-for-pointers.patch
