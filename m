From: akpm@linux-foundation.org
Subject: - uml-add-uml-dependencies.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:37:41 -0800
Message-ID: <200712040737.lB47bfkR006812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbXLDHiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:38:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@zeniv.linux.org.uk, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: add !UML dependencies
has been removed from the -mm tree.  Its filename was
     uml-add-uml-dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: add !UML dependencies
From: Al Viro <viro@zeniv.linux.org.uk>

That's not enough, unfortunately.  If we go that way, we need to add
dependencies on !UML for several options.

[ jdike - "not enough" refers to my patch which enables X86_32 and
RWSEM_XCHGADD_ALGORITHM in UML's Kconfig.i386 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/Kconfig         |    2 +-
 kernel/Kconfig.instrumentation |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/crypto/Kconfig~uml-add-uml-dependencies drivers/crypto/Kconfig
--- a/drivers/crypto/Kconfig~uml-add-uml-dependencies
+++ a/drivers/crypto/Kconfig
@@ -12,7 +12,7 @@ if CRYPTO_HW
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
-	depends on X86_32
+	depends on X86_32 && !UML
 	select CRYPTO_ALGAPI
 	help
 	  Some VIA processors come with an integrated crypto engine
diff -puN kernel/Kconfig.instrumentation~uml-add-uml-dependencies kernel/Kconfig.instrumentation
--- a/kernel/Kconfig.instrumentation~uml-add-uml-dependencies
+++ a/kernel/Kconfig.instrumentation
@@ -20,7 +20,7 @@ config PROFILING
 
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
+	depends on PROFILING && !UML
 	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -32,7 +32,7 @@ config OPROFILE
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
+	depends on (X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32) && !UML
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
_

Patches currently in -mm which might be from viro@zeniv.linux.org.uk are

kernel-auditc-warning-fix.patch
kernel-compliment-va_copy-with-va_end.patch
vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
fix-versus-precedence-in-various-places.patch
mnt_unbindable-fix.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
dont-touch-fs_struct-in-drivers.patch
remove-path_release_on_umount.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
single_open-seq_release-leak-diagnostics.patch
