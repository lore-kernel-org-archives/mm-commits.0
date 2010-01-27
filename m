From: akpm@linux-foundation.org
Subject: + broadsheetfb-add-mmio-hooks.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:29:11 -0800
Message-ID: <201001272329.o0RNTBwg006632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324Ab0A0X33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:29:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jayakumar.lkml@gmail.com, geert@linux-m68k.org, krzysztof.h1@wp.pl


The patch titled
     broadsheetfb: add MMIO hooks
has been added to the -mm tree.  Its filename is
     broadsheetfb-add-mmio-hooks.patch

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
Subject: broadsheetfb: add MMIO hooks
From: Jaya Kumar <jayakumar.lkml@gmail.com>

Allow boards with GP-MMIO controllers to provide hooks to broadsheetfb in
order to offload cmd/data writes and data reads instead of relying only on
host based GPIO wiggling.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/broadsheetfb.c |  110 ++++++++++++++++++++++++++++-----
 include/video/broadsheetfb.h |   17 +++--
 2 files changed, 107 insertions(+), 20 deletions(-)

diff -puN drivers/video/broadsheetfb.c~broadsheetfb-add-mmio-hooks drivers/video/broadsheetfb.c
--- a/drivers/video/broadsheetfb.c~broadsheetfb-add-mmio-hooks
+++ a/drivers/video/broadsheetfb.c
@@ -115,30 +115,30 @@ static struct fb_var_screeninfo broadshe
 };
 
 /* main broadsheetfb functions */
-static void broadsheet_issue_data(struct broadsheetfb_par *par, u16 data)
+static void broadsheet_gpio_issue_data(struct broadsheetfb_par *par, u16 data)
 {
 	par->board->set_ctl(par, BS_WR, 0);
 	par->board->set_hdb(par, data);
 	par->board->set_ctl(par, BS_WR, 1);
 }
 
-static void broadsheet_issue_cmd(struct broadsheetfb_par *par, u16 data)
+static void broadsheet_gpio_issue_cmd(struct broadsheetfb_par *par, u16 data)
 {
 	par->board->set_ctl(par, BS_DC, 0);
-	broadsheet_issue_data(par, data);
+	broadsheet_gpio_issue_data(par, data);
 }
 
-static void broadsheet_send_command(struct broadsheetfb_par *par, u16 data)
+static void broadsheet_gpio_send_command(struct broadsheetfb_par *par, u16 data)
 {
 	par->board->wait_for_rdy(par);
 
 	par->board->set_ctl(par, BS_CS, 0);
-	broadsheet_issue_cmd(par, data);
+	broadsheet_gpio_issue_cmd(par, data);
 	par->board->set_ctl(par, BS_DC, 1);
 	par->board->set_ctl(par, BS_CS, 1);
 }
 
