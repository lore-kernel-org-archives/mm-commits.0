From: akpm@linux-foundation.org
Subject: + score-remove-deprecated-irqf_disabled.patch added to -mm tree
Date: Wed, 01 Oct 2014 13:07:47 -0700
Message-ID: <542c5f13.06Z2TRsU35YJej3t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaJAUHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 16:07:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, lennox.wu@gmail.com, liqin.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: remove deprecated IRQF_DISABLED
has been added to the -mm tree.  Its filename is
     score-remove-deprecated-irqf_disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/score-remove-deprecated-irqf_disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/score-remove-deprecated-irqf_disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: score: remove deprecated IRQF_DISABLED

Remove the use of the IRQF_DISABLED flag from arch/score/kernel/time.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/score/kernel/time.c~score-remove-deprecated-irqf_disabled arch/score/kernel/time.c
--- a/arch/score/kernel/time.c~score-remove-deprecated-irqf_disabled
+++ a/arch/score/kernel/time.c
@@ -41,7 +41,7 @@ static irqreturn_t timer_interrupt(int i
 
 static struct irqaction timer_irq = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.flags = IRQF_TIMER,
 	.name = "timer",
 };
 
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

score-remove-deprecated-irqf_disabled.patch
frv-remove-deprecated-irqf_disabled.patch
linux-next.patch

