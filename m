From: akpm@linux-foundation.org
Subject: - make-init-do_mountsc-root_device_name-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:22 -0700
Message-ID: <200807262118.m6QLIM62020085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758041AbYGZVSa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make init/do_mounts.c:root_device_name static
has been removed from the -mm tree.  Its filename was
     make-init-do_mountsc-root_device_name-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make init/do_mounts.c:root_device_name static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global root_device_name static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 +-
 init/do_mounts.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN init/do_mounts.c~make-init-do_mountsc-root_device_name-static init/do_mounts.c
--- a/init/do_mounts.c~make-init-do_mountsc-root_device_name-static
+++ a/init/do_mounts.c
@@ -23,7 +23,7 @@
 int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
 
 int root_mountflags = MS_RDONLY | MS_SILENT;
-char * __initdata root_device_name;
+static char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
 static int __initdata root_wait;
 
diff -puN init/do_mounts.h~make-init-do_mountsc-root_device_name-static init/do_mounts.h
--- a/init/do_mounts.h~make-init-do_mountsc-root_device_name-static
+++ a/init/do_mounts.h
@@ -11,7 +11,6 @@ void  change_floppy(char *fmt, ...);
 void  mount_block_root(char *name, int flags);
 void  mount_root(void);
 extern int root_mountflags;
-extern char *root_device_name;
 
 static inline int create_dev(char *name, dev_t dev)
 {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

