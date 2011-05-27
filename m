From: akpm@linux-foundation.org
Subject: [merged] proc-stat-use-defined-macro-kmalloc_max_size.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:42 -0700
Message-ID: <201105271956.p4RJul6v017598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757206Ab1E0UIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuanhan.liu@linux.intel.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc/stat: use defined macro KMALLOC_MAX_SIZE
has been removed from the -mm tree.  Its filename was
     proc-stat-use-defined-macro-kmalloc_max_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc/stat: use defined macro KMALLOC_MAX_SIZE
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>

There is a macro for the max size kmalloc can allocate, so use it instead
of a hardcoded number.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/stat.c~proc-stat-use-defined-macro-kmalloc_max_size fs/proc/stat.c
--- a/fs/proc/stat.c~proc-stat-use-defined-macro-kmalloc_max_size
+++ a/fs/proc/stat.c
@@ -138,9 +138,9 @@ static int stat_open(struct inode *inode
 	struct seq_file *m;
 	int res;
 
-	/* don't ask for more than the kmalloc() max size, currently 128 KB */
-	if (size > 128 * 1024)
-		size = 128 * 1024;
+	/* don't ask for more than the kmalloc() max size */
+	if (size > KMALLOC_MAX_SIZE)
+		size = KMALLOC_MAX_SIZE;
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

origin.patch

