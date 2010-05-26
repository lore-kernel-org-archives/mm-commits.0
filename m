From: akpm@linux-foundation.org
Subject: + vmware-balloon-clamp-number-of-collected-non-balloonable-pages.patch added to -mm tree
Date: Wed, 26 May 2010 16:09:31 -0700
Message-ID: <201005262309.o4QN9VA7020239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934489Ab0EZXKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 May 2010 19:10:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@vmware.com, bhavesh@vmware.com, stable@kernel.org


The patch titled
     vmware balloon: clamp number of collected non-balloonable pages
has been added to the -mm tree.  Its filename is
     vmware-balloon-clamp-number-of-collected-non-balloonable-pages.patch

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
Subject: vmware balloon: clamp number of collected non-balloonable pages
From: Dmitry Torokhov <dtor@vmware.com>

Limit number of accumulated non-balloonable pages during inflation cycle,
otherwise there is a chance we will be spinning and growing the list
forever.  This happens during torture tests when balloon target changes
while we are in the middle of inflation cycle and monitor starts refusing
to lock pages (since they are not needed anymore).

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Acked-by: Bhavesh Davda <bhavesh@vmware.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmware_balloon.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN drivers/misc/vmware_balloon.c~vmware-balloon-clamp-number-of-collected-non-balloonable-pages drivers/misc/vmware_balloon.c
--- a/drivers/misc/vmware_balloon.c~vmware-balloon-clamp-number-of-collected-non-balloonable-pages
+++ a/drivers/misc/vmware_balloon.c
@@ -45,7 +45,7 @@
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
-MODULE_VERSION("1.2.1.0-K");
+MODULE_VERSION("1.2.1.1-k");
 MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
@@ -101,6 +101,8 @@ MODULE_LICENSE("GPL");
 /* Maximum number of page allocations without yielding processor */
 #define VMW_BALLOON_YIELD_THRESHOLD	1024
 
+/* Maximum number of refused pages we accumulate during inflation cycle */
+#define VMW_BALLOON_MAX_REFUSED		16
 
 /*
  * Hypervisor communication port definitions.
@@ -183,6 +185,7 @@ struct vmballoon {
 
 	/* transient list of non-balloonable pages */
 	struct list_head refused_pages;
+	unsigned int n_refused_pages;
 
 	/* balloon size in pages */
 	unsigned int size;
@@ -428,14 +431,21 @@ static int vmballoon_reserve_page(struct
 		/* inform monitor */
 		locked = vmballoon_send_lock_page(b, page_to_pfn(page));
 		if (!locked) {
+			STATS_INC(b->stats.refused_alloc);
+
 			if (b->reset_required) {
 				__free_page(page);
 				return -EIO;
 			}
 
-			/* place on list of non-balloonable pages, retry allocation */
+			/*
+			 * Place page on the list of non-balloonable pages
+			 * and retry allocation, unless we already accumulated
+			 * too many of them, in which case take a breather.
+			 */
 			list_add(&page->lru, &b->refused_pages);
-			STATS_INC(b->stats.refused_alloc);
+			if (++b->n_refused_pages >= VMW_BALLOON_MAX_REFUSED)
+				return -EIO;
 		}
 	} while (!locked);
 
@@ -483,6 +493,8 @@ static void vmballoon_release_refused_pa
 		__free_page(page);
 		STATS_INC(b->stats.refused_free);
 	}
+
+	b->n_refused_pages = 0;
 }
 
 /*
_

Patches currently in -mm which might be from dtor@vmware.com are

origin.patch
vmware-balloon-clamp-number-of-collected-non-balloonable-pages.patch

