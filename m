From: akpm@linux-foundation.org
Subject: [patch 18/20] ipack: print a hex number after a 0x prefix
Date: Thu, 27 Oct 2016 17:47:07 -0700
Message-ID: <5812a00b.zVaS+QCySsmyiFeW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943135AbcJ1ArI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de, gregkh@linuxfoundation.org, jens.taprogge@taprogge.org, siglesias@igalia.com

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: ipack: print a hex number after a 0x prefix

It makes the result hard to interpret correctly if a base 10 number is
prefixed by 0x. So change to a hex number.

Link: http://lkml.kernel.org/r/20161026125658.25728-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ipack/ipack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ipack/ipack.c~ipack-print-a-hex-number-after-a-0x-prefix drivers/ipack/ipack.c
--- a/drivers/ipack/ipack.c~ipack-print-a-hex-number-after-a-0x-prefix
+++ a/drivers/ipack/ipack.c
@@ -178,7 +178,7 @@ static ssize_t modalias_show(struct devi
 		       idev->id_vendor, idev->id_device);
 }
 
-ipack_device_attr(id_format, "0x%hhu\n");
+ipack_device_attr(id_format, "0x%hhx\n");
 
 static DEVICE_ATTR_RO(id);
 static DEVICE_ATTR_RO(id_device);
_
