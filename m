From: akpm@linux-foundation.org
Subject: + wireless-use-get-put_unaligned_-helpers.patch added to -mm tree
Date: Tue, 15 Apr 2008 15:22:18 -0700
Message-ID: <200804152222.m3FMMJSe018806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932313AbYDOW1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 18:27:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dsd@gentoo.org, linville@tuxdriver.com, mb@bu3sch.de, viro@zeniv.linux.org.uk


The patch titled
     wireless: use get/put_unaligned_* helpers
has been added to the -mm tree.  Its filename is
     wireless-use-get-put_unaligned_-helpers.patch

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
Subject: wireless: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Daniel Drake <dsd@gentoo.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/airo.c             |    2 -
 drivers/net/wireless/ath5k/base.c       |    8 +----
 drivers/net/wireless/b43/main.c         |    2 -
 drivers/net/wireless/b43legacy/main.c   |    2 -
 drivers/net/wireless/iwlwifi/iwl-3945.c |   32 +++++++++-------------
 drivers/net/wireless/libertas/scan.c    |    2 -
 drivers/net/wireless/zd1211rw/zd_usb.c  |    4 +-
 7 files changed, 22 insertions(+), 30 deletions(-)

diff -puN drivers/net/wireless/airo.c~wireless-use-get-put_unaligned_-helpers drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~wireless-use-get-put_unaligned_-helpers
+++ a/drivers/net/wireless/airo.c
@@ -3657,7 +3657,7 @@ void mpi_receive_802_11 (struct airo_inf
 	ptr += hdrlen;
 	if (hdrlen == 24)
 		ptr += 6;
-	gap = le16_to_cpu(get_unaligned((__le16 *)ptr));
+	gap = get_unaligned_le16(ptr);
 	ptr += sizeof(__le16);
 	if (gap) {
 		if (gap <= 8)
diff -puN drivers/net/wireless/ath5k/base.c~wireless-use-get-put_unaligned_-helpers drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~wireless-use-get-put_unaligned_-helpers
+++ a/drivers/net/wireless/ath5k/base.c
@@ -58,10 +58,6 @@
 #include "reg.h"
 #include "debug.h"
 
-/* unaligned little endian access */
-#define LE_READ_2(_p) (le16_to_cpu(get_unaligned((__le16 *)(_p))))
-#define LE_READ_4(_p) (le32_to_cpu(get_unaligned((__le32 *)(_p))))
-
 enum {
 	ATH_LED_TX,
 	ATH_LED_RX,
@@ -2903,9 +2899,9 @@ static void ath5k_configure_filter(struc
 			if (!mclist)
 				break;
 			/* calculate XOR of eight 6-bit values */
-			val = LE_READ_4(mclist->dmi_addr + 0);
+			val = get_unaligned_le32(mclist->dmi_addr + 0);
 			pos = (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
-			val = LE_READ_4(mclist->dmi_addr + 3);
+			val = get_unaligned_le32(mclist->dmi_addr + 3);
 			pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
 			pos &= 0x3f;
 			mfilt[pos / 32] |= (1 << (pos % 32));
diff -puN drivers/net/wireless/b43/main.c~wireless-use-get-put_unaligned_-helpers drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~wireless-use-get-put_unaligned_-helpers
+++ a/drivers/net/wireless/b43/main.c
@@ -2167,7 +2167,7 @@ static int b43_write_initvals(struct b43
 				goto err_format;
 			array_size -= sizeof(iv->data.d32);
 
-			value = be32_to_cpu(get_unaligned(&iv->data.d32));
+			value = get_unaligned_be32(&iv->data.d32);
 			b43_write32(dev, offset, value);
 
 			iv = (const struct b43_iv *)((const uint8_t *)iv +
diff -puN drivers/net/wireless/b43legacy/main.c~wireless-use-get-put_unaligned_-helpers drivers/net/wireless/b43legacy/main.c
--- a/drivers/net/wireless/b43legacy/main.c~wireless-use-get-put_unaligned_-helpers
+++ a/drivers/net/wireless/b43legacy/main.c
@@ -1718,7 +1718,7 @@ static int b43legacy_write_initvals(stru
 				goto err_format;
 			array_size -= sizeof(iv->data.d32);
 
-			value = be32_to_cpu(get_unaligned(&iv->data.d32));
+			value = get_unaligned_be32(&iv->data.d32);
 			b43legacy_write32(dev, offset, value);
 
 			iv = (const struct b43legacy_iv *)((const uint8_t *)iv +
diff -puN drivers/net/wireless/iwlwifi/iwl-3945.c~wireless-use-get-put_unaligned_-helpers drivers/net/wireless/iwlwifi/iwl-3945.c
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c~wireless-use-get-put_unaligned_-helpers
+++ a/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -554,40 +554,36 @@ static void iwl3945_add_radiotap(struct 
 	iwl3945_rt->rt_hdr.it_pad = 0;
 
 	/* total header + data */
-	put_unaligned(cpu_to_le16(sizeof(*iwl3945_rt)),
-		      &iwl3945_rt->rt_hdr.it_len);
+	put_unaligned_le16(sizeof(*iwl3945_rt), &iwl3945_rt->rt_hdr.it_len);
 
 	/* Indicate all the fields we add to the radiotap header */
-	put_unaligned(cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
-				  (1 << IEEE80211_RADIOTAP_FLAGS) |
-				  (1 << IEEE80211_RADIOTAP_RATE) |
-				  (1 << IEEE80211_RADIOTAP_CHANNEL) |
-				  (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
-				  (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
-				  (1 << IEEE80211_RADIOTAP_ANTENNA)),
-		      &iwl3945_rt->rt_hdr.it_present);
+	put_unaligned_le32((1 << IEEE80211_RADIOTAP_TSFT) |
+			   (1 << IEEE80211_RADIOTAP_FLAGS) |
+			   (1 << IEEE80211_RADIOTAP_RATE) |
+			   (1 << IEEE80211_RADIOTAP_CHANNEL) |
+			   (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
+			   (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
+			   (1 << IEEE80211_RADIOTAP_ANTENNA)),
+			&iwl3945_rt->rt_hdr.it_present);
 
 	/* Zero the flags, we'll add to them as we go */
 	iwl3945_rt->rt_flags = 0;
 
-	put_unaligned(cpu_to_le64(tsf), &iwl3945_rt->rt_tsf);
+	put_unaligned_le64(tsf, &iwl3945_rt->rt_tsf);
 
 	iwl3945_rt->rt_dbmsignal = signal;
 	iwl3945_rt->rt_dbmnoise = noise;
 
 	/* Convert the channel frequency and set the flags */
-	put_unaligned(cpu_to_le16(stats->freq), &iwl3945_rt->rt_channelMHz);
+	put_unaligned_le16(stats->freq, &iwl3945_rt->rt_channelMHz);
 	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
-		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
-					  IEEE80211_CHAN_5GHZ),
+		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ,
 			      &iwl3945_rt->rt_chbitmask);
 	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
-		put_unaligned(cpu_to_le16(IEEE80211_CHAN_CCK |
-					  IEEE80211_CHAN_2GHZ),
+		put_unaligned_le16(IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ,
 			      &iwl3945_rt->rt_chbitmask);
 	else	/* 802.11g */
-		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
-					  IEEE80211_CHAN_2GHZ),
+		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
 			      &iwl3945_rt->rt_chbitmask);
 
 	if (rate == -1)
diff -puN drivers/net/wireless/libertas/scan.c~wireless-use-get-put_unaligned_-helpers drivers/net/wireless/libertas/scan.c
--- a/drivers/net/wireless/libertas/scan.c~wireless-use-get-put_unaligned_-helpers
+++ a/drivers/net/wireless/libertas/scan.c
@@ -522,7 +522,7 @@ static int lbs_process_bss(struct bss_de
 
 	if (*bytesleft >= sizeof(beaconsize)) {
 		/* Extract & convert beacon size from the command buffer */
-		beaconsize = le16_to_cpu(get_unaligned((__le16 *)*pbeaconinfo));
+		beaconsize = get_unaligned_le16(*pbeaconinfo);
 		*bytesleft -= sizeof(beaconsize);
 		*pbeaconinfo += sizeof(beaconsize);
 	}
diff -puN drivers/net/wireless/zd1211rw/zd_usb.c~wireless-use-get-put_unaligned_-helpers drivers/net/wireless/zd1211rw/zd_usb.c
--- a/drivers/net/wireless/zd1211rw/zd_usb.c~wireless-use-get-put_unaligned_-helpers
+++ a/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -545,11 +545,11 @@ static void handle_rx_packet(struct zd_u
 	 * be padded. Unaligned access might also happen if the length_info
 	 * structure is not present.
 	 */
-	if (get_unaligned(&length_info->tag) == cpu_to_le16(RX_LENGTH_INFO_TAG))
+	if (get_unaligned_le16(&length_info->tag) == RX_LENGTH_INFO_TAG)
 	{
 		unsigned int l, k, n;
 		for (i = 0, l = 0;; i++) {
-			k = le16_to_cpu(get_unaligned(&length_info->length[i]));
+			k = get_unaligned_le16(&length_info->length[i]);
 			if (k == 0)
 				return;
 			n = l+k;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-libata-all.patch
git-mips.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
git-s390.patch
git-scsi-misc.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mac80211-michaelc-replace-macro-with-function.patch
mac80211-michaelc-use-unaligned-byteorder-helpers.patch
mac80211-michaelc-fold-initial-xor-into-block-helper.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
input-replace-remaining-__function__-occurrences.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
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
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
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
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
radio-use-get-put_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

