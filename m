From: akpm@linux-foundation.org
Subject: [merged] drivers-macintosh-macio-adbc-add-missing-unlock.patch removed from -mm tree
Date: Thu, 08 Apr 2010 11:12:59 -0400
Message-ID: <201004081814.o38IERWS032333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758897Ab0DHSOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 14:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     drivers/macintosh/macio-adb.c: add missing unlock
has been removed from the -mm tree.  Its filename was
     drivers-macintosh-macio-adbc-add-missing-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/macintosh/macio-adb.c: add missing unlock
From: Julia Lawall <julia@diku.dk>

In some error handling cases the lock is not unlocked.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irqsave (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/macio-adb.c |    1 +
 drivers/macintosh/smu.c       |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/macintosh/macio-adb.c~drivers-macintosh-macio-adbc-add-missing-unlock drivers/macintosh/macio-adb.c
--- a/drivers/macintosh/macio-adb.c~drivers-macintosh-macio-adbc-add-missing-unlock
+++ a/drivers/macintosh/macio-adb.c
@@ -155,6 +155,7 @@ static int macio_adb_reset_bus(void)
 	while ((in_8(&adb->ctrl.r) & ADB_RST) != 0) {
 		if (--timeout == 0) {
 			out_8(&adb->ctrl.r, in_8(&adb->ctrl.r) & ~ADB_RST);
+			spin_unlock_irqrestore(&macio_lock, flags);
 			return -1;
 		}
 	}
diff -puN drivers/macintosh/smu.c~drivers-macintosh-macio-adbc-add-missing-unlock drivers/macintosh/smu.c
--- a/drivers/macintosh/smu.c~drivers-macintosh-macio-adbc-add-missing-unlock
+++ a/drivers/macintosh/smu.c
@@ -1183,8 +1183,10 @@ static ssize_t smu_read_command(struct f
 		return -EOVERFLOW;
 	spin_lock_irqsave(&pp->lock, flags);
 	if (pp->cmd.status == 1) {
-		if (file->f_flags & O_NONBLOCK)
+		if (file->f_flags & O_NONBLOCK) {
+			spin_unlock_irqrestore(&pp->lock, flags);
 			return -EAGAIN;
+		}
 		add_wait_queue(&pp->wait, &wait);
 		for (;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock.patch
drivers-serial-pmac_zilogc-add-missing-unlock.patch
drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch
drivers-acpi-use-kasprintf.patch
drivers-acpi-use-kasprintf-fix.patch
arch-x86-pci-use-kasprintf.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-avoid-null-dereference.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch

