From: akpm@osdl.org
Subject: + remove-555-unneeded-includes-of-schedh.patch added to -mm tree
Date: Tue, 02 Jan 2007 12:54:20 -0800
Message-ID: <200701022054.l02KsLp6029330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59858 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbXABUzB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 15:55:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim@physik3.uni-rostock.de


The patch titled
     remove 555 unneeded #includes of sched.h
has been added to the -mm tree.  Its filename is
     remove-555-unneeded-includes-of-schedh.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove 555 unneeded #includes of sched.h
From: Tim Schmielau <tim@physik3.uni-rostock.de>

After Al Viro (finally) succeeded in removing the sched.h #include in module.h
recently, it makes sense again to remove other superfluous sched.h includes. 
There are quite a lot of files which include it but don't actually need
anything defined in there.  Presumably these includes were once needed for
macros that used to live in sched.h, but moved to other header files in the
course of cleaning it up.

To ease the pain, this time I did not fiddle with any header files and only
removed #includes from .c-files, which tend to cause less trouble.

Compile tested against 2.6.20-rc2 and 2.6.20-rc2-mm2 (with offsets) on alpha,
arm, i386, ia64, mips, powerpc, and x86_64 with allnoconfig, defconfig,
allmodconfig, and allyesconfig as well as a few randconfigs on x86_64 and all
configs in arch/arm/configs on arm.  I also checked that no new warnings were
introduced by the patch (actually, some warnings are removed that were emitted
by unnecessarily included header files).

Signed-off-by: Tim Schmielau <tim@physik3.uni-rostock.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acorn/block/mfmhd.c                     |    1 -
 drivers/acorn/char/i2c.c                        |    1 -
 drivers/acpi/i2c_ec.c                           |    1 -
 drivers/acpi/sleep/poweroff.c                   |    1 -
 drivers/acpi/tables.c                           |    1 -
 drivers/acpi/thermal.c                          |    3 ++-
 drivers/ata/ahci.c                              |    1 -
 drivers/ata/pdc_adma.c                          |    1 -
 drivers/ata/sata_mv.c                           |    1 -
 drivers/ata/sata_promise.c                      |    1 -
 drivers/ata/sata_qstor.c                        |    1 -
 drivers/ata/sata_sx4.c                          |    1 -
 drivers/atm/adummy.c                            |    1 -
 drivers/atm/fore200e.c                          |    1 -
 drivers/atm/idt77105.c                          |    1 -
 drivers/atm/uPD98402.c                          |    1 -
 drivers/atm/zatm.c                              |    1 -
 drivers/block/acsi.c                            |    1 -
 drivers/block/paride/pd.c                       |    1 -
 drivers/block/umem.c                            |    1 -
 drivers/bluetooth/bfusb.c                       |    1 -
 drivers/bluetooth/bt3c_cs.c                     |    1 -
 drivers/bluetooth/btuart_cs.c                   |    1 -
 drivers/bluetooth/dtl1_cs.c                     |    1 -
 drivers/bluetooth/hci_bcsp.c                    |    1 -
 drivers/bluetooth/hci_h4.c                      |    1 -
 drivers/bluetooth/hci_ldisc.c                   |    1 -
 drivers/bluetooth/hci_usb.c                     |    1 -
 drivers/cdrom/aztcd.c                           |    1 -
 drivers/cdrom/cm206.c                           |    1 -
 drivers/cdrom/gscd.c                            |    1 -
 drivers/cdrom/sjcd.c                            |    1 -
 drivers/char/briq_panel.c                       |    1 -
 drivers/char/drm/ffb_context.c                  |    1 -
 drivers/char/drm/ffb_drv.c                      |    1 -
 drivers/char/ds1620.c                           |    1 -
 drivers/char/dsp56k.c                           |    1 -
 drivers/char/hvsi.c                             |    1 -
 drivers/char/ipmi/ipmi_devintf.c                |    1 -
 drivers/char/ipmi/ipmi_msghandler.c             |    1 -
 drivers/char/nvram.c                            |    1 -
 drivers/char/nwflash.c                          |    1 -
 drivers/char/pty.c                              |    1 -
 drivers/char/scan_keyb.c                        |    1 -
 drivers/char/ser_a2232.c                        |    1 -
 drivers/char/sonypi.c                           |    1 -
 drivers/char/tlclk.c                            |    1 -
 drivers/char/toshiba.c                          |    1 -
 drivers/char/tpm/tpm.c                          |    1 -
 drivers/char/vc_screen.c                        |    1 -
 drivers/char/vme_scc.c                          |    1 -
 drivers/cpufreq/cpufreq_conservative.c          |    1 -
 drivers/crypto/geode-aes.c                      |    1 -
 drivers/fc4/fc_syms.c                           |    1 -
 drivers/fc4/soc.c                               |    1 -
 drivers/fc4/socal.c                             |    1 -
 drivers/hid/hid-core.c                          |    1 -
 drivers/i2c/busses/i2c-ali1535.c                |    1 -
 drivers/i2c/busses/i2c-ali15x3.c                |    1 -
 drivers/i2c/busses/i2c-amd756.c                 |    1 -
 drivers/i2c/busses/i2c-amd8111.c                |    1 -
 drivers/i2c/busses/i2c-i801.c                   |    1 -
 drivers/i2c/busses/i2c-iop3xx.c                 |    1 -
 drivers/i2c/busses/i2c-nforce2.c                |    1 -
 drivers/i2c/busses/i2c-ocores.c                 |    1 -
 drivers/i2c/busses/i2c-piix4.c                  |    1 -
 drivers/i2c/busses/i2c-s3c2410.c                |    1 -
 drivers/i2c/busses/i2c-sis96x.c                 |    1 -
 drivers/i2c/chips/eeprom.c                      |    1 -
 drivers/ide/ide-proc.c                          |    1 -
 drivers/ide/legacy/ide-cs.c                     |    1 -
 drivers/ide/ppc/mpc8xx.c                        |    1 -
 drivers/ide/ppc/pmac.c                          |    1 -
 drivers/ieee1394/eth1394.c                      |    1 -
 drivers/ieee1394/iso.c                          |    1 -
 drivers/ieee1394/ohci1394.c                     |    1 -
 drivers/infiniband/core/cache.c                 |    1 -
 drivers/input/ff-memless.c                      |    2 +-
 drivers/input/input.c                           |    1 -
 drivers/input/mouse/rpcmouse.c                  |    1 -
 drivers/input/serio/hil_mlc.c                   |    1 -
 drivers/input/serio/hp_sdc.c                    |    1 -
 drivers/isdn/capi/capidrv.c                     |    1 -
 drivers/isdn/hardware/avm/avm_cs.c              |    1 -
 drivers/isdn/hardware/eicon/divamnt.c           |    1 -
 drivers/isdn/hardware/eicon/divasmain.c         |    1 -
 drivers/isdn/hisax/avma1_cs.c                   |    1 -
 drivers/isdn/hisax/elsa_cs.c                    |    1 -
 drivers/isdn/hisax/hfc_usb.c                    |    1 -
 drivers/isdn/hisax/sedlbauer_cs.c               |    1 -
 drivers/isdn/hisax/teles_cs.c                   |    1 -
 drivers/isdn/hysdn/boardergo.c                  |    1 -
 drivers/isdn/hysdn/hysdn_sched.c                |    1 -
 drivers/isdn/i4l/isdn_bsdcomp.c                 |    1 -
 drivers/isdn/pcbit/callbacks.c                  |    1 -
 drivers/isdn/pcbit/capi.c                       |    1 -
 drivers/isdn/pcbit/drv.c                        |    1 -
 drivers/isdn/pcbit/edss1.c                      |    1 -
 drivers/isdn/pcbit/layer2.c                     |    1 -
 drivers/isdn/pcbit/module.c                     |    1 -
 drivers/macintosh/macio-adb.c                   |    1 -
 drivers/macintosh/via-cuda.c                    |    1 -
 drivers/macintosh/via-macii.c                   |    1 -
 drivers/macintosh/via-maciisi.c                 |    1 -
 drivers/macintosh/via-pmu68k.c                  |    1 -
 drivers/media/dvb/dvb-core/dmxdev.c             |    1 -
 drivers/media/dvb/dvb-core/dvbdev.c             |    1 -
 drivers/media/dvb/ttpci/av7110_av.c             |    1 -
 drivers/media/dvb/ttpci/av7110_ca.c             |    1 -
 drivers/media/dvb/ttpci/av7110_hw.c             |    1 -
 drivers/media/dvb/ttpci/av7110_v4l.c            |    1 -
 drivers/media/radio/miropcm20-rds.c             |    1 -
 drivers/media/radio/radio-maestro.c             |    1 -
 drivers/media/radio/radio-maxiradio.c           |    1 -
 drivers/media/video/adv7170.c                   |    1 -
 drivers/media/video/adv7175.c                   |    1 -
 drivers/media/video/bt819.c                     |    1 -
 drivers/media/video/bt856.c                     |    1 -
 drivers/media/video/bt8xx/bttv-vbi.c            |    1 -
 drivers/media/video/cx88/cx88-tvaudio.c         |    1 -
 drivers/media/video/em28xx/em28xx-input.c       |    1 -
 drivers/media/video/indycam.c                   |    1 -
 drivers/media/video/ir-kbd-i2c.c                |    1 -
 drivers/media/video/meye.c                      |    1 -
 drivers/media/video/pms.c                       |    1 -
 drivers/media/video/saa5246a.c                  |    1 -
 drivers/media/video/saa7111.c                   |    1 -
 drivers/media/video/saa7114.c                   |    1 -
 drivers/media/video/saa711x.c                   |    1 -
 drivers/media/video/saa7134/saa6752hs.c         |    1 -
 drivers/media/video/saa7134/saa7134-input.c     |    1 -
 drivers/media/video/saa7185.c                   |    1 -
 drivers/media/video/saa7191.c                   |    1 -
 drivers/media/video/tda7432.c                   |    1 -
 drivers/media/video/tda9875.c                   |    1 -
 drivers/media/video/tuner-core.c                |    1 -
 drivers/media/video/tvmixer.c                   |    1 -
 drivers/media/video/usbvideo/ibmcam.c           |    1 -
 drivers/media/video/usbvideo/ultracam.c         |    1 -
 drivers/media/video/usbvision/usbvision-core.c  |    1 -
 drivers/media/video/usbvision/usbvision-i2c.c   |    1 -
 drivers/media/video/usbvision/usbvision-video.c |    1 -
 drivers/media/video/v4l2-common.c               |    1 -
 drivers/media/video/videodev.c                  |    1 -
 drivers/message/fusion/mptfc.c                  |    1 -
 drivers/message/fusion/mptsas.c                 |    2 +-
 drivers/message/fusion/mptscsih.c               |    1 -
 drivers/message/fusion/mptspi.c                 |    1 -
 drivers/mmc/mmc_block.c                         |    1 -
 drivers/mtd/chips/cfi_util.c                    |    1 -
 drivers/mtd/devices/doc2001.c                   |    1 -
 drivers/mtd/devices/doc2001plus.c               |    1 -
 drivers/mtd/devices/docecc.c                    |    1 -
 drivers/mtd/devices/pmc551.c                    |    1 -
 drivers/mtd/devices/slram.c                     |    1 -
 drivers/mtd/ftl.c                               |    1 -
 drivers/mtd/inftlmount.c                        |    1 -
 drivers/mtd/mtdcore.c                           |    1 -
 drivers/mtd/nftlcore.c                          |    1 -
 drivers/net/arm/ether1.c                        |    1 -
 drivers/net/arm/ether3.c                        |    1 -
 drivers/net/arm/etherh.c                        |    1 -
 drivers/net/au1000_eth.c                        |    1 -
 drivers/net/bonding/bond_main.c                 |    1 -
 drivers/net/bonding/bond_sysfs.c                |    1 -
 drivers/net/cris/eth_v10.c                      |    1 -
 drivers/net/fec_8xx/fec_8xx-netta.c             |    1 -
 drivers/net/fec_8xx/fec_main.c                  |    1 -
 drivers/net/fec_8xx/fec_mii.c                   |    1 -
 drivers/net/fs_enet/fs_enet-main.c              |    1 -
 drivers/net/fs_enet/mac-fcc.c                   |    1 -
 drivers/net/fs_enet/mac-fec.c                   |    1 -
 drivers/net/fs_enet/mac-scc.c                   |    1 -
 drivers/net/fs_enet/mii-bitbang.c               |    1 -
 drivers/net/fs_enet/mii-fec.c                   |    1 -
 drivers/net/gianfar.c                           |    1 -
 drivers/net/gianfar_ethtool.c                   |    1 -
 drivers/net/gianfar_mii.c                       |    1 -
 drivers/net/gianfar_sysfs.c                     |    1 -
 drivers/net/ibm_emac/ibm_emac_core.c            |    1 -
 drivers/net/irda/ma600-sir.c                    |    1 -
 drivers/net/meth.c                              |    1 -
 drivers/net/mipsnet.c                           |    1 -
 drivers/net/phy/cicada.c                        |    1 -
 drivers/net/phy/davicom.c                       |    1 -
 drivers/net/phy/fixed.c                         |    1 -
 drivers/net/phy/lxt.c                           |    1 -
 drivers/net/phy/marvell.c                       |    1 -
 drivers/net/phy/mdio_bus.c                      |    1 -
 drivers/net/phy/phy.c                           |    1 -
 drivers/net/phy/phy_device.c                    |    1 -
 drivers/net/phy/qsemi.c                         |    1 -
 drivers/net/qla3xxx.c                           |    1 -
 drivers/net/s2io.c                              |    1 -
 drivers/net/sungem_phy.c                        |    1 -
 drivers/net/tsi108_eth.c                        |    1 -
 drivers/net/ucc_geth_phy.c                      |    1 -
 drivers/net/wan/cycx_drv.c                      |    1 -
 drivers/net/wan/pci200syn.c                     |    1 -
 drivers/net/wireless/atmel.c                    |    1 -
 drivers/net/wireless/bcm43xx/bcm43xx_wx.c       |    1 -
 drivers/parisc/eisa.c                           |    1 -
 drivers/parport/parport_cs.c                    |    1 -
 drivers/parport/parport_gsc.c                   |    1 -
 drivers/pci/hotplug/ibmphp_ebda.c               |    1 -
 drivers/pci/syscall.c                           |    1 -
 drivers/pcmcia/at91_cf.c                        |    1 -
 drivers/pcmcia/cistpl.c                         |    1 -
 drivers/pcmcia/i82365.c                         |    1 -
 drivers/pcmcia/m32r_cfc.c                       |    1 -
 drivers/pcmcia/m32r_pcc.c                       |    1 -
 drivers/pcmcia/m8xx_pcmcia.c                    |    1 -
 drivers/pcmcia/omap_cf.c                        |    1 -
 drivers/pcmcia/pxa2xx_lubbock.c                 |    1 -
 drivers/pcmcia/sa1100_badge4.c                  |    1 -
 drivers/pcmcia/sa1100_cerf.c                    |    1 -
 drivers/pcmcia/sa1100_h3600.c                   |    1 -
 drivers/pcmcia/sa1100_jornada720.c              |    1 -
 drivers/pcmcia/sa1100_neponset.c                |    1 -
 drivers/pcmcia/sa1100_shannon.c                 |    1 -
 drivers/pcmcia/sa1100_simpad.c                  |    1 -
 drivers/pcmcia/vrc4171_card.c                   |    1 -
 drivers/pcmcia/yenta_socket.c                   |    1 -
 drivers/rapidio/rio-sysfs.c                     |    1 -
 drivers/s390/char/sclp_tty.c                    |    1 -
 drivers/s390/char/sclp_vt220.c                  |    1 -
 drivers/s390/net/ctcmain.c                      |    1 -
 drivers/s390/net/netiucv.c                      |    1 -
 drivers/sbus/char/cpwatchdog.c                  |    1 -
 drivers/sbus/char/openprom.c                    |    1 -
 drivers/sbus/char/uctrl.c                       |    1 -
 drivers/sbus/char/vfc_dev.c                     |    1 -
 drivers/scsi/53c700.c                           |    1 -
 drivers/scsi/NCR53c406a.c                       |    1 -
 drivers/scsi/a2091.c                            |    1 -
 drivers/scsi/a3000.c                            |    1 -
 drivers/scsi/aacraid/aachba.c                   |    1 -
 drivers/scsi/aacraid/commctrl.c                 |    1 -
 drivers/scsi/aacraid/comminit.c                 |    1 -
 drivers/scsi/aacraid/dpcsup.c                   |    1 -
 drivers/scsi/aacraid/rx.c                       |    1 -
 drivers/scsi/aacraid/sa.c                       |    1 -
 drivers/scsi/aha152x.c                          |    1 -
 drivers/scsi/aic7xxx_old.c                      |    1 -
 drivers/scsi/amiga7xx.c                         |    1 -
 drivers/scsi/arm/acornscsi.c                    |    1 -
 drivers/scsi/arm/arxescsi.c                     |    1 -
 drivers/scsi/arm/cumana_1.c                     |    1 -
 drivers/scsi/arm/cumana_2.c                     |    1 -
 drivers/scsi/arm/ecoscsi.c                      |    1 -
 drivers/scsi/arm/eesox.c                        |    1 -
 drivers/scsi/arm/fas216.c                       |    1 -
 drivers/scsi/arm/oak.c                          |    1 -
 drivers/scsi/arm/powertec.c                     |    1 -
 drivers/scsi/atari_scsi.c                       |    1 -
 drivers/scsi/bvme6000.c                         |    1 -
 drivers/scsi/ch.c                               |    1 -
 drivers/scsi/dtc.c                              |    1 -
 drivers/scsi/eata_pio.c                         |    1 -
 drivers/scsi/g_NCR5380.c                        |    1 -
 drivers/scsi/gdth.c                             |    1 -
 drivers/scsi/gvp11.c                            |    1 -
 drivers/scsi/initio.c                           |    1 -
 drivers/scsi/lasi700.c                          |    1 -
 drivers/scsi/mac_scsi.c                         |    1 -
 drivers/scsi/mvme147.c                          |    1 -
 drivers/scsi/mvme16x.c                          |    1 -
 drivers/scsi/nsp32.c                            |    1 -
 drivers/scsi/pas16.c                            |    1 -
 drivers/scsi/pcmcia/aha152x_stub.c              |    1 -
 drivers/scsi/pcmcia/fdomain_stub.c              |    1 -
 drivers/scsi/pcmcia/nsp_cs.c                    |    1 -
 drivers/scsi/pcmcia/qlogic_stub.c               |    1 -
 drivers/scsi/pcmcia/sym53c500_cs.c              |    1 -
 drivers/scsi/qla1280.c                          |    1 -
 drivers/scsi/scsi.c                             |    1 -
 drivers/scsi/scsi_debug.c                       |    1 -
 drivers/scsi/scsi_transport_fc.c                |    1 -
 drivers/scsi/sd.c                               |    1 -
 drivers/scsi/sr.c                               |    1 -
 drivers/scsi/sr_ioctl.c                         |    1 -
 drivers/scsi/stex.c                             |    1 -
 drivers/scsi/sun3_scsi.c                        |    1 -
 drivers/scsi/sun3_scsi_vme.c                    |    1 -
 drivers/scsi/sym53c416.c                        |    1 -
 drivers/scsi/t128.c                             |    1 -
 drivers/scsi/tmscsim.c                          |    1 -
 drivers/scsi/wd33c93.c                          |    1 -
 drivers/serial/8250_pci.c                       |    1 -
 drivers/serial/icom.c                           |    1 -
 drivers/serial/ip22zilog.c                      |    1 -
 drivers/serial/serial_cs.c                      |    1 -
 drivers/serial/sunsab.c                         |    1 -
 drivers/serial/sunsu.c                          |    1 -
 drivers/serial/sunzilog.c                       |    1 -
 drivers/tc/lk201.c                              |    1 -
 drivers/telephony/ixj_pcmcia.c                  |    1 -
 drivers/usb/gadget/at91_udc.c                   |    1 -
 drivers/usb/gadget/dummy_hcd.c                  |    1 -
 drivers/usb/gadget/ether.c                      |    1 -
 drivers/usb/gadget/goku_udc.c                   |    1 -
 drivers/usb/gadget/net2280.c                    |    1 -
 drivers/usb/gadget/omap_udc.c                   |    1 -
 drivers/usb/gadget/pxa2xx_udc.c                 |    1 -
 drivers/usb/gadget/serial.c                     |    1 -
 drivers/usb/gadget/zero.c                       |    1 -
 drivers/usb/host/hc_crisv10.c                   |    1 -
 drivers/usb/host/sl811_cs.c                     |    1 -
 drivers/usb/host/uhci-hcd.c                     |    1 -
 drivers/usb/image/microtek.c                    |    1 -
 drivers/usb/input/aiptek.c                      |    1 -
 drivers/usb/input/hid-core.c                    |    1 -
 drivers/usb/input/hid-pidff.c                   |    1 -
 drivers/usb/misc/sisusbvga/sisusb.c             |    1 -
 drivers/usb/misc/sisusbvga/sisusb_con.c         |    1 -
 drivers/usb/net/asix.c                          |    1 -
 drivers/usb/net/cdc_ether.c                     |    1 -
 drivers/usb/net/cdc_subset.c                    |    1 -
 drivers/usb/net/gl620a.c                        |    1 -
 drivers/usb/net/kaweth.c                        |    1 -
 drivers/usb/net/net1080.c                       |    1 -
 drivers/usb/net/plusb.c                         |    1 -
 drivers/usb/net/rndis_host.c                    |    1 -
 drivers/usb/net/rtl8150.c                       |    1 -
 drivers/usb/net/usbnet.c                        |    1 -
 drivers/usb/net/zaurus.c                        |    1 -
 drivers/usb/storage/datafab.c                   |    1 -
 drivers/usb/storage/initializers.c              |    1 -
 drivers/usb/storage/jumpshot.c                  |    1 -
 drivers/usb/storage/sddr09.c                    |    1 -
 drivers/usb/storage/shuttle_usbat.c             |    1 -
 drivers/video/atafb.c                           |    1 -
 drivers/video/aty/mach64_accel.c                |    1 -
 drivers/video/aty/mach64_gx.c                   |    1 -
 drivers/video/aty/radeon_i2c.c                  |    1 -
 drivers/video/console/fbcon.c                   |    1 -
 drivers/video/console/mdacon.c                  |    1 -
 drivers/video/console/vgacon.c                  |    1 -
 drivers/video/fbmem.c                           |    1 -
 drivers/video/g364fb.c                          |    1 -
 drivers/video/hitfb.c                           |    1 -
 drivers/video/hpfb.c                            |    1 -
 drivers/video/i810/i810-i2c.c                   |    1 -
 drivers/video/imxfb.c                           |    1 -
 drivers/video/intelfb/intelfb_i2c.c             |    1 -
 drivers/video/kyro/fbdev.c                      |    1 -
 drivers/video/macfb.c                           |    1 -
 drivers/video/maxinefb.c                        |    1 -
 drivers/video/modedb.c                          |    1 -
 drivers/video/nvidia/nv_i2c.c                   |    1 -
 drivers/video/nvidia/nv_of.c                    |    1 -
 drivers/video/pmag-aa-fb.c                      |    1 -
 drivers/video/riva/rivafb-i2c.c                 |    1 -
 drivers/video/savage/savagefb-i2c.c             |    1 -
 drivers/video/tgafb.c                           |    1 -
 fs/afs/cell.c                                   |    1 -
 fs/afs/dir.c                                    |    1 -
 fs/afs/file.c                                   |    1 -
 fs/afs/inode.c                                  |    1 -
 fs/afs/main.c                                   |    1 -
 fs/afs/mntpt.c                                  |    1 -
 fs/afs/proc.c                                   |    1 -
 fs/ecryptfs/keystore.c                          |    1 -
 fs/ext3/hash.c                                  |    1 -
 fs/ext3/resize.c                                |    1 -
 fs/ext4/hash.c                                  |    1 -
 fs/ext4/resize.c                                |    1 -
 fs/filesystems.c                                |    1 -
 fs/gfs2/bmap.c                                  |    1 -
 fs/gfs2/dir.c                                   |    1 -
 fs/gfs2/eaops.c                                 |    1 -
 fs/gfs2/eattr.c                                 |    1 -
 fs/gfs2/glops.c                                 |    1 -
 fs/gfs2/lm.c                                    |    1 -
 fs/gfs2/main.c                                  |    1 -
 fs/gfs2/mount.c                                 |    1 -
 fs/gfs2/ondisk.c                                |    1 -
 fs/gfs2/ops_dentry.c                            |    1 -
 fs/gfs2/ops_export.c                            |    1 -
 fs/gfs2/ops_file.c                              |    1 -
 fs/gfs2/ops_inode.c                             |    1 -
 fs/gfs2/ops_vm.c                                |    1 -
 fs/gfs2/recovery.c                              |    1 -
 fs/gfs2/rgrp.c                                  |    1 -
 fs/gfs2/util.c                                  |    1 -
 fs/hfsplus/catalog.c                            |    1 -
 fs/hfsplus/dir.c                                |    1 -
 fs/hfsplus/super.c                              |    1 -
 fs/jffs2/compr_zlib.c                           |    1 -
 fs/jffs2/dir.c                                  |    1 -
 fs/jffs2/summary.c                              |    1 -
 fs/lockd/host.c                                 |    1 -
 fs/nfs/nfs4renewd.c                             |    1 -
 fs/nfsd/export.c                                |    1 -
 fs/nfsd/nfs4idmap.c                             |    1 -
 fs/nfsd/nfsfh.c                                 |    1 -
 fs/smbfs/symlink.c                              |    1 -
 fs/ufs/balloc.c                                 |    1 -
 fs/ufs/dir.c                                    |    1 -
 fs/xattr_acl.c                                  |    1 -
 fs/xfs/linux-2.6/kmem.c                         |    1 -
 init/calibrate.c                                |    2 +-
 init/version.c                                  |    1 -
 kernel/lockdep_proc.c                           |    1 -
 kernel/mutex-debug.c                            |    1 -
 kernel/resource.c                               |    1 -
 net/802/fc.c                                    |    1 -
 net/802/fddi.c                                  |    1 -
 net/802/hippi.c                                 |    1 -
 net/atm/addr.c                                  |    1 -
 net/atm/lec.c                                   |    1 -
 net/atm/raw.c                                   |    1 -
 net/ax25/ax25_addr.c                            |    1 -
 net/ax25/ax25_dev.c                             |    1 -
 net/ax25/ax25_ds_in.c                           |    1 -
 net/ax25/ax25_ds_subr.c                         |    1 -
 net/ax25/ax25_iface.c                           |    1 -
 net/ax25/ax25_in.c                              |    1 -
 net/ax25/ax25_ip.c                              |    1 -
 net/ax25/ax25_out.c                             |    1 -
 net/ax25/ax25_std_in.c                          |    1 -
 net/ax25/ax25_std_subr.c                        |    1 -
 net/ax25/ax25_std_timer.c                       |    1 -
 net/ax25/ax25_subr.c                            |    1 -
 net/ax25/ax25_uid.c                             |    1 -
 net/bluetooth/bnep/sock.c                       |    1 -
 net/bluetooth/cmtp/sock.c                       |    1 -
 net/bluetooth/hci_conn.c                        |    1 -
 net/bluetooth/hci_event.c                       |    1 -
 net/bluetooth/hci_sock.c                        |    1 -
 net/bluetooth/hidp/sock.c                       |    1 -
 net/bridge/netfilter/ebtables.c                 |    1 -
 net/compat.c                                    |    1 -
 net/core/dev_mcast.c                            |    1 -
 net/core/dst.c                                  |    1 -
 net/core/filter.c                               |    1 -
 net/core/iovec.c                                |    1 -
 net/core/neighbour.c                            |    1 -
 net/core/rtnetlink.c                            |    1 -
 net/core/skbuff.c                               |    1 -
 net/decnet/dn_nsp_in.c                          |    1 -
 net/decnet/dn_nsp_out.c                         |    1 -
 net/econet/af_econet.c                          |    1 -
 net/ethernet/eth.c                              |    1 -
 net/ipv4/arp.c                                  |    1 -
 net/ipv4/devinet.c                              |    1 -
 net/ipv4/fib_frontend.c                         |    1 -
 net/ipv4/fib_hash.c                             |    1 -
 net/ipv4/fib_trie.c                             |    1 -
 net/ipv4/inetpeer.c                             |    1 -
 net/ipv4/ip_forward.c                           |    1 -
 net/ipv4/ip_gre.c                               |    1 -
 net/ipv4/ip_output.c                            |    1 -
 net/ipv4/ip_sockglue.c                          |    1 -
 net/ipv4/ipip.c                                 |    1 -
 net/ipv4/ipmr.c                                 |    1 -
 net/ipv4/ipvs/ip_vs_sched.c                     |    1 -
 net/ipv4/multipath_drr.c                        |    1 -
 net/ipv4/multipath_random.c                     |    1 -
 net/ipv4/multipath_rr.c                         |    1 -
 net/ipv4/multipath_wrandom.c                    |    1 -
 net/ipv4/netfilter/ip_conntrack_proto_generic.c |    1 -
 net/ipv4/netfilter/ip_conntrack_proto_icmp.c    |    1 -
 net/ipv4/netfilter/ip_conntrack_proto_sctp.c    |    1 -
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c     |    1 -
 net/ipv4/netfilter/ip_conntrack_proto_udp.c     |    1 -
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c    |    1 -
 net/ipv4/protocol.c                             |    1 -
 net/ipv4/route.c                                |    1 -
 net/ipv6/addrconf.c                             |    1 -
 net/ipv6/af_inet6.c                             |    1 -
 net/ipv6/anycast.c                              |    1 -
 net/ipv6/datagram.c                             |    1 -
 net/ipv6/exthdrs.c                              |    1 -
 net/ipv6/icmp.c                                 |    1 -
 net/ipv6/ip6_input.c                            |    1 -
 net/ipv6/ipv6_sockglue.c                        |    1 -
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c  |    1 -
 net/ipv6/proc.c                                 |    1 -
 net/ipv6/protocol.c                             |    1 -
 net/ipv6/raw.c                                  |    1 -
 net/ipv6/sit.c                                  |    1 -
 net/ipv6/udp.c                                  |    1 -
 net/irda/ircomm/ircomm_core.c                   |    1 -
 net/irda/ircomm/ircomm_event.c                  |    1 -
 net/irda/ircomm/ircomm_lmp.c                    |    1 -
 net/irda/ircomm/ircomm_param.c                  |    1 -
 net/irda/ircomm/ircomm_ttp.c                    |    1 -
 net/irda/ircomm/ircomm_tty_attach.c             |    1 -
 net/irda/ircomm/ircomm_tty_ioctl.c              |    1 -
 net/lapb/lapb_in.c                              |    1 -
 net/lapb/lapb_out.c                             |    1 -
 net/lapb/lapb_subr.c                            |    1 -
 net/netfilter/nf_conntrack_proto_generic.c      |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c         |    1 -
 net/netfilter/nf_conntrack_proto_tcp.c          |    1 -
 net/netfilter/nf_conntrack_proto_udp.c          |    1 -
 net/netfilter/nfnetlink.c                       |    1 -
 net/netrom/nr_dev.c                             |    1 -
 net/netrom/nr_in.c                              |    1 -
 net/netrom/nr_out.c                             |    1 -
 net/netrom/nr_route.c                           |    1 -
 net/netrom/nr_subr.c                            |    1 -
 net/packet/af_packet.c                          |    1 -
 net/rose/rose_dev.c                             |    1 -
 net/rose/rose_in.c                              |    1 -
 net/rose/rose_out.c                             |    1 -
 net/rose/rose_route.c                           |    1 -
 net/rose/rose_subr.c                            |    1 -
 net/rxrpc/transport.c                           |    1 -
 net/sched/act_api.c                             |    1 -
 net/sched/act_gact.c                            |    1 -
 net/sched/act_ipt.c                             |    1 -
 net/sched/act_mirred.c                          |    1 -
 net/sched/act_pedit.c                           |    1 -
 net/sched/act_police.c                          |    1 -
 net/sched/cls_api.c                             |    1 -
 net/sched/cls_basic.c                           |    1 -
 net/sched/cls_fw.c                              |    1 -
 net/sched/cls_route.c                           |    1 -
 net/sched/cls_rsvp.c                            |    1 -
 net/sched/cls_rsvp6.c                           |    1 -
 net/sched/cls_u32.c                             |    1 -
 net/sched/em_nbyte.c                            |    1 -
 net/sched/em_text.c                             |    1 -
 net/sched/ematch.c                              |    1 -
 net/sched/sch_api.c                             |    1 -
 net/sched/sch_cbq.c                             |    1 -
 net/sched/sch_htb.c                             |    1 -
 net/sched/sch_prio.c                            |    1 -
 net/sched/sch_teql.c                            |    1 -
 net/sctp/associola.c                            |    1 -
 net/sctp/bind_addr.c                            |    1 -
 net/sctp/endpointola.c                          |    1 -
 net/sctp/ipv6.c                                 |    1 -
 net/sunrpc/auth_null.c                          |    1 -
 net/sunrpc/stats.c                              |    1 -
 net/sunrpc/sunrpc_syms.c                        |    1 -
 net/sunrpc/svcauth.c                            |    1 -
 net/sunrpc/xprtsock.c                           |    1 -
 net/unix/garbage.c                              |    1 -
 security/keys/compat.c                          |    1 -
 security/keys/user_defined.c                    |    1 -
 security/security.c                             |    1 -
 security/selinux/ss/sidtab.c                    |    1 -
 sound/core/misc.c                               |    1 -
 sound/core/seq/instr/ainstr_fm.c                |    1 -
 sound/core/seq/instr/ainstr_gf1.c               |    1 -
 sound/core/seq/instr/ainstr_iw.c                |    1 -
 sound/core/seq/instr/ainstr_simple.c            |    1 -
 sound/core/seq/seq_virmidi.c                    |    1 -
 sound/drivers/virmidi.c                         |    1 -
 sound/isa/dt019x.c                              |    1 -
 sound/synth/emux/emux.c                         |    1 -
 sound/synth/emux/emux_proc.c                    |    1 -
 555 files changed, 6 insertions(+), 555 deletions(-)

