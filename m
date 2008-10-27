From: akpm@linux-foundation.org
Subject: + scsi-ioctl-fix-kernel-doc-warning.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:11:57 -0700
Message-ID: <200810272011.m9RKBvkC010200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663AbYJ0UML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com


The patch titled
     scsi ioctl: fix kernel-doc warning
has been added to the -mm tree.  Its filename is
     scsi-ioctl-fix-kernel-doc-warning.patch

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
Subject: scsi ioctl: fix kernel-doc warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc parameter warning and correct the function name:

Warning(linux-next-20081022//drivers/scsi/scsi_ioctl.c:281): No description found for parameter 'ndelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_ioctl.c~scsi-ioctl-fix-kernel-doc-warning drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c~scsi-ioctl-fix-kernel-doc-warning
+++ a/drivers/scsi/scsi_ioctl.c
@@ -270,11 +270,11 @@ int scsi_ioctl(struct scsi_device *sdev,
 EXPORT_SYMBOL(scsi_ioctl);
 
 /**
- * scsi_nonblock_ioctl() - Handle SG_SCSI_RESET
+ * scsi_nonblockable_ioctl() - Handle SG_SCSI_RESET
  * @sdev: scsi device receiving ioctl
  * @cmd: Must be SC_SCSI_RESET
  * @arg: pointer to int containing SG_SCSI_RESET_{DEVICE,BUS,HOST}
- * @filp: either NULL or a &struct file which must have the O_NONBLOCK flag.
+ * @ndelay: file mode O_NDELAY flag
  */
 int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 			    void __user *arg, int ndelay)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

