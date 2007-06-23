From: akpm@linux-foundation.org
Subject: - x86_64-use-null-for-pointer.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:28 -0700
Message-ID: <200706231928.l5NJSS5h022150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbXFWTeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: use NULL for pointer
has been removed from the -mm tree.  Its filename was
     x86_64-use-null-for-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: use NULL for pointer
From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointer:
arch/x86_64/kernel/vsyscall.c:183:21: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vsyscall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/vsyscall.c~x86_64-use-null-for-pointer arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~x86_64-use-null-for-pointer
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -180,7 +180,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
 
-	vgettimeofday(&tv, 0);
+	vgettimeofday(&tv, NULL);
 	result = tv.tv_sec;
 	if (t)
 		*t = result;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
