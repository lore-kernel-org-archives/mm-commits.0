From: akpm@linux-foundation.org
Subject: - random-reuse-rand_initialize.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:11 -0700
Message-ID: <200804300548.m3U5mBHV029861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756605AbYD3GHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: reuse rand_initialize
has been removed from the -mm tree.  Its filename was
     random-reuse-rand_initialize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: reuse rand_initialize
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/char/random.c~random-reuse-rand_initialize drivers/char/random.c
--- a/drivers/char/random.c~random-reuse-rand_initialize
+++ a/drivers/char/random.c
@@ -899,7 +899,7 @@ static void init_std_data(struct entropy
 			  sizeof(*(utsname()))/4);
 }
 
-static int __init rand_initialize(void)
+static int rand_initialize(void)
 {
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
@@ -1101,9 +1101,7 @@ static long random_ioctl(struct file *f,
 		/* Clear the entropy pool counters. */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		init_std_data(&input_pool);
-		init_std_data(&blocking_pool);
-		init_std_data(&nonblocking_pool);
+		rand_initialize();
 		return 0;
 	default:
 		return -EINVAL;
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch

