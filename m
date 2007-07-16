From: akpm@linux-foundation.org
Subject: - sony-laptop-use-null-for-pointer.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:07 -0700
Message-ID: <200707162056.l6GKu7Vf002067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762571AbXGPVOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, malattia@linux.it, mm-commits@vger.kernel.org


The patch titled
     sony-laptop: use NULL for pointer
has been removed from the -mm tree.  Its filename was
     sony-laptop-use-null-for-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony-laptop: use NULL for pointer
From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointer:
drivers/misc/sony-laptop.c:1920:6: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sony-laptop.c~sony-laptop-use-null-for-pointer drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~sony-laptop-use-null-for-pointer
+++ a/drivers/misc/sony-laptop.c
@@ -1917,7 +1917,8 @@ end:
  */
 static int sony_pic_disable(struct acpi_device *device)
 {
-	if (ACPI_FAILURE(acpi_evaluate_object(device->handle, "_DIS", 0, NULL)))
+	if (ACPI_FAILURE(acpi_evaluate_object(device->handle,
+			"_DIS", NULL, NULL)))
 		return -ENXIO;
 
 	dprintk("Device disabled\n");
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
docbook-dont-reference-file-without-kernel-doc.patch
profile-likely-unlikely-macros.patch
