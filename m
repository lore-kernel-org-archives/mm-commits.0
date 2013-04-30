From: akpm@linux-foundation.org
Subject: + pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch added to -mm tree
Date: Tue, 30 Apr 2013 12:20:20 -0700
Message-ID: <20130430192020.D579731C37D@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:56910 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab3D3TUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:20:22 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so90049yen.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:20:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@parallels.com, glommer@parallels.com, kosaki.motohiro@gmail.com, mpm@selenic.com, mtosatti@redhat.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4
has been added to the -mm tree.  Its filename is
     pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
