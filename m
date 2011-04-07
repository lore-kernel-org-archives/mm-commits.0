From: akpm@linux-foundation.org
Subject: + w1-complete-the-1-wire-w1-ds1wm-driver-search-algorithm.patch added to -mm tree
Date: Thu, 07 Apr 2011 15:43:45 -0700
Message-ID: <201104072243.p37Mhk9J004899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756886Ab1DGWo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 18:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dagenaisj@sonatest.com, johnpol@2ka.mipt.ru, mreimer@vpop.net, szabolcs.gyurko@tlt.hu


The patch titled
     w1: complete the 1-wire (w1) ds1wm driver search algorithm
has been added to the -mm tree.  Its filename is
     w1-complete-the-1-wire-w1-ds1wm-driver-search-algorithm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: w1: complete the 1-wire (w1) ds1wm driver search algorithm
=46rom: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>

This adds multi-slave support of the w1 bus for the ds1wm Synthesizable
1-Wire Bus Master.  Also many fixes and tweaks based on the rev3 of the
datasheet http://datasheets.maxim-ic.com/en/ds/DS1WM.pdf

Signed-off-by: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/Kconfig |    2=20
 drivers/w1/masters/ds1wm.c |  321 +++++++++++++++++++++++------------
 2 files changed, 220 insertions(+), 103 deletions(-)

diff -puN drivers/w1/masters/Kconfig~w1-complete-the-1-wire-w1-ds1wm-dr=
iver-search-algorithm drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig~w1-complete-the-1-wire-w1-ds1wm-driver=
-search-algorithm
+++ a/drivers/w1/masters/Kconfig
@@ -42,7 +42,7 @@ config W1_MASTER_MXC
=20
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
-	depends on W1 && ARM && HAVE_CLK
+	depends on W1
 	help
 	  Say Y here to enable the DS1WM 1-wire driver, such as that
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
diff -puN drivers/w1/masters/ds1wm.c~w1-complete-the-1-wire-w1-ds1wm-dr=
iver-search-algorithm drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~w1-complete-the-1-wire-w1-ds1wm-driver=
-search-algorithm
+++ a/drivers/w1/masters/ds1wm.c
@@ -33,6 +33,7 @@
 #define DS1WM_INT	0x02	/* R/W interrupt status */
 #define DS1WM_INT_EN	0x03	/* R/W interrupt enable */
 #define DS1WM_CLKDIV	0x04	/* R/W 5 bits of divisor and pre-scale */
+#define DS1WM_CNTRL	0x05	/* R/W master control register (not used yet)=
 */
=20
 #define DS1WM_CMD_1W_RESET  (1 << 0)	/* force reset on 1-wire bus */
 #define DS1WM_CMD_SRA	    (1 << 1)	/* enable Search ROM accelerator mo=
de */
@@ -56,6 +57,7 @@
 #define DS1WM_INTEN_ERSRF   (1 << 5)	/* enable rx shift register full =
int */
 #define DS1WM_INTEN_DQO	    (1 << 6)	/* enable direct bus driving ops =
*/
=20
+#define DS1WM_INTEN_NOT_IAS (~DS1WM_INTEN_IAS)	/* all but INTR active =
state */
=20
 #define DS1WM_TIMEOUT (HZ * 5)
