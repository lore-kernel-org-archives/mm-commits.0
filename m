From: akpm@linux-foundation.org
Subject: [merged] docs-large-update-to-ioctl-numbertxt.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:17:41 -0800
Message-ID: <201001112017.o0BKHfOD025419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865Ab0AKUSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:18:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docs: large update to ioctl-number.txt
has been removed from the -mm tree.  Its filename was
     docs-large-update-to-ioctl-numbertxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docs: large update to ioctl-number.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Add many ioctl definitions to ioctl-number.txt.
Fix some whitespace/formatting.
Correct some filenames/paths.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl/ioctl-number.txt |  203 +++++++++++++++++++------
 1 file changed, 159 insertions(+), 44 deletions(-)

diff -puN Documentation/ioctl/ioctl-number.txt~docs-large-update-to-ioctl-numbertxt Documentation/ioctl/ioctl-number.txt
--- a/Documentation/ioctl/ioctl-number.txt~docs-large-update-to-ioctl-numbertxt
+++ a/Documentation/ioctl/ioctl-number.txt
@@ -56,10 +56,11 @@ Following this convention is good becaus
 (5) When following the convention, the driver code can use generic
     code to copy the parameters between user and kernel space.
 
-This table lists ioctls visible from user land for Linux/i386.  It contains
-most drivers up to 2.3.14, but I know I am missing some.
+This table lists ioctls visible from user land for Linux/x86.  It contains
+most drivers up to 2.6.31, but I know I am missing some.  There has been
+no attempt to list non-X86 architectures or ioctls from drivers/staging/.
 
-Code	Seq#	Include File		Comments
+Code  Seq#(hex)	Include File		Comments
 ========================================================
 0x00	00-1F	linux/fs.h		conflict!
 0x00	00-1F	scsi/scsi_ioctl.h	conflict!
@@ -69,119 +70,228 @@ Code	Seq#	Include File		Comments
 0x03	all	linux/hdreg.h
 0x04	D2-DC	linux/umsdos_fs.h	Dead since 2.6.11, but don't reuse these.
 0x06	all	linux/lp.h
-0x09	all	linux/md.h
+0x09	all	linux/raid/md_u.h
+0x10	00-0F	drivers/char/s390/vmcp.h
 0x12	all	linux/fs.h
 		linux/blkpg.h
 0x1b	all	InfiniBand Subsystem	<http://www.openib.org/>
 0x20	all	drivers/cdrom/cm206.h
 0x22	all	scsi/sg.h
 '#'	00-3F	IEEE 1394 Subsystem	Block for the entire subsystem
+'$'	00-0F	linux/perf_counter.h, linux/perf_event.h
 '1'	00-1F	<linux/timepps.h>	PPS kit from Ulrich Windl
 					<ftp://ftp.de.kernel.org/pub/linux/daemons/ntp/PPS/>
+'2'	01-04	linux/i2o.h
+'3'	00-0F	drivers/s390/char/raw3270.h	conflict!
+'3'	00-1F	linux/suspend_ioctls.h	conflict!
+		and kernel/power/user.c
 '8'	all				SNP8023 advanced NIC card
 					<mailto:mcr@solidum.com>
-'A'	00-1F	linux/apm_bios.h
+'@'	00-0F	linux/radeonfb.h	conflict!
+'@'	00-0F	drivers/video/aty/aty128fb.c	conflict!
+'A'	00-1F	linux/apm_bios.h	conflict!
+'A'	00-0F	linux/agpgart.h		conflict!
+		and drivers/char/agp/compat_ioctl.h
+'A'	00-7F	sound/asound.h		conflict!
+'B'	00-1F	linux/cciss_ioctl.h	conflict!
+'B'	00-0F	include/linux/pmu.h	conflict!
 'B'	C0-FF				advanced bbus
 					<mailto:maassen@uni-freiburg.de>
-'C'	all	linux/soundcard.h
+'C'	all	linux/soundcard.h	conflict!
+'C'	01-2F	linux/capi.h		conflict!
+'C'	F0-FF	drivers/net/wan/cosa.h	conflict!
 'D'	all	arch/s390/include/asm/dasd.h
-'E'	all	linux/input.h
-'F'	all	linux/fb.h
-'H'	all	linux/hiddev.h
-'I'	all	linux/isdn.h
+'D'	40-5F	drivers/scsi/dpt/dtpi_ioctl.h
+'D'	05	drivers/scsi/pmcraid.h
+'E'	all	linux/input.h		conflict!
+'E'	00-0F	xen/evtchn.h		conflict!
+'F'	all	linux/fb.h		conflict!
+'F'	01-02	drivers/scsi/pmcraid.h	conflict!
+'F'	20	drivers/video/fsl-diu-fb.h	conflict!
+'F'	20	drivers/video/intelfb/intelfb.h	conflict!
+'F'	20	linux/ivtvfb.h		conflict!
+'F'	20	linux/matroxfb.h	conflict!
+'F'	20	drivers/video/aty/atyfb_base.c	conflict!
+'F'	00-0F	video/da8xx-fb.h	conflict!
+'F'	80-8F	linux/arcfb.h		conflict!
+'F'	DD	video/sstfb.h		conflict!
+'G'	00-3F	drivers/misc/sgi-gru/grulib.h	conflict!
+'G'	00-0F	linux/gigaset_dev.h	conflict!
+'H'	00-7F	linux/hiddev.h		conflict!
+'H'	00-0F	linux/hidraw.h		conflict!
+'H'	00-0F	sound/asound.h		conflict!
+'H'	20-40	sound/asound_fm.h	conflict!
+'H'	80-8F	sound/sfnt_info.h	conflict!
+'H'	10-8F	sound/emu10k1.h		conflict!
+'H'	10-1F	sound/sb16_csp.h	conflict!
+'H'	10-1F	sound/hda_hwdep.h	conflict!
+'H'	40-4F	sound/hdspm.h		conflict!
+'H'	40-4F	sound/hdsp.h		conflict!
+'H'	90	sound/usb/usx2y/usb_stream.h
+'H'	C0-F0	net/bluetooth/hci.h	conflict!
+'H'	C0-DF	net/bluetooth/hidp/hidp.h	conflict!
+'H'	C0-DF	net/bluetooth/cmtp/cmtp.h	conflict!
+'H'	C0-DF	net/bluetooth/bnep/bnep.h	conflict!
+'I'	all	linux/isdn.h		conflict!
+'I'	00-0F	drivers/isdn/divert/isdn_divert.h	conflict!
+'I'	40-4F	linux/mISDNif.h		conflict!
 'J'	00-1F	drivers/scsi/gdth_ioctl.h
 'K'	all	linux/kd.h
-'L'	00-1F	linux/loop.h
-'L'	20-2F	driver/usb/misc/vstusb.h
+'L'	00-1F	linux/loop.h		conflict!
+'L'	10-1F	drivers/scsi/mpt2sas/mpt2sas_ctl.h	conflict!
+'L'	20-2F	linux/usb/vstusb.h
 'L'	E0-FF	linux/ppdd.h		encrypted disk device driver
 					<http://linux01.gwdg.de/~alatham/ppdd.html>
-'M'	all	linux/soundcard.h
+'M'	all	linux/soundcard.h	conflict!
+'M'	01-16	mtd/mtd-abi.h		conflict!
+		and drivers/mtd/mtdchar.c
+'M'	01-03	drivers/scsi/megaraid/megaraid_sas.h
+'M'	00-0F	drivers/video/fsl-diu-fb.h	conflict!
 'N'	00-1F	drivers/usb/scanner.h
-'O'     00-02   include/mtd/ubi-user.h UBI
-'P'	all	linux/soundcard.h
+'O'     00-06   mtd/ubi-user.h		UBI
+'P'	all	linux/soundcard.h	conflict!
+'P'	60-6F	sound/sscape_ioctl.h	conflict!
+'P'	00-0F	drivers/usb/class/usblp.c	conflict!
 'Q'	all	linux/soundcard.h
