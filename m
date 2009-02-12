From: akpm@linux-foundation.org
Subject: [merged] gpio_free-might-sleep-blackfin-architecture.patch removed from -mm tree
Date: Wed, 11 Feb 2009 18:23:26 -0800
Message-ID: <200902120223.n1C2NRPF023831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756595AbZBLCXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 21:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ukleinek@strlen.de, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio_free might sleep, blackfin architecture
has been removed from the -mm tree.  Its filename was
     gpio_free-might-sleep-blackfin-architecture.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpio_free might sleep, blackfin architecture
=46rom: Uwe Kleine-K=F6nig <ukleinek@strlen.de>

According to the documentation gpio_free should only be called from tas=
k
context only.  To make this more explicit add a might sleep to all
implementations.

This patch changes the gpio_free implementations for the blackfin
architecture.

Signed-off-by: Uwe Kleine-K=F6nig <ukleinek@strlen.de>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Bryan Wu <cooloney@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/bfin_gpio.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/blackfin/kernel/bfin_gpio.c~gpio_free-might-sleep-blackf=
in-architecture arch/blackfin/kernel/bfin_gpio.c
--- a/arch/blackfin/kernel/bfin_gpio.c~gpio_free-might-sleep-blackfin-a=
rchitecture
+++ a/arch/blackfin/kernel/bfin_gpio.c
@@ -988,6 +988,8 @@ void bfin_gpio_free(unsigned gpio)
 	if (check_gpio(gpio) < 0)
 		return;
=20
+	might_sleep();
+
 	local_irq_save_hw(flags);
=20
 	if (unlikely(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))))=
 {
_

Patches currently in -mm which might be from ukleinek@strlen.de are

video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-=
driver.patch
linux-next.patch
gpio_free-might-sleep-blackfin-architecture.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
