From: akpm@linux-foundation.org
Subject: - fs-ramfs-extern-cleanup.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:14 -0700
Message-ID: <200804300539.m3U5dEK4028820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723AbYD3Fjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs/ramfs/ extern cleanup
has been removed from the -mm tree.  Its filename was
     fs-ramfs-extern-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ramfs/ extern cleanup
From: Adrian Bunk <bunk@kernel.org>

- internal.h shouldn't duplicate the extern declaration for
  ramfs_file_operations already in include/linux/ramfs.h
- file-mmu.c needs two #include's for seeing the extern declarations
  of it's global struct's

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-mmu.c |    3 +++
 fs/ramfs/internal.h |    1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ramfs/file-mmu.c~fs-ramfs-extern-cleanup fs/ramfs/file-mmu.c
--- a/fs/ramfs/file-mmu.c~fs-ramfs-extern-cleanup
+++ a/fs/ramfs/file-mmu.c
@@ -26,6 +26,9 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/ramfs.h>
+
+#include "internal.h"
 
 const struct address_space_operations ramfs_aops = {
 	.readpage	= simple_readpage,
diff -puN fs/ramfs/internal.h~fs-ramfs-extern-cleanup fs/ramfs/internal.h
--- a/fs/ramfs/internal.h~fs-ramfs-extern-cleanup
+++ a/fs/ramfs/internal.h
@@ -11,5 +11,4 @@
 
 
 extern const struct address_space_operations ramfs_aops;
-extern const struct file_operations ramfs_file_operations;
 extern const struct inode_operations ramfs_file_inode_operations;
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

