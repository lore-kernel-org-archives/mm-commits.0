From: akpm@linux-foundation.org
Subject: + acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch added to -mm tree
Date: Wed, 02 Jul 2008 12:14:57 -0700
Message-ID: <200807021914.m62JEvTX031668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbYGBTT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 15:19:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, andi@firstfloor.org, lenb@kernel.org


The patch titled
     acpi utmisc: use WARN_ON() instead of warn_on_slowpath()
has been added to the -mm tree.  Its filename is
     acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
doc-kernel-parameterstxt-fix-stale-references.patch
cpusets-document-proc-status-cpus-and-mems-allowed-lists.patch
linux-next.patch
acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kbuild-next.patch
bluetooth-hci_bcsp-fix-bitrev-kconfig.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
e100-fix-printk-format-warning.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

