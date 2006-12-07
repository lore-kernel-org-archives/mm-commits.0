From: akpm@osdl.org
Subject: - acpi-fix-symbol-conflict-between-acpiphp-and-dock.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:18:32 -0800
Message-ID: <200612072318.kB7NIWMm031038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54005 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163921AbWLGXSo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:18:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: ix symbol conflict between acpiphp and dock
has been removed from the -mm tree.  Its filename was
     acpi-fix-symbol-conflict-between-acpiphp-and-dock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: ix symbol conflict between acpiphp and dock
From: Prarit Bhargava <prarit@redhat.com>

Fix bug which will cause acpiphp to not be able to load when dock.ko cannot
   load.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/dock.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/dock.c~acpi-fix-symbol-conflict-between-acpiphp-and-dock drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-fix-symbol-conflict-between-acpiphp-and-dock
+++ a/drivers/acpi/dock.c
@@ -444,6 +444,9 @@ static int dock_in_progress(struct dock_
  */
 int register_dock_notifier(struct notifier_block *nb)
 {
+	if (!dock_station)
+		return -ENODEV;
+
 	return atomic_notifier_chain_register(&dock_notifier_list, nb);
 }
 
@@ -455,6 +458,9 @@ EXPORT_SYMBOL_GPL(register_dock_notifier
  */
 void unregister_dock_notifier(struct notifier_block *nb)
 {
+	if (!dock_station)
+		return;
+
 	atomic_notifier_chain_unregister(&dock_notifier_list, nb);
 }
 
@@ -807,7 +813,7 @@ static int __init dock_init(void)
 			    ACPI_UINT32_MAX, find_dock, &num, NULL);
 
 	if (!num)
-		return -ENODEV;
+		printk(KERN_INFO "No dock devices found.\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from prarit@redhat.com are

git-acpi.patch
tty-signal-tty-locking.patch