=20
@@ -63,41 +65,50 @@ static struct {
 	unsigned long freq;
 	unsigned long divisor;
 } freq[] =3D {
-	{ 4000000, 0x8 },
-	{ 5000000, 0x2 },
-	{ 6000000, 0x5 },
-	{ 7000000, 0x3 },
-	{ 8000000, 0xc },
-	{ 10000000, 0x6 },
-	{ 12000000, 0x9 },
-	{ 14000000, 0x7 },
-	{ 16000000, 0x10 },
-	{ 20000000, 0xa },
-	{ 24000000, 0xd },
-	{ 28000000, 0xb },
-	{ 32000000, 0x14 },
-	{ 40000000, 0xe },
-	{ 48000000, 0x11 },
-	{ 56000000, 0xf },
-	{ 64000000, 0x18 },
-	{ 80000000, 0x12 },
-	{ 96000000, 0x15 },
-	{ 112000000, 0x13 },
-	{ 128000000, 0x1c },
+	{   1000000, 0x80 },
+	{   2000000, 0x84 },
+	{   3000000, 0x81 },
+	{   4000000, 0x88 },
+	{   5000000, 0x82 },
+	{   6000000, 0x85 },
+	{   7000000, 0x83 },
+	{   8000000, 0x8c },
+	{  10000000, 0x86 },
+	{  12000000, 0x89 },
+	{  14000000, 0x87 },
+	{  16000000, 0x90 },
+	{  20000000, 0x8a },
+	{  24000000, 0x8d },
+	{  28000000, 0x8b },
+	{  32000000, 0x94 },
+	{  40000000, 0x8e },
+	{  48000000, 0x91 },
+	{  56000000, 0x8f },
+	{  64000000, 0x98 },
+	{  80000000, 0x92 },
+	{  96000000, 0x95 },
+	{ 112000000, 0x93 },
+	{ 128000000, 0x9c },
+/* you can continue this table, consult the OPERATION - CLOCK DIVISOR
+   section of the ds1wm spec sheet. */
 };
=20
 struct ds1wm_data {
-	void		__iomem *map;
-	int		bus_shift; /* # of shifts to calc register offsets */
+	void     __iomem *map;
+	int      bus_shift; /* # of shifts to calc register offsets */
 	struct platform_device *pdev;
-	const struct mfd_cell *cell;
-	int		irq;
-	int		active_high;
-	int		slave_present;
-	void		*reset_complete;
-	void		*read_complete;
-	void		*write_complete;
-	u8		read_byte; /* last byte received */
+	const struct mfd_cell   *cell;
+	int      irq;
+	int      slave_present;
+	void     *reset_complete;
+	void     *read_complete;
+	void     *write_complete;
+	int      read_error;
+	/* last byte received */
+	u8       read_byte;
+	/* byte to write that makes all intr disabled, */
+	/* considering active_state (IAS) (optimization) */
+	u8       int_en_reg_none;
 };
=20
 static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data,=
 u32 reg,
@@ -115,23 +126,39 @@ static inline u8 ds1wm_read_register(str
 static irqreturn_t ds1wm_isr(int isr, void *data)
 {
 	struct ds1wm_data *ds1wm_data =3D data;
-	u8 intr =3D ds1wm_read_register(ds1wm_data, DS1WM_INT);
+	u8 intr;
+	u8 inten =3D ds1wm_read_register(ds1wm_data, DS1WM_INT_EN);
+	/* if no bits are set in int enable register (except the IAS)
+	than go no further, reading the regs below has side effects */
+	if (!(inten & DS1WM_INTEN_NOT_IAS))
+		return IRQ_NONE;
=20
-	ds1wm_data->slave_present =3D (intr & DS1WM_INT_PDR) ? 0 : 1;
+	ds1wm_write_register(ds1wm_data,
+		DS1WM_INT_EN, ds1wm_data->int_en_reg_none);
=20
-	if ((intr & DS1WM_INT_PD) && ds1wm_data->reset_complete)
-		complete(ds1wm_data->reset_complete);
+	/* this read action clears the INTR and certain flags in ds1wm */
+	intr =3D ds1wm_read_register(ds1wm_data, DS1WM_INT);
=20
-	if ((intr & DS1WM_INT_TSRE) && ds1wm_data->write_complete)
-		complete(ds1wm_data->write_complete);
+	ds1wm_data->slave_present =3D (intr & DS1WM_INT_PDR) ? 0 : 1;
=20
+	if ((intr & DS1WM_INT_TSRE) && ds1wm_data->write_complete) {
+		inten &=3D ~DS1WM_INTEN_ETMT;
+		complete(ds1wm_data->write_complete);
+	}
 	if (intr & DS1WM_INT_RBF) {
+		/* this read clears the RBF flag */
 		ds1wm_data->read_byte =3D ds1wm_read_register(ds1wm_data,
-							    DS1WM_DATA);
+		DS1WM_DATA);
+		inten &=3D ~DS1WM_INTEN_ERBF;
 		if (ds1wm_data->read_complete)
 			complete(ds1wm_data->read_complete);
 	}
+	if ((intr & DS1WM_INT_PD) && ds1wm_data->reset_complete) {
+		inten &=3D ~DS1WM_INTEN_EPD;
+		complete(ds1wm_data->reset_complete);
+	}
=20
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, inten);
 	return IRQ_HANDLED;
 }
