From: akpm@linux-foundation.org
Subject: - ptrace-needs-proc_fs.patch removed from -mm tree
Date: Thu, 22 Mar 2007 12:21:36 -0800
Message-ID: <200703222021.l2MKLaNV029474@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49960 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934224AbXCVUVk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:21:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ptrace needs PROC_FS
has been removed from the -mm tree.  Its filename was
     ptrace-needs-proc_fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ptrace needs PROC_FS
From: Randy Dunlap <randy.dunlap@oracle.com>

CONFIG_PTRACE needs PROC_FS; with CONFIG_PROC_FS=n (x86_64):

  LD      .tmp_vmlinux1
kernel/built-in.o: In function `ptrace_start':
ptrace.c:(.text+0x300f9): undefined reference to `ptrace_may_attach'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~ptrace-needs-proc_fs init/Kconfig
--- a/init/Kconfig~ptrace-needs-proc_fs
+++ a/init/Kconfig
@@ -650,7 +650,7 @@ config UTRACE
 config PTRACE
 	bool "Legacy ptrace system call interface"
 	default y
-	depends on UTRACE
+	depends on UTRACE && PROC_FS
 	help
 	  Enable the ptrace system call.
 	  This is traditionally used by debuggers like GDB,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
cpuidle-unsigned-bitfield.patch
acpi-dock-use-null-for-pointer.patch
nozomi-use-null-for-pointers.patch
git-drm.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
