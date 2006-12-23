From: akpm@osdl.org
Subject: - build-compileh-earlier.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:55:15 -0800
Message-ID: <200612230755.kBN7tFJo010282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49843 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbWLWHzV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:55:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, sam@ravnborg.org, torvalds@osdl.org, mm-commits@vger.kernel.org


The patch titled
     build compile.h earlier
has been removed from the -mm tree.  Its filename was
     build-compileh-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: build compile.h earlier
From: Andrew Morton <akpm@osdl.org>

compile.h is created super-late in the build.  But proc_misc.c want to include
it, and it's generally not sane to have a header file in include/linux be
created at the end of the build: it's either not present or, worse, wrong for
most of the build.

So the patch arranges for compile.h to be built at the start of the build
process.  It also consolidates the compile.h rules with those for version.h
and utsname.h, so they all get built together.

I hope.  My chances of having got this right are about 2%.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile      |   31 ++++++++++++++++++++++---------
 init/Makefile |    9 ---------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff -puN Makefile~build-compileh-earlier Makefile
--- a/Makefile~build-compileh-earlier
+++ a/Makefile
@@ -368,10 +368,14 @@ endif
 # Detect when mixed targets is specified, and make a second invocation
 # of make so .config is not included in this case either (for *config).
 
-no-dot-config-targets := clean mrproper distclean \
+PHONY += generated_headers
+
+generated_headers: include/linux/version.h include/linux/compile.h \
+		include/linux/utsrelease.h
+
+no-dot-config-targets := generated_headers clean mrproper distclean \
 			 cscope TAGS tags help %docs check% \
-			 include/linux/version.h headers_% \
-			 kernelrelease kernelversion
+			 headers_% kernelrelease kernelversion
 
 config-targets := 0
 mixed-targets  := 0
@@ -734,6 +738,16 @@ debug_kallsyms: .tmp_map$(last_kallsyms)
 
 endif # ifdef CONFIG_KALLSYMS
 
+# compile.h changes depending on hostname, generation number, etc,
+# so we regenerate it always.
+# mkcompile_h will make sure to only update the
+# actual file if its content has changed.
+
+include/linux/compile.h: FORCE
+	@echo '  CHK     $@'
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkcompile_h $@ \
+	"$(UTS_MACHINE)" "$(CONFIG_SMP)" "$(CONFIG_PREEMPT)" "$(CC) $(CFLAGS)"
+
 # vmlinux image - including updated kernel symbols
 vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) FORCE
 ifdef CONFIG_HEADERS_CHECK
@@ -852,8 +866,8 @@ endif
 # prepare2 creates a makefile if using a separate output directory
 prepare2: prepare3 outputmakefile
 
-prepare1: prepare2 include/linux/version.h include/linux/utsrelease.h \
-                   include/asm include/config/auto.conf
+prepare1: prepare2 generated_headers include/asm include/config/auto.conf
+
 ifneq ($(KBUILD_MODULES),)
 	$(Q)mkdir -p $(MODVERDIR)
 	$(Q)rm -f $(MODVERDIR)/*
@@ -922,14 +936,14 @@ export INSTALL_HDR_PATH
 HDRARCHES=$(filter-out generic,$(patsubst $(srctree)/include/asm-%/Kbuild,%,$(wildcard $(srctree)/include/asm-*/Kbuild)))
 
 PHONY += headers_install_all
-headers_install_all: include/linux/version.h scripts_basic FORCE
+headers_install_all: generated_headers scripts_basic FORCE
 	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
 	$(Q)for arch in $(HDRARCHES); do \
 	 $(MAKE) ARCH=$$arch -f $(srctree)/scripts/Makefile.headersinst obj=include BIASMDIR=-bi-$$arch ;\
 	 done
 
 PHONY += headers_install
-headers_install: include/linux/version.h scripts_basic FORCE
+headers_install: generated_headers scripts_basic FORCE
 	@if [ ! -r $(srctree)/include/asm-$(ARCH)/Kbuild ]; then \
 	  echo '*** Error: Headers not exportable for this architecture ($(ARCH))'; \
 	  exit 1 ; fi
@@ -1026,8 +1040,7 @@ CLEAN_FILES +=	vmlinux System.map \
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config include2 usr/include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
-                  include/linux/autoconf.h include/linux/version.h      \
-                  include/linux/utsrelease.h                            \
+                  include/linux/autoconf.h generated-headers		\
 		  Module.symvers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
diff -puN init/Makefile~build-compileh-earlier init/Makefile
--- a/init/Makefile~build-compileh-earlier
+++ a/init/Makefile
@@ -18,12 +18,3 @@ clean-files := ../include/linux/compile.
 $(obj)/main.o: include/linux/compile.h
 $(obj)/version.o: include/linux/compile.h
 
-# compile.h changes depending on hostname, generation number, etc,
-# so we regenerate it always.
-# mkcompile_h will make sure to only update the
-# actual file if its content has changed.
-
-include/linux/compile.h: FORCE
-	@echo '  CHK     $@'
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkcompile_h $@ \
-	"$(UTS_MACHINE)" "$(CONFIG_SMP)" "$(CONFIG_PREEMPT)" "$(CC) $(CFLAGS)"
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-agpgart.patch
cifs-sprintf-fix.patch
git-cpufreq.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input.patch
git-libata-all.patch
git-libata-all-fixup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
driver-for-silan-sc92031-netdev.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
spi-controller-driver-for-omap-microwire-tidy.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
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
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

