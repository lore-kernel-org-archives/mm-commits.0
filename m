From: akpm@linux-foundation.org
Subject: [merged] dib3000mc-reduce-large-stack-usage.patch removed from -mm tree
Date: Thu, 06 May 2010 12:08:54 -0400
Message-ID: <201005061910.o46JAO50008529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab0EFTK6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:10:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mchehab@infradead.org, obi@linuxtv.org, pboettcher@dibcom.fr, mm-commits@vger.kernel.org


The patch titled
     dib3000mc: reduce large stack usage
has been removed from the -mm tree.  Its filename was
     dib3000mc-reduce-large-stack-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Andreas Oberritter <obi@linuxtv.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/dib3000mc.c |   35 +++++++++++++---------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN drivers/media/dvb/frontends/dib3000mc.c~dib3000mc-reduce-large-stack-usage drivers/media/dvb/frontends/dib3000mc.c
--- a/drivers/media/dvb/frontends/dib3000mc.c~dib3000mc-reduce-large-stack-usage
+++ a/drivers/media/dvb/frontends/dib3000mc.c
@@ -814,42 +814,51 @@ EXPORT_SYMBOL(dib3000mc_set_config);
 
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

origin.patch
linux-next.patch
virtio_9ph-include-linux-typesh.patch
dib3000mc-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

