From: akpm@linux-foundation.org
Subject: [merged] kernel-exitc-fix-shadows-sparse-warning.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:23 -0800
Message-ID: <201003091906.o29J6Nb4031252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771Ab0CITHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:07:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tfransosi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel/exit.c: fix shadows sparse warning
has been removed from the -mm tree.  Its filename was
     kernel-exitc-fix-shadows-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/exit.c: fix shadows sparse warning
From: Thiago Farina <tfransosi@gmail.com>

kernel/exit.c:1183:26: warning: symbol 'status' shadows an earlier one
kernel/exit.c:1173:21: originally declared here

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~kernel-exitc-fix-shadows-sparse-warning kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-fix-shadows-sparse-warning
+++ a/kernel/exit.c
@@ -1189,7 +1189,7 @@ static int wait_task_zombie(struct wait_
 
 	if (unlikely(wo->wo_flags & WNOWAIT)) {
 		int exit_code = p->exit_code;
-		int why, status;
+		int why;
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from tfransosi@gmail.com are

linux-next.patch