-'R'	00-1F	linux/random.h
+'R'	00-1F	linux/random.h		conflict!
+'R'	01	linux/rfkill.h		conflict!
+'R'	01-0F	media/rds.h		conflict!
+'R'	C0-DF	net/bluetooth/rfcomm.h
 'S'	all	linux/cdrom.h		conflict!
 'S'	80-81	scsi/scsi_ioctl.h	conflict!
 'S'	82-FF	scsi/scsi.h		conflict!
+'S'	00-7F	sound/asequencer.h	conflict!
 'T'	all	linux/soundcard.h	conflict!
+'T'	00-AF	sound/asound.h		conflict!
 'T'	all	arch/x86/include/asm/ioctls.h	conflict!
-'U'	00-EF	linux/drivers/usb/usb.h
-'V'	all	linux/vt.h
+'T'	C0-DF	linux/if_tun.h		conflict!
+'U'	all	sound/asound.h		conflict!
+'U'	00-0F	drivers/media/video/uvc/uvcvideo.h	conflict!
+'U'	00-CF	linux/uinput.h		conflict!
+'U'	00-EF	linux/usbdevice_fs.h
+'U'	C0-CF	drivers/bluetooth/hci_uart.h
+'V'	all	linux/vt.h		conflict!
+'V'	all	linux/videodev2.h	conflict!
+'V'	C0	linux/ivtvfb.h		conflict!
+'V'	C0	linux/ivtv.h		conflict!
+'V'	C0	media/davinci/vpfe_capture.h	conflict!
+'V'	C0	media/si4713.h		conflict!
+'V'	C0-CF	drivers/media/video/mxb.h	conflict!
 'W'	00-1F	linux/watchdog.h	conflict!
 'W'	00-1F	linux/wanrouter.h	conflict!
-'X'	all	linux/xfs_fs.h
+'W'	00-3F	sound/asound.h		conflict!
+'X'	all	fs/xfs/xfs_fs.h		conflict!
+		and fs/xfs/linux-2.6/xfs_ioctl32.h
+		and include/linux/falloc.h
+		and linux/fs.h
+'X'	all	fs/ocfs2/ocfs_fs.h	conflict!
+'X'	01	linux/pktcdvd.h		conflict!
 'Y'	all	linux/cyclades.h
-'['	00-07	linux/usb/usbtmc.h	USB Test and Measurement Devices
+'Z'	14-15	drivers/message/fusion/mptctl.h
+'['	00-07	linux/usb/tmc.h		USB Test and Measurement Devices
 					<mailto:gregkh@suse.de>
-'a'	all				ATM on linux
+'a'	all	linux/atm*.h, linux/sonet.h	ATM on linux
 					<http://lrcwww.epfl.ch/linux-atm/magic.html>
-'b'	00-FF				bit3 vme host bridge
+'b'	00-FF				conflict! bit3 vme host bridge
 					<mailto:natalia@nikhefk.nikhef.nl>
+'b'	00-0F	media/bt819.h		conflict!
+'c'	all	linux/cm4000_cs.h	conflict!
 'c'	00-7F	linux/comstats.h	conflict!
 'c'	00-7F	linux/coda.h		conflict!
-'c'	80-9F	arch/s390/include/asm/chsc.h
-'c'	A0-AF   arch/x86/include/asm/msr.h
+'c'	00-1F	linux/chio.h		conflict!
+'c'	80-9F	arch/s390/include/asm/chsc.h	conflict!
+'c'	A0-AF   arch/x86/include/asm/msr.h	conflict!
 'd'	00-FF	linux/char/drm/drm/h	conflict!
+'d'	02-40	pcmcia/ds.h		conflict!
+'d'	10-3F	drivers/media/video/dabusb.h	conflict!
+'d'	C0-CF	drivers/media/video/saa7191.h	conflict!
 'd'	F0-FF	linux/digi1.h
 'e'	all	linux/digi1.h		conflict!
