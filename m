From: akpm@linux-foundation.org
Subject: + dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch added to -mm tree
Date: Mon, 05 Nov 2012 12:05:42 -0800
Message-ID: <20121105200543.1EAA51000AE@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:45852 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:05:44 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so719185yen.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:05:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthieu.castet@parrot.com


The patch titled
     Subject: dmapool: make DMAPOOL_DEBUG detect corruption of free marker
has been added to the -mm tree.  Its filename is
     dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: dmapool: make DMAPOOL_DEBUG detect corruption of free marker

This can help to catch the case where hardware is writing after dma free.

Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN mm/dmapool.c~dmapool-make-dmapool_debug-detect-corruption-of-free-marker mm/dmapool.c
--- a/mm/dmapool.c~dmapool-make-dmapool_debug-detect-corruption-of-free-marker
+++ a/mm/dmapool.c
@@ -346,6 +346,29 @@ void *dma_pool_alloc(struct dma_pool *po
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
 #ifdef	DMAPOOL_DEBUG
+	{
+		int i;
+		u8 *data = retval;
+		/* page->offset is stored in first 4 bytes */
+		for (i = sizeof(int); i < pool->size; i++) {
+			if (data[i] != POOL_POISON_FREED) {
+				if (pool->dev)
+					dev_err(pool->dev,
+							"dma_pool_alloc %s, %p (corruped)\n",
+							pool->name, retval);
+				else
+					printk(KERN_ERR
+							"dma_pool_alloc %s, %p (corruped)\n",
+							pool->name, retval);
+
+				/* we dump the first 4 bytes even if there are not
+				   POOL_POISON_FREED */
+				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
+						data, pool->size, 1);
+				break;
+			}
+		}
+	}
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
  done:
_

Patches currently in -mm which might be from matthieu.castet@parrot.com are

linux-next.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch

