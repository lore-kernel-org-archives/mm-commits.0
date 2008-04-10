From: akpm@linux-foundation.org
Subject: + frv-add-support-for-emulation-of-userspace-atomic-ops.patch added to -mm tree
Date: Thu, 10 Apr 2008 13:46:20 -0700
Message-ID: <200804102046.m3AKkKtj016695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758169AbYDJUql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     frv: add support for emulation of userspace atomic ops
has been added to the -mm tree.  Its filename is
     frv-add-support-for-emulation-of-userspace-atomic-ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: add support for emulation of userspace atomic ops
From: David Howells <dhowells@redhat.com>

Use traps 120-126 to emulate atomic cmpxchg32, xchg32, and XOR-, OR-, AND-,
SUB- and ADD-to-memory operations for userspace.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/entry-table.S |    8 -
 arch/frv/kernel/entry.S       |   20 ++
 arch/frv/kernel/traps.c       |  227 ++++++++++++++++++++++++++++++++
 include/asm-frv/spr-regs.h    |   14 +
 4 files changed, 268 insertions(+), 1 deletion(-)

diff -puN arch/frv/kernel/entry-table.S~frv-add-support-for-emulation-of-userspace-atomic-ops arch/frv/kernel/entry-table.S
--- a/arch/frv/kernel/entry-table.S~frv-add-support-for-emulation-of-userspace-atomic-ops
+++ a/arch/frv/kernel/entry-table.S
@@ -316,8 +316,14 @@ __trap_fixup_kernel_data_tlb_miss:
 	.section	.trap.vector
 	.org		TBR_TT_TRAP0 >> 2
 	.long		system_call
-	.rept		126
+	.rept		119
 	.long		__entry_unsupported_trap
 	.endr
+
+	# userspace atomic op emulation, traps 120-126
+	.rept		7
+	.long		__entry_atomic_op
+	.endr
+
 	.org		TBR_TT_BREAK >> 2
 	.long		__entry_debug_exception
diff -puN arch/frv/kernel/entry.S~frv-add-support-for-emulation-of-userspace-atomic-ops arch/frv/kernel/entry.S
--- a/arch/frv/kernel/entry.S~frv-add-support-for-emulation-of-userspace-atomic-ops
+++ a/arch/frv/kernel/entry.S
@@ -656,6 +656,26 @@ __entry_debug_exception:
 
 ###############################################################################
 #
+# handle atomic operation emulation for userspace
+#
+###############################################################################
+	.globl		__entry_atomic_op
+__entry_atomic_op:
+	LEDS		0x6012
+	sethi.p		%hi(atomic_operation),gr5
+	setlo		%lo(atomic_operation),gr5
+	movsg		esfr1,gr8
+	movsg		epcr0,gr9
+	movsg		esr0,gr10
+
+	# now that we've accessed the exception regs, we can enable exceptions
+	movsg		psr,gr4
+	ori		gr4,#PSR_ET,gr4
+	movgs		gr4,psr
+	jmpl		@(gr5,gr0)	; call atomic_operation(esfr1,epcr0,esr0)
+
+###############################################################################
+#
 # handle media exception
 #
 ###############################################################################
