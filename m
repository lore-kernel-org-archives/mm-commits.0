From: akpm@linux-foundation.org
Subject: - acpi-sparse-fix-replace-macro-with-static-function.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:31 -0800
Message-ID: <200802232021.m1NKLVRT013341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760101AbYBWUVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:21:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: sparse fix, replace macro with static function
has been removed from the -mm tree.  Its filename was
     acpi-sparse-fix-replace-macro-with-static-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
markers-fix-sparse-warnings-in-markersc.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-nfsd.patch
git-sched.patch
git-scsi-rc-fixes.patch
git-x86.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
