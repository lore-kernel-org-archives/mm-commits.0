From: akpm@linux-foundation.org
Subject: + drivers-power-gpio-chargerc-check-for-kzalloc-failure.patch added to -mm tree
Date: Wed, 22 Dec 2010 14:15:03 -0800
Message-ID: <201012222215.oBMMF3mZ022434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab0LVWPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 17:15:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, cbouatmailru@gmail.com, lars@metafoo.de


The patch titled
     drivers/power/gpio-charger.c: check for kzalloc() failure
has been added to the -mm tree.  Its filename is
     drivers-power-gpio-chargerc-check-for-kzalloc-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/power/gpio-charger.c: check for kzalloc() failure
From: Dan Carpenter <error27@gmail.com>

Return -ENOMEM if kzalloc() fails.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/gpio-charger.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/power/gpio-charger.c~drivers-power-gpio-chargerc-check-for-kzalloc-failure drivers/power/gpio-charger.c
--- a/drivers/power/gpio-charger.c~drivers-power-gpio-chargerc-check-for-kzalloc-failure
+++ a/drivers/power/gpio-charger.c
@@ -87,6 +87,8 @@ static int __devinit gpio_charger_probe(
 	}
 
 	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
+	if (!gpio_charger)
+		return -ENOMEM;
 
 	charger = &gpio_charger->charger;
 
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
arch-x86-oprofile-op_model_amdc-perform-initialisation-on-a-single-cpu.patch
dca-remove-unneeded-null-check.patch
drivers-power-gpio-chargerc-check-for-kzalloc-failure.patch

