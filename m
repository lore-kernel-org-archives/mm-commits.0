From: akpm@linux-foundation.org
Subject: [merged] h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:33 -0700
Message-ID: <201107271927.p6RJRJLc003205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1G0T16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@zankel.net, drepper@gmail.com, geert@linux-m68k.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300/m68k/xtensa: __FD_ISSET should return 0/1
has been removed from the -mm tree.  Its filename was
     h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300/m68k/xtensa: __FD_ISSET should return 0/1
From: Andrew Morton <akpm@linux-foundation.org>

Harmonise these return values with other architectures.  In some cases
this affects all compilers and in other cases non-gcc compilers only.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/posix_types.h  |    2 +-
 arch/m68k/include/asm/posix_types.h   |    2 +-
 arch/xtensa/include/asm/posix_types.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/h8300/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1 arch/h8300/include/asm/posix_types.h
--- a/arch/h8300/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1
+++ a/arch/h8300/include/asm/posix_types.h
@@ -50,7 +50,7 @@ typedef struct {
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
 
 #undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	((set)->fds_bits[__FDELT(d)] & __FDMASK(d))
+#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
 
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
diff -puN arch/m68k/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1 arch/m68k/include/asm/posix_types.h
--- a/arch/m68k/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1
+++ a/arch/m68k/include/asm/posix_types.h
@@ -51,7 +51,7 @@ typedef struct {
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
 
 #undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	((set)->fds_bits[__FDELT(d)] & __FDMASK(d))
+#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
 
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
diff -puN arch/xtensa/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1 arch/xtensa/include/asm/posix_types.h
--- a/arch/xtensa/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1
+++ a/arch/xtensa/include/asm/posix_types.h
@@ -58,7 +58,7 @@ typedef struct {
 
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-#define	__FD_ISSET(d, set)	((set)->fds_bits[__FDELT(d)] & __FDMASK(d))
+#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
 #define	__FD_ZERO(set)	\
   ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

