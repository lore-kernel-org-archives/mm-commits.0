From: akpm@linux-foundation.org
Subject: [merged] mm-warn-about-vmdata-over-rlimit_data.patch removed from -mm tree
Date: Wed, 03 Feb 2016 13:53:21 -0800
Message-ID: <56b276d1.Carc4NWxEhIPnrnF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbcBCVxW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, a.p.zijlstra@chello.nl, borntraeger@de.ibm.com, gorcunov@gmail.com, keescook@google.com, luto@amacapital.net, quentin.casasnovas@oracle.com, torvalds@linux-foundation.org, vdavydov@virtuozzo.com, vegard.nossum@oracle.com, w@1wt.eu, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: warn about VmData over RLIMIT_DATA
has been removed from the -mm tree.  Its filename was
     mm-warn-about-vmdata-over-rlimit_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: warn about VmData over RLIMIT_DATA

This patch provides a way of working around a slight regression introduced
by 84638335900f ("mm: rework virtual memory accounting").

Before that commit RLIMIT_DATA have control only over size of the brk
region.  But that change have caused problems with all existing versions
of valgrind, because it set RLIMIT_DATA to zero.

This patch fixes rlimit check (limit actually in bytes, not pages) and by
default turns it into warning which prints at first VmData misuse: "mmap:
top (795): VmData 516096 exceed data ulimit 512000.  Will be forbidden
soon."

Behavior is controlled by boot param ignore_rlimit_data=y/n and by sysfs
/sys/module/kernel/parameters/ignore_rlimit_data.  For now it set to "y".

[akpm@linux-foundation.org: tweak kernel-parameters.txt text[
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Link: http://lkml.kernel.org/r/20151228211015.GL2194@uranus
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: Kees Cook <keescook@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 mm/internal.h                       |   16 ++++++++++++++++
 mm/mmap.c                           |   23 +++++++++++++++++------
 3 files changed, 38 insertions(+), 6 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-warn-about-vmdata-over-rlimit_data Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-warn-about-vmdata-over-rlimit_data
+++ a/Documentation/kernel-parameters.txt
@@ -1496,6 +1496,11 @@ bytes respectively. Such letter suffixes
 			could change it dynamically, usually by
 			/sys/module/printk/parameters/ignore_loglevel.
 
+	ignore_rlimit_data
+			Ignore RLIMIT_DATA setting for data mappings,
+			print warning at first misuse.  Can be changed via
+			/sys/module/kernel/parameters/ignore_rlimit_data.
+
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
diff -puN mm/internal.h~mm-warn-about-vmdata-over-rlimit_data mm/internal.h
--- a/mm/internal.h~mm-warn-about-vmdata-over-rlimit_data
+++ a/mm/internal.h
@@ -216,6 +216,22 @@ static inline bool is_cow_mapping(vm_fla
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
+static inline bool is_exec_mapping(vm_flags_t flags)
+{
+	return (flags & (VM_EXEC | VM_WRITE)) == VM_EXEC;
+}
+
+static inline bool is_stack_mapping(vm_flags_t flags)
+{
+	return (flags & (VM_STACK_FLAGS & (VM_GROWSUP | VM_GROWSDOWN))) != 0;
+}
+
+static inline bool is_data_mapping(vm_flags_t flags)
+{
+	return (flags & ((VM_STACK_FLAGS & (VM_GROWSUP | VM_GROWSDOWN)) |
+					VM_WRITE | VM_SHARED)) == VM_WRITE;
+}
+
 /* mm/util.c */
 void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct vm_area_struct *prev, struct rb_node *rb_parent);
diff -puN mm/mmap.c~mm-warn-about-vmdata-over-rlimit_data mm/mmap.c
--- a/mm/mmap.c~mm-warn-about-vmdata-over-rlimit_data
+++ a/mm/mmap.c
@@ -42,6 +42,7 @@
 #include <linux/memory.h>
 #include <linux/printk.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/moduleparam.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -69,6 +70,8 @@ const int mmap_rnd_compat_bits_max = CON
 int mmap_rnd_compat_bits __read_mostly = CONFIG_ARCH_MMAP_RND_COMPAT_BITS;
 #endif
 
+static bool ignore_rlimit_data = true;
+core_param(ignore_rlimit_data, ignore_rlimit_data, bool, 0644);
 
 static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
@@ -2982,9 +2985,17 @@ bool may_expand_vm(struct mm_struct *mm,
 	if (mm->total_vm + npages > rlimit(RLIMIT_AS) >> PAGE_SHIFT)
 		return false;
 
-	if ((flags & (VM_WRITE | VM_SHARED | (VM_STACK_FLAGS &
-				(VM_GROWSUP | VM_GROWSDOWN)))) == VM_WRITE)
-		return mm->data_vm + npages <= rlimit(RLIMIT_DATA);
+	if (is_data_mapping(flags) &&
+	    mm->data_vm + npages > rlimit(RLIMIT_DATA) >> PAGE_SHIFT) {
+		if (ignore_rlimit_data)
+			pr_warn_once("%s (%d): VmData %lu exceed data ulimit "
+				     "%lu. Will be forbidden soon.\n",
+				     current->comm, current->pid,
+				     (mm->data_vm + npages) << PAGE_SHIFT,
+				     rlimit(RLIMIT_DATA));
+		else
+			return false;
+	}
 
 	return true;
 }
@@ -2993,11 +3004,11 @@ void vm_stat_account(struct mm_struct *m
 {
 	mm->total_vm += npages;
 
-	if ((flags & (VM_EXEC | VM_WRITE)) == VM_EXEC)
+	if (is_exec_mapping(flags))
 		mm->exec_vm += npages;
-	else if (flags & (VM_STACK_FLAGS & (VM_GROWSUP | VM_GROWSDOWN)))
+	else if (is_stack_mapping(flags))
 		mm->stack_vm += npages;
-	else if ((flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
+	else if (is_data_mapping(flags))
 		mm->data_vm += npages;
 }
 
_

Patches currently in -mm which might be from koct9i@gmail.com are

mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write.patch

