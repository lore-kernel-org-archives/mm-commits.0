From: akpm@linux-foundation.org
Subject: + handle-failure-of-irqchip-set_type-in-setup_irq-update.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:41:22 -0700
Message-ID: <200807111847.m6BIl3bb031045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755615AbYGKSrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:47:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, mingo@elte.hu


The patch titled
     handle-failure-of-irqchip-set_type-in-setup_irq update
has been added to the -mm tree.  Its filename is
     handle-failure-of-irqchip-set_type-in-setup_irq-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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
@@ -310,14 +310,9 @@ static int __irq_set_trigger(struct irq_
=20
 	ret =3D chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
=20
-	if (ret) {
-		char buf[100];
