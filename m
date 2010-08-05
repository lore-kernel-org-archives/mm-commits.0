From: akpm@linux-foundation.org
Subject: + scsi-remove-fake-address-of-expression.patch added to -mm tree
Date: Thu, 05 Aug 2010 16:35:12 -0700
Message-ID: <201008052335.o75NZC5P012350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758196Ab0HEXgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 19:36:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu


The patch titled
     scsi: remove fake "address-of" expression
has been added to the -mm tree.  Its filename is
     scsi-remove-fake-address-of-expression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: remove fake "address-of" expression
From: Alan Stern <stern@rowland.harvard.edu>

Fake "address-of" expressions that evaluate to NULL generally confuse
readers and can provoke compiler warnings.  This patch (as1411) removes
one such fake expression, using an "#ifdef" in its place.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_priv.h  |    2 --
 drivers/scsi/scsi_sysfs.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_priv.h~scsi-remove-fake-address-of-expression drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h~scsi-remove-fake-address-of-expression
+++ a/drivers/scsi/scsi_priv.h
@@ -148,8 +148,6 @@ static inline void scsi_netlink_exit(voi
 /* scsi_pm.c */
 #ifdef CONFIG_PM_OPS
 extern const struct dev_pm_ops scsi_bus_pm_ops;
-#else /* CONFIG_PM_OPS */
-#define scsi_bus_pm_ops		(*NULL)
 #endif
 #ifdef CONFIG_PM_RUNTIME
 extern void scsi_autopm_get_target(struct scsi_target *);
diff -puN drivers/scsi/scsi_sysfs.c~scsi-remove-fake-address-of-expression drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~scsi-remove-fake-address-of-expression
+++ a/drivers/scsi/scsi_sysfs.c
@@ -381,7 +381,9 @@ struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
+#ifdef CONFIG_PM_OPS
 	.pm		= &scsi_bus_pm_ops,
+#endif
 };
 EXPORT_SYMBOL_GPL(scsi_bus_type);
 
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
linux-next.patch
scsi-remove-fake-address-of-expression.patch
scsi-sr-add-no_read_disc_info-scsi_device-flag.patch
usb-storage-add-new-no_read_disc_info-quirk.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
scsi-sd-add-a-no_read_capacity_16-scsi_device-flag.patch
usb-storage-add-new-no_read_capacity_16-quirk.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2.patch

