From: akpm@google.com
Subject: [wrecked] lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch removed from -mm tree
Date: Tue, 27 Sep 2011 12:10:58 -0700
Message-ID: <201109271910.p8RJAwYV017196@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:20685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1I0TLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 15:11:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andy.shevchenko@gmail.com, dhowells@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/hexdump.c: make hex2bin() return the updated `src' address
has been removed from the -mm tree.  Its filename was
     lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/hexdump.c: make hex2bin() return the updated `src' address

As a convenience to callers.

Not a terribly convenient convenience, as most callers will need to cast
away the constness of the return value.  Oh well, those callers should
have been using a `const char *' anyway.

Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/kernel.h |    2 +-
 lib/hexdump.c          |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~lib-hexdumpc-make-hex2bin-return-the-updated-src-address include/linux/kernel.h
--- a/include/linux/kernel.h~lib-hexdumpc-make-hex2bin-return-the-updated-src-address
+++ a/include/linux/kernel.h
@@ -384,7 +384,7 @@ static inline char *pack_hex_byte(char *
 }
 
 extern int hex_to_bin(char ch);
-extern void hex2bin(u8 *dst, const char *src, size_t count);
+extern const char *hex2bin(u8 *dst, const char *src, size_t count);
 
 /*
  * General tracing related utility functions - trace_printk(),
diff -puN lib/hexdump.c~lib-hexdumpc-make-hex2bin-return-the-updated-src-address lib/hexdump.c
--- a/lib/hexdump.c~lib-hexdumpc-make-hex2bin-return-the-updated-src-address
+++ a/lib/hexdump.c
@@ -39,13 +39,14 @@ EXPORT_SYMBOL(hex_to_bin);
  * @src: ascii hexadecimal string
  * @count: result length
  */
-void hex2bin(u8 *dst, const char *src, size_t count)
+const char *hex2bin(u8 *dst, const char *src, size_t count)
 {
 	while (count--) {
 		*dst = hex_to_bin(*src++) << 4;
 		*dst += hex_to_bin(*src++);
 		dst++;
 	}
+	return src;
 }
 EXPORT_SYMBOL(hex2bin);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
drivers-block-mtip32xx-mtip32xxc-fix-warning.patch
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
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
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