diff -puN drivers/acorn/block/mfmhd.c~remove-555-unneeded-includes-of-schedh drivers/acorn/block/mfmhd.c
--- a/drivers/acorn/block/mfmhd.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/acorn/block/mfmhd.c
@@ -99,7 +99,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
diff -puN drivers/acorn/char/i2c.c~remove-555-unneeded-includes-of-schedh drivers/acorn/char/i2c.c
--- a/drivers/acorn/char/i2c.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/acorn/char/i2c.c
@@ -14,7 +14,6 @@
  */
 #include <linux/capability.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/miscdevice.h>
 #include <linux/rtc.h>
diff -puN drivers/acpi/i2c_ec.c~remove-555-unneeded-includes-of-schedh drivers/acpi/i2c_ec.c
--- a/drivers/acpi/i2c_ec.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/acpi/i2c_ec.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/acpi.h>
diff -puN drivers/acpi/sleep/poweroff.c~remove-555-unneeded-includes-of-schedh drivers/acpi/sleep/poweroff.c
--- a/drivers/acpi/sleep/poweroff.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/acpi/sleep/poweroff.c
@@ -12,7 +12,6 @@
 #include <linux/pm.h>
 #include <linux/init.h>
 #include <acpi/acpi_bus.h>
-#include <linux/sched.h>
 #include <linux/sysdev.h>
 #include <asm/io.h>
 #include "sleep.h"
diff -puN drivers/acpi/tables.c~remove-555-unneeded-includes-of-schedh drivers/acpi/tables.c
--- a/drivers/acpi/tables.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/acpi/tables.c
@@ -25,7 +25,6 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/string.h>
 #include <linux/types.h>
diff -puN drivers/acpi/thermal.c~remove-555-unneeded-includes-of-schedh drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/acpi/thermal.c
@@ -36,7 +36,8 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/proc_fs.h>
-#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
 #include <linux/kmod.h>
 #include <linux/seq_file.h>
 #include <asm/uaccess.h>
diff -puN drivers/ata/ahci.c~remove-555-unneeded-includes-of-schedh drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ata/ahci.c
@@ -39,7 +39,6 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
diff -puN drivers/ata/pdc_adma.c~remove-555-unneeded-includes-of-schedh drivers/ata/pdc_adma.c
--- a/drivers/ata/pdc_adma.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ata/pdc_adma.c
@@ -39,7 +39,6 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <asm/io.h>
diff -puN drivers/ata/sata_mv.c~remove-555-unneeded-includes-of-schedh drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ata/sata_mv.c
@@ -28,7 +28,6 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
diff -puN drivers/ata/sata_promise.c~remove-555-unneeded-includes-of-schedh drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ata/sata_promise.c
@@ -37,7 +37,6 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
diff -puN drivers/ata/sata_qstor.c~remove-555-unneeded-includes-of-schedh drivers/ata/sata_qstor.c
--- a/drivers/ata/sata_qstor.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ata/sata_qstor.c
@@ -34,7 +34,6 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <asm/io.h>
diff -puN drivers/ata/sata_sx4.c~remove-555-unneeded-includes-of-schedh drivers/ata/sata_sx4.c
--- a/drivers/ata/sata_sx4.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ata/sata_sx4.c
@@ -37,7 +37,6 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
diff -puN drivers/atm/adummy.c~remove-555-unneeded-includes-of-schedh drivers/atm/adummy.c
--- a/drivers/atm/adummy.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/atm/adummy.c
@@ -13,7 +13,6 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/mm.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <asm/io.h>
diff -puN drivers/atm/fore200e.c~remove-555-unneeded-includes-of-schedh drivers/atm/fore200e.c
--- a/drivers/atm/fore200e.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/atm/fore200e.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/capability.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/pci.h>
diff -puN drivers/atm/idt77105.c~remove-555-unneeded-includes-of-schedh drivers/atm/idt77105.c
--- a/drivers/atm/idt77105.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/atm/idt77105.c
@@ -4,7 +4,6 @@
 
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
diff -puN drivers/atm/uPD98402.c~remove-555-unneeded-includes-of-schedh drivers/atm/uPD98402.c
--- a/drivers/atm/uPD98402.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/atm/uPD98402.c
@@ -4,7 +4,6 @@
  
 
 #include <linux/module.h>
-#include <linux/sched.h> /* for jiffies */
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/atmdev.h>
diff -puN drivers/atm/zatm.c~remove-555-unneeded-includes-of-schedh drivers/atm/zatm.c
--- a/drivers/atm/zatm.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/atm/zatm.c
@@ -4,7 +4,6 @@
 
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
diff -puN drivers/block/acsi.c~remove-555-unneeded-includes-of-schedh drivers/block/acsi.c
--- a/drivers/block/acsi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/block/acsi.c
@@ -46,7 +46,6 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
diff -puN drivers/block/paride/pd.c~remove-555-unneeded-includes-of-schedh drivers/block/paride/pd.c
--- a/drivers/block/paride/pd.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/block/paride/pd.c
@@ -153,7 +153,6 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_GEO,
 #include <linux/blkpg.h>
 #include <linux/kernel.h>
 #include <asm/uaccess.h>
-#include <linux/sched.h>
 #include <linux/workqueue.h>
 
 static DEFINE_SPINLOCK(pd_lock);
diff -puN drivers/block/umem.c~remove-555-unneeded-includes-of-schedh drivers/block/umem.c
--- a/drivers/block/umem.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/block/umem.c
@@ -35,7 +35,6 @@
  */
 
 //#define DEBUG /* uncomment if you want debugging info (pr_debug) */
-#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/bio.h>
 #include <linux/kernel.h>
diff -puN drivers/bluetooth/bfusb.c~remove-555-unneeded-includes-of-schedh drivers/bluetooth/bfusb.c
--- a/drivers/bluetooth/bfusb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/bluetooth/bfusb.c
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/skbuff.h>
 
diff -puN drivers/bluetooth/bt3c_cs.c~remove-555-unneeded-includes-of-schedh drivers/bluetooth/bt3c_cs.c
--- a/drivers/bluetooth/bt3c_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/bluetooth/bt3c_cs.c
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
diff -puN drivers/bluetooth/btuart_cs.c~remove-555-unneeded-includes-of-schedh drivers/bluetooth/btuart_cs.c
--- a/drivers/bluetooth/btuart_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/bluetooth/btuart_cs.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
diff -puN drivers/bluetooth/dtl1_cs.c~remove-555-unneeded-includes-of-schedh drivers/bluetooth/dtl1_cs.c
--- a/drivers/bluetooth/dtl1_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/bluetooth/dtl1_cs.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
diff -puN drivers/bluetooth/hci_bcsp.c~remove-555-unneeded-includes-of-schedh drivers/bluetooth/hci_bcsp.c
--- a/drivers/bluetooth/hci_bcsp.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/bluetooth/hci_bcsp.c
@@ -26,7 +26,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/bluetooth/hci_h4.c~remove-555-unneeded-includes-of-schedh drivers/bluetooth/hci_h4.c
--- a/drivers/bluetooth/hci_h4.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/bluetooth/hci_h4.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/bluetooth/hci_ldisc.c~remove-555-unneeded-includes-of-schedh drivers/bluetooth/hci_ldisc.c
--- a/drivers/bluetooth/hci_ldisc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/bluetooth/hci_ldisc.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/bluetooth/hci_usb.c~remove-555-unneeded-includes-of-schedh drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/bluetooth/hci_usb.c
@@ -35,7 +35,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/unistd.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
diff -puN drivers/cdrom/aztcd.c~remove-555-unneeded-includes-of-schedh drivers/cdrom/aztcd.c
--- a/drivers/cdrom/aztcd.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/cdrom/aztcd.c
@@ -170,7 +170,6 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/timer.h>
 #include <linux/fs.h>
diff -puN drivers/cdrom/cm206.c~remove-555-unneeded-includes-of-schedh drivers/cdrom/cm206.c
--- a/drivers/cdrom/cm206.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/cdrom/cm206.c
@@ -183,7 +183,6 @@ History:
 #include <linux/errno.h>	/* These include what we really need */
 #include <linux/delay.h>
 #include <linux/string.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
 #include <linux/cdrom.h>
diff -puN drivers/cdrom/gscd.c~remove-555-unneeded-includes-of-schedh drivers/cdrom/gscd.c
--- a/drivers/cdrom/gscd.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/cdrom/gscd.c
@@ -53,7 +53,6 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
diff -puN drivers/cdrom/sjcd.c~remove-555-unneeded-includes-of-schedh drivers/cdrom/sjcd.c
--- a/drivers/cdrom/sjcd.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/cdrom/sjcd.c
@@ -60,7 +60,6 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/timer.h>
 #include <linux/fs.h>
diff -puN drivers/char/briq_panel.c~remove-555-unneeded-includes-of-schedh drivers/char/briq_panel.c
--- a/drivers/char/briq_panel.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/briq_panel.c
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/timer.h>
 #include <linux/kernel.h>
diff -puN drivers/char/drm/ffb_context.c~remove-555-unneeded-includes-of-schedh drivers/char/drm/ffb_context.c
--- a/drivers/char/drm/ffb_context.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/drm/ffb_context.c
@@ -7,7 +7,6 @@
  * for authors.
  */
 
-#include <linux/sched.h>
 #include <asm/upa.h>
 
 #include "ffb.h"
diff -puN drivers/char/drm/ffb_drv.c~remove-555-unneeded-includes-of-schedh drivers/char/drm/ffb_drv.c
--- a/drivers/char/drm/ffb_drv.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/drm/ffb_drv.c
@@ -9,7 +9,6 @@
 
 #include "ffb_drv.h"
 
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <asm/shmparam.h>
 #include <asm/oplib.h>
diff -puN drivers/char/ds1620.c~remove-555-unneeded-includes-of-schedh drivers/char/ds1620.c
--- a/drivers/char/ds1620.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/ds1620.c
@@ -3,7 +3,6 @@
  *   thermometer driver (as used in the Rebel.com NetWinder)
  */
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/miscdevice.h>
 #include <linux/smp_lock.h>
 #include <linux/delay.h>
