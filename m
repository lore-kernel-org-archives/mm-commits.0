From: akpm@linux-foundation.org
Subject: + fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch added to -mm tree
Date: Fri, 02 Jan 2015 15:47:50 -0800
Message-ID: <54a72e26./fGWutH6HWEJ+6QY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbbABXrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 18:47:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-befs-linuxvfsc-remove-unnecessary-casting-fix
has been added to the -mm tree.  Its filename is
     fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-befs-linuxvfsc-remove-unnecessary-casting-fix

avoid 80-col ugliness

Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-unnecessary-casting-fix fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-unnecessary-casting-fix
+++ a/fs/befs/linuxvfs.c
@@ -274,8 +274,9 @@ more:
 static struct inode *
 befs_alloc_inode(struct super_block *sb)
 {
-	struct befs_inode_info *bi = kmem_cache_alloc(befs_inode_cachep,
-						      GFP_KERNEL);
+	struct befs_inode_info *bi;
+
+	bi = kmem_cache_alloc(befs_inode_cachep, GFP_KERNEL);
         if (!bi)
                 return NULL;
         return &bi->vfs_inode;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

