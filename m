From: akpm@linux-foundation.org
Subject: - compat-generic-compat-get-settimeofday-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:44:09 -0700
Message-ID: <200810152344.m9FNi981022849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbYJOXoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:44:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     compat-generic-compat-get-settimeofday-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     compat-generic-compat-get-settimeofday-checkpatch-fixes.patch

This patch was dropped because it was folded into compat-generic-compat-get-settimeofday.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: compat-generic-compat-get-settimeofday-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#628: FILE: arch/sparc64/kernel/systbls.S:44:
+	.word sys32_getgroups, compat_sys_gettimeofday, sys32_getrusage, sys_nis_syscall, sys_getcwd

WARNING: line over 80 characters
#629: FILE: arch/sparc64/kernel/systbls.S:45:
+/*120*/	.word compat_sys_readv, compat_sys_writev, compat_sys_settimeofday, sys_fchown16, sys_fchmod

ERROR: code indent should use tabs where possible
#806: FILE: kernel/compat.c:75:
+ ^Iif (tv) {$

total: 1 errors, 2 warnings, 693 lines checked

./patches/compat-generic-compat-get-settimeofday.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/compat.c~compat-generic-compat-get-settimeofday-checkpatch-fixes kernel/compat.c
--- a/kernel/compat.c~compat-generic-compat-get-settimeofday-checkpatch-fixes
+++ a/kernel/compat.c
@@ -72,7 +72,7 @@ asmlinkage long compat_sys_settimeofday(
 	struct timespec kts;
 	struct timezone ktz;
 
- 	if (tv) {
+	if (tv) {
 		if (compat_get_timeval(&kts, tv))
 			return -EFAULT;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

