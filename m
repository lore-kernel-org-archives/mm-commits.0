From: akpm@linux-foundation.org
Subject: [merged] procfs-use-kbasename.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:07 -0800
Message-ID: <20121218200607.F1E17200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62877 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:10 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so63426wey.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, yongjun_wei@trendmicro.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: use kbasename()
has been removed from the -mm tree.  Its filename was
     procfs-use-kbasename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: procfs: use kbasename()

[yongjun_wei@trendmicro.com.cn: remove duplicated include]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_devtree.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/proc/proc_devtree.c~procfs-use-kbasename fs/proc/proc_devtree.c
--- a/fs/proc/proc_devtree.c~procfs-use-kbasename
+++ a/fs/proc/proc_devtree.c
@@ -195,11 +195,7 @@ void proc_device_tree_add_node(struct de
 	set_node_proc_entry(np, de);
 	for (child = NULL; (child = of_get_next_child(np, child));) {
 		/* Use everything after the last slash, or the full name */
-		p = strrchr(child->full_name, '/');
-		if (!p)
-			p = child->full_name;
-		else
-			++p;
+		p = kbasename(child->full_name);
 
 		if (duplicate_name(de, p))
 			p = fixup_name(np, de, p);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

