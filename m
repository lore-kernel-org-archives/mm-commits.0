From: akpm@linux-foundation.org
Subject: + kprobes-print-details-of-kretprobe-on-assertion-failure.patch added to -mm tree
Date: Tue, 03 Apr 2007 17:23:08 -0700
Message-ID: <200704040023.l340N8q7007546@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49876 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030275AbXDDAXV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 20:23:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, jkenisto@us.ibm.com, maneesh@in.ibm.com, prasanna@in.ibm.com


The patch titled
     Kprobes: print details of kretprobe on assertion failure
has been added to the -mm tree.  Its filename is
     kprobes-print-details-of-kretprobe-on-assertion-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kprobes: print details of kretprobe on assertion failure
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

In certain cases like when the real return address can't be found or when
the number of tracked calls to a kretprobed function is less than the
number of returns, we may not be able to find the correct return address
after processing a kretprobe.  Currently we just do a BUG_ON, but no
information is provided about the actual failing kretprobe.

Print out details of the kretprobe before calling BUG().

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/kprobes.c    |    3 +--
 arch/ia64/kernel/kprobes.c    |    3 ++-
 arch/powerpc/kernel/kprobes.c |    2 +-
 arch/x86_64/kernel/kprobes.c  |    2 +-
 include/linux/kprobes.h       |   10 ++++++++++
 5 files changed, 15 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/kprobes.c~kprobes-print-details-of-kretprobe-on-assertion-failure arch/i386/kernel/kprobes.c
--- a/arch/i386/kernel/kprobes.c~kprobes-print-details-of-kretprobe-on-assertion-failure
+++ a/arch/i386/kernel/kprobes.c
@@ -449,8 +449,7 @@ fastcall void *__kprobes trampoline_hand
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
-
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
diff -puN arch/ia64/kernel/kprobes.c~kprobes-print-details-of-kretprobe-on-assertion-failure arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~kprobes-print-details-of-kretprobe-on-assertion-failure
+++ a/arch/ia64/kernel/kprobes.c
@@ -444,7 +444,8 @@ int __kprobes trampoline_probe_handler(s
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
 	regs->cr_iip = orig_ret_address;
 
 	reset_current_kprobe();
diff -puN arch/powerpc/kernel/kprobes.c~kprobes-print-details-of-kretprobe-on-assertion-failure arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~kprobes-print-details-of-kretprobe-on-assertion-failure
+++ a/arch/powerpc/kernel/kprobes.c
@@ -302,7 +302,7 @@ int __kprobes trampoline_probe_handler(s
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 	regs->nip = orig_ret_address;
 
 	reset_current_kprobe();
diff -puN arch/x86_64/kernel/kprobes.c~kprobes-print-details-of-kretprobe-on-assertion-failure arch/x86_64/kernel/kprobes.c
--- a/arch/x86_64/kernel/kprobes.c~kprobes-print-details-of-kretprobe-on-assertion-failure
+++ a/arch/x86_64/kernel/kprobes.c
@@ -447,7 +447,7 @@ int __kprobes trampoline_probe_handler(s
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 	regs->rip = orig_ret_address;
 
 	reset_current_kprobe();
diff -puN include/linux/kprobes.h~kprobes-print-details-of-kretprobe-on-assertion-failure include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-print-details-of-kretprobe-on-assertion-failure
+++ a/include/linux/kprobes.h
@@ -157,6 +157,16 @@ struct kretprobe_instance {
 	struct task_struct *task;
 };
 
+static inline void kretprobe_assert(struct kretprobe_instance *ri,
+	unsigned long orig_ret_address, unsigned long trampoline_address)
+{
+	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
+		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
+				ri->rp, ri->rp->kp.addr);
+		BUG();
+	}
+}
+
 extern spinlock_t kretprobe_lock;
 extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
_

Patches currently in -mm which might be from ananth@in.ibm.com are

kprobes-make-kprobesymbol_name-const.patch
kprobes-fix-sparse-null-warning.patch
kprobes-print-details-of-kretprobe-on-assertion-failure.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
