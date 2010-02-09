From: akpm@linux-foundation.org
Subject: + dib3000mc-reduce-large-stack-usage.patch added to -mm tree
Date: Tue, 09 Feb 2010 14:20:47 -0800
Message-ID: <201002092220.o19MKlX9005118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316Ab0BIWVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 17:21:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mchehab@infradead.org, pboettcher@dibcom.fr


The patch titled
     dib3000mc: reduce large stack usage
has been added to the -mm tree.  Its filename is
     dib3000mc-reduce-large-stack-usage.patch

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
Subject: dib3000mc: reduce large stack usage
From: Randy Dunlap <randy.dunlap@oracle.com>

Reduce the static stack usage of one of the 2 top offenders as listed by
'make checkstack':

Building with CONFIG_FRAME_WARN=2048 produces:

drivers/media/dvb/frontends/dib3000mc.c:853: warning: the frame size of 2224 bytes is larger than 2048 bytes

and in 'make checkstack', the stack usage goes from:
0x00000bbd dib3000mc_i2c_enumeration [dib3000mc]:	2232
to unlisted with this patch.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Patrick Boettcher <pboettcher@dibcom.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/dib3000mc.c |   35 +++++++++++++---------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN drivers/media/dvb/frontends/dib3000mc.c~dib3000mc-reduce-large-stack-usage drivers/media/dvb/frontends/dib3000mc.c
--- a/drivers/media/dvb/frontends/dib3000mc.c~dib3000mc-reduce-large-stack-usage
+++ a/drivers/media/dvb/frontends/dib3000mc.c
@@ -813,42 +813,51 @@ EXPORT_SYMBOL(dib3000mc_set_config);
 
 int dib3000mc_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib3000mc_config cfg[])
 {
-	struct dib3000mc_state st = { .i2c_adap = i2c };
+	struct dib3000mc_state *dmcst;
 	int k;
 	u8 new_addr;
 
 	static u8 DIB3000MC_I2C_ADDRESS[] = {20,22,24,26};
 
+	dmcst = kzalloc(sizeof(struct dib3000mc_state), GFP_KERNEL);
+	if (dmcst == NULL)
+		return -ENODEV;
+
+	dmcst->i2c_adap = i2c;
+
 	for (k = no_of_demods-1; k >= 0; k--) {
-		st.cfg = &cfg[k];
+		dmcst->cfg = &cfg[k];
 
 		/* designated i2c address */
 		new_addr          = DIB3000MC_I2C_ADDRESS[k];
-		st.i2c_addr = new_addr;
-		if (dib3000mc_identify(&st) != 0) {
-			st.i2c_addr = default_addr;
-			if (dib3000mc_identify(&st) != 0) {
+		dmcst->i2c_addr = new_addr;
+		if (dib3000mc_identify(dmcst) != 0) {
+			dmcst->i2c_addr = default_addr;
+			if (dib3000mc_identify(dmcst) != 0) {
 				dprintk("-E-  DiB3000P/MC #%d: not identified\n", k);
+				kfree(dmcst);
 				return -ENODEV;
 			}
 		}
 
-		dib3000mc_set_output_mode(&st, OUTMODE_MPEG2_PAR_CONT_CLK);
+		dib3000mc_set_output_mode(dmcst, OUTMODE_MPEG2_PAR_CONT_CLK);
 
 		// set new i2c address and force divstr (Bit 1) to value 0 (Bit 0)
-		dib3000mc_write_word(&st, 1024, (new_addr << 3) | 0x1);
-		st.i2c_addr = new_addr;
+		dib3000mc_write_word(dmcst, 1024, (new_addr << 3) | 0x1);
+		dmcst->i2c_addr = new_addr;
 	}
 
 	for (k = 0; k < no_of_demods; k++) {
-		st.cfg = &cfg[k];
-		st.i2c_addr = DIB3000MC_I2C_ADDRESS[k];
+		dmcst->cfg = &cfg[k];
+		dmcst->i2c_addr = DIB3000MC_I2C_ADDRESS[k];
 
-		dib3000mc_write_word(&st, 1024, st.i2c_addr << 3);
+		dib3000mc_write_word(dmcst, 1024, dmcst->i2c_addr << 3);
 
 		/* turn off data output */
-		dib3000mc_set_output_mode(&st, OUTMODE_HIGH_Z);
+		dib3000mc_set_output_mode(dmcst, OUTMODE_HIGH_Z);
 	}
+
+	kfree(dmcst);
 	return 0;
 }
 EXPORT_SYMBOL(dib3000mc_i2c_enumeration);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
msi-laptop-depends-on-rfkill.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
i2c-fix-xiic-build-error.patch
pci-hotplug-fix-ibmphp-build-error.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

