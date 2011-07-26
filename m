From: akpm@linux-foundation.org
Subject: [merged] mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:05 -0700
Message-ID: <201107260751.p6Q7p8sg002925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab1GZHvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:51:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ian.campbell@citrix.com, aarcange@redhat.com, riel@redhat.com, schwidefsky@de.ibm.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: use const struct page for r/o page-flag accessor methods
has been removed from the -mm tree.  Its filename was
     mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use const struct page for r/o page-flag accessor methods
From: Ian Campbell <ian.campbell@citrix.com>

In a subsquent patch I have a const struct page in my hand...

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/page-flags.h~mm-use-const-struct-page-for-r-o-page-flag-accessor-methods include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-use-const-struct-page-for-r-o-page-flag-accessor-methods
+++ a/include/linux/page-flags.h
@@ -135,7 +135,7 @@ enum pageflags {
  * Macros to create function definitions for page flags
  */
 #define TESTPAGEFLAG(uname, lname)					\
-static inline int Page##uname(struct page *page) 			\
+static inline int Page##uname(const struct page *page)			\
 			{ return test_bit(PG_##lname, &page->flags); }
 
 #define SETPAGEFLAG(uname, lname)					\
@@ -173,7 +173,7 @@ static inline int __TestClearPage##uname
 	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
 
 #define PAGEFLAG_FALSE(uname) 						\
-static inline int Page##uname(struct page *page) 			\
+static inline int Page##uname(const struct page *page)			\
 			{ return 0; }
 
 #define TESTSCFLAG(uname, lname)					\
_

Patches currently in -mm which might be from ian.campbell@citrix.com are

origin.patch

