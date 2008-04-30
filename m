From: akpm@linux-foundation.org
Subject: - make-binfmt_flat-a-bool.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:41 -0700
Message-ID: <200804300539.m3U5df7O028872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbYD3Fj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, cooloney.lkml@gmail.com, mm-commits@vger.kernel.org


The patch titled
     make BINFMT_FLAT a bool
has been removed from the -mm tree.  Its filename was
     make-binfmt_flat-a-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make BINFMT_FLAT a bool
From: Adrian Bunk <bunk@kernel.org>

I have not yet seen anyone saying he has a reasonable use case for using
BINFMT_FLAT modular on his embedded device.

Considering that fs/binfmt_flat.c even lacks a MODULE_LICENSE() I really doubt
there is any, and this patch therefore makes BINFMT_FLAT a bool.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Bryan Wu <cooloney.lkml@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt |    2 +-
 fs/binfmt_flat.c  |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN fs/Kconfig.binfmt~make-binfmt_flat-a-bool fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~make-binfmt_flat-a-bool
+++ a/fs/Kconfig.binfmt
@@ -41,7 +41,7 @@ config BINFMT_ELF_FDPIC
 	  It is also possible to run FDPIC ELF binaries on MMU linux also.
 
 config BINFMT_FLAT
-	tristate "Kernel support for flat binaries"
+	bool "Kernel support for flat binaries"
 	depends on !MMU
 	help
 	  Support uClinux FLAT format binaries.
diff -puN fs/binfmt_flat.c~make-binfmt_flat-a-bool fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~make-binfmt_flat-a-bool
+++ a/fs/binfmt_flat.c
@@ -932,14 +932,8 @@ static int __init init_flat_binfmt(void)
 	return register_binfmt(&flat_format);
 }
 
-static void __exit exit_flat_binfmt(void)
-{
-	unregister_binfmt(&flat_format);
-}
-
 /****************************************************************************/
 
 core_initcall(init_flat_binfmt);
-module_exit(exit_flat_binfmt);
 
 /****************************************************************************/
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

