From: akpm@linux-foundation.org
Subject: - acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch removed from -mm tree
Date: Tue, 12 Aug 2008 16:21:49 -0700
Message-ID: <200808122321.m7CNLnNU019017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155AbYHLXWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:22:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, andi@firstfloor.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi utmisc: use WARN_ON() instead of warn_on_slowpath()
has been removed from the -mm tree.  Its filename was
     acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi utmisc: use WARN_ON() instead of warn_on_slowpath()
From: Randy Dunlap <randy.dunlap@oracle.com>

utmisc.c needs to include asm-generic/bug.h for warn()/WARN() functions,
but it should use WARN_ON() instead of warn_on_slowpath() since arches can
provide their own implementation of WARN_ON(), which does not have to
use/provide/implement warn_on_slowpath() at all.  Just use the front door
(WARN_ON).

linux-next-20080702/drivers/acpi/utilities/utmisc.c:1027: error: implicit declaration of function 'warn_on_slowpath'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/utilities/utmisc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/utilities/utmisc.c~acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath drivers/acpi/utilities/utmisc.c
--- a/drivers/acpi/utilities/utmisc.c~acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath
+++ a/drivers/acpi/utilities/utmisc.c
@@ -42,6 +42,7 @@
  */
 
 #include <linux/module.h>
+#include <asm-generic/bug.h>
 
 #include <acpi/acpi.h>
 #include <acpi/acnamesp.h>
@@ -1024,7 +1025,7 @@ acpi_ut_error(const char *module_name, u
 {
 	va_list args;
 
-	warn_on_slowpath(module_name, line_number);
+	WARN_ON(1);
 	acpi_os_printf("ACPI Error (%s-%04d): ", module_name, line_number);
 
 	va_start(args, format);
@@ -1039,7 +1040,7 @@ acpi_ut_exception(const char *module_nam
 {
 	va_list args;
 
-	warn_on_slowpath(module_name, line_number);
+	WARN_ON(1);
 	acpi_os_printf("ACPI Exception (%s-%04d): %s, ", module_name,
 		       line_number, acpi_format_exception(status));
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
gru-fix-preprocessor-symbol-for-sparse.patch
move-kernel-doc-comment-for-might_sleep-directly-before-its-defining-block.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
linux-next.patch
acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
git-unionfs.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

