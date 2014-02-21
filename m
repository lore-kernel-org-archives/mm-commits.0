From: akpm@linux-foundation.org
Subject: + fs-kernel-permit-disabling-the-uselib-syscall.patch added to
 -mm tree
Date: Fri, 21 Feb 2014 12:17:13 -0800
Message-ID: <5307b449.G9H1Go3UvO58ciph%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaBUURN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:17:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org

Subject: + fs-kernel-permit-disabling-the-uselib-syscall.patch added to -mm tree
To: josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:17:13 -0800


The patch titled
     Subject: fs, kernel: permit disabling the uselib syscall
has been added to the -mm tree.  Its filename is
     fs-kernel-permit-disabling-the-uselib-syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-kernel-permit-disabling-the-uselib-syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-kernel-permit-disabling-the-uselib-syscall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: fs, kernel: permit disabling the uselib syscall

uselib hasn't been used since libc5; glibc does not use it.  Support
turning it off.

When disabled, also omit the load_elf_library implementation from
binfmt_elf.c, which only uselib invokes.

bloat-o-meter:
add/remove: 0/4 grow/shrink: 0/1 up/down: 0/-785 (-785)
function                                     old     new   delta
padzero                                       39      36      -3
uselib_flags                                  20       -     -20
sys_uselib                                   168       -    -168
SyS_uselib                                   168       -    -168
load_elf_library                             426       -    -426

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    9 ++++++++-
 fs/exec.c       |    2 ++
 init/Kconfig    |    9 +++++++++
 kernel/sys_ni.c |    1 +
 4 files changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~fs-kernel-permit-disabling-the-uselib-syscall fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-kernel-permit-disabling-the-uselib-syscall
+++ a/fs/binfmt_elf.c
@@ -46,10 +46,15 @@
 #endif
 
 static int load_elf_binary(struct linux_binprm *bprm);
-static int load_elf_library(struct file *);
 static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
 				int, int, unsigned long);
 
+#ifdef CONFIG_USELIB
+static int load_elf_library(struct file *);
+#else
+#define load_elf_library NULL
+#endif
+
 /*
  * If we don't support core dumping, then supply a NULL so we
  * don't even try.
@@ -1005,6 +1010,7 @@ out_free_ph:
 	goto out;
 }
 
+#ifdef CONFIG_USELIB
 /* This is really simpleminded and specialized - we are loading an
    a.out library that is given an ELF header. */
 static int load_elf_library(struct file *file)
@@ -1083,6 +1089,7 @@ out_free_ph:
 out:
 	return error;
 }
+#endif /* #ifdef CONFIG_USELIB */
 
 #ifdef CONFIG_ELF_CORE
 /*
diff -puN fs/exec.c~fs-kernel-permit-disabling-the-uselib-syscall fs/exec.c
--- a/fs/exec.c~fs-kernel-permit-disabling-the-uselib-syscall
+++ a/fs/exec.c
@@ -97,6 +97,7 @@ static inline void put_binfmt(struct lin
 	module_put(fmt->module);
 }
 
+#ifdef CONFIG_USELIB
 /*
  * Note that a shared library must be both readable and executable due to
  * security reasons.
@@ -156,6 +157,7 @@ exit:
 out:
   	return error;
 }
+#endif /* #ifdef CONFIG_USELIB */
 
 #ifdef CONFIG_MMU
 /*
diff -puN init/Kconfig~fs-kernel-permit-disabling-the-uselib-syscall init/Kconfig
--- a/init/Kconfig~fs-kernel-permit-disabling-the-uselib-syscall
+++ a/init/Kconfig
@@ -273,6 +273,15 @@ config FHANDLE
 	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
 	  syscalls.
 
+config USELIB
+	bool "uselib syscall"
+	help
+	  This option enables the uselib syscall, a system call used in the
+	  dynamic linker from libc5 and earlier.  glibc does not use this
+	  system call.  If you intend to run programs built on libc5 or
+	  earlier, you may need to enable this syscall.  Current systems
+	  running glibc can safely disable this.
+
 config AUDIT
 	bool "Auditing support"
 	depends on NET
diff -puN kernel/sys_ni.c~fs-kernel-permit-disabling-the-uselib-syscall kernel/sys_ni.c
--- a/kernel/sys_ni.c~fs-kernel-permit-disabling-the-uselib-syscall
+++ a/kernel/sys_ni.c
@@ -152,6 +152,7 @@ cond_syscall(sys_process_vm_readv);
 cond_syscall(sys_process_vm_writev);
 cond_syscall(compat_sys_process_vm_readv);
 cond_syscall(compat_sys_process_vm_writev);
+cond_syscall(sys_uselib);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
_

Patches currently in -mm which might be from josh@joshtriplett.org are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
fs-kernel-permit-disabling-the-uselib-syscall.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

