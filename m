From: akpm@linux-foundation.org
Subject: - handle-failure-of-irqchip-set_type-in-setup_irq-update.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:24:31 -0700
Message-ID: <200807232337.m6NNb8wH018089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764AbYGWXhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:37:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Uwe.Kleine-Koenig@digi.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     handle-failure-of-irqchip-set_type-in-setup_irq update
has been removed from the -mm tree.  Its filename was
     handle-failure-of-irqchip-set_type-in-setup_irq-update.patch

This patch was dropped because it was folded into handle-failure-of-irq=
chip-set_type-in-setup_irq.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: handle-failure-of-irqchip-set_type-in-setup_irq update
=46rom: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>

This uses the new feature of printk introduced in
0fe1ef24f7bd0020f29ffe287dfdb9ead33ca0b2.

The actual output is unchanged.

Signed-off-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN kernel/irq/manage.c~handle-failure-of-irqchip-set_type-in-set=
up_irq-update kernel/irq/manage.c
--- a/kernel/irq/manage.c~handle-failure-of-irqchip-set_type-in-setup_i=
rq-update
+++ a/kernel/irq/manage.c
@@ -317,14 +317,9 @@ static int __irq_set_trigger(struct irq_
=20
 	ret =3D chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
=20
-	if (ret) {
-		char buf[100];
