From: akpm@linux-foundation.org
Subject: - via-rng-enable-secondary-noise-source-on-cpus-where-it-is-present.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:14 -0800
Message-ID: <200802070022.m170Mtpe006479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935168AbYBGAqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, folkert@vanheusden.com, mb@bu3sch.de, udovdh@xs4all.nl, mm-commits@vger.kernel.org


The patch titled
     via-rng: enable secondary noise source on CPUs where it is present
has been removed from the -mm tree.  Its filename was
     via-rng-enable-secondary-noise-source-on-cpus-where-it-is-present.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: via-rng: enable secondary noise source on CPUs where it is present
From: Dave Jones <davej@redhat.com>

In the padlock spec:

"SRC Bits[9:8] Noise source select (I): These bits control the two noise
 sources on the processor that input bits to the accumulation buffers.
 On Nehemiah processors prior to stepping 8, these bits are reserved
 and undefined. The default RESET state is both bits = 0."

Signed-off-by: Dave Jones <davej@redhat.com>
Tested-by: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: folkert van Heusden <folkert@vanheusden.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/via-rng.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/char/hw_random/via-rng.c~via-rng-enable-secondary-noise-source-on-cpus-where-it-is-present drivers/char/hw_random/via-rng.c
--- a/drivers/char/hw_random/via-rng.c~via-rng-enable-secondary-noise-source-on-cpus-where-it-is-present
+++ a/drivers/char/hw_random/via-rng.c
@@ -42,6 +42,8 @@ enum {
 	VIA_STRFILT_ENABLE	= (1 << 14),
 	VIA_RAWBITS_ENABLE	= (1 << 13),
 	VIA_RNG_ENABLE		= (1 << 6),
+	VIA_NOISESRC1		= (1 << 8),
+	VIA_NOISESRC2		= (1 << 9),
 	VIA_XSTORE_CNT_MASK	= 0x0F,
 
 	VIA_RNG_CHUNK_8		= 0x00,	/* 64 rand bits, 64 stored bits */
@@ -119,6 +121,7 @@ static int via_rng_data_read(struct hwrn
 
 static int via_rng_init(struct hwrng *rng)
 {
+	struct cpuinfo_x86 *c = &cpu_data(0);
 	u32 lo, hi, old_lo;
 
 	/* Control the RNG via MSR.  Tread lightly and pay very close
@@ -134,6 +137,17 @@ static int via_rng_init(struct hwrng *rn
 	lo &= ~VIA_XSTORE_CNT_MASK;
 	lo &= ~(VIA_STRFILT_ENABLE | VIA_STRFILT_FAIL | VIA_RAWBITS_ENABLE);
 	lo |= VIA_RNG_ENABLE;
+	lo |= VIA_NOISESRC1;
+
+	/* Enable secondary noise source on CPUs where it is present. */
+
+	/* Nehemiah stepping 8 and higher */
+	if ((c->x86_model == 9) && (c->x86_mask > 7))
+		lo |= VIA_NOISESRC2;
+
+	/* Esther */
+	if (c->x86_model >= 10)
+		lo |= VIA_NOISESRC2;
 
 	if (lo != old_lo)
 		wrmsr(MSR_VIA_RNG, lo, hi);
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
git-acpi.patch
git-cpufreq.patch
