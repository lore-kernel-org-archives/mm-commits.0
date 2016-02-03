From: akpm@linux-foundation.org
Subject: [merged] mm-polish-virtual-memory-accounting.patch removed from
 -mm tree
Date: Wed, 03 Feb 2016 13:53:24 -0800
Message-ID: <56b276d4.6A6JOb241TOteki4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbcBCVxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, gorcunov@gmail.com, sudipm.mukherjee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: polish virtual memory accounting
has been removed from the -mm tree.  Its filename was
     mm-polish-virtual-memory-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: polish virtual memory accounting

* add VM_STACK as alias for VM_GROWSUP/DOWN depending on architecture
* always account VMAs with flag VM_STACK as stack (as it was before)
* cleanup classifying helpers
* update comments and documentation

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 ++--
 include/linux/mm.h                 |    6 ++++--
 include/linux/mm_types.h           |    6 +++---
 mm/internal.h                      |   23 +++++++++++++++++++----
 4 files changed, 28 insertions(+), 11 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-polish-virtual-memory-accounting Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-polish-virtual-memory-accounting
+++ a/Documentation/filesystems/proc.txt
@@ -240,8 +240,8 @@ Table 1-2: Contents of the status files
  RssFile                     size of resident file mappings
  RssShmem                    size of resident shmem memory (includes SysV shm,
                              mapping of tmpfs and shared anonymous mappings)
- VmData                      size of data, stack, and text segments
- VmStk                       size of data, stack, and text segments
+ VmData                      size of private data segments
+ VmStk                       size of stack segments
  VmExe                       size of text segment
  VmLib                       size of shared library code
  VmPTE                       size of page table entries
diff -puN include/linux/mm.h~mm-polish-virtual-memory-accounting include/linux/mm.h
--- a/include/linux/mm.h~mm-polish-virtual-memory-accounting
+++ a/include/linux/mm.h
@@ -201,11 +201,13 @@ extern unsigned int kobjsize(const void
 #endif
 
 #ifdef CONFIG_STACK_GROWSUP
-#define VM_STACK_FLAGS	(VM_GROWSUP | VM_STACK_DEFAULT_FLAGS | VM_ACCOUNT)
+#define VM_STACK	VM_GROWSUP
 #else
-#define VM_STACK_FLAGS	(VM_GROWSDOWN | VM_STACK_DEFAULT_FLAGS | VM_ACCOUNT)
+#define VM_STACK	VM_GROWSDOWN
 #endif
 
+#define VM_STACK_FLAGS	(VM_STACK | VM_STACK_DEFAULT_FLAGS | VM_ACCOUNT)
+
 /*
  * Special vmas that are non-mergable, non-mlock()able.
  * Note: mm/huge_memory.c VM_NO_THP depends on this definition.
diff -puN include/linux/mm_types.h~mm-polish-virtual-memory-accounting include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-polish-virtual-memory-accounting
+++ a/include/linux/mm_types.h
@@ -424,9 +424,9 @@ struct mm_struct {
 	unsigned long total_vm;		/* Total pages mapped */
 	unsigned long locked_vm;	/* Pages that have PG_mlocked set */
 	unsigned long pinned_vm;	/* Refcount permanently increased */
-	unsigned long data_vm;		/* VM_WRITE & ~VM_SHARED/GROWSDOWN */
-	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
-	unsigned long stack_vm;		/* VM_GROWSUP/DOWN */
+	unsigned long data_vm;		/* VM_WRITE & ~VM_SHARED & ~VM_STACK */
+	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE & ~VM_STACK */
+	unsigned long stack_vm;		/* VM_STACK */
 	unsigned long def_flags;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long start_brk, brk, start_stack;
diff -puN mm/internal.h~mm-polish-virtual-memory-accounting mm/internal.h
--- a/mm/internal.h~mm-polish-virtual-memory-accounting
+++ a/mm/internal.h
@@ -216,20 +216,35 @@ static inline bool is_cow_mapping(vm_fla
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
+/*
+ * These three helpers classifies VMAs for virtual memory accounting.
+ */
+
+/*
+ * Executable code area - executable, not writable, not stack
+ */
 static inline bool is_exec_mapping(vm_flags_t flags)
 {
-	return (flags & (VM_EXEC | VM_WRITE)) == VM_EXEC;
+	return (flags & (VM_EXEC | VM_WRITE | VM_STACK)) == VM_EXEC;
 }
 
+/*
+ * Stack area - atomatically grows in one direction
+ *
+ * VM_GROWSUP / VM_GROWSDOWN VMAs are always private anonymous:
+ * do_mmap() forbids all other combinations.
+ */
 static inline bool is_stack_mapping(vm_flags_t flags)
 {
-	return (flags & (VM_STACK_FLAGS & (VM_GROWSUP | VM_GROWSDOWN))) != 0;
+	return (flags & VM_STACK) == VM_STACK;
 }
 
+/*
+ * Data area - private, writable, not stack
+ */
 static inline bool is_data_mapping(vm_flags_t flags)
 {
-	return (flags & ((VM_STACK_FLAGS & (VM_GROWSUP | VM_GROWSDOWN)) |
-					VM_WRITE | VM_SHARED)) == VM_WRITE;
+	return (flags & (VM_WRITE | VM_SHARED | VM_STACK)) == VM_WRITE;
 }
 
 /* mm/util.c */
_

Patches currently in -mm which might be from koct9i@gmail.com are

mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write.patch

