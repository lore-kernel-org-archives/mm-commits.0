From: akpm@linux-foundation.org
Subject: - lguest-prevent-visws-or-voyager-randconfigs.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:24:15 -0800
Message-ID: <200712010024.lB10OFOB032053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757317AbXLAA1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: prevent VISWS or VOYAGER randconfigs
has been removed from the -mm tree.  Its filename was
     lguest-prevent-visws-or-voyager-randconfigs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: prevent VISWS or VOYAGER randconfigs
From: Randy Dunlap <randy.dunlap@oracle.com>

Keep lguest from being enabled on VISWS or VOYAGER configs, just as is
already done for VMI and XEN.  Otherwise randconfigs with VISWS and LGUEST
have this problem:

In file included from arch/x86/kernel/setup_32.c:61:
include/asm-x86/mach-visws/setup_arch.h:8:1: warning: "ARCH_SETUP" redefined
In file included from include/asm/msr.h:80,
                 from include/asm/processor_32.h:17,
                 from include/asm/processor.h:2,
                 from include/asm/thread_info_32.h:16,
                 from include/asm/thread_info.h:2,
                 from include/linux/thread_info.h:21,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:57,
                 from include/linux/sched.h:53,
                 from arch/x86/kernel/setup_32.c:24:
include/asm/paravirt.h:458:1: warning: this is the location of the previous definition

(and of course, this happens because kconfig does not follow dependencies
when [evil] select is used...)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lguest/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/lguest/Kconfig~lguest-prevent-visws-or-voyager-randconfigs arch/x86/lguest/Kconfig
--- a/arch/x86/lguest/Kconfig~lguest-prevent-visws-or-voyager-randconfigs
+++ a/arch/x86/lguest/Kconfig
@@ -2,6 +2,7 @@ config LGUEST_GUEST
 	bool "Lguest guest support"
 	select PARAVIRT
 	depends on !X86_PAE
+	depends on !(X86_VISWS || X86_VOYAGER)
 	select VIRTIO
 	select VIRTIO_RING
 	select VIRTIO_CONSOLE
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-scsi-misc.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
