From: akpm@linux-foundation.org
Subject: + m32r-remove-deprecated-irqf_disabled.patch added to -mm tree
Date: Wed, 01 Oct 2014 15:40:23 -0700
Message-ID: <542c82d7.HeVpoSbx+hpTonDf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaJAWkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: [RESEND] m32r: remove deprecated IRQF_DISABLED
has been added to the -mm tree.  Its filename is
     m32r-remove-deprecated-irqf_disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-remove-deprecated-irqf_disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-remove-deprecated-irqf_disabled.patch

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
Subject: [RESEND] m32r: remove deprecated IRQF_DISABLED

This patch removes the use of the IRQF_DISABLED flag
from arch/m32r/kernel/time.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/time.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/m32r/kernel/time.c~m32r-remove-deprecated-irqf_disabled arch/m32r/kernel/time.c
--- a/arch/m32r/kernel/time.c~m32r-remove-deprecated-irqf_disabled
+++ a/arch/m32r/kernel/time.c
@@ -134,7 +134,6 @@ static irqreturn_t timer_interrupt(int i
 
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
 	.name = "MFT2",
 };
 
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

m32r-remove-deprecated-irqf_disabled.patch
score-remove-deprecated-irqf_disabled.patch
frv-remove-deprecated-irqf_disabled.patch
maintainers-orphan-m32r.patch
linux-next.patch

