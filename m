From: akpm@linux-foundation.org
Subject: [merged] maintainers-adjust-for-uapi.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:12 -0800
Message-ID: <20130107192613.1638B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:53814 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab3AGT0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:15 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so1214171eek.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: adjust for UAPI
has been removed from the -mm tree.  Its filename was
     maintainers-adjust-for-uapi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: adjust for UAPI

Several headers were moved or split to uapi/.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |  156 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 115 insertions(+), 41 deletions(-)

diff -puN MAINTAINERS~maintainers-adjust-for-uapi MAINTAINERS
--- a/MAINTAINERS~maintainers-adjust-for-uapi
+++ a/MAINTAINERS
@@ -449,6 +449,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/char/agp/
 F:	include/linux/agp*
+F:	include/uapi/linux/agp*
 
 AHA152X SCSI DRIVER
 M:	"Juergen E. Fischer" <fischer@norbit.de>
@@ -589,6 +590,7 @@ M:	Jiri Kosina <jkosina@suse.cz>
 S:	Odd fixes
 F:	arch/x86/kernel/apm_32.c
 F:	include/linux/apm_bios.h
+F:	include/uapi/linux/apm_bios.h
 F:	drivers/char/apm-emulation.c
 
 APPLE BCM5974 MULTITOUCH DRIVER
@@ -1384,6 +1386,7 @@ W:	http://linux-atm.sourceforge.net
 S:	Maintained
 F:	drivers/atm/
 F:	include/linux/atm*
+F:	include/uapi/linux/atm*
 
 ATMEL AT91 / AT32 MCI DRIVER
 M:	Ludovic Desroches <ludovic.desroches@atmel.com>
@@ -1463,6 +1466,7 @@ W:	http://people.redhat.com/sgrubb/audit
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git
 S:	Maintained
 F:	include/linux/audit.h
+F:	include/uapi/linux/audit.h
 F:	kernel/audit*
 
 AUXILIARY DISPLAY DRIVERS
@@ -1493,7 +1497,7 @@ M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
-F:	include/linux/ax25.h
+F:	include/uapi/linux/ax25.h
 F:	include/net/ax25.h
 F:	net/ax25/
 
@@ -1554,7 +1558,7 @@ M:	"Tigran A. Aivazian" <tigran@aivazian
 S:	Maintained
 F:	Documentation/filesystems/bfs.txt
 F:	fs/bfs/
-F:	include/linux/bfs_fs.h
+F:	include/uapi/linux/bfs_fs.h
 
 BLACKFIN ARCHITECTURE
 M:	Mike Frysinger <vapier@gentoo.org>
@@ -1651,7 +1655,7 @@ L:	netdev@vger.kernel.org
 W:	http://sourceforge.net/projects/bonding/
 S:	Supported
 F:	drivers/net/bonding/
-F:	include/linux/if_bonding.h
+F:	include/uapi/linux/if_bonding.h
 
 BROADCOM B44 10/100 ETHERNET DRIVER
 M:	Gary Zambrano <zambrano@broadcom.com>
@@ -1730,6 +1734,7 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	block/bsg.c
 F:	include/linux/bsg.h
+F:	include/uapi/linux/bsg.h
 
 BT87X AUDIO DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
@@ -1800,7 +1805,7 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/caif/
 F:	drivers/net/caif/
-F:	include/linux/caif/
+F:	include/uapi/linux/caif/
 F:	include/net/caif/
 F:	net/caif/
 
@@ -1821,11 +1826,11 @@ W:	http://gitorious.org/linux-can
 T:	git git://gitorious.org/linux-can/linux-can-next.git
 S:	Maintained
 F:	net/can/
-F:	include/linux/can.h
 F:	include/linux/can/core.h
-F:	include/linux/can/bcm.h
-F:	include/linux/can/raw.h
-F:	include/linux/can/gw.h
+F:	include/uapi/linux/can.h
+F:	include/uapi/linux/can/bcm.h
+F:	include/uapi/linux/can/raw.h
+F:	include/uapi/linux/can/gw.h
 
 CAN NETWORK DRIVERS
 M:	Wolfgang Grandegger <wg@grandegger.com>
