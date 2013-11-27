From: akpm@linux-foundation.org
Subject: +
 fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch added to -mm tree
Date: Wed, 27 Nov 2013 15:13:16 -0800
Message-ID: <52967c8c.uHDuVhBWwp1DefoH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab3K0XNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 18:13:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, jack@suse.cz, fengguang.wu@intel.com, cody@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch added to -mm tree
To: akpm@linux-foundation.org,cody@linux.vnet.ibm.com,fengguang.wu@intel.com,jack@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 15:13:16 -0800


The patch titled
     Subject: fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix
has been added to the -mm tree.  Its filename is
     fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

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
Subject: fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix

use do{}while - more efficient and it squishes a coccinelle warning

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ext3/dir.c~fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix fs/ext3/dir.c
--- a/fs/ext3/dir.c~fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix
+++ a/fs/ext3/dir.c
@@ -312,11 +312,11 @@ static void free_rb_tree_fname(struct rb
 	struct fname *fname, *next;
 
 	rbtree_postorder_for_each_entry_safe(fname, next, root, rb_hash)
-		while (fname) {
-			struct fname * old = fname;
+		do {
+			struct fname *old = fname;
 			fname = fname->next;
-			kfree (old);
-		}
+			kfree(old);
+		} while (fname);
 
 	*root = RB_ROOT;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
arch-um-kernel-sysrqc-rename-print_stack_trace.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

