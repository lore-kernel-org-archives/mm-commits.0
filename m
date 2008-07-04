From: akpm@linux-foundation.org
Subject: - block-request_module-use-format-string.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:27:00 -0700
Message-ID: <200807040727.m647R0K0019320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755527AbYGDH2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: max@stro.at, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: request_module(): use format string
has been removed from the -mm tree.  Its filename was
     block-request_module-use-format-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: request_module(): use format string
From: maximilian attems <max@stro.at>

Avoid bad things happening if the module has a printk control string in
its name.

Signed-off-by: maximilian attems <max@stro.at>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/elevator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/elevator.c~block-request_module-use-format-string block/elevator.c
--- a/block/elevator.c~block-request_module-use-format-string
+++ a/block/elevator.c
@@ -150,7 +150,7 @@ static struct elevator_type *elevator_ge
 		else
 			sprintf(elv, "%s-iosched", name);
 
-		request_module(elv);
+		request_module("%s", elv);
 		spin_lock(&elv_list_lock);
 		e = elevator_find(name);
 	}
_

Patches currently in -mm which might be from max@stro.at are

origin.patch
hdaps-add-support-for-various-newer-lenovo-thinkpads.patch
alpha-linux-kernel-fails-with-inconsistent-kallsyms-data.patch
linux-next.patch

