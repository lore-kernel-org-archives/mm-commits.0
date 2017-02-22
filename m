From: akpm@linux-foundation.org
Subject: [patch 002/142] dax: add tracepoint infrastructure, PMD tracing
Date: Wed, 22 Feb 2017 15:39:50 -0800
Message-ID: <58ae2146.bP1rrT/5ily5b5Aq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49522 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934497AbdBVXpx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:45:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, dave.jiang@intel.com, david@fromorbit.com, jack@suse.cz, mawilcox@microsoft.com, rostedt@goodmis.org

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: add tracepoint infrastructure, PMD tracing

Tracepoints are the standard way to capture debugging and tracing
information in many parts of the kernel, including the XFS and ext4
filesystems.  Create a tracepoint header for FS DAX and add the first DAX
tracepoints to the PMD fault handler.  This allows the tracing for DAX to
be done in the same way as the filesystem tracing so that developers can
look at them together and get a coherent idea of what the system is doing.

I added both an entry and exit tracepoint because future patches will add
tracepoints to child functions of dax_iomap_pmd_fault() like
dax_pmd_load_hole() and dax_pmd_insert_mapping().  We want those messages
to be wrapped by the parent function tracepoints so the code flow is more
easily understood.  Having entry and exit tracepoints for faults also
allows us to easily see what filesystems functions were called during the
fault.  These filesystem functions get executed via iomap_begin() and
iomap_end() calls, for example, and will have their own tracepoints.

For PMD faults we primarily want to understand the type of mapping, the
fault flags, the faulting address and whether it fell back to 4k faults. 
If it fell back to 4k faults the tracepoints should let us understand why.

I named the new tracepoint header file "fs_dax.h" to allow for device DAX
to have its own separate tracing header in the same directory at some
point.

Here is an example output for these events from a successful PMD fault:

big-1441  [005] ....    32.582758: xfs_filemap_pmd_fault: dev 259:0 ino
0x1003

big-1441  [005] ....    32.582776: dax_pmd_fault: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start
0x10200000 vm_end 0x10700000 pgoff 0x200 max_pgoff 0x1400

big-1441  [005] ....    32.583292: dax_pmd_fault_done: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start
0x10200000 vm_end 0x10700000 pgoff 0x200 max_pgoff 0x1400 NOPAGE

Link: http://lkml.kernel.org/r/1484085142-2297-3-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                      |   30 +++++++++-----
 include/linux/mm.h            |   25 +++++++++++
 include/trace/events/fs_dax.h |   68 ++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 10 deletions(-)

diff -puN fs/dax.c~dax-add-tracepoint-infrastructure-pmd-tracing fs/dax.c
--- a/fs/dax.c~dax-add-tracepoint-infrastructure-pmd-tracing
+++ a/fs/dax.c
@@ -35,6 +35,9 @@
 #include <linux/iomap.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/fs_dax.h>
+
 /* We choose 4096 entries - same as per-zone page wait tables */
 #define DAX_WAIT_TABLE_BITS 12
 #define DAX_WAIT_TABLE_ENTRIES (1 << DAX_WAIT_TABLE_BITS)
@@ -1341,6 +1344,16 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	loff_t pos;
 	int error;
 
+	/*
+	 * Check whether offset isn't beyond end of file now. Caller is
+	 * supposed to hold locks serializing us with truncate / punch hole so
+	 * this is a reliable test.
+	 */
+	pgoff = linear_page_index(vma, pmd_addr);
+	max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;
+
+	trace_dax_pmd_fault(inode, vma, address, flags, pgoff, max_pgoff, 0);
+
 	/* Fall back to PTEs if we're going to COW */
 	if (write && !(vma->vm_flags & VM_SHARED))
 		goto fallback;
@@ -1351,16 +1364,10 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
 		goto fallback;
 
-	/*
-	 * Check whether offset isn't beyond end of file now. Caller is
-	 * supposed to hold locks serializing us with truncate / punch hole so
-	 * this is a reliable test.
-	 */
-	pgoff = linear_page_index(vma, pmd_addr);
-	max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;
-
-	if (pgoff > max_pgoff)
-		return VM_FAULT_SIGBUS;
+	if (pgoff > max_pgoff) {
+		result = VM_FAULT_SIGBUS;
+		goto out;
+	}
 
 	/* If the PMD would extend beyond the file size */
 	if ((pgoff | PG_PMD_COLOUR) > max_pgoff)
@@ -1432,6 +1439,9 @@ int dax_iomap_pmd_fault(struct vm_area_s
 		split_huge_pmd(vma, pmd, address);
 		count_vm_event(THP_FAULT_FALLBACK);
 	}
+out:
+	trace_dax_pmd_fault_done(inode, vma, address, flags, pgoff, max_pgoff,
+			result);
 	return result;
 }
 EXPORT_SYMBOL_GPL(dax_iomap_pmd_fault);
