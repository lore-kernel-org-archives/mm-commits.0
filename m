From: akpm@linux-foundation.org
Subject: + exit-quieten-greatest-stack-depth-printk.patch added to -mm
 tree
Date: Tue, 12 Jul 2016 14:02:01 -0700
Message-ID: <57855ac9.4kwCAs18xdp0nVeR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbcGLVCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 17:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit.c: quieten greatest stack depth printk
has been added to the -mm tree.  Its filename is
     exit-quieten-greatest-stack-depth-printk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-quieten-greatest-stack-depth-printk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exit-quieten-greatest-stack-depth-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anton Blanchard <anton@samba.org>
Subject: kernel/exit.c: quieten greatest stack depth printk

Many targets enable CONFIG_DEBUG_STACK_USAGE, and while the information
is useful, it isn't worthy of pr_warn(). Reduce it to pr_info().

Link: http://lkml.kernel.org/r/1466982072-29836-1-git-send-email-anton@ozlabs.org
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~exit-quieten-greatest-stack-depth-printk kernel/exit.c
--- a/kernel/exit.c~exit-quieten-greatest-stack-depth-printk
+++ a/kernel/exit.c
@@ -639,7 +639,7 @@ static void check_stack_usage(void)
 
 	spin_lock(&low_water_lock);
 	if (free < lowest_to_date) {
-		pr_warn("%s (%d) used greatest stack depth: %lu bytes left\n",
+		pr_info("%s (%d) used greatest stack depth: %lu bytes left\n",
 			current->comm, task_pid_nr(current), free);
 		lowest_to_date = free;
 	}
_

Patches currently in -mm which might be from anton@samba.org are

exit-quieten-greatest-stack-depth-printk.patch

