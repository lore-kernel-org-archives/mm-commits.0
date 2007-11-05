From: akpm@linux-foundation.org
Subject: + remove-__attribute_used__-checkpatch-fixes.patch added to -mm tree
Date: Mon, 05 Nov 2007 14:58:26 -0800
Message-ID: <200711052258.lA5MwQRV023982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbXKEW6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 17:58:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bunk@kernel.org, rientjes@google.com


The patch titled
     remove-__attribute_used__-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     remove-__attribute_used__-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove-__attribute_used__-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#132: FILE: arch/um/include/init.h:106:
+#define __uml_init_setup	__used __attribute__ ((__section__ (".uml.setup.init")))

WARNING: line over 80 characters
#133: FILE: arch/um/include/init.h:107:
+#define __uml_setup_help	__used __attribute__ ((__section__ (".uml.help.init")))

WARNING: line over 80 characters
#134: FILE: arch/um/include/init.h:108:
+#define __uml_init_call		__used __attribute__ ((__section__ (".uml.initcall.init")))

WARNING: line over 80 characters
#135: FILE: arch/um/include/init.h:109:
+#define __uml_postsetup_call	__used __attribute__ ((__section__ (".uml.postsetup.init")))

WARNING: line over 80 characters
#136: FILE: arch/um/include/init.h:110:
+#define __uml_exit_call		__used __attribute__ ((__section__ (".uml.exitcall.exit")))

ERROR: use tabs not spaces
#163: FILE: drivers/rapidio/rio.h:34:
+        static struct rio_route_ops __rio_route_ops __used   \$

WARNING: no space between function name and open parenthesis '('
#199: FILE: include/asm-ia64/gcc_intrin.h:27:
+register unsigned long ia64_r13 asm ("r13") __used;

WARNING: no space between function name and open parenthesis '('
#211: FILE: include/asm-sh/machvec.h:71:
+	__used __attribute__((__section__ (".machvec.init")))

WARNING: line over 80 characters
#306: FILE: include/linux/init.h:65:
+#define __exit		__used __attribute__ ((__section__(".exit.text"))) __cold

ERROR: need spaces around that '=' (ctx:VxV)
#324: FILE: include/linux/init.h:146:
+	__used __attribute__((__section__(".con_initcall.init")))=fn
 	                                                         ^

total: 2 errors, 8 warnings, 286 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Adrian Bunk <bunk@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.h         |    2 +-
 include/asm-ia64/gcc_intrin.h |    2 +-
 include/asm-sh/machvec.h      |    2 +-
 include/linux/init.h          |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/rio.h~remove-__attribute_used__-checkpatch-fixes drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~remove-__attribute_used__-checkpatch-fixes
+++ a/drivers/rapidio/rio.h
@@ -31,7 +31,7 @@ extern struct rio_route_ops __end_rio_ro
 
 /* Helpers internal to the RIO core code */
 #define DECLARE_RIO_ROUTE_SECTION(section, vid, did, add_hook, get_hook)  \
-        static struct rio_route_ops __rio_route_ops __used   \
+	static struct rio_route_ops __rio_route_ops __used   \
 	        __attribute__((__section__(#section))) = { vid, did, add_hook, get_hook };
 
 /**
diff -puN include/asm-ia64/gcc_intrin.h~remove-__attribute_used__-checkpatch-fixes include/asm-ia64/gcc_intrin.h
--- a/include/asm-ia64/gcc_intrin.h~remove-__attribute_used__-checkpatch-fixes
+++ a/include/asm-ia64/gcc_intrin.h
@@ -24,7 +24,7 @@
 extern void ia64_bad_param_for_setreg (void);
 extern void ia64_bad_param_for_getreg (void);
 
-register unsigned long ia64_r13 asm ("r13") __used;
+register unsigned long ia64_r13 asm("r13") __used;
 
 #define ia64_setreg(regnum, val)						\
 ({										\
diff -puN include/asm-sh/machvec.h~remove-__attribute_used__-checkpatch-fixes include/asm-sh/machvec.h
--- a/include/asm-sh/machvec.h~remove-__attribute_used__-checkpatch-fixes
+++ a/include/asm-sh/machvec.h
@@ -68,6 +68,6 @@ extern struct sh_machine_vector sh_mv;
 #define get_system_type()	sh_mv.mv_name
 
 #define __initmv \
-	__used __attribute__((__section__ (".machvec.init")))
+	__used __attribute__((__section__(".machvec.init")))
 
 #endif /* _ASM_SH_MACHVEC_H */
diff -puN include/linux/init.h~remove-__attribute_used__-checkpatch-fixes include/linux/init.h
--- a/include/linux/init.h~remove-__attribute_used__-checkpatch-fixes
+++ a/include/linux/init.h
@@ -62,7 +62,7 @@
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text"))) __cold
 #else
-#define __exit		__used __attribute__ ((__section__(".exit.text"))) __cold
+#define __exit		__used __attribute__((__section__(".exit.text"))) __cold
 #endif
 
 /* For assembly routines */
@@ -143,7 +143,7 @@ void prepare_namespace(void);
 
 #define console_initcall(fn) \
 	static initcall_t __initcall_##fn \
-	__used __attribute__((__section__(".con_initcall.init")))=fn
+	__used __attribute__((__section__(".con_initcall.init"))) = fn
 
 #define security_initcall(fn) \
 	static initcall_t __initcall_##fn \
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-arm-fixup.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
git-nfsd-fixup.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int-checkpatch-fixes.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
git-unionfs.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-make-i8259_64-more-_32-like-checkpatch-fixes.patch
git-perfmon-fixup.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
mn10300-suppress-aout-library-support-in-elf-binfmt-if-fix.patch
remove-__attribute_used__-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
