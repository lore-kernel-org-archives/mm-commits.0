From: akpm@linux-foundation.org
Subject: + lib-dma-debug-fix-bucket_find_contain.patch added to -mm tree
Date: Thu, 19 Mar 2015 15:09:06 -0700
Message-ID: <550b4902.wKLMHS9uttMgWvIz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbCSWJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Mar 2015 18:09:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebott@linux.vnet.ibm.com, f.fainelli@gmail.com, horia.geanta@freescale.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dma-debug: fix bucket_find_contain()
has been added to the -mm tree.  Its filename is
     lib-dma-debug-fix-bucket_find_contain.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-dma-debug-fix-bucket_find_contain.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-dma-debug-fix-bucket_find_contain.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: lib/dma-debug: fix bucket_find_contain()

bucket_find_contain() will search the bucket list for a dma_debug_entry. 
When the entry isn't found it needs to search other buckets too, since
only the start address of a dma range is hashed (which might be in a
different bucket).

A copy of the dma_debug_entry is used to get the previous hash bucket but
when its list is searched the original dma_debug_entry is to be used not
its modified copy.

This fixes false "device driver tries to sync DMA memory it has not allocated"
warnings.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Horia Geanta <horia.geanta@freescale.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/dma-debug.c~lib-dma-debug-fix-bucket_find_contain lib/dma-debug.c
--- a/lib/dma-debug.c~lib-dma-debug-fix-bucket_find_contain
+++ a/lib/dma-debug.c
@@ -361,7 +361,7 @@ static struct dma_debug_entry *bucket_fi
 	unsigned int range = 0;
 
 	while (range <= max_range) {
-		entry = __hash_bucket_find(*bucket, &index, containing_match);
+		entry = __hash_bucket_find(*bucket, ref, containing_match);
 
 		if (entry)
 			return entry;
_

Patches currently in -mm which might be from sebott@linux.vnet.ibm.com are

s390-remove-use-of-seq_printf-return-value.patch
lib-dma-debug-fix-bucket_find_contain.patch
linux-next.patch

