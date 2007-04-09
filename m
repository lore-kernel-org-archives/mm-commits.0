From: akpm@linux-foundation.org
Subject: + fix-kernel-oops-with-badly-formatted-module-option.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:17:42 -0700
Message-ID: <200704091917.l39JHgjG021146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56484 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXDITSE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, Larry.Finger@lwfinger.net, rusty@rustcorp.com.au


The patch titled
     fix kernel oops with badly formatted module option
has been added to the -mm tree.  Its filename is
     fix-kernel-oops-with-badly-formatted-module-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 4 insertions(+)

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

fix-kernel-oops-with-badly-formatted-module-option.patch
git-acpi.patch
git-drm.patch
git-ieee1394.patch
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
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
