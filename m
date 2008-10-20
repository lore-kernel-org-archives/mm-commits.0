From: akpm@linux-foundation.org
Subject: - pageflag-helpers-for-configed-out-flags.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:47 -0700
Message-ID: <200810202032.m9KKWlhN010480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbYJTUg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pageflag helpers for configed-out flags
has been removed from the -mm tree.  Its filename was
     pageflag-helpers-for-configed-out-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pageflag helpers for configed-out flags
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Define proper false/noop inline functions for noreclaim page flags when
!defined(CONFIG_UNEVICTABLE_LRU)

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
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
 
 TESTPAGEFLAG(Locked, locked)
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch

