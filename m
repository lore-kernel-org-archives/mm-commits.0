From: akpm@linux-foundation.org
Subject: - generic-swap-ext3-remove-local-swap-macro.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:18 -0800
Message-ID: <200901082251.n08MpIO8030418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763280AbZAHWvm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     generic swap(): ext3: remove local swap() macro
has been removed from the -mm tree.  Its filename was
     generic-swap-ext3-remove-local-swap-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic swap(): ext3: remove local swap() macro
From: Wu Fengguang <fengguang.wu@intel.com>

Use the new generic implementation.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ext3/namei.c~generic-swap-ext3-remove-local-swap-macro fs/ext3/namei.c
--- a/fs/ext3/namei.c~generic-swap-ext3-remove-local-swap-macro
+++ a/fs/ext3/namei.c
@@ -74,10 +74,6 @@ static struct buffer_head *ext3_append(h
 #define assert(test) J_ASSERT(test)
 #endif
 
-#ifndef swap
-#define swap(x, y) do { typeof(x) z = x; x = y; y = z; } while (0)
-#endif