@@ -1836,15 +1841,16 @@ T:	git git://gitorious.org/linux-can/lin
 S:	Maintained
 F:	drivers/net/can/
 F:	include/linux/can/dev.h
-F:	include/linux/can/error.h
-F:	include/linux/can/netlink.h
 F:	include/linux/can/platform/
+F:	include/uapi/linux/can/error.h
+F:	include/uapi/linux/can/netlink.h
 
 CAPABILITIES
 M:	Serge Hallyn <serge.hallyn@canonical.com>
 L:	linux-security-module@vger.kernel.org
 S:	Supported
 F:	include/linux/capability.h
+F:	include/uapi/linux/capability.h
 F:	security/capability.c
 F:	security/commoncap.c
 F:	kernel/capability.c
@@ -1857,6 +1863,7 @@ W:	http://www.ibm.com/developerworks/pow
 S:	Supported
 F:	arch/powerpc/include/asm/cell*.h
 F:	arch/powerpc/include/asm/spu*.h
+F:	arch/powerpc/include/uapi/asm/spu*.h
 F:	arch/powerpc/oprofile/*cell*
 F:	arch/powerpc/platforms/cell/
 
@@ -1905,7 +1912,7 @@ W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 S:	Maintained
-F:	include/linux/nl80211.h
+F:	include/uapi/linux/nl80211.h
 F:	include/net/cfg80211.h
 F:	net/wireless/*
 X:	net/wireless/wext*
@@ -2008,6 +2015,7 @@ S:	Maintained
 F:	Documentation/filesystems/coda.txt
 F:	fs/coda/
 F:	include/linux/coda*.h
+F:	include/uapi/linux/coda*.h
 
 COMMON CLK FRAMEWORK
 M:	Mike Turquette <mturquette@linaro.org>
@@ -2262,6 +2270,7 @@ W:	http://www.cyclades.com/
 S:	Orphan
 F:	drivers/tty/cyclades.c
 F:	include/linux/cyclades.h
+F:	include/uapi/linux/cyclades.h
 
 CYCLADES PC300 DRIVER
 W:	http://www.cyclades.com/
@@ -2319,6 +2328,7 @@ L:	dccp@vger.kernel.org
 W:	http://www.linuxfoundation.org/collaborate/workgroups/networking/dccp
 S:	Maintained
 F:	include/linux/dccp.h
+F:	include/uapi/linux/dccp.h
 F:	include/linux/tfrc.h
 F:	net/dccp/
 
@@ -2345,7 +2355,7 @@ M:	Massimo Dal Zotto <dz@debian.org>
 W:	http://www.debian.org/~dz/i8k/
 S:	Maintained
 F:	drivers/char/i8k.c
-F:	include/linux/i8k.h
+F:	include/uapi/linux/i8k.h
 
 DELL SYSTEMS MANAGEMENT BASE DRIVER (dcdbas)
 M:	Doug Warzecha <Douglas_Warzecha@dell.com>
@@ -2418,6 +2428,7 @@ S:	Maintained
 F:	Documentation/filesystems/quota.txt
 F:	fs/quota/
 F:	include/linux/quota*.h
+F:	include/uapi/linux/quota*.h
 
 DISPLAYLINK USB 2.0 FRAMEBUFFER DRIVER (UDLFB)
 M:	Bernie Thompson <bernie@plugable.com>
@@ -2524,6 +2535,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/gpu/drm/
 F:	include/drm/
+F:	include/uapi/drm/
 
 INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
 M:	Daniel Vetter <daniel.vetter@ffwll.ch>
@@ -2533,6 +2545,7 @@ T:	git git://people.freedesktop.org/~dan
 S:	Supported
 F:	drivers/gpu/drm/i915
 F:	include/drm/i915*
+F:	include/uapi/drm/i915*
 
 DRM DRIVERS FOR EXYNOS
 M:	Inki Dae <inki.dae@samsung.com>
@@ -2544,6 +2557,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
+F:	include/uapi/drm/exynos*
 
 DRM DRIVERS FOR NVIDIA TEGRA
 M:	Thierry Reding <thierry.reding@avionic-design.de>
@@ -2718,6 +2732,7 @@ L:	netfilter-devel@vger.kernel.org
 W:	http://ebtables.sourceforge.net/
 S:	Maintained
 F:	include/linux/netfilter_bridge/ebt_*.h
+F:	include/uapi/linux/netfilter_bridge/ebt_*.h
 F:	net/bridge/netfilter/ebt*.c
 
 EC100 MEDIA DRIVER
@@ -3047,6 +3062,7 @@ M:	Eric Paris <eparis@redhat.com>
 S:	Maintained
 F:	fs/notify/fanotify/
 F:	include/linux/fanotify.h
+F:	include/uapi/linux/fanotify.h
 
 FARSYNC SYNCHRONOUS DRIVER
 M:	Kevin Curtis <kevin.curtis@farsite.co.uk>
@@ -3070,6 +3086,7 @@ F:	drivers/scsi/fcoe/
 F:	include/scsi/fc/
 F:	include/scsi/libfc.h
 F:	include/scsi/libfcoe.h
+F:	include/uapi/scsi/fc/
 
 FILE LOCKING (flock() and fcntl()/lockf())
 M:	Matthew Wilcox <matthew@wil.cx>
@@ -3077,6 +3094,8 @@ L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	include/linux/fcntl.h
 F:	include/linux/fs.h
+F:	include/uapi/linux/fcntl.h
+F:	include/uapi/linux/fs.h
 F:	fs/fcntl.c
 F:	fs/locks.c
 
@@ -3166,6 +3185,8 @@ F:	Documentation/devicetree/bindings/fb/
 F:	drivers/video/
 F:	include/video/
 F:	include/linux/fb.h
+F:	include/uapi/video/
+F:	include/uapi/linux/fb.h
 
 FREESCALE DIU FRAMEBUFFER DRIVER
 M:	Timur Tabi <timur@freescale.com>
@@ -3310,7 +3331,7 @@ L:	fuse-devel@lists.sourceforge.net
 W:	http://fuse.sourceforge.net/
 S:	Maintained
 F:	fs/fuse/
-F:	include/linux/fuse.h
+F:	include/uapi/linux/fuse.h
 
 FUTURE DOMAIN TMC-16x0 SCSI DRIVER (16-bit)
 M:	Rik Faith <faith@cs.unc.edu>
@@ -3357,6 +3378,7 @@ L:	linux-arch@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
 S:	Maintained
 F:	include/asm-generic
+F:	include/uapi/asm-generic
 
 GENERIC UIO DRIVER FOR PCI DEVICES
 M:	"Michael S. Tsirkin" <mst@redhat.com>
@@ -3373,7 +3395,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Supported
 F:	Documentation/filesystems/gfs2*.txt
 F:	fs/gfs2/
-F:	include/linux/gfs2_ondisk.h
+F:	include/uapi/linux/gfs2_ondisk.h
 
 GIGASET ISDN DRIVERS
 M:	Hansjoerg Lipp <hjlipp@web.de>
@@ -3383,7 +3405,7 @@ W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
 F:	Documentation/isdn/README.gigaset
 F:	drivers/isdn/gigaset/
-F:	include/linux/gigaset_dev.h
+F:	include/uapi/linux/gigaset_dev.h
 
 GPIO SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
@@ -3540,6 +3562,7 @@ S:	Supported
 F:	Documentation/scsi/hpsa.txt
 F:	drivers/scsi/hpsa*.[ch]
 F:	include/linux/cciss*.h
+F:	include/uapi/linux/cciss*.h
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
 M:	Mike Miller <mike.miller@hp.com>
@@ -3548,6 +3571,7 @@ S:	Supported
 F:	Documentation/blockdev/cciss.txt
 F:	drivers/block/cciss*
 F:	include/linux/cciss_ioctl.h
+F:	include/uapi/linux/cciss_ioctl.h
 
 HFS FILESYSTEM
 L:	linux-fsdevel@vger.kernel.org
@@ -3582,6 +3606,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/hid/
 F:	include/linux/hid*
+F:	include/uapi/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 M:	Thomas Gleixner <tglx@linutronix.de>
@@ -3613,7 +3638,7 @@ M:	Jes Sorensen <jes@trained-monkey.org>
 L:	linux-hippi@sunsite.dk
 S:	Maintained
 F:	include/linux/hippidevice.h
-F:	include/linux/if_hippi.h
+F:	include/uapi/linux/if_hippi.h
 F:	net/802/hippi.c
 F:	drivers/net/hippi/
 
@@ -3641,6 +3666,7 @@ S:	Maintained
 F:	Documentation/timers/hpet.txt
 F:	drivers/char/hpet.c
 F:	include/linux/hpet.h
+F:	include/uapi/linux/hpet.h
 
 HPET:	x86
 M:	"Venkatesh Pallipadi (Venki)" <venki@google.com>
@@ -3741,6 +3767,8 @@ F:	Documentation/i2c/
 F:	drivers/i2c/
 F:	include/linux/i2c.h
 F:	include/linux/i2c-*.h
+F:	include/uapi/linux/i2c.h
+F:	include/uapi/linux/i2c-*.h
 
 I2C-TAOS-EVM DRIVER
 M:	Jean Delvare <khali@linux-fr.org>
@@ -3907,7 +3935,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Supported
 F:	Documentation/infiniband/
 F:	drivers/infiniband/
-F:	include/linux/if_infiniband.h
+F:	include/uapi/linux/if_infiniband.h
 
 INOTIFY
 M:	John McCutchan <john@johnmccutchan.com>
@@ -3917,6 +3945,7 @@ S:	Maintained
 F:	Documentation/filesystems/inotify.txt
 F:	fs/notify/inotify/
 F:	include/linux/inotify.h
+F:	include/uapi/linux/inotify.h
 
 INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 M:	Dmitry Torokhov <dmitry.torokhov@gmail.com>
@@ -3927,6 +3956,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/input/
 F:	include/linux/input.h
+F:	include/uapi/linux/input.h
 F:	include/linux/input/
 
 INPUT MULTITOUCH (MT) PROTOCOL
@@ -4076,7 +4106,7 @@ S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.i2400m
 F:	drivers/net/wimax/i2400m/
-F:	include/linux/wimax/i2400m.h
+F:	include/uapi/linux/wimax/i2400m.h
 
 INTEL WIRELESS 3945ABG/BG, 4965AGN (iwlegacy)
 M:	Stanislaw Gruszka <sgruszka@redhat.com>
@@ -4098,7 +4128,7 @@ INTEL MANAGEMENT ENGINE (mei)
 M:	Tomas Winkler <tomas.winkler@intel.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
-F:	include/linux/mei.h
+F:	include/uapi/linux/mei.h
 F:	drivers/misc/mei/*
 F:	Documentation/mei/*
 
@@ -4140,6 +4170,7 @@ S:	Supported
 F:	Documentation/IPMI.txt
 F:	drivers/char/ipmi/
 F:	include/linux/ipmi*
+F:	include/uapi/linux/ipmi*
 
 IPS SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
@@ -4157,7 +4188,7 @@ L:	lvs-devel@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/ipvs-sysctl.txt
 F:	include/net/ip_vs.h
-F:	include/linux/ip_vs.h
+F:	include/uapi/linux/ip_vs.h
 F:	net/netfilter/ipvs/
 
 IPWIRELESS DRIVER
@@ -4170,8 +4201,8 @@ IPX NETWORK LAYER
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	include/linux/ipx.h
 F:	include/net/ipx.h
+F:	include/uapi/linux/ipx.h
 F:	net/ipx/
 
 IRDA SUBSYSTEM
@@ -4234,6 +4265,8 @@ F:	Documentation/isdn/
 F:	drivers/isdn/
 F:	include/linux/isdn.h
 F:	include/linux/isdn/
+F:	include/uapi/linux/isdn.h
+F:	include/uapi/linux/isdn/
 
 ISDN SUBSYSTEM (Eicon active card driver)
 M:	Armin Schindler <mac@melware.de>
@@ -4274,7 +4307,7 @@ W:	http://www.ivtvdriver.org
 S:	Maintained
 F:	Documentation/video4linux/*.ivtv
 F:	drivers/media/pci/ivtv/
-F:	include/linux/ivtv*
+F:	include/uapi/linux/ivtv*
 
 IX2505V MEDIA DRIVER
 M:	Malcolm Priestley <tvboxspy@gmail.com>
@@ -4312,7 +4345,7 @@ L:	linux-mtd@lists.infradead.org
 W:	http://www.linux-mtd.infradead.org/doc/jffs2.html
 S:	Maintained
 F:	fs/jffs2/
-F:	include/linux/jffs2.h
+F:	include/uapi/linux/jffs2.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -4395,11 +4428,13 @@ W:	http://nfs.sourceforge.net/
 S:	Supported
 F:	fs/nfsd/
 F:	include/linux/nfsd/
+F:	include/uapi/linux/nfsd/
 F:	fs/lockd/
 F:	fs/nfs_common/
 F:	net/sunrpc/
 F:	include/linux/lockd/
 F:	include/linux/sunrpc/
+F:	include/uapi/linux/sunrpc/
 
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Marcelo Tosatti <mtosatti@redhat.com>
@@ -4411,6 +4446,7 @@ F:	Documentation/*/kvm.txt
 F:	arch/*/kvm/
 F:	arch/*/include/asm/kvm*
 F:	include/linux/kvm*
+F:	include/uapi/linux/kvm*
 F:	virt/kvm/
 
 KERNEL VIRTUAL MACHINE (KVM) FOR AMD-V
@@ -4457,6 +4493,7 @@ W:	http://kernel.org/pub/linux/utils/ker
 L:	kexec@lists.infradead.org
 S:	Maintained
 F:	include/linux/kexec.h
+F:	include/uapi/linux/kexec.h
 F:	kernel/kexec.c
 
 KEYS/KEYRINGS:
@@ -4698,6 +4735,7 @@ LLC (802.2)
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Maintained
 F:	include/linux/llc.h
+F:	include/uapi/linux/llc.h
 F:	include/net/llc*
 F:	net/llc/
 
@@ -4918,7 +4956,7 @@ MATROX FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
 F:	drivers/video/matrox/matroxfb_*
-F:	include/linux/matroxfb.h
+F:	include/uapi/linux/matroxfb.h
 
 MAX16065 HARDWARE MONITOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
@@ -5000,7 +5038,7 @@ T:	git git://git.infradead.org/mtd-2.6.g
 S:	Maintained
 F:	drivers/mtd/
 F:	include/linux/mtd/
-F:	include/mtd/
+F:	include/uapi/mtd/
 
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
@@ -5082,6 +5120,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/mmc/
 F:	include/linux/mmc/
