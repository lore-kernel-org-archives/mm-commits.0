From: akpm@linux-foundation.org
Subject: + x86_32-fix-visualws-and-voyager-kexec-build-failures.patch added to -mm tree
Date: Tue, 01 Apr 2008 15:44:01 -0700
Message-ID: <200804012244.m31Mi2fB017492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbYDAWol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 18:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ebiederm@xmission.com, mingo@elte.hu, sfr@canb.auug.org.au, tglx@linutronix.de


The patch titled
     x86_32: fix VisualWS and Voyager kexec build failures
has been added to the -mm tree.  Its filename is
     x86_32-fix-visualws-and-voyager-kexec-build-failures.patch

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
Subject: x86_32: fix VisualWS and Voyager kexec build failures
From: Randy Dunlap <randy.dunlap@oracle.com>

Both Visual WS and Voyager builds fail in almost the same way (in linux-next)
without this patch:

VOYAGER:
kernel/built-in.o: In function `crash_kexec':
(.text+0x28588): undefined reference to `machine_crash_shutdown'

VISWS:
kernel/built-in.o: In function `crash_kexec':
/next-20080401/kernel/kexec.c:1074: undefined reference to `machine_crash_shutdown'
make[1]: *** [.tmp_vmlinux1] Error 1

because arch/x86/kernel/reboot.c isn't built since CONFIG_X86_BIOS_REBOOT=n,
so machine_crash_shutdown() isn't available.

This patch does seem a small bit odd since the KEXEC help text says that
kexec is independent of the system firmware.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/Kconfig~x86_32-fix-visualws-and-voyager-kexec-build-failures arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86_32-fix-visualws-and-voyager-kexec-build-failures
+++ a/arch/x86/Kconfig
@@ -1077,6 +1077,7 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call"
+	depends on X86_64 || X86_BIOS_REBOOT
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

x86_32-fix-visualws-and-voyager-kexec-build-failures.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
git-kvm.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

