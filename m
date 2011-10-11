From: akpm@google.com
Subject: [folded] treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 11 Oct 2011 11:50:15 -0700
Message-ID: <201110111850.p9BIoFOJ010388@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:28035 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab1JKSuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 14:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch

This patch was dropped because it was folded into treewide-use-__printf-not-__attribute__formatprintf.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes

WARNING: externs should be avoided in .c files
#99: FILE: arch/alpha/boot/misc.c:28:
+extern __printf(1, 2) long srm_printk(const char *, ...);

ERROR: space required after that ';' (ctx:VxV)
#178: FILE: arch/powerpc/boot/ps3.c:39:
+static inline __printf(1, 2) int DBG(const char *fmt, ...) {return 0;}
                                                                     ^

ERROR: "foo* bar" should be "foo *bar"
#225: FILE: arch/s390/include/asm/debug.h:175:
+debug_sprintf_event(debug_info_t* id, int level, char *string, ...);

ERROR: space required after that ',' (ctx:VxV)
#237: FILE: arch/s390/include/asm/debug.h:216:
+debug_sprintf_exception(debug_info_t *id, int level, char *string,...);
                                                                  ^

WARNING: space prohibited between function name and open parenthesis '('
#494: FILE: fs/ext2/ext2.h:139:
+void ext2_error (struct super_block *, const char *, const char *, ...);

WARNING: printk() should include KERN_ facility level
#719: FILE: fs/partitions/ldm.c:63:
+	printk("%s%s(): %pV\n", level, function, &vaf);

WARNING: space prohibited between function name and open parenthesis '('
#721: FILE: fs/partitions/ldm.c:65:
+	va_end (args);

WARNING: space prohibited between function name and open parenthesis '('
#750: FILE: fs/ufs/ufs.h:121:
+void ufs_warning (struct super_block *, const char *, const char *, ...);

WARNING: space prohibited between function name and open parenthesis '('
#752: FILE: fs/ufs/ufs.h:123:
+void ufs_error (struct super_block *, const char *, const char *, ...);

WARNING: space prohibited between function name and open parenthesis '('
#754: FILE: fs/ufs/ufs.h:125:
+void ufs_panic (struct super_block *, const char *, const char *, ...);

WARNING: space prohibited between function name and open parenthesis '('
#1074: FILE: include/linux/ext3_fs.h:941:
+void ext3_error (struct super_block *, const char *, const char *, ...);

WARNING: space prohibited between function name and open parenthesis '('
#1083: FILE: include/linux/ext3_fs.h:944:
+void ext3_abort (struct super_block *, const char *, const char *, ...);

WARNING: space prohibited between function name and open parenthesis '('
#1085: FILE: include/linux/ext3_fs.h:946:
+void ext3_warning (struct super_block *, const char *, const char *, ...);

WARNING: do not add new typedefs
#1178: FILE: include/linux/kdb.h:119:
+typedef __printf(1, 2) int (*kdb_printf_t)(const char *, ...);

ERROR: "foo * bar" should be "foo *bar"
#1203: FILE: include/linux/kernel.h:299:
+extern __printf(2, 3) int sprintf(char * buf, const char * fmt, ...);

ERROR: "foo * bar" should be "foo *bar"
#1206: FILE: include/linux/kernel.h:302:
+int snprintf(char * buf, size_t size, const char * fmt, ...);

ERROR: "foo * bar" should be "foo *bar"
#1210: FILE: include/linux/kernel.h:306:
+int scnprintf(char * buf, size_t size, const char * fmt, ...);

total: 6 errors, 11 warnings, 1375 lines checked

./patches/treewide-use-__printf-not-__attribute__formatprintf.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/debug.h |    4 ++--
 fs/ext2/ext2.h                |    2 +-
 fs/partitions/ldm.c           |    2 +-
 fs/ufs/ufs.h                  |    6 +++---
 include/linux/ext3_fs.h       |    6 +++---
 include/linux/kernel.h        |    6 +++---
 6 files changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/s390/include/asm/debug.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes arch/s390/include/asm/debug.h
