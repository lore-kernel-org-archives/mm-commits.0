From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 29 Aug 2011 12:12:10 -0700
Message-ID: <201108291908.p7TJ8dkL017345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830Ab1H2TJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 15:09:11 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p7TJ8et7025886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2011 12:08:40 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/patch_realtek.c |   25 ---
 sound/soc/soc-io.c            |  230 --------------------------------
 2 files changed, 255 deletions(-)

diff -puN sound/pci/hda/patch_realtek.c~linux-next-git-rejects sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~linux-next-git-rejects
+++ a/sound/pci/hda/patch_realtek.c
@@ -584,11 +584,7 @@ static void alc_hp_automute(struct hda_c
 			     spec->autocfg.hp_pins);
 	if (!spec->automute)
 		return;
-<<<<<<< HEAD
-	update_speakers(codec);
-=======
 	call_update_speakers(codec);
->>>>>>> linux-next/akpm-end
 }
 
 /* standard line-out-automute helper */
@@ -601,11 +597,7 @@ static void alc_line_automute(struct hda
 			     spec->autocfg.line_out_pins);
 	if (!spec->automute || !spec->detect_line)
 		return;
-<<<<<<< HEAD
-	update_speakers(codec);
-=======
 	call_update_speakers(codec);
->>>>>>> linux-next/akpm-end
 }
 
 #define get_connection_index(codec, mux, nid) \
