From: akpm@linux-foundation.org
Subject: + h8300-remove-deprecated-irqf_disabled.patch added to -mm tree
Date: Thu, 19 Sep 2013 15:12:43 -0700
Message-ID: <523b76db.+GMBa8l1sgmS1X+e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISWMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, michael.opdenacker@free-electrons.com

Subject: + h8300-remove-deprecated-irqf_disabled.patch added to -mm tree
To: michael.opdenacker@free-electrons.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:12:43 -0700


The patch titled
     Subject: arch/h8300: remove deprecated IRQF_DISABLED
has been added to the -mm tree.  Its filename is
     h8300-remove-deprecated-irqf_disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/h8300-remove-deprecated-irqf_disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/h8300-remove-deprecated-irqf_disabled.patch

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
Subject: arch/h8300: remove deprecated IRQF_DISABLED

Remove the IRQF_DISABLED flag from h8300 architecture code.  It's a NOOP
since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/timer/itu.c     |    2 +-
 arch/h8300/kernel/timer/timer16.c |    2 +-
 arch/h8300/kernel/timer/timer8.c  |    2 +-
 arch/h8300/kernel/timer/tpu.c     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/h8300/kernel/timer/itu.c~h8300-remove-deprecated-irqf_disabled arch/h8300/kernel/timer/itu.c
--- a/arch/h8300/kernel/timer/itu.c~h8300-remove-deprecated-irqf_disabled
+++ a/arch/h8300/kernel/timer/itu.c
@@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int i
 static struct irqaction itu_irq = {
 	.name		= "itu",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initconst divide_rate[] = {1, 2, 4, 8};
diff -puN arch/h8300/kernel/timer/timer16.c~h8300-remove-deprecated-irqf_disabled arch/h8300/kernel/timer/timer16.c
--- a/arch/h8300/kernel/timer/timer16.c~h8300-remove-deprecated-irqf_disabled
+++ a/arch/h8300/kernel/timer/timer16.c
@@ -54,7 +54,7 @@ static irqreturn_t timer_interrupt(int i
 static struct irqaction timer16_irq = {
 	.name		= "timer-16",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initconst divide_rate[] = {1, 2, 4, 8};
diff -puN arch/h8300/kernel/timer/timer8.c~h8300-remove-deprecated-irqf_disabled arch/h8300/kernel/timer/timer8.c
--- a/arch/h8300/kernel/timer/timer8.c~h8300-remove-deprecated-irqf_disabled
+++ a/arch/h8300/kernel/timer/timer8.c
@@ -74,7 +74,7 @@ static irqreturn_t timer_interrupt(int i
 static struct irqaction timer8_irq = {
 	.name		= "timer-8",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initconst divide_rate[] = {8, 64, 8192};
diff -puN arch/h8300/kernel/timer/tpu.c~h8300-remove-deprecated-irqf_disabled arch/h8300/kernel/timer/tpu.c
--- a/arch/h8300/kernel/timer/tpu.c~h8300-remove-deprecated-irqf_disabled
+++ a/arch/h8300/kernel/timer/tpu.c
@@ -63,7 +63,7 @@ static irqreturn_t timer_interrupt(int i
 static struct irqaction tpu_irq = {
 	.name		= "tpu",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initconst divide_rate[] = {
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

origin.patch
h8300-remove-deprecated-irqf_disabled.patch
gdrom-remove-deprecated-irqf_disabled.patch
cramfs-mark-as-obsolete.patch
linux-next.patch