+F:	include/uapi/linux/mmc/
 
 MULTIMEDIA CARD (MMC) ETC. OVER SPI
 S:	Orphan
@@ -5182,6 +5221,8 @@ S:	Supported
 F:	include/linux/netfilter*
 F:	include/linux/netfilter/
 F:	include/net/netfilter/
+F:	include/uapi/linux/netfilter*
+F:	include/uapi/linux/netfilter/
 F:	net/*/netfilter.c
 F:	net/*/netfilter/
 F:	net/netfilter/
@@ -5200,8 +5241,8 @@ M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
-F:	include/linux/netrom.h
 F:	include/net/netrom.h
+F:	include/uapi/linux/netrom.h
 F:	net/netrom/
 
 NETWORK BLOCK DEVICE (NBD)
@@ -5210,6 +5251,7 @@ S:	Maintained
 F:	Documentation/blockdev/nbd.txt
 F:	drivers/block/nbd.c
 F:	include/linux/nbd.h
+F:	include/uapi/linux/nbd.h
 
 NETWORK DROP MONITOR
 M:	Neil Horman <nhorman@tuxdriver.com>
@@ -5231,6 +5273,9 @@ F:	include/net/
 F:	include/linux/in.h
 F:	include/linux/net.h
 F:	include/linux/netdevice.h
