From: akpm@linux-foundation.org
Subject: [merged] exit-quieten-greatest-stack-depth-printk.patch removed
 from -mm tree
Date: Wed, 03 Aug 2016 11:13:27 -0700
Message-ID: <57a23447.1qwKXb9FiK4zsgDG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbcHCSNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit.c: quieten greatest stack depth printk
has been removed from the -mm tree.  Its filename was
     exit-quieten-greatest-stack-depth-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -715,7 +715,7 @@ static void check_stack_usage(void)
 
 	spin_lock(&low_water_lock);
 	if (free < lowest_to_date) {
-		pr_warn("%s (%d) used greatest stack depth: %lu bytes left\n",
+		pr_info("%s (%d) used greatest stack depth: %lu bytes left\n",
 			current->comm, task_pid_nr(current), free);
 		lowest_to_date = free;
 	}
_

Patches currently in -mm which might be from anton@samba.org are


