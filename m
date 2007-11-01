From: akpm@linux-foundation.org
Subject: + make-jffs2_get_acl-static.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:50:02 -0700
Message-ID: <200711010750.lA17o21W018995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128AbXKAHub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, dwmw2@infradead.org, kaigai@ak.jp.nec.com


The patch titled
     make jffs2_get_acl() static
has been added to the -mm tree.  Its filename is
     make-jffs2_get_acl-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make jffs2_get_acl() static
From: Adrian Bunk <bunk@kernel.org>

jffs2_get_acl() can now become static again.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/acl.c |    2 +-
 fs/jffs2/acl.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/jffs2/acl.c~make-jffs2_get_acl-static fs/jffs2/acl.c
--- a/fs/jffs2/acl.c~make-jffs2_get_acl-static
+++ a/fs/jffs2/acl.c
@@ -176,7 +176,7 @@ static void jffs2_iset_acl(struct inode 
 	spin_unlock(&inode->i_lock);
 }
 
-struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
+static struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
 {
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	struct posix_acl *acl;
diff -puN fs/jffs2/acl.h~make-jffs2_get_acl-static fs/jffs2/acl.h
--- a/fs/jffs2/acl.h~make-jffs2_get_acl-static
+++ a/fs/jffs2/acl.h
@@ -28,7 +28,6 @@ struct jffs2_acl_header {
 
 #define JFFS2_ACL_NOT_CACHED ((void *)-1)
 
-extern struct posix_acl *jffs2_get_acl(struct inode *inode, int type);
 extern int jffs2_permission(struct inode *, int, struct nameidata *);
 extern int jffs2_acl_chmod(struct inode *);
 extern int jffs2_init_acl_pre(struct inode *, struct inode *, int *);
@@ -40,7 +39,6 @@ extern struct xattr_handler jffs2_acl_de
 
 #else
 
-#define jffs2_get_acl(inode, type)		(NULL)
 #define jffs2_permission			(NULL)
 #define jffs2_acl_chmod(inode)			(0)
 #define jffs2_init_acl_pre(dir_i,inode,mode)	(0)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
xtensa-iss_net_setup-must-be-__init.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
scheduled-oss-driver-removal.patch
cleanup-after-apus-removal.patch
53c7xx-removal-fallout.patch
remove-mm_ptovvtop.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