diff -puN drivers/char/dsp56k.c~remove-555-unneeded-includes-of-schedh drivers/char/dsp56k.c
--- a/drivers/char/dsp56k.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/dsp56k.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>	/* for kmalloc() and kfree() */
-#include <linux/sched.h>	/* for struct wait_queue etc */
 #include <linux/major.h>
 #include <linux/types.h>
 #include <linux/errno.h>
diff -puN drivers/char/hvsi.c~remove-555-unneeded-includes-of-schedh drivers/char/hvsi.c
--- a/drivers/char/hvsi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/hvsi.c
@@ -39,7 +39,6 @@
 #include <linux/module.h>
 #include <linux/major.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/sysrq.h>
 #include <linux/tty.h>
diff -puN drivers/char/ipmi/ipmi_devintf.c~remove-555-unneeded-includes-of-schedh drivers/char/ipmi/ipmi_devintf.c
--- a/drivers/char/ipmi/ipmi_devintf.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/ipmi/ipmi_devintf.c
@@ -35,7 +35,6 @@
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
 #include <asm/system.h>
-#include <linux/sched.h>
 #include <linux/poll.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
diff -puN drivers/char/ipmi/ipmi_msghandler.c~remove-555-unneeded-includes-of-schedh drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <asm/system.h>
-#include <linux/sched.h>
 #include <linux/poll.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
diff -puN drivers/char/nvram.c~remove-555-unneeded-includes-of-schedh drivers/char/nvram.c
--- a/drivers/char/nvram.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/nvram.c
@@ -37,7 +37,6 @@
 #define NVRAM_VERSION	"1.2"
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/nvram.h>
 
diff -puN drivers/char/nwflash.c~remove-555-unneeded-includes-of-schedh drivers/char/nwflash.c
--- a/drivers/char/nwflash.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/nwflash.c
@@ -21,7 +21,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
-#include <linux/sched.h>
 #include <linux/miscdevice.h>
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
diff -puN drivers/char/pty.c~remove-555-unneeded-includes-of-schedh drivers/char/pty.c
--- a/drivers/char/pty.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/pty.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>	/* For EXPORT_SYMBOL */
 
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
diff -puN drivers/char/scan_keyb.c~remove-555-unneeded-includes-of-schedh drivers/char/scan_keyb.c
--- a/drivers/char/scan_keyb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/scan_keyb.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/spinlock.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
 #include <linux/mm.h>
diff -puN drivers/char/ser_a2232.c~remove-555-unneeded-includes-of-schedh drivers/char/ser_a2232.c
--- a/drivers/char/ser_a2232.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/ser_a2232.c
@@ -86,7 +86,6 @@
 #include <linux/module.h>
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff -puN drivers/char/sonypi.c~remove-555-unneeded-includes-of-schedh drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/sonypi.c
@@ -36,7 +36,6 @@
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/pci.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/miscdevice.h>
diff -puN drivers/char/tlclk.c~remove-555-unneeded-includes-of-schedh drivers/char/tlclk.c
--- a/drivers/char/tlclk.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/tlclk.c
@@ -29,7 +29,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/kernel.h>	/* printk() */
 #include <linux/fs.h>		/* everything... */
 #include <linux/errno.h>	/* error codes */
diff -puN drivers/char/toshiba.c~remove-555-unneeded-includes-of-schedh drivers/char/toshiba.c
--- a/drivers/char/toshiba.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/toshiba.c
@@ -58,7 +58,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/miscdevice.h>
diff -puN drivers/char/tpm/tpm.c~remove-555-unneeded-includes-of-schedh drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/tpm/tpm.c
@@ -23,7 +23,6 @@
  *
  */
 
-#include <linux/sched.h>
 #include <linux/poll.h>
 #include <linux/spinlock.h>
 #include "tpm.h"
diff -puN drivers/char/vc_screen.c~remove-555-unneeded-includes-of-schedh drivers/char/vc_screen.c
--- a/drivers/char/vc_screen.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/vc_screen.c
@@ -25,7 +25,6 @@
 #include <linux/major.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/init.h>
diff -puN drivers/char/vme_scc.c~remove-555-unneeded-includes-of-schedh drivers/char/vme_scc.c
--- a/drivers/char/vme_scc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/char/vme_scc.c
@@ -17,7 +17,6 @@
 #include <linux/kdev_t.h>
 #include <asm/io.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
diff -puN drivers/cpufreq/cpufreq_conservative.c~remove-555-unneeded-includes-of-schedh drivers/cpufreq/cpufreq_conservative.c
--- a/drivers/cpufreq/cpufreq_conservative.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/cpufreq/cpufreq_conservative.c
@@ -23,7 +23,6 @@
 #include <linux/fs.h>
 #include <linux/sysfs.h>
 #include <linux/cpu.h>
-#include <linux/sched.h>
 #include <linux/kmod.h>
 #include <linux/workqueue.h>
 #include <linux/jiffies.h>
diff -puN drivers/crypto/geode-aes.c~remove-555-unneeded-includes-of-schedh drivers/crypto/geode-aes.c
--- a/drivers/crypto/geode-aes.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/crypto/geode-aes.c
@@ -8,7 +8,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/crypto.h>
diff -puN drivers/fc4/fc_syms.c~remove-555-unneeded-includes-of-schedh drivers/fc4/fc_syms.c
--- a/drivers/fc4/fc_syms.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/fc4/fc_syms.c
@@ -6,7 +6,6 @@
 
 #ifdef CONFIG_MODULES
 
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
diff -puN drivers/fc4/soc.c~remove-555-unneeded-includes-of-schedh drivers/fc4/soc.c
--- a/drivers/fc4/soc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/fc4/soc.c
@@ -22,7 +22,6 @@ static char *version =
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/fc4/socal.c~remove-555-unneeded-includes-of-schedh drivers/fc4/socal.c
--- a/drivers/fc4/socal.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/fc4/socal.c
@@ -17,7 +17,6 @@ static char *version =
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/hid/hid-core.c~remove-555-unneeded-includes-of-schedh drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/hid/hid-core.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/smp_lock.h>
diff -puN drivers/i2c/busses/i2c-ali1535.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-ali1535.c
--- a/drivers/i2c/busses/i2c-ali1535.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-ali1535.c
@@ -57,7 +57,6 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
diff -puN drivers/i2c/busses/i2c-ali15x3.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-ali15x3.c
--- a/drivers/i2c/busses/i2c-ali15x3.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-ali15x3.c
@@ -64,7 +64,6 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
diff -puN drivers/i2c/busses/i2c-amd756.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-amd756.c
--- a/drivers/i2c/busses/i2c-amd756.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-amd756.c
@@ -42,7 +42,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/stddef.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
diff -puN drivers/i2c/busses/i2c-amd8111.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-amd8111.c
--- a/drivers/i2c/busses/i2c-amd8111.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-amd8111.c
@@ -12,7 +12,6 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
diff -puN drivers/i2c/busses/i2c-i801.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-i801.c
--- a/drivers/i2c/busses/i2c-i801.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-i801.c
@@ -48,7 +48,6 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
diff -puN drivers/i2c/busses/i2c-iop3xx.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-iop3xx.c
--- a/drivers/i2c/busses/i2c-iop3xx.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-iop3xx.c
@@ -36,7 +36,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 
diff -puN drivers/i2c/busses/i2c-nforce2.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-nforce2.c
--- a/drivers/i2c/busses/i2c-nforce2.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-nforce2.c
@@ -44,7 +44,6 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
diff -puN drivers/i2c/busses/i2c-ocores.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-ocores.c
--- a/drivers/i2c/busses/i2c-ocores.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-ocores.c
@@ -11,7 +11,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/platform_device.h>
diff -puN drivers/i2c/busses/i2c-piix4.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-piix4.c
--- a/drivers/i2c/busses/i2c-piix4.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-piix4.c
@@ -35,7 +35,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/stddef.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
diff -puN drivers/i2c/busses/i2c-s3c2410.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-s3c2410.c
--- a/drivers/i2c/busses/i2c-s3c2410.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-s3c2410.c
@@ -28,7 +28,6 @@
 #include <linux/init.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/err.h>
diff -puN drivers/i2c/busses/i2c-sis96x.c~remove-555-unneeded-includes-of-schedh drivers/i2c/busses/i2c-sis96x.c
--- a/drivers/i2c/busses/i2c-sis96x.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/busses/i2c-sis96x.c
@@ -37,7 +37,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/stddef.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
diff -puN drivers/i2c/chips/eeprom.c~remove-555-unneeded-includes-of-schedh drivers/i2c/chips/eeprom.c
--- a/drivers/i2c/chips/eeprom.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/i2c/chips/eeprom.c
@@ -30,7 +30,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
diff -puN drivers/ide/ide-proc.c~remove-555-unneeded-includes-of-schedh drivers/ide/ide-proc.c
--- a/drivers/ide/ide-proc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ide/ide-proc.c
@@ -26,7 +26,6 @@
 
 #include <asm/uaccess.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/mm.h>
diff -puN drivers/ide/legacy/ide-cs.c~remove-555-unneeded-includes-of-schedh drivers/ide/legacy/ide-cs.c
--- a/drivers/ide/legacy/ide-cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ide/legacy/ide-cs.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/ide/ppc/mpc8xx.c~remove-555-unneeded-includes-of-schedh drivers/ide/ppc/mpc8xx.c
--- a/drivers/ide/ppc/mpc8xx.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ide/ppc/mpc8xx.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/stddef.h>
diff -puN drivers/ide/ppc/pmac.c~remove-555-unneeded-includes-of-schedh drivers/ide/ppc/pmac.c
--- a/drivers/ide/ppc/pmac.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ide/ppc/pmac.c
@@ -24,7 +24,6 @@
  */
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
diff -puN drivers/ieee1394/eth1394.c~remove-555-unneeded-includes-of-schedh drivers/ieee1394/eth1394.c
--- a/drivers/ieee1394/eth1394.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ieee1394/eth1394.c
@@ -43,7 +43,6 @@
 
 #include <linux/module.h>
 
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
diff -puN drivers/ieee1394/iso.c~remove-555-unneeded-includes-of-schedh drivers/ieee1394/iso.c
--- a/drivers/ieee1394/iso.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ieee1394/iso.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/pci.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 
 #include "hosts.h"
diff -puN drivers/ieee1394/ohci1394.c~remove-555-unneeded-includes-of-schedh drivers/ieee1394/ohci1394.c
--- a/drivers/ieee1394/ohci1394.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/ieee1394/ohci1394.c
@@ -102,7 +102,6 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/irq.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
diff -puN drivers/infiniband/core/cache.c~remove-555-unneeded-includes-of-schedh drivers/infiniband/core/cache.c
--- a/drivers/infiniband/core/cache.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/infiniband/core/cache.c
@@ -38,7 +38,6 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/sched.h>	/* INIT_WORK, schedule_work(), flush_scheduled_work() */
 
 #include <rdma/ib_cache.h>
 
diff -puN drivers/input/ff-memless.c~remove-555-unneeded-includes-of-schedh drivers/input/ff-memless.c
--- a/drivers/input/ff-memless.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/input/ff-memless.c
@@ -29,7 +29,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
-#include <linux/sched.h>
+#include <linux/jiffies.h>
 
 #include "fixp-arith.h"
 
diff -puN drivers/input/input.c~remove-555-unneeded-includes-of-schedh drivers/input/input.c
--- a/drivers/input/input.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/input/input.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/input.h>
 #include <linux/module.h>
diff -puN drivers/input/mouse/rpcmouse.c~remove-555-unneeded-includes-of-schedh drivers/input/mouse/rpcmouse.c
--- a/drivers/input/mouse/rpcmouse.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/input/mouse/rpcmouse.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
diff -puN drivers/input/serio/hil_mlc.c~remove-555-unneeded-includes-of-schedh drivers/input/serio/hil_mlc.c
--- a/drivers/input/serio/hil_mlc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/input/serio/hil_mlc.c
@@ -59,7 +59,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
-#include <linux/sched.h>
 #include <linux/list.h>
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
diff -puN drivers/input/serio/hp_sdc.c~remove-555-unneeded-includes-of-schedh drivers/input/serio/hp_sdc.c
--- a/drivers/input/serio/hp_sdc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/input/serio/hp_sdc.c
@@ -62,7 +62,6 @@
  */
 
 #include <linux/hp_sdc.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff -puN drivers/isdn/capi/capidrv.c~remove-555-unneeded-includes-of-schedh drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/capi/capidrv.c
@@ -13,7 +13,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/major.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/fcntl.h>
 #include <linux/fs.h>
diff -puN drivers/isdn/hardware/avm/avm_cs.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hardware/avm/avm_cs.c
--- a/drivers/isdn/hardware/avm/avm_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hardware/avm/avm_cs.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/isdn/hardware/eicon/divamnt.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hardware/eicon/divamnt.c
--- a/drivers/isdn/hardware/eicon/divamnt.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hardware/eicon/divamnt.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <asm/uaccess.h>
diff -puN drivers/isdn/hardware/eicon/divasmain.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hardware/eicon/divasmain.c
--- a/drivers/isdn/hardware/eicon/divasmain.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hardware/eicon/divasmain.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/ioport.h>
diff -puN drivers/isdn/hisax/avma1_cs.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hisax/avma1_cs.c
--- a/drivers/isdn/hisax/avma1_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hisax/avma1_cs.c
@@ -14,7 +14,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/isdn/hisax/elsa_cs.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hisax/elsa_cs.c
--- a/drivers/isdn/hisax/elsa_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hisax/elsa_cs.c
@@ -38,7 +38,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/isdn/hisax/hfc_usb.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hisax/hfc_usb.c
--- a/drivers/isdn/hisax/hfc_usb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hisax/hfc_usb.c
@@ -38,7 +38,6 @@
 #include <linux/usb.h>
 #include <linux/kernel.h>
 #include <linux/smp_lock.h>
-#include <linux/sched.h>
 #include "hisax.h"
 #include "hisax_if.h"
 #include "hfc_usb.h"
diff -puN drivers/isdn/hisax/sedlbauer_cs.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hisax/sedlbauer_cs.c
--- a/drivers/isdn/hisax/sedlbauer_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hisax/sedlbauer_cs.c
@@ -38,7 +38,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/isdn/hisax/teles_cs.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hisax/teles_cs.c
--- a/drivers/isdn/hisax/teles_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hisax/teles_cs.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/isdn/hysdn/boardergo.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hysdn/boardergo.c
--- a/drivers/isdn/hysdn/boardergo.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hysdn/boardergo.c
@@ -14,7 +14,6 @@
  *
  */
 
-#include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
diff -puN drivers/isdn/hysdn/hysdn_sched.c~remove-555-unneeded-includes-of-schedh drivers/isdn/hysdn/hysdn_sched.c
--- a/drivers/isdn/hysdn/hysdn_sched.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/hysdn/hysdn_sched.c
@@ -11,7 +11,6 @@
  *
  */
 
-#include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
diff -puN drivers/isdn/i4l/isdn_bsdcomp.c~remove-555-unneeded-includes-of-schedh drivers/isdn/i4l/isdn_bsdcomp.c
--- a/drivers/isdn/i4l/isdn_bsdcomp.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/i4l/isdn_bsdcomp.c
@@ -56,7 +56,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/isdn/pcbit/callbacks.c~remove-555-unneeded-includes-of-schedh drivers/isdn/pcbit/callbacks.c
--- a/drivers/isdn/pcbit/callbacks.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/pcbit/callbacks.c
@@ -15,7 +15,6 @@
  * NULL pointer dereference in cb_in_1 (originally fixed in 2.0)
  */
 
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 
diff -puN drivers/isdn/pcbit/capi.c~remove-555-unneeded-includes-of-schedh drivers/isdn/pcbit/capi.c
--- a/drivers/isdn/pcbit/capi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/pcbit/capi.c
@@ -27,7 +27,6 @@
  *              encode our number in CallerPN and ConnectedPN
  */
 
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 
diff -puN drivers/isdn/pcbit/drv.c~remove-555-unneeded-includes-of-schedh drivers/isdn/pcbit/drv.c
--- a/drivers/isdn/pcbit/drv.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/pcbit/drv.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 
-#include <linux/sched.h>
 
 #include <linux/kernel.h>
 
diff -puN drivers/isdn/pcbit/edss1.c~remove-555-unneeded-includes-of-schedh drivers/isdn/pcbit/edss1.c
--- a/drivers/isdn/pcbit/edss1.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/pcbit/edss1.c
@@ -15,7 +15,6 @@
  *              move state/event descriptions to a user space logger
  */
 
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 
diff -puN drivers/isdn/pcbit/layer2.c~remove-555-unneeded-includes-of-schedh drivers/isdn/pcbit/layer2.c
--- a/drivers/isdn/pcbit/layer2.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/pcbit/layer2.c
@@ -24,7 +24,6 @@
  *              re-write/remove debug printks
  */
 
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
diff -puN drivers/isdn/pcbit/module.c~remove-555-unneeded-includes-of-schedh drivers/isdn/pcbit/module.c
--- a/drivers/isdn/pcbit/module.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/isdn/pcbit/module.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
diff -puN drivers/macintosh/macio-adb.c~remove-555-unneeded-includes-of-schedh drivers/macintosh/macio-adb.c
--- a/drivers/macintosh/macio-adb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/macintosh/macio-adb.c
@@ -6,7 +6,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <asm/prom.h>
diff -puN drivers/macintosh/via-cuda.c~remove-555-unneeded-includes-of-schedh drivers/macintosh/via-cuda.c
--- a/drivers/macintosh/via-cuda.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/macintosh/via-cuda.c
@@ -13,7 +13,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/adb.h>
 #include <linux/cuda.h>
 #include <linux/spinlock.h>
diff -puN drivers/macintosh/via-macii.c~remove-555-unneeded-includes-of-schedh drivers/macintosh/via-macii.c
--- a/drivers/macintosh/via-macii.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/macintosh/via-macii.c
@@ -19,7 +19,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/adb.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
diff -puN drivers/macintosh/via-maciisi.c~remove-555-unneeded-includes-of-schedh drivers/macintosh/via-maciisi.c
--- a/drivers/macintosh/via-maciisi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/macintosh/via-maciisi.c
@@ -18,7 +18,6 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/adb.h>
 #include <linux/cuda.h>
 #include <linux/delay.h>
diff -puN drivers/macintosh/via-pmu68k.c~remove-555-unneeded-includes-of-schedh drivers/macintosh/via-pmu68k.c
--- a/drivers/macintosh/via-pmu68k.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/macintosh/via-pmu68k.c
@@ -22,7 +22,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/miscdevice.h>
 #include <linux/blkdev.h>
 #include <linux/pci.h>
diff -puN drivers/media/dvb/dvb-core/dmxdev.c~remove-555-unneeded-includes-of-schedh drivers/media/dvb/dvb-core/dmxdev.c
--- a/drivers/media/dvb/dvb-core/dmxdev.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/dvb/dvb-core/dmxdev.c
@@ -25,7 +25,6 @@
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/sched.h>
 #include <linux/poll.h>
 #include <linux/ioctl.h>
 #include <linux/wait.h>
diff -puN drivers/media/dvb/dvb-core/dvbdev.c~remove-555-unneeded-includes-of-schedh drivers/media/dvb/dvb-core/dvbdev.c
--- a/drivers/media/dvb/dvb-core/dvbdev.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/dvb/dvb-core/dvbdev.c
@@ -27,7 +27,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/device.h>
diff -puN drivers/media/dvb/ttpci/av7110_av.c~remove-555-unneeded-includes-of-schedh drivers/media/dvb/ttpci/av7110_av.c
--- a/drivers/media/dvb/ttpci/av7110_av.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/dvb/ttpci/av7110_av.c
@@ -31,7 +31,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
diff -puN drivers/media/dvb/ttpci/av7110_ca.c~remove-555-unneeded-includes-of-schedh drivers/media/dvb/ttpci/av7110_ca.c
--- a/drivers/media/dvb/ttpci/av7110_ca.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/dvb/ttpci/av7110_ca.c
@@ -29,7 +29,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
diff -puN drivers/media/dvb/ttpci/av7110_hw.c~remove-555-unneeded-includes-of-schedh drivers/media/dvb/ttpci/av7110_hw.c
--- a/drivers/media/dvb/ttpci/av7110_hw.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/dvb/ttpci/av7110_hw.c
@@ -32,7 +32,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
diff -puN drivers/media/dvb/ttpci/av7110_v4l.c~remove-555-unneeded-includes-of-schedh drivers/media/dvb/ttpci/av7110_v4l.c
--- a/drivers/media/dvb/ttpci/av7110_v4l.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
diff -puN drivers/media/radio/miropcm20-rds.c~remove-555-unneeded-includes-of-schedh drivers/media/radio/miropcm20-rds.c
--- a/drivers/media/radio/miropcm20-rds.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/radio/miropcm20-rds.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
-#include <linux/sched.h>	/* current, TASK_*, schedule_timeout() */
 #include <linux/delay.h>
 #include <asm/uaccess.h>
 #include "miropcm20-rds-core.h"
diff -puN drivers/media/radio/radio-maestro.c~remove-555-unneeded-includes-of-schedh drivers/media/radio/radio-maestro.c
--- a/drivers/media/radio/radio-maestro.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/radio/radio-maestro.c
@@ -22,7 +22,6 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/mutex.h>
diff -puN drivers/media/radio/radio-maxiradio.c~remove-555-unneeded-includes-of-schedh drivers/media/radio/radio-maxiradio.c
--- a/drivers/media/radio/radio-maxiradio.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/radio/radio-maxiradio.c
@@ -35,7 +35,6 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/mutex.h>
diff -puN drivers/media/video/adv7170.c~remove-555-unneeded-includes-of-schedh drivers/media/video/adv7170.c
--- a/drivers/media/video/adv7170.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/adv7170.c
@@ -42,7 +42,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 
 #include <linux/videodev.h>
diff -puN drivers/media/video/adv7175.c~remove-555-unneeded-includes-of-schedh drivers/media/video/adv7175.c
--- a/drivers/media/video/adv7175.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/adv7175.c
@@ -38,7 +38,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 
 #include <linux/videodev.h>