=20
@@ -142,33 +169,19 @@ static int ds1wm_reset(struct ds1wm_data
=20
 	ds1wm_data->reset_complete =3D &reset_done;
=20
+	/* enable Presence detect only */
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, DS1WM_INTEN_EPD |
-		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
+	ds1wm_data->int_en_reg_none);
=20
 	ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_1W_RESET);
=20
 	timeleft =3D wait_for_completion_timeout(&reset_done, DS1WM_TIMEOUT);
 	ds1wm_data->reset_complete =3D NULL;
 	if (!timeleft) {
-		dev_err(&ds1wm_data->pdev->dev, "reset failed\n");
+		dev_err(&ds1wm_data->pdev->dev, "reset failed, timed out\n");
 		return 1;
 	}
=20
-	/* Wait for the end of the reset. According to the specs, the time
-	 * from when the interrupt is asserted to the end of the reset is:
-	 *     tRSTH  - tPDH  - tPDL - tPDI
-	 *     625 us - 60 us - 240 us - 100 ns =3D 324.9 us
-	 *
-	 * We'll wait a bit longer just to be sure.
-	 * Was udelay(500), but if it is going to busywait the cpu that long,
-	 * might as well come back later.
-	 */
-	msleep(1);
-
-	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
-		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
-		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
-
 	if (!ds1wm_data->slave_present) {
 		dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
 		return 1;
@@ -179,26 +192,47 @@ static int ds1wm_reset(struct ds1wm_data
=20
 static int ds1wm_write(struct ds1wm_data *ds1wm_data, u8 data)
 {
+	unsigned long timeleft;
 	DECLARE_COMPLETION_ONSTACK(write_done);
 	ds1wm_data->write_complete =3D &write_done;
=20
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
+	ds1wm_data->int_en_reg_none | DS1WM_INTEN_ETMT);
+
 	ds1wm_write_register(ds1wm_data, DS1WM_DATA, data);
=20
-	wait_for_completion_timeout(&write_done, DS1WM_TIMEOUT);
+	timeleft =3D wait_for_completion_timeout(&write_done, DS1WM_TIMEOUT);
+
 	ds1wm_data->write_complete =3D NULL;
+	if (!timeleft) {
+		dev_err(&ds1wm_data->pdev->dev, "write failed, timed out\n");
+		return -ETIMEDOUT;
+	}
=20
 	return 0;
 }
=20
-static int ds1wm_read(struct ds1wm_data *ds1wm_data, unsigned char wri=
te_data)
+static u8 ds1wm_read(struct ds1wm_data *ds1wm_data, unsigned char writ=
e_data)
 {
+	unsigned long timeleft;
+	u8 intEnable =3D DS1WM_INTEN_ERBF | ds1wm_data->int_en_reg_none;
 	DECLARE_COMPLETION_ONSTACK(read_done);
+
+	ds1wm_read_register(ds1wm_data, DS1WM_DATA);
+
 	ds1wm_data->read_complete =3D &read_done;
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, intEnable);
=20
-	ds1wm_write(ds1wm_data, write_data);
-	wait_for_completion_timeout(&read_done, DS1WM_TIMEOUT);
-	ds1wm_data->read_complete =3D NULL;
+	ds1wm_write_register(ds1wm_data, DS1WM_DATA, write_data);
+	timeleft =3D wait_for_completion_timeout(&read_done, DS1WM_TIMEOUT);
=20
+	ds1wm_data->read_complete =3D NULL;
+	if (!timeleft) {
+		dev_err(&ds1wm_data->pdev->dev, "read failed, timed out\n");
+		ds1wm_data->read_error =3D -ETIMEDOUT;
+		return 0xFF;
+	}
+	ds1wm_data->read_error =3D 0;
 	return ds1wm_data->read_byte;
 }
