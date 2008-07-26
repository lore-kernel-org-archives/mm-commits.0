From: akpm@linux-foundation.org
Subject: - kexec-jump-save-restore-device-state.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:14:13 -0700
Message-ID: <200807262114.m6QLEDWG019678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576AbYGZVPO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:15:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, nigel@nigel.suspend2.net, pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec jump: save/restore device state
has been removed from the -mm tree.  Its filename was
     kexec-jump-save-restore-device-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec jump: save/restore device state
From: Huang Ying <ying.huang@intel.com>

This patch implements devices state save/restore before after kexec.

This patch together with features in kexec_jump patch can be used for
following:

- A simple hibernation implementation without ACPI support.  You can kexec a
  hibernating kernel, save the memory image of original system and shutdown
  the system.  When resuming, you restore the memory image of original system
  via ordinary kexec load then jump back.

- Kernel/system debug through making system snapshot.  You can make system
  snapshot, jump back, do some thing and make another system snapshot.

- Cooperative multi-kernel/system.  With kexec jump, you can switch between
  several kernels/systems quickly without boot process except the first time. 
  This appears like swap a whole kernel/system out/in.

- A general method to call program in physical mode (paging turning
  off). This can be used to invoke BIOS code under Linux.

The following user-space tools can be used with kexec jump:

- kexec-tools needs to be patched to support kexec jump. The patches
  and the precompiled kexec can be download from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-src_git_kh10.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-patches_git_kh10.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec_git_kh10

- makedumpfile with patches are used as memory image saving tool, it
  can exclude free pages from original kernel memory image file. The
  patches and the precompiled makedumpfile can be download from the
  following URL:
       source: http://khibernation.sourceforge.net/download/release_v10/makedumpfile/makedumpfile-src_cvs_kh10.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v10/makedumpfile/makedumpfile-patches_cvs_kh10.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v10/makedumpfile/makedumpfile_cvs_kh10

- An initramfs image can be used as the root file system of kexeced
  kernel. An initramfs image built with "BuildRoot" can be downloaded
  from the following URL:
       initramfs image: http://khibernation.sourceforge.net/download/release_v10/initramfs/rootfs_cvs_kh10.gz
  All user space tools above are included in the initramfs image.

Usage example of simple hibernation:

1. Compile and install patched kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PM=y
CONFIG_HIBERNATION=y
CONFIG_KEXEC_JUMP=y

2. Build an initramfs image contains kexec-tool and makedumpfile, or
   download the pre-built initramfs image, called rootfs.gz in
   following text.

3. Prepare a partition to save memory image of original kernel, called
   hibernating partition in following text.

4. Boot kernel compiled in step 1 (kernel A).

5. In the kernel A, load kernel compiled in step 1 (kernel B) with
   /sbin/kexec. The shell command line can be as follow:

   /sbin/kexec --load-preserve-context /boot/bzImage --mem-min=0x100000
     --mem-max=0xffffff --initrd=rootfs.gz

6. Boot the kernel B with following shell command line:

   /sbin/kexec -e

7. The kernel B will boot as normal kexec. In kernel B the memory
   image of kernel A can be saved into hibernating partition as
   follow:

   jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
   echo $jump_back_entry > kexec_jump_back_entry
   cp /proc/vmcore dump.elf

   Then you can shutdown the machine as normal.

8. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
   root file system.

9. In kernel C, load the memory image of kernel A as follow:

   /sbin/kexec -l --args-none --entry=`cat kexec_jump_back_entry` dump.elf

10. Jump back to the kernel A as follow:

   /sbin/kexec -e

   Then, kernel A is resumed.

Implementation point:

To support jumping between two kernels, before jumping to (executing)
the new kernel and jumping back to the original kernel, the devices
are put into quiescent state, and the state of devices and CPU is
saved. After jumping back from kexeced kernel and jumping to the new
kernel, the state of devices and CPU are restored accordingly. The
devices/CPU state save/restore code of software suspend is called to
implement corresponding function.

Known issues:

- Because the segment number supported by sys_kexec_load is limited,
  hibernation image with many segments may not be load. This is
  planned to be eliminated by adding a new flag to sys_kexec_load to
  make a image can be loaded with multiple sys_kexec_load invoking.

Now, only the i386 architecture is supported.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                   |    5 ++-
 arch/x86/kernel/machine_kexec_32.c |   12 ++++++++
 include/linux/suspend.h            |    2 +
 kernel/kexec.c                     |   39 +++++++++++++++++++++++++++
 kernel/power/power.h               |    2 -
 5 files changed, 56 insertions(+), 4 deletions(-)

