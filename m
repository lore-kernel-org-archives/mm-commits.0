From: akpm@linux-foundation.org
Subject: [patch 073/111] kernel/exit.c: quieten greatest stack depth
 printk
Date: Tue, 02 Aug 2016 14:05:40 -0700
Message-ID: <57a10b24.tRwnr6VIzzvZv0BE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbcHBVRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, anton@samba.org

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