-'e'	00-1F	net/irda/irtty.h	conflict!
-'f'	00-1F	linux/ext2_fs.h
-'h'	00-7F				Charon filesystem
+'e'	00-1F	drivers/net/irda/irtty-sir.h	conflict!
+'f'	00-1F	linux/ext2_fs.h		conflict!
+'f'	00-1F	linux/ext3_fs.h		conflict!
+'f'	00-0F	fs/jfs/jfs_dinode.h	conflict!
+'f'	00-0F	fs/ext4/ext4.h		conflict!
+'f'	00-0F	linux/fs.h		conflict!
+'f'	00-0F	fs/ocfs2/ocfs2_fs.h	conflict!
+'g'	00-0F	linux/usb/gadgetfs.h
+'g'	20-2F	linux/usb/g_printer.h
+'h'	00-7F				conflict! Charon filesystem
 					<mailto:zapman@interlan.net>
-'i'	00-3F	linux/i2o.h
+'h'	00-1F	linux/hpet.h		conflict!
+'i'	00-3F	linux/i2o-dev.h		conflict!
+'i'	0B-1F	linux/ipmi.h		conflict!
+'i'	80-8F	linux/i8k.h
 'j'	00-3F	linux/joystick.h
+'k'	00-0F	linux/spi/spidev.h	conflict!
+'k'	00-05	video/kyro.h		conflict!
 'l'	00-3F	linux/tcfs_fs.h		transparent cryptographic file system
 					<http://mikonos.dia.unisa.it/tcfs>
 'l'	40-7F	linux/udf_fs_i.h	in development:
 					<http://sourceforge.net/projects/linux-udf/>
-'m'	00-09	linux/mmtimer.h
+'m'	00-09	linux/mmtimer.h		conflict!
 'm'	all	linux/mtio.h		conflict!
 'm'	all	linux/soundcard.h	conflict!
 'm'	all	linux/synclink.h	conflict!
+'m'	00-19	drivers/message/fusion/mptctl.h	conflict!
+'m'	00	drivers/scsi/megaraid/megaraid_ioctl.h	conflict!
 'm'	00-1F	net/irda/irmod.h	conflict!
-'n'	00-7F	linux/ncp_fs.h
+'n'	00-7F	linux/ncp_fs.h and fs/ncpfs/ioctl.c
 'n'	80-8F	linux/nilfs2_fs.h	NILFS2
-'n'	E0-FF	video/matrox.h          matroxfb
+'n'	E0-FF	linux/matroxfb.h	matroxfb
 'o'	00-1F	fs/ocfs2/ocfs2_fs.h	OCFS2
