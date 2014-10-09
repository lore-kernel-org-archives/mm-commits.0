From: akpm@linux-foundation.org
Subject: [merged] score-remove-deprecated-irqf_disabled.patch removed from -mm tree
Date: Thu, 09 Oct 2014 11:21:54 -0700
Message-ID: <5436d242.HGrEI5UJKMIbaR/8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaJISVy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 14:21:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, lennox.wu@gmail.com, liqin.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: remove deprecated IRQF_DISABLED
has been removed from the -mm tree.  Its filename was
     score-remove-deprecated-irqf_disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
m32r-remove-deprecated-irqf_disabled.patch
frv-remove-deprecated-irqf_disabled.patch
maintainers-orphan-m32r.patch
maintainers-remove-chirag-kantharia-invalid-e-mail.patch
linux-next.patch

