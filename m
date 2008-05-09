From: akpm@linux-foundation.org
Subject: - mm-only-b43-rewrite-lo-calibration.patch removed from -mm tree
Date: Fri, 09 May 2008 14:47:32 -0700
Message-ID: <200805092147.m49LlWp9027244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbYEIV4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     b43: rewrite LO calibration
has been removed from the -mm tree.  Its filename was
     mm-only-b43-rewrite-lo-calibration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: b43: rewrite LO calibration
From: Michael Buesch <mb@bu3sch.de>

This patch is supposed to distribute the calibration bursts over time, so that
calibration only happens when it's actually needed.

So instead of disabling the MAC every 120 secs and recalibrating the whole
calibration tables, we assign a timeout to each calibration value and only
recalibrate it if it's

a) expired and

b) currently used.

Recalibration might also happen on TX power adjustment, if the corresponding
calibration item is no longer in the cache because it has expired.  That
actually happens most of the time, but we can live with it, as power
adjustment doesn't happen that often and calibration is a _lot_ cheaper.

This patch also reduced overall memory consumption by nuking the huge static
calibration tables.

Disclaimer:

The algorithms in this patch are completely redesigned and have nothing in
common with how broadcom does the stuff in the proprietary driver.  So it's
highly experimental and I'm not responsible in case this patch eats your cat.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/debugfs.c |   79 +--
 drivers/net/wireless/b43/debugfs.h |    1 
 drivers/net/wireless/b43/lo.c      |  700 +++++++++------------------
 drivers/net/wireless/b43/lo.h      |  112 +---
 drivers/net/wireless/b43/main.c    |   26 -
 drivers/net/wireless/b43/main.h    |    3 
 drivers/net/wireless/b43/phy.c     |  117 +---
 drivers/net/wireless/b43/phy.h     |   16 
 8 files changed, 382 insertions(+), 672 deletions(-)

diff -puN drivers/net/wireless/b43/debugfs.c~mm-only-b43-rewrite-lo-calibration drivers/net/wireless/b43/debugfs.c
--- a/drivers/net/wireless/b43/debugfs.c~mm-only-b43-rewrite-lo-calibration
+++ a/drivers/net/wireless/b43/debugfs.c
@@ -270,24 +270,22 @@ static int restart_write_file(struct b43
 	return err;
 }
 
