From: akpm@linux-foundation.org
Subject: - fix-kernel-oops-with-badly-formatted-module-option.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:10 -0700
Message-ID: <200704132328.l3DNSAlK012502@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60325 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160999AbXDMX2W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:28:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Larry.Finger@lwfinger.net, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     fix kernel oops with badly formatted module option
has been removed from the -mm tree.  Its filename was
     fix-kernel-oops-with-badly-formatted-module-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix kernel oops with badly formatted module option
From: Randy Dunlap <randy.dunlap@oracle.com>

Catch malformed kernel parameter usage of "param = value".  Spaces are not
supported, but don't cause a kernel fault on such usage, just report an
error.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/params.c~fix-kernel-oops-with-badly-formatted-module-option kernel/params.c
--- a/kernel/params.c~fix-kernel-oops-with-badly-formatted-module-option
+++ a/kernel/params.c
@@ -356,6 +356,10 @@ int param_set_copystring(const char *val
 {
 	struct kparam_string *kps = kp->arg;
 
+	if (!val) {
+		printk(KERN_ERR "%s: missing param set value\n", kp->name);
+		return -EINVAL;
+	}
 	if (strlen(val)+1 > kps->maxlen) {
 		printk(KERN_ERR "%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-fix-plisth-comments.patch
git-acpi.patch
git-drm.patch
git-ieee1394.patch
git-kbuild.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
8250_pci-fix-pci-must_checks.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-mtrr-sections.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
expose-range-checking-functions-from-arch-specific.patch
expose-range-checking-functions-from-arch-specific-update.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kernel-doc-html-mode-struct-highlights.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
