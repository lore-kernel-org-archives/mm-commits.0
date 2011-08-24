From: akpm@linux-foundation.org
Subject: [obsolete] fs-xfs-xfs_iopsc-unbork.patch removed from -mm tree
Date: Wed, 24 Aug 2011 11:33:03 -0700
Message-ID: <201108241829.p7OITvmT031428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753557Ab1HXS37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Aug 2011 14:29:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aelder@sgi.com, mm-commits@vger.kernel.org


The patch titled
     fs/xfs/xfs_iops.c: unbork
has been removed from the -mm tree.  Its filename was
     fs-xfs-xfs_iopsc-unbork.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/xfs/xfs_iops.c: unbork
From: Andrew Morton <akpm@linux-foundation.org>

fs/xfs/xfs_iops.c: In function 'xfs_init_security':
fs/xfs/xfs_iops.c:116: warning: passing argument 4 of 'security_inode_init_security' from incompatible pointer type
include/linux/security.h:1711: note: expected 'initxattrs' but argument is of type 'char **'
fs/xfs/xfs_iops.c:116: error: too many arguments to function 'security_inode_ini

Not sure what's going on here, but I can't be bothered fixing it.

Cc: Alex Elder <aelder@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_iops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/xfs/xfs_iops.c~fs-xfs-xfs_iopsc-unbork fs/xfs/xfs_iops.c
--- a/fs/xfs/xfs_iops.c~fs-xfs-xfs_iopsc-unbork
+++ a/fs/xfs/xfs_iops.c
@@ -112,6 +112,7 @@ xfs_init_security(
 	unsigned char	*name;
 	int		error;
 
+#if 0
 	error = security_inode_init_security(inode, dir, qstr, (char **)&name,
 					     &value, &length);
 	if (error) {
@@ -119,7 +120,7 @@ xfs_init_security(
 			return 0;
 		return -error;
 	}
-
+#endif
 	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
 
 	kfree(name);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
alpha-unbreak-osf_setsysinfossi_nvpairs-checkpatch-fixes.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
drivers-base-inodec-let-vmstat_text-be-optional-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

