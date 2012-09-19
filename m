From: akpm@linux-foundation.org
Subject: + plist-make-plist-test-announcements-kern_debug.patch added to -mm tree
Date: Wed, 19 Sep 2012 13:13:55 -0700
Message-ID: <20120919201356.1C30220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:53633 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2ISUN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 16:13:58 -0400
Received: by wgbdt11 with SMTP id dt11so46394wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 13:13:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borislav.petkov@amd.com, laijs@cn.fujitsu.com, paul.gortmaker@windriver.com, rostedt@goodmis.org


The patch titled
     Subject: lib/plist.c: make plist test announcements KERN_DEBUG
has been added to the -mm tree.  Its filename is
     plist-make-plist-test-announcements-kern_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
plist-make-plist-test-announcements-kern_debug.patch

