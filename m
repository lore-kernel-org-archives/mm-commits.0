From: akpm@linux-foundation.org
Subject: - pagemap-add-documentation-for-pagemap.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:23 -0700
Message-ID: <200806081949.m58JnNdH017677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591AbYFHTuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ttuttle@google.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: add documentation for pagemap
has been removed from the -mm tree.  Its filename was
     pagemap-add-documentation-for-pagemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: add documentation for pagemap
From: "Thomas Tuttle" <ttuttle@google.com>

Just a quick explanation of the pagemap interface from a userspace point
of view, and an example of how to use it (in English, not code).

Signed-off-by: Thomas  Tuttle <ttuttle@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |   77 +++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff -puN /dev/null Documentation/vm/pagemap.txt
--- /dev/null
+++ a/Documentation/vm/pagemap.txt
@@ -0,0 +1,77 @@
+pagemap, from the userspace perspective
+---------------------------------------
+
+pagemap is a new (as of 2.6.25) set of interfaces in the kernel that allow
+userspace programs to examine the page tables and related information by
+reading files in /proc.
+
+There are three components to pagemap:
+
+ * /proc/pid/pagemap.  This file lets a userspace process find out which
+   physical frame each virtual page is mapped to.  It contains one 64-bit
+   value for each virtual page, containing the following data (from
+   fs/proc/task_mmu.c, above pagemap_read):
+
+    * Bits 0-55  page frame number (PFN) if present
+    * Bits 0-4   swap type if swapped
+    * Bits 5-55  swap offset if swapped
+    * Bits 55-60 page shift (page size = 1<<page shift)
+    * Bit  61    reserved for future use
+    * Bit  62    page swapped
+    * Bit  63    page present
+
+   If the page is not present but in swap, then the PFN contains an
+   encoding of the swap file number and the page's offset into the
+   swap. Unmapped pages return a null PFN. This allows determining
+   precisely which pages are mapped (or in swap) and comparing mapped
+   pages between processes.
+
+   Efficient users of this interface will use /proc/pid/maps to
+   determine which areas of memory are actually mapped and llseek to
+   skip over unmapped regions.
+
+ * /proc/kpagecount.  This file contains a 64-bit count of the number of
+   times each page is mapped, indexed by PFN.
+
+ * /proc/kpageflags.  This file contains a 64-bit set of flags for each
+   page, indexed by PFN.
+
+   The flags are (from fs/proc/proc_misc, above kpageflags_read):
+
+     0. LOCKED
+     1. ERROR
+     2. REFERENCED
+     3. UPTODATE
+     4. DIRTY
+     5. LRU
+     6. ACTIVE
+     7. SLAB
+     8. WRITEBACK
+     9. RECLAIM
+    10. BUDDY
+
+Using pagemap to do something useful:
+
+The general procedure for using pagemap to find out about a process' memory
+usage goes like this:
+
+ 1. Read /proc/pid/maps to determine which parts of the memory space are
+    mapped to what.
+ 2. Select the maps you are interested in -- all of them, or a particular
+    library, or the stack or the heap, etc.
+ 3. Open /proc/pid/pagemap and seek to the pages you would like to examine.
+ 4. Read a u64 for each page from pagemap.
+ 5. Open /proc/kpagecount and/or /proc/kpageflags.  For each PFN you just
+    read, seek to that entry in the file, and read the data you want.
+
+For example, to find the "unique set size" (USS), which is the amount of
+memory that a process is using that is not shared with any other process,
+you can go through every map in the process, find the PFNs, look those up
+in kpagecount, and tally up the number of pages that are only referenced
+once.
+
+Other notes:
+
+Reading from any of the files will return -EINVAL if you are not starting
+the read on an 8-byte boundary (e.g., if you seeked an odd number of bytes
+into the file), or if the size of the read is not a multiple of 8 bytes.
_

Patches currently in -mm which might be from ttuttle@google.com are

origin.patch