diff -puN drivers/media/video/bt819.c~remove-555-unneeded-includes-of-schedh drivers/media/video/bt819.c
--- a/drivers/media/video/bt819.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/bt819.c
@@ -42,7 +42,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 
 #include <linux/videodev.h>
diff -puN drivers/media/video/bt856.c~remove-555-unneeded-includes-of-schedh drivers/media/video/bt856.c
--- a/drivers/media/video/bt856.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/bt856.c
@@ -42,7 +42,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 
 #include <linux/videodev.h>
diff -puN drivers/media/video/bt8xx/bttv-vbi.c~remove-555-unneeded-includes-of-schedh drivers/media/video/bt8xx/bttv-vbi.c
--- a/drivers/media/video/bt8xx/bttv-vbi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/bt8xx/bttv-vbi.c
@@ -25,7 +25,6 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/kdev_t.h>
 #include <asm/io.h>
diff -puN drivers/media/video/cx88/cx88-tvaudio.c~remove-555-unneeded-includes-of-schedh drivers/media/video/cx88/cx88-tvaudio.c
--- a/drivers/media/video/cx88/cx88-tvaudio.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/cx88/cx88-tvaudio.c
@@ -45,7 +45,6 @@
 #include <linux/pci.h>
 #include <linux/signal.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
diff -puN drivers/media/video/em28xx/em28xx-input.c~remove-555-unneeded-includes-of-schedh drivers/media/video/em28xx/em28xx-input.c
--- a/drivers/media/video/em28xx/em28xx-input.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/em28xx/em28xx-input.c
@@ -25,7 +25,6 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/usb.h>
diff -puN drivers/media/video/indycam.c~remove-555-unneeded-includes-of-schedh drivers/media/video/indycam.c
--- a/drivers/media/video/indycam.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/indycam.c
@@ -17,7 +17,6 @@
 #include <linux/major.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 
 #include <linux/videodev.h>
diff -puN drivers/media/video/ir-kbd-i2c.c~remove-555-unneeded-includes-of-schedh drivers/media/video/ir-kbd-i2c.c
--- a/drivers/media/video/ir-kbd-i2c.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/ir-kbd-i2c.c
@@ -31,7 +31,6 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
diff -puN drivers/media/video/meye.c~remove-555-unneeded-includes-of-schedh drivers/media/video/meye.c
--- a/drivers/media/video/meye.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/meye.c
@@ -28,7 +28,6 @@
  */
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
diff -puN drivers/media/video/pms.c~remove-555-unneeded-includes-of-schedh drivers/media/video/pms.c
--- a/drivers/media/video/pms.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/pms.c
@@ -28,7 +28,6 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <asm/io.h>
-#include <linux/sched.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
diff -puN drivers/media/video/saa5246a.c~remove-555-unneeded-includes-of-schedh drivers/media/video/saa5246a.c
--- a/drivers/media/video/saa5246a.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/saa5246a.c
@@ -40,7 +40,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
diff -puN drivers/media/video/saa7111.c~remove-555-unneeded-includes-of-schedh drivers/media/video/saa7111.c
--- a/drivers/media/video/saa7111.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/saa7111.c
@@ -41,7 +41,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 
 #include <linux/videodev.h>
diff -puN drivers/media/video/saa7114.c~remove-555-unneeded-includes-of-schedh drivers/media/video/saa7114.c
--- a/drivers/media/video/saa7114.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/saa7114.c
@@ -44,7 +44,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 
 #include <linux/videodev.h>
diff -puN drivers/media/video/saa711x.c~remove-555-unneeded-includes-of-schedh drivers/media/video/saa711x.c
--- a/drivers/media/video/saa711x.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/saa711x.c
@@ -35,7 +35,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <asm/uaccess.h>
 #include <linux/videodev.h>
diff -puN drivers/media/video/saa7134/saa6752hs.c~remove-555-unneeded-includes-of-schedh drivers/media/video/saa7134/saa6752hs.c
--- a/drivers/media/video/saa7134/saa6752hs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/saa7134/saa6752hs.c
@@ -1,6 +1,5 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
diff -puN drivers/media/video/saa7134/saa7134-input.c~remove-555-unneeded-includes-of-schedh drivers/media/video/saa7134/saa7134-input.c
--- a/drivers/media/video/saa7134/saa7134-input.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/saa7134/saa7134-input.c
@@ -22,7 +22,6 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 
diff -puN drivers/media/video/saa7185.c~remove-555-unneeded-includes-of-schedh drivers/media/video/saa7185.c
--- a/drivers/media/video/saa7185.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/saa7185.c
@@ -38,7 +38,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 
 #include <linux/videodev.h>
diff -puN drivers/media/video/saa7191.c~remove-555-unneeded-includes-of-schedh drivers/media/video/saa7191.c
--- a/drivers/media/video/saa7191.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/saa7191.c
@@ -17,7 +17,6 @@
 #include <linux/major.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 
 #include <linux/videodev.h>
diff -puN drivers/media/video/tda7432.c~remove-555-unneeded-includes-of-schedh drivers/media/video/tda7432.c
--- a/drivers/media/video/tda7432.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/tda7432.c
@@ -38,7 +38,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
diff -puN drivers/media/video/tda9875.c~remove-555-unneeded-includes-of-schedh drivers/media/video/tda9875.c
--- a/drivers/media/video/tda9875.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/tda9875.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
diff -puN drivers/media/video/tuner-core.c~remove-555-unneeded-includes-of-schedh drivers/media/video/tuner-core.c
--- a/drivers/media/video/tuner-core.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/tuner-core.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
diff -puN drivers/media/video/tvmixer.c~remove-555-unneeded-includes-of-schedh drivers/media/video/tvmixer.c
--- a/drivers/media/video/tvmixer.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/tvmixer.c
@@ -4,7 +4,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
diff -puN drivers/media/video/usbvideo/ibmcam.c~remove-555-unneeded-includes-of-schedh drivers/media/video/usbvideo/ibmcam.c
--- a/drivers/media/video/usbvideo/ibmcam.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/usbvideo/ibmcam.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/init.h>
 
diff -puN drivers/media/video/usbvideo/ultracam.c~remove-555-unneeded-includes-of-schedh drivers/media/video/usbvideo/ultracam.c
--- a/drivers/media/video/usbvideo/ultracam.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/usbvideo/ultracam.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/init.h>
 
diff -puN drivers/media/video/usbvision/usbvision-core.c~remove-555-unneeded-includes-of-schedh drivers/media/video/usbvision/usbvision-core.c
--- a/drivers/media/video/usbvision/usbvision-core.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/usbvision/usbvision-core.c
@@ -24,7 +24,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
diff -puN drivers/media/video/usbvision/usbvision-i2c.c~remove-555-unneeded-includes-of-schedh drivers/media/video/usbvision/usbvision-i2c.c
--- a/drivers/media/video/usbvision/usbvision-i2c.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/usbvision/usbvision-i2c.c
@@ -34,7 +34,6 @@
 #include <asm/uaccess.h>
 #include <linux/ioport.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
 #include "usbvision.h"
diff -puN drivers/media/video/usbvision/usbvision-video.c~remove-555-unneeded-includes-of-schedh drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -46,7 +46,6 @@
 
 #include <linux/version.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
diff -puN drivers/media/video/v4l2-common.c~remove-555-unneeded-includes-of-schedh drivers/media/video/v4l2-common.c
--- a/drivers/media/video/v4l2-common.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/v4l2-common.c
@@ -47,7 +47,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/string.h>
diff -puN drivers/media/video/videodev.c~remove-555-unneeded-includes-of-schedh drivers/media/video/videodev.c
--- a/drivers/media/video/videodev.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/media/video/videodev.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/string.h>
diff -puN drivers/message/fusion/mptfc.c~remove-555-unneeded-includes-of-schedh drivers/message/fusion/mptfc.c
--- a/drivers/message/fusion/mptfc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/message/fusion/mptfc.c
@@ -53,7 +53,6 @@
 #include <linux/delay.h>	/* for mdelay */
 #include <linux/interrupt.h>	/* needed for in_interrupt() proto */
 #include <linux/reboot.h>	/* notifier code */
-#include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/sort.h>
 
diff -puN drivers/message/fusion/mptsas.c~remove-555-unneeded-includes-of-schedh drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/message/fusion/mptsas.c
@@ -48,7 +48,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
+#include <linux/jiffies.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>	/* for mdelay */
 
diff -puN drivers/message/fusion/mptscsih.c~remove-555-unneeded-includes-of-schedh drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/message/fusion/mptscsih.c
@@ -54,7 +54,6 @@
 #include <linux/delay.h>	/* for mdelay */
 #include <linux/interrupt.h>	/* needed for in_interrupt() proto */
 #include <linux/reboot.h>	/* notifier code */
-#include <linux/sched.h>
 #include <linux/workqueue.h>
 
 #include <scsi/scsi.h>
diff -puN drivers/message/fusion/mptspi.c~remove-555-unneeded-includes-of-schedh drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/message/fusion/mptspi.c
@@ -54,7 +54,6 @@
 #include <linux/delay.h>	/* for mdelay */
 #include <linux/interrupt.h>	/* needed for in_interrupt() proto */
 #include <linux/reboot.h>	/* notifier code */
-#include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/raid_class.h>
 
diff -puN drivers/mmc/mmc_block.c~remove-555-unneeded-includes-of-schedh drivers/mmc/mmc_block.c
--- a/drivers/mmc/mmc_block.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mmc/mmc_block.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/errno.h>
diff -puN drivers/mtd/chips/cfi_util.c~remove-555-unneeded-includes-of-schedh drivers/mtd/chips/cfi_util.c
--- a/drivers/mtd/chips/cfi_util.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/chips/cfi_util.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
 
diff -puN drivers/mtd/devices/doc2001.c~remove-555-unneeded-includes-of-schedh drivers/mtd/devices/doc2001.c
--- a/drivers/mtd/devices/doc2001.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/devices/doc2001.c
@@ -16,7 +16,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/bitops.h>
diff -puN drivers/mtd/devices/doc2001plus.c~remove-555-unneeded-includes-of-schedh drivers/mtd/devices/doc2001plus.c
--- a/drivers/mtd/devices/doc2001plus.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/devices/doc2001plus.c
@@ -20,7 +20,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/bitops.h>
diff -puN drivers/mtd/devices/docecc.c~remove-555-unneeded-includes-of-schedh drivers/mtd/devices/docecc.c
--- a/drivers/mtd/devices/docecc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/devices/docecc.c
@@ -32,7 +32,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/types.h>
 
diff -puN drivers/mtd/devices/pmc551.c~remove-555-unneeded-includes-of-schedh drivers/mtd/devices/pmc551.c
--- a/drivers/mtd/devices/pmc551.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/devices/pmc551.c
@@ -86,7 +86,6 @@
 #include <linux/module.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
diff -puN drivers/mtd/devices/slram.c~remove-555-unneeded-includes-of-schedh drivers/mtd/devices/slram.c
--- a/drivers/mtd/devices/slram.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/devices/slram.c
@@ -35,7 +35,6 @@
 #include <asm/uaccess.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/mtd/ftl.c~remove-555-unneeded-includes-of-schedh drivers/mtd/ftl.c
--- a/drivers/mtd/ftl.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/ftl.c
@@ -61,7 +61,6 @@
 /*#define PSYCHO_DEBUG */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/mtd/inftlmount.c~remove-555-unneeded-includes-of-schedh drivers/mtd/inftlmount.c
--- a/drivers/mtd/inftlmount.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/inftlmount.c
@@ -34,7 +34,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nftl.h>
diff -puN drivers/mtd/mtdcore.c~remove-555-unneeded-includes-of-schedh drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/mtdcore.c
@@ -8,7 +8,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/mtd/nftlcore.c~remove-555-unneeded-includes-of-schedh drivers/mtd/nftlcore.c
--- a/drivers/mtd/nftlcore.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/mtd/nftlcore.c
@@ -20,7 +20,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/hdreg.h>
 
diff -puN drivers/net/arm/ether1.c~remove-555-unneeded-includes-of-schedh drivers/net/arm/ether1.c
--- a/drivers/net/arm/ether1.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/arm/ether1.c
@@ -33,7 +33,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/net/arm/ether3.c~remove-555-unneeded-includes-of-schedh drivers/net/arm/ether3.c
--- a/drivers/net/arm/ether3.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/arm/ether3.c
@@ -48,7 +48,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/net/arm/etherh.c~remove-555-unneeded-includes-of-schedh drivers/net/arm/etherh.c
--- a/drivers/net/arm/etherh.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/arm/etherh.c
@@ -28,7 +28,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/net/au1000_eth.c~remove-555-unneeded-includes-of-schedh drivers/net/au1000_eth.c
--- a/drivers/net/au1000_eth.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/au1000_eth.c
@@ -37,7 +37,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/errno.h>
diff -puN drivers/net/bonding/bond_main.c~remove-555-unneeded-includes-of-schedh drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/bonding/bond_main.c
@@ -35,7 +35,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
diff -puN drivers/net/bonding/bond_sysfs.c~remove-555-unneeded-includes-of-schedh drivers/net/bonding/bond_sysfs.c
--- a/drivers/net/bonding/bond_sysfs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/bonding/bond_sysfs.c
@@ -22,7 +22,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/sysdev.h>
 #include <linux/fs.h>
diff -puN drivers/net/cris/eth_v10.c~remove-555-unneeded-includes-of-schedh drivers/net/cris/eth_v10.c
--- a/drivers/net/cris/eth_v10.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/cris/eth_v10.c
@@ -222,7 +222,6 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
diff -puN drivers/net/fec_8xx/fec_8xx-netta.c~remove-555-unneeded-includes-of-schedh drivers/net/fec_8xx/fec_8xx-netta.c
--- a/drivers/net/fec_8xx/fec_8xx-netta.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/fec_8xx/fec_8xx-netta.c
@@ -4,7 +4,6 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
diff -puN drivers/net/fec_8xx/fec_main.c~remove-555-unneeded-includes-of-schedh drivers/net/fec_8xx/fec_main.c
--- a/drivers/net/fec_8xx/fec_main.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/fec_8xx/fec_main.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
diff -puN drivers/net/fec_8xx/fec_mii.c~remove-555-unneeded-includes-of-schedh drivers/net/fec_8xx/fec_mii.c
--- a/drivers/net/fec_8xx/fec_mii.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/fec_8xx/fec_mii.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
diff -puN drivers/net/fs_enet/fs_enet-main.c~remove-555-unneeded-includes-of-schedh drivers/net/fs_enet/fs_enet-main.c
--- a/drivers/net/fs_enet/fs_enet-main.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/fs_enet/fs_enet-main.c
@@ -18,7 +18,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
diff -puN drivers/net/fs_enet/mac-fcc.c~remove-555-unneeded-includes-of-schedh drivers/net/fs_enet/mac-fcc.c
--- a/drivers/net/fs_enet/mac-fcc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/fs_enet/mac-fcc.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
diff -puN drivers/net/fs_enet/mac-fec.c~remove-555-unneeded-includes-of-schedh drivers/net/fs_enet/mac-fec.c
--- a/drivers/net/fs_enet/mac-fec.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/fs_enet/mac-fec.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
diff -puN drivers/net/fs_enet/mac-scc.c~remove-555-unneeded-includes-of-schedh drivers/net/fs_enet/mac-scc.c
--- a/drivers/net/fs_enet/mac-scc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/fs_enet/mac-scc.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
diff -puN drivers/net/fs_enet/mii-bitbang.c~remove-555-unneeded-includes-of-schedh drivers/net/fs_enet/mii-bitbang.c
--- a/drivers/net/fs_enet/mii-bitbang.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/fs_enet/mii-bitbang.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
diff -puN drivers/net/fs_enet/mii-fec.c~remove-555-unneeded-includes-of-schedh drivers/net/fs_enet/mii-fec.c
--- a/drivers/net/fs_enet/mii-fec.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/fs_enet/mii-fec.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
diff -puN drivers/net/gianfar.c~remove-555-unneeded-includes-of-schedh drivers/net/gianfar.c
--- a/drivers/net/gianfar.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/gianfar.c
@@ -65,7 +65,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/gianfar_ethtool.c~remove-555-unneeded-includes-of-schedh drivers/net/gianfar_ethtool.c
--- a/drivers/net/gianfar_ethtool.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/gianfar_ethtool.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff -puN drivers/net/gianfar_mii.c~remove-555-unneeded-includes-of-schedh drivers/net/gianfar_mii.c
--- a/drivers/net/gianfar_mii.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/gianfar_mii.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/gianfar_sysfs.c~remove-555-unneeded-includes-of-schedh drivers/net/gianfar_sysfs.c
--- a/drivers/net/gianfar_sysfs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/gianfar_sysfs.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/ibm_emac/ibm_emac_core.c~remove-555-unneeded-includes-of-schedh drivers/net/ibm_emac/ibm_emac_core.c
--- a/drivers/net/ibm_emac/ibm_emac_core.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/ibm_emac/ibm_emac_core.c
@@ -21,7 +21,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
diff -puN drivers/net/irda/ma600-sir.c~remove-555-unneeded-includes-of-schedh drivers/net/irda/ma600-sir.c
--- a/drivers/net/irda/ma600-sir.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/irda/ma600-sir.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 
 #include <net/irda/irda.h>
 
diff -puN drivers/net/meth.c~remove-555-unneeded-includes-of-schedh drivers/net/meth.c
--- a/drivers/net/meth.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/meth.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
-#include <linux/sched.h>
 #include <linux/kernel.h> /* printk() */
 #include <linux/delay.h>
 #include <linux/slab.h>
diff -puN drivers/net/mipsnet.c~remove-555-unneeded-includes-of-schedh drivers/net/mipsnet.c
--- a/drivers/net/mipsnet.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/mipsnet.c
@@ -10,7 +10,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/sched.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
 #include <linux/platform_device.h>
diff -puN drivers/net/phy/cicada.c~remove-555-unneeded-includes-of-schedh drivers/net/phy/cicada.c
--- a/drivers/net/phy/cicada.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/phy/cicada.c
@@ -14,7 +14,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/phy/davicom.c~remove-555-unneeded-includes-of-schedh drivers/net/phy/davicom.c
--- a/drivers/net/phy/davicom.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/phy/davicom.c
@@ -14,7 +14,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/phy/fixed.c~remove-555-unneeded-includes-of-schedh drivers/net/phy/fixed.c
--- a/drivers/net/phy/fixed.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/phy/fixed.c
@@ -14,7 +14,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/phy/lxt.c~remove-555-unneeded-includes-of-schedh drivers/net/phy/lxt.c
--- a/drivers/net/phy/lxt.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/phy/lxt.c
@@ -14,7 +14,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/phy/marvell.c~remove-555-unneeded-includes-of-schedh drivers/net/phy/marvell.c
--- a/drivers/net/phy/marvell.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/phy/marvell.c
@@ -14,7 +14,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/phy/mdio_bus.c~remove-555-unneeded-includes-of-schedh drivers/net/phy/mdio_bus.c
--- a/drivers/net/phy/mdio_bus.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/phy/mdio_bus.c
@@ -14,7 +14,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/phy/phy.c~remove-555-unneeded-includes-of-schedh drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/phy/phy.c
@@ -16,7 +16,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/phy/phy_device.c~remove-555-unneeded-includes-of-schedh drivers/net/phy/phy_device.c
--- a/drivers/net/phy/phy_device.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/phy/phy_device.c
@@ -15,7 +15,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/phy/qsemi.c~remove-555-unneeded-includes-of-schedh drivers/net/phy/qsemi.c
--- a/drivers/net/phy/qsemi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/phy/qsemi.c
@@ -14,7 +14,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/net/qla3xxx.c~remove-555-unneeded-includes-of-schedh drivers/net/qla3xxx.c
--- a/drivers/net/qla3xxx.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/qla3xxx.c
@@ -12,7 +12,6 @@
 #include <linux/list.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/dmapool.h>
 #include <linux/mempool.h>
diff -puN drivers/net/s2io.c~remove-555-unneeded-includes-of-schedh drivers/net/s2io.c
--- a/drivers/net/s2io.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/s2io.c
@@ -59,7 +59,6 @@
 #include <linux/stddef.h>
 #include <linux/ioctl.h>
 #include <linux/timex.h>
-#include <linux/sched.h>
 #include <linux/ethtool.h>
 #include <linux/workqueue.h>
 #include <linux/if_vlan.h>
diff -puN drivers/net/sungem_phy.c~remove-555-unneeded-includes-of-schedh drivers/net/sungem_phy.c
--- a/drivers/net/sungem_phy.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/sungem_phy.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/net/tsi108_eth.c~remove-555-unneeded-includes-of-schedh drivers/net/tsi108_eth.c
--- a/drivers/net/tsi108_eth.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/tsi108_eth.c
@@ -38,7 +38,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/crc32.h>
diff -puN drivers/net/ucc_geth_phy.c~remove-555-unneeded-includes-of-schedh drivers/net/ucc_geth_phy.c
--- a/drivers/net/ucc_geth_phy.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/ucc_geth_phy.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff -puN drivers/net/wan/cycx_drv.c~remove-555-unneeded-includes-of-schedh drivers/net/wan/cycx_drv.c
--- a/drivers/net/wan/cycx_drv.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/wan/cycx_drv.c
@@ -53,7 +53,6 @@
 #include <linux/kernel.h>	/* printk(), and other useful stuff */
 #include <linux/stddef.h>	/* offsetof(), etc. */
 #include <linux/errno.h>	/* return codes */
-#include <linux/sched.h>	/* for jiffies, HZ, etc. */
 #include <linux/cycx_drv.h>	/* API definitions */
 #include <linux/cycx_cfm.h>	/* CYCX firmware module definitions */
 #include <linux/delay.h>	/* udelay, msleep_interruptible */
