From: akpm@linux-foundation.org
Subject: +
 page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
 added to -mm tree
Date: Fri, 02 Oct 2015 14:10:16 -0700
Message-ID: <560ef2b8.GnlZGZfwm82J88tc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbJBVKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 17:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, cl@linux.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: hide PF_* validation check under separate config option
has been added to the -mm tree.  Its filename is
     page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: hide PF_* validation check under separate config option

VM_BUG_ONs in PF_NO_TAIL() and PF_NO_COMPOUND() add 4+ KiB to
mm/build-in.o for DEBUG_VM kernel.

Let's hide them under new config option -- CONFIG_DEBUG_VM_PGFLAGS.
With the option enabled VM_BUG_ON_PGFLAGS() is equal to VM_BUG_ON_PAGE.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h    |    6 ++++++
 include/linux/page-flags.h |    6 ++----
 lib/Kconfig.debug          |    8 ++++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff -puN include/linux/mmdebug.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3 include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3
+++ a/include/linux/mmdebug.h
@@ -55,4 +55,10 @@ void dump_mm(const struct mm_struct *mm)
 #define VIRTUAL_BUG_ON(cond) do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_VM_PGFLAGS
+#define VM_BUG_ON_PGFLAGS(cond, page) VM_BUG_ON_PAGE(cond, page)
+#else
+#define VM_BUG_ON_PGFLAGS(cond, page) BUILD_BUG_ON_INVALID(cond)
+#endif
+
 #endif
diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3 include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3
+++ a/include/linux/page-flags.h
@@ -174,12 +174,10 @@ static inline int PageCompound(struct pa
 #define PF_ANY(page, enforce)	page
 #define PF_HEAD(page, enforce)	compound_head(page)
 #define PF_NO_TAIL(page, enforce) ({					\
-		if (enforce)						\
-			VM_BUG_ON_PAGE(PageTail(page), page);		\
+		VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);	\
 		compound_head(page);})
 #define PF_NO_COMPOUND(page, enforce) ({					\
-		if (enforce)						\
-			VM_BUG_ON_PAGE(PageCompound(page), page);	\
+		VM_BUG_ON_PGFLAGS(enforce && PageCompound(page), page);	\
 		page;})
 
 /*
diff -puN lib/Kconfig.debug~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3 lib/Kconfig.debug
--- a/lib/Kconfig.debug~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3
+++ a/lib/Kconfig.debug
@@ -570,6 +570,14 @@ config DEBUG_VM_RB
 
 	  If unsure, say N.
 
+config DEBUG_VM_PGFLAGS
+	bool "Debug page-flags operations"
+	depends on DEBUG_VM
+	help
+	  Enables extra validation on page flags operations.
+
+	  If unsure, say N.
+
 config DEBUG_VIRTUAL
 	bool "Debug VM translations"
 	depends on DEBUG_KERNEL && X86
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

