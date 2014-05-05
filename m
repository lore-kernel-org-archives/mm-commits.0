From: akpm@linux-foundation.org
Subject: + lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch
 added to -mm tree
Date: Mon, 05 May 2014 13:35:36 -0700
Message-ID: <5367f618.DJi9r8JWhhPMj84C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbaEEUfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 16:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, ddstreet@ieee.org

Subject: + lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch added to -mm tree
To: ddstreet@ieee.org,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 13:35:36 -0700


The patch titled
     Subject: lib/plist.c: replace pr_debug with printk in plist_test()
has been added to the -mm tree.  Its filename is
     lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -175,7 +175,7 @@ static int  __init plist_test(void)
 	int nr_expect = 0, i, loop;
 	unsigned int r = local_clock();
 
-	pr_debug("start plist test\n");
+	printk(KERN_DEBUG "start plist test\n");
 	plist_head_init(&test_head);
 	for (i = 0; i < ARRAY_SIZE(test_node); i++)
 		plist_node_init(test_node + i, 0);
@@ -203,7 +203,7 @@ static int  __init plist_test(void)
 		plist_test_check(nr_expect);
 	}
 
-	pr_debug("end plist test\n");
+	printk(KERN_DEBUG "end plist test\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from ddstreet@ieee.org are

lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch

