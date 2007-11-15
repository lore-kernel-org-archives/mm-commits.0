From: akpm@linux-foundation.org
Subject: + frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:44:16 -0800
Message-ID: <200711152244.lAFMiGWW019763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932470AbXKOWob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:44:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: arrange things such that BRA can reach from the trap table
has been added to the -mm tree.  Its filename is
     frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: arrange things such that BRA can reach from the trap table
From: David Howells <dhowells@redhat.com>

Arrange the sections in the FRV arch so that a BRA instruction with a
16-bit displacement can always reach from the trap table to entry.S,
tlb-miss.S and break.S.

The problem otherwise is that the linker can insert sufficient code between
the slots in the trap table and the targets of the branch instructions in
those slots that the displacement field in the instruction isn't
sufficiently large.  This is because the branch targets were in the .text
section along with most of the other code in the kernel.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/break.S       |    2 +-
 arch/frv/kernel/entry.S       |    2 +-
 arch/frv/kernel/vmlinux.lds.S |   27 +++++++++++++++------------
 arch/frv/mm/tlb-miss.S        |    2 +-
 4 files changed, 18 insertions(+), 15 deletions(-)

diff -puN arch/frv/kernel/break.S~frv-arrange-things-such-that-bra-can-reach-from-the-trap arch/frv/kernel/break.S
--- a/arch/frv/kernel/break.S~frv-arrange-things-such-that-bra-can-reach-from-the-trap
+++ a/arch/frv/kernel/break.S
@@ -63,7 +63,7 @@ __break_trace_through_exceptions:
 # entry point for Break Exceptions/Interrupts
 #
 ###############################################################################
-	.text
+	.section	.text.break
 	.balign		4
 	.globl		__entry_break
 __entry_break:
diff -puN arch/frv/kernel/entry.S~frv-arrange-things-such-that-bra-can-reach-from-the-trap arch/frv/kernel/entry.S
--- a/arch/frv/kernel/entry.S~frv-arrange-things-such-that-bra-can-reach-from-the-trap
+++ a/arch/frv/kernel/entry.S
@@ -38,7 +38,7 @@
 
 #define nr_syscalls ((syscall_table_size)/4)
 
-	.text
+	.section	.text.entry
 	.balign		4
 
 .macro LEDS val
diff -puN arch/frv/kernel/vmlinux.lds.S~frv-arrange-things-such-that-bra-can-reach-from-the-trap arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~frv-arrange-things-such-that-bra-can-reach-from-the-trap
+++ a/arch/frv/kernel/vmlinux.lds.S
@@ -76,6 +76,12 @@ SECTIONS
 	  *(.data.init_task)
   }
 
+  . = ALIGN(4096);
+  .data.page_aligned : { *(.data.idt) }
+
+  . = ALIGN(L1_CACHE_BYTES);
+  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+
   .trap : {
 	/* trap table management - read entry-table.S before modifying */
 	. = ALIGN(8192);
@@ -86,28 +92,25 @@ SECTIONS
 	*(.trap.break)
   }
 
-  . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
-
-  . = ALIGN(L1_CACHE_BYTES);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-
   /* Text and read-only data */
   . = ALIGN(4);
   _text = .;
   _stext = .;
   .text : {
-	*(
-		.text.start .text.*
+	*(.text.start)
+	*(.text.entry)
+	*(.text.break)
+	*(.text.tlbmiss)
+	TEXT_TEXT
+	SCHED_TEXT
+	LOCK_TEXT
 #ifdef CONFIG_DEBUG_INFO
+	*(
 	.init.text
 	.exit.text
 	.exitcall.exit
-#endif
 	)
-	TEXT_TEXT
-	SCHED_TEXT
-	LOCK_TEXT
+#endif
 	*(.fixup)
 	*(.gnu.warning)
 	*(.exitcall.exit)
diff -puN arch/frv/mm/tlb-miss.S~frv-arrange-things-such-that-bra-can-reach-from-the-trap arch/frv/mm/tlb-miss.S
--- a/arch/frv/mm/tlb-miss.S~frv-arrange-things-such-that-bra-can-reach-from-the-trap
+++ a/arch/frv/mm/tlb-miss.S
@@ -16,7 +16,7 @@
 #include <asm/highmem.h>
 #include <asm/spr-regs.h>
 
-	.section	.text
+	.section	.text.tlbmiss
 	.balign		4
 
 	.globl		__entry_insn_mmu_miss
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
suppress-aout-library-support-if-config_binfmt_aout.patch
suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
usb-net2280-cant-have-a-function-called.patch
usb-net2280-cant-have-a-function-called-checkpatch-fixes.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-ia64-fix.patch
mutex-subsystem-synchro-test-module.patch
