From: akpm@linux-foundation.org
Subject: [merged] lib-use-seq_open_private-instead-of-seq_open.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:25 -0700
Message-ID: <543d692d.lIDuChkI2g2uT9ar%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbaJNSTY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, jbaron@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dynamic_debug.c: use seq_open_private() instead of seq_open()
has been removed from the -mm tree.  Its filename was
     lib-use-seq_open_private-instead-of-seq_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rob Jones <rob.jones@codethink.co.uk>
Subject: lib/dynamic_debug.c: use seq_open_private() instead of seq_open()

Using seq_open_private() removes boilerplate code from ddebug_proc_open().

The resultant code is shorter and easier to follow.

This patch does not change any functionality.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Acked-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN lib/dynamic_debug.c~lib-use-seq_open_private-instead-of-seq_open lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~lib-use-seq_open_private-instead-of-seq_open
+++ a/lib/dynamic_debug.c
@@ -819,22 +819,9 @@ static const struct seq_operations ddebu
  */
 static int ddebug_proc_open(struct inode *inode, struct file *file)
 {
-	struct ddebug_iter *iter;
-	int err;
-
 	vpr_info("called\n");
-
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (iter == NULL)
-		return -ENOMEM;
