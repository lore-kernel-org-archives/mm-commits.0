From: akpm@linux-foundation.org
Subject: + mm-remove-unused-testsetpagelocked-interface.patch added to -mm tree
Date: Tue, 22 Feb 2011 16:22:27 -0800
Message-ID: <201102230022.p1N0MR9S002975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab1BWAXC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Feb 2011 19:23:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com


The patch titled
     mm: remove unused TestSetPageLocked() interface
has been added to the -mm tree.  Its filename is
     mm-remove-unused-testsetpagelocked-interface.patch

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

linux-next.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-remove-unused-testsetpagelocked-interface.patch

