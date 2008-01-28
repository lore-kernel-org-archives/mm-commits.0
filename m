From: akpm@linux-foundation.org
Subject: + uml-defconfig-tweaks.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:23:52 -0800
Message-ID: <200801280524.m0S5OkMW013815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbYA1Fd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:33:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: defconfig tweaks
has been added to the -mm tree.  Its filename is
     uml-defconfig-tweaks.patch

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
Subject: uml: defconfig tweaks
From: Jeff Dike <jdike@addtoit.com>

Tweak the UML defconfig -
      we probably don't need 256 old-style ptys - this slows down udev
noticably
      enable hostfs
      disable slab debugging - another noticable performance hit

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/defconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/defconfig~uml-defconfig-tweaks arch/um/defconfig
--- a/arch/um/defconfig~uml-defconfig-tweaks
+++ a/arch/um/defconfig
@@ -77,7 +77,7 @@ CONFIG_LD_SCRIPT_DYN=y
 CONFIG_NET=y
 CONFIG_BINFMT_ELF=y
 CONFIG_BINFMT_MISC=m
-# CONFIG_HOSTFS is not set
+CONFIG_HOSTFS=y
 # CONFIG_HPPFS is not set
 CONFIG_MCONSOLE=y
 CONFIG_MAGIC_SYSRQ=y
@@ -188,7 +188,7 @@ CONFIG_CON_CHAN="xterm"
 CONFIG_SSL_CHAN="pts"
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
+CONFIG_LEGACY_PTY_COUNT=32
 # CONFIG_WATCHDOG is not set
 CONFIG_UML_SOUND=m
 CONFIG_SOUND=m
@@ -508,7 +508,7 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
-CONFIG_DEBUG_SLAB=y
+# CONFIG_DEBUG_SLAB is not set
 # CONFIG_DEBUG_SLAB_LEAK is not set
 # CONFIG_DEBUG_MUTEXES is not set
 # CONFIG_DEBUG_SPINLOCK is not set
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-header-untangling-fix.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-signal-handling-tidying.patch
uml-remove-init_irq_signals.patch
uml-smp-locking-commentary.patch
uml-implement-o_append.patch
uml-remove-fakehd.patch
uml-debug_shirq-fixes.patch
uml-add-back-config_hz.patch
uml-style-fixes-in-arch-um-sys-x86_64.patch
uml-add-newlines-to-printks.patch
uml-move-register-initialization.patch
uml-remove-unused-fields-from-mm_context.patch
uml-remove-map_cb.patch
uml-use-of-a-public-mac-is-a-warning-not-an-error.patch
uml-defconfig-tweaks.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
