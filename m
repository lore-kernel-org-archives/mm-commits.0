From: akpm@linux-foundation.org
Subject: + frv-remove-deprecated-irqf_disabled.patch added to -mm tree
Date: Wed, 01 Oct 2014 13:07:04 -0700
Message-ID: <542c5ee8.QXaPH9z7hvS6yE/r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaJAUHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 16:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: remove deprecated IRQF_DISABLED
has been added to the -mm tree.  Its filename is
     frv-remove-deprecated-irqf_disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-remove-deprecated-irqf_disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-remove-deprecated-irqf_disabled.patch

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
Subject: frv: remove deprecated IRQF_DISABLED

Remove the IRQF_DISABLED flag from FRV architecture code.  It's a NOOP
since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/irq-mb93091.c |    8 ++++----
 arch/frv/kernel/irq-mb93093.c |    1 -
 arch/frv/kernel/irq-mb93493.c |    4 ++--
 arch/frv/kernel/time.c        |    1 -
 4 files changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/frv/kernel/irq-mb93091.c~frv-remove-deprecated-irqf_disabled arch/frv/kernel/irq-mb93091.c
--- a/arch/frv/kernel/irq-mb93091.c~frv-remove-deprecated-irqf_disabled
+++ a/arch/frv/kernel/irq-mb93091.c
@@ -107,25 +107,25 @@ static irqreturn_t fpga_interrupt(int ir
 static struct irqaction fpga_irq[4]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0028UL,
 	},
 	[1] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.1",
 		.dev_id		= (void *) 0x0050UL,
 	},
 	[2] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.2",
 		.dev_id		= (void *) 0x1c00UL,
 	},
 	[3] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.3",
 		.dev_id		= (void *) 0x6386UL,
 	}
diff -puN arch/frv/kernel/irq-mb93093.c~frv-remove-deprecated-irqf_disabled arch/frv/kernel/irq-mb93093.c
--- a/arch/frv/kernel/irq-mb93093.c~frv-remove-deprecated-irqf_disabled
+++ a/arch/frv/kernel/irq-mb93093.c
@@ -105,7 +105,6 @@ static irqreturn_t fpga_interrupt(int ir
 static struct irqaction fpga_irq[1]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0700UL,
 	}
diff -puN arch/frv/kernel/irq-mb93493.c~frv-remove-deprecated-irqf_disabled arch/frv/kernel/irq-mb93493.c
--- a/arch/frv/kernel/irq-mb93493.c~frv-remove-deprecated-irqf_disabled
+++ a/arch/frv/kernel/irq-mb93493.c
@@ -118,13 +118,13 @@ static irqreturn_t mb93493_interrupt(int
 static struct irqaction mb93493_irq[2]  = {
 	[0] = {
 		.handler	= mb93493_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "mb93493.0",
 		.dev_id		= (void *) __addr_MB93493_IQSR(0),
 	},
 	[1] = {
 		.handler	= mb93493_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "mb93493.1",
 		.dev_id		= (void *) __addr_MB93493_IQSR(1),
 	}
diff -puN arch/frv/kernel/time.c~frv-remove-deprecated-irqf_disabled arch/frv/kernel/time.c
--- a/arch/frv/kernel/time.c~frv-remove-deprecated-irqf_disabled
+++ a/arch/frv/kernel/time.c
@@ -44,7 +44,6 @@ static irqreturn_t timer_interrupt(int i
 
 static struct irqaction timer_irq  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
 	.name = "timer",
 };
 
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

frv-remove-deprecated-irqf_disabled.patch
linux-next.patch
score-remove-deprecated-irqf_disabled.patch

