From: akpm@linux-foundation.org
Subject: - ipsc-update-version-information.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:50 -0700
Message-ID: <200709270143.l8R1hodc013995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbXI0BvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, James.Bottomley@steeleye.com, aacraid@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     ips.c: update version information
has been removed from the -mm tree.  Its filename was
     ipsc-update-version-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ips.c: update version information
From: Bernhard Walle <bwalle@suse.de>

Make the version number in ips.c and ips.h consistent.  It seems that this
has been forgotten in a60768e2d43eb30a1adb8a119aeac35dc0d03ef6.

It also removes code duplication, each number is now only once in the code to
avoid similar errors in the future.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |    4 ++--
 drivers/scsi/ips.h |   11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ips.c~ipsc-update-version-information drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~ipsc-update-version-information
+++ a/drivers/scsi/ips.c
@@ -204,8 +204,8 @@ module_param(ips, charp, 0);
 /*
  * DRIVER_VER
  */
-#define IPS_VERSION_HIGH        "7.12"
-#define IPS_VERSION_LOW         ".05 "
+#define IPS_VERSION_HIGH        IPS_VER_MAJOR_STRING "." IPS_VER_MINOR_STRING
+#define IPS_VERSION_LOW         "." IPS_VER_BUILD_STRING " "
 
 #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
 #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
diff -puN drivers/scsi/ips.h~ipsc-update-version-information drivers/scsi/ips.h
--- a/drivers/scsi/ips.h~ipsc-update-version-information
+++ a/drivers/scsi/ips.h
@@ -1172,12 +1172,13 @@ typedef struct {
 *************************************************************************/
 
 #define IPS_VER_MAJOR 7
-#define IPS_VER_MAJOR_STRING "7"
+#define IPS_VER_MAJOR_STRING __stringify(IPS_VER_MAJOR)
 #define IPS_VER_MINOR 12
-#define IPS_VER_MINOR_STRING "12"
-#define IPS_VER_BUILD 02
-#define IPS_VER_BUILD_STRING "02"
-#define IPS_VER_STRING "7.12.02"
+#define IPS_VER_MINOR_STRING __stringify(IPS_VER_MINOR)
+#define IPS_VER_BUILD 05
+#define IPS_VER_BUILD_STRING __stringify(IPS_VER_BUILD)
+#define IPS_VER_STRING IPS_VER_MAJOR_STRING "." \
+		IPS_VER_MINOR_STRING "." IPS_VER_BUILD_STRING
 #define IPS_RELEASE_ID 0x00020000
 #define IPS_BUILD_IDENT 761
 #define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2002. All Rights Reserved."
_

Patches currently in -mm which might be from bwalle@suse.de are

git-scsi-misc.patch
add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
extended-crashkernel-command-line-comment-fix.patch
extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
