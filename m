From: akpm@linux-foundation.org
Subject: [merged] mm-improve-help-text-for-mm-debug-config-options.patch removed from -mm tree
Date: Fri, 14 Aug 2009 12:56:25 -0700
Message-ID: <200908141956.n7EJuPgD005872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757093AbZHNT4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Aug 2009 15:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm: improve help text for mm debug config options
has been removed from the -mm tree.  Its filename was
     mm-improve-help-text-for-mm-debug-config-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

