From: akpm@linux-foundation.org
Subject: + mm-use-seq_open_private-instead-of-seq_open.patch added to -mm
 tree
Date: Fri, 29 Aug 2014 12:21:20 -0700
Message-ID: <5400d2b0.quR8DgWX+/oLUvG2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaH2TVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: use seq_open_private() instead of seq_open()
has been added to the -mm tree.  Its filename is
     mm-use-seq_open_private-instead-of-seq_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-seq_open_private-instead-of-seq_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-seq_open_private-instead-of-seq_open.patch

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
Subject: mm/vmalloc.c: use seq_open_private() instead of seq_open()

Using seq_open_private() removes boilerplate code from vmalloc_open().

The resultant code is shorter and easier to follow.

However, please note that seq_open_private() call kzalloc() rather than
kmalloc() which may affect timing due to the memory initialisation
overhead.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN mm/vmalloc.c~mm-use-seq_open_private-instead-of-seq_open mm/vmalloc.c
--- a/mm/vmalloc.c~mm-use-seq_open_private-instead-of-seq_open
+++ a/mm/vmalloc.c
@@ -2646,21 +2646,11 @@ static const struct seq_operations vmall
 
 static int vmalloc_open(struct inode *inode, struct file *file)
 {
-	unsigned int *ptr = NULL;
-	int ret;
-
-	if (IS_ENABLED(CONFIG_NUMA)) {
-		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
-		if (ptr == NULL)
-			return -ENOMEM;
-	}
-	ret = seq_open(file, &vmalloc_op);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = ptr;
-	} else
-		kfree(ptr);
-	return ret;
+	if (IS_ENABLED(CONFIG_NUMA))
+		return seq_open_private(file, &vmalloc_op,
+					nr_node_ids * sizeof(unsigned int));
+	else
+		return seq_open(file, &vmalloc_op);
 }
 
 static const struct file_operations proc_vmalloc_operations = {
_

Patches currently in -mm which might be from rob.jones@codethink.co.uk are

ipc-use-__seq_open_private-instead-of-seq_open.patch
mm-use-seq_open_private-instead-of-seq_open.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
lib-use-seq_open_private-instead-of-seq_open.patch
linux-next.patch

