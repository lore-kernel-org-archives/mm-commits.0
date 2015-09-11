From: akpm@linux-foundation.org
Subject: [merged] proc-add-kpagecgroup-file.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:11:16 -0700
Message-ID: <55f31944.gjz5hG8+gHxPx+1A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbbIKSLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add kpagecgroup file
has been removed from the -mm tree.  Its filename was
     proc-add-kpagecgroup-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: proc: add kpagecgroup file

/proc/kpagecgroup contains a 64-bit inode number of the memory cgroup each
page is charged to, indexed by PFN.  Having this information is useful for
estimating a cgroup working set size.

The file is present if CONFIG_PROC_PAGE_MONITOR && CONFIG_MEMCG.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    6 +++
 fs/proc/page.c               |   53 +++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)

diff -puN Documentation/vm/pagemap.txt~proc-add-kpagecgroup-file Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~proc-add-kpagecgroup-file
+++ a/Documentation/vm/pagemap.txt
@@ -5,7 +5,7 @@ pagemap is a new (as of 2.6.25) set of i
 userspace programs to examine the page tables and related information by
 reading files in /proc.
 
-There are three components to pagemap:
+There are four components to pagemap:
 
  * /proc/pid/pagemap.  This file lets a userspace process find out which
    physical frame each virtual page is mapped to.  It contains one 64-bit
@@ -71,6 +71,10 @@ There are three components to pagemap:
     23. BALLOON
     24. ZERO_PAGE
 
+ * /proc/kpagecgroup.  This file contains a 64-bit inode number of the
+   memory cgroup each page is charged to, indexed by PFN. Only available when
+   CONFIG_MEMCG is set.
+
 Short descriptions to the page flags:
 
  0. LOCKED
diff -puN fs/proc/page.c~proc-add-kpagecgroup-file fs/proc/page.c
--- a/fs/proc/page.c~proc-add-kpagecgroup-file
+++ a/fs/proc/page.c
@@ -9,6 +9,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
+#include <linux/memcontrol.h>
 #include <linux/kernel-page-flags.h>
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -225,10 +226,62 @@ static const struct file_operations proc
 	.read = kpageflags_read,
 };
 
+#ifdef CONFIG_MEMCG
+static ssize_t kpagecgroup_read(struct file *file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	u64 __user *out = (u64 __user *)buf;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	u64 ino;
+
+	pfn = src / KPMSIZE;
+	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EINVAL;
+
+	while (count > 0) {
+		if (pfn_valid(pfn))
+			ppage = pfn_to_page(pfn);
+		else
+			ppage = NULL;
+
+		if (ppage)
+			ino = page_cgroup_ino(ppage);
+		else
+			ino = 0;
+
+		if (put_user(ino, out)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		pfn++;
+		out++;
+		count -= KPMSIZE;
+	}
+
+	*ppos += (char __user *)out - buf;
+	if (!ret)
+		ret = (char __user *)out - buf;
+	return ret;
+}
+
+static const struct file_operations proc_kpagecgroup_operations = {
+	.llseek = mem_lseek,
+	.read = kpagecgroup_read,
+};
+#endif /* CONFIG_MEMCG */
+
 static int __init proc_page_init(void)
 {
 	proc_create("kpagecount", S_IRUSR, NULL, &proc_kpagecount_operations);
 	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
+#ifdef CONFIG_MEMCG
+	proc_create("kpagecgroup", S_IRUSR, NULL, &proc_kpagecgroup_operations);
+#endif
 	return 0;
 }
 fs_initcall(proc_page_init);
_

Patches currently in -mm which might be from vdavydov@parallels.com are


