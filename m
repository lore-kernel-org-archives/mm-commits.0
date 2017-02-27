From: akpm@linux-foundation.org
Subject: [merged] notifier-simplify-expression.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:28:48 -0800
Message-ID: <58b48c00.JXD149OphSUp9XWO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdB0Ukd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/notifier.c: simplify expression
has been removed from the -mm tree.  Its filename was
     notifier-simplify-expression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: kernel/notifier.c: simplify expression

NOTIFY_STOP_MASK (0x8000) has only one bit set and there is no need to
compare output of "ret & NOTIFY_STOP_MASK" to NOTIFY_STOP_MASK.  We just
need to make sure the output is non-zero, that's it.

Link: http://lkml.kernel.org/r/88ee58264a2bfab1c97ffc8ac753e25f55f57c10.1483593065.git.viresh.kumar@linaro.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/notifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/notifier.c~notifier-simplify-expression kernel/notifier.c
--- a/kernel/notifier.c~notifier-simplify-expression
+++ a/kernel/notifier.c
@@ -95,7 +95,7 @@ static int notifier_call_chain(struct no
 		if (nr_calls)
 			(*nr_calls)++;
 
-		if ((ret & NOTIFY_STOP_MASK) == NOTIFY_STOP_MASK)
+		if (ret & NOTIFY_STOP_MASK)
 			break;
 		nb = next_nb;
 		nr_to_call--;
_

Patches currently in -mm which might be from viresh.kumar@linaro.org are


