From: akpm@linux-foundation.org
Subject: + idr-print-a-stack-dump-after-ida_remove-warning.patch added to -mm tree
Date: Tue, 07 May 2013 16:34:31 -0700
Message-ID: <20130507233431.D118B31C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:35173 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab3EGXec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 19:34:32 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so113926ghr.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 16:34:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdelvare@suse.de, tiwai@suse.de, tj@kernel.org


The patch titled
     Subject: idr: print a stack dump after ida_remove warning
has been added to the -mm tree.  Its filename is
     idr-print-a-stack-dump-after-ida_remove-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: idr: print a stack dump after ida_remove warning

We print a dump stack after idr_remove warning.  This is useful to find
the faulty piece of code.  Let's do the same for ida_remove, as it would
be equally useful there.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/idr.c~idr-print-a-stack-dump-after-ida_remove-warning lib/idr.c
--- a/lib/idr.c~idr-print-a-stack-dump-after-ida_remove-warning
+++ a/lib/idr.c
@@ -1066,6 +1066,7 @@ void ida_remove(struct ida *ida, int id)
  err:
 	printk(KERN_WARNING
 	       "ida_remove called for id=%d which is not allocated.\n", id);
+	dump_stack();
 }
 EXPORT_SYMBOL(ida_remove);
 
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
linux-next.patch
idr-print-a-stack-dump-after-ida_remove-warning.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch

