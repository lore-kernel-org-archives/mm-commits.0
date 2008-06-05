From: akpm@linux-foundation.org
Subject: + pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series.patch added to -mm tree
Date: Thu, 05 Jun 2008 13:04:15 -0700
Message-ID: <200806052004.m55K4Fgg027339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbYFEUHN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 16:07:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ttuttle@google.com, mpm@selenic.com, stable@kernel.org


The patch titled
     pagemap: fix bug in add_to_pagemap, require aligned-length reads of /proc/pid/pagemap
has been added to the -mm tree.  Its filename is
     pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: fix bug in add_to_pagemap, require aligned-length reads of /proc/pid/pagemap
From: "Thomas Tuttle" <ttuttle@google.com>

Fix a bug in add_to_pagemap.  Previously, since pm->out was a char *,
put_user was only copying 1 byte of every PFN, resulting in the top 7
bytes of each PFN not being copied.  By requiring that reads be a multiple
of 8 bytes, I can make pm->out and pm->end u64*s instead of char*s, which
makes put_user work properly, and also simplifies the logic in
add_to_pagemap a bit.

Signed-off-by: Thomas Tuttle <ttuttle@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series
+++ a/fs/proc/task_mmu.c
@@ -496,7 +496,7 @@ const struct file_operations proc_clear_
 };
 
 struct pagemapread {
-	char __user *out, *end;
+	u64 __user *out, *end;
 };
 
 #define PM_ENTRY_BYTES      sizeof(u64)
@@ -519,21 +519,11 @@ struct pagemapread {
 static int add_to_pagemap(unsigned long addr, u64 pfn,
 			  struct pagemapread *pm)
 {
-	/*
-	 * Make sure there's room in the buffer for an
-	 * entire entry.  Otherwise, only copy part of
-	 * the pfn.
-	 */
-	if (pm->out + PM_ENTRY_BYTES >= pm->end) {
-		if (copy_to_user(pm->out, &pfn, pm->end - pm->out))
-			return -EFAULT;
-		pm->out = pm->end;
-		return PM_END_OF_BUFFER;
-	}
-
 	if (put_user(pfn, pm->out))
 		return -EFAULT;
-	pm->out += PM_ENTRY_BYTES;
+	pm->out++;
+	if (pm->out >= pm->end)
+		return PM_END_OF_BUFFER;
 	return 0;
 }
 
@@ -634,7 +624,7 @@ static ssize_t pagemap_read(struct file 
 
 	ret = -EINVAL;
 	/* file position must be aligned */
-	if (*ppos % PM_ENTRY_BYTES)
+	if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
 		goto out_task;
 
 	ret = 0;
@@ -664,8 +654,8 @@ static ssize_t pagemap_read(struct file 
 		goto out_pages;
 	}
 
-	pm.out = buf;
-	pm.end = buf + count;
+	pm.out = (u64*)buf;
+	pm.end = (u64*)(buf + count);
 
 	if (!ptrace_may_attach(task)) {
 		ret = -EIO;
@@ -690,9 +680,9 @@ static ssize_t pagemap_read(struct file 
 		if (ret == PM_END_OF_BUFFER)
 			ret = 0;
 		/* don't need mmap_sem for these, but this looks cleaner */
-		*ppos += pm.out - buf;
+		*ppos += (char*)pm.out - buf;
 		if (!ret)
-			ret = pm.out - buf;
+			ret = (char*)pm.out - buf;
 	}
 
 out_pages:
_

Patches currently in -mm which might be from ttuttle@google.com are

pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series.patch
pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes.patch

