From: akpm@linux-foundation.org
Subject: - b43-replace-limit_value-macro-with-clamp_val.patch removed from -mm tree
Date: Fri, 16 May 2008 15:54:20 -0700
Message-ID: <200805162254.m4GMsKRB003229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758325AbYEPWzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linville@tuxdriver.com, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     b43: replace limit_value macro with clamp_val
has been removed from the -mm tree.  Its filename was
     b43-replace-limit_value-macro-with-clamp_val.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: b43: replace limit_value macro with clamp_val
From: Harvey Harrison <harvey.harrison@gmail.com>

kernel-provided clamp_val is identical, delete the private limit_value helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/b43.h  |   16 ----------------
 drivers/net/wireless/b43/lo.c   |    4 ++--
 drivers/net/wireless/b43/main.c |    8 ++++----
 drivers/net/wireless/b43/phy.c  |   24 ++++++++++++------------
 4 files changed, 18 insertions(+), 34 deletions(-)

diff -puN drivers/net/wireless/b43/b43.h~b43-replace-limit_value-macro-with-clamp_val drivers/net/wireless/b43/b43.h
--- a/drivers/net/wireless/b43/b43.h~b43-replace-limit_value-macro-with-clamp_val
+++ a/drivers/net/wireless/b43/b43.h
@@ -939,22 +939,6 @@ static inline bool __b43_warn_on_dummy(b
 # define B43_WARN_ON(x)	__b43_warn_on_dummy(unlikely(!!(x)))
 #endif
 
-/** Limit a value between two limits */
-#ifdef limit_value
-# undef limit_value
-#endif
-#define limit_value(value, min, max)  \
-	({						\
-		typeof(value) __value = (value);	\
-		typeof(value) __min = (min);		\
-		typeof(value) __max = (max);		\
-		if (__value < __min)			\
-			__value = __min;		\
-		else if (__value > __max)		\
-			__value = __max;		\
-		__value;				\
-	})
-
 /* Convert an integer to a Q5.2 value */
 #define INT_TO_Q52(i)	((i) << 2)
 /* Convert a Q5.2 value to an integer (precision loss!) */
diff -puN drivers/net/wireless/b43/lo.c~b43-replace-limit_value-macro-with-clamp_val drivers/net/wireless/b43/lo.c
--- a/drivers/net/wireless/b43/lo.c~b43-replace-limit_value-macro-with-clamp_val
+++ a/drivers/net/wireless/b43/lo.c
@@ -199,7 +199,7 @@ static void lo_measure_txctl_values(stru
 		if (lb_gain > 10) {
 			radio_pctl_reg = 0;
 			pga = abs(10 - lb_gain) / 6;
-			pga = limit_value(pga, 0, 15);
+			pga = clamp_val(pga, 0, 15);
 		} else {
 			int cmp_val;
 			int tmp;
@@ -321,7 +321,7 @@ static void lo_measure_gain_values(struc
 			phy->lna_lod_gain = 1;
 			trsw_rx_gain -= 8;
 		}
-		trsw_rx_gain = limit_value(trsw_rx_gain, 0, 0x2D);
+		trsw_rx_gain = clamp_val(trsw_rx_gain, 0, 0x2D);
 		phy->pga_gain = trsw_rx_gain / 3;
 		if (phy->pga_gain >= 5) {
 			phy->pga_gain -= 5;
diff -puN drivers/net/wireless/b43/main.c~b43-replace-limit_value-macro-with-clamp_val drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~b43-replace-limit_value-macro-with-clamp_val
+++ a/drivers/net/wireless/b43/main.c
@@ -1182,10 +1182,10 @@ static void handle_irq_noise(struct b43_
 	/* Get the noise samples. */
 	B43_WARN_ON(dev->noisecalc.nr_samples >= 8);
 	i = dev->noisecalc.nr_samples;
-	noise[0] = limit_value(noise[0], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
-	noise[1] = limit_value(noise[1], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
-	noise[2] = limit_value(noise[2], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
-	noise[3] = limit_value(noise[3], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[0] = clamp_val(noise[0], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[1] = clamp_val(noise[1], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[2] = clamp_val(noise[2], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[3] = clamp_val(noise[3], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
 	dev->noisecalc.samples[i][0] = phy->nrssi_lt[noise[0]];
 	dev->noisecalc.samples[i][1] = phy->nrssi_lt[noise[1]];
 	dev->noisecalc.samples[i][2] = phy->nrssi_lt[noise[2]];
diff -puN drivers/net/wireless/b43/phy.c~b43-replace-limit_value-macro-with-clamp_val drivers/net/wireless/b43/phy.c
--- a/drivers/net/wireless/b43/phy.c~b43-replace-limit_value-macro-with-clamp_val
+++ a/drivers/net/wireless/b43/phy.c
@@ -1415,7 +1415,7 @@ static void b43_phy_initg(struct b43_wld
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
 		 * Essentially, what we do here is resetting all NRSSI LT
-		 * entries to -32 (see the limit_value() in nrssi_hw_update())
+		 * entries to -32 (see the clamp_val() in nrssi_hw_update())
 		 */
 		b43_nrssi_hw_update(dev, 0xFFFF);	//FIXME?
 		b43_calc_nrssi_threshold(dev);
@@ -1477,13 +1477,13 @@ static s8 b43_phy_estimate_power_out(str
 	switch (phy->type) {
 	case B43_PHYTYPE_A:
 		tmp += 0x80;
-		tmp = limit_value(tmp, 0x00, 0xFF);
+		tmp = clamp_val(tmp, 0x00, 0xFF);
 		dbm = phy->tssi2dbm[tmp];
 		//TODO: There's a FIXME on the specs
 		break;
 	case B43_PHYTYPE_B:
 	case B43_PHYTYPE_G:
-		tmp = limit_value(tmp, 0x00, 0x3F);
+		tmp = clamp_val(tmp, 0x00, 0x3F);
 		dbm = phy->tssi2dbm[tmp];
 		break;
 	default:
@@ -1542,8 +1542,8 @@ void b43_put_attenuation_into_ranges(str
 		break;
 	}
 
-	*_rfatt = limit_value(rfatt, rf_min, rf_max);
-	*_bbatt = limit_value(bbatt, bb_min, bb_max);
+	*_rfatt = clamp_val(rfatt, rf_min, rf_max);
+	*_bbatt = clamp_val(bbatt, bb_min, bb_max);
 }
 
 /* http://bcm-specs.sipsolutions.net/RecalculateTransmissionPower */
@@ -1638,7 +1638,7 @@ void b43_phy_xmitpower(struct b43_wldev 
 			/* Get desired power (in Q5.2) */
 			desired_pwr = INT_TO_Q52(phy->power_level);
 			/* And limit it. max_pwr already is Q5.2 */
-			desired_pwr = limit_value(desired_pwr, 0, max_pwr);
+			desired_pwr = clamp_val(desired_pwr, 0, max_pwr);
 			if (b43_debug(dev, B43_DBG_XMITPOWER)) {
 				b43dbg(dev->wl,
 				       "Current TX power output: " Q52_FMT
@@ -1748,7 +1748,7 @@ static inline
 		f = q;
 		i++;
 	} while (delta >= 2);
-	entry[index] = limit_value(b43_tssi2dbm_ad(m1 * f, 8192), -127, 128);
+	entry[index] = clamp_val(b43_tssi2dbm_ad(m1 * f, 8192), -127, 128);
 	return 0;
 }
 
@@ -2274,7 +2274,7 @@ void b43_nrssi_hw_update(struct b43_wlde
 	for (i = 0; i < 64; i++) {
 		tmp = b43_nrssi_hw_read(dev, i);
 		tmp -= val;
-		tmp = limit_value(tmp, -32, 31);
+		tmp = clamp_val(tmp, -32, 31);
 		b43_nrssi_hw_write(dev, i, tmp);
 	}
 }
@@ -2291,7 +2291,7 @@ void b43_nrssi_mem_update(struct b43_wld
 		tmp = (i - delta) * phy->nrssislope;
 		tmp /= 0x10000;
 		tmp += 0x3A;
-		tmp = limit_value(tmp, 0, 0x3F);
+		tmp = clamp_val(tmp, 0, 0x3F);
 		phy->nrssi_lt[i] = tmp;
 	}
 }
@@ -2728,7 +2728,7 @@ void b43_calc_nrssi_threshold(struct b43
 			} else
 				threshold = phy->nrssi[1] - 5;
 
-			threshold = limit_value(threshold, 0, 0x3E);
+			threshold = clamp_val(threshold, 0, 0x3E);
 			b43_phy_read(dev, 0x0020);	/* dummy read */
 			b43_phy_write(dev, 0x0020,
 				      (((u16) threshold) << 8) | 0x001C);
@@ -2779,7 +2779,7 @@ void b43_calc_nrssi_threshold(struct b43
 			else
 				a += 32;
 			a = a >> 6;
-			a = limit_value(a, -31, 31);
+			a = clamp_val(a, -31, 31);
 
 			b = b * (phy->nrssi[1] - phy->nrssi[0]);
 			b += (phy->nrssi[0] << 6);
@@ -2788,7 +2788,7 @@ void b43_calc_nrssi_threshold(struct b43
 			else
 				b += 32;
 			b = b >> 6;
-			b = limit_value(b, -31, 31);
+			b = clamp_val(b, -31, 31);
 
 			tmp_u16 = b43_phy_read(dev, 0x048A) & 0xF000;
 			tmp_u16 |= ((u32) b & 0x0000003F);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
nfs-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