=20
@@ -206,8 +240,8 @@ static int ds1wm_find_divisor(int gclk)
 {
 	int i;
=20
-	for (i =3D 0; i < ARRAY_SIZE(freq); i++)
-		if (gclk <=3D freq[i].freq)
+	for (i =3D ARRAY_SIZE(freq)-1; i >=3D 0; --i)
+		if (gclk >=3D freq[i].freq)
 			return freq[i].divisor;
=20
 	return 0;
@@ -222,6 +256,8 @@ static void ds1wm_up(struct ds1wm_data *
 		ds1wm_data->cell->enable(ds1wm_data->pdev);
=20
 	divisor =3D ds1wm_find_divisor(plat->clock_rate);
+	dev_dbg(&ds1wm_data->pdev->dev,
+		"found divisor 0x%x for clock %d\n", divisor, plat->clock_rate);
 	if (divisor =3D=3D 0) {
 		dev_err(&ds1wm_data->pdev->dev,
 			"no suitable divisor for %dHz clock\n",
@@ -242,7 +278,7 @@ static void ds1wm_down(struct ds1wm_data
=20
 	/* Disable interrupts. */
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
-			     ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0);
+		ds1wm_data->int_en_reg_none);
=20
 	if (ds1wm_data->cell->disable)
 		ds1wm_data->cell->disable(ds1wm_data->pdev);
@@ -279,41 +315,121 @@ static void ds1wm_search(void *data, str
 {
 	struct ds1wm_data *ds1wm_data =3D data;
 	int i;
-	unsigned long long rom_id;
-
-	/* XXX We need to iterate for multiple devices per the DS1WM docs.
-	 * See http://www.maxim-ic.com/appnotes.cfm/appnote_number/120. */
-	if (ds1wm_reset(ds1wm_data))
-		return;
-
-	ds1wm_write(ds1wm_data, search_type);
-	ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_SRA);
-
-	for (rom_id =3D 0, i =3D 0; i < 16; i++) {
-
-		unsigned char resp, r, d;
-
-		resp =3D ds1wm_read(ds1wm_data, 0x00);
-
-		r =3D ((resp & 0x02) >> 1) |
-		    ((resp & 0x08) >> 2) |
-		    ((resp & 0x20) >> 3) |
-		    ((resp & 0x80) >> 4);
-
-		d =3D ((resp & 0x01) >> 0) |
-		    ((resp & 0x04) >> 1) |
-		    ((resp & 0x10) >> 2) |
-		    ((resp & 0x40) >> 3);
-
-		rom_id |=3D (unsigned long long) r << (i * 4);
-
-	}
-	dev_dbg(&ds1wm_data->pdev->dev, "found 0x%08llX\n", rom_id);
-
-	ds1wm_write_register(ds1wm_data, DS1WM_CMD, ~DS1WM_CMD_SRA);
-	ds1wm_reset(ds1wm_data);
-
-	slave_found(master_dev, rom_id);
+	int ms_discrep_bit =3D -1;
+	u64 r =3D 0; /* holds the progress of the search */
+	u64 r_prime, d;
+	unsigned slaves_found =3D 0;
+	unsigned int pass =3D 0;
+
+	dev_dbg(&ds1wm_data->pdev->dev, "search begin\n");
+	while (true) {
+		++pass;
+		if (pass > 100) {
+			dev_dbg(&ds1wm_data->pdev->dev,
+				"too many attempts (100), search aborted\n");
+			return;
+		}
+
+		if (ds1wm_reset(ds1wm_data)) {
+			dev_dbg(&ds1wm_data->pdev->dev,
+				"pass: %d reset error (or no slaves)\n", pass);
+			break;
+		}
+
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d r : %0#18llx writing SEARCH_ROM\n", pass, r);
+		ds1wm_write(ds1wm_data, search_type);
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d entering ASM\n", pass);
+		ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_SRA);
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d begining nibble loop\n", pass);
+
+		r_prime =3D 0;
+		d =3D 0;
+		/* we work one nibble at a time */
+		/* each nibble is interleaved to form a byte */
+		for (i =3D 0; i < 16; i++) {
+
+			unsigned char resp, _r, _r_prime, _d;
+
+			_r =3D (r >> (4*i)) & 0xf;
+			_r =3D ((_r & 0x1) << 1) |
+			((_r & 0x2) << 2) |
+			((_r & 0x4) << 3) |
+			((_r & 0x8) << 4);
+
+			/* writes _r, then reads back: */
+			resp =3D ds1wm_read(ds1wm_data, _r);
+
+			if (ds1wm_data->read_error) {
+				dev_err(&ds1wm_data->pdev->dev,
+				"pass: %d nibble: %d read error\n", pass, i);
+				break;
+			}
+
+			_r_prime =3D ((resp & 0x02) >> 1) |
+			((resp & 0x08) >> 2) |
+			((resp & 0x20) >> 3) |
+			((resp & 0x80) >> 4);
+
+			_d =3D ((resp & 0x01) >> 0) |
+			((resp & 0x04) >> 1) |
+			((resp & 0x10) >> 2) |
+			((resp & 0x40) >> 3);
+
+			r_prime |=3D (unsigned long long) _r_prime << (i * 4);
+			d |=3D (unsigned long long) _d << (i * 4);
+
+		}
+		if (ds1wm_data->read_error) {
+			dev_err(&ds1wm_data->pdev->dev,
+				"pass: %d read error, retrying\n", pass);
+			break;
+		}
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d r\': %0#18llx d:%0#18llx\n",
+			pass, r_prime, d);
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d nibble loop complete, exiting ASM\n", pass);
+		ds1wm_write_register(ds1wm_data, DS1WM_CMD, ~DS1WM_CMD_SRA);
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d resetting bus\n", pass);
+		ds1wm_reset(ds1wm_data);
+		if ((r_prime & ((u64)1 << 63)) && (d & ((u64)1 << 63))) {
+			dev_err(&ds1wm_data->pdev->dev,
+				"pass: %d bus error, retrying\n", pass);
+			continue; /* start over */
+		}
+
+
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d found %0#18llx\n", pass, r_prime);
+		slave_found(master_dev, r_prime);
+		++slaves_found;
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d complete, preparing next pass\n", pass);
+
+		/* any discrepency found which we already choose the
+		   '1' branch is now is now irrelevant we reveal the
+		   next branch with this: */
+		d &=3D ~r;
+		/* find last bit set, i.e. the most signif. bit set */
+		ms_discrep_bit =3D fls64(d) - 1;
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d new d:%0#18llx MS discrep bit:%d\n",
+			pass, d, ms_discrep_bit);
+
+		/* prev_ms_discrep_bit =3D ms_discrep_bit;
+		   prepare for next ROM search:		    */
+		if (ms_discrep_bit =3D=3D -1)
+			break;
+
+		r =3D (r &  ~(~0ull << (ms_discrep_bit))) | 1 << ms_discrep_bit;
+	} /* end while true */
+	dev_dbg(&ds1wm_data->pdev->dev,
+		"pass: %d total: %d search done ms d bit pos: %d\n", pass,
+		slaves_found, ms_discrep_bit);
 }
