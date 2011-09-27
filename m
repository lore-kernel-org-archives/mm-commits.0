From: akpm@google.com
Subject: [wrecked] fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch removed from -mm tree
Date: Tue, 27 Sep 2011 12:11:07 -0700
Message-ID: <201109271911.p8RJB7Zx008164@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:21036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1I0TLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 15:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andy.shevchenko@gmail.com, dhowells@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix
has been removed from the -mm tree.  Its filename was
     fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix

Use hex2bin()

Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 fs/binfmt_misc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/binfmt_misc.c~fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix
+++ a/fs/binfmt_misc.c
@@ -243,9 +243,7 @@ static int unquote(char *from)
 
 	while ((c = *s++) != '\0') {
 		if (c == '\\' && *s == 'x') {
-			s++;
-			*p = hex_to_bin(*s++) << 4;
-			*p++ |= hex_to_bin(*s++);
+			s = (char *)hex2bin(p, s + 1, 1);
 			continue;
 		}
 		*p++ = c;
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