+F:	include/uapi/linux/in.h
+F:	include/uapi/linux/net.h
+F:	include/uapi/linux/netdevice.h
 
 NETWORKING [IPv4/IPv6]
 M:	"David S. Miller" <davem@davemloft.net>
@@ -5276,6 +5321,7 @@ F:	net/rfkill/
 F:	net/wireless/
 F:	include/net/ieee80211*
 F:	include/linux/wireless.h
+F:	include/uapi/linux/wireless.h
 F:	include/net/iw_handler.h
 F:	drivers/net/wireless/
 
@@ -5295,6 +5341,8 @@ F:	include/linux/fcdevice.h
 F:	include/linux/fddidevice.h
 F:	include/linux/hippidevice.h
 F:	include/linux/inetdevice.h
+F:	include/uapi/linux/if_*
+F:	include/uapi/linux/netdevice.h
 
 NETXEN (1/10) GbE SUPPORT
 M:	Sony Chacko <sony.chacko@qlogic.com>
@@ -5312,8 +5360,8 @@ L:	linux-wireless@vger.kernel.org
 L:	linux-nfc@lists.01.org (moderated for non-subscribers)
 S:	Maintained
 F:	net/nfc/
-F:	include/linux/nfc.h
 F:	include/net/nfc/
+F:	include/uapi/linux/nfc.h
 F:	drivers/nfc/
 F:	include/linux/platform_data/pn544.h
 
