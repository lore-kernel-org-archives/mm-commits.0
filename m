From: akpm@linux-foundation.org
Subject: + x86_64-use-null-for-pointer.patch added to -mm tree
Date: Wed, 06 Jun 2007 00:00:20 -0700
Message-ID: <200706060700.l5670KAP011389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756744AbXFFHA2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 03:00:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     x86_64: use NULL for pointer
has been added to the -mm tree.  Its filename is
     x86_64-use-null-for-pointer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
git-acpi.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
hexdump-more-output-formatting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
x86_64-use-null-for-pointer.patch
sony-laptop-use-null-for-pointer.patch
mtd-use-null-for-pointer.patch