diff -puN drivers/net/wan/pci200syn.c~remove-555-unneeded-includes-of-schedh drivers/net/wan/pci200syn.c
--- a/drivers/net/wan/pci200syn.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/wan/pci200syn.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/in.h>
diff -puN drivers/net/wireless/atmel.c~remove-555-unneeded-includes-of-schedh drivers/net/wireless/atmel.c
--- a/drivers/net/wireless/atmel.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/wireless/atmel.c
@@ -42,7 +42,6 @@
 #include <linux/init.h>
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/net/wireless/bcm43xx/bcm43xx_wx.c~remove-555-unneeded-includes-of-schedh drivers/net/wireless/bcm43xx/bcm43xx_wx.c
--- a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
@@ -33,7 +33,6 @@
 #include <net/ieee80211softmac.h>
 #include <net/ieee80211softmac_wx.h>
 #include <linux/capability.h>
-#include <linux/sched.h> /* for capable() */
 #include <linux/delay.h>
 
 #include "bcm43xx.h"
diff -puN drivers/parisc/eisa.c~remove-555-unneeded-includes-of-schedh drivers/parisc/eisa.c
--- a/drivers/parisc/eisa.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/parisc/eisa.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/eisa.h>
 
diff -puN drivers/parport/parport_cs.c~remove-555-unneeded-includes-of-schedh drivers/parport/parport_cs.c
--- a/drivers/parport/parport_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/parport/parport_cs.c
@@ -37,7 +37,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/parport/parport_gsc.c~remove-555-unneeded-includes-of-schedh drivers/parport/parport_gsc.c
--- a/drivers/parport/parport_gsc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/parport/parport_gsc.c
@@ -23,7 +23,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
diff -puN drivers/pci/hotplug/ibmphp_ebda.c~remove-555-unneeded-includes-of-schedh drivers/pci/hotplug/ibmphp_ebda.c
--- a/drivers/pci/hotplug/ibmphp_ebda.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pci/hotplug/ibmphp_ebda.c
@@ -28,7 +28,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
diff -puN drivers/pci/syscall.c~remove-555-unneeded-includes-of-schedh drivers/pci/syscall.c
--- a/drivers/pci/syscall.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pci/syscall.c
@@ -7,7 +7,6 @@
  * magic northbridge registers..
  */
 
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/pci.h>
 #include <linux/smp_lock.h>
diff -puN drivers/pcmcia/at91_cf.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/at91_cf.c
--- a/drivers/pcmcia/at91_cf.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/at91_cf.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/platform_device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
diff -puN drivers/pcmcia/cistpl.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/cistpl.c
--- a/drivers/pcmcia/cistpl.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/cistpl.c
@@ -21,7 +21,6 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <asm/io.h>
diff -puN drivers/pcmcia/i82365.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/i82365.c
--- a/drivers/pcmcia/i82365.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/i82365.c
@@ -40,7 +40,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
diff -puN drivers/pcmcia/m32r_cfc.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/m32r_cfc.c
--- a/drivers/pcmcia/m32r_cfc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/m32r_cfc.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
diff -puN drivers/pcmcia/m32r_pcc.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/m32r_pcc.c
--- a/drivers/pcmcia/m32r_pcc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/m32r_pcc.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
diff -puN drivers/pcmcia/m8xx_pcmcia.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/m8xx_pcmcia.c
--- a/drivers/pcmcia/m8xx_pcmcia.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/m8xx_pcmcia.c
@@ -46,7 +46,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
 #include <linux/ioport.h>
diff -puN drivers/pcmcia/omap_cf.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/omap_cf.c
--- a/drivers/pcmcia/omap_cf.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/omap_cf.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/platform_device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
diff -puN drivers/pcmcia/pxa2xx_lubbock.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/pxa2xx_lubbock.c
--- a/drivers/pcmcia/pxa2xx_lubbock.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/pxa2xx_lubbock.c
@@ -16,7 +16,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
diff -puN drivers/pcmcia/sa1100_badge4.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/sa1100_badge4.c
--- a/drivers/pcmcia/sa1100_badge4.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/sa1100_badge4.c
@@ -14,7 +14,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
diff -puN drivers/pcmcia/sa1100_cerf.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/sa1100_cerf.c
--- a/drivers/pcmcia/sa1100_cerf.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/sa1100_cerf.c
@@ -7,7 +7,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff -puN drivers/pcmcia/sa1100_h3600.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/sa1100_h3600.c
--- a/drivers/pcmcia/sa1100_h3600.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/sa1100_h3600.c
@@ -6,7 +6,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
diff -puN drivers/pcmcia/sa1100_jornada720.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/sa1100_jornada720.c
--- a/drivers/pcmcia/sa1100_jornada720.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/sa1100_jornada720.c
@@ -6,7 +6,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
diff -puN drivers/pcmcia/sa1100_neponset.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/sa1100_neponset.c
--- a/drivers/pcmcia/sa1100_neponset.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/sa1100_neponset.c
@@ -5,7 +5,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
diff -puN drivers/pcmcia/sa1100_shannon.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/sa1100_shannon.c
--- a/drivers/pcmcia/sa1100_shannon.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/sa1100_shannon.c
@@ -6,7 +6,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/init.h>
 
diff -puN drivers/pcmcia/sa1100_simpad.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/sa1100_simpad.c
--- a/drivers/pcmcia/sa1100_simpad.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/sa1100_simpad.c
@@ -6,7 +6,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/init.h>
 
diff -puN drivers/pcmcia/vrc4171_card.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/vrc4171_card.c
--- a/drivers/pcmcia/vrc4171_card.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/vrc4171_card.c
@@ -22,7 +22,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
 
diff -puN drivers/pcmcia/yenta_socket.c~remove-555-unneeded-includes-of-schedh drivers/pcmcia/yenta_socket.c
--- a/drivers/pcmcia/yenta_socket.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/pcmcia/yenta_socket.c
@@ -12,7 +12,6 @@
  */
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
diff -puN drivers/rapidio/rio-sysfs.c~remove-555-unneeded-includes-of-schedh drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/rapidio/rio-sysfs.c
@@ -14,7 +14,6 @@
 #include <linux/rio.h>
 #include <linux/rio_drv.h>
 #include <linux/stat.h>
-#include <linux/sched.h>	/* for capable() */
 
 #include "rio.h"
 
diff -puN drivers/s390/char/sclp_tty.c~remove-555-unneeded-includes-of-schedh drivers/s390/char/sclp_tty.c
--- a/drivers/s390/char/sclp_tty.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/s390/char/sclp_tty.c
@@ -13,7 +13,6 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
-#include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
 #include <linux/err.h>
diff -puN drivers/s390/char/sclp_vt220.c~remove-555-unneeded-includes-of-schedh drivers/s390/char/sclp_vt220.c
--- a/drivers/s390/char/sclp_vt220.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/s390/char/sclp_vt220.c
@@ -16,7 +16,6 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/major.h>
diff -puN drivers/s390/net/ctcmain.c~remove-555-unneeded-includes-of-schedh drivers/s390/net/ctcmain.c
--- a/drivers/s390/net/ctcmain.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/s390/net/ctcmain.c
@@ -45,7 +45,6 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
-#include <linux/sched.h>
 #include <linux/bitops.h>
 
 #include <linux/signal.h>
diff -puN drivers/s390/net/netiucv.c~remove-555-unneeded-includes-of-schedh drivers/s390/net/netiucv.c
--- a/drivers/s390/net/netiucv.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/s390/net/netiucv.c
@@ -41,7 +41,6 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
-#include <linux/sched.h>
 #include <linux/bitops.h>
 
 #include <linux/signal.h>
diff -puN drivers/sbus/char/cpwatchdog.c~remove-555-unneeded-includes-of-schedh drivers/sbus/char/cpwatchdog.c
--- a/drivers/sbus/char/cpwatchdog.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/sbus/char/cpwatchdog.c
@@ -20,7 +20,6 @@
 #include <linux/major.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/timer.h>
diff -puN drivers/sbus/char/openprom.c~remove-555-unneeded-includes-of-schedh drivers/sbus/char/openprom.c
--- a/drivers/sbus/char/openprom.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/sbus/char/openprom.c
@@ -31,7 +31,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/sbus/char/uctrl.c~remove-555-unneeded-includes-of-schedh drivers/sbus/char/uctrl.c
--- a/drivers/sbus/char/uctrl.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/sbus/char/uctrl.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
diff -puN drivers/sbus/char/vfc_dev.c~remove-555-unneeded-includes-of-schedh drivers/sbus/char/vfc_dev.c
--- a/drivers/sbus/char/vfc_dev.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/sbus/char/vfc_dev.c
@@ -19,7 +19,6 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/smp_lock.h>
 #include <linux/delay.h>
diff -puN drivers/scsi/53c700.c~remove-555-unneeded-includes-of-schedh drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/53c700.c
@@ -121,7 +121,6 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/NCR53c406a.c~remove-555-unneeded-includes-of-schedh drivers/scsi/NCR53c406a.c
--- a/drivers/scsi/NCR53c406a.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/NCR53c406a.c
@@ -41,7 +41,6 @@
 
 #include <linux/errno.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
diff -puN drivers/scsi/a2091.c~remove-555-unneeded-includes-of-schedh drivers/scsi/a2091.c
--- a/drivers/scsi/a2091.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/a2091.c
@@ -1,7 +1,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 
diff -puN drivers/scsi/a3000.c~remove-555-unneeded-includes-of-schedh drivers/scsi/a3000.c
--- a/drivers/scsi/a3000.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/a3000.c
@@ -1,7 +1,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
diff -puN drivers/scsi/aacraid/aachba.c~remove-555-unneeded-includes-of-schedh drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/aacraid/aachba.c
@@ -26,7 +26,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/aacraid/commctrl.c~remove-555-unneeded-includes-of-schedh drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/aacraid/commctrl.c
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/aacraid/comminit.c~remove-555-unneeded-includes-of-schedh drivers/scsi/aacraid/comminit.c
--- a/drivers/scsi/aacraid/comminit.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/aacraid/comminit.c
@@ -32,7 +32,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/aacraid/dpcsup.c~remove-555-unneeded-includes-of-schedh drivers/scsi/aacraid/dpcsup.c
--- a/drivers/scsi/aacraid/dpcsup.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/aacraid/dpcsup.c
@@ -32,7 +32,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/aacraid/rx.c~remove-555-unneeded-includes-of-schedh drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/aacraid/rx.c
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/aacraid/sa.c~remove-555-unneeded-includes-of-schedh drivers/scsi/aacraid/sa.c
--- a/drivers/scsi/aacraid/sa.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/aacraid/sa.c
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/aha152x.c~remove-555-unneeded-includes-of-schedh drivers/scsi/aha152x.c
--- a/drivers/scsi/aha152x.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/aha152x.c
@@ -236,7 +236,6 @@
  **************************************************************************/
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <asm/irq.h>
 #include <linux/io.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/aic7xxx_old.c~remove-555-unneeded-includes-of-schedh drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/aic7xxx_old.c
@@ -229,7 +229,6 @@
 #include <linux/kernel.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/amiga7xx.c~remove-555-unneeded-includes-of-schedh drivers/scsi/amiga7xx.c
--- a/drivers/scsi/amiga7xx.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/amiga7xx.c
@@ -10,7 +10,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
 #include <linux/zorro.h>
 #include <linux/stat.h>
 
diff -puN drivers/scsi/arm/acornscsi.c~remove-555-unneeded-includes-of-schedh drivers/scsi/arm/acornscsi.c
--- a/drivers/scsi/arm/acornscsi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/arm/acornscsi.c
@@ -131,7 +131,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN drivers/scsi/arm/arxescsi.c~remove-555-unneeded-includes-of-schedh drivers/scsi/arm/arxescsi.c
--- a/drivers/scsi/arm/arxescsi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/arm/arxescsi.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/unistd.h>
 #include <linux/stat.h>
diff -puN drivers/scsi/arm/cumana_1.c~remove-555-unneeded-includes-of-schedh drivers/scsi/arm/cumana_1.c
--- a/drivers/scsi/arm/cumana_1.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/arm/cumana_1.c
@@ -5,7 +5,6 @@
  */
 #include <linux/module.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/arm/cumana_2.c~remove-555-unneeded-includes-of-schedh drivers/scsi/arm/cumana_2.c
--- a/drivers/scsi/arm/cumana_2.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/arm/cumana_2.c
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
diff -puN drivers/scsi/arm/ecoscsi.c~remove-555-unneeded-includes-of-schedh drivers/scsi/arm/ecoscsi.c
--- a/drivers/scsi/arm/ecoscsi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/arm/ecoscsi.c
@@ -23,7 +23,6 @@
 
 #include <linux/module.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/init.h>
diff -puN drivers/scsi/arm/eesox.c~remove-555-unneeded-includes-of-schedh drivers/scsi/arm/eesox.c
--- a/drivers/scsi/arm/eesox.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/arm/eesox.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
diff -puN drivers/scsi/arm/fas216.c~remove-555-unneeded-includes-of-schedh drivers/scsi/arm/fas216.c
--- a/drivers/scsi/arm/fas216.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/arm/fas216.c
@@ -39,7 +39,6 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
diff -puN drivers/scsi/arm/oak.c~remove-555-unneeded-includes-of-schedh drivers/scsi/arm/oak.c
--- a/drivers/scsi/arm/oak.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/arm/oak.c
@@ -6,7 +6,6 @@
 
 #include <linux/module.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/arm/powertec.c~remove-555-unneeded-includes-of-schedh drivers/scsi/arm/powertec.c
--- a/drivers/scsi/arm/powertec.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/arm/powertec.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
diff -puN drivers/scsi/atari_scsi.c~remove-555-unneeded-includes-of-schedh drivers/scsi/atari_scsi.c
--- a/drivers/scsi/atari_scsi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/atari_scsi.c
@@ -86,7 +86,6 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/nvram.h>
diff -puN drivers/scsi/bvme6000.c~remove-555-unneeded-includes-of-schedh drivers/scsi/bvme6000.c
--- a/drivers/scsi/bvme6000.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/bvme6000.c
@@ -6,7 +6,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
 #include <linux/zorro.h>
 
 #include <asm/setup.h>
diff -puN drivers/scsi/ch.c~remove-555-unneeded-includes-of-schedh drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/ch.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/major.h>
 #include <linux/string.h>
diff -puN drivers/scsi/dtc.c~remove-555-unneeded-includes-of-schedh drivers/scsi/dtc.c
--- a/drivers/scsi/dtc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/dtc.c
@@ -75,7 +75,6 @@
 #include <asm/system.h>
 #include <linux/module.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/stat.h>
diff -puN drivers/scsi/eata_pio.c~remove-555-unneeded-includes-of-schedh drivers/scsi/eata_pio.c
--- a/drivers/scsi/eata_pio.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/eata_pio.c
@@ -48,7 +48,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/g_NCR5380.c~remove-555-unneeded-includes-of-schedh drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/g_NCR5380.c
@@ -103,7 +103,6 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/blkdev.h>
 #include "scsi.h"
 #include <scsi/scsi_host.h>
diff -puN drivers/scsi/gdth.c~remove-555-unneeded-includes-of-schedh drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/gdth.c
@@ -387,7 +387,6 @@
 #include <linux/ctype.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/in.h>
 #include <linux/proc_fs.h>
diff -puN drivers/scsi/gvp11.c~remove-555-unneeded-includes-of-schedh drivers/scsi/gvp11.c
--- a/drivers/scsi/gvp11.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/gvp11.c
@@ -1,7 +1,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 
diff -puN drivers/scsi/initio.c~remove-555-unneeded-includes-of-schedh drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/initio.c
@@ -123,7 +123,6 @@
 #include <linux/string.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/dma-mapping.h>
diff -puN drivers/scsi/lasi700.c~remove-555-unneeded-includes-of-schedh drivers/scsi/lasi700.c
--- a/drivers/scsi/lasi700.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/lasi700.c
@@ -38,7 +38,6 @@
 #include <linux/stat.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/dma-mapping.h>
 
diff -puN drivers/scsi/mac_scsi.c~remove-555-unneeded-includes-of-schedh drivers/scsi/mac_scsi.c
--- a/drivers/scsi/mac_scsi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/mac_scsi.c
@@ -36,7 +36,6 @@
 
 #include <linux/module.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/mvme147.c~remove-555-unneeded-includes-of-schedh drivers/scsi/mvme147.c
--- a/drivers/scsi/mvme147.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/mvme147.c
@@ -1,7 +1,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 
 #include <asm/page.h>
diff -puN drivers/scsi/mvme16x.c~remove-555-unneeded-includes-of-schedh drivers/scsi/mvme16x.c
--- a/drivers/scsi/mvme16x.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/mvme16x.c
@@ -6,7 +6,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff -puN drivers/scsi/nsp32.c~remove-555-unneeded-includes-of-schedh drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/nsp32.c
@@ -27,7 +27,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff -puN drivers/scsi/pas16.c~remove-555-unneeded-includes-of-schedh drivers/scsi/pas16.c
--- a/drivers/scsi/pas16.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/pas16.c
@@ -116,7 +116,6 @@
 #include <asm/system.h>
 #include <linux/signal.h>
 #include <linux/proc_fs.h>
-#include <linux/sched.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/pcmcia/aha152x_stub.c~remove-555-unneeded-includes-of-schedh drivers/scsi/pcmcia/aha152x_stub.c
--- a/drivers/scsi/pcmcia/aha152x_stub.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/pcmcia/aha152x_stub.c
@@ -37,7 +37,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
diff -puN drivers/scsi/pcmcia/fdomain_stub.c~remove-555-unneeded-includes-of-schedh drivers/scsi/pcmcia/fdomain_stub.c
--- a/drivers/scsi/pcmcia/fdomain_stub.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/pcmcia/fdomain_stub.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
diff -puN drivers/scsi/pcmcia/nsp_cs.c~remove-555-unneeded-includes-of-schedh drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/pcmcia/nsp_cs.c
@@ -31,7 +31,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff -puN drivers/scsi/pcmcia/qlogic_stub.c~remove-555-unneeded-includes-of-schedh drivers/scsi/pcmcia/qlogic_stub.c
--- a/drivers/scsi/pcmcia/qlogic_stub.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/pcmcia/qlogic_stub.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
diff -puN drivers/scsi/pcmcia/sym53c500_cs.c~remove-555-unneeded-includes-of-schedh drivers/scsi/pcmcia/sym53c500_cs.c
--- a/drivers/scsi/pcmcia/sym53c500_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -54,7 +54,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
diff -puN drivers/scsi/qla1280.c~remove-555-unneeded-includes-of-schedh drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/qla1280.c
@@ -341,7 +341,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/timer.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
diff -puN drivers/scsi/scsi.c~remove-555-unneeded-includes-of-schedh drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/scsi.c
@@ -40,7 +40,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/scsi_debug.c~remove-555-unneeded-includes-of-schedh drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/scsi_debug.c
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
 #include <linux/types.h>
diff -puN drivers/scsi/scsi_transport_fc.c~remove-555-unneeded-includes-of-schedh drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/scsi_transport_fc.c
@@ -26,7 +26,6 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>	/* workqueue stuff, HZ */
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
diff -puN drivers/scsi/sd.c~remove-555-unneeded-includes-of-schedh drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/sd.c
@@ -35,7 +35,6 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/bio.h>
 #include <linux/genhd.h>
diff -puN drivers/scsi/sr.c~remove-555-unneeded-includes-of-schedh drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/sr.c
@@ -35,7 +35,6 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/bio.h>
 #include <linux/string.h>
diff -puN drivers/scsi/sr_ioctl.c~remove-555-unneeded-includes-of-schedh drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/sr_ioctl.c
@@ -1,5 +1,4 @@
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/errno.h>
diff -puN drivers/scsi/stex.c~remove-555-unneeded-includes-of-schedh drivers/scsi/stex.c
--- a/drivers/scsi/stex.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/stex.c
@@ -17,7 +17,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/pci.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/sun3_scsi.c~remove-555-unneeded-includes-of-schedh drivers/scsi/sun3_scsi.c
--- a/drivers/scsi/sun3_scsi.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/sun3_scsi.c
@@ -58,7 +58,6 @@
 
 #include <linux/module.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/sun3_scsi_vme.c~remove-555-unneeded-includes-of-schedh drivers/scsi/sun3_scsi_vme.c
--- a/drivers/scsi/sun3_scsi_vme.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/sun3_scsi_vme.c
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/sym53c416.c~remove-555-unneeded-includes-of-schedh drivers/scsi/sym53c416.c
--- a/drivers/scsi/sym53c416.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/sym53c416.c
@@ -32,7 +32,6 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
diff -puN drivers/scsi/t128.c~remove-555-unneeded-includes-of-schedh drivers/scsi/t128.c
--- a/drivers/scsi/t128.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/t128.c
@@ -108,7 +108,6 @@
 
 #include <asm/system.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/io.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
diff -puN drivers/scsi/tmscsim.c~remove-555-unneeded-includes-of-schedh drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/tmscsim.c
@@ -223,7 +223,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
diff -puN drivers/scsi/wd33c93.c~remove-555-unneeded-includes-of-schedh drivers/scsi/wd33c93.c
--- a/drivers/scsi/wd33c93.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/scsi/wd33c93.c
@@ -73,7 +73,6 @@
 
 #include <linux/module.h>
 
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/init.h>
diff -puN drivers/serial/8250_pci.c~remove-555-unneeded-includes-of-schedh drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/serial/8250_pci.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff -puN drivers/serial/icom.c~remove-555-unneeded-includes-of-schedh drivers/serial/icom.c
--- a/drivers/serial/icom.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/serial/icom.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
diff -puN drivers/serial/ip22zilog.c~remove-555-unneeded-includes-of-schedh drivers/serial/ip22zilog.c
--- a/drivers/serial/ip22zilog.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/serial/ip22zilog.c
@@ -14,7 +14,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/tty.h>
diff -puN drivers/serial/serial_cs.c~remove-555-unneeded-includes-of-schedh drivers/serial/serial_cs.c
--- a/drivers/serial/serial_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/serial/serial_cs.c
@@ -35,7 +35,6 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/serial/sunsab.c~remove-555-unneeded-includes-of-schedh drivers/serial/sunsab.c
--- a/drivers/serial/sunsab.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/serial/sunsab.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
diff -puN drivers/serial/sunsu.c~remove-555-unneeded-includes-of-schedh drivers/serial/sunsu.c
--- a/drivers/serial/sunsu.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/serial/sunsu.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
diff -puN drivers/serial/sunzilog.c~remove-555-unneeded-includes-of-schedh drivers/serial/sunzilog.c
--- a/drivers/serial/sunzilog.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/serial/sunzilog.c
@@ -14,7 +14,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/tty.h>
diff -puN drivers/tc/lk201.c~remove-555-unneeded-includes-of-schedh drivers/tc/lk201.c
--- a/drivers/tc/lk201.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/tc/lk201.c
@@ -10,7 +10,6 @@
 
 
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff -puN drivers/telephony/ixj_pcmcia.c~remove-555-unneeded-includes-of-schedh drivers/telephony/ixj_pcmcia.c
--- a/drivers/telephony/ixj_pcmcia.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/telephony/ixj_pcmcia.c
@@ -3,7 +3,6 @@
 #include <linux/module.h>
 
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/kernel.h>	/* printk() */
 #include <linux/fs.h>		/* everything... */
 #include <linux/errno.h>	/* error codes */
