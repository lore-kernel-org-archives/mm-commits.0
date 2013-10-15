From: akpm@linux-foundation.org
Subject: + sched-remove-init_completion.patch added to -mm tree
Date: Tue, 15 Oct 2013 15:25:41 -0700
Message-ID: <525dc0e5.7KTTXRj7Bc8Nb1TW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519Ab3JOWZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Oct 2013 18:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, linus.walleij@linaro.org, wsa@the-dreams.de

Subject: + sched-remove-init_completion.patch added to -mm tree
To: wsa@the-dreams.de,linus.walleij@linaro.org,mingo@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 15 Oct 2013 15:25:41 -0700


The patch titled
     Subject: sched: remove INIT_COMPLETION
has been added to the -mm tree.  Its filename is
     sched-remove-init_completion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-remove-init_completion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-remove-init_completion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
