From: akpm@linux-foundation.org
Subject: - uml-use-generic-bug.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:04 -0700
Message-ID: <200706250921.l5P9L4L8031068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56704 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbXFYJVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: use generic BUG
has been removed from the -mm tree.  Its filename was
     uml-use-generic-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: use generic BUG
From: Nick Piggin <npiggin@suse.de>

Get UML to use the generic bug support rather than arch specific one.

If I insert an artificial bug right before loading init, I get this:

 Kernel panic - not syncing: Kernel mode signal 4

 EIP: 0023:[<0819d501>] CPU: 0 Not tainted ESP: 002b:f7fd4fbc EFLAGS: 00000246
    Not tainted
    EAX: 00000000 EBX: 00007870 ECX: 00000013 EDX: 00007870
    ESI: 0000786d EDI: 00000011 EBP: f7fd4fd8 DS: 002b ES: 002b
    08273bec:  [<0806e814>] show_regs+0x104/0x106
    08273c08:  [<08058927>] panic_exit+0x2c/0x4b
    08273c18:  [<08080ee7>] notifier_call_chain+0x32/0x5b
    08273c38:  [<08080fbd>] __atomic_notifier_call_chain+0x30/0x32
    08273c54:  [<08080fee>] atomic_notifier_call_chain+0x2f/0x31
    08273c70:  [<08073b88>] panic+0x75/0x131
    08273c94:  [<080586c7>] relay_signal+0x87/0x95
    08273cb0:  [<0806b9ee>] sig_handler_common_skas+0x9e/0x120
    08273cd8:  [<08067738>] sig_handler+0x28/0x4f
    08273cec:  [<0806792e>] handle_signal+0x53/0x89
    08273d0c:  [<08069f60>] hard_handler+0x18/0x28
    08273d1c:  [<ffffe500>] transitions+0xf7d598b8/0xfffffff0

With this patch in place, this is how it looks:

 BUG: failure at init/main.c:779/init_post()!
 Kernel panic - not syncing: BUG!

 EIP: 0023:[<081a65d1>] CPU: 0 Not tainted ESP: 002b:f7f0dfbc EFLAGS: 00000246
    Not tainted
    EAX: 00000000 EBX: 000069db ECX: 00000013 EDX: 000069db
    ESI: 000069d8 EDI: 00000011 EBP: f7f0dfd8 DS: 002b ES: 002b
    098efedc:  [<0806e9a4>] show_regs+0x104/0x106
    098efef8:  [<080589c7>] panic_exit+0x2c/0x4b
    098eff08:  [<080818d7>] notifier_call_chain+0x32/0x5b
    098eff28:  [<080819ad>] __atomic_notifier_call_chain+0x30/0x32
    098eff44:  [<080819de>] atomic_notifier_call_chain+0x2f/0x31
    098eff60:  [<08073f28>] panic+0x75/0x131
    098eff84:  [<080541d5>] init_post+0xcd/0xe8
    098eff9c:  [<08048ad4>] kernel_init+0x8e/0x9a
    098effb4:  [<08066dee>] run_kernel_thread+0x41/0x53
    098effe0:  [<08058e75>] new_thread_handler+0x62/0x8b
    098efffc:  [<a55a5a5a>] 0xa55a5a5a

[ jdike - added BUG_TABLE to linker script ]

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/bug.h        |    2 +-
 include/asm-um/common.lds.S |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/asm-um/bug.h~uml-use-generic-bug include/asm-um/bug.h
--- a/include/asm-um/bug.h~uml-use-generic-bug
+++ a/include/asm-um/bug.h
@@ -1,6 +1,6 @@
 #ifndef __UM_BUG_H
 #define __UM_BUG_H
 
-#include <asm/arch/bug.h>
+#include <asm-generic/bug.h>
 
 #endif
diff -puN include/asm-um/common.lds.S~uml-use-generic-bug include/asm-um/common.lds.S
--- a/include/asm-um/common.lds.S~uml-use-generic-bug
+++ a/include/asm-um/common.lds.S
@@ -20,6 +20,8 @@
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;
 
+  BUG_TABLE
+
   __uml_setup_start = .;
   .uml.setup.init : { *(.uml.setup.init) }
   __uml_setup_end = .;
_

Patches currently in -mm which might be from npiggin@suse.de are

slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-merge-nopfn-into-fault-spufs-fix.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fix-read-truncate-race.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
