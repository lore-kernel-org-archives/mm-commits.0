From: akpm@linux-foundation.org
Subject: + ramzswap-remove-arm-specific-d-cache-hack.patch added to -mm tree
Date: Wed, 16 Dec 2009 15:31:39 -0800
Message-ID: <200912162331.nBGNVdET022067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757009AbZLPXbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 18:31:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ngupta@vflare.org, greg@kroah.com, penberg@cs.helsinki.fi


The patch titled
     ramzswap: remove ARM specific d-cache hack
has been added to the -mm tree.  Its filename is
     ramzswap-remove-arm-specific-d-cache-hack.patch

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
Subject: ramzswap: remove ARM specific d-cache hack
From: Nitin Gupta <ngupta@vflare.org>

Remove d-cache hack in ramzswap driver that was needed to workaround a bug
in ARM version of update_mmu_cache() which caused stale data in d-cache to
be transferred to userspace.  This bug was fixed by
787b2faadc4356b6c2c71feb42fb944fece9a12f ("ARM: force dcache flush if
dcache_dirty bit set").

This also brings down one entry in TODO file.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/ramzswap/TODO           |    1 
 drivers/staging/ramzswap/ramzswap_drv.c |   28 ++--------------------
 2 files changed, 3 insertions(+), 26 deletions(-)

diff -puN drivers/staging/ramzswap/TODO~ramzswap-remove-arm-specific-d-cache-hack drivers/staging/ramzswap/TODO
--- a/drivers/staging/ramzswap/TODO~ramzswap-remove-arm-specific-d-cache-hack
+++ a/drivers/staging/ramzswap/TODO
@@ -1,6 +1,5 @@
 TODO:
 	- Add support for swap notifiers
-	- Remove CONFIG_ARM hack
 
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
 Nitin Gupta <ngupta@vflare.org>
diff -puN drivers/staging/ramzswap/ramzswap_drv.c~ramzswap-remove-arm-specific-d-cache-hack drivers/staging/ramzswap/ramzswap_drv.c
--- a/drivers/staging/ramzswap/ramzswap_drv.c~ramzswap-remove-arm-specific-d-cache-hack
+++ a/drivers/staging/ramzswap/ramzswap_drv.c
@@ -222,28 +222,6 @@ out:
 	return ret;
 }
 
-static void ramzswap_flush_dcache_page(struct page *page)
-{
-#ifdef CONFIG_ARM
-	int flag = 0;
-	/*
-	 * Ugly hack to get flush_dcache_page() work on ARM.
-	 * page_mapping(page) == NULL after clearing this swap cache flag.
-	 * Without clearing this flag, flush_dcache_page() will simply set
-	 * "PG_dcache_dirty" bit and return.
-	 */
-	if (PageSwapCache(page)) {
-		flag = 1;
-		ClearPageSwapCache(page);
-	}
-#endif
-	flush_dcache_page(page);
-#ifdef CONFIG_ARM
-	if (flag)
-		SetPageSwapCache(page);
-#endif
-}
-
 void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
 			struct ramzswap_ioctl_stats *s)
 {
@@ -655,7 +633,7 @@ static int handle_zero_page(struct bio *
 	memset(user_mem, 0, PAGE_SIZE);
 	kunmap_atomic(user_mem, KM_USER0);
 
-	ramzswap_flush_dcache_page(page);
+	flush_dcache_page(page);
 
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_endio(bio, 0);
@@ -679,7 +657,7 @@ static int handle_uncompressed_page(stru
 	kunmap_atomic(user_mem, KM_USER0);
 	kunmap_atomic(cmem, KM_USER1);
 
-	ramzswap_flush_dcache_page(page);
+	flush_dcache_page(page);
 
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_endio(bio, 0);
@@ -779,7 +757,7 @@ static int ramzswap_read(struct ramzswap
 		goto out;
 	}
 
-	ramzswap_flush_dcache_page(page);
+	flush_dcache_page(page);
 
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_endio(bio, 0);
_

Patches currently in -mm which might be from ngupta@vflare.org are

origin.patch
ramzswap-remove-arm-specific-d-cache-hack.patch

