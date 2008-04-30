From: akpm@linux-foundation.org
Subject: - random-remove-cacheline-alignment-for-locks.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:17 -0700
Message-ID: <200804300548.m3U5mHKr029870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554AbYD3GJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: remove cacheline alignment for locks
has been removed from the -mm tree.  Its filename was
     random-remove-cacheline-alignment-for-locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: remove cacheline alignment for locks
From: Matt Mackall <mpm@selenic.com>

Earlier changes greatly reduce the number of times we grab the lock
per output byte, so we shouldn't need this particular hack any more.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/random.c~random-remove-cacheline-alignment-for-locks drivers/char/random.c
--- a/drivers/char/random.c~random-remove-cacheline-alignment-for-locks
+++ a/drivers/char/random.c
@@ -395,7 +395,7 @@ module_param(debug, bool, 0644);
 
 struct entropy_store;
 struct entropy_store {
-	/* mostly-read data: */
+	/* read-only data: */
 	struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
@@ -403,7 +403,7 @@ struct entropy_store {
 	struct entropy_store *pull;
 
 	/* read-write data: */
-	spinlock_t lock ____cacheline_aligned_in_smp;
+	spinlock_t lock;
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch

