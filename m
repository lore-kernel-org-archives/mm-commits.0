From: akpm@linux-foundation.org
Subject: [folded] dynamic_debug-use-a-single-printk-to-emit-messages-fix.patch removed from -mm tree
Date: Tue, 20 Sep 2011 14:16:18 -0700
Message-ID: <201109202116.p8KLGIJu011914@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:53128 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1ITVQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2011 17:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, greg@kroah.com, jbaron@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug-use-a-single-printk-to-emit-messages-fix
has been removed from the -mm tree.  Its filename was
     dynamic_debug-use-a-single-printk-to-emit-messages-fix.patch

This patch was dropped because it was folded into dynamic_debug-use-a-single-printk-to-emit-messages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dynamic_debug-use-a-single-printk-to-emit-messages-fix

covnert dangerous macro to C

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 lib/dynamic_debug.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-use-a-single-printk-to-emit-messages-fix lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-use-a-single-printk-to-emit-messages-fix
+++ a/lib/dynamic_debug.c
@@ -422,31 +422,39 @@ static int ddebug_exec_query(char *query
 }
 
 #define PREFIX_SIZE 64
-#define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
+
+static int remaining(int wrote)
+{
+	if (PREFIX_SIZE - wrote > 0)
+		return PREFIX_SIZE - wrote;
+	return 0;
+}
 
 static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
 {
 	int pos_after_tid;
 	int pos = 0;
 
-	pos += snprintf(buf + pos, LEFT(pos), "%s", KERN_DEBUG);
+	pos += snprintf(buf + pos, remaining(pos), "%s", KERN_DEBUG);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
 		if (in_interrupt())
-			pos += snprintf(buf + pos, LEFT(pos), "%s ",
+			pos += snprintf(buf + pos, remaining(pos), "%s ",
 						"<intr>");
 		else
-			pos += snprintf(buf + pos, LEFT(pos), "[%d] ",
+			pos += snprintf(buf + pos, remaining(pos), "[%d] ",
 						task_pid_vnr(current));
 	}
 	pos_after_tid = pos;
 	if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
-		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->modname);
+		pos += snprintf(buf + pos, remaining(pos), "%s:",
+					desc->modname);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
-		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
+		pos += snprintf(buf + pos, remaining(pos), "%s:",
+					desc->function);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		pos += snprintf(buf + pos, LEFT(pos), "%d:", desc->lineno);
+		pos += snprintf(buf + pos, remaining(pos), "%d:", desc->lineno);
 	if (pos - pos_after_tid)
-		pos += snprintf(buf + pos, LEFT(pos), " ");
+		pos += snprintf(buf + pos, remaining(pos), " ");
 	if (pos >= PREFIX_SIZE)
 		buf[PREFIX_SIZE - 1] = '\0';
 
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
dynamic_debug-use-a-single-printk-to-emit-messages.patch
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

