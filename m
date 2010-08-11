From: akpm@linux-foundation.org
Subject: + mm-fix-fatal-kernel-doc-error.patch added to -mm tree
Date: Wed, 11 Aug 2010 12:37:15 -0700
Message-ID: <201008111937.o7BJbHZ8010509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391Ab0HKThv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 15:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     mm: fix fatal kernel-doc error
has been added to the -mm tree.  Its filename is
     mm-fix-fatal-kernel-doc-error.patch

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
Subject: mm: fix fatal kernel-doc error
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix a fatal kernel-doc error due to a #define coming between a function's
kernel-doc notation and the function signature.  (kernel-doc cannot handle
this)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-fix-fatal-kernel-doc-error mm/page-writeback.c
--- a/mm/page-writeback.c~mm-fix-fatal-kernel-doc-error
+++ a/mm/page-writeback.c
@@ -825,10 +825,10 @@ void __init page_writeback_init(void)
 /*
  * We tag pages in batches of WRITEBACK_TAG_BATCH to reduce tree_lock latency.
  */
-#define WRITEBACK_TAG_BATCH 4096
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end)
 {
+#define WRITEBACK_TAG_BATCH 4096
 	unsigned long tagged;
 
 	do {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
mm-fix-fatal-kernel-doc-error.patch
pc8736x_gpio-depends-on-x86_32.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

