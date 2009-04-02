From: akpm@linux-foundation.org
Subject: + mm-define-a-unique-value-for-as_unevictable-flag.patch added to -mm tree
Date: Thu, 02 Apr 2009 10:11:37 -0700
Message-ID: <200904021711.n32HBbQp002343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbZDBRPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 13:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, stable@kernel.org


The patch titled
     mm: define a UNIQUE value for AS_UNEVICTABLE flag
has been added to the -mm tree.  Its filename is
     mm-define-a-unique-value-for-as_unevictable-flag.patch

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
Subject: mm: define a UNIQUE value for AS_UNEVICTABLE flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

A new "address_space flag"--AS_MM_ALL_LOCKS--was defined to use the next
available AS flag while the Unevictable LRU was under development.  The
Unevictable LRU was using the same flag and "no one" noticed.  Current
mainline, since 2.6.28, has same value for two symbolic flag names.

So, define a unique flag value for AS_UNEVICTABLE--up close to the other
flags, [at the cost of an additional #ifdef] so we'll notice next time. 
Note that #ifdef is not actually required, if we don't mind having the
unused flag value defined.

Replace #defines with an enum.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: <stable@kernel.org>		[2.6.28.x, 2.6.29.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/pagemap.h~mm-define-a-unique-value-for-as_unevictable-flag include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-define-a-unique-value-for-as_unevictable-flag
+++ a/include/linux/pagemap.h
@@ -18,9 +18,14 @@
  * Bits in mapping->flags.  The lower __GFP_BITS_SHIFT bits are the page
  * allocation mode flags.
  */
-#define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
-#define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
-#define AS_MM_ALL_LOCKS	(__GFP_BITS_SHIFT + 2)	/* under mm_take_all_locks() */
+enum mapping_flags {
+	AS_EIO		= __GFP_BITS_SHIFT + 0,	/* IO error on async write */
+	AS_ENOSPC	= __GFP_BITS_SHIFT + 1,	/* ENOSPC on async write */
+	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
+#ifdef CONFIG_UNEVICTABLE_LRU
+	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
+#endif
+};
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
 {
@@ -33,7 +38,6 @@ static inline void mapping_set_error(str
 }
 
 #ifdef CONFIG_UNEVICTABLE_LRU
-#define AS_UNEVICTABLE	(__GFP_BITS_SHIFT + 2)	/* e.g., ramdisk, SHM_LOCK */
 
 static inline void mapping_set_unevictable(struct address_space *mapping)
 {
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
mm-define-a-unique-value-for-as_unevictable-flag.patch

