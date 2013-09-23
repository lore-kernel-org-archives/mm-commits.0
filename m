From: akpm@linux-foundation.org
Subject: [merged] h8300-remove-deprecated-irqf_disabled.patch removed from -mm tree
Date: Mon, 23 Sep 2013 11:25:13 -0700
Message-ID: <52408789.ZnC+IVuz0619sbBk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3IWSZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 14:25:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, michael.opdenacker@free-electrons.com

Subject: [merged] h8300-remove-deprecated-irqf_disabled.patch removed from -mm tree
To: michael.opdenacker@free-electrons.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 11:25:13 -0700


The patch titled
     Subject: arch/h8300: remove deprecated IRQF_DISABLED
has been removed from the -mm tree.  Its filename was
     h8300-remove-deprecated-irqf_disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch
cramfs-mark-as-obsolete.patch

