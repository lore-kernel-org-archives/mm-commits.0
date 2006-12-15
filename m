From: akpm@osdl.org
Subject: + kgdb-fix-rejects.patch added to -mm tree
Date: Fri, 15 Dec 2006 14:07:09 -0800
Message-ID: <200612152207.kBFM79Au002206@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50345 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030242AbWLOWaM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 17:30:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, piet@bluelane.com, trini@kernel.crashing.org


The patch titled
     kgdb: fix rejects
has been added to the -mm tree.  Its filename is
     kgdb-fix-rejects.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kgdb: fix rejects
From: Andrew Morton <akpm@osdl.org>

Fix the rejects which arise from forcing the kgdb patch onto the -mm queue.

Cc: Piet Delaney <piet@bluelane.com>
Cc: Tom Rini <trini@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile              |    1 
 include/asm-sh/kgdb.h |   87 +++++++---------------------------------
 kernel/timer.c        |    1 
 3 files changed, 18 insertions(+), 71 deletions(-)

diff -puN Makefile~kgdb-fix-rejects Makefile
--- a/Makefile~kgdb-fix-rejects
+++ a/Makefile
@@ -1041,6 +1041,7 @@ CLEAN_FILES +=	vmlinux System.map \
 MRPROPER_DIRS  += include/config include2 usr/include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h generated-headers		\
+		  include/linux/dwarf2-defs.h				\
 		  Module.symvers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
diff -puN include/asm-sh/kgdb.h~kgdb-fix-rejects include/asm-sh/kgdb.h
--- a/include/asm-sh/kgdb.h~kgdb-fix-rejects
+++ a/include/asm-sh/kgdb.h
@@ -2,94 +2,39 @@
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
  *
- * Based on original code by Glenn Engel, Jim Kingdon,
- * David Grothe <dave@gcom.com>, Tigran Aivazian, <tigran@sco.com> and
- * Amit S. Kale <akale@veritas.com>
- * 
- * Super-H port based on sh-stub.c (Ben Lee and Steve Chamberlain) by
- * Henry Bell <henry.bell@st.com>
- * 
- * Header file for low-level support for remote debug using GDB. 
+ * Based on a file that was modified or based on files by: Glenn Engel,
+ * Jim Kingdon, David Grothe <dave@gcom.com>, Tigran Aivazian <tigran@sco.com>,
+ * Amit S. Kale <akale@veritas.com>, sh-stub.c from Ben Lee and
+ * Steve Chamberlain, Henry Bell <henry.bell@st.com>
  *
+ * Maintainer: Tom Rini <trini@kernel.crashing.org>
  */
 
 #ifndef __KGDB_H
 #define __KGDB_H
 
-#include <asm/ptrace.h>
-
-struct console;
+#include <asm-generic/kgdb.h>
+/* Based on sh-gdb.c from gdb-6.1, Glenn
+     Engel at HP  Ben Lee and Steve Chamberlain */
+#define NUMREGBYTES	112	/* 92 */
+#define NUMCRITREGBYTES	(9 << 2)
+#define BUFMAX		400
 
 /* Same as pt_regs but has vbr in place of syscall_nr */
 struct kgdb_regs {
         unsigned long regs[16];
         unsigned long pc;
         unsigned long pr;
-        unsigned long sr;
         unsigned long gbr;
+	unsigned long vbr;
         unsigned long mach;
         unsigned long macl;
-        unsigned long vbr;
-};
-
-/* State info */
-extern char kgdb_in_gdb_mode;
-extern int kgdb_done_init;
-extern int kgdb_enabled;
-extern int kgdb_nofault;	/* Ignore bus errors (in gdb mem access) */
-extern int kgdb_halt;		/* Execute initial breakpoint at startup */
-extern char in_nmi;		/* Debounce flag to prevent NMI reentry*/
-
-/* SCI */
-extern int kgdb_portnum;
-extern int kgdb_baud;
-extern char kgdb_parity;
-extern char kgdb_bits;
-extern int kgdb_console_setup(struct console *, char *);
-
-/* Init and interface stuff */
-extern int kgdb_init(void);
-extern int (*kgdb_serial_setup)(void);
-extern int (*kgdb_getchar)(void);
-extern void (*kgdb_putchar)(int);
-
-struct kgdb_sermap {
-	char *name;
-	int namelen;
-	int (*setup_fn)(struct console *, char *);
-	struct kgdb_sermap *next;
+	unsigned long sr;
 };
-extern void kgdb_register_sermap(struct kgdb_sermap *map);
-extern struct kgdb_sermap *kgdb_porttype;
 
-/* Trap functions */
-typedef void (kgdb_debug_hook_t)(struct pt_regs *regs); 
-typedef void (kgdb_bus_error_hook_t)(void);
-extern kgdb_debug_hook_t  *kgdb_debug_hook;
-extern kgdb_bus_error_hook_t *kgdb_bus_err_hook;
-
-extern void breakpoint(void);
-
-/* Console */
-struct console;
-void kgdb_console_write(struct console *co, const char *s, unsigned count);
-void kgdb_console_init(void);
-
-/* Prototypes for jmp fns */
-#define _JBLEN 9
-typedef        int jmp_buf[_JBLEN];
-extern void    longjmp(jmp_buf __jmpb, int __retval);
-extern int     setjmp(jmp_buf __jmpb);
-
-/* Variadic macro to print our own message to the console */
-#define KGDB_PRINTK(...) printk("KGDB: " __VA_ARGS__)
-
-/* Forced breakpoint */
-#define BREAKPOINT()					\
-do {							\
-	if (kgdb_enabled)				\
-		__asm__ __volatile__("trapa   #0x3c");	\
-} while (0)
+#define BREAKPOINT()		asm("trapa #0xff");
+#define BREAK_INSTR_SIZE	2
+#define CACHE_FLUSH_IS_SAFE	1
 
 /* KGDB should be able to flush all kernel text space */
 #if defined(CONFIG_CPU_SH4)
diff -puN kernel/timer.c~kgdb-fix-rejects kernel/timer.c
--- a/kernel/timer.c~kgdb-fix-rejects
+++ a/kernel/timer.c
@@ -35,6 +35,7 @@
 #include <linux/syscalls.h>
 #include <linux/delay.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
_

Patches currently in -mm which might be from akpm@osdl.org are

deadlock-in-mincore-tidy.patch
deadlock-in-mincore-speedup.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-acpi-cpufreq-fixup.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
arm-systemh-build-fix.patch
git-drm.patch
ia64-enable-config_debug_spinlock_sleep.patch
infiniband-fix-for-gregkh-depredations.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
driver-for-silan-sc92031-netdev-fix-more.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
pci-disable-multithreaded-probing.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
funsoft-is-bust-on-sparc.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
add-memcpy_uncached_read-fix.patch
add-memcpy_uncached_read-tidy.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
kgdb-fix-rejects.patch
git-kgdb-fixup.patch
git-kgdb-vs-define-struct-pspace.patch
kgdb-default-to-ttys0.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

