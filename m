From: akpm@linux-foundation.org
Subject: - move-proc_kmsg_operations-to-fs-proc-internalh.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:09 -0700
Message-ID: <200807252302.m6PN29k9003801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877AbYGYXCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     move proc_kmsg_operations to fs/proc/internal.h
has been removed from the -mm tree.  Its filename was
     move-proc_kmsg_operations-to-fs-proc-internalh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: move proc_kmsg_operations to fs/proc/internal.h
From: Adrian Bunk <bunk@kernel.org>

This patch moves the extern of struct proc_kmsg_operations to
fs/proc/internal.h and adds an #include "internal.h" to fs/proc/kmsg.c
so that the latter sees the former.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h      |    1 +
 fs/proc/kmsg.c          |    2 ++
 include/linux/proc_fs.h |    1 -
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/internal.h~move-proc_kmsg_operations-to-fs-proc-internalh fs/proc/internal.h
--- a/fs/proc/internal.h~move-proc_kmsg_operations-to-fs-proc-internalh
+++ a/fs/proc/internal.h
@@ -63,6 +63,7 @@ extern const struct file_operations proc
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
 extern const struct file_operations proc_net_operations;
+extern const struct file_operations proc_kmsg_operations;
 extern const struct inode_operations proc_net_inode_operations;
 
 void free_proc_entry(struct proc_dir_entry *de);
diff -puN fs/proc/kmsg.c~move-proc_kmsg_operations-to-fs-proc-internalh fs/proc/kmsg.c
--- a/fs/proc/kmsg.c~move-proc_kmsg_operations-to-fs-proc-internalh
+++ a/fs/proc/kmsg.c
@@ -15,6 +15,8 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#include "internal.h"
+
 extern wait_queue_head_t log_wait;
 
 extern int do_syslog(int type, char __user *bug, int count);
diff -puN include/linux/proc_fs.h~move-proc_kmsg_operations-to-fs-proc-internalh include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~move-proc_kmsg_operations-to-fs-proc-internalh
+++ a/include/linux/proc_fs.h
@@ -138,7 +138,6 @@ extern int proc_readdir(struct file *, v
 extern struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
 
 extern const struct file_operations proc_kcore_operations;
-extern const struct file_operations proc_kmsg_operations;
 extern const struct file_operations ppc_htab_operations;
 
 extern int pid_ns_prepare_proc(struct pid_namespace *ns);
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

