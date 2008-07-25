From: akpm@linux-foundation.org
Subject: - proper-pidhashmap_init-prototypes.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:24 -0700
Message-ID: <200807252302.m6PN2OGG003822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361AbYGYXGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     proper pid{hash,map}_init() prototypes
has been removed from the -mm tree.  Its filename was
     proper-pidhashmap_init-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper pid{hash,map}_init() prototypes
From: Adrian Bunk <bunk@kernel.org>

This patch adds proper prototypes for pid{hash,map}_init() in
include/linux/pid_namespace.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    3 +++
 init/main.c                   |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/pid_namespace.h~proper-pidhashmap_init-prototypes include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~proper-pidhashmap_init-prototypes
+++ a/include/linux/pid_namespace.h
@@ -85,4 +85,7 @@ static inline struct task_struct *task_c
 	return tsk->nsproxy->pid_ns->child_reaper;
 }
 
+void pidhash_init(void);
+void pidmap_init(void);
+
 #endif /* _LINUX_PID_NS_H */
diff -puN init/main.c~proper-pidhashmap_init-prototypes init/main.c
--- a/init/main.c~proper-pidhashmap_init-prototypes
+++ a/init/main.c
@@ -87,8 +87,6 @@ extern void init_IRQ(void);
 extern void fork_init(unsigned long);
 extern void mca_init(void);
 extern void sbus_init(void);
-extern void pidhash_init(void);
-extern void pidmap_init(void);
 extern void prio_tree_init(void);
 extern void radix_tree_init(void);
 extern void free_initmem(void);
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

