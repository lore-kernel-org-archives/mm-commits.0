From: akpm@osdl.org
Subject: - add-include-linux-freezerh-and-move-definitions-from.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:24 -0800
Message-ID: <200612072259.kB7MxOEk029510@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163677AbWLGW7n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ncunningham@linuxmail.org, nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Add include/linux/freezer.h and move definitions from sched.h
has been removed from the -mm tree.  Its filename was
     add-include-linux-freezerh-and-move-definitions-from.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add include/linux/freezer.h and move definitions from sched.h
From: Nigel Cunningham <ncunningham@linuxmail.org>

Move process freezing functions from include/linux/sched.h to freezer.h, so
that modifications to the freezer or the kernel configuration don't require
recompiling just about everything.

[akpm@osdl.org: fix ueagle driver]
Signed-off-by: Nigel Cunningham <nigel@suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/kernel/signal.c                  |    1 
 arch/avr32/kernel/signal.c                |    2 
 arch/frv/kernel/signal.c                  |    2 
 arch/h8300/kernel/signal.c                |    2 
 arch/i386/kernel/io_apic.c                |    1 
 arch/m32r/kernel/signal.c                 |    2 
 arch/powerpc/kernel/signal_32.c           |    2 
 arch/sh/kernel/signal.c                   |    1 
 arch/sh64/kernel/signal.c                 |    2 
 drivers/block/pktcdvd.c                   |    2 
 drivers/char/hvc_console.c                |    1 
 drivers/edac/edac_mc.c                    |    1 
 drivers/ieee1394/nodemgr.c                |    1 
 drivers/input/gameport/gameport.c         |    1 
 drivers/input/serio/serio.c               |    1 
 drivers/macintosh/therm_adt746x.c         |    1 
 drivers/macintosh/via-pmu.c               |    2 
 drivers/macintosh/windfarm_core.c         |    1 
 drivers/md/md.c                           |    2 
 drivers/media/dvb/dvb-core/dvb_frontend.c |    2 
 drivers/media/video/msp3400-driver.c      |    2 
 drivers/media/video/tvaudio.c             |    1 
 drivers/media/video/video-buf-dvb.c       |    2 
 drivers/media/video/vivi.c                |    1 
 drivers/mfd/ucb1x00-ts.c                  |    2 
 drivers/net/irda/stir4200.c               |    1 
 drivers/net/wireless/airo.c               |    1 
 drivers/pcmcia/cs.c                       |    1 
 drivers/pnp/pnpbios/core.c                |    1 
 drivers/usb/atm/ueagle-atm.c              |    2 
 drivers/usb/core/hub.c                    |    1 
 drivers/usb/gadget/file_storage.c         |    2 
 drivers/usb/storage/usb.c                 |    2 
 drivers/w1/w1.c                           |    1 
 fs/afs/kafsasyncd.c                       |    1 
 fs/afs/kafstimod.c                        |    1 
 fs/cifs/cifsfs.c                          |    1 
 fs/cifs/connect.c                         |    1 
 fs/jbd/journal.c                          |    2 
 fs/jbd2/journal.c                         |    2 
 fs/jffs/intrep.c                          |    1 
 fs/jffs2/background.c                     |    1 
 fs/jfs/jfs_logmgr.c                       |    2 
 fs/jfs/jfs_txnmgr.c                       |    2 
 fs/lockd/clntproc.c                       |    1 
 fs/xfs/linux-2.6/xfs_buf.c                |    1 
 fs/xfs/linux-2.6/xfs_super.c              |    1 
 include/linux/freezer.h                   |   84 ++++++++++++++++++++
 include/linux/sched.h                     |   81 -------------------
 init/do_mounts_initrd.c                   |    1 
 kernel/audit.c                            |    1 
 kernel/power/disk.c                       |    1 
 kernel/power/main.c                       |    1 
 kernel/power/process.c                    |    1 
 kernel/power/user.c                       |    1 
 kernel/rtmutex-tester.c                   |    1 
 kernel/sched.c                            |    2 
 kernel/signal.c                           |    1 
 mm/pdflush.c                              |    1 
 mm/vmscan.c                               |    1 
 net/rxrpc/krxiod.c                        |    1 
 net/rxrpc/krxsecd.c                       |    1 
 net/rxrpc/krxtimod.c                      |    1 
 net/sunrpc/svcsock.c                      |    1 
 64 files changed, 147 insertions(+), 101 deletions(-)

