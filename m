From: akpm@linux-foundation.org
Subject: + mtd-m25p80-add-support-for-cat25xxx-serial-eeproms.patch added to -mm tree
Date: Tue, 22 Sep 2009 16:26:54 -0700
Message-ID: <200909222326.n8MNQtL8009851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbZIVX33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 19:29:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     mtd: m25p80: add support for CAT25xxx serial EEPROMs
has been added to the -mm tree.  Its filename is
     mtd-m25p80-add-support-for-cat25xxx-serial-eeproms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: m25p80: add support for CAT25xxx serial EEPROMs
From: Anton Vorontsov <avorontsov@ru.mvista.com>

CAT25 chips (as manufactured by On Semiconductor, previously Catalyst
Semiconductor) are similar to the original M25Px0 chips, except:

- Address width can vary (1-2 bytes, in contrast to 3 bytes in M25P
  chips). So, implement convenient m25p_addr2cmd() and m25p_cmdsz()
  calls, and place address width information into flash_info struct;

- Page size can vary, therefore we shouldn't hardcode it, so get rid
  of FLASH_PAGESIZE definition, and place the page size information
  into flash_info struct;

- CAT25 EEPROMs don't need to be erased, so add NO_ERASE flag, and
  propagate it to the mtd subsystem.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |  176 ++++++++++++++++++---------------
 1 file changed, 99 insertions(+), 77 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-m25p80-add-support-for-cat25xxx-serial-eeproms drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-m25p80-add-support-for-cat25xxx-serial-eeproms
+++ a/drivers/mtd/devices/m25p80.c
@@ -29,9 +29,6 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 
-
-#define FLASH_PAGESIZE		256
-
 /* Flash opcodes. */
 #define	OPCODE_WREN		0x06	/* Write enable */
 #define	OPCODE_RDSR		0x05	/* Read status register */
@@ -56,7 +53,7 @@
 
 /* Define max times to check status register before we give up. */
 #define	MAX_READY_WAIT_JIFFIES	(40 * HZ)	/* M25P16 specs 40s max chip erase */
-#define	CMD_SIZE		4
+#define	MAX_CMD_SIZE		4
 
 #ifdef CONFIG_M25PXX_USE_FAST_READ
 #define OPCODE_READ 	OPCODE_FAST_READ
@@ -73,8 +70,10 @@ struct m25p {
 	struct mutex		lock;
 	struct mtd_info		mtd;
 	unsigned		partitioned:1;
+	u16			page_size;
+	u16			addr_width;
 	u8			erase_opcode;
-	u8			command[CMD_SIZE + FAST_READ_DUMMY_BYTE];
+	u8			command[MAX_CMD_SIZE + FAST_READ_DUMMY_BYTE];
 };
 
 static inline struct m25p *mtd_to_m25p(struct mtd_info *mtd)
@@ -184,6 +183,19 @@ static int erase_chip(struct m25p *flash
 	return 0;
 }
 
+static void m25p_addr2cmd(struct m25p *flash, unsigned int addr, u8 *cmd)
+{
+	/* opcode is in cmd[0] */
+	cmd[1] = addr >> (flash->addr_width * 8 -  8);
+	cmd[2] = addr >> (flash->addr_width * 8 - 16);
+	cmd[3] = addr >> (flash->addr_width * 8 - 24);
+}
+
+static int m25p_cmdsz(struct m25p *flash)
+{
+	return 1 + flash->addr_width;
+}
+
 /*
  * Erase one sector of flash memory at offset ``offset'' which is any
  * address within the sector which should be erased.
@@ -205,11 +217,9 @@ static int erase_sector(struct m25p *fla
 
 	/* Set up command buffer. */
 	flash->command[0] = flash->erase_opcode;
-	flash->command[1] = offset >> 16;
-	flash->command[2] = offset >> 8;
-	flash->command[3] = offset;
+	m25p_addr2cmd(flash, offset, flash->command);
 
-	spi_write(flash->spi, flash->command, CMD_SIZE);
+	spi_write(flash->spi, flash->command, m25p_cmdsz(flash));
 
 	return 0;
 }
