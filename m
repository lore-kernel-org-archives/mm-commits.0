From: akpm@linux-foundation.org
Subject: + mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch added to -mm tree
Date: Fri, 22 Jul 2011 14:07:14 -0700
Message-ID: <201107222107.p6ML7ESs012351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932158Ab1GVVHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 17:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian.campbell@citrix.com, aarcange@redhat.com, riel@redhat.com, schwidefsky@de.ibm.com, walken@google.com


The patch titled
     mm: use const struct page for r/o page-flag accessor methods
has been added to the -mm tree.  Its filename is
     mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch

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
Subject: mm: use const struct page for r/o page-flag accessor methods
From: Ian Campbell <ian.campbell@citrix.com>

In a subsquent patch I have a const struct page in my hand...

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
+static inline int Page##uname(const struct page *page) 			\
 			{ return test_bit(PG_##lname, &page->flags); }
 
 #define SETPAGEFLAG(uname, lname)					\
@@ -173,7 +173,7 @@ static inline int __TestClearPage##uname
 	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
 
 #define PAGEFLAG_FALSE(uname) 						\
-static inline int Page##uname(struct page *page) 			\
+static inline int Page##uname(const struct page *page) 			\
 			{ return 0; }
 
 #define TESTSCFLAG(uname, lname)					\
_

Patches currently in -mm which might be from ian.campbell@citrix.com are

mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
linux-next.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
xen-balloon-memory-hotplug-support-for-xen-balloon-driver.patch