diff -puN arch/arm/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from arch/arm/kernel/signal.c
--- a/arch/arm/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/arch/arm/kernel/signal.c
@@ -11,6 +11,7 @@
 #include <linux/signal.h>
 #include <linux/ptrace.h>
 #include <linux/personality.h>
+#include <linux/freezer.h>
 
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
diff -puN arch/avr32/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from arch/avr32/kernel/signal.c
--- a/arch/avr32/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/arch/avr32/kernel/signal.c
@@ -15,7 +15,7 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/ucontext.h>
diff -puN arch/frv/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from arch/frv/kernel/signal.c
--- a/arch/frv/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/arch/frv/kernel/signal.c
@@ -21,7 +21,7 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/personality.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff -puN arch/h8300/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from arch/h8300/kernel/signal.c
--- a/arch/h8300/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/arch/h8300/kernel/signal.c
@@ -38,7 +38,7 @@
 #include <linux/personality.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
diff -puN arch/i386/kernel/io_apic.c~add-include-linux-freezerh-and-move-definitions-from arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/arch/i386/kernel/io_apic.c
@@ -34,6 +34,7 @@
 #include <linux/pci.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
+#include <linux/freezer.h>
 
 #include <asm/io.h>
 #include <asm/smp.h>
diff -puN arch/m32r/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from arch/m32r/kernel/signal.c
--- a/arch/m32r/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/arch/m32r/kernel/signal.c
@@ -21,7 +21,7 @@
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/personality.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff -puN arch/powerpc/kernel/signal_32.c~add-include-linux-freezerh-and-move-definitions-from arch/powerpc/kernel/signal_32.c
--- a/arch/powerpc/kernel/signal_32.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/arch/powerpc/kernel/signal_32.c
@@ -36,7 +36,7 @@
 #include <linux/stddef.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #endif
 
 #include <asm/uaccess.h>
diff -puN arch/sh/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from arch/sh/kernel/signal.c
--- a/arch/sh/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/arch/sh/kernel/signal.c
@@ -23,6 +23,7 @@
 #include <linux/elf.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
+#include <linux/freezer.h>
 
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff -puN arch/sh64/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from arch/sh64/kernel/signal.c
--- a/arch/sh64/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/arch/sh64/kernel/signal.c
@@ -22,7 +22,7 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/personality.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
diff -puN drivers/block/pktcdvd.c~add-include-linux-freezerh-and-move-definitions-from drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/block/pktcdvd.c
@@ -54,7 +54,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/miscdevice.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/mutex.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_ioctl.h>
diff -puN drivers/char/hvc_console.c~add-include-linux-freezerh-and-move-definitions-from drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/char/hvc_console.c
@@ -38,6 +38,7 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 
diff -puN drivers/edac/edac_mc.c~add-include-linux-freezerh-and-move-definitions-from drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/edac/edac_mc.c
@@ -28,6 +28,7 @@
 #include <linux/sysdev.h>
 #include <linux/ctype.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/edac.h>
diff -puN drivers/ieee1394/nodemgr.c~add-include-linux-freezerh-and-move-definitions-from drivers/ieee1394/nodemgr.c
--- a/drivers/ieee1394/nodemgr.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/ieee1394/nodemgr.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/moduleparam.h>
+#include <linux/freezer.h>
 #include <asm/atomic.h>
 
 #include "csr.h"
diff -puN drivers/input/gameport/gameport.c~add-include-linux-freezerh-and-move-definitions-from drivers/input/gameport/gameport.c
--- a/drivers/input/gameport/gameport.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/input/gameport/gameport.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>	/* HZ */
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 /*#include <asm/io.h>*/
 
diff -puN drivers/input/serio/serio.c~add-include-linux-freezerh-and-move-definitions-from drivers/input/serio/serio.c
--- a/drivers/input/serio/serio.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/input/serio/serio.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Serio abstraction core");
diff -puN drivers/macintosh/therm_adt746x.c~add-include-linux-freezerh-and-move-definitions-from drivers/macintosh/therm_adt746x.c
--- a/drivers/macintosh/therm_adt746x.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/macintosh/therm_adt746x.c
@@ -24,6 +24,7 @@
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/moduleparam.h>
+#include <linux/freezer.h>
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
diff -puN drivers/macintosh/via-pmu.c~add-include-linux-freezerh-and-move-definitions-from drivers/macintosh/via-pmu.c
--- a/drivers/macintosh/via-pmu.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/macintosh/via-pmu.c
@@ -42,7 +42,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/sysdev.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/syscalls.h>
 #include <linux/cpu.h>
 #include <asm/prom.h>
diff -puN drivers/macintosh/windfarm_core.c~add-include-linux-freezerh-and-move-definitions-from drivers/macintosh/windfarm_core.c
--- a/drivers/macintosh/windfarm_core.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/macintosh/windfarm_core.c
@@ -34,6 +34,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <asm/prom.h>
 
diff -puN drivers/md/md.c~add-include-linux-freezerh-and-move-definitions-from drivers/md/md.c
--- a/drivers/md/md.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/md/md.c
@@ -39,10 +39,10 @@
 #include <linux/raid/bitmap.h>
 #include <linux/sysctl.h>
 #include <linux/buffer_head.h> /* for invalidate_bdev */
-#include <linux/suspend.h>
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/ctype.h>
+#include <linux/freezer.h>
 
 #include <linux/init.h>
 
diff -puN drivers/media/dvb/dvb-core/dvb_frontend.c~add-include-linux-freezerh-and-move-definitions-from drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -34,7 +34,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/list.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/jiffies.h>
 #include <asm/processor.h>
 
diff -puN drivers/media/video/msp3400-driver.c~add-include-linux-freezerh-and-move-definitions-from drivers/media/video/msp3400-driver.c
--- a/drivers/media/video/msp3400-driver.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/media/video/msp3400-driver.c
@@ -56,7 +56,7 @@
 #include <media/tvaudio.h>
 #include <media/msp3400.h>
 #include <linux/kthread.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include "msp3400-driver.h"
 
 /* ---------------------------------------------------------------------- */
diff -puN drivers/media/video/tvaudio.c~add-include-linux-freezerh-and-move-definitions-from drivers/media/video/tvaudio.c
--- a/drivers/media/video/tvaudio.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/media/video/tvaudio.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/smp_lock.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <media/tvaudio.h>
 #include <media/v4l2-common.h>
diff -puN drivers/media/video/video-buf-dvb.c~add-include-linux-freezerh-and-move-definitions-from drivers/media/video/video-buf-dvb.c
--- a/drivers/media/video/video-buf-dvb.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/media/video/video-buf-dvb.c
@@ -20,7 +20,7 @@
 #include <linux/fs.h>
 #include <linux/kthread.h>
 #include <linux/file.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 
 #include <media/video-buf.h>
 #include <media/video-buf-dvb.h>
diff -puN drivers/media/video/vivi.c~add-include-linux-freezerh-and-move-definitions-from drivers/media/video/vivi.c
--- a/drivers/media/video/vivi.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/media/video/vivi.c
@@ -36,6 +36,7 @@
 #include <media/v4l2-common.h>
 #include <linux/kthread.h>
 #include <linux/highmem.h>
+#include <linux/freezer.h>
 
 /* Wake up at about 30 fps */
 #define WAKE_NUMERATOR 30
diff -puN drivers/mfd/ucb1x00-ts.c~add-include-linux-freezerh-and-move-definitions-from drivers/mfd/ucb1x00-ts.c
--- a/drivers/mfd/ucb1x00-ts.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/mfd/ucb1x00-ts.c
@@ -28,7 +28,7 @@
 #include <linux/string.h>
 #include <linux/input.h>
 #include <linux/device.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
 
diff -puN drivers/net/irda/stir4200.c~add-include-linux-freezerh-and-move-definitions-from drivers/net/irda/stir4200.c
--- a/drivers/net/irda/stir4200.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/net/irda/stir4200.c
@@ -50,6 +50,7 @@
 #include <linux/usb.h>
 #include <linux/crc32.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <net/irda/irda.h>
 #include <net/irda/irlap.h>
 #include <net/irda/irda_device.h>
diff -puN drivers/net/wireless/airo.c~add-include-linux-freezerh-and-move-definitions-from drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/net/wireless/airo.c
@@ -49,6 +49,7 @@
 #include <asm/uaccess.h>
 #include <net/ieee80211.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include "airo.h"
 
diff -puN drivers/pcmcia/cs.c~add-include-linux-freezerh-and-move-definitions-from drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/pcmcia/cs.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <asm/system.h>
 #include <asm/irq.h>
 
diff -puN drivers/pnp/pnpbios/core.c~add-include-linux-freezerh-and-move-definitions-from drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/pnp/pnpbios/core.c
@@ -61,6 +61,7 @@
 #include <linux/dmi.h>
 #include <linux/delay.h>
 #include <linux/acpi.h>
+#include <linux/freezer.h>
 
 #include <asm/page.h>
 #include <asm/desc.h>
diff -puN drivers/usb/atm/ueagle-atm.c~add-include-linux-freezerh-and-move-definitions-from drivers/usb/atm/ueagle-atm.c
--- a/drivers/usb/atm/ueagle-atm.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/usb/atm/ueagle-atm.c
@@ -64,6 +64,8 @@
 #include <linux/kthread.h>
 #include <linux/version.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
+
 #include <asm/unaligned.h>
 
 #include "usbatm.h"
diff -puN drivers/usb/core/hub.c~add-include-linux-freezerh-and-move-definitions-from drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/usb/core/hub.c
@@ -22,6 +22,7 @@
 #include <linux/usbdevice_fs.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
diff -puN drivers/usb/gadget/file_storage.c~add-include-linux-freezerh-and-move-definitions-from drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/usb/gadget/file_storage.c
@@ -250,7 +250,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/utsname.h>
 
 #include <linux/usb_ch9.h>
diff -puN drivers/usb/storage/usb.c~add-include-linux-freezerh-and-move-definitions-from drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/usb/storage/usb.c
@@ -49,7 +49,7 @@
 
 #include <linux/sched.h>
 #include <linux/errno.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff -puN drivers/w1/w1.c~add-include-linux-freezerh-and-move-definitions-from drivers/w1/w1.c
--- a/drivers/w1/w1.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/drivers/w1/w1.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/atomic.h>
 
diff -puN fs/afs/kafsasyncd.c~add-include-linux-freezerh-and-move-definitions-from fs/afs/kafsasyncd.c
--- a/fs/afs/kafsasyncd.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/afs/kafsasyncd.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
+#include <linux/freezer.h>
 #include "cell.h"
 #include "server.h"
 #include "volume.h"
diff -puN fs/afs/kafstimod.c~add-include-linux-freezerh-and-move-definitions-from fs/afs/kafstimod.c
--- a/fs/afs/kafstimod.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/afs/kafstimod.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
+#include <linux/freezer.h>
 #include "cell.h"
 #include "volume.h"
 #include "kafstimod.h"
diff -puN fs/cifs/cifsfs.c~add-include-linux-freezerh-and-move-definitions-from fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/cifs/cifsfs.c
@@ -34,6 +34,7 @@
 #include <linux/mempool.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
 #define DECLARE_GLOBALS_HERE
diff -puN fs/cifs/connect.c~add-include-linux-freezerh-and-move-definitions-from fs/cifs/connect.c
--- a/fs/cifs/connect.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/cifs/connect.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/completion.h>
 #include <linux/pagevec.h>
+#include <linux/freezer.h>
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 #include "cifspdu.h"
diff -puN fs/jbd/journal.c~add-include-linux-freezerh-and-move-definitions-from fs/jbd/journal.c
--- a/fs/jbd/journal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/jbd/journal.c
@@ -31,7 +31,7 @@
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/mm.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/pagemap.h>
 #include <linux/kthread.h>
 #include <linux/poison.h>
diff -puN fs/jbd2/journal.c~add-include-linux-freezerh-and-move-definitions-from fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/jbd2/journal.c
@@ -31,7 +31,7 @@
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/mm.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/pagemap.h>
 #include <linux/kthread.h>
 #include <linux/poison.h>
diff -puN fs/jffs/intrep.c~add-include-linux-freezerh-and-move-definitions-from fs/jffs/intrep.c
--- a/fs/jffs/intrep.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/jffs/intrep.c
@@ -66,6 +66,7 @@
 #include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/ctype.h>
+#include <linux/freezer.h>
 
 #include "intrep.h"
 #include "jffs_fm.h"
diff -puN fs/jffs2/background.c~add-include-linux-freezerh-and-move-definitions-from fs/jffs2/background.c
--- a/fs/jffs2/background.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/jffs2/background.c
@@ -16,6 +16,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/completion.h>
 #include <linux/sched.h>
+#include <linux/freezer.h>
 #include "nodelist.h"
 
 
diff -puN fs/jfs/jfs_logmgr.c~add-include-linux-freezerh-and-move-definitions-from fs/jfs/jfs_logmgr.c
--- a/fs/jfs/jfs_logmgr.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/jfs/jfs_logmgr.c
@@ -67,7 +67,7 @@
 #include <linux/kthread.h>
 #include <linux/buffer_head.h>		/* for sync_blockdev() */
 #include <linux/bio.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include "jfs_incore.h"
diff -puN fs/jfs/jfs_txnmgr.c~add-include-linux-freezerh-and-move-definitions-from fs/jfs/jfs_txnmgr.c
--- a/fs/jfs/jfs_txnmgr.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/jfs/jfs_txnmgr.c
@@ -46,7 +46,7 @@
 #include <linux/vmalloc.h>
 #include <linux/smp_lock.h>
 #include <linux/completion.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kthread.h>
diff -puN fs/lockd/clntproc.c~add-include-linux-freezerh-and-move-definitions-from fs/lockd/clntproc.c
--- a/fs/lockd/clntproc.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/lockd/clntproc.c
@@ -13,6 +13,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/utsname.h>
 #include <linux/smp_lock.h>
+#include <linux/freezer.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/lockd/lockd.h>
diff -puN fs/xfs/linux-2.6/xfs_buf.c~add-include-linux-freezerh-and-move-definitions-from fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -32,6 +32,7 @@
 #include <linux/kthread.h>
 #include <linux/migrate.h>
 #include <linux/backing-dev.h>
+#include <linux/freezer.h>
 
 STATIC kmem_zone_t *xfs_buf_zone;
 STATIC kmem_shaker_t xfs_buf_shake;
diff -puN fs/xfs/linux-2.6/xfs_super.c~add-include-linux-freezerh-and-move-definitions-from fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -56,6 +56,7 @@
 #include <linux/mempool.h>
 #include <linux/writeback.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 STATIC struct quotactl_ops xfs_quotactl_operations;
 STATIC struct super_operations xfs_super_operations;
diff -puN /dev/null include/linux/freezer.h
--- /dev/null
+++ a/include/linux/freezer.h
@@ -0,0 +1,84 @@
+/* Freezer declarations */
+
+#ifdef CONFIG_PM
+/*
+ * Check if a process has been frozen
+ */
+static inline int frozen(struct task_struct *p)
+{
+	return p->flags & PF_FROZEN;
+}
+
+/*
+ * Check if there is a request to freeze a process
+ */
+static inline int freezing(struct task_struct *p)
+{
+	return p->flags & PF_FREEZE;
+}
+
+/*
+ * Request that a process be frozen
+ * FIXME: SMP problem. We may not modify other process' flags!
+ */
+static inline void freeze(struct task_struct *p)
+{
+	p->flags |= PF_FREEZE;
+}
+
+/*
+ * Sometimes we may need to cancel the previous 'freeze' request
+ */
+static inline void do_not_freeze(struct task_struct *p)
+{
+	p->flags &= ~PF_FREEZE;
+}
+
+/*
+ * Wake up a frozen process
+ */
+static inline int thaw_process(struct task_struct *p)
+{
+	if (frozen(p)) {
+		p->flags &= ~PF_FROZEN;
+		wake_up_process(p);
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * freezing is complete, mark process as frozen
+ */
+static inline void frozen_process(struct task_struct *p)
+{
+	p->flags = (p->flags & ~PF_FREEZE) | PF_FROZEN;
+}
+
+extern void refrigerator(void);
+extern int freeze_processes(void);
+extern void thaw_processes(void);
+
+static inline int try_to_freeze(void)
+{
+	if (freezing(current)) {
+		refrigerator();
+		return 1;
+	} else
+		return 0;
+}
+#else
+static inline int frozen(struct task_struct *p) { return 0; }
+static inline int freezing(struct task_struct *p) { return 0; }
+static inline void freeze(struct task_struct *p) { BUG(); }
+static inline int thaw_process(struct task_struct *p) { return 1; }
+static inline void frozen_process(struct task_struct *p) { BUG(); }
+
+static inline void refrigerator(void) {}
+static inline int freeze_processes(void) { BUG(); return 0; }
+static inline void thaw_processes(void) {}
+
+static inline int try_to_freeze(void) { return 0; }
+
+
+#endif
diff -puN include/linux/sched.h~add-include-linux-freezerh-and-move-definitions-from include/linux/sched.h
--- a/include/linux/sched.h~add-include-linux-freezerh-and-move-definitions-from
+++ a/include/linux/sched.h
@@ -1618,87 +1618,6 @@ extern int sched_create_sysfs_power_savi
 
 extern void normalize_rt_tasks(void);
 
-#ifdef CONFIG_PM
-/*
- * Check if a process has been frozen
- */
-static inline int frozen(struct task_struct *p)
-{
-	return p->flags & PF_FROZEN;
-}
-
-/*
- * Check if there is a request to freeze a process
- */
-static inline int freezing(struct task_struct *p)
-{
-	return p->flags & PF_FREEZE;
-}
-
-/*
- * Request that a process be frozen
- * FIXME: SMP problem. We may not modify other process' flags!
- */
-static inline void freeze(struct task_struct *p)
-{
-	p->flags |= PF_FREEZE;
-}
-
-/*
- * Sometimes we may need to cancel the previous 'freeze' request
- */
-static inline void do_not_freeze(struct task_struct *p)
-{
-	p->flags &= ~PF_FREEZE;
-}
-
-/*
- * Wake up a frozen process
- */
-static inline int thaw_process(struct task_struct *p)
-{
-	if (frozen(p)) {
-		p->flags &= ~PF_FROZEN;
-		wake_up_process(p);
-		return 1;
-	}
-	return 0;
-}
-
-/*
- * freezing is complete, mark process as frozen
- */
-static inline void frozen_process(struct task_struct *p)
-{
-	p->flags = (p->flags & ~PF_FREEZE) | PF_FROZEN;
-}
-
-extern void refrigerator(void);
-extern int freeze_processes(void);
-extern void thaw_processes(void);
-
-static inline int try_to_freeze(void)
-{
-	if (freezing(current)) {
-		refrigerator();
-		return 1;
-	} else
-		return 0;
-}
-#else
-static inline int frozen(struct task_struct *p) { return 0; }
-static inline int freezing(struct task_struct *p) { return 0; }
-static inline void freeze(struct task_struct *p) { BUG(); }
-static inline int thaw_process(struct task_struct *p) { return 1; }
-static inline void frozen_process(struct task_struct *p) { BUG(); }
-
-static inline void refrigerator(void) {}
-static inline int freeze_processes(void) { BUG(); return 0; }
-static inline void thaw_processes(void) {}
-
-static inline int try_to_freeze(void) { return 0; }
-
-#endif /* CONFIG_PM */
 #endif /* __KERNEL__ */
 
 #endif
diff -puN init/do_mounts_initrd.c~add-include-linux-freezerh-and-move-definitions-from init/do_mounts_initrd.c
--- a/init/do_mounts_initrd.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/init/do_mounts_initrd.c
@@ -6,6 +6,7 @@
 #include <linux/romfs_fs.h>
 #include <linux/initrd.h>
 #include <linux/sched.h>
+#include <linux/freezer.h>
 
 #include "do_mounts.h"
 
diff -puN kernel/audit.c~add-include-linux-freezerh-and-move-definitions-from kernel/audit.c
--- a/kernel/audit.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/kernel/audit.c
@@ -57,6 +57,7 @@
 #include <linux/netlink.h>
 #include <linux/selinux.h>
 #include <linux/inotify.h>
+#include <linux/freezer.h>
 
 #include "audit.h"
 
diff -puN kernel/power/disk.c~add-include-linux-freezerh-and-move-definitions-from kernel/power/disk.c
--- a/kernel/power/disk.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/kernel/power/disk.c
@@ -20,6 +20,7 @@
 #include <linux/pm.h>
 #include <linux/console.h>
 #include <linux/cpu.h>
+#include <linux/freezer.h>
 
 #include "power.h"
 
diff -puN kernel/power/main.c~add-include-linux-freezerh-and-move-definitions-from kernel/power/main.c
--- a/kernel/power/main.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/kernel/power/main.c
@@ -18,6 +18,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/resume-trace.h>
+#include <linux/freezer.h>
 
 #include "power.h"
 
diff -puN kernel/power/process.c~add-include-linux-freezerh-and-move-definitions-from kernel/power/process.c
--- a/kernel/power/process.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/kernel/power/process.c
@@ -13,6 +13,7 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/syscalls.h>
+#include <linux/freezer.h>
 
 /* 
  * Timeout for stopping processes
diff -puN kernel/power/user.c~add-include-linux-freezerh-and-move-definitions-from kernel/power/user.c
--- a/kernel/power/user.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/kernel/power/user.c
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/console.h>
 #include <linux/cpu.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 
diff -puN kernel/rtmutex-tester.c~add-include-linux-freezerh-and-move-definitions-from kernel/rtmutex-tester.c
--- a/kernel/rtmutex-tester.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/kernel/rtmutex-tester.c
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/sysdev.h>
 #include <linux/timer.h>
+#include <linux/freezer.h>
 
 #include "rtmutex.h"
 
diff -puN kernel/sched.c~add-include-linux-freezerh-and-move-definitions-from kernel/sched.c
--- a/kernel/sched.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/kernel/sched.c
@@ -34,7 +34,7 @@
 #include <linux/security.h>
 #include <linux/notifier.h>
 #include <linux/profile.h>
-#include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/vmalloc.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
diff -puN kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from kernel/signal.c
--- a/kernel/signal.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/kernel/signal.c
@@ -23,6 +23,7 @@
 #include <linux/ptrace.h>
 #include <linux/signal.h>
 #include <linux/capability.h>
+#include <linux/freezer.h>
 #include <asm/param.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff -puN mm/pdflush.c~add-include-linux-freezerh-and-move-definitions-from mm/pdflush.c
--- a/mm/pdflush.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/mm/pdflush.c
@@ -21,6 +21,7 @@
 #include <linux/writeback.h>	// Prototypes pdflush_operation()
 #include <linux/kthread.h>
 #include <linux/cpuset.h>
+#include <linux/freezer.h>
 
 
 /*
diff -puN mm/vmscan.c~add-include-linux-freezerh-and-move-definitions-from mm/vmscan.c
--- a/mm/vmscan.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/mm/vmscan.c
@@ -36,6 +36,7 @@
 #include <linux/rwsem.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
diff -puN net/rxrpc/krxiod.c~add-include-linux-freezerh-and-move-definitions-from net/rxrpc/krxiod.c
--- a/net/rxrpc/krxiod.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/net/rxrpc/krxiod.c
@@ -13,6 +13,7 @@
 #include <linux/completion.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/freezer.h>
 #include <rxrpc/krxiod.h>
 #include <rxrpc/transport.h>
 #include <rxrpc/peer.h>
diff -puN net/rxrpc/krxsecd.c~add-include-linux-freezerh-and-move-definitions-from net/rxrpc/krxsecd.c
--- a/net/rxrpc/krxsecd.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/net/rxrpc/krxsecd.c
@@ -27,6 +27,7 @@
 #include <rxrpc/call.h>
 #include <linux/udp.h>
 #include <linux/ip.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 #include "internal.h"
 
diff -puN net/rxrpc/krxtimod.c~add-include-linux-freezerh-and-move-definitions-from net/rxrpc/krxtimod.c
--- a/net/rxrpc/krxtimod.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/net/rxrpc/krxtimod.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
+#include <linux/freezer.h>
 #include <rxrpc/rxrpc.h>
 #include <rxrpc/krxtimod.h>
 #include <asm/errno.h>
diff -puN net/sunrpc/svcsock.c~add-include-linux-freezerh-and-move-definitions-from net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~add-include-linux-freezerh-and-move-definitions-from
+++ a/net/sunrpc/svcsock.c
@@ -32,6 +32,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/file.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <net/ip.h>
_

Patches currently in -mm which might be from ncunningham@linuxmail.org are

origin.patch

