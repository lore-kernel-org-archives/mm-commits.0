From: akpm@linux-foundation.org
Subject: [folded-merged]
 hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
 removed from -mm tree
Date: Tue, 11 Oct 2016 13:40:08 -0700
Message-ID: <57fd4e28.CAWuuXveD4zYgS/H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37625 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754851AbcJKUkW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jsiddle@redhat.com, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix
has been removed from the -mm tree.  Its filename was
     hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch

This patch was dropped because it was folded into hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix

fix off-by-one

Cc: John Siddle <jsiddle@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/hung_task.c~hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix kernel/hung_task.c
--- a/kernel/hung_task.c~hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix
+++ a/kernel/hung_task.c
@@ -101,14 +101,12 @@ static void check_hung_task(struct task_
 	if (!sysctl_hung_task_warnings && !sysctl_hung_task_panic)
 		return;
 
-	if (sysctl_hung_task_warnings > 0)
-		sysctl_hung_task_warnings--;