diff -puN drivers/usb/gadget/at91_udc.c~remove-555-unneeded-includes-of-schedh drivers/usb/gadget/at91_udc.c
--- a/drivers/usb/gadget/at91_udc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/gadget/at91_udc.c
@@ -30,7 +30,6 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
diff -puN drivers/usb/gadget/dummy_hcd.c~remove-555-unneeded-includes-of-schedh drivers/usb/gadget/dummy_hcd.c
--- a/drivers/usb/gadget/dummy_hcd.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/gadget/dummy_hcd.c
@@ -40,7 +40,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
diff -puN drivers/usb/gadget/ether.c~remove-555-unneeded-includes-of-schedh drivers/usb/gadget/ether.c
--- a/drivers/usb/gadget/ether.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/gadget/ether.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
diff -puN drivers/usb/gadget/goku_udc.c~remove-555-unneeded-includes-of-schedh drivers/usb/gadget/goku_udc.c
--- a/drivers/usb/gadget/goku_udc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/gadget/goku_udc.c
@@ -29,7 +29,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
diff -puN drivers/usb/gadget/net2280.c~remove-555-unneeded-includes-of-schedh drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/gadget/net2280.c
@@ -53,7 +53,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
diff -puN drivers/usb/gadget/omap_udc.c~remove-555-unneeded-includes-of-schedh drivers/usb/gadget/omap_udc.c
--- a/drivers/usb/gadget/omap_udc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/gadget/omap_udc.c
@@ -28,7 +28,6 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/gadget/pxa2xx_udc.c~remove-555-unneeded-includes-of-schedh drivers/usb/gadget/pxa2xx_udc.c
--- a/drivers/usb/gadget/pxa2xx_udc.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/gadget/pxa2xx_udc.c
@@ -33,7 +33,6 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/gadget/serial.c~remove-555-unneeded-includes-of-schedh drivers/usb/gadget/serial.c
--- a/drivers/usb/gadget/serial.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/gadget/serial.c
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
diff -puN drivers/usb/gadget/zero.c~remove-555-unneeded-includes-of-schedh drivers/usb/gadget/zero.c
--- a/drivers/usb/gadget/zero.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/gadget/zero.c
@@ -66,7 +66,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
diff -puN drivers/usb/host/hc_crisv10.c~remove-555-unneeded-includes-of-schedh drivers/usb/host/hc_crisv10.c
--- a/drivers/usb/host/hc_crisv10.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/host/hc_crisv10.c
@@ -7,7 +7,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/usb/host/sl811_cs.c~remove-555-unneeded-includes-of-schedh drivers/usb/host/sl811_cs.c
--- a/drivers/usb/host/sl811_cs.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/host/sl811_cs.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff -puN drivers/usb/host/uhci-hcd.c~remove-555-unneeded-includes-of-schedh drivers/usb/host/uhci-hcd.c
--- a/drivers/usb/host/uhci-hcd.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/host/uhci-hcd.c
@@ -28,7 +28,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
diff -puN drivers/usb/image/microtek.c~remove-555-unneeded-includes-of-schedh drivers/usb/image/microtek.c
--- a/drivers/usb/image/microtek.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/image/microtek.c
@@ -121,7 +121,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/random.h>
diff -puN drivers/usb/input/aiptek.c~remove-555-unneeded-includes-of-schedh drivers/usb/input/aiptek.c
--- a/drivers/usb/input/aiptek.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/input/aiptek.c
@@ -76,7 +76,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/usb/input.h>
-#include <linux/sched.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
diff -puN drivers/usb/input/hid-core.c~remove-555-unneeded-includes-of-schedh drivers/usb/input/hid-core.c
--- a/drivers/usb/input/hid-core.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/input/hid-core.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/smp_lock.h>
diff -puN drivers/usb/input/hid-pidff.c~remove-555-unneeded-includes-of-schedh drivers/usb/input/hid-pidff.c
--- a/drivers/usb/input/hid-pidff.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/input/hid-pidff.c
@@ -24,7 +24,6 @@
 
 #define debug(format, arg...) pr_debug("hid-pidff: " format "\n" , ## arg)
 
-#include <linux/sched.h>
 #include <linux/input.h>
 #include <linux/usb.h>
 
diff -puN drivers/usb/misc/sisusbvga/sisusb.c~remove-555-unneeded-includes-of-schedh drivers/usb/misc/sisusbvga/sisusb.c
--- a/drivers/usb/misc/sisusbvga/sisusb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/misc/sisusbvga/sisusb.c
@@ -40,7 +40,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/poll.h>
 #include <linux/init.h>
diff -puN drivers/usb/misc/sisusbvga/sisusb_con.c~remove-555-unneeded-includes-of-schedh drivers/usb/misc/sisusbvga/sisusb_con.c
--- a/drivers/usb/misc/sisusbvga/sisusb_con.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/misc/sisusbvga/sisusb_con.c
@@ -51,7 +51,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/tty.h>
 #include <linux/console.h>
diff -puN drivers/usb/net/asix.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/asix.c
--- a/drivers/usb/net/asix.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/asix.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/kmod.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/usb/net/cdc_ether.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/cdc_ether.c
--- a/drivers/usb/net/cdc_ether.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/cdc_ether.c
@@ -22,7 +22,6 @@
 // #define	VERBOSE			// more; success messages
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/usb/net/cdc_subset.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/cdc_subset.c
--- a/drivers/usb/net/cdc_subset.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/cdc_subset.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 #include <linux/kmod.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/usb/net/gl620a.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/gl620a.c
--- a/drivers/usb/net/gl620a.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/gl620a.c
@@ -22,7 +22,6 @@
 // #define	VERBOSE			// more; success messages
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/usb/net/kaweth.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/kaweth.c
--- a/drivers/usb/net/kaweth.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/kaweth.c
@@ -46,7 +46,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/init.h>
diff -puN drivers/usb/net/net1080.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/net1080.c
--- a/drivers/usb/net/net1080.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/net1080.c
@@ -21,7 +21,6 @@
 // #define	VERBOSE			// more; success messages
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/usb/net/plusb.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/plusb.c
--- a/drivers/usb/net/plusb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/plusb.c
@@ -21,7 +21,6 @@
 // #define	VERBOSE			// more; success messages
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/usb/net/rndis_host.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/rndis_host.c
--- a/drivers/usb/net/rndis_host.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/rndis_host.c
@@ -21,7 +21,6 @@
 // #define	VERBOSE			// more; success messages
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/usb/net/rtl8150.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/rtl8150.c
--- a/drivers/usb/net/rtl8150.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/rtl8150.c
@@ -6,7 +6,6 @@
  * version 2 as published by the Free Software Foundation.
  */
 
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
diff -puN drivers/usb/net/usbnet.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/usbnet.c
--- a/drivers/usb/net/usbnet.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/usbnet.c
@@ -34,7 +34,6 @@
 // #define	VERBOSE			// more; success messages
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/usb/net/zaurus.c~remove-555-unneeded-includes-of-schedh drivers/usb/net/zaurus.c
--- a/drivers/usb/net/zaurus.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/net/zaurus.c
@@ -21,7 +21,6 @@
 // #define	VERBOSE			// more; success messages
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
diff -puN drivers/usb/storage/datafab.c~remove-555-unneeded-includes-of-schedh drivers/usb/storage/datafab.c
--- a/drivers/usb/storage/datafab.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/storage/datafab.c
@@ -50,7 +50,6 @@
  * in that routine.
  */
 
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 
diff -puN drivers/usb/storage/initializers.c~remove-555-unneeded-includes-of-schedh drivers/usb/storage/initializers.c
--- a/drivers/usb/storage/initializers.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/storage/initializers.c
@@ -37,7 +37,6 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/sched.h>
 #include <linux/errno.h>
 
 #include "usb.h"
diff -puN drivers/usb/storage/jumpshot.c~remove-555-unneeded-includes-of-schedh drivers/usb/storage/jumpshot.c
--- a/drivers/usb/storage/jumpshot.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/storage/jumpshot.c
@@ -47,7 +47,6 @@
   * in that routine.
   */
 
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 
diff -puN drivers/usb/storage/sddr09.c~remove-555-unneeded-includes-of-schedh drivers/usb/storage/sddr09.c
--- a/drivers/usb/storage/sddr09.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/storage/sddr09.c
@@ -41,7 +41,6 @@
  * EF: compute checksum (?)
  */
 
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 
diff -puN drivers/usb/storage/shuttle_usbat.c~remove-555-unneeded-includes-of-schedh drivers/usb/storage/shuttle_usbat.c
--- a/drivers/usb/storage/shuttle_usbat.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/usb/storage/shuttle_usbat.c
@@ -43,7 +43,6 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/cdrom.h>
diff -puN drivers/video/atafb.c~remove-555-unneeded-includes-of-schedh drivers/video/atafb.c
--- a/drivers/video/atafb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/atafb.c
@@ -49,7 +49,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff -puN drivers/video/aty/mach64_accel.c~remove-555-unneeded-includes-of-schedh drivers/video/aty/mach64_accel.c
--- a/drivers/video/aty/mach64_accel.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/aty/mach64_accel.c
@@ -3,7 +3,6 @@
  *  ATI Mach64 Hardware Acceleration
  */
 
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <video/mach64.h>
diff -puN drivers/video/aty/mach64_gx.c~remove-555-unneeded-includes-of-schedh drivers/video/aty/mach64_gx.c
--- a/drivers/video/aty/mach64_gx.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/aty/mach64_gx.c
@@ -5,7 +5,6 @@
 
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/sched.h>
 
 #include <asm/io.h>
 
diff -puN drivers/video/aty/radeon_i2c.c~remove-555-unneeded-includes-of-schedh drivers/video/aty/radeon_i2c.c
--- a/drivers/video/aty/radeon_i2c.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/aty/radeon_i2c.c
@@ -1,6 +1,5 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/fb.h>
diff -puN drivers/video/console/fbcon.c~remove-555-unneeded-includes-of-schedh drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/console/fbcon.c
@@ -60,7 +60,6 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>	/* MSch: for IRQ probe */
diff -puN drivers/video/console/mdacon.c~remove-555-unneeded-includes-of-schedh drivers/video/console/mdacon.c
--- a/drivers/video/console/mdacon.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/console/mdacon.c
@@ -27,7 +27,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff -puN drivers/video/console/vgacon.c~remove-555-unneeded-includes-of-schedh drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/console/vgacon.c
@@ -35,7 +35,6 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/console.h>
diff -puN drivers/video/fbmem.c~remove-555-unneeded-includes-of-schedh drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/fbmem.c
@@ -16,7 +16,6 @@
 #include <linux/compat.h>
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/major.h>
diff -puN drivers/video/g364fb.c~remove-555-unneeded-includes-of-schedh drivers/video/g364fb.c
--- a/drivers/video/g364fb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/g364fb.c
@@ -16,7 +16,6 @@
 
 #include <linux/module.h>
 #include <linux/console.h>
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/string.h>
diff -puN drivers/video/hitfb.c~remove-555-unneeded-includes-of-schedh drivers/video/hitfb.c
--- a/drivers/video/hitfb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/hitfb.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff -puN drivers/video/hpfb.c~remove-555-unneeded-includes-of-schedh drivers/video/hpfb.c
--- a/drivers/video/hpfb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/hpfb.c
@@ -7,7 +7,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff -puN drivers/video/i810/i810-i2c.c~remove-555-unneeded-includes-of-schedh drivers/video/i810/i810-i2c.c
--- a/drivers/video/i810/i810-i2c.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/i810/i810-i2c.c
@@ -10,7 +10,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/fb.h>
diff -puN drivers/video/imxfb.c~remove-555-unneeded-includes-of-schedh drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/imxfb.c
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/interrupt.h>
diff -puN drivers/video/intelfb/intelfb_i2c.c~remove-555-unneeded-includes-of-schedh drivers/video/intelfb/intelfb_i2c.c
--- a/drivers/video/intelfb/intelfb_i2c.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/intelfb/intelfb_i2c.c
@@ -27,7 +27,6 @@ USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/fb.h>
diff -puN drivers/video/kyro/fbdev.c~remove-555-unneeded-includes-of-schedh drivers/video/kyro/fbdev.c
--- a/drivers/video/kyro/fbdev.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/kyro/fbdev.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/string.h>
diff -puN drivers/video/macfb.c~remove-555-unneeded-includes-of-schedh drivers/video/macfb.c
--- a/drivers/video/macfb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/macfb.c
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff -puN drivers/video/maxinefb.c~remove-555-unneeded-includes-of-schedh drivers/video/maxinefb.c
--- a/drivers/video/maxinefb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/maxinefb.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff -puN drivers/video/modedb.c~remove-555-unneeded-includes-of-schedh drivers/video/modedb.c
--- a/drivers/video/modedb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/modedb.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/fb.h>
-#include <linux/sched.h>
 
 #undef DEBUG
 
diff -puN drivers/video/nvidia/nv_i2c.c~remove-555-unneeded-includes-of-schedh drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/fb.h>
diff -puN drivers/video/nvidia/nv_of.c~remove-555-unneeded-includes-of-schedh drivers/video/nvidia/nv_of.c
--- a/drivers/video/nvidia/nv_of.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/nvidia/nv_of.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/fb.h>
diff -puN drivers/video/pmag-aa-fb.c~remove-555-unneeded-includes-of-schedh drivers/video/pmag-aa-fb.c
--- a/drivers/video/pmag-aa-fb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/pmag-aa-fb.c
@@ -24,7 +24,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff -puN drivers/video/riva/rivafb-i2c.c~remove-555-unneeded-includes-of-schedh drivers/video/riva/rivafb-i2c.c
--- a/drivers/video/riva/rivafb-i2c.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/riva/rivafb-i2c.c
@@ -14,7 +14,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/fb.h>
diff -puN drivers/video/savage/savagefb-i2c.c~remove-555-unneeded-includes-of-schedh drivers/video/savage/savagefb-i2c.c
--- a/drivers/video/savage/savagefb-i2c.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/savage/savagefb-i2c.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/fb.h>
diff -puN drivers/video/tgafb.c~remove-555-unneeded-includes-of-schedh drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~remove-555-unneeded-includes-of-schedh
+++ a/drivers/video/tgafb.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff -puN fs/afs/cell.c~remove-555-unneeded-includes-of-schedh fs/afs/cell.c
--- a/fs/afs/cell.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/afs/cell.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <rxrpc/peer.h>
 #include <rxrpc/connection.h>
diff -puN fs/afs/dir.c~remove-555-unneeded-includes-of-schedh fs/afs/dir.c
--- a/fs/afs/dir.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/afs/dir.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
diff -puN fs/afs/file.c~remove-555-unneeded-includes-of-schedh fs/afs/file.c
--- a/fs/afs/file.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/afs/file.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
diff -puN fs/afs/inode.c~remove-555-unneeded-includes-of-schedh fs/afs/inode.c
--- a/fs/afs/inode.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/afs/inode.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
diff -puN fs/afs/main.c~remove-555-unneeded-includes-of-schedh fs/afs/main.c
--- a/fs/afs/main.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/afs/main.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/completion.h>
 #include <rxrpc/rxrpc.h>
 #include <rxrpc/transport.h>
diff -puN fs/afs/mntpt.c~remove-555-unneeded-includes-of-schedh fs/afs/mntpt.c
--- a/fs/afs/mntpt.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/afs/mntpt.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
diff -puN fs/afs/proc.c~remove-555-unneeded-includes-of-schedh fs/afs/proc.c
--- a/fs/afs/proc.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/afs/proc.c
@@ -9,7 +9,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
diff -puN fs/ecryptfs/keystore.c~remove-555-unneeded-includes-of-schedh fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/ecryptfs/keystore.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/string.h>
-#include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/key.h>
diff -puN fs/ext3/hash.c~remove-555-unneeded-includes-of-schedh fs/ext3/hash.c
--- a/fs/ext3/hash.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/ext3/hash.c
@@ -11,7 +11,6 @@
 
 #include <linux/fs.h>
 #include <linux/jbd.h>
-#include <linux/sched.h>
 #include <linux/ext3_fs.h>
 #include <linux/cryptohash.h>
 
diff -puN fs/ext3/resize.c~remove-555-unneeded-includes-of-schedh fs/ext3/resize.c
--- a/fs/ext3/resize.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/ext3/resize.c
@@ -11,7 +11,6 @@
 
 #define EXT3FS_DEBUG
 
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/ext3_jbd.h>
 
diff -puN fs/ext4/hash.c~remove-555-unneeded-includes-of-schedh fs/ext4/hash.c
--- a/fs/ext4/hash.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/ext4/hash.c
@@ -11,7 +11,6 @@
 
 #include <linux/fs.h>
 #include <linux/jbd2.h>
-#include <linux/sched.h>
 #include <linux/ext4_fs.h>
 #include <linux/cryptohash.h>
 
diff -puN fs/ext4/resize.c~remove-555-unneeded-includes-of-schedh fs/ext4/resize.c
--- a/fs/ext4/resize.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/ext4/resize.c
@@ -11,7 +11,6 @@
 
 #define EXT4FS_DEBUG
 
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/ext4_jbd2.h>
 
diff -puN fs/filesystems.c~remove-555-unneeded-includes-of-schedh fs/filesystems.c
--- a/fs/filesystems.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/filesystems.c
@@ -12,7 +12,6 @@
 #include <linux/kmod.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/sched.h>	/* for 'current' */
 #include <asm/uaccess.h>
 
 /*
diff -puN fs/gfs2/bmap.c~remove-555-unneeded-includes-of-schedh fs/gfs2/bmap.c
--- a/fs/gfs2/bmap.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/bmap.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/dir.c~remove-555-unneeded-includes-of-schedh fs/gfs2/dir.c
--- a/fs/gfs2/dir.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/dir.c
@@ -53,7 +53,6 @@
  * but never before the maximum hash table size has been reached.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/buffer_head.h>
diff -puN fs/gfs2/eaops.c~remove-555-unneeded-includes-of-schedh fs/gfs2/eaops.c
--- a/fs/gfs2/eaops.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/eaops.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/eattr.c~remove-555-unneeded-includes-of-schedh fs/gfs2/eattr.c
--- a/fs/gfs2/eattr.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/eattr.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/glops.c~remove-555-unneeded-includes-of-schedh fs/gfs2/glops.c
--- a/fs/gfs2/glops.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/glops.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/lm.c~remove-555-unneeded-includes-of-schedh fs/gfs2/lm.c
--- a/fs/gfs2/lm.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/lm.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/main.c~remove-555-unneeded-includes-of-schedh fs/gfs2/main.c
--- a/fs/gfs2/main.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/main.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/mount.c~remove-555-unneeded-includes-of-schedh fs/gfs2/mount.c
--- a/fs/gfs2/mount.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/mount.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/ondisk.c~remove-555-unneeded-includes-of-schedh fs/gfs2/ondisk.c
--- a/fs/gfs2/ondisk.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/ondisk.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/ops_dentry.c~remove-555-unneeded-includes-of-schedh fs/gfs2/ops_dentry.c
--- a/fs/gfs2/ops_dentry.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/ops_dentry.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/ops_export.c~remove-555-unneeded-includes-of-schedh fs/gfs2/ops_export.c
--- a/fs/gfs2/ops_export.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/ops_export.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/ops_file.c~remove-555-unneeded-includes-of-schedh fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/ops_file.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/ops_inode.c~remove-555-unneeded-includes-of-schedh fs/gfs2/ops_inode.c
--- a/fs/gfs2/ops_inode.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/ops_inode.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/ops_vm.c~remove-555-unneeded-includes-of-schedh fs/gfs2/ops_vm.c
--- a/fs/gfs2/ops_vm.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/ops_vm.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/recovery.c~remove-555-unneeded-includes-of-schedh fs/gfs2/recovery.c
--- a/fs/gfs2/recovery.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/recovery.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/rgrp.c~remove-555-unneeded-includes-of-schedh fs/gfs2/rgrp.c
--- a/fs/gfs2/rgrp.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/rgrp.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/gfs2/util.c~remove-555-unneeded-includes-of-schedh fs/gfs2/util.c
--- a/fs/gfs2/util.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/gfs2/util.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License version 2.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff -puN fs/hfsplus/catalog.c~remove-555-unneeded-includes-of-schedh fs/hfsplus/catalog.c
--- a/fs/hfsplus/catalog.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/hfsplus/catalog.c
@@ -8,7 +8,6 @@
  * Handling of catalog records
  */
 
-#include <linux/sched.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
diff -puN fs/hfsplus/dir.c~remove-555-unneeded-includes-of-schedh fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/hfsplus/dir.c
@@ -10,7 +10,6 @@
 
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 
diff -puN fs/hfsplus/super.c~remove-555-unneeded-includes-of-schedh fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/hfsplus/super.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/fs.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/nls.h>
diff -puN fs/jffs2/compr_zlib.c~remove-555-unneeded-includes-of-schedh fs/jffs2/compr_zlib.c
--- a/fs/jffs2/compr_zlib.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/jffs2/compr_zlib.c
@@ -16,7 +16,6 @@
 #endif
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
 #include <linux/zutil.h>
diff -puN fs/jffs2/dir.c~remove-555-unneeded-includes-of-schedh fs/jffs2/dir.c
--- a/fs/jffs2/dir.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/jffs2/dir.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/crc32.h>
 #include <linux/jffs2.h>
