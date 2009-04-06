From: akpm@linux-foundation.org
Subject: [merged] mm-define-a-unique-value-for-as_unevictable-flag.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:41 -0700
Message-ID: <200904061932.n36JWfNq010803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757417AbZDFTgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: define a UNIQUE value for AS_UNEVICTABLE flag
has been removed from the -mm tree.  Its filename was
     mm-define-a-unique-value-for-as_unevictable-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

