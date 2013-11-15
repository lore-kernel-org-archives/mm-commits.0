From: akpm@linux-foundation.org
Subject: [merged] sched-remove-init_completion.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:09 -0800
Message-ID: <52867f65.Mbrro56CyFzqT6pL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3KOUJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, linus.walleij@linaro.org, wsa@the-dreams.de

Subject: [merged] sched-remove-init_completion.patch removed from -mm tree
To: wsa@the-dreams.de,linus.walleij@linaro.org,mingo@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:09 -0800


The patch titled
     Subject: sched: remove INIT_COMPLETION
has been removed from the -mm tree.  Its filename was
     sched-remove-init_completion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wolfram Sang <wsa@the-dreams.de>
Subject: sched: remove INIT_COMPLETION

All users are converted over to reinit_completion(). Remove the old
macro now.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/completion.h |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN include/linux/completion.h~sched-remove-init_completion include/linux/completion.h
--- a/include/linux/completion.h~sched-remove-init_completion
+++ a/include/linux/completion.h
@@ -106,14 +106,4 @@ extern bool completion_done(struct compl
 extern void complete(struct completion *);
 extern void complete_all(struct completion *);
 
-/**
- * INIT_COMPLETION - reinitialize a completion structure
- * @x:  completion structure to be reinitialized
- *
- * This macro should be used to reinitialize a completion structure so it can
- * be reused. This is especially important after complete_all() is used.
- */
-#define INIT_COMPLETION(x)	((x).done = 0)
-