diff -puN fs/jffs2/summary.c~remove-555-unneeded-includes-of-schedh fs/jffs2/summary.c
--- a/fs/jffs2/summary.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/jffs2/summary.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/mtd/mtd.h>
 #include <linux/pagemap.h>
diff -puN fs/lockd/host.c~remove-555-unneeded-includes-of-schedh fs/lockd/host.c
--- a/fs/lockd/host.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/lockd/host.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/in.h>
 #include <linux/sunrpc/clnt.h>
diff -puN fs/nfs/nfs4renewd.c~remove-555-unneeded-includes-of-schedh fs/nfs/nfs4renewd.c
--- a/fs/nfs/nfs4renewd.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/nfs/nfs4renewd.c
@@ -43,7 +43,6 @@
  * child task framework of the RPC layer?
  */
 
-#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
diff -puN fs/nfsd/export.c~remove-555-unneeded-includes-of-schedh fs/nfsd/export.c
--- a/fs/nfsd/export.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/nfsd/export.c
@@ -16,7 +16,6 @@
 
 #include <linux/unistd.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/in.h>
 #include <linux/seq_file.h>
diff -puN fs/nfsd/nfs4idmap.c~remove-555-unneeded-includes-of-schedh fs/nfsd/nfs4idmap.c
--- a/fs/nfsd/nfs4idmap.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/nfsd/nfs4idmap.c
@@ -50,7 +50,6 @@
 #include <linux/sunrpc/cache.h>
 #include <linux/nfsd_idmap.h>
 #include <linux/list.h>
-#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/seq_file.h>
 #include <linux/sunrpc/svcauth.h>
diff -puN fs/nfsd/nfsfh.c~remove-555-unneeded-includes-of-schedh fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/nfsd/nfsfh.c
@@ -9,7 +9,6 @@
  * ... and again Southern-Winter 2001 to support export_operations
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
diff -puN fs/smbfs/symlink.c~remove-555-unneeded-includes-of-schedh fs/smbfs/symlink.c
--- a/fs/smbfs/symlink.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/smbfs/symlink.c
@@ -6,7 +6,6 @@
  *  Please add a note about your changes to smbfs in the ChangeLog file.
  */
 
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/fcntl.h>
diff -puN fs/ufs/balloc.c~remove-555-unneeded-includes-of-schedh fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/ufs/balloc.c
@@ -14,7 +14,6 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
-#include <linux/sched.h>
 #include <linux/bitops.h>
 #include <asm/byteorder.h>
 
diff -puN fs/ufs/dir.c~remove-555-unneeded-includes-of-schedh fs/ufs/dir.c
--- a/fs/ufs/dir.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/ufs/dir.c
@@ -20,7 +20,6 @@
 #include <linux/fs.h>
 #include <linux/ufs_fs.h>
 #include <linux/smp_lock.h>
-#include <linux/sched.h>
 
 #include "swab.h"
 #include "util.h"
diff -puN fs/xattr_acl.c~remove-555-unneeded-includes-of-schedh fs/xattr_acl.c
--- a/fs/xattr_acl.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/xattr_acl.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/posix_acl_xattr.h>
diff -puN fs/xfs/linux-2.6/kmem.c~remove-555-unneeded-includes-of-schedh fs/xfs/linux-2.6/kmem.c
--- a/fs/xfs/linux-2.6/kmem.c~remove-555-unneeded-includes-of-schedh
+++ a/fs/xfs/linux-2.6/kmem.c
@@ -15,7 +15,6 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
diff -puN init/calibrate.c~remove-555-unneeded-includes-of-schedh init/calibrate.c
--- a/init/calibrate.c~remove-555-unneeded-includes-of-schedh
+++ a/init/calibrate.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
-#include <linux/sched.h>
+#include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 
diff -puN init/version.c~remove-555-unneeded-includes-of-schedh init/version.c
--- a/init/version.c~remove-555-unneeded-includes-of-schedh
+++ a/init/version.c
@@ -12,7 +12,6 @@
 #include <linux/utsname.h>
 #include <linux/utsrelease.h>
 #include <linux/version.h>
-#include <linux/sched.h>
 
 #define version(a) Version_ ## a
 #define version_string(a) version(a)
diff -puN kernel/lockdep_proc.c~remove-555-unneeded-includes-of-schedh kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~remove-555-unneeded-includes-of-schedh
+++ a/kernel/lockdep_proc.c
@@ -10,7 +10,6 @@
  * Code for /proc/lockdep and /proc/lockdep_stats:
  *
  */
-#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff -puN kernel/mutex-debug.c~remove-555-unneeded-includes-of-schedh kernel/mutex-debug.c
--- a/kernel/mutex-debug.c~remove-555-unneeded-includes-of-schedh
+++ a/kernel/mutex-debug.c
@@ -13,7 +13,6 @@
  *  Released under the General Public License (GPL).
  */
 #include <linux/mutex.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/poison.h>
diff -puN kernel/resource.c~remove-555-unneeded-includes-of-schedh kernel/resource.c
--- a/kernel/resource.c~remove-555-unneeded-includes-of-schedh
+++ a/kernel/resource.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
diff -puN net/802/fc.c~remove-555-unneeded-includes-of-schedh net/802/fc.c
--- a/net/802/fc.c~remove-555-unneeded-includes-of-schedh
+++ a/net/802/fc.c
@@ -14,7 +14,6 @@
 #include <asm/system.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/802/fddi.c~remove-555-unneeded-includes-of-schedh net/802/fddi.c
--- a/net/802/fddi.c~remove-555-unneeded-includes-of-schedh
+++ a/net/802/fddi.c
@@ -30,7 +30,6 @@
 #include <asm/system.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/802/hippi.c~remove-555-unneeded-includes-of-schedh net/802/hippi.c
--- a/net/802/hippi.c~remove-555-unneeded-includes-of-schedh
+++ a/net/802/hippi.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/atm/addr.c~remove-555-unneeded-includes-of-schedh net/atm/addr.c
--- a/net/atm/addr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/atm/addr.c
@@ -4,7 +4,6 @@
 
 #include <linux/atm.h>
 #include <linux/atmdev.h>
-#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 #include "signaling.h"
diff -puN net/atm/lec.c~remove-555-unneeded-includes-of-schedh net/atm/lec.c
--- a/net/atm/lec.c~remove-555-unneeded-includes-of-schedh
+++ a/net/atm/lec.c
@@ -1437,7 +1437,6 @@ static void lane2_associate_ind(struct n
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <asm/param.h>
 #include <asm/atomic.h>
diff -puN net/atm/raw.c~remove-555-unneeded-includes-of-schedh net/atm/raw.c
--- a/net/atm/raw.c~remove-555-unneeded-includes-of-schedh
+++ a/net/atm/raw.c
@@ -4,7 +4,6 @@
 
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/atmdev.h>
 #include <linux/capability.h>
 #include <linux/kernel.h>
diff -puN net/ax25/ax25_addr.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_addr.c
--- a/net/ax25/ax25_addr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_addr.c
@@ -12,7 +12,6 @@
 #include <linux/in.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_dev.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_dev.c
--- a/net/ax25/ax25_dev.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_dev.c
@@ -11,7 +11,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_ds_in.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_ds_in.c
--- a/net/ax25/ax25_ds_in.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_ds_in.c
@@ -12,7 +12,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_ds_subr.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_ds_subr.c
--- a/net/ax25/ax25_ds_subr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_ds_subr.c
@@ -12,7 +12,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_iface.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_iface.c
--- a/net/ax25/ax25_iface.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_iface.c
@@ -12,7 +12,6 @@
 #include <linux/in.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/string.h>
diff -puN net/ax25/ax25_in.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_in.c
--- a/net/ax25/ax25_in.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_in.c
@@ -14,7 +14,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_ip.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_ip.c
--- a/net/ax25/ax25_ip.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_ip.c
@@ -12,7 +12,6 @@
 #include <linux/in.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_out.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_out.c
--- a/net/ax25/ax25_out.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_out.c
@@ -14,7 +14,6 @@
 #include <linux/in.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_std_in.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_std_in.c
--- a/net/ax25/ax25_std_in.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_std_in.c
@@ -19,7 +19,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_std_subr.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_std_subr.c
--- a/net/ax25/ax25_std_subr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_std_subr.c
@@ -11,7 +11,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_std_timer.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_std_timer.c
--- a/net/ax25/ax25_std_timer.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_std_timer.c
@@ -14,7 +14,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_subr.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_subr.c
--- a/net/ax25/ax25_subr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_subr.c
@@ -14,7 +14,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ax25/ax25_uid.c~remove-555-unneeded-includes-of-schedh net/ax25/ax25_uid.c
--- a/net/ax25/ax25_uid.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ax25/ax25_uid.c
@@ -13,7 +13,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/bluetooth/bnep/sock.c~remove-555-unneeded-includes-of-schedh net/bluetooth/bnep/sock.c
--- a/net/bluetooth/bnep/sock.c~remove-555-unneeded-includes-of-schedh
+++ a/net/bluetooth/bnep/sock.c
@@ -34,7 +34,6 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
diff -puN net/bluetooth/cmtp/sock.c~remove-555-unneeded-includes-of-schedh net/bluetooth/cmtp/sock.c
--- a/net/bluetooth/cmtp/sock.c~remove-555-unneeded-includes-of-schedh
+++ a/net/bluetooth/cmtp/sock.c
@@ -26,7 +26,6 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
diff -puN net/bluetooth/hci_conn.c~remove-555-unneeded-includes-of-schedh net/bluetooth/hci_conn.c
--- a/net/bluetooth/hci_conn.c~remove-555-unneeded-includes-of-schedh
+++ a/net/bluetooth/hci_conn.c
@@ -29,7 +29,6 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
diff -puN net/bluetooth/hci_event.c~remove-555-unneeded-includes-of-schedh net/bluetooth/hci_event.c
--- a/net/bluetooth/hci_event.c~remove-555-unneeded-includes-of-schedh
+++ a/net/bluetooth/hci_event.c
@@ -29,7 +29,6 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
diff -puN net/bluetooth/hci_sock.c~remove-555-unneeded-includes-of-schedh net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c~remove-555-unneeded-includes-of-schedh
+++ a/net/bluetooth/hci_sock.c
@@ -30,7 +30,6 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
diff -puN net/bluetooth/hidp/sock.c~remove-555-unneeded-includes-of-schedh net/bluetooth/hidp/sock.c
--- a/net/bluetooth/hidp/sock.c~remove-555-unneeded-includes-of-schedh
+++ a/net/bluetooth/hidp/sock.c
@@ -26,7 +26,6 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
diff -puN net/bridge/netfilter/ebtables.c~remove-555-unneeded-includes-of-schedh net/bridge/netfilter/ebtables.c
--- a/net/bridge/netfilter/ebtables.c~remove-555-unneeded-includes-of-schedh
+++ a/net/bridge/netfilter/ebtables.c
@@ -16,7 +16,6 @@
  */
 
 /* used for print_string */
-#include <linux/sched.h>
 #include <linux/tty.h>
 
 #include <linux/kmod.h>
diff -puN net/compat.c~remove-555-unneeded-includes-of-schedh net/compat.c
--- a/net/compat.c~remove-555-unneeded-includes-of-schedh
+++ a/net/compat.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/fs.h>
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/file.h>
 #include <linux/icmpv6.h>
diff -puN net/core/dev_mcast.c~remove-555-unneeded-includes-of-schedh net/core/dev_mcast.c
--- a/net/core/dev_mcast.c~remove-555-unneeded-includes-of-schedh
+++ a/net/core/dev_mcast.c
@@ -27,7 +27,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/core/dst.c~remove-555-unneeded-includes-of-schedh net/core/dst.c
--- a/net/core/dst.c~remove-555-unneeded-includes-of-schedh
+++ a/net/core/dst.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
 #include <linux/types.h>
diff -puN net/core/filter.c~remove-555-unneeded-includes-of-schedh net/core/filter.c
--- a/net/core/filter.c~remove-555-unneeded-includes-of-schedh
+++ a/net/core/filter.c
@@ -18,7 +18,6 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/fcntl.h>
 #include <linux/socket.h>
diff -puN net/core/iovec.c~remove-555-unneeded-includes-of-schedh net/core/iovec.c
--- a/net/core/iovec.c~remove-555-unneeded-includes-of-schedh
+++ a/net/core/iovec.c
@@ -18,7 +18,6 @@
 
 #include <linux/errno.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
diff -puN net/core/neighbour.c~remove-555-unneeded-includes-of-schedh net/core/neighbour.c
--- a/net/core/neighbour.c~remove-555-unneeded-includes-of-schedh
+++ a/net/core/neighbour.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/socket.h>
-#include <linux/sched.h>
 #include <linux/netdevice.h>
 #include <linux/proc_fs.h>
 #ifdef CONFIG_SYSCTL
diff -puN net/core/rtnetlink.c~remove-555-unneeded-includes-of-schedh net/core/rtnetlink.c
--- a/net/core/rtnetlink.c~remove-555-unneeded-includes-of-schedh
+++ a/net/core/rtnetlink.c
@@ -21,7 +21,6 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/core/skbuff.c~remove-555-unneeded-includes-of-schedh net/core/skbuff.c
--- a/net/core/skbuff.c~remove-555-unneeded-includes-of-schedh
+++ a/net/core/skbuff.c
@@ -41,7 +41,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/in.h>
diff -puN net/decnet/dn_nsp_in.c~remove-555-unneeded-includes-of-schedh net/decnet/dn_nsp_in.c
--- a/net/decnet/dn_nsp_in.c~remove-555-unneeded-includes-of-schedh
+++ a/net/decnet/dn_nsp_in.c
@@ -50,7 +50,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/decnet/dn_nsp_out.c~remove-555-unneeded-includes-of-schedh net/decnet/dn_nsp_out.c
--- a/net/decnet/dn_nsp_out.c~remove-555-unneeded-includes-of-schedh
+++ a/net/decnet/dn_nsp_out.c
@@ -43,7 +43,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/econet/af_econet.c~remove-555-unneeded-includes-of-schedh net/econet/af_econet.c
--- a/net/econet/af_econet.c~remove-555-unneeded-includes-of-schedh
+++ a/net/econet/af_econet.c
@@ -13,7 +13,6 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/ethernet/eth.c~remove-555-unneeded-includes-of-schedh net/ethernet/eth.c
--- a/net/ethernet/eth.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ethernet/eth.c
@@ -40,7 +40,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/ipv4/arp.c~remove-555-unneeded-includes-of-schedh net/ipv4/arp.c
--- a/net/ipv4/arp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/arp.c
@@ -78,7 +78,6 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/capability.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
diff -puN net/ipv4/devinet.c~remove-555-unneeded-includes-of-schedh net/ipv4/devinet.c
--- a/net/ipv4/devinet.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/devinet.c
@@ -35,7 +35,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/ipv4/fib_frontend.c~remove-555-unneeded-includes-of-schedh net/ipv4/fib_frontend.c
--- a/net/ipv4/fib_frontend.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/fib_frontend.c
@@ -22,7 +22,6 @@
 #include <linux/capability.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/socket.h>
diff -puN net/ipv4/fib_hash.c~remove-555-unneeded-includes-of-schedh net/ipv4/fib_hash.c
--- a/net/ipv4/fib_hash.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/fib_hash.c
@@ -20,7 +20,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/socket.h>
diff -puN net/ipv4/fib_trie.c~remove-555-unneeded-includes-of-schedh net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/fib_trie.c
@@ -57,7 +57,6 @@
 #include <asm/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/socket.h>
diff -puN net/ipv4/inetpeer.c~remove-555-unneeded-includes-of-schedh net/ipv4/inetpeer.c
--- a/net/ipv4/inetpeer.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/inetpeer.c
@@ -14,7 +14,6 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/random.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/kernel.h>
diff -puN net/ipv4/ip_forward.c~remove-555-unneeded-includes-of-schedh net/ipv4/ip_forward.c
--- a/net/ipv4/ip_forward.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/ip_forward.c
@@ -23,7 +23,6 @@
 
 #include <linux/types.h>
 #include <linux/mm.h>
-#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/icmp.h>
diff -puN net/ipv4/ip_gre.c~remove-555-unneeded-includes-of-schedh net/ipv4/ip_gre.c
--- a/net/ipv4/ip_gre.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/ip_gre.c
@@ -13,7 +13,6 @@
 #include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <asm/uaccess.h>
 #include <linux/skbuff.h>
diff -puN net/ipv4/ip_output.c~remove-555-unneeded-includes-of-schedh net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/ip_output.c
@@ -49,7 +49,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/errno.h>
diff -puN net/ipv4/ip_sockglue.c~remove-555-unneeded-includes-of-schedh net/ipv4/ip_sockglue.c
--- a/net/ipv4/ip_sockglue.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/ip_sockglue.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/mm.h>
-#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/icmp.h>
diff -puN net/ipv4/ipip.c~remove-555-unneeded-includes-of-schedh net/ipv4/ipip.c
--- a/net/ipv4/ipip.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/ipip.c
@@ -96,7 +96,6 @@
 #include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <asm/uaccess.h>
 #include <linux/skbuff.h>
diff -puN net/ipv4/ipmr.c~remove-555-unneeded-includes-of-schedh net/ipv4/ipmr.c
--- a/net/ipv4/ipmr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/ipmr.c
@@ -31,7 +31,6 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
diff -puN net/ipv4/ipvs/ip_vs_sched.c~remove-555-unneeded-includes-of-schedh net/ipv4/ipvs/ip_vs_sched.c
--- a/net/ipv4/ipvs/ip_vs_sched.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/ipvs/ip_vs_sched.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <asm/string.h>
diff -puN net/ipv4/multipath_drr.c~remove-555-unneeded-includes-of-schedh net/ipv4/multipath_drr.c
--- a/net/ipv4/multipath_drr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/multipath_drr.c
@@ -15,7 +15,6 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
 #include <linux/mm.h>
diff -puN net/ipv4/multipath_random.c~remove-555-unneeded-includes-of-schedh net/ipv4/multipath_random.c
--- a/net/ipv4/multipath_random.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/multipath_random.c
@@ -15,7 +15,6 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
 #include <linux/mm.h>
diff -puN net/ipv4/multipath_rr.c~remove-555-unneeded-includes-of-schedh net/ipv4/multipath_rr.c
--- a/net/ipv4/multipath_rr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/multipath_rr.c
@@ -15,7 +15,6 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
 #include <linux/mm.h>
diff -puN net/ipv4/multipath_wrandom.c~remove-555-unneeded-includes-of-schedh net/ipv4/multipath_wrandom.c
--- a/net/ipv4/multipath_wrandom.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/multipath_wrandom.c
@@ -15,7 +15,6 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
 #include <linux/mm.h>
diff -puN net/ipv4/netfilter/ip_conntrack_proto_generic.c~remove-555-unneeded-includes-of-schedh net/ipv4/netfilter/ip_conntrack_proto_generic.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_generic.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/netfilter/ip_conntrack_proto_generic.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
diff -puN net/ipv4/netfilter/ip_conntrack_proto_icmp.c~remove-555-unneeded-includes-of-schedh net/ipv4/netfilter/ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <linux/in.h>
diff -puN net/ipv4/netfilter/ip_conntrack_proto_sctp.c~remove-555-unneeded-includes-of-schedh net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/netfilter.h>
diff -puN net/ipv4/netfilter/ip_conntrack_proto_tcp.c~remove-555-unneeded-includes-of-schedh net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
diff -puN net/ipv4/netfilter/ip_conntrack_proto_udp.c~remove-555-unneeded-includes-of-schedh net/ipv4/netfilter/ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/netfilter/ip_conntrack_proto_udp.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <linux/in.h>
diff -puN net/ipv4/netfilter/nf_conntrack_proto_icmp.c~remove-555-unneeded-includes-of-schedh net/ipv4/netfilter/nf_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <linux/in.h>
diff -puN net/ipv4/protocol.c~remove-555-unneeded-includes-of-schedh net/ipv4/protocol.c
--- a/net/ipv4/protocol.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/protocol.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/socket.h>
 #include <linux/in.h>
diff -puN net/ipv4/route.c~remove-555-unneeded-includes-of-schedh net/ipv4/route.c
--- a/net/ipv4/route.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv4/route.c
@@ -70,7 +70,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/bootmem.h>
 #include <linux/string.h>
diff -puN net/ipv6/addrconf.c~remove-555-unneeded-includes-of-schedh net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/addrconf.c
@@ -44,7 +44,6 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
-#include <linux/sched.h>
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
diff -puN net/ipv6/af_inet6.c~remove-555-unneeded-includes-of-schedh net/ipv6/af_inet6.c
--- a/net/ipv6/af_inet6.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/af_inet6.c
@@ -28,7 +28,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/ipv6/anycast.c~remove-555-unneeded-includes-of-schedh net/ipv6/anycast.c
--- a/net/ipv6/anycast.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/anycast.c
@@ -21,7 +21,6 @@
 #include <linux/string.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
-#include <linux/sched.h>
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
diff -puN net/ipv6/datagram.c~remove-555-unneeded-includes-of-schedh net/ipv6/datagram.c
--- a/net/ipv6/datagram.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/datagram.c
@@ -17,7 +17,6 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
diff -puN net/ipv6/exthdrs.c~remove-555-unneeded-includes-of-schedh net/ipv6/exthdrs.c
--- a/net/ipv6/exthdrs.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/exthdrs.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
-#include <linux/sched.h>
 #include <linux/net.h>
 #include <linux/netdevice.h>
 #include <linux/in6.h>
diff -puN net/ipv6/icmp.c~remove-555-unneeded-includes-of-schedh net/ipv6/icmp.c
--- a/net/ipv6/icmp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/icmp.c
@@ -37,7 +37,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/sockios.h>
 #include <linux/net.h>
 #include <linux/skbuff.h>
diff -puN net/ipv6/ip6_input.c~remove-555-unneeded-includes-of-schedh net/ipv6/ip6_input.c
--- a/net/ipv6/ip6_input.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/ip6_input.c
@@ -25,7 +25,6 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
-#include <linux/sched.h>
 #include <linux/net.h>
 #include <linux/netdevice.h>
 #include <linux/in6.h>
diff -puN net/ipv6/ipv6_sockglue.c~remove-555-unneeded-includes-of-schedh net/ipv6/ipv6_sockglue.c
--- a/net/ipv6/ipv6_sockglue.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/ipv6_sockglue.c
@@ -31,7 +31,6 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
-#include <linux/sched.h>
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
diff -puN net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c~remove-555-unneeded-includes-of-schedh net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/module.h>
 #include <linux/netfilter.h>
diff -puN net/ipv6/proc.c~remove-555-unneeded-includes-of-schedh net/ipv6/proc.c
--- a/net/ipv6/proc.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/proc.c
@@ -17,7 +17,6 @@
  *		as published by the Free Software Foundation; either version
  *		2 of the License, or (at your option) any later version.
  */
-#include <linux/sched.h>
 #include <linux/socket.h>
 #include <linux/net.h>
 #include <linux/ipv6.h>
diff -puN net/ipv6/protocol.c~remove-555-unneeded-includes-of-schedh net/ipv6/protocol.c
--- a/net/ipv6/protocol.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/protocol.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
-#include <linux/sched.h>
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
diff -puN net/ipv6/raw.c~remove-555-unneeded-includes-of-schedh net/ipv6/raw.c
--- a/net/ipv6/raw.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/raw.c
@@ -24,7 +24,6 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
-#include <linux/sched.h>
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
diff -puN net/ipv6/sit.c~remove-555-unneeded-includes-of-schedh net/ipv6/sit.c
--- a/net/ipv6/sit.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/sit.c
@@ -24,7 +24,6 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
-#include <linux/sched.h>
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
diff -puN net/ipv6/udp.c~remove-555-unneeded-includes-of-schedh net/ipv6/udp.c
--- a/net/ipv6/udp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/ipv6/udp.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
-#include <linux/sched.h>
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
diff -puN net/irda/ircomm/ircomm_core.c~remove-555-unneeded-includes-of-schedh net/irda/ircomm/ircomm_core.c
--- a/net/irda/ircomm/ircomm_core.c~remove-555-unneeded-includes-of-schedh
+++ a/net/irda/ircomm/ircomm_core.c
@@ -30,7 +30,6 @@
  ********************************************************************/
 
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
diff -puN net/irda/ircomm/ircomm_event.c~remove-555-unneeded-includes-of-schedh net/irda/ircomm/ircomm_event.c
--- a/net/irda/ircomm/ircomm_event.c~remove-555-unneeded-includes-of-schedh
+++ a/net/irda/ircomm/ircomm_event.c
@@ -28,7 +28,6 @@
  *     
  ********************************************************************/
 
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 
diff -puN net/irda/ircomm/ircomm_lmp.c~remove-555-unneeded-includes-of-schedh net/irda/ircomm/ircomm_lmp.c
--- a/net/irda/ircomm/ircomm_lmp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/irda/ircomm/ircomm_lmp.c
@@ -30,7 +30,6 @@
  *     
  ********************************************************************/
 
-#include <linux/sched.h>
 #include <linux/init.h>
 
 #include <net/irda/irda.h>
diff -puN net/irda/ircomm/ircomm_param.c~remove-555-unneeded-includes-of-schedh net/irda/ircomm/ircomm_param.c
--- a/net/irda/ircomm/ircomm_param.c~remove-555-unneeded-includes-of-schedh
+++ a/net/irda/ircomm/ircomm_param.c
@@ -28,7 +28,6 @@
  *     
  ********************************************************************/
 
-#include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 
diff -puN net/irda/ircomm/ircomm_ttp.c~remove-555-unneeded-includes-of-schedh net/irda/ircomm/ircomm_ttp.c
--- a/net/irda/ircomm/ircomm_ttp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/irda/ircomm/ircomm_ttp.c
@@ -29,7 +29,6 @@
  *     
  ********************************************************************/
 
-#include <linux/sched.h>
 #include <linux/init.h>
 
 #include <net/irda/irda.h>
diff -puN net/irda/ircomm/ircomm_tty_attach.c~remove-555-unneeded-includes-of-schedh net/irda/ircomm/ircomm_tty_attach.c
--- a/net/irda/ircomm/ircomm_tty_attach.c~remove-555-unneeded-includes-of-schedh
+++ a/net/irda/ircomm/ircomm_tty_attach.c
@@ -29,7 +29,6 @@
  *     
  ********************************************************************/
 
-#include <linux/sched.h>
 #include <linux/init.h>
 
 #include <net/irda/irda.h>
diff -puN net/irda/ircomm/ircomm_tty_ioctl.c~remove-555-unneeded-includes-of-schedh net/irda/ircomm/ircomm_tty_ioctl.c
--- a/net/irda/ircomm/ircomm_tty_ioctl.c~remove-555-unneeded-includes-of-schedh
+++ a/net/irda/ircomm/ircomm_tty_ioctl.c
@@ -30,7 +30,6 @@
 
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/sched.h>
 #include <linux/termios.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
diff -puN net/lapb/lapb_in.c~remove-555-unneeded-includes-of-schedh net/lapb/lapb_in.c
--- a/net/lapb/lapb_in.c~remove-555-unneeded-includes-of-schedh
+++ a/net/lapb/lapb_in.c
@@ -20,7 +20,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/lapb/lapb_out.c~remove-555-unneeded-includes-of-schedh net/lapb/lapb_out.c
--- a/net/lapb/lapb_out.c~remove-555-unneeded-includes-of-schedh
+++ a/net/lapb/lapb_out.c
@@ -19,7 +19,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/lapb/lapb_subr.c~remove-555-unneeded-includes-of-schedh net/lapb/lapb_subr.c
--- a/net/lapb/lapb_subr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/lapb/lapb_subr.c
@@ -18,7 +18,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/netfilter/nf_conntrack_proto_generic.c~remove-555-unneeded-includes-of-schedh net/netfilter/nf_conntrack_proto_generic.c
--- a/net/netfilter/nf_conntrack_proto_generic.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netfilter/nf_conntrack_proto_generic.c
@@ -12,7 +12,7 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
+#include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
diff -puN net/netfilter/nf_conntrack_proto_sctp.c~remove-555-unneeded-includes-of-schedh net/netfilter/nf_conntrack_proto_sctp.c
--- a/net/netfilter/nf_conntrack_proto_sctp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netfilter/nf_conntrack_proto_sctp.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
diff -puN net/netfilter/nf_conntrack_proto_tcp.c~remove-555-unneeded-includes-of-schedh net/netfilter/nf_conntrack_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netfilter/nf_conntrack_proto_tcp.c
@@ -25,7 +25,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
diff -puN net/netfilter/nf_conntrack_proto_udp.c~remove-555-unneeded-includes-of-schedh net/netfilter/nf_conntrack_proto_udp.c
--- a/net/netfilter/nf_conntrack_proto_udp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netfilter/nf_conntrack_proto_udp.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/module.h>
 #include <linux/netfilter.h>
diff -puN net/netfilter/nfnetlink.c~remove-555-unneeded-includes-of-schedh net/netfilter/nfnetlink.c
--- a/net/netfilter/nfnetlink.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netfilter/nfnetlink.c
@@ -19,7 +19,6 @@
 #include <linux/socket.h>
 #include <linux/kernel.h>
 #include <linux/major.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/netrom/nr_dev.c~remove-555-unneeded-includes-of-schedh net/netrom/nr_dev.c
--- a/net/netrom/nr_dev.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netrom/nr_dev.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/fs.h>
 #include <linux/types.h>
diff -puN net/netrom/nr_in.c~remove-555-unneeded-includes-of-schedh net/netrom/nr_in.c
--- a/net/netrom/nr_in.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netrom/nr_in.c
@@ -12,7 +12,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/netrom/nr_out.c~remove-555-unneeded-includes-of-schedh net/netrom/nr_out.c
--- a/net/netrom/nr_out.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netrom/nr_out.c
@@ -12,7 +12,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/netrom/nr_route.c~remove-555-unneeded-includes-of-schedh net/netrom/nr_route.c
--- a/net/netrom/nr_route.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netrom/nr_route.c
@@ -13,7 +13,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/netrom/nr_subr.c~remove-555-unneeded-includes-of-schedh net/netrom/nr_subr.c
--- a/net/netrom/nr_subr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/netrom/nr_subr.c
@@ -11,7 +11,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/packet/af_packet.c~remove-555-unneeded-includes-of-schedh net/packet/af_packet.c
--- a/net/packet/af_packet.c~remove-555-unneeded-includes-of-schedh
+++ a/net/packet/af_packet.c
@@ -50,7 +50,6 @@
  */
  
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/capability.h>
 #include <linux/fcntl.h>
diff -puN net/rose/rose_dev.c~remove-555-unneeded-includes-of-schedh net/rose/rose_dev.c
--- a/net/rose/rose_dev.c~remove-555-unneeded-includes-of-schedh
+++ a/net/rose/rose_dev.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/fs.h>
 #include <linux/types.h>
diff -puN net/rose/rose_in.c~remove-555-unneeded-includes-of-schedh net/rose/rose_in.c
--- a/net/rose/rose_in.c~remove-555-unneeded-includes-of-schedh
+++ a/net/rose/rose_in.c
@@ -16,7 +16,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/rose/rose_out.c~remove-555-unneeded-includes-of-schedh net/rose/rose_out.c
--- a/net/rose/rose_out.c~remove-555-unneeded-includes-of-schedh
+++ a/net/rose/rose_out.c
@@ -11,7 +11,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/rose/rose_route.c~remove-555-unneeded-includes-of-schedh net/rose/rose_route.c
--- a/net/rose/rose_route.c~remove-555-unneeded-includes-of-schedh
+++ a/net/rose/rose_route.c
@@ -12,7 +12,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/rose/rose_subr.c~remove-555-unneeded-includes-of-schedh net/rose/rose_subr.c
--- a/net/rose/rose_subr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/rose/rose_subr.c
@@ -11,7 +11,6 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
diff -puN net/rxrpc/transport.c~remove-555-unneeded-includes-of-schedh net/rxrpc/transport.c
--- a/net/rxrpc/transport.c~remove-555-unneeded-includes-of-schedh
+++ a/net/rxrpc/transport.c
@@ -9,7 +9,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <rxrpc/transport.h>
diff -puN net/sched/act_api.c~remove-555-unneeded-includes-of-schedh net/sched/act_api.c
--- a/net/sched/act_api.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/act_api.c
@@ -16,7 +16,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/act_gact.c~remove-555-unneeded-includes-of-schedh net/sched/act_gact.c
--- a/net/sched/act_gact.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/act_gact.c
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/act_ipt.c~remove-555-unneeded-includes-of-schedh net/sched/act_ipt.c
--- a/net/sched/act_ipt.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/act_ipt.c
@@ -16,7 +16,6 @@
 #include <asm/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/act_mirred.c~remove-555-unneeded-includes-of-schedh net/sched/act_mirred.c
--- a/net/sched/act_mirred.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/act_mirred.c
@@ -17,7 +17,6 @@
 #include <asm/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/act_pedit.c~remove-555-unneeded-includes-of-schedh net/sched/act_pedit.c
--- a/net/sched/act_pedit.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/act_pedit.c
@@ -14,7 +14,6 @@
 #include <asm/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/act_police.c~remove-555-unneeded-includes-of-schedh net/sched/act_police.c
--- a/net/sched/act_police.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/act_police.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/cls_api.c~remove-555-unneeded-includes-of-schedh net/sched/cls_api.c
--- a/net/sched/cls_api.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/cls_api.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/cls_basic.c~remove-555-unneeded-includes-of-schedh net/sched/cls_basic.c
--- a/net/sched/cls_basic.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/cls_basic.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
diff -puN net/sched/cls_fw.c~remove-555-unneeded-includes-of-schedh net/sched/cls_fw.c
--- a/net/sched/cls_fw.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/cls_fw.c
@@ -24,7 +24,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/cls_route.c~remove-555-unneeded-includes-of-schedh net/sched/cls_route.c
--- a/net/sched/cls_route.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/cls_route.c
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/cls_rsvp.c~remove-555-unneeded-includes-of-schedh net/sched/cls_rsvp.c
--- a/net/sched/cls_rsvp.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/cls_rsvp.c
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/cls_rsvp6.c~remove-555-unneeded-includes-of-schedh net/sched/cls_rsvp6.c
--- a/net/sched/cls_rsvp6.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/cls_rsvp6.c
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/cls_u32.c~remove-555-unneeded-includes-of-schedh net/sched/cls_u32.c
--- a/net/sched/cls_u32.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/cls_u32.c
@@ -36,7 +36,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/em_nbyte.c~remove-555-unneeded-includes-of-schedh net/sched/em_nbyte.c
--- a/net/sched/em_nbyte.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/em_nbyte.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/skbuff.h>
 #include <linux/tc_ematch/tc_em_nbyte.h>
diff -puN net/sched/em_text.c~remove-555-unneeded-includes-of-schedh net/sched/em_text.c
--- a/net/sched/em_text.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/em_text.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/skbuff.h>
 #include <linux/textsearch.h>
diff -puN net/sched/ematch.c~remove-555-unneeded-includes-of-schedh net/sched/ematch.c
--- a/net/sched/ematch.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/ematch.c
@@ -84,7 +84,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
diff -puN net/sched/sch_api.c~remove-555-unneeded-includes-of-schedh net/sched/sch_api.c
--- a/net/sched/sch_api.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/sch_api.c
@@ -18,7 +18,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/sch_cbq.c~remove-555-unneeded-includes-of-schedh net/sched/sch_cbq.c
--- a/net/sched/sch_cbq.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/sch_cbq.c
@@ -16,7 +16,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/sch_htb.c~remove-555-unneeded-includes-of-schedh net/sched/sch_htb.c
--- a/net/sched/sch_htb.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/sch_htb.c
@@ -33,7 +33,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/sch_prio.c~remove-555-unneeded-includes-of-schedh net/sched/sch_prio.c
--- a/net/sched/sch_prio.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/sch_prio.c
@@ -17,7 +17,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sched/sch_teql.c~remove-555-unneeded-includes-of-schedh net/sched/sch_teql.c
--- a/net/sched/sch_teql.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sched/sch_teql.c
@@ -14,7 +14,6 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
diff -puN net/sctp/associola.c~remove-555-unneeded-includes-of-schedh net/sctp/associola.c
--- a/net/sctp/associola.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sctp/associola.c
@@ -52,7 +52,6 @@
 #include <linux/fcntl.h>
 #include <linux/poll.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 
 #include <linux/slab.h>
 #include <linux/in.h>
diff -puN net/sctp/bind_addr.c~remove-555-unneeded-includes-of-schedh net/sctp/bind_addr.c
--- a/net/sctp/bind_addr.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sctp/bind_addr.c
@@ -43,7 +43,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/in.h>
 #include <net/sock.h>
 #include <net/ipv6.h>
diff -puN net/sctp/endpointola.c~remove-555-unneeded-includes-of-schedh net/sctp/endpointola.c
--- a/net/sctp/endpointola.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sctp/endpointola.c
@@ -50,7 +50,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/in.h>
 #include <linux/random.h>	/* get_random_bytes() */
diff -puN net/sctp/ipv6.c~remove-555-unneeded-includes-of-schedh net/sctp/ipv6.c
--- a/net/sctp/ipv6.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sctp/ipv6.c
@@ -53,7 +53,6 @@
 #include <linux/socket.h>
 #include <linux/sockios.h>
 #include <linux/net.h>
-#include <linux/sched.h>
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
diff -puN net/sunrpc/auth_null.c~remove-555-unneeded-includes-of-schedh net/sunrpc/auth_null.c
--- a/net/sunrpc/auth_null.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sunrpc/auth_null.c
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/utsname.h>
 #include <linux/sunrpc/clnt.h>
-#include <linux/sched.h>
 
 #ifdef RPC_DEBUG
 # define RPCDBG_FACILITY	RPCDBG_AUTH
diff -puN net/sunrpc/stats.c~remove-555-unneeded-includes-of-schedh net/sunrpc/stats.c
--- a/net/sunrpc/stats.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sunrpc/stats.c
@@ -16,7 +16,6 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/sunrpc/clnt.h>
diff -puN net/sunrpc/sunrpc_syms.c~remove-555-unneeded-includes-of-schedh net/sunrpc/sunrpc_syms.c
--- a/net/sunrpc/sunrpc_syms.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sunrpc/sunrpc_syms.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/uio.h>
 #include <linux/unistd.h>
 #include <linux/init.h>
diff -puN net/sunrpc/svcauth.c~remove-555-unneeded-includes-of-schedh net/sunrpc/svcauth.c
--- a/net/sunrpc/svcauth.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sunrpc/svcauth.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/xdr.h>
diff -puN net/sunrpc/xprtsock.c~remove-555-unneeded-includes-of-schedh net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~remove-555-unneeded-includes-of-schedh
+++ a/net/sunrpc/xprtsock.c
@@ -18,7 +18,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/capability.h>
-#include <linux/sched.h>
 #include <linux/pagemap.h>
 #include <linux/errno.h>
 #include <linux/socket.h>
diff -puN net/unix/garbage.c~remove-555-unneeded-includes-of-schedh net/unix/garbage.c
--- a/net/unix/garbage.c~remove-555-unneeded-includes-of-schedh
+++ a/net/unix/garbage.c
@@ -65,7 +65,6 @@
  */
  
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/socket.h>
 #include <linux/un.h>
diff -puN security/keys/compat.c~remove-555-unneeded-includes-of-schedh security/keys/compat.c
--- a/security/keys/compat.c~remove-555-unneeded-includes-of-schedh
+++ a/security/keys/compat.c
@@ -9,7 +9,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/keyctl.h>
 #include <linux/compat.h>
diff -puN security/keys/user_defined.c~remove-555-unneeded-includes-of-schedh security/keys/user_defined.c
--- a/security/keys/user_defined.c~remove-555-unneeded-includes-of-schedh
+++ a/security/keys/user_defined.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
diff -puN security/security.c~remove-555-unneeded-includes-of-schedh security/security.c
--- a/security/security.c~remove-555-unneeded-includes-of-schedh
+++ a/security/security.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/security.h>
 
 #define SECURITY_FRAMEWORK_VERSION	"1.0.0"
diff -puN security/selinux/ss/sidtab.c~remove-555-unneeded-includes-of-schedh security/selinux/ss/sidtab.c
--- a/security/selinux/ss/sidtab.c~remove-555-unneeded-includes-of-schedh
+++ a/security/selinux/ss/sidtab.c
@@ -7,7 +7,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include "flask.h"
 #include "security.h"
 #include "sidtab.h"
diff -puN sound/core/misc.c~remove-555-unneeded-includes-of-schedh sound/core/misc.c
--- a/sound/core/misc.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/core/misc.c
@@ -21,7 +21,6 @@
 
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/ioport.h>
 #include <sound/core.h>
diff -puN sound/core/seq/instr/ainstr_fm.c~remove-555-unneeded-includes-of-schedh sound/core/seq/instr/ainstr_fm.c
--- a/sound/core/seq/instr/ainstr_fm.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/core/seq/instr/ainstr_fm.c
@@ -20,7 +20,6 @@
  
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <sound/core.h>
 #include <sound/ainstr_fm.h>
 #include <sound/initval.h>
diff -puN sound/core/seq/instr/ainstr_gf1.c~remove-555-unneeded-includes-of-schedh sound/core/seq/instr/ainstr_gf1.c
--- a/sound/core/seq/instr/ainstr_gf1.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/core/seq/instr/ainstr_gf1.c
@@ -20,7 +20,6 @@
  
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/ainstr_gf1.h>
diff -puN sound/core/seq/instr/ainstr_iw.c~remove-555-unneeded-includes-of-schedh sound/core/seq/instr/ainstr_iw.c
--- a/sound/core/seq/instr/ainstr_iw.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/core/seq/instr/ainstr_iw.c
@@ -20,7 +20,6 @@
  
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/ainstr_iw.h>
diff -puN sound/core/seq/instr/ainstr_simple.c~remove-555-unneeded-includes-of-schedh sound/core/seq/instr/ainstr_simple.c
--- a/sound/core/seq/instr/ainstr_simple.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/core/seq/instr/ainstr_simple.c
@@ -20,7 +20,6 @@
  
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/ainstr_simple.h>
diff -puN sound/core/seq/seq_virmidi.c~remove-555-unneeded-includes-of-schedh sound/core/seq/seq_virmidi.c
--- a/sound/core/seq/seq_virmidi.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/core/seq/seq_virmidi.c
@@ -38,7 +38,6 @@
 #include <sound/driver.h>
 #include <linux/init.h>
 #include <linux/wait.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/rawmidi.h>
diff -puN sound/drivers/virmidi.c~remove-555-unneeded-includes-of-schedh sound/drivers/virmidi.c
--- a/sound/drivers/virmidi.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/drivers/virmidi.c
@@ -44,7 +44,6 @@
 #include <sound/driver.h>
 #include <linux/init.h>
 #include <linux/wait.h>
-#include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
diff -puN sound/isa/dt019x.c~remove-555-unneeded-includes-of-schedh sound/isa/dt019x.c
--- a/sound/isa/dt019x.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/isa/dt019x.c
@@ -23,7 +23,6 @@
 
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/pnp.h>
 #include <linux/moduleparam.h>
diff -puN sound/synth/emux/emux.c~remove-555-unneeded-includes-of-schedh sound/synth/emux/emux.c
--- a/sound/synth/emux/emux.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/synth/emux/emux.c
@@ -20,7 +20,6 @@
 
 #include <sound/driver.h>
 #include <linux/wait.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <sound/core.h>
diff -puN sound/synth/emux/emux_proc.c~remove-555-unneeded-includes-of-schedh sound/synth/emux/emux_proc.c
--- a/sound/synth/emux/emux_proc.c~remove-555-unneeded-includes-of-schedh
+++ a/sound/synth/emux/emux_proc.c
@@ -20,7 +20,6 @@
 
 #include <sound/driver.h>
 #include <linux/wait.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/emux_synth.h>
_

Patches currently in -mm which might be from tim@physik3.uni-rostock.de are

remove-555-unneeded-includes-of-schedh.patch
