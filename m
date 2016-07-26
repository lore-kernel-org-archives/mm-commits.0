From: akpm@linux-foundation.org
Subject: [patch 004/126] dma-debug: track bucket lock state for static
 checkers
Date: Tue, 26 Jul 2016 15:21:08 -0700
Message-ID: <5797e254.8nUeHy1cYEwT/Xhp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbcGZWVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sboyd@codeaurora.org

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