@@ -311,7 +321,7 @@ static int m25p80_read(struct mtd_info *
 	 * Should add 1 byte DUMMY_BYTE.
 	 */
 	t[0].tx_buf = flash->command;
-	t[0].len = CMD_SIZE + FAST_READ_DUMMY_BYTE;
+	t[0].len = m25p_cmdsz(flash) + FAST_READ_DUMMY_BYTE;
 	spi_message_add_tail(&t[0], &m);
 
 	t[1].rx_buf = buf;
@@ -338,13 +348,11 @@ static int m25p80_read(struct mtd_info *
 
 	/* Set up the write data buffer. */
 	flash->command[0] = OPCODE_READ;
-	flash->command[1] = from >> 16;
-	flash->command[2] = from >> 8;
-	flash->command[3] = from;
+	m25p_addr2cmd(flash, from, flash->command);
 
 	spi_sync(flash->spi, &m);
 
-	*retlen = m.actual_length - CMD_SIZE - FAST_READ_DUMMY_BYTE;
+	*retlen = m.actual_length - m25p_cmdsz(flash) - FAST_READ_DUMMY_BYTE;
 
 	mutex_unlock(&flash->lock);
 
@@ -382,7 +390,7 @@ static int m25p80_write(struct mtd_info 
 	memset(t, 0, (sizeof t));
 
 	t[0].tx_buf = flash->command;
-	t[0].len = CMD_SIZE;
+	t[0].len = m25p_cmdsz(flash);
 	spi_message_add_tail(&t[0], &m);
 
 	t[1].tx_buf = buf;
@@ -400,41 +408,36 @@ static int m25p80_write(struct mtd_info 
 
 	/* Set up the opcode in the write buffer. */
 	flash->command[0] = OPCODE_PP;
-	flash->command[1] = to >> 16;
-	flash->command[2] = to >> 8;
-	flash->command[3] = to;
+	m25p_addr2cmd(flash, to, flash->command);
 
-	/* what page do we start with? */
-	page_offset = to % FLASH_PAGESIZE;
+	page_offset = to & (flash->page_size - 1);
 
 	/* do all the bytes fit onto one page? */
-	if (page_offset + len <= FLASH_PAGESIZE) {
+	if (page_offset + len <= flash->page_size) {
 		t[1].len = len;
 
 		spi_sync(flash->spi, &m);
 
-		*retlen = m.actual_length - CMD_SIZE;
+		*retlen = m.actual_length - m25p_cmdsz(flash);
 	} else {
 		u32 i;
 
 		/* the size of data remaining on the first page */
-		page_size = FLASH_PAGESIZE - page_offset;
+		page_size = flash->page_size - page_offset;
 
 		t[1].len = page_size;
 		spi_sync(flash->spi, &m);
 
-		*retlen = m.actual_length - CMD_SIZE;
+		*retlen = m.actual_length - m25p_cmdsz(flash);
 
-		/* write everything in PAGESIZE chunks */
+		/* write everything in flash->page_size chunks */
 		for (i = page_size; i < len; i += page_size) {
 			page_size = len - i;
-			if (page_size > FLASH_PAGESIZE)
-				page_size = FLASH_PAGESIZE;
+			if (page_size > flash->page_size)
+				page_size = flash->page_size;
 
 			/* write the next page to flash */
-			flash->command[1] = (to + i) >> 16;
-			flash->command[2] = (to + i) >> 8;
-			flash->command[3] = (to + i);
+			m25p_addr2cmd(flash, to + i, flash->command);
 
 			t[1].tx_buf = buf + i;
 			t[1].len = page_size;
@@ -446,7 +449,7 @@ static int m25p80_write(struct mtd_info 
 			spi_sync(flash->spi, &m);
 
 			if (retlen)
-				*retlen += m.actual_length - CMD_SIZE;
+				*retlen += m.actual_length - m25p_cmdsz(flash);
 		}
 	}
 
@@ -476,16 +479,23 @@ struct flash_info {
 	unsigned	sector_size;
 	u16		n_sectors;
 
+	u16		page_size;
+	u16		addr_width;
+
 	u16		flags;
 #define	SECT_4K		0x01		/* OPCODE_BE_4K works uniformly */
+#define	M25P_NO_ERASE	0x02		/* No erase command needed */
 };
 
-#define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _flags)	\
+#define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _page_size,	\
+		_addr_width, _flags)					\
 	((kernel_ulong_t)&(struct flash_info) {				\
 		.jedec_id = (_jedec_id),				\
 		.ext_id = (_ext_id),					\
 		.sector_size = (_sector_size),				\
 		.n_sectors = (_n_sectors),				\
+		.page_size = (_page_size),				\
+		.addr_width = (_addr_width),				\
 		.flags = (_flags),					\
 	})
 
@@ -495,66 +505,73 @@ struct flash_info {
  */
 static const struct spi_device_id m25p_ids[] = {
 	/* Atmel -- some are (confusingly) marketed as "DataFlash" */
-	{ "at25fs010",  INFO(0x1f6601, 0, 32 * 1024, 4, SECT_4K) },
-	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024, 8, SECT_4K) },
+	{ "at25fs010",  INFO(0x1f6601, 0, 32 * 1024, 4, 256, 3, SECT_4K) },
+	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024, 8, 256, 3, SECT_4K) },
 
-	{ "at25df041a", INFO(0x1f4401, 0, 64 * 1024, 8, SECT_4K) },
-	{ "at25df641",  INFO(0x1f4800, 0, 64 * 1024, 128, SECT_4K) },
+	{ "at25df041a", INFO(0x1f4401, 0, 64 * 1024, 8, 256, 3, SECT_4K) },
+	{ "at25df641",  INFO(0x1f4800, 0, 64 * 1024, 128, 256, 3, SECT_4K) },
 
-	{ "at26f004",   INFO(0x1f0400, 0, 64 * 1024, 8, SECT_4K) },
-	{ "at26df081a", INFO(0x1f4501, 0, 64 * 1024, 16, SECT_4K) },
-	{ "at26df161a", INFO(0x1f4601, 0, 64 * 1024, 32, SECT_4K) },
-	{ "at26df321",  INFO(0x1f4701, 0, 64 * 1024, 64, SECT_4K) },
+	{ "at26f004",   INFO(0x1f0400, 0, 64 * 1024, 8, 256, 3, SECT_4K) },
+	{ "at26df081a", INFO(0x1f4501, 0, 64 * 1024, 16, 256, 3, SECT_4K) },
+	{ "at26df161a", INFO(0x1f4601, 0, 64 * 1024, 32, 256, 3, SECT_4K) },
+	{ "at26df321",  INFO(0x1f4701, 0, 64 * 1024, 64, 256, 3, SECT_4K) },
 
 	/* Macronix */
-	{ "mx25l3205d", INFO(0xc22016, 0, 64 * 1024, 64, 0) },
-	{ "mx25l6405d", INFO(0xc22017, 0, 64 * 1024, 128, 0) },
-	{ "mx25l12805d", INFO(0xc22018, 0, 64 * 1024, 256, 0) },
-	{ "mx25l12855e", INFO(0xc22618, 0, 64 * 1024, 256, 0) },
+	{ "mx25l3205d", INFO(0xc22016, 0, 64 * 1024, 64, 256, 3, 0) },
+	{ "mx25l6405d", INFO(0xc22017, 0, 64 * 1024, 128, 256, 3, 0) },
+	{ "mx25l12805d", INFO(0xc22018, 0, 64 * 1024, 256, 256, 3, 0) },
+	{ "mx25l12855e", INFO(0xc22618, 0, 64 * 1024, 256, 256, 3, 0) },
 
 	/* Spansion -- single (large) sector size only, at least
 	 * for the chips listed here (without boot sectors).
 	 */
-	{ "s25sl004a",  INFO(0x010212, 0, 64 * 1024, 8, 0) },
-	{ "s25sl008a",  INFO(0x010213, 0, 64 * 1024, 16, 0) },
-	{ "s25sl016a",  INFO(0x010214, 0, 64 * 1024, 32, 0) },
-	{ "s25sl032a",  INFO(0x010215, 0, 64 * 1024, 64, 0) },
-	{ "s25sl064a",  INFO(0x010216, 0, 64 * 1024, 128, 0) },
-	{ "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024, 64, 0) },
-	{ "s25sl12801", INFO(0x012018, 0x0301, 64 * 1024, 256, 0) },
+	{ "s25sl004a",  INFO(0x010212, 0, 64 * 1024, 8, 256, 3, 0) },
+	{ "s25sl008a",  INFO(0x010213, 0, 64 * 1024, 16, 256, 3, 0) },
+	{ "s25sl016a",  INFO(0x010214, 0, 64 * 1024, 32, 256, 3, 0) },
+	{ "s25sl032a",  INFO(0x010215, 0, 64 * 1024, 64, 256, 3, 0) },
+	{ "s25sl064a",  INFO(0x010216, 0, 64 * 1024, 128, 256, 3, 0) },
+	{ "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024, 64, 256, 3, 0) },
+	{ "s25sl12801", INFO(0x012018, 0x0301, 64 * 1024, 256, 256, 3, 0) },
 
 	/* SST -- large erase sizes are "overlays", "sectors" are 4K */
-	{ "sst25vf040b", INFO(0xbf258d, 0, 64 * 1024, 8, SECT_4K) },
-	{ "sst25vf080b", INFO(0xbf258e, 0, 64 * 1024, 16, SECT_4K) },
-	{ "sst25vf016b", INFO(0xbf2541, 0, 64 * 1024, 32, SECT_4K) },
-	{ "sst25vf032b", INFO(0xbf254a, 0, 64 * 1024, 64, SECT_4K) },
+	{ "sst25vf040b", INFO(0xbf258d, 0, 64 * 1024, 8, 256, 3, SECT_4K) },
+	{ "sst25vf080b", INFO(0xbf258e, 0, 64 * 1024, 16, 256, 3, SECT_4K) },
+	{ "sst25vf016b", INFO(0xbf2541, 0, 64 * 1024, 32, 256, 3, SECT_4K) },
+	{ "sst25vf032b", INFO(0xbf254a, 0, 64 * 1024, 64, 256, 3, SECT_4K) },
 
 	/* ST Microelectronics -- newer production may have feature updates */
-	{ "m25p05",  INFO(0x202010,  0, 32 * 1024, 2, 0) },
-	{ "m25p10",  INFO(0x202011,  0, 32 * 1024, 4, 0) },
-	{ "m25p20",  INFO(0x202012,  0, 64 * 1024, 4, 0) },
-	{ "m25p40",  INFO(0x202013,  0, 64 * 1024, 8, 0) },
-	{ "m25p80",  INFO(0x202014,  0, 64 * 1024, 16, 0) },
-	{ "m25p16",  INFO(0x202015,  0, 64 * 1024, 32, 0) },
-	{ "m25p32",  INFO(0x202016,  0, 64 * 1024, 64, 0) },
-	{ "m25p64",  INFO(0x202017,  0, 64 * 1024, 128, 0) },
-	{ "m25p128", INFO(0x202018, 0, 256 * 1024, 64, 0) },
-
-	{ "m45pe10", INFO(0x204011,  0, 64 * 1024, 2, 0) },
-	{ "m45pe80", INFO(0x204014,  0, 64 * 1024, 16, 0) },
-	{ "m45pe16", INFO(0x204015,  0, 64 * 1024, 32, 0) },
+	{ "m25p05",  INFO(0x202010,  0, 32 * 1024, 2, 256, 3, 0) },
+	{ "m25p10",  INFO(0x202011,  0, 32 * 1024, 4, 256, 3, 0) },
+	{ "m25p20",  INFO(0x202012,  0, 64 * 1024, 4, 256, 3, 0) },
+	{ "m25p40",  INFO(0x202013,  0, 64 * 1024, 8, 256, 3, 0) },
+	{ "m25p80",  INFO(0x202014,  0, 64 * 1024, 16, 256, 3, 0) },
+	{ "m25p16",  INFO(0x202015,  0, 64 * 1024, 32, 256, 3, 0) },
+	{ "m25p32",  INFO(0x202016,  0, 64 * 1024, 64, 256, 3, 0) },
+	{ "m25p64",  INFO(0x202017,  0, 64 * 1024, 128, 256, 3, 0) },
+	{ "m25p128", INFO(0x202018, 0, 256 * 1024, 64, 256, 3, 0) },
+
+	{ "m45pe10", INFO(0x204011,  0, 64 * 1024, 2, 256, 3, 0) },
+	{ "m45pe80", INFO(0x204014,  0, 64 * 1024, 16, 256, 3, 0) },
+	{ "m45pe16", INFO(0x204015,  0, 64 * 1024, 32, 256, 3, 0) },
 
-	{ "m25pe80", INFO(0x208014,  0, 64 * 1024, 16, 0) },
-	{ "m25pe16", INFO(0x208015,  0, 64 * 1024, 32, SECT_4K) },
+	{ "m25pe80", INFO(0x208014,  0, 64 * 1024, 16, 256, 3, 0) },
+	{ "m25pe16", INFO(0x208015,  0, 64 * 1024, 32, 256, 3, SECT_4K) },
 
 	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
-	{ "w25x10", INFO(0xef3011, 0, 64 * 1024, 2, SECT_4K) },
-	{ "w25x20", INFO(0xef3012, 0, 64 * 1024, 4, SECT_4K) },
-	{ "w25x40", INFO(0xef3013, 0, 64 * 1024, 8, SECT_4K) },
-	{ "w25x80", INFO(0xef3014, 0, 64 * 1024, 16, SECT_4K) },
-	{ "w25x16", INFO(0xef3015, 0, 64 * 1024, 32, SECT_4K) },
-	{ "w25x32", INFO(0xef3016, 0, 64 * 1024, 64, SECT_4K) },
-	{ "w25x64", INFO(0xef3017, 0, 64 * 1024, 128, SECT_4K) },
+	{ "w25x10", INFO(0xef3011, 0, 64 * 1024, 2, 256, 3, SECT_4K) },
+	{ "w25x20", INFO(0xef3012, 0, 64 * 1024, 4, 256, 3, SECT_4K) },
+	{ "w25x40", INFO(0xef3013, 0, 64 * 1024, 8, 256, 3, SECT_4K) },
+	{ "w25x80", INFO(0xef3014, 0, 64 * 1024, 16, 256, 3, SECT_4K) },
+	{ "w25x16", INFO(0xef3015, 0, 64 * 1024, 32, 256, 3, SECT_4K) },
+	{ "w25x32", INFO(0xef3016, 0, 64 * 1024, 64, 256, 3, SECT_4K) },
+	{ "w25x64", INFO(0xef3017, 0, 64 * 1024, 128, 256, 3, SECT_4K) },
+
+	/* Catalyst / On Semiconductor -- non-JEDEC */
+	{ "cat25c11",  INFO(0x0, 0,   16, 8, 16, 1, M25P_NO_ERASE) },
+	{ "cat25c03",  INFO(0x0, 0,   32, 8, 16, 2, M25P_NO_ERASE) },
+	{ "cat25c09",  INFO(0x0, 0,  128, 8, 32, 2, M25P_NO_ERASE) },
+	{ "cat25c17",  INFO(0x0, 0,  256, 8, 32, 2, M25P_NO_ERASE) },
+	{ "cat25128",  INFO(0x0, 0, 2048, 8, 64, 2, M25P_NO_ERASE) },
 	{ },
 };
 MODULE_DEVICE_TABLE(spi, m25p_ids);
@@ -705,7 +722,12 @@ static int __devinit m25p_probe(struct s
 		flash->mtd.erasesize = info->sector_size;
 	}
 
+	if (info->flags & M25P_NO_ERASE)
+		flash->mtd.flags |= MTD_NO_ERASE;
+
 	flash->mtd.dev.parent = &spi->dev;
+	flash->page_size = info->page_size;
+	flash->addr_width = info->addr_width;
 
 	dev_info(&spi->dev, "%s (%lld Kbytes)\n", id->name,
 			(long long)flash->mtd.size >> 10);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
sdhci-be-more-strict-with-get_min_clock-usage.patch
sdhci-of-fix-sd-clock-calculation.patch
sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch
sdhci-of-fix-high-speed-cards-recognition.patch
powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch
sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch
sdhci-of-cleanup-esdhcs-set_clock-a-little-bit.patch
powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch
spi-add-support-for-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-m25p80-convert-to-device-table-matching.patch
mtd-m25p80-rework-probing-jedec-code.patch
mtd-m25p80-add-support-for-cat25xxx-serial-eeproms.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

