From: akpm@linux-foundation.org
Subject: + vmscan-pageflag-helpers-for-configed-out-flags.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:18:37 -0700
Message-ID: <200806090618.m596IbKK006625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbYFIGTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     vmscan: pageflag helpers for configed-out flags
has been added to the -mm tree.  Its filename is
     vmscan-pageflag-helpers-for-configed-out-flags.patch

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
Subject: vmscan: pageflag helpers for configed-out flags
From: Lee Schermerhorn <lee.schermerhorn@hp.com>


Define proper false/noop inline functions for noreclaim page
flags when !defined(CONFIG_NORECLAIM_LRU)

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

---
 1 file changed, 12 insertions(+)

Index: linux-2.6.26-rc2-mm1/include/linux/page-flags.h
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN include/linux/page-flags.h~pageflag-helpers-for-configed-out-flags include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflag-helpers-for-configed-out-flags
+++ a/include/linux/page-flags.h
@@ -162,6 +162,18 @@ static inline int Page##uname(struct pag
 #define TESTSCFLAG(uname, lname)					\
 	TESTSETFLAG(uname, lname) TESTCLEARFLAG(uname, lname)
 
+#define SETPAGEFLAG_NOOP(uname)						\
+static inline void SetPage##uname(struct page *page) {  }
+
+#define CLEARPAGEFLAG_NOOP(uname)					\
+static inline void ClearPage##uname(struct page *page) {  }
+
+#define __CLEARPAGEFLAG_NOOP(uname)					\
+static inline void __ClearPage##uname(struct page *page) {  }
+
+#define TESTCLEARFLAG_FALSE(uname)					\
+static inline int TestClearPage##uname(struct page *page) { return 0; }
+
 struct page;	/* forward declaration */
 
 PAGEFLAG(Locked, locked) TESTSCFLAG(Locked, locked)
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
vmscan-define-page_file_cache-function.patch
vmscan-pageflag-helpers-for-configed-out-flags.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-cull-non-reclaimable-pages-in-fault-path.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch

