From: akpm@linux-foundation.org
Subject: + enable-dual-rng-on-via-c7.patch added to -mm tree
Date: Sun, 25 Nov 2007 23:39:55 -0800
Message-ID: <200711260739.lAQ7duTS022662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbXKZHkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 02:40:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: udovdh@xs4all.nl, mb@bu3sch.de


The patch titled
     enable dual rng on VIA C7
has been added to the -mm tree.  Its filename is
     enable-dual-rng-on-via-c7.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: enable dual rng on VIA C7
From: Udo van den Heuvel <udovdh@xs4all.nl>

Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/via-rng.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/char/hw_random/via-rng.c~enable-dual-rng-on-via-c7 drivers/char/hw_random/via-rng.c
--- a/drivers/char/hw_random/via-rng.c~enable-dual-rng-on-via-c7
+++ a/drivers/char/hw_random/via-rng.c
@@ -41,6 +41,7 @@ enum {
 	VIA_STRFILT_ENABLE	= (1 << 14),
 	VIA_RAWBITS_ENABLE	= (1 << 13),
 	VIA_RNG_ENABLE		= (1 << 6),
+	VIA_RNG_DUAL            = (1 << 9),
 	VIA_XSTORE_CNT_MASK	= 0x0F,
 
 	VIA_RNG_CHUNK_8		= 0x00,	/* 64 rand bits, 64 stored bits */
@@ -128,6 +129,7 @@ static int via_rng_init(struct hwrng *rn
 	lo &= ~(0x7f << VIA_STRFILT_CNT_SHIFT);
 	lo &= ~VIA_XSTORE_CNT_MASK;
 	lo &= ~(VIA_STRFILT_ENABLE | VIA_STRFILT_FAIL | VIA_RAWBITS_ENABLE);
+	lo |= VIA_RNG_DUAL;
 	lo |= VIA_RNG_ENABLE;
 
 	if (lo != old_lo)
_

Patches currently in -mm which might be from udovdh@xs4all.nl are

enable-dual-rng-on-via-c7.patch
