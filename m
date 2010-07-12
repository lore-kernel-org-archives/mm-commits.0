From: akpm@linux-foundation.org
Subject: + gpiolib-allow-nested-threaded-irqs-for-poll2.patch added to -mm tree
Date: Mon, 12 Jul 2010 13:02:18 -0700
Message-ID: <201007122002.o6CK2I4g026323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab0GLUCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 16:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg@emlix.com, david-b@pacbell.net, ian@jeffray.co.uk


The patch titled
     gpiolib: allow nested threaded irqs for poll(2)
has been added to the -mm tree.  Its filename is
     gpiolib-allow-nested-threaded-irqs-for-poll2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpiolib: allow nested threaded irqs for poll(2)
=46rom: Daniel Gl=F6ckner <dg@emlix.com>

The pca953x driver requires the use of threaded irqs as its irq
demultiplexer can sleep.  Our irq handler can be called from any contex=
t,
so use request_any_context_irq to allow threaded irqs as well.

Signed-off-by: Daniel Gl=F6ckner <dg@emlix.com>
Reported-by: Ian Jeffray <ian@jeffray.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-allow-nested-threaded-irqs-for=
-poll2 drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-allow-nested-threaded-irqs-for-pol=
l2
+++ a/drivers/gpio/gpiolib.c
@@ -386,9 +386,9 @@ static int gpio_setup_irq(struct gpio_de
 		}
 	}
=20
-	ret =3D request_irq(irq, gpio_sysfs_irq, irq_flags,
+	ret =3D request_any_context_irq(irq, gpio_sysfs_irq, irq_flags,
 				"gpiolib", value_sd);
-	if (ret)
+	if (ret < 0)
 		goto free_id;
=20
 	desc->flags |=3D gpio_flags;
_

Patches currently in -mm which might be from dg@emlix.com are

linux-next.patch
gpiolib-get-rid-of-struct-poll_desc-and-worklet.patch
gpiolib-allow-nested-threaded-irqs-for-poll2.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
