From: akpm@linux-foundation.org
Subject: [merged] init-mainc-fix-sparse-warnings-context-imbalance.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:53 -0700
Message-ID: <200904011839.n31Idrbt008827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764808AbZDATMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     init/main.c: fix sparse warnings: context imbalance
has been removed from the -mm tree.  Its filename was
     init-mainc-fix-sparse-warnings-context-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/main.c: fix sparse warnings: context imbalance
From: Hannes Eder <hannes@hanneseder.net>

Impact: Attribute function 'init_post' with __releases(...).

Fix these sparse warnings:
  init/main.c:805:21: warning: context imbalance in 'init_post' - unexpected unlock
  init/main.c:899:9: warning: context imbalance in 'kernel_init' - wrong count at exit

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/main.c~init-mainc-fix-sparse-warnings-context-imbalance init/main.c
--- a/init/main.c~init-mainc-fix-sparse-warnings-context-imbalance
+++ a/init/main.c
@@ -793,6 +793,7 @@ static void run_init_process(char *init_
  * makes it inline to init() and it becomes part of init.text section
  */
 static noinline int init_post(void)
+	__releases(kernel_lock)
 {
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
_

Patches currently in -mm which might be from hannes@hanneseder.net are

origin.patch
linux-next.patch