-static ssize_t append_lo_table(ssize_t count, char *buf, const size_t bufsize,
-			       struct b43_loctl table[B43_NR_BB][B43_NR_RF])
-{
-	unsigned int i, j;
-	struct b43_loctl *ctl;
-
-	for (i = 0; i < B43_NR_BB; i++) {
-		for (j = 0; j < B43_NR_RF; j++) {
-			ctl = &(table[i][j]);
-			fappend("(bbatt %2u, rfatt %2u)  ->  "
-				"(I %+3d, Q %+3d, Used: %d, Calibrated: %d)\n",
-				i, j, ctl->i, ctl->q,
-				ctl->used,
-				b43_loctl_is_calibrated(ctl));
-		}
+static unsigned long calc_expire_secs(unsigned long now,
+				      unsigned long time,
+				      unsigned long expire)
+{
+	expire = time + expire;
+
+	if (time_after(now, expire))
+		return 0; /* expired */
+	if (expire < now) {
+		/* jiffies wrapped */
+		expire -= MAX_JIFFY_OFFSET;
+		now -= MAX_JIFFY_OFFSET;
 	}
+	B43_WARN_ON(expire < now);
 
-	return count;
+	return (expire - now) / HZ;
 }
 
 static ssize_t loctls_read_file(struct b43_wldev *dev,
@@ -296,27 +294,45 @@ static ssize_t loctls_read_file(struct b
 	ssize_t count = 0;
 	struct b43_txpower_lo_control *lo;
 	int i, err = 0;
+	struct b43_lo_calib *cal;
+	unsigned long now = jiffies;
+	struct b43_phy *phy = &dev->phy;
 
-	if (dev->phy.type != B43_PHYTYPE_G) {
+	if (phy->type != B43_PHYTYPE_G) {
 		fappend("Device is not a G-PHY\n");
 		err = -ENODEV;
 		goto out;
 	}
-	lo = dev->phy.lo_control;
+	lo = phy->lo_control;
 	fappend("-- Local Oscillator calibration data --\n\n");
-	fappend("Measured: %d,  Rebuild: %d,  HW-power-control: %d\n",
-		lo->lo_measured,
-		lo->rebuild,
+	fappend("HW-power-control enabled: %d\n",
 		dev->phy.hardware_power_control);
-	fappend("TX Bias: 0x%02X,  TX Magn: 0x%02X\n",
-		lo->tx_bias, lo->tx_magn);
-	fappend("Power Vector: 0x%08X%08X\n",
+	fappend("TX Bias: 0x%02X,  TX Magn: 0x%02X  (expire in %lu sec)\n",
+		lo->tx_bias, lo->tx_magn,
+		calc_expire_secs(now, lo->txctl_measured_time,
+				 B43_LO_TXCTL_EXPIRE));
+	fappend("Power Vector: 0x%08X%08X  (expires in %lu sec)\n",
 		(unsigned int)((lo->power_vector & 0xFFFFFFFF00000000ULL) >> 32),
-		(unsigned int)(lo->power_vector & 0x00000000FFFFFFFFULL));
-	fappend("\nControl table WITH PADMIX:\n");
-	count = append_lo_table(count, buf, bufsize, lo->with_padmix);
-	fappend("\nControl table WITHOUT PADMIX:\n");
-	count = append_lo_table(count, buf, bufsize, lo->no_padmix);
+		(unsigned int)(lo->power_vector & 0x00000000FFFFFFFFULL),
+		calc_expire_secs(now, lo->pwr_vec_read_time,
+				 B43_LO_PWRVEC_EXPIRE));
+
+	fappend("\nCalibrated settings:\n");
+	list_for_each_entry(cal, &lo->calib_list, list) {
+		bool active;
+
+		active = (b43_compare_bbatt(&cal->bbatt, &phy->bbatt) &&
+			  b43_compare_rfatt(&cal->rfatt, &phy->rfatt));
+		fappend("BB(%d), RF(%d,%d)  ->  I=%d, Q=%d  "
+			"(expires in %lu sec)%s\n",
+			cal->bbatt.att,
+			cal->rfatt.att, cal->rfatt.with_padmix,
+			cal->ctl.i, cal->ctl.q,
+			calc_expire_secs(now, cal->calib_time,
+					 B43_LO_CALIB_EXPIRE),
+			active ? "  ACTIVE" : "");
+	}
+
 	fappend("\nUsed RF attenuation values:  Value(WithPadmix flag)\n");
 	for (i = 0; i < lo->rfatt_list.len; i++) {
 		fappend("%u(%d), ",
@@ -351,7 +367,7 @@ static ssize_t b43_debugfs_read(struct f
 	struct b43_dfs_file *dfile;
 	ssize_t uninitialized_var(ret);
 	char *buf;
-	const size_t bufsize = 1024 * 128;
+	const size_t bufsize = 1024 * 16; /* 16 kiB buffer */
 	const size_t buforder = get_order(bufsize);
 	int err = 0;
 
@@ -380,8 +396,6 @@ static ssize_t b43_debugfs_read(struct f
 			err = -ENOMEM;
 			goto out_unlock;
 		}
-		/* Sparse warns about the following memset, because it has a big
-		 * size value. That warning is bogus, so I will ignore it. --mb */
 		memset(buf, 0, bufsize);
 		if (dfops->take_irqlock) {
 			spin_lock_irq(&dev->wl->irq_lock);
@@ -523,6 +537,7 @@ static void b43_add_dynamic_debug(struct
 	add_dyn_dbg("debug_dmaverbose", B43_DBG_DMAVERBOSE, 0);
 	add_dyn_dbg("debug_pwork_fast", B43_DBG_PWORK_FAST, 0);
 	add_dyn_dbg("debug_pwork_stop", B43_DBG_PWORK_STOP, 0);
+	add_dyn_dbg("debug_lo", B43_DBG_LO, 0);
 
 #undef add_dyn_dbg
 }
diff -puN drivers/net/wireless/b43/debugfs.h~mm-only-b43-rewrite-lo-calibration drivers/net/wireless/b43/debugfs.h
--- a/drivers/net/wireless/b43/debugfs.h~mm-only-b43-rewrite-lo-calibration
+++ a/drivers/net/wireless/b43/debugfs.h
@@ -10,6 +10,7 @@ enum b43_dyndbg {		/* Dynamic debugging 
 	B43_DBG_DMAVERBOSE,
 	B43_DBG_PWORK_FAST,
 	B43_DBG_PWORK_STOP,
+	B43_DBG_LO,
 	__B43_NR_DYNDBG,
 };
 
diff -puN drivers/net/wireless/b43/lo.c~mm-only-b43-rewrite-lo-calibration drivers/net/wireless/b43/lo.c
--- a/drivers/net/wireless/b43/lo.c~mm-only-b43-rewrite-lo-calibration
+++ a/drivers/net/wireless/b43/lo.c
@@ -36,10 +36,22 @@
 #include <linux/sched.h>
 
 
-/* Define to 1 to always calibrate all possible LO control pairs.
- * This is a workaround until we fix the partial LO calibration optimization. */
-#define B43_CALIB_ALL_LOCTLS	1
+static struct b43_lo_calib * b43_find_lo_calib(struct b43_txpower_lo_control *lo,
+					       const struct b43_bbatt *bbatt,
+					       const struct b43_rfatt *rfatt)
+{
+	struct b43_lo_calib *c;
 
+	list_for_each_entry(c, &lo->calib_list, list) {
+		if (!b43_compare_bbatt(&c->bbatt, bbatt))
+			continue;
+		if (!b43_compare_rfatt(&c->rfatt, rfatt))
+			continue;
+		return c;
+	}
+
+	return NULL;
+}
 
 /* Write the LocalOscillator Control (adjust) value-pair. */
 static void b43_lo_write(struct b43_wldev *dev, struct b43_loctl *control)
@@ -64,183 +76,6 @@ static void b43_lo_write(struct b43_wlde
 	b43_phy_write(dev, reg, value);
 }
 
-static int assert_rfatt_and_bbatt(const struct b43_rfatt *rfatt,
-				  const struct b43_bbatt *bbatt,
-				  struct b43_wldev *dev)
-{
-	int err = 0;
-
-	/* Check the attenuation values against the LO control array sizes. */
-	if (unlikely(rfatt->att >= B43_NR_RF)) {
-		b43err(dev->wl, "rfatt(%u) >= size of LO array\n", rfatt->att);
-		err = -EINVAL;
-	}
-	if (unlikely(bbatt->att >= B43_NR_BB)) {
-		b43err(dev->wl, "bbatt(%u) >= size of LO array\n", bbatt->att);
-		err = -EINVAL;
-	}
-
-	return err;
-}
-
-#if !B43_CALIB_ALL_LOCTLS
-static
-struct b43_loctl *b43_get_lo_g_ctl_nopadmix(struct b43_wldev *dev,
-					    const struct b43_rfatt *rfatt,
-					    const struct b43_bbatt *bbatt)
-{
-	struct b43_phy *phy = &dev->phy;
-	struct b43_txpower_lo_control *lo = phy->lo_control;
-
-	if (assert_rfatt_and_bbatt(rfatt, bbatt, dev))
-		return &(lo->no_padmix[0][0]);	/* Just prevent a crash */
-	return &(lo->no_padmix[bbatt->att][rfatt->att]);
-}
-#endif /* !B43_CALIB_ALL_LOCTLS */
-
-struct b43_loctl *b43_get_lo_g_ctl(struct b43_wldev *dev,
-				   const struct b43_rfatt *rfatt,
-				   const struct b43_bbatt *bbatt)
-{
-	struct b43_phy *phy = &dev->phy;
-	struct b43_txpower_lo_control *lo = phy->lo_control;
-
-	if (assert_rfatt_and_bbatt(rfatt, bbatt, dev))
-		return &(lo->no_padmix[0][0]);	/* Just prevent a crash */
-	if (rfatt->with_padmix)
-		return &(lo->with_padmix[bbatt->att][rfatt->att]);
-	return &(lo->no_padmix[bbatt->att][rfatt->att]);
-}
-
-/* Call a function for every possible LO control value-pair. */
-static void b43_call_for_each_loctl(struct b43_wldev *dev,
-				    void (*func) (struct b43_wldev *,
-						  struct b43_loctl *))
-{
-	struct b43_phy *phy = &dev->phy;
-	struct b43_txpower_lo_control *ctl = phy->lo_control;
-	int i, j;
-
-	for (i = 0; i < B43_NR_BB; i++) {
-		for (j = 0; j < B43_NR_RF; j++)
-			func(dev, &(ctl->with_padmix[i][j]));
-	}
-	for (i = 0; i < B43_NR_BB; i++) {
-		for (j = 0; j < B43_NR_RF; j++)
-			func(dev, &(ctl->no_padmix[i][j]));
-	}
-}
-
-static u16 lo_b_r15_loop(struct b43_wldev *dev)
-{
-	int i;
-	u16 ret = 0;
-
-	for (i = 0; i < 10; i++) {
-		b43_phy_write(dev, 0x0015, 0xAFA0);
-		udelay(1);
-		b43_phy_write(dev, 0x0015, 0xEFA0);
-		udelay(10);
-		b43_phy_write(dev, 0x0015, 0xFFA0);
-		udelay(40);
-		ret += b43_phy_read(dev, 0x002C);
-	}
-
-	return ret;
-}
-
-void b43_lo_b_measure(struct b43_wldev *dev)
-{
-	struct b43_phy *phy = &dev->phy;
-	u16 regstack[12] = { 0 };
-	u16 mls;
-	u16 fval;
-	int i, j;
-
-	regstack[0] = b43_phy_read(dev, 0x0015);
-	regstack[1] = b43_radio_read16(dev, 0x0052) & 0xFFF0;
-
-	if (phy->radio_ver == 0x2053) {
-		regstack[2] = b43_phy_read(dev, 0x000A);
-		regstack[3] = b43_phy_read(dev, 0x002A);
-		regstack[4] = b43_phy_read(dev, 0x0035);
-		regstack[5] = b43_phy_read(dev, 0x0003);
-		regstack[6] = b43_phy_read(dev, 0x0001);
-		regstack[7] = b43_phy_read(dev, 0x0030);
-
-		regstack[8] = b43_radio_read16(dev, 0x0043);
-		regstack[9] = b43_radio_read16(dev, 0x007A);
-		regstack[10] = b43_read16(dev, 0x03EC);
-		regstack[11] = b43_radio_read16(dev, 0x0052) & 0x00F0;
-
-		b43_phy_write(dev, 0x0030, 0x00FF);
-		b43_write16(dev, 0x03EC, 0x3F3F);
-		b43_phy_write(dev, 0x0035, regstack[4] & 0xFF7F);
-		b43_radio_write16(dev, 0x007A, regstack[9] & 0xFFF0);
-	}
-	b43_phy_write(dev, 0x0015, 0xB000);
-	b43_phy_write(dev, 0x002B, 0x0004);
-
-	if (phy->radio_ver == 0x2053) {
-		b43_phy_write(dev, 0x002B, 0x0203);
-		b43_phy_write(dev, 0x002A, 0x08A3);
-	}
-
-	phy->minlowsig[0] = 0xFFFF;
-
-	for (i = 0; i < 4; i++) {
-		b43_radio_write16(dev, 0x0052, regstack[1] | i);
-		lo_b_r15_loop(dev);
-	}
-	for (i = 0; i < 10; i++) {
-		b43_radio_write16(dev, 0x0052, regstack[1] | i);
-		mls = lo_b_r15_loop(dev) / 10;
-		if (mls < phy->minlowsig[0]) {
-			phy->minlowsig[0] = mls;
-			phy->minlowsigpos[0] = i;
-		}
-	}
-	b43_radio_write16(dev, 0x0052, regstack[1] | phy->minlowsigpos[0]);
-
-	phy->minlowsig[1] = 0xFFFF;
-
-	for (i = -4; i < 5; i += 2) {
-		for (j = -4; j < 5; j += 2) {
-			if (j < 0)
-				fval = (0x0100 * i) + j + 0x0100;
-			else
-				fval = (0x0100 * i) + j;
-			b43_phy_write(dev, 0x002F, fval);
-			mls = lo_b_r15_loop(dev) / 10;
-			if (mls < phy->minlowsig[1]) {
-				phy->minlowsig[1] = mls;
-				phy->minlowsigpos[1] = fval;
-			}
-		}
-	}
-	phy->minlowsigpos[1] += 0x0101;
-
-	b43_phy_write(dev, 0x002F, phy->minlowsigpos[1]);
-	if (phy->radio_ver == 0x2053) {
-		b43_phy_write(dev, 0x000A, regstack[2]);
-		b43_phy_write(dev, 0x002A, regstack[3]);
-		b43_phy_write(dev, 0x0035, regstack[4]);
-		b43_phy_write(dev, 0x0003, regstack[5]);
-		b43_phy_write(dev, 0x0001, regstack[6]);
-		b43_phy_write(dev, 0x0030, regstack[7]);
-
-		b43_radio_write16(dev, 0x0043, regstack[8]);
-		b43_radio_write16(dev, 0x007A, regstack[9]);
-
-		b43_radio_write16(dev, 0x0052,
-				  (b43_radio_read16(dev, 0x0052) & 0x000F)
-				  | regstack[11]);
-
-		b43_write16(dev, 0x03EC, regstack[10]);
-	}
-	b43_phy_write(dev, 0x0015, regstack[0]);
-}
-
 static u16 lo_measure_feedthrough(struct b43_wldev *dev,
 				  u16 lna, u16 pga, u16 trsw_rx)
 {
@@ -438,48 +273,30 @@ static void lo_measure_txctl_values(stru
 		b43_radio_write16(dev, 0x52, b43_radio_read16(dev, 0x52)
 				  & 0xFFF0);	/* TX bias == 0 */
 	}
+	lo->txctl_measured_time = jiffies;
 }
 
 static void lo_read_power_vector(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_txpower_lo_control *lo = phy->lo_control;
-	u16 i;
+	int i;
 	u64 tmp;
 	u64 power_vector = 0;
-	int rf_offset, bb_offset;
-	struct b43_loctl *loctl;
 
 	for (i = 0; i < 8; i += 2) {
 		tmp = b43_shm_read16(dev, B43_SHM_SHARED, 0x310 + i);
 		/* Clear the top byte. We get holes in the bitmap... */
+		/* FIXME this simply doesn't make sense. Maybe it's a bug in the brcm driver.
+		 * Did they use an u8 type for the temp variable? */
 		tmp &= 0xFF;
 		power_vector |= (tmp << (i * 8));
 		/* Clear the vector on the device. */
 		b43_shm_write16(dev, B43_SHM_SHARED, 0x310 + i, 0);
 	}
-
 	if (power_vector)
 		lo->power_vector = power_vector;
-	power_vector = lo->power_vector;
-
-	for (i = 0; i < 64; i++) {
-		if (power_vector & ((u64) 1ULL << i)) {
-			/* Now figure out which b43_loctl corresponds
-			 * to this bit.
-			 */
-			rf_offset = i / lo->rfatt_list.len;
-			bb_offset = i % lo->rfatt_list.len;	//FIXME?
-			loctl =
-			    b43_get_lo_g_ctl(dev,
-					     &lo->rfatt_list.list[rf_offset],
-					     &lo->bbatt_list.list[bb_offset]);
-			/* And mark it as "used", as the device told us
-			 * through the bitmap it is using it.
-			 */
-			loctl->used = 1;
-		}
-	}
+	lo->pwr_vec_read_time = jiffies;
 }
 
 /* 802.11/LO/GPHY/MeasuringGains */
@@ -609,8 +426,6 @@ static void lo_measure_setup(struct b43_
 		b43_phy_write(dev, B43_PHY_CCK(0x16), 0x410);
 		b43_phy_write(dev, B43_PHY_CCK(0x17), 0x820);
 	}
-	if (!lo->rebuild && b43_has_hardware_pctl(phy))
-		lo_read_power_vector(dev);
 	if (phy->rev >= 2) {
 		sav->phy_analogover = b43_phy_read(dev, B43_PHY_ANALOGOVER);
 		sav->phy_analogoverval =
@@ -691,8 +506,12 @@ static void lo_measure_setup(struct b43_
 	b43_radio_read16(dev, 0x51);	/* dummy read */
 	if (phy->type == B43_PHYTYPE_G)
 		b43_phy_write(dev, B43_PHY_CCK(0x2F), 0);
-	if (lo->rebuild)
+
+	/* Re-measure the txctl values, if needed. */
+	if (time_before(lo->txctl_measured_time,
+			jiffies - B43_LO_TXCTL_EXPIRE))
 		lo_measure_txctl_values(dev);
+
 	if (phy->type == B43_PHYTYPE_G && phy->rev >= 3) {
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0xC078);
 	} else {
@@ -707,7 +526,6 @@ static void lo_measure_restore(struct b4
 			       struct lo_g_saved_values *sav)
 {
 	struct b43_phy *phy = &dev->phy;
-	struct b43_txpower_lo_control *lo = phy->lo_control;
 	u16 tmp;
 
 	if (phy->rev >= 2) {
@@ -722,14 +540,6 @@ static void lo_measure_restore(struct b4
 		tmp = (phy->pga_gain | 0xEFA0);
 		b43_phy_write(dev, B43_PHY_PGACTL, tmp);
 	}
-	if (b43_has_hardware_pctl(phy)) {
-		b43_gphy_dc_lt_init(dev);
-	} else {
-		if (lo->rebuild)
-			b43_lo_g_adjust_to(dev, 3, 2, 0);
-		else
-			b43_lo_g_adjust(dev);
-	}
 	if (phy->type == B43_PHYTYPE_G) {
 		if (phy->rev >= 3)
 			b43_phy_write(dev, B43_PHY_CCK(0x2E), 0xC078);
@@ -793,7 +603,6 @@ static int lo_probe_possible_loctls(stru
 				    struct b43_lo_g_statemachine *d)
 {
 	struct b43_phy *phy = &dev->phy;
-	struct b43_txpower_lo_control *lo = phy->lo_control;
 	struct b43_loctl test_loctl;
 	struct b43_loctl orig_loctl;
 	struct b43_loctl prev_loctl = {
@@ -852,7 +661,7 @@ static int lo_probe_possible_loctls(stru
 				found_lower = 1;
 				d->lowest_feedth = feedth;
 				if ((d->nr_measured < 2) &&
-				    (!has_loopback_gain(phy) || lo->rebuild))
+				    !has_loopback_gain(phy))
 					break;
 			}
 		}
@@ -874,7 +683,6 @@ static void lo_probe_loctls_statemachine
 					 int *max_rx_gain)
 {
 	struct b43_phy *phy = &dev->phy;
-	struct b43_txpower_lo_control *lo = phy->lo_control;
 	struct b43_lo_g_statemachine d;
 	u16 feedth;
 	int found_lower;
@@ -883,18 +691,18 @@ static void lo_probe_loctls_statemachine
 
 	d.nr_measured = 0;
 	d.state_val_multiplier = 1;
-	if (has_loopback_gain(phy) && !lo->rebuild)
+	if (has_loopback_gain(phy))
 		d.state_val_multiplier = 3;
 
 	memcpy(&d.min_loctl, loctl, sizeof(struct b43_loctl));
-	if (has_loopback_gain(phy) && lo->rebuild)
+	if (has_loopback_gain(phy))
 		max_repeat = 4;
 	do {
 		b43_lo_write(dev, &d.min_loctl);
 		feedth = lo_measure_feedthrough(dev, phy->lna_gain,
 						phy->pga_gain,
 						phy->trsw_rx_gain);
-		if (!lo->rebuild && feedth < 0x258) {
+		if (feedth < 0x258) {
 			if (feedth >= 0x12C)
 				*max_rx_gain += 6;
 			else
@@ -944,256 +752,164 @@ static void lo_probe_loctls_statemachine
 	} while (++repeat_cnt < max_repeat);
 }
 
-#if B43_CALIB_ALL_LOCTLS
-static const struct b43_rfatt b43_full_rfatt_list_items[] = {
-	{ .att = 0, .with_padmix = 0, },
-	{ .att = 1, .with_padmix = 0, },
-	{ .att = 2, .with_padmix = 0, },
-	{ .att = 3, .with_padmix = 0, },
-	{ .att = 4, .with_padmix = 0, },
-	{ .att = 5, .with_padmix = 0, },
-	{ .att = 6, .with_padmix = 0, },
-	{ .att = 7, .with_padmix = 0, },
-	{ .att = 8, .with_padmix = 0, },
-	{ .att = 9, .with_padmix = 0, },
-	{ .att = 10, .with_padmix = 0, },
-	{ .att = 11, .with_padmix = 0, },
-	{ .att = 12, .with_padmix = 0, },
-	{ .att = 13, .with_padmix = 0, },
-	{ .att = 14, .with_padmix = 0, },
-	{ .att = 15, .with_padmix = 0, },
-	{ .att = 0, .with_padmix = 1, },
-	{ .att = 1, .with_padmix = 1, },
-	{ .att = 2, .with_padmix = 1, },
-	{ .att = 3, .with_padmix = 1, },
-	{ .att = 4, .with_padmix = 1, },
-	{ .att = 5, .with_padmix = 1, },
-	{ .att = 6, .with_padmix = 1, },
-	{ .att = 7, .with_padmix = 1, },
-	{ .att = 8, .with_padmix = 1, },
-	{ .att = 9, .with_padmix = 1, },
-	{ .att = 10, .with_padmix = 1, },
-	{ .att = 11, .with_padmix = 1, },
-	{ .att = 12, .with_padmix = 1, },
-	{ .att = 13, .with_padmix = 1, },
-	{ .att = 14, .with_padmix = 1, },
-	{ .att = 15, .with_padmix = 1, },
-};
-static const struct b43_rfatt_list b43_full_rfatt_list = {
-	.list		= b43_full_rfatt_list_items,
-	.len		= ARRAY_SIZE(b43_full_rfatt_list_items),
-};
-
-static const struct b43_bbatt b43_full_bbatt_list_items[] = {
-	{ .att = 0, },
-	{ .att = 1, },
-	{ .att = 2, },
-	{ .att = 3, },
-	{ .att = 4, },
-	{ .att = 5, },
-	{ .att = 6, },
-	{ .att = 7, },
-	{ .att = 8, },
-	{ .att = 9, },
-	{ .att = 10, },
-	{ .att = 11, },
-};
-static const struct b43_bbatt_list b43_full_bbatt_list = {
-	.list		= b43_full_bbatt_list_items,
-	.len		= ARRAY_SIZE(b43_full_bbatt_list_items),
-};
-#endif /* B43_CALIB_ALL_LOCTLS */
-
-static void lo_measure(struct b43_wldev *dev)
+static
+struct b43_lo_calib * b43_calibrate_lo_setting(struct b43_wldev *dev,
+					       const struct b43_bbatt *bbatt,
+					       const struct b43_rfatt *rfatt)
 {
 	struct b43_phy *phy = &dev->phy;
-	struct b43_txpower_lo_control *lo = phy->lo_control;
 	struct b43_loctl loctl = {
 		.i = 0,
 		.q = 0,
 	};
-	struct b43_loctl *ploctl;
 	int max_rx_gain;
-	int rfidx, bbidx;
-	const struct b43_bbatt_list *bbatt_list;
-	const struct b43_rfatt_list *rfatt_list;
-
+	struct b43_lo_calib *cal;
+	struct lo_g_saved_values uninitialized_var(saved_regs);
 	/* Values from the "TXCTL Register and Value Table" */
 	u16 txctl_reg;
 	u16 txctl_value;
 	u16 pad_mix_gain;
 
-	bbatt_list = &lo->bbatt_list;
-	rfatt_list = &lo->rfatt_list;
-#if B43_CALIB_ALL_LOCTLS
-	bbatt_list = &b43_full_bbatt_list;
-	rfatt_list = &b43_full_rfatt_list;
-#endif
+	saved_regs.old_channel = phy->channel;
+	b43_mac_suspend(dev);
+	lo_measure_setup(dev, &saved_regs);
 
 	txctl_reg = lo_txctl_register_table(dev, &txctl_value, &pad_mix_gain);
 
-	for (rfidx = 0; rfidx < rfatt_list->len; rfidx++) {
+	b43_radio_write16(dev, 0x43,
+			  (b43_radio_read16(dev, 0x43) & 0xFFF0)
+			  | rfatt->att);
+	b43_radio_write16(dev, txctl_reg,
+			  (b43_radio_read16(dev, txctl_reg) & ~txctl_value)
+			  | (rfatt->with_padmix) ? txctl_value : 0);
 
-		b43_radio_write16(dev, 0x43, (b43_radio_read16(dev, 0x43)
-					      & 0xFFF0) |
-				  rfatt_list->list[rfidx].att);
-		b43_radio_write16(dev, txctl_reg,
-				  (b43_radio_read16(dev, txctl_reg)
-				   & ~txctl_value)
-				  | (rfatt_list->list[rfidx].with_padmix ?
-				     txctl_value : 0));
-
-		for (bbidx = 0; bbidx < bbatt_list->len; bbidx++) {
-			if (lo->rebuild) {
-#if B43_CALIB_ALL_LOCTLS
-				ploctl = b43_get_lo_g_ctl(dev,
-							  &rfatt_list->list[rfidx],
-							  &bbatt_list->list[bbidx]);
-#else
-				ploctl = b43_get_lo_g_ctl_nopadmix(dev,
-								   &rfatt_list->
-								   list[rfidx],
-								   &bbatt_list->
-								   list[bbidx]);
-#endif
-			} else {
-				ploctl = b43_get_lo_g_ctl(dev,
-							  &rfatt_list->list[rfidx],
-							  &bbatt_list->list[bbidx]);
-				if (!ploctl->used)
-					continue;
-			}
-			memcpy(&loctl, ploctl, sizeof(loctl));
-			loctl.i = 0;
-			loctl.q = 0;
-
-			max_rx_gain = rfatt_list->list[rfidx].att * 2;
-			max_rx_gain += bbatt_list->list[bbidx].att / 2;
-			if (rfatt_list->list[rfidx].with_padmix)
-				max_rx_gain -= pad_mix_gain;
-			if (has_loopback_gain(phy))
-				max_rx_gain += phy->max_lb_gain;
-			lo_measure_gain_values(dev, max_rx_gain,
-					       has_loopback_gain(phy));
-
-			b43_phy_set_baseband_attenuation(dev,
-							 bbatt_list->list[bbidx].att);
-			lo_probe_loctls_statemachine(dev, &loctl, &max_rx_gain);
-			if (phy->type == B43_PHYTYPE_B) {
-				loctl.i++;
-				loctl.q++;
-			}
-			b43_loctl_set_calibrated(&loctl, 1);
-			memcpy(ploctl, &loctl, sizeof(loctl));
-		}
-	}
-}
+	max_rx_gain = rfatt->att * 2;
+	max_rx_gain += bbatt->att / 2;
+	if (rfatt->with_padmix)
+		max_rx_gain -= pad_mix_gain;
+	if (has_loopback_gain(phy))
+		max_rx_gain += phy->max_lb_gain;
+	lo_measure_gain_values(dev, max_rx_gain,
+			       has_loopback_gain(phy));
 
-#if B43_DEBUG
-static void do_validate_loctl(struct b43_wldev *dev, struct b43_loctl *control)
-{
-	const int is_initializing = (b43_status(dev) == B43_STAT_UNINIT);
-	int i = control->i;
-	int q = control->q;
-
-	if (b43_loctl_is_calibrated(control)) {
-		if ((abs(i) > 16) || (abs(q) > 16))
-			goto error;
-	} else {
-		if (control->used)
-			goto error;
-		if (dev->phy.lo_control->rebuild) {
-			control->i = 0;
-			control->q = 0;
-			if ((i != B43_LOCTL_POISON) ||
-			    (q != B43_LOCTL_POISON))
-				goto error;
-		}
-	}
-	if (is_initializing && control->used)
-		goto error;
+	b43_phy_set_baseband_attenuation(dev, bbatt->att);
+	lo_probe_loctls_statemachine(dev, &loctl, &max_rx_gain);
 
-	return;
-error:
-	b43err(dev->wl, "LO control pair validation failed "
-	       "(I: %d, Q: %d, used %u, calib: %u, initing: %d)\n",
-	       i, q, control->used,
-	       b43_loctl_is_calibrated(control),
-	       is_initializing);
-}
+	lo_measure_restore(dev, &saved_regs);
+	b43_mac_enable(dev);
 
-static void validate_all_loctls(struct b43_wldev *dev)
-{
-	b43_call_for_each_loctl(dev, do_validate_loctl);
-}
+	if (b43_debug(dev, B43_DBG_LO)) {
+		b43dbg(dev->wl, "LO: Calibrated for BB(%u), RF(%u,%u) "
+		       "=> I=%d Q=%d\n",
+		       bbatt->att, rfatt->att, rfatt->with_padmix,
+		       loctl.i, loctl.q);
+	}
 
-static void do_reset_calib(struct b43_wldev *dev, struct b43_loctl *control)
-{
-	if (dev->phy.lo_control->rebuild ||
-	    control->used) {
-		b43_loctl_set_calibrated(control, 0);
-		control->i = B43_LOCTL_POISON;
-		control->q = B43_LOCTL_POISON;
+	cal = kmalloc(sizeof(*cal), GFP_KERNEL);
+	if (!cal) {
+		b43warn(dev->wl, "LO calib: out of memory\n");
+		return NULL;
 	}
-}
+	memcpy(&cal->bbatt, bbatt, sizeof(*bbatt));
+	memcpy(&cal->rfatt, rfatt, sizeof(*rfatt));
+	memcpy(&cal->ctl, &loctl, sizeof(loctl));
+	cal->calib_time = jiffies;
+	INIT_LIST_HEAD(&cal->list);
 
-static void reset_all_loctl_calibration_states(struct b43_wldev *dev)
-{
-	b43_call_for_each_loctl(dev, do_reset_calib);
+	return cal;
 }
 
-#else /* B43_DEBUG */
-static inline void validate_all_loctls(struct b43_wldev *dev) { }
-static inline void reset_all_loctl_calibration_states(struct b43_wldev *dev) { }
-#endif /* B43_DEBUG */
+/* Get a calibrated LO setting for the given attenuation values.
+ * Might return a NULL pointer under OOM! */
+static
+struct b43_lo_calib * b43_get_calib_lo_settings(struct b43_wldev *dev,
+						const struct b43_bbatt *bbatt,
+						const struct b43_rfatt *rfatt)
+{
+	struct b43_txpower_lo_control *lo = dev->phy.lo_control;
+	struct b43_lo_calib *c;
+
+	c = b43_find_lo_calib(lo, bbatt, rfatt);
+	if (c)
+		return c;
+	/* Not in the list of calibrated LO settings.
+	 * Calibrate it now. */
+	c = b43_calibrate_lo_setting(dev, bbatt, rfatt);
+	if (!c)
+		return NULL;
+	list_add(&c->list, &lo->calib_list);
+
+	return c;
+}
 
-void b43_lo_g_measure(struct b43_wldev *dev)
+void b43_gphy_dc_lt_init(struct b43_wldev *dev, bool update_all)
 {
 	struct b43_phy *phy = &dev->phy;
-	struct lo_g_saved_values uninitialized_var(sav);
-
-	B43_WARN_ON((phy->type != B43_PHYTYPE_B) &&
-		    (phy->type != B43_PHYTYPE_G));
-
-	sav.old_channel = phy->channel;
-	lo_measure_setup(dev, &sav);
-	reset_all_loctl_calibration_states(dev);
-	lo_measure(dev);
-	lo_measure_restore(dev, &sav);
+	struct b43_txpower_lo_control *lo = phy->lo_control;
+	int i;
+	int rf_offset, bb_offset;
+	const struct b43_rfatt *rfatt;
+	const struct b43_bbatt *bbatt;
+	u64 power_vector;
+	bool table_changed = 0;
 
-	validate_all_loctls(dev);
+	BUILD_BUG_ON(B43_DC_LT_SIZE != 32);
+	B43_WARN_ON(lo->rfatt_list.len * lo->bbatt_list.len > 64);
 
-	phy->lo_control->lo_measured = 1;
-	phy->lo_control->rebuild = 0;
-}
+	power_vector = lo->power_vector;
+	if (!update_all && !power_vector)
+		return; /* Nothing to do. */
 
-#if B43_DEBUG
-static void validate_loctl_calibration(struct b43_wldev *dev,
-				       struct b43_loctl *loctl,
-				       struct b43_rfatt *rfatt,
-				       struct b43_bbatt *bbatt)
-{
-	if (b43_loctl_is_calibrated(loctl))
-		return;
-	if (!dev->phy.lo_control->lo_measured) {
-		/* On init we set the attenuation values before we
-		 * calibrated the LO. I guess that's OK. */
-		return;
+	/* Suspend the MAC now to avoid continuous suspend/enable
+	 * cycles in the loop. */
+	b43_mac_suspend(dev);
+
+	for (i = 0; i < B43_DC_LT_SIZE * 2; i++) {
+		struct b43_lo_calib *cal;
+		int idx;
+		u16 val;
+
+		if (!update_all && !(power_vector & (((u64)1ULL) << i)))
+			continue;
+		/* Update the table entry for this power_vector bit.
+		 * The table rows are RFatt entries and columns are BBatt. */
+		bb_offset = i / lo->rfatt_list.len;
+		rf_offset = i % lo->rfatt_list.len;
+		bbatt = &(lo->bbatt_list.list[bb_offset]);
+		rfatt = &(lo->rfatt_list.list[rf_offset]);
+
+		cal = b43_calibrate_lo_setting(dev, bbatt, rfatt);
+		if (!cal) {
+			b43warn(dev->wl, "LO: Could not "
+				"calibrate DC table entry\n");
+			continue;
+		}
+		/*FIXME: Is Q really in the low nibble? */
+		val = (u8)(cal->ctl.q);
+		val |= ((u8)(cal->ctl.i)) << 4;
+		kfree(cal);
+
+		/* Get the index into the hardware DC LT. */
+		idx = i / 2;
+		/* Change the table in memory. */
+		if (i % 2) {
+			/* Change the high byte. */
+			lo->dc_lt[idx] = (lo->dc_lt[idx] & 0x00FF)
+					 | ((val & 0x00FF) << 8);
+		} else {
+			/* Change the low byte. */
+			lo->dc_lt[idx] = (lo->dc_lt[idx] & 0xFF00)
+					 | (val & 0x00FF);
+		}
+		table_changed = 1;
+	}
+	if (table_changed) {
+		/* The table changed in memory. Update the hardware table. */
+		for (i = 0; i < B43_DC_LT_SIZE; i++)
+			b43_phy_write(dev, 0x3A0 + i, lo->dc_lt[i]);
 	}
-	b43err(dev->wl, "Adjusting Local Oscillator to an uncalibrated "
-	       "control pair: rfatt=%u,%spadmix bbatt=%u\n",
-	       rfatt->att,
-	       (rfatt->with_padmix) ? "" : "no-",
-	       bbatt->att);
+	b43_mac_enable(dev);
 }
-#else
-static inline void validate_loctl_calibration(struct b43_wldev *dev,
-					      struct b43_loctl *loctl,
-					      struct b43_rfatt *rfatt,
-					      struct b43_bbatt *bbatt)
-{
-}
-#endif
 
 static inline void fixup_rfatt_for_txcontrol(struct b43_rfatt *rf,
 					     u8 tx_control)
@@ -1207,15 +923,16 @@ static inline void fixup_rfatt_for_txcon
 void b43_lo_g_adjust(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
+	struct b43_lo_calib *cal;
 	struct b43_rfatt rf;
-	struct b43_loctl *loctl;
 
 	memcpy(&rf, &phy->rfatt, sizeof(rf));
 	fixup_rfatt_for_txcontrol(&rf, phy->tx_control);
 
-	loctl = b43_get_lo_g_ctl(dev, &rf, &phy->bbatt);
-	validate_loctl_calibration(dev, loctl, &rf, &phy->bbatt);
-	b43_lo_write(dev, loctl);
+	cal = b43_get_calib_lo_settings(dev, &phy->bbatt, &rf);
+	if (!cal)
+		return;
+	b43_lo_write(dev, &cal->ctl);
 }
 
 void b43_lo_g_adjust_to(struct b43_wldev *dev,
@@ -1223,39 +940,102 @@ void b43_lo_g_adjust_to(struct b43_wldev
 {
 	struct b43_rfatt rf;
 	struct b43_bbatt bb;
-	struct b43_loctl *loctl;
+	struct b43_lo_calib *cal;
 
 	memset(&rf, 0, sizeof(rf));
 	memset(&bb, 0, sizeof(bb));
 	rf.att = rfatt;
 	bb.att = bbatt;
 	fixup_rfatt_for_txcontrol(&rf, tx_control);
-	loctl = b43_get_lo_g_ctl(dev, &rf, &bb);
-	validate_loctl_calibration(dev, loctl, &rf, &bb);
-	b43_lo_write(dev, loctl);
+	cal = b43_get_calib_lo_settings(dev, &bb, &rf);
+	if (!cal)
+		return;
+	b43_lo_write(dev, &cal->ctl);
 }
 
-static void do_mark_unused(struct b43_wldev *dev, struct b43_loctl *control)
+/* Periodic LO maintanance work */
+void b43_lo_g_maintanance_work(struct b43_wldev *dev)
 {
-	control->used = 0;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_txpower_lo_control *lo = phy->lo_control;
+	unsigned long now;
+	unsigned long expire;
+	struct b43_lo_calib *cal, *tmp;
+	bool current_item_expired = 0;
+	bool hwpctl;
+
+	if (!lo)
+		return;
+	now = jiffies;
+	hwpctl = b43_has_hardware_pctl(phy);
+
+	if (hwpctl) {
+		/* Read the power vector and update it, if needed. */
+		expire = now - B43_LO_PWRVEC_EXPIRE;
+		if (time_before(lo->pwr_vec_read_time, expire)) {
+			lo_read_power_vector(dev);
+			b43_gphy_dc_lt_init(dev, 0);
+		}
+		//FIXME Recalc the whole DC table from time to time?
+	}
+
+	if (hwpctl)
+		return;
+	/* Search for expired LO settings. Remove them.
+	 * Recalibrate the current setting, if expired. */
+	expire = now - B43_LO_CALIB_EXPIRE;
+	list_for_each_entry_safe(cal, tmp, &lo->calib_list, list) {
+		if (!time_before(cal->calib_time, expire))
+			continue;
+		/* This item expired. */
+		if (b43_compare_bbatt(&cal->bbatt, &phy->bbatt) &&
+		    b43_compare_rfatt(&cal->rfatt, &phy->rfatt)) {
+			B43_WARN_ON(current_item_expired);
+			current_item_expired = 1;
+		}
+		if (b43_debug(dev, B43_DBG_LO)) {
+			b43dbg(dev->wl, "LO: Item BB(%u), RF(%u,%u), "
+			       "I=%d, Q=%d expired\n",
+			       cal->bbatt.att, cal->rfatt.att,
+			       cal->rfatt.with_padmix,
+			       cal->ctl.i, cal->ctl.q);
+		}
+		list_del(&cal->list);
+		kfree(cal);
+	}
+	if (current_item_expired || unlikely(list_empty(&lo->calib_list))) {
+		/* Recalibrate currently used LO setting. */
+		if (b43_debug(dev, B43_DBG_LO))
+			b43dbg(dev->wl, "LO: Recalibrating current LO setting\n");
+		cal = b43_calibrate_lo_setting(dev, &phy->bbatt, &phy->rfatt);
+		if (cal) {
+			list_add(&cal->list, &lo->calib_list);
+			b43_lo_write(dev, &cal->ctl);
+		} else
+			b43warn(dev->wl, "Failed to recalibrate current LO setting\n");
+	}
 }
 
-void b43_lo_g_ctl_mark_all_unused(struct b43_wldev *dev)
+void b43_lo_g_cleanup(struct b43_wldev *dev)
 {
-	struct b43_phy *phy = &dev->phy;
-	struct b43_txpower_lo_control *lo = phy->lo_control;
+	struct b43_txpower_lo_control *lo = dev->phy.lo_control;
+	struct b43_lo_calib *cal, *tmp;
 
-	b43_call_for_each_loctl(dev, do_mark_unused);
-	lo->rebuild = 1;
+	if (!lo)
+		return;
+	list_for_each_entry_safe(cal, tmp, &lo->calib_list, list) {
+		list_del(&cal->list);
+		kfree(cal);
+	}
 }
 
-void b43_lo_g_ctl_mark_cur_used(struct b43_wldev *dev)
+/* LO Initialization */
+void b43_lo_g_init(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
-	struct b43_rfatt rf;
-
-	memcpy(&rf, &phy->rfatt, sizeof(rf));
-	fixup_rfatt_for_txcontrol(&rf, phy->tx_control);
 
-	b43_get_lo_g_ctl(dev, &rf, &phy->bbatt)->used = 1;
+	if (b43_has_hardware_pctl(phy)) {
+		lo_read_power_vector(dev);
+		b43_gphy_dc_lt_init(dev, 1);
+	}
 }
diff -puN drivers/net/wireless/b43/lo.h~mm-only-b43-rewrite-lo-calibration drivers/net/wireless/b43/lo.h
--- a/drivers/net/wireless/b43/lo.h~mm-only-b43-rewrite-lo-calibration
+++ a/drivers/net/wireless/b43/lo.h
@@ -10,82 +10,60 @@ struct b43_loctl {
 	/* Control values. */
 	s8 i;
 	s8 q;
-	/* "Used by hardware" flag. */
-	bool used;
-#ifdef CONFIG_B43_DEBUG
-	/* Is this lo-control-array entry calibrated? */
-	bool calibrated;
-#endif
 };
-
 /* Debugging: Poison value for i and q values. */
 #define B43_LOCTL_POISON	111
 
-/* loctl->calibrated debugging mechanism */
-#ifdef CONFIG_B43_DEBUG
-static inline void b43_loctl_set_calibrated(struct b43_loctl *loctl,
-					    bool calibrated)
-{
-	loctl->calibrated = calibrated;
-}
-static inline bool b43_loctl_is_calibrated(struct b43_loctl *loctl)
-{
-	return loctl->calibrated;
-}
-#else
-static inline void b43_loctl_set_calibrated(struct b43_loctl *loctl,
-					    bool calibrated)
-{
-}
-static inline bool b43_loctl_is_calibrated(struct b43_loctl *loctl)
-{
-	return 1;
-}
-#endif
-
-/* TX Power LO Control Array.
- * Value-pairs to adjust the LocalOscillator are stored
- * in this structure.
- * There are two different set of values. One for "Flag is Set"
- * and one for "Flag is Unset".
- * By "Flag" the flag in struct b43_rfatt is meant.
- * The Value arrays are two-dimensional. The first index
- * is the baseband attenuation and the second index
- * is the radio attenuation.
- * Use b43_get_lo_g_ctl() to retrieve a value from the lists.
- */
-struct b43_txpower_lo_control {
-#define B43_NR_BB	12
-#define B43_NR_RF	16
-	/* LO Control values, with PAD Mixer */
-	struct b43_loctl with_padmix[B43_NR_BB][B43_NR_RF];
-	/* LO Control values, without PAD Mixer */
-	struct b43_loctl no_padmix[B43_NR_BB][B43_NR_RF];
-
-	/* Flag to indicate a complete rebuild of the two tables above
-	 * to the LO measuring code. */
-	bool rebuild;
+/* This struct holds calibrated LO settings for a set of
+ * Baseband and RF attenuation settings. */
+struct b43_lo_calib {
+	/* The set of attenuation values this set of LO
+	 * control values is calibrated for. */
+	struct b43_bbatt bbatt;
+	struct b43_rfatt rfatt;
+	/* The set of control values for the LO. */
+	struct b43_loctl ctl;
+	/* The time when these settings were calibrated (in jiffies) */
+	unsigned long calib_time;
+	/* List. */
+	struct list_head list;
+};
+
+/* Size of the DC Lookup Table in 16bit words. */
+#define B43_DC_LT_SIZE		32
 
-	/* Lists of valid RF and BB attenuation values for this device. */
+/* Local Oscillator calibration information */
+struct b43_txpower_lo_control {
+	/* Lists of RF and BB attenuation values for this device.
+	 * Used for building hardware power control tables. */
 	struct b43_rfatt_list rfatt_list;
 	struct b43_bbatt_list bbatt_list;
 
+	/* The DC Lookup Table is cached in memory here.
+	 * Note that this is only used for Hardware Power Control. */
+	u16 dc_lt[B43_DC_LT_SIZE];
+
+	/* List of calibrated control values (struct b43_lo_calib). */
+	struct list_head calib_list;
+	/* Last time the power vector was read (jiffies). */
+	unsigned long pwr_vec_read_time;
+	/* Last time the txctl values were measured (jiffies). */
+	unsigned long txctl_measured_time;
+
 	/* Current TX Bias value */
 	u8 tx_bias;
 	/* Current TX Magnification Value (if used by the device) */
 	u8 tx_magn;
 
-	/* GPHY LO is measured. */
-	bool lo_measured;
-
 	/* Saved device PowerVector */
 	u64 power_vector;
 };
 
-/* Measure the BPHY Local Oscillator. */
-void b43_lo_b_measure(struct b43_wldev *dev);
-/* Measure the BPHY/GPHY Local Oscillator. */
-void b43_lo_g_measure(struct b43_wldev *dev);
+/* Expire times */
+#define B43_LO_CALIB_EXPIRE	(HZ * (90 - 2))
+#define B43_LO_PWRVEC_EXPIRE	(HZ * (90 - 2))
+#define B43_LO_TXCTL_EXPIRE	(HZ * (180 - 4))
+
 
 /* Adjust the Local Oscillator to the saved attenuation
  * and txctl values.
@@ -95,18 +73,10 @@ void b43_lo_g_adjust(struct b43_wldev *d
 void b43_lo_g_adjust_to(struct b43_wldev *dev,
 			u16 rfatt, u16 bbatt, u16 tx_control);
 
-/* Mark all possible b43_lo_g_ctl as "unused" */
-void b43_lo_g_ctl_mark_all_unused(struct b43_wldev *dev);
-/* Mark the b43_lo_g_ctl corresponding to the current
- * attenuation values as used.
- */
-void b43_lo_g_ctl_mark_cur_used(struct b43_wldev *dev);
+void b43_gphy_dc_lt_init(struct b43_wldev *dev, bool update_all);
 
-/* Get a reference to a LO Control value pair in the
- * TX Power LO Control Array.
- */
-struct b43_loctl *b43_get_lo_g_ctl(struct b43_wldev *dev,
-				   const struct b43_rfatt *rfatt,
-				   const struct b43_bbatt *bbatt);
+void b43_lo_g_maintanance_work(struct b43_wldev *dev);
+void b43_lo_g_cleanup(struct b43_wldev *dev);
+void b43_lo_g_init(struct b43_wldev *dev);
 
 #endif /* B43_LO_H_ */
diff -puN drivers/net/wireless/b43/main.c~mm-only-b43-rewrite-lo-calibration drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~mm-only-b43-rewrite-lo-calibration
+++ a/drivers/net/wireless/b43/main.c
@@ -2308,7 +2308,7 @@ static void b43_gpio_cleanup(struct b43_
 }
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
-static void b43_mac_enable(struct b43_wldev *dev)
+void b43_mac_enable(struct b43_wldev *dev)
 {
 	dev->mac_suspended--;
 	B43_WARN_ON(dev->mac_suspended < 0);
@@ -2331,7 +2331,7 @@ static void b43_mac_enable(struct b43_wl
 }
 
 /* http://bcm-specs.sipsolutions.net/SuspendMAC */
-static void b43_mac_suspend(struct b43_wldev *dev)
+void b43_mac_suspend(struct b43_wldev *dev)
 {
 	int i;
 	u32 tmp;
@@ -2503,6 +2503,7 @@ static void b43_chip_exit(struct b43_wld
 {
 	b43_radio_turn_off(dev, 1);
 	b43_gpio_cleanup(dev);
+	b43_lo_g_cleanup(dev);
 	/* firmware is released later */
 }
 
@@ -2609,28 +2610,12 @@ err_gpio_clean:
 	return err;
 }
 
-static void b43_periodic_every120sec(struct b43_wldev *dev)
-{
-	struct b43_phy *phy = &dev->phy;
-
-	if (phy->type != B43_PHYTYPE_G || phy->rev < 2)
-		return;
-
-	b43_mac_suspend(dev);
-	b43_lo_g_measure(dev);
-	b43_mac_enable(dev);
-	if (b43_has_hardware_pctl(phy))
-		b43_lo_g_ctl_mark_all_unused(dev);
-}
-
 static void b43_periodic_every60sec(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 
 	if (phy->type != B43_PHYTYPE_G)
 		return;
-	if (!b43_has_hardware_pctl(phy))
-		b43_lo_g_ctl_mark_all_unused(dev);
 	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI) {
 		b43_mac_suspend(dev);
 		b43_calc_nrssi_slope(dev);
@@ -2682,6 +2667,7 @@ static void b43_periodic_every15sec(stru
 		}
 	}
 	b43_phy_xmitpower(dev);	//FIXME: unless scanning?
+	b43_lo_g_maintanance_work(dev);
 	//TODO for APHY (temperature?)
 
 	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
@@ -2693,8 +2679,6 @@ static void do_periodic_work(struct b43_
 	unsigned int state;
 
 	state = dev->periodic_state;
-	if (state % 8 == 0)
-		b43_periodic_every120sec(dev);
 	if (state % 4 == 0)
 		b43_periodic_every60sec(dev);
 	if (state % 2 == 0)
@@ -3668,8 +3652,8 @@ static void setup_struct_phy_for_init(st
 	lo = phy->lo_control;
 	if (lo) {
 		memset(lo, 0, sizeof(*(phy->lo_control)));
-		lo->rebuild = 1;
 		lo->tx_bias = 0xFF;
+		INIT_LIST_HEAD(&lo->calib_list);
 	}
 	phy->max_lb_gain = 0;
 	phy->trsw_rx_gain = 0;
diff -puN drivers/net/wireless/b43/main.h~mm-only-b43-rewrite-lo-calibration drivers/net/wireless/b43/main.h
--- a/drivers/net/wireless/b43/main.h~mm-only-b43-rewrite-lo-calibration
+++ a/drivers/net/wireless/b43/main.h
@@ -114,4 +114,7 @@ void b43_controller_restart(struct b43_w
 #define B43_PS_ASLEEP	(1 << 3)	/* Force device asleep */
 void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags);
 
+void b43_mac_suspend(struct b43_wldev *dev);
+void b43_mac_enable(struct b43_wldev *dev);
+
 #endif /* B43_MAIN_H_ */
diff -puN drivers/net/wireless/b43/phy.c~mm-only-b43-rewrite-lo-calibration drivers/net/wireless/b43/phy.c
--- a/drivers/net/wireless/b43/phy.c~mm-only-b43-rewrite-lo-calibration
+++ a/drivers/net/wireless/b43/phy.c
@@ -559,11 +559,6 @@ static void b43_gphy_gain_lt_init(struct
 	u16 tmp;
 	u8 rf, bb;
 
-	if (!lo->lo_measured) {
-		b43_phy_write(dev, 0x3FF, 0);
-		return;
-	}
-
 	for (rf = 0; rf < lo->rfatt_list.len; rf++) {
 		for (bb = 0; bb < lo->bbatt_list.len; bb++) {
 			if (nr_written >= 0x40)
@@ -581,42 +576,6 @@ static void b43_gphy_gain_lt_init(struct
 	}
 }
 
-/* GPHY_DC_Lookup_Table */
-void b43_gphy_dc_lt_init(struct b43_wldev *dev)
-{
-	struct b43_phy *phy = &dev->phy;
-	struct b43_txpower_lo_control *lo = phy->lo_control;
-	struct b43_loctl *loctl0;
-	struct b43_loctl *loctl1;
-	int i;
-	int rf_offset, bb_offset;
-	u16 tmp;
-
-	for (i = 0; i < lo->rfatt_list.len + lo->bbatt_list.len; i += 2) {
-		rf_offset = i / lo->rfatt_list.len;
-		bb_offset = i % lo->rfatt_list.len;
-
-		loctl0 = b43_get_lo_g_ctl(dev, &lo->rfatt_list.list[rf_offset],
-					  &lo->bbatt_list.list[bb_offset]);
-		if (i + 1 < lo->rfatt_list.len * lo->bbatt_list.len) {
-			rf_offset = (i + 1) / lo->rfatt_list.len;
-			bb_offset = (i + 1) % lo->rfatt_list.len;
-
-			loctl1 =
-			    b43_get_lo_g_ctl(dev,
-					     &lo->rfatt_list.list[rf_offset],
-					     &lo->bbatt_list.list[bb_offset]);
-		} else
-			loctl1 = loctl0;
-
-		tmp = ((u16) loctl0->q & 0xF);
-		tmp |= ((u16) loctl0->i & 0xF) << 4;
-		tmp |= ((u16) loctl1->q & 0xF) << 8;
-		tmp |= ((u16) loctl1->i & 0xF) << 12;	//FIXME?
-		b43_phy_write(dev, 0x3A0 + (i / 2), tmp);
-	}
-}
-
 static void hardware_pctl_init_aphy(struct b43_wldev *dev)
 {
 	//TODO
@@ -643,7 +602,7 @@ static void hardware_pctl_init_gphy(stru
 	b43_phy_write(dev, 0x0801, b43_phy_read(dev, 0x0801)
 		      & 0xFFBF);
 
-	b43_gphy_dc_lt_init(dev);
+	b43_gphy_dc_lt_init(dev, 1);
 }
 
 /* HardwarePowerControl init for A and G PHY */
@@ -967,7 +926,7 @@ static void b43_phy_initb2(struct b43_wl
 	b43_phy_write(dev, 0x0032, 0x00CA);
 	b43_phy_write(dev, 0x0032, 0x00CC);
 	b43_phy_write(dev, 0x0035, 0x07C2);
-	b43_lo_b_measure(dev);
+//XXX won't trigger	b43_lo_b_measure(dev);
 	b43_phy_write(dev, 0x0026, 0xCC00);
 	if (phy->radio_ver != 0x2050)
 		b43_phy_write(dev, 0x0026, 0xCE00);
@@ -1017,7 +976,7 @@ static void b43_phy_initb4(struct b43_wl
 		b43_phy_write(dev, 0x0032, 0x00E0);
 	b43_phy_write(dev, 0x0035, 0x07C2);
 
-	b43_lo_b_measure(dev);
+//XXX won't trigger	b43_lo_b_measure(dev);
 
 	b43_phy_write(dev, 0x0026, 0xCC00);
 	if (phy->radio_ver == 0x2050)
@@ -1259,19 +1218,9 @@ static void b43_phy_initb6(struct b43_wl
 		b43_phy_write(dev, 0x0002, (b43_phy_read(dev, 0x0002) & 0xFFC0)
 			      | 0x0004);
 	}
-	if (phy->type == B43_PHYTYPE_B) {
-		b43_write16(dev, 0x03E6, 0x8140);
-		b43_phy_write(dev, 0x0016, 0x0410);
-		b43_phy_write(dev, 0x0017, 0x0820);
-		b43_phy_write(dev, 0x0062, 0x0007);
-		b43_radio_init2050(dev);
-		b43_lo_g_measure(dev);
-		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI) {
-			b43_calc_nrssi_slope(dev);
-			b43_calc_nrssi_threshold(dev);
-		}
-		b43_phy_init_pctl(dev);
-	} else if (phy->type == B43_PHYTYPE_G)
+	if (phy->type == B43_PHYTYPE_B)
+		B43_WARN_ON(1);
+	else if (phy->type == B43_PHYTYPE_G)
 		b43_write16(dev, 0x03E6, 0x0);
 }
 
@@ -1534,34 +1483,31 @@ static void b43_phy_initg(struct b43_wld
 		else
 			b43_radio_write16(dev, 0x0078, phy->initval);
 	}
-	if (phy->lo_control->tx_bias == 0xFF) {
-		b43_lo_g_measure(dev);
+	b43_lo_g_init(dev);
+	if (has_tx_magnification(phy)) {
+		b43_radio_write16(dev, 0x52,
+				  (b43_radio_read16(dev, 0x52) & 0xFF00)
+				  | phy->lo_control->tx_bias | phy->
+				  lo_control->tx_magn);
 	} else {
-		if (has_tx_magnification(phy)) {
-			b43_radio_write16(dev, 0x52,
-					  (b43_radio_read16(dev, 0x52) & 0xFF00)
-					  | phy->lo_control->tx_bias | phy->
-					  lo_control->tx_magn);
-		} else {
-			b43_radio_write16(dev, 0x52,
-					  (b43_radio_read16(dev, 0x52) & 0xFFF0)
-					  | phy->lo_control->tx_bias);
-		}
-		if (phy->rev >= 6) {
-			b43_phy_write(dev, B43_PHY_CCK(0x36),
-				      (b43_phy_read(dev, B43_PHY_CCK(0x36))
-				       & 0x0FFF) | (phy->lo_control->
-						    tx_bias << 12));
-		}
-		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
-			b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x8075);
-		else
-			b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x807F);
-		if (phy->rev < 2)
-			b43_phy_write(dev, B43_PHY_CCK(0x2F), 0x101);
-		else
-			b43_phy_write(dev, B43_PHY_CCK(0x2F), 0x202);
+		b43_radio_write16(dev, 0x52,
+				  (b43_radio_read16(dev, 0x52) & 0xFFF0)
+				  | phy->lo_control->tx_bias);
+	}
+	if (phy->rev >= 6) {
+		b43_phy_write(dev, B43_PHY_CCK(0x36),
+			      (b43_phy_read(dev, B43_PHY_CCK(0x36))
+			       & 0x0FFF) | (phy->lo_control->
+					    tx_bias << 12));
 	}
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
+		b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x8075);
+	else
+		b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x807F);
+	if (phy->rev < 2)
+		b43_phy_write(dev, B43_PHY_CCK(0x2F), 0x101);
+	else
+		b43_phy_write(dev, B43_PHY_CCK(0x2F), 0x202);
 	if (phy->gmode || phy->rev >= 2) {
 		b43_lo_g_adjust(dev);
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0x8078);
@@ -1821,10 +1767,8 @@ void b43_phy_xmitpower(struct b43_wldev 
 			bbatt_delta -= 4 * rfatt_delta;
 
 			/* So do we finally need to adjust something? */
-			if ((rfatt_delta == 0) && (bbatt_delta == 0)) {
-				b43_lo_g_ctl_mark_cur_used(dev);
+			if ((rfatt_delta == 0) && (bbatt_delta == 0))
 				return;
-			}
 
 			/* Calculate the new attenuation values. */
 			bbatt = phy->bbatt.att;
@@ -1870,7 +1814,6 @@ void b43_phy_xmitpower(struct b43_wldev 
 			b43_radio_lock(dev);
 			b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt,
 					  phy->tx_control);
-			b43_lo_g_ctl_mark_cur_used(dev);
 			b43_radio_unlock(dev);
 			b43_phy_unlock(dev);
 			break;
diff -puN drivers/net/wireless/b43/phy.h~mm-only-b43-rewrite-lo-calibration drivers/net/wireless/b43/phy.h
--- a/drivers/net/wireless/b43/phy.h~mm-only-b43-rewrite-lo-calibration
+++ a/drivers/net/wireless/b43/phy.h
@@ -225,7 +225,6 @@ int b43_phy_init(struct b43_wldev *dev);
 void b43_set_rx_antenna(struct b43_wldev *dev, int antenna);
 
 void b43_phy_xmitpower(struct b43_wldev *dev);
-void b43_gphy_dc_lt_init(struct b43_wldev *dev);
 
 /* Returns the boolean whether the board has HardwarePowerControl */
 bool b43_has_hardware_pctl(struct b43_phy *phy);
@@ -252,6 +251,14 @@ struct b43_rfatt_list {
 	u8 max_val;
 };
 
+/* Returns true, if the values are the same. */
+static inline bool b43_compare_rfatt(const struct b43_rfatt *a,
+				     const struct b43_rfatt *b)
+{
+	return ((a->att == b->att) &&
+		(a->with_padmix == b->with_padmix));
+}
+
 /* Baseband Attenuation */
 struct b43_bbatt {
 	u8 att;			/* Attenuation value */
@@ -265,6 +272,13 @@ struct b43_bbatt_list {
 	u8 max_val;
 };
 
+/* Returns true, if the values are the same. */
+static inline bool b43_compare_bbatt(const struct b43_bbatt *a,
+				     const struct b43_bbatt *b)
+{
+	return (a->att == b->att);
+}
+
 /* tx_control bits. */
 #define B43_TXCTL_PA3DB		0x40	/* PA Gain 3dB */
 #define B43_TXCTL_PA2DB		0x20	/* PA Gain 2dB */
_

Patches currently in -mm which might be from mb@bu3sch.de are

linux-next.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch

