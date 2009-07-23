From: akpm@linux-foundation.org
Subject: + ksm-define-madv_mergeable-and-madv_unmergeable.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:07:28 -0700
Message-ID: <200907232107.n6NL7SkZ027250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241AbZGWVIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:08:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chris@zankel.net, chrisw@redhat.com, deller@gmx.de, fengguang.wu@intel.com, ieidus@redhat.com, ink@jurassic.park.msu.ru, kamezawa.hiroyu@jp.fujitsu.com, kyle@mcmartin.ca, lee.schermerhorn@hp.com, mtk.manpages@gmail.com, nickpiggin@yahoo.com.au, ralf@linux-mips.org, riel@redhat.com, rth@twiddle.net


The patch titled
     ksm: define MADV_MERGEABLE and MADV_UNMERGEABLE
has been added to the -mm tree.  Its filename is
     ksm-define-madv_mergeable-and-madv_unmergeable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-avoid-endless-looping-for-oom-killed-tasks.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
prio_tree-debugging-patch.patch

