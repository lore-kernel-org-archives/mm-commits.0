From: akpm@osdl.org
Subject: - no-paravirt-for-x86_voyager-or-x86_visws.patch removed from -mm tree
Date: Sat, 09 Dec 2006 17:52:47 -0800
Message-ID: <200612100152.kBA1qlPZ010603@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40575 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223AbWLJBxW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 20:53:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@suse.de, chrisw@sous-sol.org, jeremy@goop.org, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     no paravirt for X86_VOYAGER or X86_VISWS
has been removed from the -mm tree.  Its filename was
     no-paravirt-for-x86_voyager-or-x86_visws.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: no paravirt for X86_VOYAGER or X86_VISWS
From: Randy Dunlap <randy.dunlap@oracle.com>

Since Voyager and Visual WS already define ARCH_SETUP,
it looks like PARAVIRT shouldn't be offered for them.

In file included from arch/i386/kernel/setup.c:63:
include/asm-i386/mach-visws/setup_arch.h:8:1: warning: "ARCH_SETUP" redefined
In file included from include/asm/msr.h:5,
                 from include/asm/processor.h:17,
                 from include/asm/thread_info.h:16,
                 from include/linux/thread_info.h:21,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/capability.h:45,
                 from include/linux/sched.h:46,
                 from arch/i386/kernel/setup.c:26:
include/asm/paravirt.h:163:1: warning: this is the location of the previous definition
In file included from arch/i386/kernel/setup.c:63:
include/asm-i386/mach-visws/setup_arch.h:8:1: warning: "ARCH_SETUP" redefined
In file included from include/asm/msr.h:5,
                 from include/asm/processor.h:17,
                 from include/asm/thread_info.h:16,
                 from include/linux/thread_info.h:21,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/capability.h:45,
                 from include/linux/sched.h:46,
                 from arch/i386/kernel/setup.c:26:
include/asm/paravirt.h:163:1: warning: this is the location of the previous definition

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Acked-by: Zachary Amsden <zach@vmware.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/Kconfig~no-paravirt-for-x86_voyager-or-x86_visws arch/i386/Kconfig
--- a/arch/i386/Kconfig~no-paravirt-for-x86_voyager-or-x86_visws
+++ a/arch/i386/Kconfig
@@ -190,6 +190,7 @@ endchoice
 config PARAVIRT
 	bool "Paravirtualization support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	depends on !(X86_VISWS || X86_VOYAGER)
 	help
 	  Paravirtualization is a way of running multiple instances of
 	  Linux on the same machine, under a hypervisor.  This option
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
ucb1400_ts-depends-snd_ac97_bus.patch
ipc-procfs-sysctl-mixups.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
git-net.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
codingstyle-updates.patch
freezerh-uses-task_struct-fields.patch
geode-crypto-is-pci-device.patch
ipmi-remove-zero-inits.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

