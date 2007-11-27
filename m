From: akpm@linux-foundation.org
Subject: - enable-dual-rng-on-via-c7.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:48:10 -0800
Message-ID: <200711272048.lARKmAjj029638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47022 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756150AbXK0UsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:48:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: udovdh@xs4all.nl, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     enable dual rng on VIA C7
has been removed from the -mm tree.  Its filename was
     enable-dual-rng-on-via-c7.patch

This patch was dropped because an updated version will be merged

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
@@ -42,6 +42,7 @@ enum {
 	VIA_STRFILT_ENABLE	= (1 << 14),
 	VIA_RAWBITS_ENABLE	= (1 << 13),
 	VIA_RNG_ENABLE		= (1 << 6),
+	VIA_RNG_DUAL            = (1 << 9),
 	VIA_XSTORE_CNT_MASK	= 0x0F,
 
 	VIA_RNG_CHUNK_8		= 0x00,	/* 64 rand bits, 64 stored bits */
@@ -133,6 +134,7 @@ static int via_rng_init(struct hwrng *rn
 	lo &= ~(0x7f << VIA_STRFILT_CNT_SHIFT);
 	lo &= ~VIA_XSTORE_CNT_MASK;
 	lo &= ~(VIA_STRFILT_ENABLE | VIA_STRFILT_FAIL | VIA_RAWBITS_ENABLE);
+	lo |= VIA_RNG_DUAL;
 	lo |= VIA_RNG_ENABLE;
 
 	if (lo != old_lo)
_

Patches currently in -mm which might be from udovdh@xs4all.nl are

enable-dual-rng-on-via-c7.patch
