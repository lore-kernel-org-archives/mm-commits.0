From: akpm@linux-foundation.org
Subject: - xfs-fix-randomh-include-for-non-debug-builds.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:29 -0700
Message-ID: <200805010933.m419XT1N031145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755281AbYEAJdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dgc@sgi.com, hch@infradead.org, lachlan@sgi.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     xfs: fix random.h include for non-debug builds
has been removed from the -mm tree.  Its filename was
     xfs-fix-randomh-include-for-non-debug-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: fix random.h include for non-debug builds
From: David Chinner <dgc@sgi.com>

Include linux/random.h in all builds, not just debug.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_linux.h |    1 +
 fs/xfs/support/debug.h       |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_linux.h~xfs-fix-randomh-include-for-non-debug-builds fs/xfs/linux-2.6/xfs_linux.h
--- a/fs/xfs/linux-2.6/xfs_linux.h~xfs-fix-randomh-include-for-non-debug-builds
+++ a/fs/xfs/linux-2.6/xfs_linux.h
@@ -75,6 +75,7 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 #include <linux/spinlock.h>
+#include <linux/random.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff -puN fs/xfs/support/debug.h~xfs-fix-randomh-include-for-non-debug-builds fs/xfs/support/debug.h
--- a/fs/xfs/support/debug.h~xfs-fix-randomh-include-for-non-debug-builds
+++ a/fs/xfs/support/debug.h
@@ -49,8 +49,6 @@ extern void assfail(char *expr, char *f,
 
 #else /* DEBUG */
 
-#include <linux/random.h>
