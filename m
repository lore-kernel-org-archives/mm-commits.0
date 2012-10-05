From: akpm@linux-foundation.org
Subject: [merged] plist-make-plist-test-announcements-kern_debug.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:56 -0700
Message-ID: <20121005201557.237C35C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:58361 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2JEUP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:59 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so141020lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borislav.petkov@amd.com, laijs@cn.fujitsu.com, paul.gortmaker@windriver.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/plist.c: make plist test announcements KERN_DEBUG
has been removed from the -mm tree.  Its filename was
     plist-make-plist-test-announcements-kern_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <borislav.petkov@amd.com>
Subject: lib/plist.c: make plist test announcements KERN_DEBUG

They show up in dmesg

[    4.041094] start plist test
[    4.045804] end plist test

without a lot of meaning so hide them behind debug loglevel.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/plist.c~plist-make-plist-test-announcements-kern_debug lib/plist.c
--- a/lib/plist.c~plist-make-plist-test-announcements-kern_debug
+++ a/lib/plist.c
@@ -175,7 +175,7 @@ static int  __init plist_test(void)
 	int nr_expect = 0, i, loop;
 	unsigned int r = local_clock();
 
-	printk(KERN_INFO "start plist test\n");
+	pr_debug("start plist test\n");
 	plist_head_init(&test_head);
 	for (i = 0; i < ARRAY_SIZE(test_node); i++)
 		plist_node_init(test_node + i, 0);
@@ -203,7 +203,7 @@ static int  __init plist_test(void)
 		plist_test_check(nr_expect);
 	}
 
-	printk(KERN_INFO "end plist test\n");
+	pr_debug("end plist test\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from borislav.petkov@amd.com are

origin.patch
linux-next.patch