@@ -5330,6 +5378,8 @@ F:	net/sunrpc/
 F:	include/linux/lockd/
 F:	include/linux/nfs*
 F:	include/linux/sunrpc/
+F:	include/uapi/linux/nfs*
+F:	include/uapi/linux/sunrpc/
 
 NI5010 NETWORK DRIVER
 M:	Jan-Pascal van Best <janpascal@vanbest.org>
@@ -5519,6 +5569,7 @@ M:	Harald Welte <laforge@gnumonks.org>
 S:	Maintained
 F:	drivers/char/pcmcia/cm4000_cs.c
 F:	include/linux/cm4000_cs.h
+F:	include/uapi/linux/cm4000_cs.h
 
 OMNIKEY CARDMAN 4040 DRIVER
 M:	Harald Welte <laforge@gnumonks.org>
@@ -5677,7 +5728,7 @@ S:	Orphan
 F:	drivers/parport/
 F:	include/linux/parport*.h
 F:	drivers/char/ppdev.c
-F:	include/linux/ppdev.h
+F:	include/uapi/linux/ppdev.h
 
 PARAVIRT_OPS INTERFACE
 M:	Jeremy Fitzhardinge <jeremy@goop.org>
@@ -5818,6 +5869,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Supported
 F:	kernel/events/*
 F:	include/linux/perf_event.h
+F:	include/uapi/linux/perf_event.h
 F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
 F:	arch/*/kernel/*/*/perf_event*.c
@@ -5831,6 +5883,7 @@ M:	Christoph Hellwig <hch@infradead.org>
 L:	linux-abi-devel@lists.sourceforge.net
 S:	Maintained
 F:	include/linux/personality.h
+F:	include/uapi/linux/personality.h
 
 PHONET PROTOCOL
 M:	Remi Denis-Courmont <courmisch@gmail.com>
@@ -5838,6 +5891,7 @@ S:	Supported
 F:	Documentation/networking/phonet.txt
 F:	include/linux/phonet.h
 F:	include/net/phonet/
+F:	include/uapi/linux/phonet.h
 F:	net/phonet/
 
 PHRAM MTD DRIVER
@@ -5886,6 +5940,7 @@ M:	Jiri Kosina <jkosina@suse.cz>
 S:	Maintained
 F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
+F:	include/uapi/linux/pktcdvd.h
 
 PKUNITY SOC DRIVERS
 M:	Guan Xuetao <gxt@mprc.pku.edu.cn>
@@ -5960,7 +6015,7 @@ PPP OVER ATM (RFC 2364)
 M:	Mitchell Blank Jr <mitch@sfgoth.com>
 S:	Maintained
 F:	net/atm/pppoatm.c
-F:	include/linux/atmppp.h
+F:	include/uapi/linux/atmppp.h
 
 PPP OVER ETHERNET
 M:	Michal Ostrowski <mostrows@earthlink.net>
@@ -5973,6 +6028,7 @@ M:	James Chapman <jchapman@katalix.com>
 S:	Maintained
 F:	net/l2tp/l2tp_ppp.c
 F:	include/linux/if_pppol2tp.h
+F:	include/uapi/linux/if_pppol2tp.h
 
 PPS SUPPORT
 M:	Rodolfo Giometti <giometti@enneenne.com>
