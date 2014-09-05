From: akpm@linux-foundation.org
Subject: + zbud-avoid-accessing-in-last-unused-freelist.patch added to -mm tree
Date: Fri, 05 Sep 2014 13:38:36 -0700
Message-ID: <540a1f4c.8VON5o129yRl/RAP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaIEUih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 16:38:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chao2.yu@samsung.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zbud: avoid accessing last unused freelist
has been added to the -mm tree.  Its filename is
     zbud-avoid-accessing-in-last-unused-freelist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zbud-avoid-accessing-in-last-unused-freelist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zbud-avoid-accessing-in-last-unused-freelist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chao Yu <chao2.yu@samsung.com>
Subject: zbud: avoid accessing last unused freelist

For now, there are NCHUNKS of 64 freelists in zbud_pool, the last
unbuddied[63] freelist linked with all zbud pages which have free chunks
of 63.  Calculating according to context of num_free_chunks(), our max
chunk number of unbuddied zbud page is 62, so none of zbud pages will be
added/removed in last freelist, but still we will try to find an unbuddied
zbud page in the last unused freelist, it is unneeded.

This patch redefines NCHUNKS to 63 as free chunk number in one zbud page,
hence we can decrease size of zpool and avoid accessing the last unused
freelist whenever failing to allocate zbud from freelist in zbud_alloc.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/zbud.c~zbud-avoid-accessing-in-last-unused-freelist mm/zbud.c
--- a/mm/zbud.c~zbud-avoid-accessing-in-last-unused-freelist
+++ a/mm/zbud.c
@@ -60,15 +60,17 @@
  * NCHUNKS_ORDER determines the internal allocation granularity, effectively
  * adjusting internal fragmentation.  It also determines the number of
  * freelists maintained in each pool. NCHUNKS_ORDER of 6 means that the
- * allocation granularity will be in chunks of size PAGE_SIZE/64, and there
- * will be 64 freelists per pool.
+ * allocation granularity will be in chunks of size PAGE_SIZE/64. As one chunk
+ * in allocated page is occupied by zbud header, NCHUNKS will be calculated to
+ * 63 which shows the max number of free chunks in zbud page, also there will be
+ * 63 freelists per pool.
  */
 #define NCHUNKS_ORDER	6
 
 #define CHUNK_SHIFT	(PAGE_SHIFT - NCHUNKS_ORDER)
 #define CHUNK_SIZE	(1 << CHUNK_SHIFT)
-#define NCHUNKS		(PAGE_SIZE >> CHUNK_SHIFT)
 #define ZHDR_SIZE_ALIGNED CHUNK_SIZE
+#define NCHUNKS		((PAGE_SIZE - ZHDR_SIZE_ALIGNED) >> CHUNK_SHIFT)
 
 /**
  * struct zbud_pool - stores metadata for each zbud pool
@@ -268,10 +270,9 @@ static int num_free_chunks(struct zbud_h
 {
 	/*
 	 * Rather than branch for different situations, just use the fact that
-	 * free buddies have a length of zero to simplify everything. -1 at the
-	 * end for the zbud header.
+	 * free buddies have a length of zero to simplify everything.
 	 */
-	return NCHUNKS - zhdr->first_chunks - zhdr->last_chunks - 1;
+	return NCHUNKS - zhdr->first_chunks - zhdr->last_chunks;
 }
 
 /*****************
_

Patches currently in -mm which might be from chao2.yu@samsung.com are

origin.patch
zram-use-notify_free-to-account-all-free-notifications.patch
zbud-avoid-accessing-in-last-unused-freelist.patch

