From: akpm@linux-foundation.org
Subject: [merged] fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:52 -0800
Message-ID: <5489eb10.zwArsVNpNgOeVZG3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbaLKTFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_misc.c: use GFP_KERNEL instead of GFP_USER
has been removed from the -mm tree.  Its filename was
     fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/binfmt_misc.c: use GFP_KERNEL instead of GFP_USER

GFP_USER means "honour cpuset nodes-allowed beancounting".  These are
regular old kernel objects and there seems no reason to give them this
treatment.

Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_misc.c~fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user
+++ a/fs/binfmt_misc.c
@@ -308,7 +308,7 @@ static Node *create_entry(const char __u
 
 	err = -ENOMEM;
 	memsize = sizeof(Node) + count + 8;
-	e = kmalloc(memsize, GFP_USER);
+	e = kmalloc(memsize, GFP_KERNEL);
 	if (!e)
 		goto out;
 
@@ -416,7 +416,7 @@ static Node *create_entry(const char __u
 
 			if (e->mask) {
 				int i;
-				char *masked = kmalloc(e->size, GFP_USER);
+				char *masked = kmalloc(e->size, GFP_KERNEL);
 
 				print_hex_dump_bytes(
 					KBUILD_MODNAME ": register:  mask[decoded]: ",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle-checkpatch-fixes.patch
include-linux-kmemleakh-needs-slabh.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

