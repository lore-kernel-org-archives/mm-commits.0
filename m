From: akpm@linux-foundation.org
Subject: + b43legacy-replace-limit_value-macro-with-clamp_val.patch added to -mm tree
Date: Fri, 14 Mar 2008 12:48:19 -0700
Message-ID: <200803141948.m2EJmJOc016312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbYCNTuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 15:50:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linville@tuxdriver.com, mb@bu3sch.de


The patch titled
     b43legacy: replace limit_value macro with clamp_val
has been added to the -mm tree.  Its filename is
     b43legacy-replace-limit_value-macro-with-clamp_val.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: b43legacy: replace limit_value macro with clamp_val
From: Harvey Harrison <harvey.harrison@gmail.com>

kernel-provided clamp_val is identical, delete the private limit_value helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43legacy/b43legacy.h |   17 -----------------
 drivers/net/wireless/b43legacy/main.c      |    8 ++++----
 drivers/net/wireless/b43legacy/phy.c       |   14 +++++++-------
 drivers/net/wireless/b43legacy/radio.c     |   12 ++++++------
 4 files changed, 17 insertions(+), 34 deletions(-)

diff -puN drivers/net/wireless/b43legacy/b43legacy.h~b43legacy-replace-limit_value-macro-with-clamp_val drivers/net/wireless/b43legacy/b43legacy.h
--- a/drivers/net/wireless/b43legacy/b43legacy.h~b43legacy-replace-limit_value-macro-with-clamp_val
+++ a/drivers/net/wireless/b43legacy/b43legacy.h
@@ -814,23 +814,6 @@ void b43legacydbg(struct b43legacy_wl *w
 # define b43legacydbg(wl, fmt...) do { /* nothing */ } while (0)
 #endif /* DEBUG */
 
-
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
 /* Macros for printing a value in Q5.2 format */
 #define Q52_FMT		"%u.%u"
 #define Q52_ARG(q52)	((q52) / 4), (((q52) & 3) * 100 / 4)
diff -puN drivers/net/wireless/b43legacy/main.c~b43legacy-replace-limit_value-macro-with-clamp_val drivers/net/wireless/b43legacy/main.c
--- a/drivers/net/wireless/b43legacy/main.c~b43legacy-replace-limit_value-macro-with-clamp_val
+++ a/drivers/net/wireless/b43legacy/main.c
@@ -839,10 +839,10 @@ static void handle_irq_noise(struct b43l
 	/* Get the noise samples. */
 	B43legacy_WARN_ON(dev->noisecalc.nr_samples >= 8);
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
diff -puN drivers/net/wireless/b43legacy/phy.c~b43legacy-replace-limit_value-macro-with-clamp_val drivers/net/wireless/b43legacy/phy.c
--- a/drivers/net/wireless/b43legacy/phy.c~b43legacy-replace-limit_value-macro-with-clamp_val
+++ a/drivers/net/wireless/b43legacy/phy.c
@@ -1088,7 +1088,7 @@ static void b43legacy_phy_initg(struct b
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
 		 * Essentially, what we do here is resetting all NRSSI LT
-		 * entries to -32 (see the limit_value() in nrssi_hw_update())
+		 * entries to -32 (see the clamp_val() in nrssi_hw_update())
 		 */
 		b43legacy_nrssi_hw_update(dev, 0xFFFF);
 		b43legacy_calc_nrssi_threshold(dev);
@@ -1756,7 +1756,7 @@ static s8 b43legacy_phy_estimate_power_o
 	switch (phy->type) {
 	case B43legacy_PHYTYPE_B:
 	case B43legacy_PHYTYPE_G:
-		tmp = limit_value(tmp, 0x00, 0x3F);
+		tmp = clamp_val(tmp, 0x00, 0x3F);
 		dbm = phy->tssi2dbm[tmp];
 		break;
 	default:
@@ -1859,7 +1859,7 @@ void b43legacy_phy_xmitpower(struct b43l
 
 	/* find the desired power in Q5.2 - power_level is in dBm
 	 * and limit it - max_pwr is already in Q5.2 */
-	desired_pwr = limit_value(phy->power_level << 2, 0, max_pwr);
+	desired_pwr = clamp_val(phy->power_level << 2, 0, max_pwr);
 	if (b43legacy_debug(dev, B43legacy_DBG_XMITPOWER))
 		b43legacydbg(dev->wl, "Current TX power output: " Q52_FMT
 		       " dBm, Desired TX power output: " Q52_FMT
@@ -1905,7 +1905,7 @@ void b43legacy_phy_xmitpower(struct b43l
 			radio_attenuation++;
 		}
 	}
-	baseband_attenuation = limit_value(baseband_attenuation, 0, 11);
+	baseband_attenuation = clamp_val(baseband_attenuation, 0, 11);
 
 	txpower = phy->txctl1;
 	if ((phy->radio_ver == 0x2050) && (phy->radio_rev == 2)) {
@@ -1933,8 +1933,8 @@ void b43legacy_phy_xmitpower(struct b43l
 	}
 	/* Save the control values */
 	phy->txctl1 = txpower;
-	baseband_attenuation = limit_value(baseband_attenuation, 0, 11);
-	radio_attenuation = limit_value(radio_attenuation, 0, 9);
+	baseband_attenuation = clamp_val(baseband_attenuation, 0, 11);
+	radio_attenuation = clamp_val(radio_attenuation, 0, 9);
 	phy->rfatt = radio_attenuation;
 	phy->bbatt = baseband_attenuation;
 
@@ -1979,7 +1979,7 @@ s8 b43legacy_tssi2dbm_entry(s8 entry [],
 		f = q;
 		i++;
 	} while (delta >= 2);
-	entry[index] = limit_value(b43legacy_tssi2dbm_ad(m1 * f, 8192),
+	entry[index] = clamp_val(b43legacy_tssi2dbm_ad(m1 * f, 8192),
 				   -127, 128);
 	return 0;
 }
diff -puN drivers/net/wireless/b43legacy/radio.c~b43legacy-replace-limit_value-macro-with-clamp_val drivers/net/wireless/b43legacy/radio.c
--- a/drivers/net/wireless/b43legacy/radio.c~b43legacy-replace-limit_value-macro-with-clamp_val
+++ a/drivers/net/wireless/b43legacy/radio.c
@@ -357,7 +357,7 @@ void b43legacy_nrssi_hw_update(struct b4
 	for (i = 0; i < 64; i++) {
 		tmp = b43legacy_nrssi_hw_read(dev, i);
 		tmp -= val;
-		tmp = limit_value(tmp, -32, 31);
+		tmp = clamp_val(tmp, -32, 31);
 		b43legacy_nrssi_hw_write(dev, i, tmp);
 	}
 }
@@ -375,7 +375,7 @@ void b43legacy_nrssi_mem_update(struct b
 		tmp = (i - delta) * phy->nrssislope;
 		tmp /= 0x10000;
 		tmp += 0x3A;
-		tmp = limit_value(tmp, 0, 0x3F);
+		tmp = clamp_val(tmp, 0, 0x3F);
 		phy->nrssi_lt[i] = tmp;
 	}
 }
@@ -839,7 +839,7 @@ void b43legacy_calc_nrssi_threshold(stru
 		} else
 			threshold = phy->nrssi[1] - 5;
 
-		threshold = limit_value(threshold, 0, 0x3E);
+		threshold = clamp_val(threshold, 0, 0x3E);
 		b43legacy_phy_read(dev, 0x0020); /* dummy read */
 		b43legacy_phy_write(dev, 0x0020, (((u16)threshold) << 8)
 				    | 0x001C);
@@ -892,7 +892,7 @@ void b43legacy_calc_nrssi_threshold(stru
 			else
 				a += 32;
 			a = a >> 6;
-			a = limit_value(a, -31, 31);
+			a = clamp_val(a, -31, 31);
 
 			b = b * (phy->nrssi[1] - phy->nrssi[0]);
 			b += (phy->nrssi[0] << 6);
@@ -901,7 +901,7 @@ void b43legacy_calc_nrssi_threshold(stru
 			else
 				b += 32;
 			b = b >> 6;
-			b = limit_value(b, -31, 31);
+			b = clamp_val(b, -31, 31);
 
 			tmp_u16 = b43legacy_phy_read(dev, 0x048A) & 0xF000;
 			tmp_u16 |= ((u32)b & 0x0000003F);
@@ -1905,7 +1905,7 @@ void b43legacy_radio_set_txpower_a(struc
 	u16 dac;
 	u16 ilt;
 
-	txpower = limit_value(txpower, 0, 63);
+	txpower = clamp_val(txpower, 0, 63);
 
 	pamp = b43legacy_get_txgain_freq_power_amp(txpower);
 	pamp <<= 5;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
git-acpi.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-cifs.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
git-async-tx.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

