From: akpm@linux-foundation.org
Subject: [merged]
 lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 13:05:09 -0700
Message-ID: <5390cd75.biWioVObr3hQIFWx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaFEUFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, ddstreet@ieee.org

Subject: [merged] lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch removed from -mm tree
To: ddstreet@ieee.org,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:09 -0700


The patch titled
     Subject: lib/plist.c: replace pr_debug with printk in plist_test()
has been removed from the -mm tree.  Its filename was
     lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: lib/plist.c: replace pr_debug with printk in plist_test()

Replace pr_debug() in lib/plist.c test function plist_test() with
printk(KERN_DEBUG ...).

Without DEBUG defined, pr_debug() is complied out, but the entire
plist_test() function is already inside CONFIG_DEBUG_PI_LIST, so printk
should just be used directly.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/plist.c~lib-plistc-replace-pr_debug-with-printk-in-plist_test lib/plist.c
--- a/lib/plist.c~lib-plistc-replace-pr_debug-with-printk-in-plist_test
+++ a/lib/plist.c
@@ -223,7 +223,7 @@ static int  __init plist_test(void)
 	int nr_expect = 0, i, loop;
 	unsigned int r = local_clock();
 
-	pr_debug("start plist test\n");
+	printk(KERN_DEBUG "start plist test\n");
 	plist_head_init(&test_head);
 	for (i = 0; i < ARRAY_SIZE(test_node); i++)
 		plist_node_init(test_node + i, 0);
@@ -255,7 +255,7 @@ static int  __init plist_test(void)
 		plist_test_check(nr_expect);
 	}
 
-	pr_debug("end plist test\n");
+	printk(KERN_DEBUG "end plist test\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from ddstreet@ieee.org are

origin.patch
linux-next.patch