--- a/arch/s390/include/asm/debug.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes
+++ a/arch/s390/include/asm/debug.h
@@ -172,7 +172,7 @@ debug_text_event(debug_info_t* id, int l
  * stored in the s390dbf. See Documentation/s390/s390dbf.txt for more details!
  */
 extern __printf(3, 4) debug_entry_t *
-debug_sprintf_event(debug_info_t* id, int level, char *string, ...);
+debug_sprintf_event(debug_info_t *id, int level, char *string, ...);
 
 static inline debug_entry_t*
 debug_exception(debug_info_t* id, int level, void* data, int length)
@@ -213,7 +213,7 @@ debug_text_exception(debug_info_t* id, i
  * stored in the s390dbf. See Documentation/s390/s390dbf.txt for more details!
  */
 extern __printf(3, 4) debug_entry_t *
-debug_sprintf_exception(debug_info_t *id, int level, char *string,...);
+debug_sprintf_exception(debug_info_t *id, int level, char *string, ...);
 
 int debug_register_view(debug_info_t* id, struct debug_view* view);
 int debug_unregister_view(debug_info_t* id, struct debug_view* view);
diff -puN fs/ext2/ext2.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes
+++ a/fs/ext2/ext2.h
@@ -136,7 +136,7 @@ struct dentry *ext2_get_parent(struct de
 
 /* super.c */
 extern __printf(3, 4)
-void ext2_error (struct super_block *, const char *, const char *, ...);
+void ext2_error(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
 void ext2_msg(struct super_block *, const char *, const char *, ...);
 extern void ext2_update_dynamic_rev (struct super_block *sb);
diff -puN fs/partitions/ldm.c~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes
+++ a/fs/partitions/ldm.c
@@ -62,7 +62,7 @@ void _ldm_printk(const char *level, cons
 
 	printk("%s%s(): %pV\n", level, function, &vaf);
 
-	va_end (args);
+	va_end(args);
 }
 
 /**
diff -puN fs/ufs/ufs.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes
+++ a/fs/ufs/ufs.h
@@ -118,11 +118,11 @@ extern const struct file_operations ufs_
 
 /* super.c */
 extern __printf(3, 4)
-void ufs_warning (struct super_block *, const char *, const char *, ...);
+void ufs_warning(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
-void ufs_error (struct super_block *, const char *, const char *, ...);
+void ufs_error(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
-void ufs_panic (struct super_block *, const char *, const char *, ...);
+void ufs_panic(struct super_block *, const char *, const char *, ...);
 
 /* symlink.c */
 extern const struct inode_operations ufs_fast_symlink_inode_operations;
diff -puN include/linux/ext3_fs.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes
+++ a/include/linux/ext3_fs.h
@@ -938,12 +938,12 @@ extern int ext3_group_extend(struct supe
 
 /* super.c */
 extern __printf(3, 4)
-void ext3_error (struct super_block *, const char *, const char *, ...);
+void ext3_error(struct super_block *, const char *, const char *, ...);
 extern void __ext3_std_error (struct super_block *, const char *, int);
 extern __printf(3, 4)
-void ext3_abort (struct super_block *, const char *, const char *, ...);
+void ext3_abort(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
-void ext3_warning (struct super_block *, const char *, const char *, ...);
+void ext3_warning(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
 void ext3_msg(struct super_block *, const char *, const char *, ...);
 extern void ext3_update_dynamic_rev (struct super_block *sb);
diff -puN include/linux/kernel.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes include/linux/kernel.h
--- a/include/linux/kernel.h~treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes
+++ a/include/linux/kernel.h
@@ -296,14 +296,14 @@ extern long long simple_strtoll(const ch
 #define strict_strtoull	kstrtoull
 #define strict_strtoll	kstrtoll
 
-extern __printf(2, 3) int sprintf(char * buf, const char * fmt, ...);
+extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
 extern __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
 extern __printf(3, 4)
-int snprintf(char * buf, size_t size, const char * fmt, ...);
+int snprintf(char *buf, size_t size, const char *fmt, ...);
 extern __printf(3, 0)
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
 extern __printf(3, 4)
-int scnprintf(char * buf, size_t size, const char * fmt, ...);
+int scnprintf(char *buf, size_t size, const char *fmt, ...);
 extern __printf(3, 0)
 int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
 extern __printf(2, 3)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
treewide-use-__printf-not-__attribute__formatprintf.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