diff -puN arch/x86/Kconfig~kexec-jump-save-restore-device-state arch/x86/Kconfig
--- a/arch/x86/Kconfig~kexec-jump-save-restore-device-state
+++ a/arch/x86/Kconfig
@@ -1282,9 +1282,10 @@ config CRASH_DUMP
 config KEXEC_JUMP
 	bool "kexec jump (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	depends on KEXEC && PM_SLEEP && X86_32
+	depends on KEXEC && HIBERNATION && X86_32
 	help
-	  Invoke code in physical address mode via KEXEC
+	  Jump between original kernel and kexeced kernel and invoke
+	  code in physical address mode via KEXEC
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
diff -puN arch/x86/kernel/machine_kexec_32.c~kexec-jump-save-restore-device-state arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~kexec-jump-save-restore-device-state
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -125,6 +125,18 @@ void machine_kexec(struct kimage *image)
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 
+	if (image->preserve_context) {
+#ifdef CONFIG_X86_IO_APIC
+		/* We need to put APICs in legacy mode so that we can
+		 * get timer interrupts in second kernel. kexec/kdump
+		 * paths already have calls to disable_IO_APIC() in
+		 * one form or other. kexec jump path also need
+		 * one.
+		 */
+		disable_IO_APIC();
+#endif
+	}
+
 	control_page = page_address(image->control_code_page);
 	memcpy(control_page, relocate_kernel, PAGE_SIZE/2);
 
diff -puN include/linux/suspend.h~kexec-jump-save-restore-device-state include/linux/suspend.h
--- a/include/linux/suspend.h~kexec-jump-save-restore-device-state
+++ a/include/linux/suspend.h
@@ -278,4 +278,6 @@ static inline void register_nosave_regio
 }
 #endif
 
+extern struct mutex pm_mutex;
+
 #endif /* _LINUX_SUSPEND_H */
diff -puN kernel/kexec.c~kexec-jump-save-restore-device-state kernel/kexec.c
--- a/kernel/kexec.c~kexec-jump-save-restore-device-state
+++ a/kernel/kexec.c
@@ -26,6 +26,10 @@
 #include <linux/numa.h>
 #include <linux/suspend.h>
 #include <linux/device.h>
+#include <linux/freezer.h>
+#include <linux/pm.h>
+#include <linux/cpu.h>
+#include <linux/console.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1441,7 +1445,31 @@ int kernel_kexec(void)
 
 	if (kexec_image->preserve_context) {
 #ifdef CONFIG_KEXEC_JUMP
+		mutex_lock(&pm_mutex);
+		pm_prepare_console();
+		error = freeze_processes();
+		if (error) {
+			error = -EBUSY;
+			goto Restore_console;
+		}
+		suspend_console();
+		error = device_suspend(PMSG_FREEZE);
+		if (error)
+			goto Resume_console;
+		error = disable_nonboot_cpus();
+		if (error)
+			goto Resume_devices;
 		local_irq_disable();
+		/* At this point, device_suspend() has been called,
+		 * but *not* device_power_down(). We *must*
+		 * device_power_down() now.  Otherwise, drivers for
+		 * some devices (e.g. interrupt controllers) become
+		 * desynchronized with the actual state of the
+		 * hardware at resume time, and evil weirdness ensues.
+		 */
+		error = device_power_down(PMSG_FREEZE);
+		if (error)
+			goto Enable_irqs;
 		save_processor_state();
 #endif
 	} else {
@@ -1459,7 +1487,18 @@ int kernel_kexec(void)
 	if (kexec_image->preserve_context) {
 #ifdef CONFIG_KEXEC_JUMP
 		restore_processor_state();
+		device_power_up(PMSG_RESTORE);
+ Enable_irqs:
 		local_irq_enable();
+		enable_nonboot_cpus();
+ Resume_devices:
+		device_resume(PMSG_RESTORE);
+ Resume_console:
+		resume_console();
+		thaw_processes();
+ Restore_console:
+		pm_restore_console();
+		mutex_unlock(&pm_mutex);
 #endif
 	}
 
diff -puN kernel/power/power.h~kexec-jump-save-restore-device-state kernel/power/power.h
--- a/kernel/power/power.h~kexec-jump-save-restore-device-state
+++ a/kernel/power/power.h
@@ -53,8 +53,6 @@ extern int hibernation_platform_enter(vo
 
 extern int pfn_is_nosave(unsigned long);
 
-extern struct mutex pm_mutex;
