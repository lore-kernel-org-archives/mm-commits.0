From: akpm@linux-foundation.org
Subject: - remove-the-in-kernel-struct-dirent64.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:37 -0700
Message-ID: <200807252257.m6PMvbvO003204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754962AbYGYXGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, hirofumi@mail.parknet.co.jp, hpa@kernel.org, mm-commits@vger.kernel.org


The patch titled
     remove the in-kernel struct dirent{,64}
has been removed from the -mm tree.  Its filename was
     remove-the-in-kernel-struct-dirent64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove the in-kernel struct dirent{,64}
From: Adrian Bunk <bunk@kernel.org>

The kernel struct dirent{,64} were different from the ones in
userspace.

Even worse, we exported the kernel ones to userspace.

But after the fat usages are fixed we can remove the conflicting
kernel versions.

Reviewed-by: H. Peter Anvin <hpa@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild   |    1 -
 include/linux/dirent.h |   20 --------------------
 2 files changed, 21 deletions(-)

diff -puN include/linux/Kbuild~remove-the-in-kernel-struct-dirent64 include/linux/Kbuild
--- a/include/linux/Kbuild~remove-the-in-kernel-struct-dirent64
+++ a/include/linux/Kbuild
@@ -189,7 +189,6 @@ unifdef-y += connector.h
 unifdef-y += cuda.h
 unifdef-y += cyclades.h
 unifdef-y += dccp.h
-unifdef-y += dirent.h
 unifdef-y += dlm.h
 unifdef-y += dlm_plock.h
 unifdef-y += edd.h
diff -puN include/linux/dirent.h~remove-the-in-kernel-struct-dirent64 include/linux/dirent.h
--- a/include/linux/dirent.h~remove-the-in-kernel-struct-dirent64
+++ a/include/linux/dirent.h
@@ -1,23 +1,6 @@
 #ifndef _LINUX_DIRENT_H
 #define _LINUX_DIRENT_H
 
-struct dirent {
-	long		d_ino;
-	__kernel_off_t	d_off;
-	unsigned short	d_reclen;
-	char		d_name[256]; /* We must not include limits.h! */
-};
-
-struct dirent64 {
-	__u64		d_ino;
-	__s64		d_off;
-	unsigned short	d_reclen;
-	unsigned char	d_type;
-	char		d_name[256];
-};
-
-#ifdef __KERNEL__
-
 struct linux_dirent64 {
 	u64		d_ino;
 	s64		d_off;
@@ -26,7 +9,4 @@ struct linux_dirent64 {
 	char		d_name[0];
 };
 
-#endif	/* __KERNEL__ */
-
-
 #endif
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
include-video-atmel_lcdch-must-include-linux-workqueueh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

