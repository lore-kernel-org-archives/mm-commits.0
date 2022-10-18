Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA5CC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 21:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiJRVHq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 17:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJRVHn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 17:07:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852429AF88
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 14:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FDE6B82170
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 21:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9712C433D6;
        Tue, 18 Oct 2022 21:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666127258;
        bh=RGmKGtVHA9Up29jdK7OX7C/c/vAkZwo/GcnKXaOBPHI=;
        h=Date:To:From:Subject:From;
        b=uU2y5ByXVyorUucFsmnbLYP3UhofbhC6otM7jgQGW9UINJsrRxd8VbjZNN9yqA9vA
         pDHP6x5Xq38+gyZxd60HfOt5kskBx0qlA+DhJblJV8opaKf8AxmBmKZq7ghM9yGE7f
         1Q++Wc9MJNaPM4a5FMzuR8X852qhkmWfio2KFOtw=
Date:   Tue, 18 Oct 2022 14:07:38 -0700
To:     mm-commits@vger.kernel.org, stf_xl@wp.pl, kvalo@kernel.org,
        helmut.schaa@googlemail.com, andriy.shevchenko@linux.intel.com,
        Jason@zx2c4.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + wifi-rt2x00-use-explicitly-signed-type-for-clamping.patch added to mm-nonmm-unstable branch
Message-Id: <20221018210738.D9712C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: wifi: rt2x00: use explicitly signed type for clamping
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     wifi-rt2x00-use-explicitly-signed-type-for-clamping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/wifi-rt2x00-use-explicitly-signed-type-for-clamping.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: wifi: rt2x00: use explicitly signed type for clamping
Date: Tue, 18 Oct 2022 14:27:34 -0600

On some platforms, `char` is unsigned, which makes casting -7 to char
overflow, which in turn makes the clamping operation bogus.  Instead, deal
with an explicit `s8` type, so that the comparison is always signed, and
return an s8 result from the function as well.  Note that this function's
result is assigned to a `short`, which is always signed.

Link: https://lkml.kernel.org/r/20221018202734.140489-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c~wifi-rt2x00-use-explicitly-signed-type-for-clamping
+++ a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4035,23 +4035,23 @@ static void rt2800_iq_calibrate(struct r
 	rt2800_bbp_write(rt2x00dev, 159, cal != 0xff ? cal : 0);
 }
 
-static char rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
+static s8 rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
 				  unsigned int channel,
-				  char txpower)
+				  s8 txpower)
 {
 	if (rt2x00_rt(rt2x00dev, RT3593) ||
 	    rt2x00_rt(rt2x00dev, RT3883))
 		txpower = rt2x00_get_field8(txpower, EEPROM_TXPOWER_ALC);
 
 	if (channel <= 14)
-		return clamp_t(char, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
+		return clamp_t(s8, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
 
 	if (rt2x00_rt(rt2x00dev, RT3593) ||
 	    rt2x00_rt(rt2x00dev, RT3883))
-		return clamp_t(char, txpower, MIN_A_TXPOWER_3593,
+		return clamp_t(s8, txpower, MIN_A_TXPOWER_3593,
 			       MAX_A_TXPOWER_3593);
 	else
-		return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
+		return clamp_t(s8, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
 }
 
 static void rt3883_bbp_adjust(struct rt2x00_dev *rt2x00dev,
_

Patches currently in -mm which might be from Jason@zx2c4.com are

wifi-rt2x00-use-explicitly-signed-type-for-clamping.patch
minmax-sanity-check-constant-bounds-when-clamping.patch
minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch

