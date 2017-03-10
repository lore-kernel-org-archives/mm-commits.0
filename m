From: akpm@linux-foundation.org
Subject: [patch 03/26] scripts/spelling.txt: add "overide" pattern and fix typo instances
Date: Thu, 09 Mar 2017 16:16:33 -0800
Message-ID: <58c1f061.y50Zmm+etaA5ukDX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753417AbdCJAQf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "overide" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  overide||override

While we are here, fix the doubled "address" in the touched line
Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt.

Also, fix the comment block style in the touched hunks in
drivers/media/dvb-frontends/drx39xyj/drx_driver.h.

Link: http://lkml.kernel.org/r/1481573103-11329-21-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt |    2 +-
 drivers/block/paride/pcd.c                                       |    2 +-
 drivers/block/paride/pd.c                                        |    2 +-
 drivers/block/paride/pf.c                                        |    2 +-
 drivers/block/paride/pg.c                                        |    2 +-
 drivers/block/paride/pt.c                                        |    2 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h                |    8 +++-----
 drivers/net/ethernet/qlogic/qlge/qlge.h                          |    2 +-
 include/dt-bindings/sound/cs42l42.h                              |    2 +-
 include/net/irda/timer.h                                         |    2 +-
 kernel/trace/trace_stack.c                                       |    2 +-
 scripts/spelling.txt                                             |    1 +
 tools/lguest/lguest.c                                            |    2 +-
 tools/lib/bpf/Makefile                                           |    2 +-
 tools/lib/traceevent/Makefile                                    |    2 +-
 tools/lib/traceevent/event-parse.h                               |    2 +-
 16 files changed, 18 insertions(+), 19 deletions(-)

diff -puN Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
--- a/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
@@ -45,7 +45,7 @@ Required Properties:
 Optional Properties:
 - reg-names: In addition to the required properties, the following are optional
   - "efuse-address"	- Contains efuse base address used to pick up ABB info.
-  - "ldo-address"	- Contains address of ABB LDO overide register address.
+  - "ldo-address"	- Contains address of ABB LDO override register.
 	"efuse-address" is required for this.
 - ti,ldovbb-vset-mask	- Required if ldo-address is set, mask for LDO override
 	register to provide override vset value.
diff -puN drivers/block/paride/pcd.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances drivers/block/paride/pcd.c
--- a/drivers/block/paride/pcd.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/drivers/block/paride/pcd.c
@@ -50,7 +50,7 @@
                         the slower the port i/o.  In some cases, setting
                         this to zero will speed up the device. (default -1)
                         
-            major       You may use this parameter to overide the
+            major       You may use this parameter to override the
                         default major number (46) that this driver
                         will use.  Be sure to change the device
                         name as well.
diff -puN drivers/block/paride/pd.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances drivers/block/paride/pd.c
--- a/drivers/block/paride/pd.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/drivers/block/paride/pd.c
@@ -61,7 +61,7 @@
                         first drive found.
 			
 
-            major       You may use this parameter to overide the
+            major       You may use this parameter to override the
                         default major number (45) that this driver
                         will use.  Be sure to change the device
                         name as well.
diff -puN drivers/block/paride/pf.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances drivers/block/paride/pf.c
--- a/drivers/block/paride/pf.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/drivers/block/paride/pf.c
@@ -59,7 +59,7 @@
                         the slower the port i/o.  In some cases, setting
                         this to zero will speed up the device. (default -1)
 
-	    major	You may use this parameter to overide the
+	    major	You may use this parameter to override the
 			default major number (47) that this driver
 			will use.  Be sure to change the device
 			name as well.
diff -puN drivers/block/paride/pg.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/drivers/block/paride/pg.c
@@ -84,7 +84,7 @@
 			the slower the port i/o.  In some cases, setting
 			this to zero will speed up the device. (default -1)
 
-	    major	You may use this parameter to overide the
+	    major	You may use this parameter to override the
 			default major number (97) that this driver
 			will use.  Be sure to change the device
 			name as well.
diff -puN drivers/block/paride/pt.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances drivers/block/paride/pt.c
--- a/drivers/block/paride/pt.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/drivers/block/paride/pt.c
@@ -61,7 +61,7 @@
                         the slower the port i/o.  In some cases, setting
                         this to zero will speed up the device. (default -1)
 
-	    major	You may use this parameter to overide the
+	    major	You may use this parameter to override the
 			default major number (96) that this driver
 			will use.  Be sure to change the device
 			name as well.
diff -puN drivers/media/dvb-frontends/drx39xyj/drx_driver.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances drivers/media/dvb-frontends/drx39xyj/drx_driver.h
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -256,8 +256,7 @@ int drxbsp_tuner_default_i2c_write_read(
 *
 * The actual DAP implementation may be restricted to only one of the modes.
 * A compiler warning or error will be generated if the DAP implementation
-* overides or cannot handle the mode defined below.
-*
+* overrides or cannot handle the mode defined below.
 */
 #ifndef DRXDAP_SINGLE_MASTER
 #define DRXDAP_SINGLE_MASTER 1
@@ -272,7 +271,7 @@ int drxbsp_tuner_default_i2c_write_read(
 *
 * This maximum size may be restricted by the actual DAP implementation.
 * A compiler warning or error will be generated if the DAP implementation
-* overides or cannot handle the chunksize defined below.
+* overrides or cannot handle the chunksize defined below.
 *
 * Beware that the DAP uses  DRXDAP_MAX_WCHUNKSIZE to create a temporary data
 * buffer. Do not undefine or choose too large, unless your system is able to
@@ -292,8 +291,7 @@ int drxbsp_tuner_default_i2c_write_read(
 *
 * This maximum size may be restricted by the actual DAP implementation.
 * A compiler warning or error will be generated if the DAP implementation
-* overides or cannot handle the chunksize defined below.
-*
+* overrides or cannot handle the chunksize defined below.
 */
 #ifndef DRXDAP_MAX_RCHUNKSIZE
 #define  DRXDAP_MAX_RCHUNKSIZE 60
diff -puN drivers/net/ethernet/qlogic/qlge/qlge.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances drivers/net/ethernet/qlogic/qlge/qlge.h
--- a/drivers/net/ethernet/qlogic/qlge/qlge.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/qlogic/qlge/qlge.h
@@ -1162,7 +1162,7 @@ struct ob_mac_tso_iocb_rsp {
 struct ib_mac_iocb_rsp {
 	u8 opcode;		/* 0x20 */
 	u8 flags1;
-#define IB_MAC_IOCB_RSP_OI	0x01	/* Overide intr delay */
+#define IB_MAC_IOCB_RSP_OI	0x01	/* Override intr delay */
 #define IB_MAC_IOCB_RSP_I	0x02	/* Disable Intr Generation */
 #define IB_MAC_CSUM_ERR_MASK 0x1c	/* A mask to use for csum errs */
 #define IB_MAC_IOCB_RSP_TE	0x04	/* Checksum error */
diff -puN include/dt-bindings/sound/cs42l42.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances include/dt-bindings/sound/cs42l42.h
--- a/include/dt-bindings/sound/cs42l42.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/include/dt-bindings/sound/cs42l42.h
@@ -20,7 +20,7 @@
 #define CS42L42_HPOUT_LOAD_1NF		0
 #define CS42L42_HPOUT_LOAD_10NF		1
 
-/* HPOUT Clamp to GND Overide */
+/* HPOUT Clamp to GND Override */
 #define CS42L42_HPOUT_CLAMP_EN		0
 #define CS42L42_HPOUT_CLAMP_DIS		1
 
diff -puN include/net/irda/timer.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances include/net/irda/timer.h
--- a/include/net/irda/timer.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/include/net/irda/timer.h
@@ -59,7 +59,7 @@ struct lap_cb;
  *  Slot timer must never exceed 85 ms, and must always be at least 25 ms, 
  *  suggested to  75-85 msec by IrDA lite. This doesn't work with a lot of
  *  devices, and other stackes uses a lot more, so it's best we do it as well
- *  (Note : this is the default value and sysctl overides it - Jean II)
+ *  (Note : this is the default value and sysctl overrides it - Jean II)
  */
 #define SLOT_TIMEOUT            (90*HZ/1000)
 
diff -puN kernel/trace/trace_stack.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances kernel/trace/trace_stack.c
--- a/kernel/trace/trace_stack.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/kernel/trace/trace_stack.c
@@ -65,7 +65,7 @@ void stack_trace_print(void)
 }
 
 /*
- * When arch-specific code overides this function, the following
+ * When arch-specific code overrides this function, the following
  * data should be filled up, assuming stack_trace_max_lock is held to
  * prevent concurrent updates.
  *     stack_trace_index[]
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -734,6 +734,7 @@ oustanding||outstanding
 overaall||overall
 overhread||overhead
 overlaping||overlapping
+overide||override
 overrided||overridden
 overriden||overridden
 overun||overrun
diff -puN tools/lguest/lguest.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances tools/lguest/lguest.c
--- a/tools/lguest/lguest.c~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/tools/lguest/lguest.c
@@ -1387,7 +1387,7 @@ static bool pci_data_iowrite(u16 port, u
 		/* Allow writing to any other BAR, or expansion ROM */
 		iowrite(portoff, val, mask, &d->config_words[reg]);
 		return true;
-		/* We let them overide latency timer and cacheline size */
+		/* We let them override latency timer and cacheline size */
 	} else if (&d->config_words[reg] == (void *)&d->config.cacheline_size) {
 		/* Only let them change the first two fields. */
 		if (mask == 0xFFFFFFFF)
diff -puN tools/lib/bpf/Makefile~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances tools/lib/bpf/Makefile
--- a/tools/lib/bpf/Makefile~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/tools/lib/bpf/Makefile
@@ -132,7 +132,7 @@ else
   Q = @
 endif
 
-# Disable command line variables (CFLAGS) overide from top
+# Disable command line variables (CFLAGS) override from top
 # level Makefile (perf), otherwise build Makefile will get
 # the same command line setup.
 MAKEOVERRIDES=
diff -puN tools/lib/traceevent/Makefile~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances tools/lib/traceevent/Makefile
--- a/tools/lib/traceevent/Makefile~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/tools/lib/traceevent/Makefile
@@ -135,7 +135,7 @@ else
   Q = @
 endif
 
-# Disable command line variables (CFLAGS) overide from top
+# Disable command line variables (CFLAGS) override from top
 # level Makefile (perf), otherwise build Makefile will get
 # the same command line setup.
 MAKEOVERRIDES=
diff -puN tools/lib/traceevent/event-parse.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances tools/lib/traceevent/event-parse.h
--- a/tools/lib/traceevent/event-parse.h~scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances
+++ a/tools/lib/traceevent/event-parse.h
@@ -140,7 +140,7 @@ struct pevent_plugin_option {
  *   struct pevent_plugin_option PEVENT_PLUGIN_OPTIONS[] = {
  *	{
  *		.name = "option-name",
- *		.plugin_alias = "overide-file-name", (optional)
+ *		.plugin_alias = "override-file-name", (optional)
  *		.description = "description of option to show users",
  *	},
  *	{
_
