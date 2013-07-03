From: akpm@linux-foundation.org
Subject: [folded-merged]
 pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch removed
 from -mm tree
Date: Wed, 03 Jul 2013 14:23:59 -0700
Message-ID: <51d4966f.LsRkYgKyEtaph5cu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240Ab3GCVYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com, mpm@selenic.com, kosaki.motohiro@gmail.com, glommer@parallels.com, xemul@parallels.com

Subject: [folded-merged] pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch removed from -mm tree
To: xemul@parallels.com,glommer@parallels.com,kosaki.motohiro@gmail.com,mpm@selenic.com,mtosatti@redhat.com,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:23:59 -0700


The patch titled
     Subject: pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4
has been removed from the -mm tree.  Its filename was
     pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch

This patch was dropped because it was folded into pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4
+++ a/fs/proc/task_mmu.c
@@ -824,7 +824,7 @@ struct pagemapread {
 #define __PM_PSHIFT(x)      (((u64) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
 #define PM_PFRAME_MASK      ((1LL << PM_PSHIFT_OFFSET) - 1)
 #define PM_PFRAME(x)        ((x) & PM_PFRAME_MASK)
-/* in pagemap2 pshift bits are occupied with more status bits */
+/* in "new" pagemap pshift bits are occupied with more status bits */
 #define PM_STATUS2(v2, x)   (__PM_PSHIFT(v2 ? x : PAGE_SHIFT))
 
 #define PM_PRESENT          PM_STATUS(4LL)
@@ -1028,8 +1028,8 @@ static int pagemap_hugetlb_range(pte_t *
  * determine which areas of memory are actually mapped and llseek to
  * skip over unmapped regions.
  */
-static ssize_t do_pagemap_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *ppos, bool v2)
+static ssize_t pagemap_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
 {
 	struct task_struct *task = get_proc_task(file_inode(file));
 	struct mm_struct *mm;
@@ -1054,7 +1054,7 @@ static ssize_t do_pagemap_read(struct fi
 	if (!count)
 		goto out_task;
 
-	pm.v2 = v2;
+	pm.v2 = false;
 	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
 	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
 	ret = -ENOMEM;
@@ -1127,12 +1127,6 @@ out:
 	return ret;
 }
 
-static ssize_t pagemap_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *ppos)
-{
-	return do_pagemap_read(file, buf, count, ppos, false);
-}
