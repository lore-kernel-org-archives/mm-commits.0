From: akpm@linux-foundation.org
Subject: + x86-dont-allow-kvm_clock-without-have_kvm.patch added to -mm tree
Date: Fri, 14 Mar 2008 15:20:21 -0700
Message-ID: <200803142220.m2EMKMM0021975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529AbYCNWWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 18:22:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, avi@qumranet.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: don't allow KVM_CLOCK without HAVE_KVM
has been added to the -mm tree.  Its filename is
     x86-dont-allow-kvm_clock-without-have_kvm.patch

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
Subject: x86: don't allow KVM_CLOCK without HAVE_KVM
From: Randy Dunlap <randy.dunlap@oracle.com>


Make KVM_CLOCK depend on HAVE_KVM.  Otherwise a Voyager build can
fail with:

  CC      arch/x86/kernel/asm-offsets.s
In file included from include2/asm/irqflags.h:59,
                 from /local/linsrc/next-20080314/include/linux/irqflags.h:46,
                 from include2/asm/system.h:11,
                 from include2/asm/processor.h:21,
                 from include2/asm/atomic_32.h:5,
                 from include2/asm/atomic.h:2,
                 from /local/linsrc/next-20080314/include/linux/crypto.h:20,
                 from /local/linsrc/next-20080314/arch/x86/kernel/asm-offsets_32.c:7,
                 from /local/linsrc/next-20080314/arch/x86/kernel/asm-offsets.c:2:
include2/asm/paravirt.h: In function 'startup_ipi_hook':
include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
include2/asm/paravirt.h:856: error: memory input 4 is not directly addressable
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [sub-make] Error 2

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/Kconfig~x86-dont-allow-kvm_clock-without-have_kvm arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-dont-allow-kvm_clock-without-have_kvm
+++ a/arch/x86/Kconfig
@@ -370,6 +370,7 @@ config VMI
 config KVM_CLOCK
 	bool "KVM paravirtualized clock"
 	select PARAVIRT
+	depends on HAVE_KVM
 	help
 	  Turning on this option will allow you to run a paravirtualized clock
 	  when running over the KVM hypervisor. Instead of relying on a PIT
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-set-verbose-mode-via-environment.patch
mm-fix-various-kernel-doc-comments.patch
mm-shmem-and-tiny-shmem-fix-some-kernel-doc.patch
mm-oom_kill-fix-kernel-doc.patch
mm-highmem-kernel-doc-additions.patch
mm-rmap-kernel-doc-fixes.patch
jbd-fix-jbd-kernel-doc-notation.patch
git-acpi.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
profile-likely-unlikely-macros.patch

