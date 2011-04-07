From: akpm@linux-foundation.org
Subject: + w1-add-1-wire-w1-reset-and-resume-command-api-support.patch added to -mm tree
Date: Thu, 07 Apr 2011 15:43:38 -0700
Message-ID: <201104072243.p37Mhd06004872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756878Ab1DGWo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 18:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dagenaisj@sonatest.com, johnpol@2ka.mipt.ru, mreimer@vpop.net, szabolcs.gyurko@tlt.hu


The patch titled
     w1: add 1-wire (w1) reset and resume command API support
has been added to the -mm tree.  Its filename is
     w1-add-1-wire-w1-reset-and-resume-command-api-support.patch

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
Subject: w1: add 1-wire (w1) reset and resume command API support
=46rom: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>

The first patch adds generic functionnality to w1_io for Resume Command
[A5h] lots of slaves support.  I found it useful for multi-commands/res=
et
workflows with the same slave on a multi-slave bus.

This DS2408 w1 slave driver is not complete for all the features of the
chip, but its sufficient if you use it as a simple IO expander.  Enjoy!

The ds1wm had Kconfig dependencies towards ARM && HAVE_CLK.  I took the=
m
out since I was using the ds1wm on an x86_64 platform (ds1wm in a FPGA
through pcie) and found them irrelevant.

The clock freq/divisors at the top of ds1wm.c did not have the MSB set =
to
1.  This bit is CLK_EN which turns the whole prescaler and dividers on.=
=20
The driver never mentionned this bit either, so I just included this bi=
t
right in the table entries.  I also took the liberty to add a couple of
entries to the table.  The spec doesn't explicitely mentions these
possibilities but the description and examination of the core shows the
prescalers & dividers can be used for more than the table explicitely
shows.  The table I enlarged still doesn't cover all possibilities, but
it's a good start.

I also made a few tweaks to a couple of the read and write algorithms
which made sense while I had my head very deep in the ds1wm documentati=
on.
 We stressed it a lot with 10+ slaves on the bus, many ds2408, ds2431 a=
nd
ds2433 at the same time doing extensive interaction.  It proved quite
stable in our production environment.

This patch:

Add generic functionnality to w1_io for Resume Command [A5h] lots of
slaves support.

Signed-off-by: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.h    |    2 ++
 drivers/w1/w1_io.c |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN drivers/w1/w1.h~w1-add-1-wire-w1-reset-and-resume-command-api=
-support drivers/w1/w1.h
--- a/drivers/w1/w1.h~w1-add-1-wire-w1-reset-and-resume-command-api-sup=
port
+++ a/drivers/w1/w1.h
@@ -55,6 +55,7 @@ struct w1_reg_num
 #define W1_READ_ROM		0x33
 #define W1_READ_PSUPPLY		0xB4
 #define W1_MATCH_ROM		0x55
+#define W1_RESUME_CMD		0xA5
=20
 #define W1_SLAVE_ACTIVE		0
=20
@@ -213,6 +214,7 @@ void w1_write_block(struct w1_master *,=20
 void w1_touch_block(struct w1_master *, u8 *, int);
 u8 w1_read_block(struct w1_master *, u8 *, int);
 int w1_reset_select_slave(struct w1_slave *sl);
+int w1_reset_resume_command(struct w1_master *);
 void w1_next_pullup(struct w1_master *, int);
=20
 static inline struct w1_slave* dev_to_w1_slave(struct device *dev)
diff -puN drivers/w1/w1_io.c~w1-add-1-wire-w1-reset-and-resume-command-=
api-support drivers/w1/w1_io.c
--- a/drivers/w1/w1_io.c~w1-add-1-wire-w1-reset-and-resume-command-api-=
support
+++ a/drivers/w1/w1_io.c
@@ -390,6 +390,32 @@ int w1_reset_select_slave(struct w1_slav
 EXPORT_SYMBOL_GPL(w1_reset_select_slave);
=20
 /**
+ * When the workflow with a slave amongst many requires several
+ * successive commands a reset between each, this function is similar
+ * to doing a reset then a match ROM for the last matched ROM. The
+ * advantage being that the matched ROM step is skipped in favor of th=
e
+ * resume command. The slave must support the command of course.
+ *
+ * If the bus has only one slave, traditionnaly the match ROM is skipp=
ed
+ * and a "SKIP ROM" is done for efficiency. On multi-slave busses, thi=
s
+ * doesn't work of course, but the resume command is the next best thi=
ng.
+ *
+ * The w1 master lock must be held.
+ *
+ * @param dev     the master device
+ */
+int w1_reset_resume_command(struct w1_master *dev)
+{
+	if (w1_reset_bus(dev))
+		return -1;
+
+	/* This will make only the last matched slave perform a skip ROM. */
+	w1_write_8(dev, W1_RESUME_CMD);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(w1_reset_resume_command);
+
+/**
  * Put out a strong pull-up of the specified duration after the next w=
rite
  * operation.  Not all hardware supports strong pullups.  Hardware tha=
t
  * doesn't support strong pullups will sleep for the given time after =
the
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
