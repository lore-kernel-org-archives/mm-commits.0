From: akpm@linux-foundation.org
Subject: + maintainers-fix-major-alpha-ordering.patch added to -mm tree
Date: Mon, 19 Jun 2017 15:38:56 -0700
Message-ID: <59485280.DRHlBH2h3VFf5X9y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdFSWi5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2017 18:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix major alpha ordering
has been added to the -mm tree.  Its filename is
     maintainers-fix-major-alpha-ordering.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-fix-major-alpha-ordering.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-fix-major-alpha-ordering.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: fix major alpha ordering

Fix major alphabetic ordering errors.  No attempt to fix items that all
begin with the same word (like ARM, BROADCOM, DRM, EDAC, FREESCALE, INTEL,
OMAP, PCI, SAMSUNG, TI, USB, etc.).

(diffstat +/- is different by one line because TI KEYSTONE MULTICORE
had 2 blank lines after it.)

Link: http://lkml.kernel.org/r/a6711322-8622-cd98-3f47-412bfdcdffd8@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS | 1497 ++++++++++++++++++++++++--------------------------
 1 file changed, 748 insertions(+), 749 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-major-alpha-ordering MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-major-alpha-ordering
+++ a/MAINTAINERS
@@ -872,6 +872,14 @@ F:	include/linux/apm_bios.h
 F:	include/uapi/linux/apm_bios.h
 F:	drivers/char/apm-emulation.c
 
+APPARMOR SECURITY MODULE
+M:	John Johansen <john.johansen@canonical.com>
+L:	apparmor@lists.ubuntu.com (subscribers-only, general discussion)
+W:	apparmor.wiki.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git
+S:	Supported
+F:	security/apparmor/
+
 APPLE BCM5974 MULTITOUCH DRIVER
 M:	Henrik Rydberg <rydberg@bitmath.org>
 L:	linux-input@vger.kernel.org
@@ -930,6 +938,12 @@ S:	Maintained
 F:	drivers/video/fbdev/arcfb.c
 F:	drivers/video/fbdev/core/fb_defio.c
 
+ARC PGU DRM DRIVER
+M:	Alexey Brodkin <abrodkin@synopsys.com>
+S:	Supported
+F:	drivers/gpu/drm/arc/
+F:	Documentation/devicetree/bindings/display/snps,arcpgu.txt
+
 ARCNET NETWORK LAYER
 M:	Michael Grzeschik <m.grzeschik@pengutronix.de>
 L:	netdev@vger.kernel.org
@@ -937,12 +951,6 @@ S:	Maintained
 F:	drivers/net/arcnet/
 F:	include/uapi/linux/if_arcnet.h
 
-ARC PGU DRM DRIVER
-M:	Alexey Brodkin <abrodkin@synopsys.com>
-S:	Supported
-F:	drivers/gpu/drm/arc/
-F:	Documentation/devicetree/bindings/display/snps,arcpgu.txt
-
 ARM ARCHITECTED TIMER DRIVER
 M:	Mark Rutland <mark.rutland@arm.com>
 M:	Marc Zyngier <marc.zyngier@arm.com>
@@ -2168,22 +2176,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Supported
 F:	drivers/net/wireless/ath/ath6kl/
 
-WILOCITY WIL6210 WIRELESS DRIVER
-M:	Maya Erez <qca_merez@qca.qualcomm.com>
-L:	linux-wireless@vger.kernel.org
-L:	wil6210@qca.qualcomm.com
-S:	Supported
-W:	http://wireless.kernel.org/en/users/Drivers/wil6210
-F:	drivers/net/wireless/ath/wil6210/
-F:	include/uapi/linux/wil6210_uapi.h
-
-CARL9170 LINUX COMMUNITY WIRELESS DRIVER
-M:	Christian Lamparter <chunkeey@googlemail.com>
-L:	linux-wireless@vger.kernel.org
-W:	http://wireless.kernel.org/en/users/Drivers/carl9170
-S:	Maintained
-F:	drivers/net/wireless/ath/carl9170/
-
 ATK0110 HWMON DRIVER
 M:	Luca Tettamanti <kronos.it@gmail.com>
 L:	linux-hwmon@vger.kernel.org
@@ -2459,13 +2451,11 @@ W:	https://linuxtv.org
 S:	Supported
 F:	drivers/media/platform/sti/bdisp
 
-DELTA ST MEDIA DRIVER
-M:	Hugues Fruchet <hugues.fruchet@st.com>
-L:	linux-media@vger.kernel.org
-T:	git git://linuxtv.org/media_tree.git
-W:	https://linuxtv.org
-S:	Supported
-F:	drivers/media/platform/sti/delta
+BECKHOFF CX5020 ETHERCAT MASTER DRIVER
+M:	Dariusz Marcinkiewicz <reksio@newterm.pl>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/ec_bhf.c
 
 BEFS FILE SYSTEM
 M:	Luis de Bethencourt <luisbg@osg.samsung.com>
@@ -2475,11 +2465,13 @@ T:	git git://github.com/luisbg/linux-bef
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
 
-BECKHOFF CX5020 ETHERCAT MASTER DRIVER
-M:	Dariusz Marcinkiewicz <reksio@newterm.pl>
-L:	netdev@vger.kernel.org
+BFQ I/O SCHEDULER
+M:	Paolo Valente <paolo.valente@linaro.org>
+M:	Jens Axboe <axboe@kernel.dk>
+L:	linux-block@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/ec_bhf.c
+F:	block/bfq-*
+F:	Documentation/block/bfq-iosched.txt
 
 BFS FILE SYSTEM
 M:	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>
@@ -2558,14 +2550,6 @@ F:	block/
 F:	kernel/trace/blktrace.c
 F:	lib/sbitmap.c
 
-BFQ I/O SCHEDULER
-M:	Paolo Valente <paolo.valente@linaro.org>
-M:	Jens Axboe <axboe@kernel.dk>
-L:	linux-block@vger.kernel.org
-S:	Maintained
-F:	block/bfq-*
-F:	Documentation/block/bfq-iosched.txt
-
 BLOCK2MTD DRIVER
 M:	Joern Engel <joern@lazybastard.org>
 L:	linux-mtd@lists.infradead.org
@@ -2948,6 +2932,15 @@ S:	Odd fixes
 F:	Documentation/media/v4l-drivers/bttv*
 F:	drivers/media/pci/bt8xx/bttv*
 
+BUS FREQUENCY DRIVER FOR SAMSUNG EXYNOS
+M:	Chanwoo Choi <cw00.choi@samsung.com>
+L:	linux-pm@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git
+S:	Maintained
+F:	drivers/devfreq/exynos-bus.c
+F:	Documentation/devicetree/bindings/devfreq/exynos-bus.txt
+
 BUSLOGIC SCSI DRIVER
 M:	Khalid Aziz <khalid@gonehiking.org>
 L:	linux-scsi@vger.kernel.org
@@ -3067,6 +3060,13 @@ M:	Kevin Tsai <ktsai@capellamicro.com>
 S:	Maintained
 F:	drivers/iio/light/cm*
 
+CARL9170 LINUX COMMUNITY WIRELESS DRIVER
+M:	Christian Lamparter <chunkeey@googlemail.com>
+L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org/en/users/Drivers/carl9170
+S:	Maintained
+F:	drivers/net/wireless/ath/carl9170/
+
 CAVIUM THUNDERX2 ARM64 SOC
 M:	Jayachandran C <jnair@caviumnetworks.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -3194,12 +3194,6 @@ F:	drivers/usb/host/whci/
 F:	drivers/usb/wusbcore/
 F:	include/linux/usb/wusb*
 
-HT16K33 LED CONTROLLER DRIVER
-M:	Robin van der Gracht <robin@protonic.nl>
-S:	Maintained
-F:	drivers/auxdisplay/ht16k33.c
-F:	Documentation/devicetree/bindings/display/ht16k33.txt
-
 CFAG12864B LCD DRIVER
 M:	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
 W:	http://miguelojeda.es/auxdisplay.htm
@@ -3270,19 +3264,6 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/olof/chrome-platform.git
 F:	drivers/platform/chrome/
 
-CISCO VIC ETHERNET NIC DRIVER
-M:	Christian Benvenuti <benve@cisco.com>
-M:	Govindarajulu Varadarajan <_govind@gmx.com>
-M:	Neel Patel <neepatel@cisco.com>
-S:	Supported
-F:	drivers/net/ethernet/cisco/enic/
-
-CISCO VIC LOW LATENCY NIC DRIVER
-M:	Christian Benvenuti <benve@cisco.com>
-M:	Dave Goodell <dgoodell@cisco.com>
-S:	Supported
-F:	drivers/infiniband/hw/usnic/
-
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
 M:	Hartley Sweeten <hsweeten@visionengravers.com>
 L:	netdev@vger.kernel.org
@@ -3296,6 +3277,34 @@ L:	alsa-devel@alsa-project.org (moderate
 S:	Maintained
 F:	sound/soc/codecs/cs*
 
+CISCO FCOE HBA DRIVER
+M:	Satish Kharat <satishkh@cisco.com>
+M:	Sesidhar Baddela <sebaddel@cisco.com>
+M:	Karan Tilak Kumar <kartilak@cisco.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/fnic/
+
+CISCO SCSI HBA DRIVER
+M:	Karan Tilak Kumar <kartilak@cisco.com>
+M:	Sesidhar Baddela <sebaddel@cisco.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/snic/
+
+CISCO VIC ETHERNET NIC DRIVER
+M:	Christian Benvenuti <benve@cisco.com>
+M:	Govindarajulu Varadarajan <_govind@gmx.com>
+M:	Neel Patel <neepatel@cisco.com>
+S:	Supported
+F:	drivers/net/ethernet/cisco/enic/
+
+CISCO VIC LOW LATENCY NIC DRIVER
+M:	Christian Benvenuti <benve@cisco.com>
+M:	Dave Goodell <dgoodell@cisco.com>
+S:	Supported
+F:	drivers/infiniband/hw/usnic/
+
 CLEANCACHE API
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
 L:	linux-kernel@vger.kernel.org
@@ -3317,21 +3326,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Supported
 F:	drivers/clocksource
 
-CISCO FCOE HBA DRIVER
-M:	Satish Kharat <satishkh@cisco.com>
-M:	Sesidhar Baddela <sebaddel@cisco.com>
-M:	Karan Tilak Kumar <kartilak@cisco.com>
-L:	linux-scsi@vger.kernel.org
-S:	Supported
-F:	drivers/scsi/fnic/
-
-CISCO SCSI HBA DRIVER
-M:	Karan Tilak Kumar <kartilak@cisco.com>
-M:	Sesidhar Baddela <sebaddel@cisco.com>
-L:	linux-scsi@vger.kernel.org
-S:	Supported
-F:	drivers/scsi/snic/
-
 CMPC ACPI DRIVER
 M:	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
 M:	Daniel Oliveira Nascimento <don@syst.com.br>
@@ -3742,14 +3736,6 @@ F:	drivers/scsi/cxlflash/
 F:	include/uapi/scsi/cxlflash_ioctls.h
 F:	Documentation/powerpc/cxlflash.txt
 
-STMMAC ETHERNET DRIVER
-M:	Giuseppe Cavallaro <peppe.cavallaro@st.com>
-M:	Alexandre Torgue <alexandre.torgue@st.com>
-L:	netdev@vger.kernel.org
-W:	http://www.stlinux.com
-S:	Supported
-F:	drivers/net/ethernet/stmicro/stmmac/
-
 CYBERPRO FB DRIVER
 M:	Russell King <linux@armlinux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -3895,6 +3881,14 @@ M:	Pali Rohár <pali.rohar@gmail.com>
 S:	Maintained
 F:	drivers/platform/x86/dell-wmi.c
 
+DELTA ST MEDIA DRIVER
+M:	Hugues Fruchet <hugues.fruchet@st.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	https://linuxtv.org
+S:	Supported
+F:	drivers/media/platform/sti/delta
+
 DESIGNWARE USB2 DRD IP DRIVER
 M:	John Youn <johnyoun@synopsys.com>
 L:	linux-usb@vger.kernel.org
@@ -3943,15 +3937,6 @@ F:	drivers/devfreq/devfreq-event.c
 F:	include/linux/devfreq-event.h
 F:	Documentation/devicetree/bindings/devfreq/event/
 
-BUS FREQUENCY DRIVER FOR SAMSUNG EXYNOS
-M:	Chanwoo Choi <cw00.choi@samsung.com>
-L:	linux-pm@vger.kernel.org
-L:	linux-samsung-soc@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git
-S:	Maintained
-F:	drivers/devfreq/exynos-bus.c
-F:	Documentation/devicetree/bindings/devfreq/exynos-bus.txt
-
 DEVICE NUMBER REGISTRY
 M:	Torben Mathiasen <device@lanana.org>
 W:	http://lanana.org/docs/device-list/index.html
@@ -4097,20 +4082,6 @@ F:	include/linux/*fence.h
 F:	Documentation/driver-api/dma-buf.rst
 T:	git git://anongit.freedesktop.org/drm/drm-misc
 
-SYNC FILE FRAMEWORK
-M:	Sumit Semwal <sumit.semwal@linaro.org>
-R:	Gustavo Padovan <gustavo@padovan.org>
-S:	Maintained
-L:	linux-media@vger.kernel.org
-L:	dri-devel@lists.freedesktop.org
-F:	drivers/dma-buf/sync_*
-F:	drivers/dma-buf/dma-fence*
-F:	drivers/dma-buf/sw_sync.c
-F:	include/linux/sync_file.h
-F:	include/uapi/linux/sync_file.h
-F:	Documentation/sync_file.txt
-T:	git git://anongit.freedesktop.org/drm/drm-misc
-
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 M:	Vinod Koul <vinod.koul@intel.com>
 L:	dmaengine@vger.kernel.org
@@ -4204,6 +4175,14 @@ F:	include/linux/debugfs.h
 F:	include/linux/kobj*
 F:	lib/kobj*
 
+DRIVERS FOR ADAPTIVE VOLTAGE SCALING (AVS)
+M:	Kevin Hilman <khilman@kernel.org>
+M:	Nishanth Menon <nm@ti.com>
+S:	Maintained
+F:	drivers/power/avs/
+F:	include/linux/power/smartreflex.h
+L:	linux-pm@vger.kernel.org
+
 DRM DRIVERS
 M:	David Airlie <airlied@linux.ie>
 L:	dri-devel@lists.freedesktop.org
@@ -4972,6 +4951,34 @@ M:	David Woodhouse <dwmw2@infradead.org>
 L:	linux-embedded@vger.kernel.org
 S:	Maintained
 
+Emulex 10Gbps iSCSI - OneConnect DRIVER
+M:	Subbu Seetharaman <subbu.seetharaman@broadcom.com>
+M:	Ketan Mukadam <ketan.mukadam@broadcom.com>
+M:	Jitendra Bhivare <jitendra.bhivare@broadcom.com>
+L:	linux-scsi@vger.kernel.org
+W:	http://www.broadcom.com
+S:	Supported
+F:	drivers/scsi/be2iscsi/
+
+Emulex 10Gbps NIC BE2, BE3-R, Lancer, Skyhawk-R DRIVER (be2net)
+M:	Sathya Perla <sathya.perla@broadcom.com>
+M:	Ajit Khaparde <ajit.khaparde@broadcom.com>
+M:	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
+M:	Somnath Kotur <somnath.kotur@broadcom.com>
+L:	netdev@vger.kernel.org
+W:	http://www.emulex.com
+S:	Supported
+F:	drivers/net/ethernet/emulex/benet/
+
+EMULEX ONECONNECT ROCE DRIVER
+M:	Selvin Xavier <selvin.xavier@broadcom.com>
+M:	Devesh Sharma <devesh.sharma@broadcom.com>
+L:	linux-rdma@vger.kernel.org
+W:	http://www.broadcom.com
+S:	Odd Fixes
+F:	drivers/infiniband/hw/ocrdma/
+F:	include/uapi/rdma/ocrdma-abi.h
+
 EMULEX/BROADCOM LPFC FC/FCOE SCSI DRIVER
 M:	James Smart <james.smart@broadcom.com>
 M:	Dick Kennedy <dick.kennedy@broadcom.com>
@@ -5081,6 +5088,19 @@ S:	Supported
 F:	arch/arc/plat-eznps
 F:	arch/arc/boot/dts/eznps.dts
 
+F2FS FILE SYSTEM
+M:	Jaegeuk Kim <jaegeuk@kernel.org>
+M:	Chao Yu <yuchao0@huawei.com>
+L:	linux-f2fs-devel@lists.sourceforge.net
+W:	https://f2fs.wiki.kernel.org/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
+S:	Maintained
+F:	Documentation/filesystems/f2fs.txt
+F:	Documentation/ABI/testing/sysfs-fs-f2fs
+F:	fs/f2fs/
+F:	include/linux/f2fs_fs.h
+F:	include/trace/events/f2fs.h
+
 F71805F HARDWARE MONITORING DRIVER
 M:	Jean Delvare <jdelvare@suse.com>
 L:	linux-hwmon@vger.kernel.org
@@ -5088,23 +5108,6 @@ S:	Maintained
 F:	Documentation/hwmon/f71805f
 F:	drivers/hwmon/f71805f.c
 
-FC0011 TUNER DRIVER
-M:	Michael Buesch <m@bues.ch>
-L:	linux-media@vger.kernel.org
-S:	Maintained
-F:	drivers/media/tuners/fc0011.h
-F:	drivers/media/tuners/fc0011.c
-
-FC2580 MEDIA DRIVER
-M:	Antti Palosaari <crope@iki.fi>
-L:	linux-media@vger.kernel.org
-W:	https://linuxtv.org
-W:	http://palosaari.fi/linux/
-Q:	http://patchwork.linuxtv.org/project/linux-media/list/
-T:	git git://linuxtv.org/anttip/media_tree.git
-S:	Maintained
-F:	drivers/media/tuners/fc2580*
-
 FANOTIFY
 M:	Eric Paris <eparis@redhat.com>
 S:	Maintained
@@ -5129,13 +5132,30 @@ M:	Thomas Petazzoni <thomas.petazzoni@fr
 S:	Maintained
 F:	drivers/staging/fbtft/
 
-FCOE SUBSYSTEM (libfc, libfcoe, fcoe)
-M:	Johannes Thumshirn <jth@kernel.org>
-L:	fcoe-devel@open-fcoe.org
-W:	www.Open-FCoE.org
-S:	Supported
-F:	drivers/scsi/libfc/
-F:	drivers/scsi/fcoe/
+FC0011 TUNER DRIVER
+M:	Michael Buesch <m@bues.ch>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/tuners/fc0011.h
+F:	drivers/media/tuners/fc0011.c
+
+FC2580 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/tuners/fc2580*
+
+FCOE SUBSYSTEM (libfc, libfcoe, fcoe)
+M:	Johannes Thumshirn <jth@kernel.org>
+L:	fcoe-devel@open-fcoe.org
+W:	www.Open-FCoE.org
+S:	Supported
+F:	drivers/scsi/libfc/
+F:	drivers/scsi/fcoe/
 F:	include/scsi/fc/
 F:	include/scsi/libfc.h
 F:	include/scsi/libfcoe.h
@@ -5450,19 +5470,6 @@ S:	Supported
 F:	fs/crypto/
 F:	include/linux/fscrypt*.h
 
-F2FS FILE SYSTEM
-M:	Jaegeuk Kim <jaegeuk@kernel.org>
-M:	Chao Yu <yuchao0@huawei.com>
-L:	linux-f2fs-devel@lists.sourceforge.net
-W:	https://f2fs.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
-S:	Maintained
-F:	Documentation/filesystems/f2fs.txt
-F:	Documentation/ABI/testing/sysfs-fs-f2fs
-F:	fs/f2fs/
-F:	include/linux/f2fs_fs.h
-F:	include/trace/events/f2fs.h
-
 FUJITSU FR-V (FRV) PORT
 S:	Orphan
 F:	arch/frv/
@@ -5536,6 +5543,12 @@ S:	Maintained
 F:	kernel/gcov/
 F:	Documentation/dev-tools/gcov.rst
 
+GDB KERNEL DEBUGGING HELPER SCRIPTS
+M:	Jan Kiszka <jan.kiszka@siemens.com>
+M:	Kieran Bingham <kieran@bingham.xyz>
+S:	Supported
+F:	scripts/gdb/
+
 GDT SCSI DISK ARRAY CONTROLLER DRIVER
 M:	Achim Leubner <achim_leubner@adaptec.com>
 L:	linux-scsi@vger.kernel.org
@@ -5543,12 +5556,6 @@ W:	http://www.icp-vortex.com/
 S:	Supported
 F:	drivers/scsi/gdt*
 
-GDB KERNEL DEBUGGING HELPER SCRIPTS
-M:	Jan Kiszka <jan.kiszka@siemens.com>
-M:	Kieran Bingham <kieran@bingham.xyz>
-S:	Supported
-F:	scripts/gdb/
-
 GEMTEK FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
@@ -5615,17 +5622,17 @@ L:	kvm@vger.kernel.org
 S:	Supported
 F:	drivers/uio/uio_pci_generic.c
 
-GET_MAINTAINER SCRIPT
-M:	Joe Perches <joe@perches.com>
-S:	Maintained
-F:	scripts/get_maintainer.pl
-
 GENWQE (IBM Generic Workqueue Card)
 M:	Frank Haverkamp <haver@linux.vnet.ibm.com>
 M:	Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
 S:	Supported
 F:	drivers/misc/genwqe/
 
+GET_MAINTAINER SCRIPT
+M:	Joe Perches <joe@perches.com>
+S:	Maintained
+F:	scripts/get_maintainer.pl
+
 GFS2 FILE SYSTEM
 M:	Steven Whitehouse <swhiteho@redhat.com>
 M:	Bob Peterson <rpeterso@redhat.com>
@@ -5837,13 +5844,6 @@ L:	linux-efi@vger.kernel.org
 S:	Maintained
 F:	block/partitions/efi.*
 
-STK1160 USB VIDEO CAPTURE DRIVER
-M:	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
-L:	linux-media@vger.kernel.org
-T:	git git://linuxtv.org/media_tree.git
-S:	Maintained
-F:	drivers/media/usb/stk1160/
-
 H8/300 ARCHITECTURE
 M:	Yoshinori Sato <ysato@users.sourceforge.jp>
 L:	uclinux-h8-devel@lists.sourceforge.jp (moderated for non-subscribers)
@@ -5855,33 +5855,6 @@ F:	drivers/clocksource/h8300_*.c
 F:	drivers/clk/h8300/
 F:	drivers/irqchip/irq-renesas-h8*.c
 
-HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
-M:	Frank Seidel <frank@f-seidel.de>
-L:	platform-driver-x86@vger.kernel.org
-W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
-S:	Maintained
-F:	drivers/platform/x86/hdaps.c
-
-HDPVR USB VIDEO ENCODER DRIVER
-M:	Hans Verkuil <hverkuil@xs4all.nl>
-L:	linux-media@vger.kernel.org
-T:	git git://linuxtv.org/media_tree.git
-W:	https://linuxtv.org
-S:	Odd Fixes
-F:	drivers/media/usb/hdpvr/
-
-HWPOISON MEMORY FAILURE HANDLING
-M:	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	mm/memory-failure.c
-F:	mm/hwpoison-inject.c
-
-HYPERVISOR VIRTUAL CONSOLE DRIVER
-L:	linuxppc-dev@lists.ozlabs.org
-S:	Odd Fixes
-F:	drivers/tty/hvc/
-
 HACKRF MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
@@ -5892,6 +5865,13 @@ T:	git git://linuxtv.org/anttip/media_tr
 S:	Maintained
 F:	drivers/media/usb/hackrf/
 
+HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
+M:	Frank Seidel <frank@f-seidel.de>
+L:	platform-driver-x86@vger.kernel.org
+W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
+S:	Maintained
+F:	drivers/platform/x86/hdaps.c
+
 HARDWARE MONITORING
 M:	Jean Delvare <jdelvare@suse.com>
 M:	Guenter Roeck <linux@roeck-us.net>
@@ -5930,6 +5910,14 @@ L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/parisc/harmony.*
 
+HDPVR USB VIDEO ENCODER DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	https://linuxtv.org
+S:	Odd Fixes
+F:	drivers/media/usb/hdpvr/
+
 HEWLETT PACKARD ENTERPRISE ILO NMI WATCHDOG DRIVER
 M:	Jimmy Vance <jimmy.vance@hpe.com>
 S:	Supported
@@ -5956,13 +5944,6 @@ F:	drivers/block/cciss*
 F:	include/linux/cciss_ioctl.h
 F:	include/uapi/linux/cciss_ioctl.h
 
-OPA-VNIC DRIVER
-M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
-M:	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
-L:	linux-rdma@vger.kernel.org
-S:	Supported
-F:	drivers/infiniband/ulp/opa_vnic
-
 HFI1 DRIVER
 M:	Mike Marciniszyn <mike.marciniszyn@intel.com>
 M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
@@ -6141,6 +6122,12 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	net/hsr/
 
+HT16K33 LED CONTROLLER DRIVER
+M:	Robin van der Gracht <robin@protonic.nl>
+S:	Maintained
+F:	drivers/auxdisplay/ht16k33.c
+F:	Documentation/devicetree/bindings/display/ht16k33.txt
+
 HTCPEN TOUCHSCREEN DRIVER
 M:	Pau Oliva Fora <pof@eslack.org>
 L:	linux-input@vger.kernel.org
@@ -6160,6 +6147,13 @@ W:	https://linuxtv.org
 S:	Supported
 F:	drivers/media/platform/sti/hva
 
+HWPOISON MEMORY FAILURE HANDLING
+M:	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/memory-failure.c
+F:	mm/hwpoison-inject.c
+
 Hyper-V CORE AND DRIVERS
 M:	"K. Y. Srinivasan" <kys@microsoft.com>
 M:	Haiyang Zhang <haiyangz@microsoft.com>
@@ -6182,6 +6176,11 @@ F:	include/linux/hyperv.h
 F:	tools/hv/
 F:	Documentation/ABI/stable/sysfs-bus-vmbus
 
+HYPERVISOR VIRTUAL CONSOLE DRIVER
+L:	linuxppc-dev@lists.ozlabs.org
+S:	Odd Fixes
+F:	drivers/tty/hvc/
+
 I2C MUXES
 M:	Peter Rosin <peda@axentia.se>
 L:	linux-i2c@vger.kernel.org
@@ -6389,11 +6388,6 @@ S:	Maintained
 F:	drivers/mfd/lpc_ich.c
 F:	drivers/gpio/gpio-ich.c
 
-IDT VersaClock 5 CLOCK DRIVER
-M:	Marek Vasut <marek.vasut@gmail.com>
-S:	Maintained
-F:	drivers/clk/clk-versaclock5.c
-
 IDE SUBSYSTEM
 M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-ide@vger.kernel.org
@@ -6404,6 +6398,13 @@ F:	Documentation/ide/
 F:	drivers/ide/
 F:	include/linux/ide.h
 
+IDE/ATAPI DRIVERS
+M:	Borislav Petkov <bp@alien8.de>
+L:	linux-ide@vger.kernel.org
+S:	Maintained
+F:	Documentation/cdrom/ide-cd
+F:	drivers/ide/ide-cd*
+
 IDEAPAD LAPTOP EXTRAS DRIVER
 M:	Ike Panhc <ike.pan@canonical.com>
 L:	platform-driver-x86@vger.kernel.org
@@ -6418,12 +6419,10 @@ W:	https://github.com/o2genum/ideapad-sl
 S:	Maintained
 F:	drivers/input/misc/ideapad_slidebar.c
 
-IDE/ATAPI DRIVERS
-M:	Borislav Petkov <bp@alien8.de>
-L:	linux-ide@vger.kernel.org
+IDT VersaClock 5 CLOCK DRIVER
+M:	Marek Vasut <marek.vasut@gmail.com>
 S:	Maintained
-F:	Documentation/cdrom/ide-cd
-F:	drivers/ide/ide-cd*
+F:	drivers/clk/clk-versaclock5.c
 
 IEEE 802.15.4 SUBSYSTEM
 M:	Alexander Aring <aar@pengutronix.de>
@@ -6506,6 +6505,16 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/auxdisplay/img-ascii-lcd.txt
 F:	drivers/auxdisplay/img-ascii-lcd.c
 
+IMGTEC IR DECODER DRIVER
+M:	James Hogan <james.hogan@imgtec.com>
+S:	Maintained
+F:	drivers/media/rc/img-ir/
+
+IMS TWINTURBO FRAMEBUFFER DRIVER
+L:	linux-fbdev@vger.kernel.org
+S:	Orphan
+F:	drivers/video/fbdev/imsttfb.c
+
 INA209 HARDWARE MONITOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
 L:	linux-hwmon@vger.kernel.org
@@ -6531,6 +6540,22 @@ W:	http://industrypack.sourceforge.net
 S:	Maintained
 F:	drivers/ipack/
 
+INFINIBAND SUBSYSTEM
+M:	Doug Ledford <dledford@redhat.com>
+M:	Sean Hefty <sean.hefty@intel.com>
+M:	Hal Rosenstock <hal.rosenstock@gmail.com>
+L:	linux-rdma@vger.kernel.org
+W:	http://www.openfabrics.org/
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
+S:	Supported
+F:	Documentation/devicetree/bindings/infiniband/
+F:	Documentation/infiniband/
+F:	drivers/infiniband/
+F:	include/uapi/linux/if_infiniband.h
+F:	include/uapi/rdma/
+F:	include/rdma/
+
 INGENIC JZ4780 DMA Driver
 M:	Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
 S:	Maintained
@@ -6552,32 +6577,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Supported
 F:	security/integrity/ima/
 
-IMGTEC IR DECODER DRIVER
-M:	James Hogan <james.hogan@imgtec.com>
-S:	Maintained
-F:	drivers/media/rc/img-ir/
-
-IMS TWINTURBO FRAMEBUFFER DRIVER
-L:	linux-fbdev@vger.kernel.org
-S:	Orphan
-F:	drivers/video/fbdev/imsttfb.c
-
-INFINIBAND SUBSYSTEM
-M:	Doug Ledford <dledford@redhat.com>
-M:	Sean Hefty <sean.hefty@intel.com>
-M:	Hal Rosenstock <hal.rosenstock@gmail.com>
-L:	linux-rdma@vger.kernel.org
-W:	http://www.openfabrics.org/
-Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
-S:	Supported
-F:	Documentation/devicetree/bindings/infiniband/
-F:	Documentation/infiniband/
-F:	drivers/infiniband/
-F:	include/uapi/linux/if_infiniband.h
-F:	include/uapi/rdma/
-F:	include/rdma/
-
 INOTIFY
 M:	John McCutchan <john@johnmccutchan.com>
 M:	Robert Love <rlove@rlove.org>
@@ -6903,13 +6902,6 @@ F:	drivers/char/ipmi/
 F:	include/linux/ipmi*
 F:	include/uapi/linux/ipmi*
 
-QCOM AUDIO (ASoC) DRIVERS
-M:	Patrick Lai <plai@codeaurora.org>
-M:	Banajit Goswami <bgoswami@codeaurora.org>
-L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-S:	Supported
-F:	sound/soc/qcom/
-
 IPS SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
 L:	linux-scsi@vger.kernel.org
@@ -7697,6 +7689,11 @@ M:	Chris Wright <chrisw@sous-sol.org>
 L:	linux-security-module@vger.kernel.org
 S:	Supported
 
+LINUX KERNEL DUMP TEST MODULE (LKDTM)
+M:	Kees Cook <keescook@chromium.org>
+S:	Maintained
+F:	drivers/misc/lkdtm*
+
 LIS3LV02D ACCELEROMETER DRIVER
 M:	Eric Piel <eric.piel@tremplin-utc.net>
 S:	Maintained
@@ -7721,11 +7718,6 @@ F:	samples/livepatch/
 L:	live-patching@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/livepatching.git
 
-LINUX KERNEL DUMP TEST MODULE (LKDTM)
-M:	Kees Cook <keescook@chromium.org>
-S:	Maintained
-F:	drivers/misc/lkdtm*
-
 LLC (802.2)
 L:	netdev@vger.kernel.org
 S:	Odd fixes
@@ -7778,6 +7770,12 @@ Q:	http://patchwork.linuxtv.org/project/
 S:	Maintained
 F:	drivers/media/usb/dvb-usb-v2/lmedm04*
 
+LOADPIN SECURITY MODULE
+M:	Kees Cook <keescook@chromium.org>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git lsm/loadpin
+S:	Supported
+F:	security/loadpin/
+
 LOCKING PRIMITIVES
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Ingo Molnar <mingo@redhat.com>
@@ -8287,6 +8285,13 @@ F:	Documentation/scsi/megaraid.txt
 F:	drivers/scsi/megaraid.*
 F:	drivers/scsi/megaraid/
 
+MELEXIS MLX90614 DRIVER
+M:	Crt Mori <cmo@melexis.com>
+L:	linux-iio@vger.kernel.org
+W:	http://www.melexis.com
+S:	Supported
+F:	drivers/iio/temperature/mlx90614.c
+
 MELFAS MIP4 TOUCHSCREEN DRIVER
 M:	Sangwon Jee <jeesw@melfas.com>
 W:	http://www.melfas.com
@@ -8348,14 +8353,48 @@ S:	Supported
 F:	drivers/platform/x86/mlxcpld-hotplug.c
 F:	include/linux/platform_data/mlxcpld-hotplug.h
 
-SOFT-ROCE DRIVER (rxe)
-M:	Moni Shoua <monis@mellanox.com>
+MELLANOX MLX4 core VPI driver
+M:	Tariq Toukan <tariqt@mellanox.com>
+L:	netdev@vger.kernel.org
 L:	linux-rdma@vger.kernel.org
+W:	http://www.mellanox.com
+Q:	http://patchwork.ozlabs.org/project/netdev/list/
 S:	Supported
-W:	https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
+F:	drivers/net/ethernet/mellanox/mlx4/
+F:	include/linux/mlx4/
+
+MELLANOX MLX4 IB driver
+M:	Yishai Hadas <yishaih@mellanox.com>
+L:	linux-rdma@vger.kernel.org
+W:	http://www.mellanox.com
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-F:	drivers/infiniband/sw/rxe/
-F:	include/uapi/rdma/rdma_user_rxe.h
+S:	Supported
+F:	drivers/infiniband/hw/mlx4/
+F:	include/linux/mlx4/
+F:	include/uapi/rdma/mlx4-abi.h
+
+MELLANOX MLX5 core VPI driver
+M:	Saeed Mahameed <saeedm@mellanox.com>
+M:	Matan Barak <matanb@mellanox.com>
+M:	Leon Romanovsky <leonro@mellanox.com>
+L:	netdev@vger.kernel.org
+L:	linux-rdma@vger.kernel.org
+W:	http://www.mellanox.com
+Q:	http://patchwork.ozlabs.org/project/netdev/list/
+S:	Supported
+F:	drivers/net/ethernet/mellanox/mlx5/core/
+F:	include/linux/mlx5/
+
+MELLANOX MLX5 IB driver
+M:	Matan Barak <matanb@mellanox.com>
+M:	Leon Romanovsky <leonro@mellanox.com>
+L:	linux-rdma@vger.kernel.org
+W:	http://www.mellanox.com
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
+S:	Supported
+F:	drivers/infiniband/hw/mlx5/
+F:	include/linux/mlx5/
+F:	include/uapi/rdma/mlx5-abi.h
 
 MEMBARRIER SUPPORT
 M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
@@ -8467,6 +8506,18 @@ S:	Maintained
 F:	drivers/usb/misc/usb251xb.c
 F:	Documentation/devicetree/bindings/usb/usb251xb.txt
 
+MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)
+M:	Don Brace <don.brace@microsemi.com>
+L:	esc.storagedev@microsemi.com
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/smartpqi/smartpqi*.[ch]
+F:	drivers/scsi/smartpqi/Kconfig
+F:	drivers/scsi/smartpqi/Makefile
+F:	include/linux/cciss*.h
+F:	include/uapi/linux/cciss*.h
+F:	Documentation/scsi/smartpqi.txt
+
 MICROSOFT SURFACE PRO 3 BUTTON DRIVER
 M:	Chen Yu <yu.c.chen@intel.com>
 L:	platform-driver-x86@vger.kernel.org
@@ -8506,67 +8557,15 @@ W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/radio/radio-miropcm20*
 
-MELLANOX MLX4 core VPI driver
-M:	Tariq Toukan <tariqt@mellanox.com>
-L:	netdev@vger.kernel.org
-L:	linux-rdma@vger.kernel.org
-W:	http://www.mellanox.com
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
-S:	Supported
-F:	drivers/net/ethernet/mellanox/mlx4/
-F:	include/linux/mlx4/
-
-MELLANOX MLX4 IB driver
-M:	Yishai Hadas <yishaih@mellanox.com>
-L:	linux-rdma@vger.kernel.org
-W:	http://www.mellanox.com
-Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-S:	Supported
-F:	drivers/infiniband/hw/mlx4/
-F:	include/linux/mlx4/
-F:	include/uapi/rdma/mlx4-abi.h
-
-MELLANOX MLX5 core VPI driver
-M:	Saeed Mahameed <saeedm@mellanox.com>
-M:	Matan Barak <matanb@mellanox.com>
-M:	Leon Romanovsky <leonro@mellanox.com>
-L:	netdev@vger.kernel.org
-L:	linux-rdma@vger.kernel.org
-W:	http://www.mellanox.com
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
-S:	Supported
-F:	drivers/net/ethernet/mellanox/mlx5/core/
-F:	include/linux/mlx5/
-
-MELLANOX MLX5 IB driver
-M:	Matan Barak <matanb@mellanox.com>
-M:	Leon Romanovsky <leonro@mellanox.com>
-L:	linux-rdma@vger.kernel.org
-W:	http://www.mellanox.com
-Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-S:	Supported
-F:	drivers/infiniband/hw/mlx5/
-F:	include/linux/mlx5/
-F:	include/uapi/rdma/mlx5-abi.h
-
-MELEXIS MLX90614 DRIVER
-M:	Crt Mori <cmo@melexis.com>
-L:	linux-iio@vger.kernel.org
-W:	http://www.melexis.com
-S:	Supported
-F:	drivers/iio/temperature/mlx90614.c
-
-MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)
-M:	Don Brace <don.brace@microsemi.com>
-L:	esc.storagedev@microsemi.com
-L:	linux-scsi@vger.kernel.org
-S:	Supported
-F:	drivers/scsi/smartpqi/smartpqi*.[ch]
-F:	drivers/scsi/smartpqi/Kconfig
-F:	drivers/scsi/smartpqi/Makefile
-F:	include/linux/cciss*.h
-F:	include/uapi/linux/cciss*.h
-F:	Documentation/scsi/smartpqi.txt
+MMP SUPPORT
+M:	Eric Miao <eric.y.miao@gmail.com>
+M:	Haojian Zhuang <haojian.zhuang@gmail.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+T:	git git://github.com/hzhuang1/linux.git
+T:	git git://git.linaro.org/people/ycmiao/pxa-linux.git
+S:	Maintained
+F:	arch/arm/boot/dts/mmp*
+F:	arch/arm/mach-mmp/
 
 MN88472 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
@@ -8768,10 +8767,6 @@ S:	Maintained
 F:	drivers/mtd/nand/
 F:	include/linux/mtd/nand*.h
 
-NATSEMI ETHERNET DRIVER (DP8381x)
-S:	Orphan
-F:	drivers/net/ethernet/natsemi/natsemi.c
-
 NATIVE INSTRUMENTS USB SOUND INTERFACE DRIVER
 M:	Daniel Mack <zonque@gmail.com>
 S:	Maintained
@@ -8779,6 +8774,10 @@ L:	alsa-devel@alsa-project.org (moderate
 W:	http://www.native-instruments.com
 F:	sound/usb/caiaq/
 
+NATSEMI ETHERNET DRIVER (DP8381x)
+S:	Orphan
+F:	drivers/net/ethernet/natsemi/natsemi.c
+
 NCP FILESYSTEM
 M:	Petr Vandrovec <petr@vandrovec.name>
 S:	Odd Fixes
@@ -9450,12 +9449,17 @@ F:	drivers/scsi/osst.*
 F:	drivers/scsi/osst_*.h
 F:	drivers/scsi/st.h
 
-OPENCORES I2C BUS DRIVER
-M:	Peter Korsgaard <jacmet@sunsite.dk>
-L:	linux-i2c@vger.kernel.org
+OP-TEE DRIVER
+M:	Jens Wiklander <jens.wiklander@linaro.org>
 S:	Maintained
-F:	Documentation/i2c/busses/i2c-ocores
-F:	drivers/i2c/busses/i2c-ocores.c
+F:	drivers/tee/optee/
+
+OPA-VNIC DRIVER
+M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
+M:	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/ulp/opa_vnic
 
 OPEN FIRMWARE AND FLATTENED DEVICE TREE
 M:	Rob Herring <robh+dt@kernel.org>
@@ -9488,6 +9492,13 @@ F:	Documentation/devicetree/overlay-note
 F:	drivers/of/overlay.c
 F:	drivers/of/resolver.c
 
+OPENCORES I2C BUS DRIVER
+M:	Peter Korsgaard <jacmet@sunsite.dk>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	Documentation/i2c/busses/i2c-ocores
+F:	drivers/i2c/busses/i2c-ocores.c
+
 OPENRISC ARCHITECTURE
 M:	Jonas Bonn <jonas@southpole.se>
 M:	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
@@ -9535,11 +9546,6 @@ F:	arch/*/oprofile/
 F:	drivers/oprofile/
 F:	include/linux/oprofile.h
 
-OP-TEE DRIVER
-M:	Jens Wiklander <jens.wiklander@linaro.org>
-S:	Maintained
-F:	drivers/tee/optee/
-
 ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 M:	Mark Fasheh <mfasheh@versity.com>
 M:	Joel Becker <jlbec@evilplan.org>
@@ -9550,6 +9556,14 @@ F:	Documentation/filesystems/ocfs2.txt
 F:	Documentation/filesystems/dlmfs.txt
 F:	fs/ocfs2/
 
+ORANGEFS FILESYSTEM
+M:	Mike Marshall <hubcap@omnibond.com>
+L:	pvfs2-developers@beowulf-underground.org (subscribers-only)
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hubcap/linux.git
+S:	Supported
+F:	fs/orangefs/
+F:	Documentation/filesystems/orangefs.txt
+
 ORINOCO DRIVER
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/orinoco
@@ -9564,6 +9578,16 @@ F:	drivers/scsi/osd/
 F:	include/scsi/osd_*
 F:	fs/exofs/
 
+OV2659 OMNIVISION SENSOR DRIVER
+M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
+S:	Maintained
+F:	drivers/media/i2c/ov2659.c
+F:	include/media/i2c/ov2659.h
+
 OVERLAY FILESYSTEM
 M:	Miklos Szeredi <miklos@szeredi.hu>
 L:	linux-unionfs@vger.kernel.org
@@ -9572,14 +9596,6 @@ S:	Supported
 F:	fs/overlayfs/
 F:	Documentation/filesystems/overlayfs.txt
 
-ORANGEFS FILESYSTEM
-M:	Mike Marshall <hubcap@omnibond.com>
-L:	pvfs2-developers@beowulf-underground.org (subscribers-only)
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hubcap/linux.git
-S:	Supported
-F:	fs/orangefs/
-F:	Documentation/filesystems/orangefs.txt
-
 P54 WIRELESS DRIVER
 M:	Christian Lamparter <chunkeey@googlemail.com>
 L:	linux-wireless@vger.kernel.org
@@ -10434,16 +10450,6 @@ L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/nand/pxa3xx_nand.c
 
-MMP SUPPORT
-M:	Eric Miao <eric.y.miao@gmail.com>
-M:	Haojian Zhuang <haojian.zhuang@gmail.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-T:	git git://github.com/hzhuang1/linux.git
-T:	git git://git.linaro.org/people/ycmiao/pxa-linux.git
-S:	Maintained
-F:	arch/arm/boot/dts/mmp*
-F:	arch/arm/mach-mmp/
-
 PXA MMCI DRIVER
 S:	Orphan
 
@@ -10459,6 +10465,20 @@ L:	qat-linux@intel.com
 S:	Supported
 F:	drivers/crypto/qat/
 
+QCOM AUDIO (ASoC) DRIVERS
+M:	Patrick Lai <plai@codeaurora.org>
+M:	Banajit Goswami <bgoswami@codeaurora.org>
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
+S:	Supported
+F:	sound/soc/qcom/
+
+QEMU MACHINE EMULATOR AND VIRTUALIZER SUPPORT
+M:	Gabriel Somlo <somlo@cmu.edu>
+M:	"Michael S. Tsirkin" <mst@redhat.com>
+L:	qemu-devel@nongnu.org
+S:	Maintained
+F:	drivers/firmware/qemu_fw_cfg.c
+
 QIB DRIVER
 M:	Mike Marciniszyn <infinipath@intel.com>
 L:	linux-rdma@vger.kernel.org
@@ -10591,26 +10611,6 @@ T:	git git://github.com/KrasnikovEugene/
 S:	Supported
 F:	drivers/net/wireless/ath/wcn36xx/
 
-QEMU MACHINE EMULATOR AND VIRTUALIZER SUPPORT
-M:	Gabriel Somlo <somlo@cmu.edu>
-M:	"Michael S. Tsirkin" <mst@redhat.com>
-L:	qemu-devel@nongnu.org
-S:	Maintained
-F:	drivers/firmware/qemu_fw_cfg.c
-
-RADOS BLOCK DEVICE (RBD)
-M:	Ilya Dryomov <idryomov@gmail.com>
-M:	Sage Weil <sage@redhat.com>
-M:	Alex Elder <elder@kernel.org>
-L:	ceph-devel@vger.kernel.org
-W:	http://ceph.com/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
-T:	git git://github.com/ceph/ceph-client.git
-S:	Supported
-F:	Documentation/ABI/testing/sysfs-bus-rbd
-F:	drivers/block/rbd.c
-F:	drivers/block/rbd_types.h
-
 RADEON FRAMEBUFFER DISPLAY DRIVER
 M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
 L:	linux-fbdev@vger.kernel.org
@@ -10633,6 +10633,19 @@ S:	Maintained
 F:	drivers/media/radio/radio-shark2.c
 F:	drivers/media/radio/radio-tea5777.c
 
+RADOS BLOCK DEVICE (RBD)
+M:	Ilya Dryomov <idryomov@gmail.com>
+M:	Sage Weil <sage@redhat.com>
+M:	Alex Elder <elder@kernel.org>
+L:	ceph-devel@vger.kernel.org
+W:	http://ceph.com/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
+T:	git git://github.com/ceph/ceph-client.git
+S:	Supported
+F:	Documentation/ABI/testing/sysfs-bus-rbd
+F:	drivers/block/rbd.c
+F:	drivers/block/rbd_types.h
+
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 M:	Paul Mackerras <paulus@samba.org>
 L:	linux-fbdev@vger.kernel.org
@@ -10712,6 +10725,12 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/rdc/r6040.c
 
+RDMAVT - RDMA verbs software
+M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/sw/rdmavt
+
 RDS - RELIABLE DATAGRAM SOCKETS
 M:	Santosh Shilimkar <santosh.shilimkar@oracle.com>
 L:	netdev@vger.kernel.org
@@ -10722,12 +10741,6 @@ S:	Supported
 F:	net/rds/
 F:	Documentation/networking/rds.txt
 
-RDMAVT - RDMA verbs software
-M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
-L:	linux-rdma@vger.kernel.org
-S:	Supported
-F:	drivers/infiniband/sw/rdmavt
-
 RDT - RESOURCE ALLOCATION
 M:	Fenghua Yu <fenghua.yu@intel.com>
 L:	linux-kernel@vger.kernel.org
@@ -10776,11 +10789,6 @@ S:	Maintained
 F:	sound/soc/codecs/rt*
 F:	include/sound/rt*.h
 
-REISERFS FILE SYSTEM
-L:	reiserfs-devel@vger.kernel.org
-S:	Supported
-F:	fs/reiserfs/
-
 REGISTER MAP ABSTRACTION
 M:	Mark Brown <broonie@kernel.org>
 L:	linux-kernel@vger.kernel.org
@@ -10790,6 +10798,11 @@ F:	Documentation/devicetree/bindings/reg
 F:	drivers/base/regmap/
 F:	include/linux/regmap.h
 
+REISERFS FILE SYSTEM
+L:	reiserfs-devel@vger.kernel.org
+S:	Supported
+F:	fs/reiserfs/
+
 REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM
 M:	Ohad Ben-Cohen <ohad@wizery.com>
 M:	Bjorn Andersson <bjorn.andersson@linaro.org>
@@ -11244,119 +11257,10 @@ F:	drivers/phy/phy-s5pv210-usb2.c
 F:	drivers/phy/phy-samsung-usb2.c
 F:	drivers/phy/phy-samsung-usb2.h
 
-SERIAL DRIVERS
-M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-L:	linux-serial@vger.kernel.org
+SC1200 WDT DRIVER
+M:	Zwane Mwaikambo <zwanem@gmail.com>
 S:	Maintained
-F:	Documentation/devicetree/bindings/serial/
-F:	drivers/tty/serial/
-
-SERIAL DEVICE BUS
-M:	Rob Herring <robh@kernel.org>
-L:	linux-serial@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/serial/slave-device.txt
-F:	drivers/tty/serdev/
-F:	include/linux/serdev.h
-
-SERIAL IR RECEIVER
-M:	Sean Young <sean@mess.org>
-L:	linux-media@vger.kernel.org
-S:	Maintained
-F:	drivers/media/rc/serial_ir.c
-
-STI CEC DRIVER
-M:	Benjamin Gaignard <benjamin.gaignard@linaro.org>
-S:	Maintained
-F:	drivers/staging/media/st-cec/
-F:	Documentation/devicetree/bindings/media/stih-cec.txt
-
-SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
-M:	Ursula Braun <ubraun@linux.vnet.ibm.com>
-L:	linux-s390@vger.kernel.org
-W:	http://www.ibm.com/developerworks/linux/linux390/
-S:	Supported
-F:	net/smc/
-
-SYNOPSYS DESIGNWARE DMAC DRIVER
-M:	Viresh Kumar <vireshk@kernel.org>
-M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
-S:	Maintained
-F:	include/linux/dma/dw.h
-F:	include/linux/platform_data/dma-dw.h
-F:	drivers/dma/dw/
-
-SYNOPSYS DESIGNWARE ENTERPRISE ETHERNET DRIVER
-M:	Jie Deng <jiedeng@synopsys.com>
-L:	netdev@vger.kernel.org
-S:	Supported
-F:	drivers/net/ethernet/synopsys/
-
-SYNOPSYS DESIGNWARE I2C DRIVER
-M:	Jarkko Nikula <jarkko.nikula@linux.intel.com>
-R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
-R:	Mika Westerberg <mika.westerberg@linux.intel.com>
-L:	linux-i2c@vger.kernel.org
-S:	Maintained
-F:	drivers/i2c/busses/i2c-designware-*
-F:	include/linux/platform_data/i2c-designware.h
-
-SYNOPSYS DESIGNWARE MMC/SD/SDIO DRIVER
-M:	Jaehoon Chung <jh80.chung@samsung.com>
-L:	linux-mmc@vger.kernel.org
-S:	Maintained
-F:	drivers/mmc/host/dw_mmc*
-
-SYSTEM TRACE MODULE CLASS
-M:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ash/stm.git
-F:	Documentation/trace/stm.txt
-F:	drivers/hwtracing/stm/
-F:	include/linux/stm.h
-F:	include/uapi/linux/stm.h
-
-TEE SUBSYSTEM
-M:	Jens Wiklander <jens.wiklander@linaro.org>
-S:	Maintained
-F:	include/linux/tee_drv.h
-F:	include/uapi/linux/tee.h
-F:	drivers/tee/
-F:	Documentation/tee.txt
-
-THUNDERBOLT DRIVER
-M:	Andreas Noever <andreas.noever@gmail.com>
-S:	Maintained
-F:	drivers/thunderbolt/
-
-TI BQ27XXX POWER SUPPLY DRIVER
-R:	Andrew F. Davis <afd@ti.com>
-F:	include/linux/power/bq27xxx_battery.h
-F:	drivers/power/supply/bq27xxx_battery.c
-F:	drivers/power/supply/bq27xxx_battery_i2c.c
-
-TIMEKEEPING, CLOCKSOURCE CORE, NTP, ALARMTIMER
-M:	John Stultz <john.stultz@linaro.org>
-M:	Thomas Gleixner <tglx@linutronix.de>
-R:	Stephen Boyd <sboyd@codeaurora.org>
-L:	linux-kernel@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
-S:	Supported
-F:	include/linux/clocksource.h
-F:	include/linux/time.h
-F:	include/linux/timex.h
-F:	include/uapi/linux/time.h
-F:	include/uapi/linux/timex.h
-F:	kernel/time/clocksource.c
-F:	kernel/time/time*.c
-F:	kernel/time/alarmtimer.c
-F:	kernel/time/ntp.c
-F:	tools/testing/selftests/timers/
-
-SC1200 WDT DRIVER
-M:	Zwane Mwaikambo <zwanem@gmail.com>
-S:	Maintained
-F:	drivers/watchdog/sc1200wdt.c
+F:	drivers/watchdog/sc1200wdt.c
 
 SCHEDULER
 M:	Ingo Molnar <mingo@redhat.com>
@@ -11381,16 +11285,6 @@ M:	Lubomir Rintel <lkundrak@v3.sk>
 S:	Supported
 F:	drivers/char/pcmcia/scr24x_cs.c
 
-SYSTEM CONTROL & POWER INTERFACE (SCPI) Message Protocol drivers
-M:	Sudeep Holla <sudeep.holla@arm.com>
-L:	linux-arm-kernel@lists.infradead.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/arm/arm,scpi.txt
-F:	drivers/clk/clk-scpi.c
-F:	drivers/cpufreq/scpi-cpufreq.c
-F:	drivers/firmware/arm_scpi.c
-F:	include/linux/scpi_protocol.h
-
 SCSI CDROM DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
 L:	linux-scsi@vger.kernel.org
@@ -11475,14 +11369,6 @@ L:	sdricohcs-devel@lists.sourceforge.net
 S:	Maintained
 F:	drivers/mmc/host/sdricoh_cs.c
 
-SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
-M:	Adrian Hunter <adrian.hunter@intel.com>
-L:	linux-mmc@vger.kernel.org
-T:	git git://git.infradead.org/users/ahunter/linux-sdhci.git
-S:	Maintained
-F:	drivers/mmc/host/sdhci*
-F:	include/linux/mmc/sdhci*
-
 SECURE COMPUTING
 M:	Kees Cook <keescook@chromium.org>
 R:	Andy Lutomirski <luto@amacapital.net>
@@ -11496,6 +11382,14 @@ F:	tools/testing/selftests/seccomp/*
 K:	\bsecure_computing
 K:	\bTIF_SECCOMP\b
 
+SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
+M:	Adrian Hunter <adrian.hunter@intel.com>
+L:	linux-mmc@vger.kernel.org
+T:	git git://git.infradead.org/users/ahunter/linux-sdhci.git
+S:	Maintained
+F:	drivers/mmc/host/sdhci*
+F:	include/linux/mmc/sdhci*
+
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) Broadcom BRCMSTB DRIVER
 M:	Al Cooper <alcooperx@gmail.com>
 L:	linux-mmc@vger.kernel.org
@@ -11552,59 +11446,32 @@ F:	include/linux/selinux*
 F:	security/selinux/
 F:	scripts/selinux/
 
-APPARMOR SECURITY MODULE
-M:	John Johansen <john.johansen@canonical.com>
-L:	apparmor@lists.ubuntu.com (subscribers-only, general discussion)
-W:	apparmor.wiki.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git
-S:	Supported
-F:	security/apparmor/
-
-LOADPIN SECURITY MODULE
-M:	Kees Cook <keescook@chromium.org>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git lsm/loadpin
-S:	Supported
-F:	security/loadpin/
-
-YAMA SECURITY MODULE
-M:	Kees Cook <keescook@chromium.org>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git yama/tip
-S:	Supported
-F:	security/yama/
-
 SENSABLE PHANTOM
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
 F:	drivers/misc/phantom.c
 F:	include/uapi/linux/phantom.h
 
-Emulex 10Gbps iSCSI - OneConnect DRIVER
-M:	Subbu Seetharaman <subbu.seetharaman@broadcom.com>
-M:	Ketan Mukadam <ketan.mukadam@broadcom.com>
-M:	Jitendra Bhivare <jitendra.bhivare@broadcom.com>
-L:	linux-scsi@vger.kernel.org
-W:	http://www.broadcom.com
-S:	Supported
-F:	drivers/scsi/be2iscsi/
+SERIAL DRIVERS
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+L:	linux-serial@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/serial/
+F:	drivers/tty/serial/
 
-Emulex 10Gbps NIC BE2, BE3-R, Lancer, Skyhawk-R DRIVER (be2net)
-M:	Sathya Perla <sathya.perla@broadcom.com>
-M:	Ajit Khaparde <ajit.khaparde@broadcom.com>
-M:	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
-M:	Somnath Kotur <somnath.kotur@broadcom.com>
-L:	netdev@vger.kernel.org
-W:	http://www.emulex.com
-S:	Supported
-F:	drivers/net/ethernet/emulex/benet/
+SERIAL DEVICE BUS
+M:	Rob Herring <robh@kernel.org>
+L:	linux-serial@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/serial/slave-device.txt
+F:	drivers/tty/serdev/
+F:	include/linux/serdev.h
 
-EMULEX ONECONNECT ROCE DRIVER
-M:	Selvin Xavier <selvin.xavier@broadcom.com>
-M:	Devesh Sharma <devesh.sharma@broadcom.com>
-L:	linux-rdma@vger.kernel.org
-W:	http://www.broadcom.com
-S:	Odd Fixes
-F:	drivers/infiniband/hw/ocrdma/
-F:	include/uapi/rdma/ocrdma-abi.h
+SERIAL IR RECEIVER
+M:	Sean Young <sean@mess.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/rc/serial_ir.c
 
 SFC NETWORK DRIVER
 M:	Solarflare linux maintainers <linux-net-drivers@solarflare.com>
@@ -11633,6 +11500,24 @@ M:	Robin Holt <robinmholt@gmail.com>
 S:	Maintained
 F:	drivers/misc/sgi-xp/
 
+SH_VEU V4L2 MEM2MEM DRIVER
+L:	linux-media@vger.kernel.org
+S:	Orphan
+F:	drivers/media/platform/sh_veu.c
+
+SH_VOU V4L2 OUTPUT DRIVER
+L:	linux-media@vger.kernel.org
+S:	Orphan
+F:	drivers/media/platform/sh_vou.c
+F:	include/media/drv-intf/sh_vou.h
+
+SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
+M:	Ursula Braun <ubraun@linux.vnet.ibm.com>
+L:	linux-s390@vger.kernel.org
+W:	http://www.ibm.com/developerworks/linux/linux390/
+S:	Supported
+F:	net/smc/
+
 SI2157 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
@@ -11715,24 +11600,14 @@ S:	Maintained
 F:	drivers/input/touchscreen/silead.c
 F:	drivers/platform/x86/silead_dmi.c
 
-SIMPLEFB FB DRIVER
-M:	Hans de Goede <hdegoede@redhat.com>
+SILICON MOTION SM712 FRAME BUFFER DRIVER
+M:	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
+M:	Teddy Wang <teddy.wang@siliconmotion.com>
+M:	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/display/simple-framebuffer.txt
-F:	drivers/video/fbdev/simplefb.c
-F:	include/linux/platform_data/simplefb.h
-
-SH_VEU V4L2 MEM2MEM DRIVER
-L:	linux-media@vger.kernel.org
-S:	Orphan
-F:	drivers/media/platform/sh_veu.c
-
-SH_VOU V4L2 OUTPUT DRIVER
-L:	linux-media@vger.kernel.org
-S:	Orphan
-F:	drivers/media/platform/sh_vou.c
-F:	include/media/drv-intf/sh_vou.h
+F:	drivers/video/fbdev/sm712*
+F:	Documentation/fb/sm712fb.txt
 
 SIMPLE FIRMWARE INTERFACE (SFI)
 M:	Len Brown <lenb@kernel.org>
@@ -11744,6 +11619,14 @@ F:	arch/x86/platform/sfi/
 F:	drivers/sfi/
 F:	include/linux/sfi*.h
 
+SIMPLEFB FB DRIVER
+M:	Hans de Goede <hdegoede@redhat.com>
+L:	linux-fbdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/display/simple-framebuffer.txt
+F:	drivers/video/fbdev/simplefb.c
+F:	include/linux/platform_data/simplefb.h
+
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
 P:	Vincent Sanders <vince@simtec.co.uk>
@@ -11768,54 +11651,6 @@ F:	lib/siphash.c
 F:	lib/test_siphash.c
 F:	include/linux/siphash.h
 
-TI DAVINCI MACHINE SUPPORT
-M:	Sekhar Nori <nsekhar@ti.com>
-M:	Kevin Hilman <khilman@kernel.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci.git
-S:	Supported
-F:	arch/arm/mach-davinci/
-F:	drivers/i2c/busses/i2c-davinci.c
-F:	arch/arm/boot/dts/da850*
-
-TI DAVINCI SERIES MEDIA DRIVER
-M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
-L:	linux-media@vger.kernel.org
-W:	https://linuxtv.org
-Q:	http://patchwork.linuxtv.org/project/linux-media/list/
-T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
-S:	Maintained
-F:	drivers/media/platform/davinci/
-F:	include/media/davinci/
-
-TI AM437X VPFE DRIVER
-M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
-L:	linux-media@vger.kernel.org
-W:	https://linuxtv.org
-Q:	http://patchwork.linuxtv.org/project/linux-media/list/
-T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
-S:	Maintained
-F:	drivers/media/platform/am437x/
-
-OV2659 OMNIVISION SENSOR DRIVER
-M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
-L:	linux-media@vger.kernel.org
-W:	https://linuxtv.org
-Q:	http://patchwork.linuxtv.org/project/linux-media/list/
-T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
-S:	Maintained
-F:	drivers/media/i2c/ov2659.c
-F:	include/media/i2c/ov2659.h
-
-SILICON MOTION SM712 FRAME BUFFER DRIVER
-M:	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
-M:	Teddy Wang <teddy.wang@siliconmotion.com>
-M:	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
-L:	linux-fbdev@vger.kernel.org
-S:	Maintained
-F:	drivers/video/fbdev/sm712*
-F:	Documentation/fb/sm712fb.txt
-
 SIS 190 ETHERNET DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
@@ -11876,14 +11711,6 @@ S:	Maintained
 F:	Documentation/security/Smack.txt
 F:	security/smack/
 
-DRIVERS FOR ADAPTIVE VOLTAGE SCALING (AVS)
-M:	Kevin Hilman <khilman@kernel.org>
-M:	Nishanth Menon <nm@ti.com>
-S:	Maintained
-F:	drivers/power/avs/
-F:	include/linux/power/smartreflex.h
-L:	linux-pm@vger.kernel.org
-
 SMC91x ETHERNET DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
@@ -11961,6 +11788,15 @@ M:	Chris Boot <bootc@bootc.net>
 S:	Maintained
 F:	drivers/leds/leds-net48xx.c
 
+SOFT-ROCE DRIVER (rxe)
+M:	Moni Shoua <monis@mellanox.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+W:	https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
+F:	drivers/infiniband/sw/rxe/
+F:	include/uapi/rdma/rdma_user_rxe.h
+
 SOFTLOGIC 6x10 MPEG CODEC
 M:	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
 M:	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
@@ -12275,6 +12111,27 @@ M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
 F:	drivers/net/ethernet/adaptec/starfire*
 
+STI CEC DRIVER
+M:	Benjamin Gaignard <benjamin.gaignard@linaro.org>
+S:	Maintained
+F:	drivers/staging/media/st-cec/
+F:	Documentation/devicetree/bindings/media/stih-cec.txt
+
+STK1160 USB VIDEO CAPTURE DRIVER
+M:	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/stk1160/
+
+STMMAC ETHERNET DRIVER
+M:	Giuseppe Cavallaro <peppe.cavallaro@st.com>
+M:	Alexandre Torgue <alexandre.torgue@st.com>
+L:	netdev@vger.kernel.org
+W:	http://www.stlinux.com
+S:	Supported
+F:	drivers/net/ethernet/stmicro/stmmac/
+
 SUN3/3X
 M:	Sam Creasey <sammy@sammy.net>
 W:	http://sammy.net/sun3/
@@ -12346,6 +12203,20 @@ S:	Supported
 F:	net/switchdev/
 F:	include/net/switchdev.h
 
+SYNC FILE FRAMEWORK
+M:	Sumit Semwal <sumit.semwal@linaro.org>
+R:	Gustavo Padovan <gustavo@padovan.org>
+S:	Maintained
+L:	linux-media@vger.kernel.org
+L:	dri-devel@lists.freedesktop.org
+F:	drivers/dma-buf/sync_*
+F:	drivers/dma-buf/dma-fence*
+F:	drivers/dma-buf/sw_sync.c
+F:	include/linux/sync_file.h
+F:	include/uapi/linux/sync_file.h
+F:	Documentation/sync_file.txt
+T:	git git://anongit.freedesktop.org/drm/drm-misc
+
 SYNOPSYS ARC ARCHITECTURE
 M:	Vineet Gupta <vgupta@synopsys.com>
 L:	linux-snps-arc@lists.infradead.org
@@ -12364,6 +12235,35 @@ F:	arch/arc/plat-axs10x
 F:	arch/arc/boot/dts/ax*
 F:	Documentation/devicetree/bindings/arc/axs10*
 
+SYNOPSYS DESIGNWARE DMAC DRIVER
+M:	Viresh Kumar <vireshk@kernel.org>
+M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+S:	Maintained
+F:	include/linux/dma/dw.h
+F:	include/linux/platform_data/dma-dw.h
+F:	drivers/dma/dw/
+
+SYNOPSYS DESIGNWARE ENTERPRISE ETHERNET DRIVER
+M:	Jie Deng <jiedeng@synopsys.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/ethernet/synopsys/
+
+SYNOPSYS DESIGNWARE I2C DRIVER
+M:	Jarkko Nikula <jarkko.nikula@linux.intel.com>
+R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+R:	Mika Westerberg <mika.westerberg@linux.intel.com>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	drivers/i2c/busses/i2c-designware-*
+F:	include/linux/platform_data/i2c-designware.h
+
+SYNOPSYS DESIGNWARE MMC/SD/SDIO DRIVER
+M:	Jaehoon Chung <jh80.chung@samsung.com>
+L:	linux-mmc@vger.kernel.org
+S:	Maintained
+F:	drivers/mmc/host/dw_mmc*
+
 SYSTEM CONFIGURATION (SYSCON)
 M:	Lee Jones <lee.jones@linaro.org>
 M:	Arnd Bergmann <arnd@arndb.de>
@@ -12371,6 +12271,16 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Supported
 F:	drivers/mfd/syscon.c
 
+SYSTEM CONTROL & POWER INTERFACE (SCPI) Message Protocol drivers
+M:	Sudeep Holla <sudeep.holla@arm.com>
+L:	linux-arm-kernel@lists.infradead.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/arm/arm,scpi.txt
+F:	drivers/clk/clk-scpi.c
+F:	drivers/cpufreq/scpi-cpufreq.c
+F:	drivers/firmware/arm_scpi.c
+F:	include/linux/scpi_protocol.h
+
 SYSTEM RESET/SHUTDOWN DRIVERS
 M:	Sebastian Reichel <sre@kernel.org>
 L:	linux-pm@vger.kernel.org
@@ -12379,6 +12289,15 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/power/reset/
 F:	drivers/power/reset/
 
+SYSTEM TRACE MODULE CLASS
+M:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ash/stm.git
+F:	Documentation/trace/stm.txt
+F:	drivers/hwtracing/stm/
+F:	include/linux/stm.h
+F:	include/uapi/linux/stm.h
+
 SYSV FILESYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
 S:	Maintained
@@ -12548,6 +12467,14 @@ L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/rc/ttusbir.c
 
+TEE SUBSYSTEM
+M:	Jens Wiklander <jens.wiklander@linaro.org>
+S:	Maintained
+F:	include/linux/tee_drv.h
+F:	include/uapi/linux/tee.h
+F:	drivers/tee/
+F:	Documentation/tee.txt
+
 TEGRA ARCHITECTURE SUPPORT
 M:	Thierry Reding <thierry.reding@gmail.com>
 M:	Jonathan Hunter <jonathanh@nvidia.com>
@@ -12675,6 +12602,46 @@ T:	git git://repo.or.cz/linux-2.6/linux-
 S:	Maintained
 F:	drivers/platform/x86/thinkpad_acpi.c
 
+THUNDERBOLT DRIVER
+M:	Andreas Noever <andreas.noever@gmail.com>
+S:	Maintained
+F:	drivers/thunderbolt/
+
+TI BQ27XXX POWER SUPPLY DRIVER
+R:	Andrew F. Davis <afd@ti.com>
+F:	include/linux/power/bq27xxx_battery.h
+F:	drivers/power/supply/bq27xxx_battery.c
+F:	drivers/power/supply/bq27xxx_battery_i2c.c
+
+TI DAVINCI MACHINE SUPPORT
+M:	Sekhar Nori <nsekhar@ti.com>
+M:	Kevin Hilman <khilman@kernel.org>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci.git
+S:	Supported
+F:	arch/arm/mach-davinci/
+F:	drivers/i2c/busses/i2c-davinci.c
+F:	arch/arm/boot/dts/da850*
+
+TI DAVINCI SERIES MEDIA DRIVER
+M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
+S:	Maintained
+F:	drivers/media/platform/davinci/
+F:	include/media/davinci/
+
+TI AM437X VPFE DRIVER
+M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
+S:	Maintained
+F:	drivers/media/platform/am437x/
+
 TI BANDGAP AND THERMAL DRIVER
 M:	Eduardo Valentin <edubezval@gmail.com>
 M:	Keerthy <j-keerthy@ti.com>
@@ -12726,7 +12693,6 @@ S:	Maintained
 F:	drivers/soc/ti/*
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
 
-
 TI LM49xxx FAMILY ASoC CODEC DRIVERS
 M:	M R Swami Reddy <mr.swami.reddy@ti.com>
 M:	Vishwas A Deshpande <vishwas.a.deshpande@ti.com>
@@ -12786,16 +12752,6 @@ S:	Orphan
 F:	drivers/net/wireless/ti/
 F:	include/linux/wl12xx.h
 
-TIPC NETWORK LAYER
-M:	Jon Maloy <jon.maloy@ericsson.com>
-M:	Ying Xue <ying.xue@windriver.com>
-L:	netdev@vger.kernel.org (core kernel code)
-L:	tipc-discussion@lists.sourceforge.net (user apps, general discussion)
-W:	http://tipc.sourceforge.net/
-S:	Maintained
-F:	include/uapi/linux/tipc*.h
-F:	net/tipc/
-
 TILE ARCHITECTURE
 M:	Chris Metcalf <cmetcalf@mellanox.com>
 W:	http://www.mellanox.com/repository/solutions/tile-scm/
@@ -12811,6 +12767,34 @@ F:	drivers/tty/serial/tilegx.c
 F:	drivers/usb/host/*-tilegx.c
 F:	include/linux/usb/tilegx.h
 
+TIMEKEEPING, CLOCKSOURCE CORE, NTP, ALARMTIMER
+M:	John Stultz <john.stultz@linaro.org>
+M:	Thomas Gleixner <tglx@linutronix.de>
+R:	Stephen Boyd <sboyd@codeaurora.org>
+L:	linux-kernel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
+S:	Supported
+F:	include/linux/clocksource.h
+F:	include/linux/time.h
+F:	include/linux/timex.h
+F:	include/uapi/linux/time.h
+F:	include/uapi/linux/timex.h
+F:	kernel/time/clocksource.c
+F:	kernel/time/time*.c
+F:	kernel/time/alarmtimer.c
+F:	kernel/time/ntp.c
+F:	tools/testing/selftests/timers/
+
+TIPC NETWORK LAYER
+M:	Jon Maloy <jon.maloy@ericsson.com>
+M:	Ying Xue <ying.xue@windriver.com>
+L:	netdev@vger.kernel.org (core kernel code)
+L:	tipc-discussion@lists.sourceforge.net (user apps, general discussion)
+W:	http://tipc.sourceforge.net/
+S:	Maintained
+F:	include/uapi/linux/tipc*.h
+F:	net/tipc/
+
 TLAN NETWORK DRIVER
 M:	Samuel Chessman <chessman@tux.org>
 L:	tlan-devel@lists.sourceforge.net (subscribers-only)
@@ -12819,6 +12803,38 @@ S:	Maintained
 F:	Documentation/networking/tlan.txt
 F:	drivers/net/ethernet/ti/tlan.*
 
+TMIO/SDHI MMC DRIVER
+M:	Wolfram Sang <wsa+renesas@sang-engineering.com>
+L:	linux-mmc@vger.kernel.org
+S:	Supported
+F:	drivers/mmc/host/tmio_mmc*
+F:	drivers/mmc/host/sh_mobile_sdhi.c
+F:	include/linux/mfd/tmio.h
+
+TMP401 HARDWARE MONITOR DRIVER
+M:	Guenter Roeck <linux@roeck-us.net>
+L:	linux-hwmon@vger.kernel.org
+S:	Maintained
+F:	Documentation/hwmon/tmp401
+F:	drivers/hwmon/tmp401.c
+
+TMPFS (SHMEM FILESYSTEM)
+M:	Hugh Dickins <hughd@google.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/shmem_fs.h
+F:	mm/shmem.c
+
+TM6000 VIDEO4LINUX DRIVER
+M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
+M:	Mauro Carvalho Chehab <mchehab@kernel.org>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Odd fixes
+F:	drivers/media/usb/tm6000/
+F:	Documentation/media/v4l-drivers/tm6000*
+
 TOMOYO SECURITY MODULE
 M:	Kentaro Takeda <takedakn@nttdata.co.jp>
 M:	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
@@ -12876,62 +12892,6 @@ S:	Maintained
 F:	drivers/media/i2c/tc358743*
 F:	include/media/i2c/tc358743.h
 
-TMIO/SDHI MMC DRIVER
-M:	Wolfram Sang <wsa+renesas@sang-engineering.com>
-L:	linux-mmc@vger.kernel.org
-S:	Supported
-F:	drivers/mmc/host/tmio_mmc*
-F:	drivers/mmc/host/sh_mobile_sdhi.c
-F:	include/linux/mfd/tmio.h
-
-TMP401 HARDWARE MONITOR DRIVER
-M:	Guenter Roeck <linux@roeck-us.net>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-F:	Documentation/hwmon/tmp401
-F:	drivers/hwmon/tmp401.c
-
-TMPFS (SHMEM FILESYSTEM)
-M:	Hugh Dickins <hughd@google.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	include/linux/shmem_fs.h
-F:	mm/shmem.c
-
-TM6000 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
-M:	Mauro Carvalho Chehab <mchehab@kernel.org>
-L:	linux-media@vger.kernel.org
-W:	https://linuxtv.org
-T:	git git://linuxtv.org/media_tree.git
-S:	Odd fixes
-F:	drivers/media/usb/tm6000/
-F:	Documentation/media/v4l-drivers/tm6000*
-
-TW5864 VIDEO4LINUX DRIVER
-M:	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
-M:	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
-M:	Andrey Utkin <andrey_utkin@fastmail.com>
-L:	linux-media@vger.kernel.org
-S:	Supported
-F:	drivers/media/pci/tw5864/
-
-TW68 VIDEO4LINUX DRIVER
-M:	Hans Verkuil <hverkuil@xs4all.nl>
-L:	linux-media@vger.kernel.org
-T:	git git://linuxtv.org/media_tree.git
-W:	https://linuxtv.org
-S:	Odd Fixes
-F:	drivers/media/pci/tw68/
-
-TW686X VIDEO4LINUX DRIVER
-M:	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
-L:	linux-media@vger.kernel.org
-T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
-S:	Maintained
-F:	drivers/media/pci/tw686x/
-
 TPM DEVICE DRIVER
 M:	Peter Huewe <peterhuewe@gmx.de>
 M:	Marcel Selhorst <tpmdd@selhorst.net>
@@ -13032,6 +12992,30 @@ S:	Maintained
 F:	drivers/tc/
 F:	include/linux/tc.h
 
+TW5864 VIDEO4LINUX DRIVER
+M:	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
+M:	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
+M:	Andrey Utkin <andrey_utkin@fastmail.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+F:	drivers/media/pci/tw5864/
+
+TW68 VIDEO4LINUX DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	https://linuxtv.org
+S:	Odd Fixes
+F:	drivers/media/pci/tw68/
+
+TW686X VIDEO4LINUX DRIVER
+M:	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/pci/tw686x/
+
 UBI FILE SYSTEM (UBIFS)
 M:	Richard Weinberger <richard@nod.at>
 M:	Artem Bityutskiy <dedekind1@gmail.com>
@@ -13081,6 +13065,13 @@ S:	Maintained
 F:	drivers/hid/uhid.c
 F:	include/uapi/linux/uhid.h
 
+ULPI BUS
+M:	Heikki Krogerus <heikki.krogerus@linux.intel.com>
+L:	linux-usb@vger.kernel.org
+S:	Maintained
+F:	drivers/usb/common/ulpi.c
+F:	include/linux/ulpi/
+
 ULTRA-WIDEBAND (UWB) SUBSYSTEM:
 L:	linux-usb@vger.kernel.org
 S:	Orphan
@@ -13426,13 +13417,6 @@ S:	Maintained
 F:	Documentation/media/v4l-drivers/zr364xx*
 F:	drivers/media/usb/zr364xx/
 
-ULPI BUS
-M:	Heikki Krogerus <heikki.krogerus@linux.intel.com>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-F:	drivers/usb/common/ulpi.c
-F:	include/linux/ulpi/
-
 USER-MODE LINUX (UML)
 M:	Jeff Dike <jdike@addtoit.com>
 M:	Richard Weinberger <richard@nod.at>
@@ -13515,6 +13499,31 @@ F:	drivers/gpu/vga/vga_switcheroo.c
 F:	include/linux/vga_switcheroo.h
 T:	git git://anongit.freedesktop.org/drm/drm-misc
 
+VIA RHINE NETWORK DRIVER
+S:	Orphan
+F:	drivers/net/ethernet/via/via-rhine.c
+
+VIA SD/MMC CARD CONTROLLER DRIVER
+M:	Bruce Chang <brucechang@via.com.tw>
+M:	Harald Welte <HaraldWelte@viatech.com>
+S:	Maintained
+F:	drivers/mmc/host/via-sdmmc.c
+
+VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
+M:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
+L:	linux-fbdev@vger.kernel.org
+S:	Maintained
+F:	include/linux/via-core.h
+F:	include/linux/via-gpio.h
+F:	include/linux/via_i2c.h
+F:	drivers/video/fbdev/via/
+
+VIA VELOCITY NETWORK DRIVER
+M:	Francois Romieu <romieu@fr.zoreil.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/via/via-velocity.*
+
 VIDEOBUF2 FRAMEWORK
 M:	Pawel Osciak <pawel@osciak.com>
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
@@ -13524,6 +13533,21 @@ S:	Maintained
 F:	drivers/media/v4l2-core/videobuf2-*
 F:	include/media/videobuf2-*
 
+VIMC VIRTUAL MEDIA CONTROLLER DRIVER
+M:	Helen Koike <helen.koike@collabora.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	https://linuxtv.org
+S:	Maintained
+F:	drivers/media/platform/vimc/*
+
+VIRT LIB
+M:	Alex Williamson <alex.williamson@redhat.com>
+M:	Paolo Bonzini <pbonzini@redhat.com>
+L:	kvm@vger.kernel.org
+S:	Supported
+F:	virt/lib/
+
 VIRTIO AND VHOST VSOCK DRIVER
 M:	Stefan Hajnoczi <stefanha@redhat.com>
 L:	kvm@vger.kernel.org
@@ -13540,12 +13564,6 @@ F:	drivers/net/vsockmon.c
 F:	drivers/vhost/vsock.c
 F:	drivers/vhost/vsock.h
 
-VIRTUAL SERIO DEVICE DRIVER
-M:	Stephen Chandler Paul <thatslyude@gmail.com>
-S:	Maintained
-F:	drivers/input/serio/userio.c
-F:	include/uapi/linux/userio.h
-
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit@kernel.org>
 L:	virtualization@lists.linux-foundation.org
@@ -13612,37 +13630,11 @@ S:  Maintained
 F:  drivers/crypto/virtio/
 F:  include/uapi/linux/virtio_crypto.h
 
-VIA RHINE NETWORK DRIVER
-S:	Orphan
-F:	drivers/net/ethernet/via/via-rhine.c
-
-VIA SD/MMC CARD CONTROLLER DRIVER
-M:	Bruce Chang <brucechang@via.com.tw>
-M:	Harald Welte <HaraldWelte@viatech.com>
-S:	Maintained
-F:	drivers/mmc/host/via-sdmmc.c
-
-VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
-M:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
-L:	linux-fbdev@vger.kernel.org
-S:	Maintained
-F:	include/linux/via-core.h
-F:	include/linux/via-gpio.h
-F:	include/linux/via_i2c.h
-F:	drivers/video/fbdev/via/
-
-VIA VELOCITY NETWORK DRIVER
-M:	Francois Romieu <romieu@fr.zoreil.com>
-L:	netdev@vger.kernel.org
+VIRTUAL SERIO DEVICE DRIVER
+M:	Stephen Chandler Paul <thatslyude@gmail.com>
 S:	Maintained
-F:	drivers/net/ethernet/via/via-velocity.*
-
-VIRT LIB
-M:	Alex Williamson <alex.williamson@redhat.com>
-M:	Paolo Bonzini <pbonzini@redhat.com>
-L:	kvm@vger.kernel.org
-S:	Supported
-F:	virt/lib/
+F:	drivers/input/serio/userio.c
+F:	include/uapi/linux/userio.h
 
 VIVID VIRTUAL VIDEO DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
@@ -13652,14 +13644,6 @@ W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/platform/vivid/*
 
-VIMC VIRTUAL MEDIA CONTROLLER DRIVER
-M:	Helen Koike <helen.koike@collabora.com>
-L:	linux-media@vger.kernel.org
-T:	git git://linuxtv.org/media_tree.git
-W:	https://linuxtv.org
-S:	Maintained
-F:	drivers/media/platform/vimc/*
-
 VLYNQ BUS
 M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	openwrt-devel@lists.openwrt.org (subscribers-only)
@@ -13820,6 +13804,27 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/hid/hid-wiimote*
 
+WILOCITY WIL6210 WIRELESS DRIVER
+M:	Maya Erez <qca_merez@qca.qualcomm.com>
+L:	linux-wireless@vger.kernel.org
+L:	wil6210@qca.qualcomm.com
+S:	Supported
+W:	http://wireless.kernel.org/en/users/Drivers/wil6210
+F:	drivers/net/wireless/ath/wil6210/
+F:	include/uapi/linux/wil6210_uapi.h
+
+WIMAX STACK
+M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
+M:	linux-wimax@intel.com
+L:	wimax@linuxwimax.org (subscribers-only)
+S:	Supported
+W:	http://linuxwimax.org
+F:	Documentation/wimax/README.wimax
+F:	include/linux/wimax/debug.h
+F:	include/net/wimax.h
+F:	include/uapi/linux/wimax.h
+F:	net/wimax/
+
 WINBOND CIR DRIVER
 M:	David Härdeman <david@hardeman.nu>
 S:	Maintained
@@ -13837,18 +13842,6 @@ L:	linux-gpio@vger.kernel.org
 S:	Maintained
 F:	drivers/gpio/gpio-ws16c48.c
 
-WIMAX STACK
-M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
-M:	linux-wimax@intel.com
-L:	wimax@linuxwimax.org (subscribers-only)
-S:	Supported
-W:	http://linuxwimax.org
-F:	Documentation/wimax/README.wimax
-F:	include/linux/wimax/debug.h
-F:	include/net/wimax.h
-F:	include/uapi/linux/wimax.h
-F:	net/wimax/
