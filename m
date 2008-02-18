From: akpm@linux-foundation.org
Subject: + acpi-sparse-fix-replace-macro-with-static-function.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:55:56 -0800
Message-ID: <200802180956.m1I9usFP018700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYBRJ5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 04:57:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, lenb@kernel.org


The patch titled
     acpi: sparse fix, replace macro with static function
has been added to the -mm tree.  Its filename is
     acpi-sparse-fix-replace-macro-with-static-function.patch

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
Subject: acpi: sparse fix, replace macro with static function
From: Harvey Harrison <harvey.harrison@gmail.com>

replace acpi_util_eval_error macro with static function.

Avoid these sparse warnings due to using buffer within the macro.
drivers/acpi/utils.c:273:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:259:21: originally declared here
drivers/acpi/utils.c:279:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:259:21: originally declared here
drivers/acpi/utils.c:368:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:348:21: originally declared here
drivers/acpi/utils.c:375:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:348:21: originally declared here
drivers/acpi/utils.c:382:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:348:21: originally declared here
drivers/acpi/utils.c:402:4: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:348:21: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/utils.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/utils.c~acpi-sparse-fix-replace-macro-with-static-function drivers/acpi/utils.c
--- a/drivers/acpi/utils.c~acpi-sparse-fix-replace-macro-with-static-function
+++ a/drivers/acpi/utils.c
@@ -36,16 +36,20 @@ ACPI_MODULE_NAME("utils");
 /* --------------------------------------------------------------------------
                             Object Evaluation Helpers
    -------------------------------------------------------------------------- */
+static void
+acpi_util_eval_error(acpi_handle h, acpi_string p, acpi_status s)
+{
 #ifdef ACPI_DEBUG_OUTPUT
-#define acpi_util_eval_error(h,p,s) {\
-	char prefix[80] = {'\0'};\
-	struct acpi_buffer buffer = {sizeof(prefix), prefix};\
-	acpi_get_name(h, ACPI_FULL_PATHNAME, &buffer);\
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Evaluate [%s.%s]: %s\n",\
-		(char *) prefix, p, acpi_format_exception(s))); }
+	char prefix[80] = {'\0'};
+	struct acpi_buffer buffer = {sizeof(prefix), prefix};
+	acpi_get_name(h, ACPI_FULL_PATHNAME, &buffer);
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Evaluate [%s.%s]: %s\n",
+		(char *) prefix, p, acpi_format_exception(s)));
 #else
-#define acpi_util_eval_error(h,p,s)
+	return;
 #endif
+}
+
 acpi_status
 acpi_extract_package(union acpi_object *package,
 		     struct acpi_buffer *format, struct acpi_buffer *buffer)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
cifs-remove-global_extern-macro.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-replace-macro-with-static-inline-in-libatah.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
