From: akpm@linux-foundation.org
Subject: + mm-use-__seq_open_private-instead-of-seq_open.patch added to
 -mm tree
Date: Fri, 29 Aug 2014 12:21:21 -0700
Message-ID: <5400d2b1.5AStKD9nKe1ohKBe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaH2TVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: use __seq_open_private() instead of seq_open()
has been added to the -mm tree.  Its filename is
     mm-use-__seq_open_private-instead-of-seq_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-__seq_open_private-instead-of-seq_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-__seq_open_private-instead-of-seq_open.patch

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
Subject: mm/slab.c: use __seq_open_private() instead of seq_open()

Using __seq_open_private() removes boilerplate code from slabstats_open()

The resultant code is shorter and easier to follow.

This patch does not change any functionality.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN mm/slab.c~mm-use-__seq_open_private-instead-of-seq_open mm/slab.c
--- a/mm/slab.c~mm-use-__seq_open_private-instead-of-seq_open
+++ a/mm/slab.c
@@ -4248,19 +4248,15 @@ static const struct seq_operations slabs
 
 static int slabstats_open(struct inode *inode, struct file *file)
 {
-	unsigned long *n = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	int ret = -ENOMEM;
-	if (n) {
-		ret = seq_open(file, &slabstats_op);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			*n = PAGE_SIZE / (2 * sizeof(unsigned long));
-			m->private = n;
-			n = NULL;
-		}
-		kfree(n);
-	}
-	return ret;
+	unsigned long *n;
+
+	n = __seq_open_private(file, &slabstats_op, PAGE_SIZE);
+	if (!n)
+		return -ENOMEM;
+
+	*n = PAGE_SIZE / (2 * sizeof(unsigned long));
+
+	return 0;
 }
 
 static const struct file_operations proc_slabstats_operations = {
_

Patches currently in -mm which might be from rob.jones@codethink.co.uk are

ipc-use-__seq_open_private-instead-of-seq_open.patch
mm-use-seq_open_private-instead-of-seq_open.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
lib-use-seq_open_private-instead-of-seq_open.patch
linux-next.patch