-'o'     00-03   include/mtd/ubi-user.h  conflict! (OCFS2 and UBI overlaps)
-'o'     40-41   include/mtd/ubi-user.h  UBI
-'o'     01-A1   include/linux/dvb/*.h DVB
+'o'     00-03   mtd/ubi-user.h		conflict! (OCFS2 and UBI overlaps)
+'o'     40-41   mtd/ubi-user.h		UBI
+'o'     01-A1   linux/dvb/*.h		DVB
 'p'	00-0F	linux/phantom.h		conflict! (OpenHaptics needs this)
+'p'	00-1F	linux/rtc.h		conflict!
 'p'	00-3F	linux/mc146818rtc.h	conflict!
 'p'	40-7F	linux/nvram.h
-'p'	80-9F				user-space parport
+'p'	80-9F	linux/ppdev.h		user-space parport
 					<mailto:tim@cyberelk.net>
-'p'	a1-a4	linux/pps.h		LinuxPPS
+'p'	A1-A4	linux/pps.h		LinuxPPS
 					<mailto:giometti@linux.it>
 'q'	00-1F	linux/serio.h
-'q'	80-FF				Internet PhoneJACK, Internet LineJACK
-					<http://www.quicknet.net>
-'r'	00-1F	linux/msdos_fs.h
+'q'	80-FF	linux/telephony.h	Internet PhoneJACK, Internet LineJACK
+		linux/ixjuser.h		<http://www.quicknet.net>
+'r'	00-1F	linux/msdos_fs.h and fs/fat/dir.c
 's'	all	linux/cdk.h
 't'	00-7F	linux/if_ppp.h
 't'	80-8F	linux/isdn_ppp.h
+'t'	90	linux/toshiba.h
 'u'	00-1F	linux/smb_fs.h
-'v'	00-1F	linux/ext2_fs.h		conflict!
 'v'	all	linux/videodev.h	conflict!
+'v'	00-1F	linux/ext2_fs.h		conflict!
+'v'	00-1F	linux/fs.h		conflict!
+'v'	00-0F	linux/sonypi.h		conflict!
+'v'	C0-CF	drivers/media/video/ov511.h	conflict!
+'v'	C0-DF	media/pwc-ioctl.h	conflict!
+'v'	C0-FF	linux/meye.h		conflict!
+'v'	C0-CF	drivers/media/video/zoran/zoran.h	conflict!
+'v'	D0-DF	drivers/media/video/cpia2/cpia2dev.h	conflict!
 'w'	all				CERN SCI driver
 'y'	00-1F				packet based user level communications
 					<mailto:zapman@interlan.net>
-'z'	00-3F				CAN bus card
+'z'	00-3F				CAN bus card	conflict!
 					<mailto:hdstich@connectu.ulm.circular.de>
-'z'	40-7F				CAN bus card
+'z'	40-7F				CAN bus card	conflict!
 					<mailto:oe@port.de>
+'z'	10-4F	drivers/s390/crypto/zcrypt_api.h	conflict!
 0x80	00-1F	linux/fb.h
 0x81	00-1F	linux/videotext.h
+0x88	00-3F	media/ovcamchip.h
 0x89	00-06	arch/x86/include/asm/sockios.h
 0x89	0B-DF	linux/sockios.h
 0x89	E0-EF	linux/sockios.h		SIOCPROTOPRIVATE range
+0x89	E0-EF	linux/dn.h		PROTOPRIVATE range
 0x89	F0-FF	linux/sockios.h		SIOCDEVPRIVATE range
 0x8B	all	linux/wireless.h
 0x8C	00-3F				WiNRADiO driver
 					<http://www.proximity.com.au/~brian/winradio/>
 0x90	00	drivers/cdrom/sbpcd.h
+0x92	00-0F	drivers/usb/mon/mon_bin.c
 0x93	60-7F	linux/auto_fs.h
+0x94	all	fs/btrfs/ioctl.h
 0x99	00-0F				537-Addinboard driver
 					<mailto:buk@buks.ipn.de>
 0xA0	all	linux/sdp/sdp.h		Industrial Device Project
@@ -192,17 +302,22 @@ Code	Seq#	Include File		Comments
 0xAB	00-1F	linux/nbd.h
 0xAC	00-1F	linux/raw.h
 0xAD	00	Netfilter device	in development:
-					<mailto:rusty@rustcorp.com.au>	
+					<mailto:rusty@rustcorp.com.au>
 0xAE	all	linux/kvm.h		Kernel-based Virtual Machine
 					<mailto:kvm@vger.kernel.org>
 0xB0	all	RATIO devices		in development:
 					<mailto:vgo@ratio.de>
 0xB1	00-1F	PPPoX			<mailto:mostrows@styx.uwaterloo.ca>
+0xC0	00-0F	linux/usb/iowarrior.h
 0xCB	00-1F	CBM serial IEC bus	in development:
 					<mailto:michael.klein@puffin.lb.shuttle.de>
+0xCD	01	linux/reiserfs_fs.h
+0xCF	02	fs/cifs/ioctl.c
+0xDB	00-0F	drivers/char/mwave/mwavepub.h
 0xDD	00-3F	ZFCP device driver	see drivers/s390/scsi/
 					<mailto:aherrman@de.ibm.com>
-0xF3	00-3F	video/sisfb.h		sisfb (in development)
+0xF3	00-3F	drivers/usb/misc/sisusbvga/sisusb.h	sisfb (in development)
 					<mailto:thomas@winischhofer.net>
 0xF4	00-1F	video/mbxfb.h		mbxfb
 					<mailto:raph@8d.com>
+0xFD	all	linux/dm-ioctl.h
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfgpt-move-clocksource-menu.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

