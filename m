From: akpm@linux-foundation.org
Subject: + dma-debug-track-bucket-lock-state-for-static-checkers.patch
 added to -mm tree
Date: Mon, 11 Jul 2016 14:42:29 -0700
Message-ID: <578412c5.5pAh8ziWo8ezuxNp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbcGKVma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 17:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: track bucket lock state for static checkers
has been added to the -mm tree.  Its filename is
     dma-debug-track-bucket-lock-state-for-static-checkers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-track-bucket-lock-state-for-static-checkers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-track-bucket-lock-state-for-static-checkers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: dma-debug: track bucket lock state for static checkers

get_hash_bucket() and put_hash_bucket() acquire and release the
same spinlock, but this confuses static checkers such as sparse

lib/dma-debug.c:254:27: warning: context imbalance in 'get_hash_bucket' - wrong count at exit
lib/dma-debug.c:268:13: warning: context imbalance in 'put_hash_bucket' - unexpected unlock

Add the appropriate acquire and release statements so that
checkers can properly track the lock state.

Link: http://lkml.kernel.org/r/20160701191552.24295-1-sboyd@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/dma-debug.c~dma-debug-track-bucket-lock-state-for-static-checkers lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-track-bucket-lock-state-for-static-checkers
+++ a/lib/dma-debug.c
@@ -253,6 +253,7 @@ static int hash_fn(struct dma_debug_entr
  */
 static struct hash_bucket *get_hash_bucket(struct dma_debug_entry *entry,
 					   unsigned long *flags)
+	__acquires(&dma_entry_hash[idx].lock)
 {
 	int idx = hash_fn(entry);
 	unsigned long __flags;
@@ -267,6 +268,7 @@ static struct hash_bucket *get_hash_buck
  */
 static void put_hash_bucket(struct hash_bucket *bucket,
 			    unsigned long *flags)
+	__releases(&bucket->lock)
 {
 	unsigned long __flags = *flags;
 
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

dma-debug-track-bucket-lock-state-for-static-checkers.patch

