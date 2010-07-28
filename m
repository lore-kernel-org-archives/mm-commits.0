From: akpm@linux-foundation.org
Subject: + mm-vmallocc-check-kmalloc-return-value.patch added to -mm tree
Date: Wed, 28 Jul 2010 16:14:38 -0700
Message-ID: <201007282314.o6SNEcDl008143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774Ab0G1XOu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 19:14:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, penberg@cs.helsinki.fi


The patch titled
     mm/vmalloc.c: check kmalloc() return value
has been added to the -mm tree.  Its filename is
     mm-vmallocc-check-kmalloc-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/vmalloc.c: check kmalloc() return value
From: Kulikov Vasiliy <segooon@gmail.com>

kmalloc() may fail, if so return -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmallocc-check-kmalloc-return-value mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-check-kmalloc-return-value
+++ a/mm/vmalloc.c
@@ -2494,8 +2494,11 @@ static int vmalloc_open(struct inode *in
 	unsigned int *ptr = NULL;
 	int ret;
 
-	if (NUMA_BUILD)
+	if (NUMA_BUILD) {
 		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
+		if (ptr == NULL)
+			return -ENOMEM;
+	}
 	ret = seq_open(file, &vmalloc_op);
 	if (!ret) {
 		struct seq_file *m = file->private_data;
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
mm-vmallocc-check-kmalloc-return-value.patch
i2o-fix-overflow-of-copy_to_user.patch
i2o-check-return-code-from-put_user.patch
edac-i5000-improve-handling-of-pci_enable_device-return-value.patch
edac-i5400-improve-handling-of-pci_enable_device-return-value.patch

