From: akpm@linux-foundation.org
Subject: + pageflags-introduce-macros-to-generate-page-flag-functions.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:31:15 -0800
Message-ID: <200803060131.m261VGRx002224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758265AbYCFBcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:32:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     pageflags: introduce macros to generate page flag functions
has been added to the -mm tree.  Its filename is
     pageflags-introduce-macros-to-generate-page-flag-functions.patch

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
Subject: pageflags: introduce macros to generate page flag functions
From: Christoph Lameter <clameter@sgi.com>

Introduce a set of macros that generate functions to handle page flags.

A page flag function group typically starts with either

	SETPAGEFLAG(<part of function name>,<part of PG_ flagname>)

to create a set of page flag operations that are atomic. Or

	__SETPAGEFLAG(<part of function name>,<part of PG_ flagname)

to create a set of page flag operations that are not atomic.

Then additional operations can be added using the following macros

TESTSCFLAG		Create additional atomic test-and-set and
			test-and-clear functions

TESTSETFLAG		Create additional test and set function
TESTCLEARFLAG		Create additional test and clear function
SETPAGEFLAG		Create additional atomic set function
CLEARPAGEFLAG		Create additional atomic clear function
__TESTPAGEFLAG		Create additional non atomic set function
__SETPAGEFLAG		Create additional non atomic clear function

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   41 +++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff -puN include/linux/page-flags.h~pageflags-introduce-macros-to-generate-page-flag-functions include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflags-introduce-macros-to-generate-page-flag-functions
+++ a/include/linux/page-flags.h
@@ -105,6 +105,47 @@ enum pageflags {
 };
 
 /*
+ * Macros to create function definitions for page flags
+ */
+#define TESTPAGEFLAG(uname, lname)					\
+static inline int Page##uname(struct page *page) 			\
+			{ return test_bit(PG_##lname, page); }
+
+#define SETPAGEFLAG(uname, lname)					\
+static inline void SetPage##uname(struct page *page)			\
+			{ set_bit(PG_##lname, page); }
+
+#define CLEARPAGEFLAG(uname, lname)					\
+static inline void ClearPage##uname(struct page *page)			\
+			{ clear_bit(PG_##lname, page); }
+
+#define __SETPAGEFLAG(uname, lname)					\
+static inline void __SetPage##uname(struct page *page)			\
+			{ __set_bit(PG_##lname, page); }
+
+#define __CLEARPAGEFLAG(uname, lname)					\
+static inline void __ClearPage##uname(struct page *page)		\
+			{ __clear_bit(PG_##lname, page); }
+
+#define TESTSETFLAG(uname, lname)					\
+static inline int TestSetPage##uname(struct page *page)			\
+		{ return test_and_set_bit(PG_##lname, &page->flags); }
+
+#define TESTCLEARFLAG(uname, lname)					\
+static inline int TestClearPage##uname(struct page *page)		\
+		{ return test_and_clear_bit(PG_##lname, &page->flags); }
+
+
+#define PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
+	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)
+
+#define __PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
+	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
+
+#define TESTSCFLAG(uname, lname)					\
+	TESTSETFLAG(uname, lname) TESTCLEARFLAG(uname, lname)
+
+/*
  * Manipulation of page state flags
  */
 #define PageLocked(page)		\
_

Patches currently in -mm which might be from clameter@sgi.com are

fix-mempolicy-reference-counting-bugs.patch
git-unionfs.patch
git-slub.patch
slab-pass-correct-flags-to-kmem_getpages.patch
ntfs-fix-nommu-build.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

