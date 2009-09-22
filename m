From: akpm@linux-foundation.org
Subject: [merged] ksm-define-madv_mergeable-and-madv_unmergeable.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:39:10 -0700
Message-ID: <200909222039.n8MKdAYP002870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbZIVUkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chris@zankel.net, chrisw@redhat.com, deller@gmx.de, fengguang.wu@intel.com, ieidus@redhat.com, ink@


The patch titled
     ksm: define MADV_MERGEABLE and MADV_UNMERGEABLE
has been removed from the -mm tree.  Its filename was
     ksm-define-madv_mergeable-and-madv_unmergeable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: define MADV_MERGEABLE and MADV_UNMERGEABLE
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

The out-of-tree KSM used ioctls on fds cloned from /dev/ksm to register a
memory area for merging: we prefer now to use an madvise(2) interface.

This patch just defines MADV_MERGEABLE (to tell KSM it may merge pages in
this area found identical to pages in other mergeable areas) and
MADV_UNMERGEABLE (to undo that).

Most architectures use asm-generic, but alpha, mips, parisc, xtensa need
their own definitions: included here for mmotm convenience, but we'll
probably want to split this and feed pieces to arch maintainers.

Based upon earlier patches by Chris Wright and Izik Eidus.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h     |    3 +++
 arch/mips/include/asm/mman.h      |    3 +++
 arch/parisc/include/asm/mman.h    |    3 +++
 arch/xtensa/include/asm/mman.h    |    3 +++
 include/asm-generic/mman-common.h |    3 +++
 5 files changed, 15 insertions(+)

diff -puN arch/alpha/include/asm/mman.h~ksm-define-madv_mergeable-and-madv_unmergeable arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~ksm-define-madv_mergeable-and-madv_unmergeable
+++ a/arch/alpha/include/asm/mman.h
@@ -48,6 +48,9 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
 
+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/mips/include/asm/mman.h~ksm-define-madv_mergeable-and-madv_unmergeable arch/mips/include/asm/mman.h
--- a/arch/mips/include/asm/mman.h~ksm-define-madv_mergeable-and-madv_unmergeable
+++ a/arch/mips/include/asm/mman.h
@@ -71,6 +71,9 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
 
+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/parisc/include/asm/mman.h~ksm-define-madv_mergeable-and-madv_unmergeable arch/parisc/include/asm/mman.h
--- a/arch/parisc/include/asm/mman.h~ksm-define-madv_mergeable-and-madv_unmergeable
+++ a/arch/parisc/include/asm/mman.h
@@ -54,6 +54,9 @@
 #define MADV_16M_PAGES  24              /* Use 16 Megabyte pages */
 #define MADV_64M_PAGES  26              /* Use 64 Megabyte pages */
 
+#define MADV_MERGEABLE   65		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
diff -puN arch/xtensa/include/asm/mman.h~ksm-define-madv_mergeable-and-madv_unmergeable arch/xtensa/include/asm/mman.h
--- a/arch/xtensa/include/asm/mman.h~ksm-define-madv_mergeable-and-madv_unmergeable
+++ a/arch/xtensa/include/asm/mman.h
@@ -78,6 +78,9 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
 
+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN include/asm-generic/mman-common.h~ksm-define-madv_mergeable-and-madv_unmergeable include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~ksm-define-madv_mergeable-and-madv_unmergeable
+++ a/include/asm-generic/mman-common.h
@@ -35,6 +35,9 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
 
+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

