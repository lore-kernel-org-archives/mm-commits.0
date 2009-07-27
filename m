From: akpm@linux-foundation.org
Subject: + mm-improve-help-text-for-mm-debug-config-options.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:45:31 -0700
Message-ID: <200907272145.n6RLjV5k032551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbZG0Vph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, jkosina@suse.cz


The patch titled
     mm: improve help text for mm debug config options
has been added to the -mm tree.  Its filename is
     mm-improve-help-text-for-mm-debug-config-options.patch

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
Subject: mm: improve help text for mm debug config options
From: Frans Pop <elendil@planet.nl>

Improve the help text for PAGE_POISONING.  Also fix some typos and improve
consistency within the file.

Signed-of-by: Frans Pop <elendil@planet.nl>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/Kconfig.debug~mm-improve-help-text-for-mm-debug-config-options mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-improve-help-text-for-mm-debug-config-options
+++ a/mm/Kconfig.debug
@@ -6,7 +6,7 @@ config DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
-	  of memory corruptions.
+	  of memory corruption.
 
 config WANT_PAGE_DEBUG_FLAGS
 	bool
@@ -17,11 +17,11 @@ config PAGE_POISONING
 	depends on !HIBERNATION
 	select DEBUG_PAGEALLOC
 	select WANT_PAGE_DEBUG_FLAGS
-	help
+	---help---
 	   Fill the pages with poison patterns after free_pages() and verify
 	   the patterns before alloc_pages(). This results in a large slowdown,
-	   but helps to find certain types of memory corruptions.
+	   but helps to find certain types of memory corruption.
 
-	   This option cannot enalbe with hibernation. Otherwise, it will get
-	   wrong messages for memory corruption because the free pages are not
-	   saved to the suspend image.
+	   This option cannot be enabled in combination with hibernation as
+	   that would result in incorrect warnings of memory corruption after
+	   a resume because free pages are not saved to the suspend image.
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch
mm-improve-help-text-for-mm-debug-config-options.patch

