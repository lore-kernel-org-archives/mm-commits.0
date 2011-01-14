From: akpm@linux-foundation.org
Subject: [merged] thp-mm-define-madv_nohugepage.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:43 -0800
Message-ID: <201101142251.p0EMpXt5005524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1ANWvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: mm: define MADV_NOHUGEPAGE
has been removed from the -mm tree.  Its filename was
     thp-mm-define-madv_nohugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: mm: define MADV_NOHUGEPAGE
From: Andrea Arcangeli <aarcange@redhat.com>

Define MADV_NOHUGEPAGE.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h     |    1 +
 arch/mips/include/asm/mman.h      |    1 +
 arch/parisc/include/asm/mman.h    |    1 +
 arch/xtensa/include/asm/mman.h    |    1 +
 include/asm-generic/mman-common.h |    1 +
 5 files changed, 5 insertions(+)

diff -puN arch/alpha/include/asm/mman.h~thp-mm-define-madv_nohugepage arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~thp-mm-define-madv_nohugepage
+++ a/arch/alpha/include/asm/mman.h
@@ -54,6 +54,7 @@
 #define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
 
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
 /* compatibility flags */
 #define MAP_FILE	0
diff -puN arch/mips/include/asm/mman.h~thp-mm-define-madv_nohugepage arch/mips/include/asm/mman.h
--- a/arch/mips/include/asm/mman.h~thp-mm-define-madv_nohugepage
+++ a/arch/mips/include/asm/mman.h
@@ -78,6 +78,7 @@
 #define MADV_HWPOISON    100		/* poison a page for testing */
 
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
 /* compatibility flags */
 #define MAP_FILE	0
diff -puN arch/parisc/include/asm/mman.h~thp-mm-define-madv_nohugepage arch/parisc/include/asm/mman.h
--- a/arch/parisc/include/asm/mman.h~thp-mm-define-madv_nohugepage
+++ a/arch/parisc/include/asm/mman.h
@@ -60,6 +60,7 @@
 #define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
 
 #define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
 
 /* compatibility flags */
 #define MAP_FILE	0
diff -puN arch/xtensa/include/asm/mman.h~thp-mm-define-madv_nohugepage arch/xtensa/include/asm/mman.h
--- a/arch/xtensa/include/asm/mman.h~thp-mm-define-madv_nohugepage
+++ a/arch/xtensa/include/asm/mman.h
@@ -84,6 +84,7 @@
 #define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
 
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
 /* compatibility flags */
 #define MAP_FILE	0
diff -puN include/asm-generic/mman-common.h~thp-mm-define-madv_nohugepage include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~thp-mm-define-madv_nohugepage
+++ a/include/asm-generic/mman-common.h
@@ -46,6 +46,7 @@
 #define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
 
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
 /* compatibility flags */
 #define MAP_FILE	0
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

