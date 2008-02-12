From: akpm@linux-foundation.org
Subject: + softlockup-debug2.patch added to -mm tree
Date: Tue, 12 Feb 2008 12:18:09 -0800
Message-ID: <200802122027.m1CKR8GR020620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41182 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbYBLU16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, mingo@elte.hu


The patch titled
     softlockup debug
has been added to the -mm tree.  Its filename is
     softlockup-debug2.patch

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
Subject: softlockup debug
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/softlockup.c~softlockup-debug2 kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-debug2
+++ a/kernel/softlockup.c
@@ -236,6 +236,7 @@ static int watchdog(void *__bind_cpu)
 			check_hung_uninterruptible_tasks(this_cpu);
 
 	}
+	printk(KERN_ERR "watchdog(cpu: %d) -- exit\n", this_cpu);
 
 	return 0;
 }
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

origin.patch
softlockup-debug.patch
softlockup-debug2.patch