@@ -6070,6 +6126,7 @@ F:	include/asm-generic/syscall.h
 F:	include/linux/ptrace.h
 F:	include/linux/regset.h
 F:	include/linux/tracehook.h
+F:	include/uapi/linux/ptrace.h
 F:	kernel/ptrace.c
 
 PVRUSB2 VIDEO4LINUX DRIVER
@@ -6194,8 +6251,8 @@ M:	Anders Larsen <al@alarsen.net>
 W:	http://www.alarsen.net/linux/qnx4fs/
 S:	Maintained
 F:	fs/qnx4/
-F:	include/linux/qnx4_fs.h
-F:	include/linux/qnxtypes.h
+F:	include/uapi/linux/qnx4_fs.h
+F:	include/uapi/linux/qnxtypes.h
 
 QT1010 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
@@ -6229,7 +6286,7 @@ M:	Benjamin Herrenschmidt <benh@kernel.c
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/aty/radeon*
-F:	include/linux/radeonfb.h
+F:	include/uapi/linux/radeonfb.h
 
 RADIOSHARK RADIO DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
@@ -6330,6 +6387,7 @@ S:	Maintained
 F:	Documentation/rtc.txt
 F:	drivers/rtc/
 F:	include/linux/rtc.h
+F:	include/uapi/linux/rtc.h
 
 REISERFS FILE SYSTEM
 L:	reiserfs-devel@vger.kernel.org
@@ -6384,8 +6442,8 @@ M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
-F:	include/linux/rose.h
 F:	include/net/rose.h
+F:	include/uapi/linux/rose.h
 F:	net/rose/
 
 RTL2830 MEDIA DRIVER
@@ -6562,6 +6620,8 @@ S:	Supported
 F:	include/linux/clocksource.h
 F:	include/linux/time.h
 F:	include/linux/timex.h
+F:	include/uapi/linux/time.h
+F:	include/uapi/linux/timex.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
@@ -6586,6 +6646,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	kernel/sched/
 F:	include/linux/sched.h
+F:	include/uapi/linux/sched.h
 
 SCORE ARCHITECTURE
 M:	Chen Liqin <liqin.chen@sunplusct.com>
@@ -6739,7 +6800,7 @@ SENSABLE PHANTOM
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
 F:	drivers/misc/phantom.c
-F:	include/linux/phantom.h
+F:	include/uapi/linux/phantom.h
 
 SERIAL ATA (SATA) SUBSYSTEM
 M:	Jeff Garzik <jgarzik@pobox.com>
@@ -6997,6 +7058,7 @@ L:	linux-raid@vger.kernel.org
 S:	Supported
 F:	drivers/md/
 F:	include/linux/raid/
+F:	include/uapi/linux/raid/
 
 SONIC NETWORK DRIVER
 M:	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
@@ -7037,6 +7099,7 @@ T:	git git://git.alsa-project.org/alsa-k
 S:	Maintained
 F:	Documentation/sound/
 F:	include/sound/
+F:	include/uapi/sound/
 F:	sound/
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)
@@ -7137,6 +7200,7 @@ S:	Maintained
 F:	Documentation/spi/
 F:	drivers/spi/
 F:	include/linux/spi/
+F:	include/uapi/linux/spi/
 
 SPIDERNET NETWORK DRIVER for CELL
 M:	Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
@@ -7399,8 +7463,8 @@ TC CLASSIFIER
 M:	Jamal Hadi Salim <jhs@mojatatu.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	include/linux/pkt_cls.h
 F:	include/net/pkt_cls.h
+F:	include/uapi/linux/pkt_cls.h
 F:	net/sched/
 
 TCP LOW PRIORITY MODULE
@@ -7492,6 +7556,7 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/team/
 F:	include/linux/if_team.h
+F:	include/uapi/linux/if_team.h
 
 TECHNOTREND USB IR RECEIVER
 M:	Sean Young <sean@mess.org>
