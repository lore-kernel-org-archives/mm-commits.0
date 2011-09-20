From: akpm@google.com
Subject: [folded] dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix.patch removed from -mm tree
Date: Tue, 20 Sep 2011 14:15:47 -0700
Message-ID: <201109202115.p8KLFm3O032048@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:63355 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1ITVP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2011 17:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, greg@kroah.com, jbaron@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix
has been removed from the -mm tree.  Its filename was
     dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix.patch

This patch was dropped because it was folded into dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix

s/DECLARE/DEFINE/

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/dynamic_debug.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/dynamic_debug.h~dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix include/linux/dynamic_debug.h
--- a/include/linux/dynamic_debug.h~dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix
+++ a/include/linux/dynamic_debug.h
@@ -54,7 +54,7 @@ extern int __dynamic_netdev_dbg(struct _
 			     const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 
-#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
+#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
 	static struct _ddebug __used __aligned(8)		\
 	__attribute__((section("__verbose"))) name = {		\
 		.modname = KBUILD_MODNAME,			\
@@ -68,7 +68,7 @@ extern int __dynamic_netdev_dbg(struct _
 
 #define dynamic_pr_debug(fmt, ...)				\
 do {								\
-	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
 	if (unlikely(descriptor.enabled))			\
 		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
 				   ##__VA_ARGS__);		\
@@ -76,7 +76,7 @@ do {								\
 
 #define dynamic_dev_dbg(dev, fmt, ...)				\
 do {								\
-	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
 	if (unlikely(descriptor.enabled))			\
 		__dynamic_dev_dbg(&descriptor, dev, fmt,	\
 				  ##__VA_ARGS__);		\
@@ -84,7 +84,7 @@ do {								\
 
 #define dynamic_netdev_dbg(dev, fmt, ...)			\
 do {								\
-	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
 	if (unlikely(descriptor.enabled))			\
 		__dynamic_netdev_dbg(&descriptor, dev, fmt,	\
 				     ##__VA_ARGS__);		\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
block-document-blk-plug.patch
block-document-blk-plug-v3-fix.patch
block-blk-sysfsc-fix-kerneldoc-references.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
aio-allocate-kiocbs-in-batches-fix.patch
aio-allocate-kiocbs-in-batches-fix-fix.patch
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