-static void broadsheet_send_cmdargs(struct broadsheetfb_par *par, u16 cmd,
+static void broadsheet_gpio_send_cmdargs(struct broadsheetfb_par *par, u16 cmd,
 					int argc, u16 *argv)
 {
 	int i;
@@ -146,15 +146,43 @@ static void broadsheet_send_cmdargs(stru
 	par->board->wait_for_rdy(par);
 
 	par->board->set_ctl(par, BS_CS, 0);
-	broadsheet_issue_cmd(par, cmd);
+	broadsheet_gpio_issue_cmd(par, cmd);
 	par->board->set_ctl(par, BS_DC, 1);
 
 	for (i = 0; i < argc; i++)
-		broadsheet_issue_data(par, argv[i]);
+		broadsheet_gpio_issue_data(par, argv[i]);
 	par->board->set_ctl(par, BS_CS, 1);
 }
 
-static void broadsheet_burst_write(struct broadsheetfb_par *par, int size,
+static void broadsheet_mmio_send_cmdargs(struct broadsheetfb_par *par, u16 cmd,
+				    int argc, u16 *argv)
+{
+	int i;
+
+	par->board->mmio_write(par, BS_MMIO_CMD, cmd);
+
+	for (i = 0; i < argc; i++)
+		par->board->mmio_write(par, BS_MMIO_DATA, argv[i]);
+}
+
+static void broadsheet_send_command(struct broadsheetfb_par *par, u16 data)
+{
+	if (par->board->mmio_write)
+		par->board->mmio_write(par, BS_MMIO_CMD, data);
+	else
+		broadsheet_gpio_send_command(par, data);
+}
+
+static void broadsheet_send_cmdargs(struct broadsheetfb_par *par, u16 cmd,
+				    int argc, u16 *argv)
+{
+	if (par->board->mmio_write)
+		broadsheet_mmio_send_cmdargs(par, cmd, argc, argv);
+	else
+		broadsheet_gpio_send_cmdargs(par, cmd, argc, argv);
+}
+
+static void broadsheet_gpio_burst_write(struct broadsheetfb_par *par, int size,
 					u16 *data)
 {
 	int i;
@@ -174,7 +202,30 @@ static void broadsheet_burst_write(struc
 	par->board->set_ctl(par, BS_CS, 1);
 }
 
-static u16 broadsheet_get_data(struct broadsheetfb_par *par)
+static void broadsheet_mmio_burst_write(struct broadsheetfb_par *par, int size,
+				   u16 *data)
+{
+	int i;
+	u16 tmp;
+
+	for (i = 0; i < size; i++) {
+		tmp = (data[i] & 0x0F) << 4;
+		tmp |= (data[i] & 0x0F00) << 4;
+		par->board->mmio_write(par, BS_MMIO_DATA, tmp);
+	}
+
+}
+
+static void broadsheet_burst_write(struct broadsheetfb_par *par, int size,
+				   u16 *data)
+{
+	if (par->board->mmio_write)
+		broadsheet_mmio_burst_write(par, size, data);
+	else
+		broadsheet_gpio_burst_write(par, size, data);
+}
+
+static u16 broadsheet_gpio_get_data(struct broadsheetfb_par *par)
 {
 	u16 res;
 	/* wait for ready to go hi. (lo is busy) */
@@ -194,7 +245,16 @@ static u16 broadsheet_get_data(struct br
 	return res;
 }
 
-static void broadsheet_write_reg(struct broadsheetfb_par *par, u16 reg,
+
+static u16 broadsheet_get_data(struct broadsheetfb_par *par)
+{
+	if (par->board->mmio_read)
+		return par->board->mmio_read(par);
+	else
+		return broadsheet_gpio_get_data(par);
+}
+
+static void broadsheet_gpio_write_reg(struct broadsheetfb_par *par, u16 reg,
 					u16 data)
 {
 	/* wait for ready to go hi. (lo is busy) */
@@ -203,16 +263,34 @@ static void broadsheet_write_reg(struct 
 	/* cs lo, dc lo for cmd, we lo for each data, db as usual */
 	par->board->set_ctl(par, BS_CS, 0);
 
-	broadsheet_issue_cmd(par, BS_CMD_WR_REG);
+	broadsheet_gpio_issue_cmd(par, BS_CMD_WR_REG);
 
 	par->board->set_ctl(par, BS_DC, 1);
 
-	broadsheet_issue_data(par, reg);
-	broadsheet_issue_data(par, data);
+	broadsheet_gpio_issue_data(par, reg);
+	broadsheet_gpio_issue_data(par, data);
 
 	par->board->set_ctl(par, BS_CS, 1);
 }
 
+static void broadsheet_mmio_write_reg(struct broadsheetfb_par *par, u16 reg,
+				 u16 data)
+{
+	par->board->mmio_write(par, BS_MMIO_CMD, BS_CMD_WR_REG);
+	par->board->mmio_write(par, BS_MMIO_DATA, reg);
+	par->board->mmio_write(par, BS_MMIO_DATA, data);
+
+}
+
+static void broadsheet_write_reg(struct broadsheetfb_par *par, u16 reg,
+					u16 data)
+{
+	if (par->board->mmio_write)
+		broadsheet_mmio_write_reg(par, reg, data);
+	else
+		broadsheet_gpio_write_reg(par, reg, data);
+}
+
 static void broadsheet_write_reg32(struct broadsheetfb_par *par, u16 reg,
 					u32 data)
 {
@@ -223,8 +301,8 @@ static void broadsheet_write_reg32(struc
 
 static u16 broadsheet_read_reg(struct broadsheetfb_par *par, u16 reg)
 {
-	broadsheet_send_command(par, reg);
-	msleep(100);
+	broadsheet_send_cmdargs(par, BS_CMD_RD_REG, 1, &reg);
+	par->board->wait_for_rdy(par);
 	return broadsheet_get_data(par);
 }
 
diff -puN include/video/broadsheetfb.h~broadsheetfb-add-mmio-hooks include/video/broadsheetfb.h
--- a/include/video/broadsheetfb.h~broadsheetfb-add-mmio-hooks
+++ a/include/video/broadsheetfb.h
@@ -34,6 +34,10 @@
 #define BS_DC 	0x02
 #define BS_WR 	0x03
 
+/* Broadsheet IO interface specific defines */
+#define BS_MMIO_CMD	0x01
+#define BS_MMIO_DATA	0x02
+
 /* struct used by broadsheet. board specific stuff comes from *board */
 struct broadsheetfb_par {
 	struct fb_info *info;
@@ -49,12 +53,17 @@ struct broadsheet_board {
 	struct module *owner;
 	int (*init)(struct broadsheetfb_par *);
 	int (*wait_for_rdy)(struct broadsheetfb_par *);
-	void (*set_ctl)(struct broadsheetfb_par *, unsigned char, u8);
-	void (*set_hdb)(struct broadsheetfb_par *, u16);
-	u16 (*get_hdb)(struct broadsheetfb_par *);
 	void (*cleanup)(struct broadsheetfb_par *);
 	int (*get_panel_type)(void);
 	int (*setup_irq)(struct fb_info *);
-};
 
+	/* Functions for boards that use GPIO */
+	void (*set_ctl)(struct broadsheetfb_par *, unsigned char, u8);
+	void (*set_hdb)(struct broadsheetfb_par *, u16);
+	u16 (*get_hdb)(struct broadsheetfb_par *);
+
+	/* Functions for boards that have specialized MMIO */
+	void (*mmio_write)(struct broadsheetfb_par *, int type, u16);
+	u16 (*mmio_read)(struct broadsheetfb_par *);
+};
 #endif
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

broadsheetfb-add-multiple-panel-type-support.patch
broadsheetfb-add-mmio-hooks.patch