=20
 /* -------------------------------------------------------------------=
-- */
@@ -365,15 +481,15 @@ static int ds1wm_probe(struct platform_d
 		goto err1;
 	}
 	ds1wm_data->irq =3D res->start;
-	ds1wm_data->active_high =3D plat->active_high;
+	ds1wm_data->int_en_reg_none =3D (plat->active_high ? DS1WM_INTEN_IAS =
: 0);
=20
 	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
 		irq_set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
 	if (res->flags & IORESOURCE_IRQ_LOWEDGE)
 		irq_set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
=20
-	ret =3D request_irq(ds1wm_data->irq, ds1wm_isr, IRQF_DISABLED,
-			  "ds1wm", ds1wm_data);
+	ret =3D request_irq(ds1wm_data->irq, ds1wm_isr,
+			IRQF_DISABLED | IRQF_SHARED, "ds1wm", ds1wm_data);
 	if (ret)
 		goto err1;
=20
@@ -460,5 +576,6 @@ module_exit(ds1wm_exit);
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>, "
-	      "Matt Reimer <mreimer@vpop.net>");
+	"Matt Reimer <mreimer@vpop.net>,"
+	"Jean-Francois Dagenais <dagenaisj@sonatest.com>");
 MODULE_DESCRIPTION("DS1WM w1 busmaster driver");
_

Patches currently in -mm which might be from dagenaisj@sonatest.com are

w1-add-1-wire-w1-reset-and-resume-command-api-support.patch
w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support.patch
w1-complete-the-1-wire-w1-ds1wm-driver-search-algorithm.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
