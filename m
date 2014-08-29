From: akpm@linux-foundation.org
Subject: + ipc-use-__seq_open_private-instead-of-seq_open.patch added to
 -mm tree
Date: Fri, 29 Aug 2014 12:21:19 -0700
Message-ID: <5400d2af.iJjq3wGavPgs1K2f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaH2TVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util.c: use __seq_open_private() instead of seq_open()
has been added to the -mm tree.  Its filename is
     ipc-use-__seq_open_private-instead-of-seq_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-use-__seq_open_private-instead-of-seq_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-use-__seq_open_private-instead-of-seq_open.patch

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
Subject: ipc/util.c: use __seq_open_private() instead of seq_open()

Using __seq_open_private() removes boilerplate code from
sysvipc_proc_open().

The resultant code is shorter and easier to follow.

However, please note that __seq_open_private() call kzalloc() rather than
kmalloc() which may affect timing due to the memory initialisation
overhead.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff -puN ipc/util.c~ipc-use-__seq_open_private-instead-of-seq_open ipc/util.c
--- a/ipc/util.c~ipc-use-__seq_open_private-instead-of-seq_open
+++ a/ipc/util.c
@@ -892,28 +892,16 @@ static const struct seq_operations sysvi
 
 static int sysvipc_proc_open(struct inode *inode, struct file *file)
 {
-	int ret;
-	struct seq_file *seq;
 	struct ipc_proc_iter *iter;
 
-	ret = -ENOMEM;
-	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	iter = __seq_open_private(file, &sysvipc_proc_seqops, sizeof(*iter));
 	if (!iter)
-		goto out;
-
-	ret = seq_open(file, &sysvipc_proc_seqops);
-	if (ret) {
-		kfree(iter);
-		goto out;
-	}
