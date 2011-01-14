From: akpm@linux-foundation.org
Subject: [merged] thp-mm-define-madv_hugepage.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:19 -0800
Message-ID: <201101142249.p0EMn90j005272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771Ab1ANWtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, arnd@arndb.de, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: mm: define MADV_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     thp-mm-define-madv_hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: mm: define MADV_HUGEPAGE
From: Andrea Arcangeli <aarcange@redhat.com>

Define MADV_HUGEPAGE.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h     |    2 ++
 arch/mips/include/asm/mman.h      |    2 ++
 arch/parisc/include/asm/mman.h    |    2 ++
 arch/xtensa/include/asm/mman.h    |    2 ++
 include/asm-generic/mman-common.h |    2 ++
 5 files changed, 10 insertions(+)

diff -puN arch/alpha/include/asm/mman.h~thp-mm-define-madv_hugepage arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~thp-mm-define-madv_hugepage
+++ a/arch/alpha/include/asm/mman.h
@@ -53,6 +53,8 @@
 #define MADV_MERGEABLE   12		/* KSM may merge identical pages */
 #define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
 
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/mips/include/asm/mman.h~thp-mm-define-madv_hugepage arch/mips/include/asm/mman.h
--- a/arch/mips/include/asm/mman.h~thp-mm-define-madv_hugepage
+++ a/arch/mips/include/asm/mman.h
@@ -77,6 +77,8 @@
 #define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
 #define MADV_HWPOISON    100		/* poison a page for testing */
 
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/parisc/include/asm/mman.h~thp-mm-define-madv_hugepage arch/parisc/include/asm/mman.h
--- a/arch/parisc/include/asm/mman.h~thp-mm-define-madv_hugepage
+++ a/arch/parisc/include/asm/mman.h
@@ -59,6 +59,8 @@
 #define MADV_MERGEABLE   65		/* KSM may merge identical pages */
 #define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
 
+#define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
diff -puN arch/xtensa/include/asm/mman.h~thp-mm-define-madv_hugepage arch/xtensa/include/asm/mman.h
--- a/arch/xtensa/include/asm/mman.h~thp-mm-define-madv_hugepage
+++ a/arch/xtensa/include/asm/mman.h
@@ -83,6 +83,8 @@
 #define MADV_MERGEABLE   12		/* KSM may merge identical pages */
 #define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
 
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN include/asm-generic/mman-common.h~thp-mm-define-madv_hugepage include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~thp-mm-define-madv_hugepage
+++ a/include/asm-generic/mman-common.h
@@ -45,6 +45,8 @@
 #define MADV_MERGEABLE   12		/* KSM may merge identical pages */
 #define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
 
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