diff -puN include/linux/mm.h~dax-add-tracepoint-infrastructure-pmd-tracing include/linux/mm.h
--- a/include/linux/mm.h~dax-add-tracepoint-infrastructure-pmd-tracing
+++ a/include/linux/mm.h
@@ -285,6 +285,17 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_REMOTE	0x80	/* faulting for non current tsk/mm */
 #define FAULT_FLAG_INSTRUCTION  0x100	/* The fault was during an instruction fetch */
 
+#define FAULT_FLAG_TRACE \
+	{ FAULT_FLAG_WRITE,		"WRITE" }, \
+	{ FAULT_FLAG_MKWRITE,		"MKWRITE" }, \
+	{ FAULT_FLAG_ALLOW_RETRY,	"ALLOW_RETRY" }, \
+	{ FAULT_FLAG_RETRY_NOWAIT,	"RETRY_NOWAIT" }, \
+	{ FAULT_FLAG_KILLABLE,		"KILLABLE" }, \
+	{ FAULT_FLAG_TRIED,		"TRIED" }, \
+	{ FAULT_FLAG_USER,		"USER" }, \
+	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
+	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }
+
 /*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
@@ -1111,6 +1122,20 @@ static inline void clear_page_pfmemalloc
 			 VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE | \
 			 VM_FAULT_FALLBACK)
 
+#define VM_FAULT_RESULT_TRACE \
+	{ VM_FAULT_OOM,			"OOM" }, \
+	{ VM_FAULT_SIGBUS,		"SIGBUS" }, \
+	{ VM_FAULT_MAJOR,		"MAJOR" }, \
+	{ VM_FAULT_WRITE,		"WRITE" }, \
+	{ VM_FAULT_HWPOISON,		"HWPOISON" }, \
+	{ VM_FAULT_HWPOISON_LARGE,	"HWPOISON_LARGE" }, \
+	{ VM_FAULT_SIGSEGV,		"SIGSEGV" }, \
+	{ VM_FAULT_NOPAGE,		"NOPAGE" }, \
+	{ VM_FAULT_LOCKED,		"LOCKED" }, \
+	{ VM_FAULT_RETRY,		"RETRY" }, \
+	{ VM_FAULT_FALLBACK,		"FALLBACK" }, \
+	{ VM_FAULT_DONE_COW,		"DONE_COW" }
+
 /* Encode hstate index for a hwpoisoned large page */
 #define VM_FAULT_SET_HINDEX(x) ((x) << 12)
 #define VM_FAULT_GET_HINDEX(x) (((x) >> 12) & 0xf)
diff -puN /dev/null include/trace/events/fs_dax.h
--- /dev/null
+++ a/include/trace/events/fs_dax.h
@@ -0,0 +1,68 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM fs_dax
+
+#if !defined(_TRACE_FS_DAX_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FS_DAX_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(dax_pmd_fault_class,
+	TP_PROTO(struct inode *inode, struct vm_area_struct *vma,
+		unsigned long address, unsigned int flags, pgoff_t pgoff,
+		pgoff_t max_pgoff, int result),
+	TP_ARGS(inode, vma, address, flags, pgoff, max_pgoff, result),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long, vm_start)
+		__field(unsigned long, vm_end)
+		__field(unsigned long, vm_flags)
+		__field(unsigned long, address)
+		__field(pgoff_t, pgoff)
+		__field(pgoff_t, max_pgoff)
+		__field(dev_t, dev)
+		__field(unsigned int, flags)
+		__field(int, result)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->vm_start = vma->vm_start;
+		__entry->vm_end = vma->vm_end;
+		__entry->vm_flags = vma->vm_flags;
+		__entry->address = address;
+		__entry->flags = flags;
+		__entry->pgoff = pgoff;
+		__entry->max_pgoff = max_pgoff;
+		__entry->result = result;
+	),
+	TP_printk("dev %d:%d ino %#lx %s %s address %#lx vm_start "
+			"%#lx vm_end %#lx pgoff %#lx max_pgoff %#lx %s",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->vm_flags & VM_SHARED ? "shared" : "private",
+		__print_flags(__entry->flags, "|", FAULT_FLAG_TRACE),
+		__entry->address,
+		__entry->vm_start,
+		__entry->vm_end,
+		__entry->pgoff,
+		__entry->max_pgoff,
+		__print_flags(__entry->result, "|", VM_FAULT_RESULT_TRACE)
+	)
+)
+
+#define DEFINE_PMD_FAULT_EVENT(name) \
+DEFINE_EVENT(dax_pmd_fault_class, name, \
+	TP_PROTO(struct inode *inode, struct vm_area_struct *vma, \
+		unsigned long address, unsigned int flags, pgoff_t pgoff, \
+		pgoff_t max_pgoff, int result), \
+	TP_ARGS(inode, vma, address, flags, pgoff, max_pgoff, result))
+
+DEFINE_PMD_FAULT_EVENT(dax_pmd_fault);
+DEFINE_PMD_FAULT_EVENT(dax_pmd_fault_done);
+
+
+#endif /* _TRACE_FS_DAX_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
_
