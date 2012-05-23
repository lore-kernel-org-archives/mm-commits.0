From: akpm@linux-foundation.org
Subject: [merged] unicore32-use-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:30 -0700
Message-ID: <20120523195130.81760A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:56830 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933873Ab2EWTvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2012 15:51:32 -0400
Received: by lagr15 with SMTP id r15so441065lag.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, gxt@mprc.pku.edu.cn, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: unicore32: use block_sigmask()
has been removed from the -mm tree.  Its filename was
     unicore32-use-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: unicore32: use block_sigmask()

Use the new helper function introduced in commit 5e6292c0f28f ("signal:
add block_sigmask() for adding sigmask to current->blocked") which
centralises the code for updating current->blocked after successfully
delivering a signal and reduces the amount of duplicate code across
architectures.  In the past some architectures got this code wrong, so
using this helper function should stop that from happening again.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/signal.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/unicore32/kernel/signal.c~unicore32-use-block_sigmask arch/unicore32/kernel/signal.c
--- a/arch/unicore32/kernel/signal.c~unicore32-use-block_sigmask
+++ a/arch/unicore32/kernel/signal.c
@@ -370,10 +370,7 @@ static int handle_signal(unsigned long s
 	/*
 	 * Block the signal if we were successful.
 	 */
-	sigorsets(&blocked, &tsk->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	block_sigmask(ka, sig);
 
 	return 0;
 }
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch

