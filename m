From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-power-gpio-chargerc-check-for-kzalloc-failure.patch removed from -mm tree
Date: Tue, 28 Dec 2010 12:19:26 -0800
Message-ID: <201012282019.oBSKJt3g015665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182Ab0L1UUE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Dec 2010 15:20:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, cbouatmailru@gmail.com, lars@metafoo.de, mm-commits@vger.kernel.org


The patch titled
     drivers/power/gpio-charger.c: check for kzalloc() failure
has been removed from the -mm tree.  Its filename was
     drivers-power-gpio-chargerc-check-for-kzalloc-failure.patch

This patch was dropped because an alternative patch was merged

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

origin.patch
linux-next.patch
arch-x86-oprofile-op_model_amdc-perform-initialisation-on-a-single-cpu.patch
dca-remove-unneeded-null-check.patch

