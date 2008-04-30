From: akpm@linux-foundation.org
Subject: - fs-drop_cachesc-make-2-functions-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:28 -0700
Message-ID: <200804300539.m3U5dSYF028849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbYD3Fjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs/drop_caches.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     fs-drop_cachesc-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/drop_caches.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- drop_pagecache()
- drop_slab()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c   |    4 ++--
 include/linux/mm.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/drop_caches.c~fs-drop_cachesc-make-2-functions-static fs/drop_caches.c
--- a/fs/drop_caches.c~fs-drop_cachesc-make-2-functions-static
+++ a/fs/drop_caches.c
@@ -25,7 +25,7 @@ static void drop_pagecache_sb(struct sup
 	spin_unlock(&inode_lock);
 }
 
-void drop_pagecache(void)
+static void drop_pagecache(void)
 {
 	struct super_block *sb;
 
@@ -45,7 +45,7 @@ restart:
 	spin_unlock(&sb_lock);
 }
 
-void drop_slab(void)
+static void drop_slab(void)
 {
 	int nr_objects;
 
diff -puN include/linux/mm.h~fs-drop_cachesc-make-2-functions-static include/linux/mm.h
--- a/include/linux/mm.h~fs-drop_cachesc-make-2-functions-static
+++ a/include/linux/mm.h
@@ -1230,8 +1230,6 @@ int drop_caches_sysctl_handler(struct ct
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			unsigned long lru_pages);
-void drop_pagecache(void);
-void drop_slab(void);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
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

