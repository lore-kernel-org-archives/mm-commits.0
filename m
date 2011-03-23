From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unused-testsetpagelocked-interface.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:23 -0700
Message-ID: <201103232039.p2NKdxgp028459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933323Ab1CWUwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:52:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove unused TestSetPageLocked() interface
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-testsetpagelocked-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove unused TestSetPageLocked() interface
From: Michel Lespinasse <walken@google.com>

TestSetPageLocked() isn't being used anywhere.  Also, using it would
likely be an error, since the proper interface trylock_page() provides
stronger ordering guarantees.

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~mm-remove-unused-testsetpagelocked-interface include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-remove-unused-testsetpagelocked-interface
+++ a/include/linux/page-flags.h
@@ -196,7 +196,7 @@ static inline int __TestClearPage##uname
 
 struct page;	/* forward declaration */
 
-TESTPAGEFLAG(Locked, locked) TESTSETFLAG(Locked, locked)
+TESTPAGEFLAG(Locked, locked)
 PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
 PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
 PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
_

Patches currently in -mm which might be from walken@google.com are

origin.patch