@@ -3249,22 +3241,6 @@ static void alc_auto_init_multi_out(stru
 static void alc_auto_init_extra_out(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
-<<<<<<< HEAD
-	hda_nid_t pin, dac;
-
-	pin = spec->autocfg.hp_pins[0];
-	if (pin) {
-		dac = spec->multiout.hp_nid;
-		if (!dac)
-			dac = spec->multiout.dac_nids[0];
-		alc_auto_set_output_and_unmute(codec, pin, PIN_HP, dac);
-	}
-	pin = spec->autocfg.speaker_pins[0];
-	if (pin) {
-		dac = spec->multiout.extra_out_nid[0];
-		if (!dac)
-			dac = spec->multiout.dac_nids[0];
-=======
 	int i;
 	hda_nid_t pin, dac;
 
@@ -3292,7 +3268,6 @@ static void alc_auto_init_extra_out(stru
 			else
 				dac = spec->multiout.dac_nids[0];
 		}
->>>>>>> linux-next/akpm-end
 		alc_auto_set_output_and_unmute(codec, pin, PIN_OUT, dac);
 	}
 }
diff -puN sound/soc/soc-io.c~linux-next-git-rejects sound/soc/soc-io.c
--- a/sound/soc/soc-io.c~linux-next-git-rejects
+++ a/sound/soc/soc-io.c
@@ -64,194 +64,6 @@ static unsigned int hw_read(struct snd_s
 	return val;
 }
 
-<<<<<<< HEAD
-static int snd_soc_4_12_write(struct snd_soc_codec *codec, unsigned int reg,
-			      unsigned int value)
-{
-	u16 data;
-
-	data = cpu_to_be16((reg << 12) | (value & 0xffffff));
-
-	return do_hw_write(codec, reg, value, &data, 2);
-}
-
-static int snd_soc_7_9_write(struct snd_soc_codec *codec, unsigned int reg,
-			     unsigned int value)
-{
-	u16 data;
-
-	data = cpu_to_be16((reg << 9) | (value & 0x1ff));
-
-	return do_hw_write(codec, reg, value, &data, 2);
-}
-
-static int snd_soc_8_8_write(struct snd_soc_codec *codec, unsigned int reg,
-			     unsigned int value)
-{
-	u8 data[2];
-
-	reg &= 0xff;
-	data[0] = reg;
-	data[1] = value & 0xff;
-
-	return do_hw_write(codec, reg, value, data, 2);
-}
-
-static int snd_soc_8_16_write(struct snd_soc_codec *codec, unsigned int reg,
-			      unsigned int value)
-{
-	u8 data[3];
-	u16 val = cpu_to_be16(value);
-
-	data[0] = reg;
-	memcpy(&data[1], &val, sizeof(val));
-
-	return do_hw_write(codec, reg, value, data, 3);
-}
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int do_i2c_read(struct snd_soc_codec *codec,
-				void *reg, int reglen,
-				void *data, int datalen)
-{
-	struct i2c_msg xfer[2];
-	int ret;
-	struct i2c_client *client = codec->control_data;
-
-	/* Write register */
-	xfer[0].addr = client->addr;
-	xfer[0].flags = 0;
-	xfer[0].len = reglen;
-	xfer[0].buf = reg;
-
-	/* Read data */
-	xfer[1].addr = client->addr;
-	xfer[1].flags = I2C_M_RD;
-	xfer[1].len = datalen;
-	xfer[1].buf = data;
-
-	ret = i2c_transfer(client->adapter, xfer, 2);
-	if (ret == 2)
-		return 0;
-	else if (ret < 0)
-		return ret;
-	else
-		return -EIO;
-}
-#endif
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int snd_soc_8_8_read_i2c(struct snd_soc_codec *codec,
-					 unsigned int r)
-{
-	u8 reg = r;
-	u8 data;
-	int ret;
-
-	ret = do_i2c_read(codec, &reg, 1, &data, 1);
-	if (ret < 0)
-		return 0;
-	return data;
-}
-#else
-#define snd_soc_8_8_read_i2c NULL
-#endif
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int snd_soc_8_16_read_i2c(struct snd_soc_codec *codec,
-					  unsigned int r)
-{
-	u8 reg = r;
-	u16 data;
-	int ret;
-
-	ret = do_i2c_read(codec, &reg, 1, &data, 2);
-	if (ret < 0)
-		return 0;
-	return (data >> 8) | ((data & 0xff) << 8);
-}
-#else
-#define snd_soc_8_16_read_i2c NULL
-#endif
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int snd_soc_16_8_read_i2c(struct snd_soc_codec *codec,
-					  unsigned int r)
-{
-	u16 reg = r;
-	u8 data;
-	int ret;
-
-	ret = do_i2c_read(codec, &reg, 2, &data, 1);
-	if (ret < 0)
-		return 0;
-	return data;
-}
-#else
-#define snd_soc_16_8_read_i2c NULL
-#endif
-
-#if defined(CONFIG_SPI_MASTER)
-static unsigned int snd_soc_16_8_read_spi(struct snd_soc_codec *codec,
-		                          unsigned int r)
-{
-	struct spi_device *spi = codec->control_data;
-
-	const u16 reg = cpu_to_be16(r | 0x100);
-	u8 data;
-	int ret;
-
-	ret = spi_write_then_read(spi, &reg, 2, &data, 1);
-	if (ret < 0)
-		return 0;
-	return data;
-}
-#else
-#define snd_soc_16_8_read_spi NULL
-#endif
-
-static int snd_soc_16_8_write(struct snd_soc_codec *codec, unsigned int reg,
-			      unsigned int value)
-{
-	u8 data[3];
-	u16 rval = cpu_to_be16(reg);
-
-	memcpy(data, &rval, sizeof(rval));
-	data[2] = value;
-
-	return do_hw_write(codec, reg, value, data, 3);
-}
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int snd_soc_16_16_read_i2c(struct snd_soc_codec *codec,
-					   unsigned int r)
-{
-	u16 reg = cpu_to_be16(r);
-	u16 data;
-	int ret;
-
-	ret = do_i2c_read(codec, &reg, 2, &data, 2);
-	if (ret < 0)
-		return 0;
-	return be16_to_cpu(data);
-}
-#else
-#define snd_soc_16_16_read_i2c NULL
-#endif
-
-static int snd_soc_16_16_write(struct snd_soc_codec *codec, unsigned int reg,
-			       unsigned int value)
-{
-	u16 data[2];
-
-	data[0] = cpu_to_be16(reg);
-	data[1] = cpu_to_be16(value);
-
-	return do_hw_write(codec, reg, value, data, sizeof(data));
-}
-
-=======
->>>>>>> linux-next/akpm-end
 /* Primitive bulk write support for soc-cache.  The data pointed to by
  * `data' needs to already be in the form the hardware expects.  Any
  * data written through this function will not go through the cache as
@@ -277,48 +89,6 @@ static int snd_soc_hw_bulk_write_raw(str
 	return regmap_raw_write(codec->control_data, reg, data, len);
 }
 
-<<<<<<< HEAD
-static struct {
-	int addr_bits;
-	int data_bits;
-	int (*write)(struct snd_soc_codec *codec, unsigned int, unsigned int);
-	unsigned int (*read)(struct snd_soc_codec *, unsigned int);
-	unsigned int (*i2c_read)(struct snd_soc_codec *, unsigned int);
-	unsigned int (*spi_read)(struct snd_soc_codec *, unsigned int);
-} io_types[] = {
-	{
-		.addr_bits = 4, .data_bits = 12,
-		.write = snd_soc_4_12_write,
-	},
-	{
-		.addr_bits = 7, .data_bits = 9,
-		.write = snd_soc_7_9_write,
-	},
-	{
-		.addr_bits = 8, .data_bits = 8,
-		.write = snd_soc_8_8_write,
-		.i2c_read = snd_soc_8_8_read_i2c,
-	},
-	{
-		.addr_bits = 8, .data_bits = 16,
-		.write = snd_soc_8_16_write,
-		.i2c_read = snd_soc_8_16_read_i2c,
-	},
-	{
-		.addr_bits = 16, .data_bits = 8,
-		.write = snd_soc_16_8_write,
-		.i2c_read = snd_soc_16_8_read_i2c,
-		.spi_read = snd_soc_16_8_read_spi,
-	},
-	{
-		.addr_bits = 16, .data_bits = 16,
-		.write = snd_soc_16_16_write,
-		.i2c_read = snd_soc_16_16_read_i2c,
-	},
-};
-
-=======
->>>>>>> linux-next/akpm-end
 /**
  * snd_soc_codec_set_cache_io: Set up standard I/O functions.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
kernel-rtmutexc-fix-warning-improve-coding-style.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

