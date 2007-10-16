From: akpm@linux-foundation.org
Subject: - uml-eliminate-floating-point-state-from-register-file.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:28 -0700
Message-ID: <200710162038.l9GKcSGG015451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935170AbXJPVHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: eliminate floating point state from register file
has been removed from the -mm tree.  Its filename was
     uml-eliminate-floating-point-state-from-register-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: eliminate floating point state from register file
From: Jeff Dike <jdike@addtoit.com>

The floating point fields in the pt_regs register file aren't used, so they
are deleted.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/sysdep-i386/ptrace.h   |    2 --
 arch/um/include/sysdep-x86_64/ptrace.h |    1 -
 2 files changed, 3 deletions(-)

diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-eliminate-floating-point-state-from-register-file arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-eliminate-floating-point-state-from-register-file
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -54,8 +54,6 @@ extern int sysemu_supported;
 
 struct uml_pt_regs {
 	unsigned long gp[MAX_REG_NR];
-	unsigned long fp[HOST_FP_SIZE];
-	unsigned long xfp[HOST_XFP_SIZE];
 	struct faultinfo faultinfo;
 	long syscall;
 	int is_user;
diff -puN arch/um/include/sysdep-x86_64/ptrace.h~uml-eliminate-floating-point-state-from-register-file arch/um/include/sysdep-x86_64/ptrace.h
--- a/arch/um/include/sysdep-x86_64/ptrace.h~uml-eliminate-floating-point-state-from-register-file
+++ a/arch/um/include/sysdep-x86_64/ptrace.h
@@ -86,7 +86,6 @@
 
 struct uml_pt_regs {
 	unsigned long gp[MAX_REG_NR];
-	unsigned long fp[HOST_FP_SIZE];
 	struct faultinfo faultinfo;
 	long syscall;
 	int is_user;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
