From: akpm@linux-foundation.org
Subject: [merged] idr-print-a-stack-dump-after-ida_remove-warning.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:29 -0700
Message-ID: <51db14bd.f3G8HJjovn3pzy9d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHTg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tiwai@suse.de, jdelvare@suse.de

Subject: [merged] idr-print-a-stack-dump-after-ida_remove-warning.patch removed from -mm tree
To: jdelvare@suse.de,tiwai@suse.de,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:29 -0700


The patch titled
     Subject: idr: print a stack dump after ida_remove warning
has been removed from the -mm tree.  Its filename was
     idr-print-a-stack-dump-after-ida_remove-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: idr: print a stack dump after ida_remove warning

We print a dump stack after idr_remove warning.  This is useful to find
the faulty piece of code.  Let's do the same for ida_remove, as it would
be equally useful there.

[akpm@linux-foundation.org: convert the open-coded printk+dump_stack into WARN()]
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN lib/idr.c~idr-print-a-stack-dump-after-ida_remove-warning lib/idr.c
--- a/lib/idr.c~idr-print-a-stack-dump-after-ida_remove-warning
+++ a/lib/idr.c
@@ -524,9 +524,7 @@ EXPORT_SYMBOL(idr_alloc_cyclic);
 
 static void idr_remove_warning(int id)
 {
-	printk(KERN_WARNING
-		"idr_remove called for id=%d which is not allocated.\n", id);
-	dump_stack();
+	WARN(1, "idr_remove called for id=%d which is not allocated.\n", id);
 }
 
 static void sub_remove(struct idr *idp, int shift, int id)
@@ -1064,8 +1062,7 @@ void ida_remove(struct ida *ida, int id)
 	return;
 
  err:
-	printk(KERN_WARNING
-	       "ida_remove called for id=%d which is not allocated.\n", id);
+	WARN(1, "ida_remove called for id=%d which is not allocated.\n", id);
 }
 EXPORT_SYMBOL(ida_remove);
 
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
linux-next.patch

