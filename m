From: akpm@linux-foundation.org
Subject: + lib-use-seq_open_private-instead-of-seq_open.patch added to -mm tree
Date: Fri, 29 Aug 2014 12:21:22 -0700
Message-ID: <5400d2b2.UKvkfZR0Wc/PRJOM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaH2TVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dynamic_debug.c: use seq_open_private() instead of seq_open()
has been added to the -mm tree.  Its filename is
     lib-use-seq_open_private-instead-of-seq_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-use-seq_open_private-instead-of-seq_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-use-seq_open_private-instead-of-seq_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Jones <rob.jones@codethink.co.uk>
Subject: lib/dynamic_debug.c: use seq_open_private() instead of seq_open()

Using seq_open_private() removes boilerplate code from ddebug_proc_open().

The resultant code is shorter and easier to follow.

This patch does not change any functionality.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN lib/dynamic_debug.c~lib-use-seq_open_private-instead-of-seq_open lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~lib-use-seq_open_private-instead-of-seq_open
+++ a/lib/dynamic_debug.c
@@ -829,22 +829,9 @@ static const struct seq_operations ddebu
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
