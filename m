From: akpm@linux-foundation.org
Subject: + mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
 added to -mm tree
Date: Mon, 05 Jan 2015 14:19:54 -0800
Message-ID: <54ab0e0a.swChEPMRun0dpPbF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbbAEWTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 17:19:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_pagealloc: remove obsolete Kconfig options
has been added to the -mm tree.  Its filename is
     mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/debug_pagealloc: remove obsolete Kconfig options

These are obsolete since commit "mm/debug-pagealloc: prepare boottime
configurable" is merged. So, remove it.

[pebolle@tiscali.nl: find obsolete Kconfig options]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN mm/Kconfig.debug~mm-debug-pagealloc-prepare-boottime-configurable-on-off mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-debug-pagealloc-prepare-boottime-configurable-on-off
+++ a/mm/Kconfig.debug
@@ -14,7 +14,6 @@ config DEBUG_PAGEALLOC
 	depends on !KMEMCHECK
 	select PAGE_EXTENSION
 	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	select PAGE_GUARD if ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
@@ -27,13 +26,5 @@ config DEBUG_PAGEALLOC
 	  that would result in incorrect warnings of memory corruption after
 	  a resume because free pages are not saved to the suspend image.
 
-config WANT_PAGE_DEBUG_FLAGS
-	bool
-
 config PAGE_POISONING
 	bool
-	select WANT_PAGE_DEBUG_FLAGS