@@ -7590,7 +7655,7 @@ L:	netdev@vger.kernel.org (core kernel c
 L:	tipc-discussion@lists.sourceforge.net (user apps, general discussion)
 W:	http://tipc.sourceforge.net/
 S:	Maintained
-F:	include/linux/tipc*.h
+F:	include/uapi/linux/tipc*.h
 F:	net/tipc/
 
 TILE ARCHITECTURE
@@ -7640,6 +7705,7 @@ W:	http://www.buzzard.org.uk/toshiba/
 S:	Maintained
 F:	drivers/char/toshiba.c
 F:	include/linux/toshiba.h
+F:	include/uapi/linux/toshiba.h
 
 TMIO MMC DRIVER
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
@@ -7707,6 +7773,9 @@ F:	drivers/tty/serial/serial_core.c
 F:	include/linux/serial_core.h
 F:	include/linux/serial.h
 F:	include/linux/tty.h
+F:	include/uapi/linux/serial_core.h
+F:	include/uapi/linux/serial.h
+F:	include/uapi/linux/tty.h
 
 TUA9001 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
@@ -7786,7 +7855,7 @@ M:	David Herrmann <dh.herrmann@googlemai
 L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/hid/uhid.c
-F:	include/linux/uhid.h
+F:	include/uapi/linux/uhid.h
 
 ULTRA-WIDEBAND (UWB) SUBSYSTEM:
 L:	linux-usb@vger.kernel.org
@@ -7815,6 +7884,7 @@ S:	Maintained
 F:	Documentation/cdrom/
 F:	drivers/cdrom/cdrom.c
 F:	include/linux/cdrom.h
+F:	include/uapi/linux/cdrom.h
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
 M:	Vinayak Holikatti <vinholikatti@gmail.com>
@@ -7832,7 +7902,7 @@ T:	git git://git.infradead.org/ubi-2.6.g
 S:	Maintained
 F:	drivers/mtd/ubi/
 F:	include/linux/mtd/ubi.h
-F:	include/mtd/ubi-user.h
+F:	include/uapi/mtd/ubi-user.h
 
 UNSORTED BLOCK IMAGES (UBI) Fastmap
 M:	Richard Weinberger <richard@nod.at>
@@ -7866,7 +7936,7 @@ M:	Oliver Neukum <oliver@neukum.org>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/net/usb/cdc_*.c
-F:	include/linux/usb/cdc.h
+F:	include/uapi/linux/usb/cdc.h
 
 USB CYPRESS C67X00 DRIVER
 M:	Peter Korsgaard <jacmet@sunsite.dk>
@@ -8187,6 +8257,7 @@ S:	Maintained
 F:	Documentation/vfio.txt
 F:	drivers/vfio/
 F:	include/linux/vfio.h
+F:	include/uapi/linux/vfio.h
 
 VIDEOBUF2 FRAMEWORK
 M:	Pawel Osciak <pawel@osciak.com>
@@ -8203,6 +8274,7 @@ L:	virtualization@lists.linux-foundation
 S:	Maintained
 F:	drivers/char/virtio_console.c
 F:	include/linux/virtio_console.h
+F:	include/uapi/linux/virtio_console.h
 
 VIRTIO CORE, NET AND BLOCK DRIVERS
 M:	Rusty Russell <rusty@rustcorp.com.au>
@@ -8221,7 +8293,7 @@ L:	virtualization@lists.linux-foundation
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/vhost/
-F:	include/linux/vhost.h
+F:	include/uapi/linux/vhost.h
 
 VIA RHINE NETWORK DRIVER
 M:	Roger Luethi <rl@hellgate.ch>
@@ -8361,6 +8433,7 @@ S:	Maintained
 F:	Documentation/watchdog/
 F:	drivers/watchdog/
 F:	include/linux/watchdog.h
+F:	include/uapi/linux/watchdog.h
 
 WD7000 SCSI DRIVER
 M:	Miroslav Zagorac <zaga@fly.cc.fer.hr>
@@ -8386,9 +8459,9 @@ L:	wimax@linuxwimax.org
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.wimax
-F:	include/linux/wimax.h
 F:	include/linux/wimax/debug.h
 F:	include/net/wimax.h
+F:	include/uapi/linux/wimax.h
 F:	net/wimax/
 
 WISTRON LAPTOP BUTTON DRIVER
@@ -8506,6 +8579,7 @@ F:	drivers/*/xen-*front.c
 F:	drivers/xen/
 F:	arch/x86/include/asm/xen/
 F:	include/xen/
+F:	include/uapi/xen/
 
 XEN HYPERVISOR ARM
 M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