diff -puN arch/frv/kernel/traps.c~frv-add-support-for-emulation-of-userspace-atomic-ops arch/frv/kernel/traps.c
--- a/arch/frv/kernel/traps.c~frv-add-support-for-emulation-of-userspace-atomic-ops
+++ a/arch/frv/kernel/traps.c
@@ -102,6 +102,233 @@ asmlinkage void illegal_instruction(unsi
 
 /*****************************************************************************/
 /*
+ * handle atomic operations with errors
+ * - arguments in gr8, gr9, gr10
+ * - original memory value placed in gr5
+ * - replacement memory value placed in gr9
+ */
+asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
+				 unsigned long esr0)
+{
+	static DEFINE_SPINLOCK(atomic_op_lock);
+	unsigned long x, y, z, *p;
+	mm_segment_t oldfs;
+	siginfo_t info;
+	int ret;
+
+	y = 0;
+	z = 0;
+
+	oldfs = get_fs();
+	if (!user_mode(__frame))
+		set_fs(KERNEL_DS);
+
+	switch (__frame->tbr & TBR_TT) {
+		/* TIRA gr0,#120
+		 * u32 __atomic_user_cmpxchg32(u32 *ptr, u32 test, u32 new)
+		 */
+	case TBR_TT_ATOMIC_CMPXCHG32:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+		y = __frame->gr10;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			if (z != x)
+				goto done;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				if (z != x)
+					goto done2;
+
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#121
+		 * u32 __atomic_kernel_xchg32(void *v, u32 new)
+		 */
+	case TBR_TT_ATOMIC_XCHG32:
+		p = (unsigned long *) __frame->gr8;
+		y = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#122
+		 * ulong __atomic_kernel_XOR_return(ulong i, ulong *v)
+		 */
+	case TBR_TT_ATOMIC_XOR:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = x ^ z;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#123
+		 * ulong __atomic_kernel_OR_return(ulong i, ulong *v)
+		 */
+	case TBR_TT_ATOMIC_OR:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = x ^ z;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#124
+		 * ulong __atomic_kernel_AND_return(ulong i, ulong *v)
+		 */
+	case TBR_TT_ATOMIC_AND:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = x & z;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#125
+		 * int __atomic_user_sub_return(atomic_t *v, int i)
+		 */
+	case TBR_TT_ATOMIC_SUB:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = z - x;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#126
+		 * int __atomic_user_add_return(atomic_t *v, int i)
+		 */
+	case TBR_TT_ATOMIC_ADD:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = z + x;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+	default:
+		BUG();
+	}
+
+done2:
+	spin_unlock_irq(&atomic_op_lock);
+done:
+	if (!user_mode(__frame))
+		set_fs(oldfs);
+	__frame->gr5 = z;
+	__frame->gr9 = y;
+	return;
+
+error2:
+	spin_unlock_irq(&atomic_op_lock);
+error:
+	if (!user_mode(__frame))
+		set_fs(oldfs);
+	__frame->pc -= 4;
+
+	die_if_kernel("-- Atomic Op Error --\n");
+
+	info.si_signo	= SIGSEGV;
+	info.si_code	= SEGV_ACCERR;
+	info.si_errno	= 0;
+	info.si_addr	= (void *) __frame->pc;
+
+	force_sig_info(info.si_signo, &info, current);
+}
+
+/*****************************************************************************/
+/*
  *
  */
 asmlinkage void media_exception(unsigned long msr0, unsigned long msr1)
diff -puN include/asm-frv/spr-regs.h~frv-add-support-for-emulation-of-userspace-atomic-ops include/asm-frv/spr-regs.h
--- a/include/asm-frv/spr-regs.h~frv-add-support-for-emulation-of-userspace-atomic-ops
+++ a/include/asm-frv/spr-regs.h
@@ -99,9 +99,23 @@
 #define TBR_TT_TRAP1		(0x81 << 4)
 #define TBR_TT_TRAP2		(0x82 << 4)
 #define TBR_TT_TRAP3		(0x83 << 4)
+#define TBR_TT_TRAP120		(0xf8 << 4)
+#define TBR_TT_TRAP121		(0xf9 << 4)
+#define TBR_TT_TRAP122		(0xfa << 4)
+#define TBR_TT_TRAP123		(0xfb << 4)
+#define TBR_TT_TRAP124		(0xfc << 4)
+#define TBR_TT_TRAP125		(0xfd << 4)
 #define TBR_TT_TRAP126		(0xfe << 4)
 #define TBR_TT_BREAK		(0xff << 4)
 
+#define TBR_TT_ATOMIC_CMPXCHG32	TBR_TT_TRAP120
+#define TBR_TT_ATOMIC_XCHG32	TBR_TT_TRAP121
+#define TBR_TT_ATOMIC_XOR	TBR_TT_TRAP122
+#define TBR_TT_ATOMIC_OR	TBR_TT_TRAP123
+#define TBR_TT_ATOMIC_AND	TBR_TT_TRAP124
+#define TBR_TT_ATOMIC_SUB	TBR_TT_TRAP125
+#define TBR_TT_ATOMIC_ADD	TBR_TT_TRAP126
+
 #define __get_TBR()	({ unsigned long x; asm volatile("movsg tbr,%0" : "=r"(x)); x; })
 
 /*
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-unionfs.patch
frv-handle-update_mmu_cache-being-called-when-current-mm-is-null.patch
frv-move-stack_top_max-up.patch
frv-add-support-for-emulation-of-userspace-atomic-ops.patch
frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000.patch
frv-dont-make-smp_r-w-mb-interpolate-membar-when-config_smp=n.patch
remove-the-macro-get_personality.patch
xattr-add-missing-consts-to-function-arguments.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch
mutex-subsystem-synchro-test-module.patch

