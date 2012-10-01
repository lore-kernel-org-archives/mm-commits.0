From: akpm@linux-foundation.org
Subject: + prio_tree-remove-fix.patch added to -mm tree
Date: Mon, 01 Oct 2012 12:51:25 -0700
Message-ID: <20121001195126.19DC75C0066@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43898 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab2JATv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:51:28 -0400
Received: by weyx43 with SMTP id x43so336402wey.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:51:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, walken@google.com


The patch titled
     Subject: prio_tree: fix fs/block_dev.c for removal of prio_tree
has been added to the -mm tree.  Its filename is
     prio_tree-remove-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: prio_tree: fix fs/block_dev.c for removal of prio_tree

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~prio_tree-remove-fix fs/block_dev.c
--- a/fs/block_dev.c~prio_tree-remove-fix
+++ a/fs/block_dev.c
@@ -27,6 +27,7 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
+#include <linux/rbtree.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -132,7 +133,7 @@ int set_blocksize(struct block_device *b
 	/* Check that the block device is not memory mapped */
 	mapping = bdev->bd_inode->i_mapping;
 	mutex_lock(&mapping->i_mmap_mutex);
-	if (!prio_tree_empty(&mapping->i_mmap) ||
+	if (!RB_EMPTY_ROOT(&mapping->i_mmap) ||
 	    !list_empty(&mapping->i_mmap_nonlinear)) {
 		mutex_unlock(&mapping->i_mmap_mutex);
 		percpu_up_write(&bdev->bd_block_size_semaphore);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
rbtree-empty-nodes-have-no-color-fix.patch
prio_tree-remove-fix.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2-fix.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix.patch
coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr.patch
compat-move-compat_siginfo_t-definition-to-asm-compath.patch
coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch
kernel-forkc-export-kernel_thread-to-modules.patch

