From: akpm@linux-foundation.org
Subject: + header-cleaning-dont-include-smp_lockh-when-not-used.patch added to -mm tree
Date: Thu, 29 Mar 2007 14:46:51 -0700
Message-ID: <200703292146.l2TLkpjW012812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40245 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934353AbXC2VrB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 17:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     header cleaning: don't include smp_lock.h when not used
has been added to the -mm tree.  Its filename is
     header-cleaning-dont-include-smp_lockh-when-not-used.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: header cleaning: don't include smp_lock.h when not used
From: Randy Dunlap <randy.dunlap@oracle.com>

Remove includes of <linux/smp_lock.h> where it is not used/needed.
Suggested by Al Viro.

Builds cleanly on x86_64, i386, alpha, ia64, powerpc, sparc,
sparc64, and arm (all 59 defconfigs).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/process.c                     |    1 -
 arch/alpha/kernel/signal.c                      |    1 -
 arch/alpha/kernel/smp.c                         |    1 -
 arch/alpha/mm/fault.c                           |    1 -
 arch/arm/kernel/ptrace.c                        |    1 -
 arch/arm26/kernel/armksyms.c                    |    1 -
 arch/arm26/kernel/ptrace.c                      |    1 -
 arch/arm26/kernel/signal.c                      |    1 -
 arch/avr32/kernel/ptrace.c                      |    1 -
 arch/cris/arch-v10/kernel/ptrace.c              |    1 -
 arch/cris/arch-v10/kernel/signal.c              |    1 -
 arch/cris/arch-v32/kernel/ptrace.c              |    1 -
 arch/cris/kernel/crisksyms.c                    |    1 -
 arch/cris/kernel/ptrace.c                       |    1 -
 arch/frv/kernel/irq.c                           |    1 -
 arch/frv/kernel/ptrace.c                        |    1 -
 arch/frv/kernel/signal.c                        |    1 -
 arch/frv/kernel/sys_frv.c                       |    1 -
 arch/h8300/kernel/ptrace.c                      |    1 -
 arch/h8300/kernel/sys_h8300.c                   |    1 -
 arch/i386/kernel/apic.c                         |    1 -
 arch/i386/kernel/apm.c                          |    1 -
 arch/i386/kernel/i8259.c                        |    1 -
 arch/i386/kernel/io_apic.c                      |    1 -
 arch/i386/kernel/ioport.c                       |    1 -
 arch/i386/kernel/ldt.c                          |    1 -
 arch/i386/kernel/mpparse.c                      |    1 -
 arch/i386/kernel/process.c                      |    1 -
 arch/i386/kernel/ptrace.c                       |    1 -
 arch/i386/kernel/signal.c                       |    1 -
 arch/i386/kernel/smp.c                          |    1 -
 arch/i386/kernel/smpboot.c                      |    1 -
 arch/i386/kernel/sys_i386.c                     |    1 -
 arch/i386/kernel/vm86.c                         |    1 -
 arch/i386/mach-visws/visws_apic.c               |    1 -
 arch/i386/mach-voyager/voyager_smp.c            |    1 -
 arch/i386/mach-voyager/voyager_thread.c         |    1 -
 arch/i386/mm/fault.c                            |    1 -
 arch/i386/mm/hugetlbpage.c                      |    1 -
 arch/ia64/ia32/ia32_ldt.c                       |    1 -
 arch/ia64/ia32/ia32_signal.c                    |    1 -
 arch/ia64/kernel/iosapic.c                      |    1 -
 arch/ia64/kernel/irq_ia64.c                     |    1 -
 arch/ia64/kernel/mca.c                          |    1 -
 arch/ia64/kernel/mca_drv.c                      |    1 -
 arch/ia64/kernel/perfmon.c                      |    1 -
 arch/ia64/kernel/process.c                      |    1 -
 arch/ia64/kernel/salinfo.c                      |    1 -
 arch/ia64/kernel/signal.c                       |    1 -
 arch/ia64/kernel/smpboot.c                      |    1 -
 arch/ia64/kernel/sys_ia64.c                     |    1 -
 arch/ia64/kernel/unaligned.c                    |    1 -
 arch/ia64/mm/fault.c                            |    1 -
 arch/ia64/mm/hugetlbpage.c                      |    1 -
 arch/ia64/pci/pci.c                             |    1 -
 arch/m32r/kernel/m32r_ksyms.c                   |    1 -
 arch/m32r/kernel/signal.c                       |    1 -
 arch/m32r/kernel/smpboot.c                      |    1 -
 arch/m32r/kernel/sys_m32r.c                     |    1 -
 arch/m32r/mm/fault-nommu.c                      |    1 -
 arch/m32r/mm/fault.c                            |    1 -
 arch/m68k/kernel/ptrace.c                       |    1 -
 arch/m68k/mvme16x/rtc.c                         |    1 -
 arch/m68knommu/kernel/ptrace.c                  |    1 -
 arch/m68knommu/kernel/sys_m68k.c                |    1 -
 arch/mips/kernel/irixelf.c                      |    1 -
 arch/mips/kernel/irixioctl.c                    |    1 -
 arch/mips/kernel/irixsig.c                      |    1 -
 arch/mips/kernel/ptrace.c                       |    1 -
 arch/mips/kernel/signal.c                       |    1 -
 arch/mips/kernel/signal32.c                     |    1 -
 arch/mips/kernel/signal_n32.c                   |    1 -
 arch/mips/kernel/syscall.c                      |    1 -
 arch/mips/kernel/traps.c                        |    1 -
 arch/mips/kernel/unaligned.c                    |    1 -
 arch/mips/math-emu/dsemul.c                     |    1 -
 arch/mips/mm/fault.c                            |    1 -
 arch/mips/sgi-ip27/ip27-irq.c                   |    1 -
 arch/parisc/hpux/fs.c                           |    1 -
 arch/parisc/hpux/ioctl.c                        |    1 -
 arch/parisc/kernel/ptrace.c                     |    1 -
 arch/parisc/kernel/signal.c                     |    1 -
 arch/parisc/kernel/signal32.c                   |    1 -
 arch/parisc/kernel/sys_parisc.c                 |    1 -
 arch/parisc/kernel/traps.c                      |    1 -
 arch/powerpc/kernel/process.c                   |    1 -
 arch/powerpc/kernel/ptrace.c                    |    1 -
 arch/powerpc/kernel/signal_32.c                 |    1 -
 arch/powerpc/kernel/signal_64.c                 |    1 -
 arch/powerpc/kernel/syscalls.c                  |    1 -
 arch/powerpc/kernel/vdso.c                      |    1 -
 arch/powerpc/mm/hugetlbpage.c                   |    1 -
 arch/powerpc/platforms/cell/spufs/backing_ops.c |    1 -
 arch/powerpc/platforms/cell/spufs/hw_ops.c      |    1 -
 arch/powerpc/platforms/cell/spufs/sched.c       |    1 -
 arch/powerpc/platforms/cell/spufs/switch.c      |    1 -
 arch/powerpc/platforms/chrp/smp.c               |    1 -
 arch/powerpc/platforms/iseries/smp.c            |    1 -
 arch/powerpc/platforms/iseries/viopath.c        |    1 -
 arch/powerpc/platforms/powermac/smp.c           |    1 -
 arch/ppc/kernel/ppc_htab.c                      |    1 -
 arch/ppc/kernel/smp.c                           |    1 -
 arch/s390/kernel/compat_signal.c                |    1 -
 arch/s390/kernel/process.c                      |    1 -
 arch/s390/kernel/signal.c                       |    1 -
 arch/s390/kernel/smp.c                          |    1 -
 arch/s390/kernel/sys_s390.c                     |    1 -
 arch/s390/kernel/traps.c                        |    1 -
 arch/sh/drivers/pci/pci-st40.c                  |    1 -
 arch/sh/kernel/ptrace.c                         |    1 -
 arch/sh/kernel/sh_ksyms.c                       |    1 -
 arch/sh/kernel/signal.c                         |    1 -
 arch/sh/kernel/sys_sh.c                         |    1 -
 arch/sh/mm/fault-nommu.c                        |    1 -
 arch/sh/mm/hugetlbpage.c                        |    1 -
 arch/sh64/kernel/irq.c                          |    1 -
 arch/sh64/kernel/pci_sh5.c                      |    1 -
 arch/sh64/kernel/sh_ksyms.c                     |    1 -
 arch/sh64/kernel/signal.c                       |    1 -
 arch/sh64/kernel/sys_sh64.c                     |    1 -
 arch/sh64/kernel/traps.c                        |    1 -
 arch/sh64/mm/fault.c                            |    1 -
 arch/sh64/mm/hugetlbpage.c                      |    1 -
 arch/sh64/mm/tlbmiss.c                          |    1 -
 arch/sparc/kernel/irq.c                         |    1 -
 arch/sparc/kernel/process.c                     |    1 -
 arch/sparc/kernel/signal.c                      |    1 -
 arch/sparc/kernel/smp.c                         |    1 -
 arch/sparc/kernel/sun4d_irq.c                   |    1 -
 arch/sparc/kernel/sun4d_smp.c                   |    1 -
 arch/sparc/kernel/sun4m_smp.c                   |    1 -
 arch/sparc/kernel/sunos_ioctl.c                 |    1 -
 arch/sparc/kernel/sys_solaris.c                 |    1 -
 arch/sparc/lib/bitext.c                         |    1 -
 arch/sparc/mm/fault.c                           |    1 -
 arch/sparc64/kernel/pci.c                       |    1 -
 arch/sparc64/kernel/process.c                   |    1 -
 arch/sparc64/kernel/signal.c                    |    1 -
 arch/sparc64/kernel/signal32.c                  |    1 -
 arch/sparc64/kernel/smp.c                       |    1 -
 arch/sparc64/kernel/sunos_ioctl32.c             |    1 -
 arch/sparc64/kernel/sys_sparc.c                 |    1 -
 arch/sparc64/kernel/traps.c                     |    1 -
 arch/sparc64/kernel/unaligned.c                 |    1 -
 arch/sparc64/mm/fault.c                         |    1 -
 arch/sparc64/mm/hugetlbpage.c                   |    1 -
 arch/sparc64/solaris/ipc.c                      |    1 -
 arch/sparc64/solaris/misc.c                     |    1 -
 arch/sparc64/solaris/signal.c                   |    1 -
 arch/sparc64/solaris/socket.c                   |    1 -
 arch/sparc64/solaris/socksys.c                  |    1 -
 arch/v850/kernel/process.c                      |    1 -
 arch/v850/kernel/ptrace.c                       |    1 -
 arch/v850/kernel/signal.c                       |    1 -
 arch/v850/kernel/syscalls.c                     |    1 -
 arch/x86_64/ia32/ia32_signal.c                  |    1 -
 arch/x86_64/kernel/apic.c                       |    1 -
 arch/x86_64/kernel/i8259.c                      |    1 -
 arch/x86_64/kernel/io_apic.c                    |    1 -
 arch/x86_64/kernel/ioport.c                     |    1 -
 arch/x86_64/kernel/ldt.c                        |    1 -
 arch/x86_64/kernel/mpparse.c                    |    1 -
 arch/x86_64/kernel/ptrace.c                     |    1 -
 arch/x86_64/kernel/signal.c                     |    1 -
 arch/x86_64/kernel/smp.c                        |    1 -
 arch/x86_64/kernel/smpboot.c                    |    1 -
 arch/x86_64/kernel/sys_x86_64.c                 |    1 -
 arch/x86_64/mm/fault.c                          |    1 -
 arch/xtensa/kernel/process.c                    |    1 -
 arch/xtensa/kernel/ptrace.c                     |    1 -
 arch/xtensa/kernel/signal.c                     |    1 -
 drivers/acpi/osl.c                              |    1 -
 drivers/block/acsi_slm.c                        |    1 -
 drivers/block/umem.c                            |    1 -
 drivers/char/ds1620.c                           |    1 -
 drivers/char/dsp56k.c                           |    1 -
 drivers/char/dtlk.c                             |    1 -
 drivers/char/ec3104_keyb.c                      |    1 -
 drivers/char/hangcheck-timer.c                  |    1 -
 drivers/char/ip27-rtc.c                         |    1 -
 drivers/char/lp.c                               |    1 -
 drivers/char/mem.c                              |    1 -
 drivers/char/mxser.c                            |    1 -
 drivers/char/mxser_new.c                        |    1 -
 drivers/char/ppdev.c                            |    1 -
 drivers/char/sysrq.c                            |    1 -
 drivers/char/vc_screen.c                        |    1 -
 drivers/char/watchdog/omap_wdt.c                |    1 -
 drivers/hid/hid-core.c                          |    1 -
 drivers/i2c/busses/scx200_acb.c                 |    1 -
 drivers/i2c/i2c-dev.c                           |    1 -
 drivers/ieee1394/dv1394.c                       |    1 -
 drivers/ieee1394/raw1394.c                      |    1 -
 drivers/ieee1394/video1394.c                    |    1 -
 drivers/infiniband/ulp/iser/iser_verbs.c        |    1 -
 drivers/input/evdev.c                           |    1 -
 drivers/input/input.c                           |    1 -
 drivers/input/joydev.c                          |    1 -
 drivers/input/misc/uinput.c                     |    1 -
 drivers/input/mousedev.c                        |    1 -
 drivers/input/tsdev.c                           |    1 -
 drivers/isdn/capi/capi.c                        |    1 -
 drivers/isdn/divert/divert_procfs.c             |    1 -
 drivers/isdn/hardware/eicon/capimain.c          |    1 -
 drivers/isdn/hardware/eicon/divamnt.c           |    1 -
 drivers/isdn/hardware/eicon/divasi.c            |    1 -
 drivers/isdn/hardware/eicon/divasmain.c         |    1 -
 drivers/isdn/hardware/eicon/platform.h          |    1 -
 drivers/isdn/hisax/hfc_usb.c                    |    1 -
 drivers/macintosh/therm_adt746x.c               |    1 -
 drivers/macintosh/therm_pm72.c                  |    1 -
 drivers/macintosh/windfarm_core.c               |    1 -
 drivers/media/dvb/bt8xx/dst_common.h            |    1 -
 drivers/media/dvb/ttpci/av7110_av.c             |    1 -
 drivers/media/dvb/ttpci/av7110_ca.c             |    1 -
 drivers/media/dvb/ttpci/av7110_hw.c             |    1 -
 drivers/media/dvb/ttpci/av7110_v4l.c            |    1 -
 drivers/media/radio/dsbr100.c                   |    1 -
 drivers/media/video/cpia.h                      |    1 -
 drivers/media/video/cpia_pp.c                   |    1 -
 drivers/media/video/cx88/cx88-tvaudio.c         |    1 -
 drivers/media/video/dabusb.c                    |    1 -
 drivers/media/video/ov511.h                     |    1 -
 drivers/media/video/pvrusb2/pvrusb2-main.c      |    1 -
 drivers/media/video/saa7134/saa7134-tvaudio.c   |    1 -
 drivers/media/video/se401.h                     |    1 -
 drivers/media/video/tvaudio.c                   |    1 -
 drivers/media/video/usbvideo/usbvideo.c         |    1 -
 drivers/media/video/usbvision/usbvision-core.c  |    1 -
 drivers/media/video/usbvision/usbvision-video.c |    1 -
 drivers/media/video/v4l1-compat.c               |    1 -
 drivers/media/video/v4l2-common.c               |    1 -
 drivers/media/video/videodev.c                  |    1 -
 drivers/mfd/ucb1x00-ts.c                        |    1 -
 drivers/net/irda/sir_dev.c                      |    1 -
 drivers/net/irda/sir_dongle.c                   |    1 -
 drivers/net/irda/vlsi_ir.c                      |    1 -
 drivers/net/ns83820.c                           |    1 -
 drivers/net/ppp_generic.c                       |    1 -
 drivers/net/wan/cosa.c                          |    1 -
 drivers/net/wireless/airo.c                     |    1 -
 drivers/net/wireless/hostap/hostap_ioctl.c      |    1 -
 drivers/parisc/lba_pci.c                        |    1 -
 drivers/pci/hotplug/acpiphp_core.c              |    1 -
 drivers/pci/hotplug/acpiphp_glue.c              |    1 -
 drivers/pci/hotplug/ibmphp_core.c               |    1 -
 drivers/pci/hotplug/ibmphp_hpc.c                |    1 -
 drivers/pci/hotplug/pci_hotplug_core.c          |    1 -
 drivers/pci/hotplug/rpaphp_core.c               |    1 -
 drivers/pci/hotplug/shpchp_ctrl.c               |    1 -
 drivers/pci/msi.c                               |    1 -
 drivers/pci/proc.c                              |    1 -
 drivers/sbus/char/bpp.c                         |    1 -
 drivers/sbus/char/rtc.c                         |    1 -
 drivers/sbus/char/vfc_dev.c                     |    1 -
 drivers/scsi/aic7xxx/aic79xx_osm.h              |    1 -
 drivers/scsi/aic7xxx/aic7xxx_osm.h              |    1 -
 drivers/scsi/dpt_i2o.c                          |    1 -
 drivers/scsi/scsi_debug.c                       |    1 -
 drivers/scsi/sg.c                               |    1 -
 drivers/serial/icom.c                           |    1 -
 drivers/usb/atm/usbatm.c                        |    1 -
 drivers/usb/class/cdc-acm.c                     |    1 -
 drivers/usb/class/usblp.c                       |    1 -
 drivers/usb/core/hub.c                          |    1 -
 drivers/usb/core/inode.c                        |    1 -
 drivers/usb/core/usb.c                          |    1 -
 drivers/usb/gadget/at91_udc.c                   |    1 -
 drivers/usb/gadget/dummy_hcd.c                  |    1 -
 drivers/usb/gadget/ether.c                      |    1 -
 drivers/usb/gadget/goku_udc.c                   |    1 -
 drivers/usb/gadget/net2280.c                    |    1 -
 drivers/usb/gadget/serial.c                     |    1 -
 drivers/usb/gadget/zero.c                       |    1 -
 drivers/usb/host/ehci-hcd.c                     |    1 -
 drivers/usb/host/ohci-hcd.c                     |    1 -
 drivers/usb/host/sl811-hcd.c                    |    1 -
 drivers/usb/host/u132-hcd.c                     |    1 -
 drivers/usb/image/mdc800.c                      |    1 -
 drivers/usb/image/microtek.c                    |    1 -
 drivers/usb/input/xpad.c                        |    1 -
 drivers/usb/misc/idmouse.c                      |    1 -
 drivers/usb/misc/legousbtower.c                 |    1 -
 drivers/usb/misc/rio500.c                       |    1 -
 drivers/usb/misc/sisusbvga/sisusb_con.c         |    1 -
 drivers/usb/mon/mon_main.c                      |    1 -
 drivers/usb/serial/usb-serial.c                 |    1 -
 drivers/usb/storage/usb.h                       |    1 -
 drivers/video/sis/sis.h                         |    1 -
 drivers/video/sis/sis_main.c                    |    1 -
 fs/9p/vfs_addr.c                                |    1 -
 fs/9p/vfs_dentry.c                              |    1 -
 fs/9p/vfs_dir.c                                 |    1 -
 fs/9p/vfs_file.c                                |    1 -
 fs/9p/vfs_inode.c                               |    1 -
 fs/9p/vfs_super.c                               |    1 -
 fs/afs/dir.c                                    |    1 -
 fs/attr.c                                       |    1 -
 fs/autofs4/inode.c                              |    1 -
 fs/autofs4/root.c                               |    1 -
 fs/bad_inode.c                                  |    1 -
 fs/binfmt_elf.c                                 |    1 -
 fs/binfmt_elf_fdpic.c                           |    1 -
 fs/binfmt_em86.c                                |    1 -
 fs/binfmt_script.c                              |    1 -
 fs/buffer.c                                     |    1 -
 fs/cifs/file.c                                  |    1 -
 fs/cifs/readdir.c                               |    1 -
 fs/compat_ioctl.c                               |    1 -
 fs/dcache.c                                     |    1 -
 fs/dquot.c                                      |    1 -
 fs/ecryptfs/file.c                              |    1 -
 fs/eventpoll.c                                  |    1 -
 fs/exportfs/expfs.c                             |    1 -
 fs/ext2/dir.c                                   |    1 -
 fs/ext2/fsync.c                                 |    1 -
 fs/ext2/xattr_security.c                        |    1 -
 fs/ext2/xattr_trusted.c                         |    1 -
 fs/ext3/dir.c                                   |    1 -
 fs/ext3/inode.c                                 |    1 -
 fs/ext3/namei.c                                 |    1 -
 fs/ext3/resize.c                                |    1 -
 fs/ext3/xattr_security.c                        |    1 -
 fs/ext3/xattr_trusted.c                         |    1 -
 fs/ext3/xattr_user.c                            |    1 -
 fs/ext4/dir.c                                   |    1 -
 fs/ext4/extents.c                               |    1 -
 fs/ext4/inode.c                                 |    1 -
 fs/ext4/namei.c                                 |    1 -
 fs/ext4/resize.c                                |    1 -
 fs/ext4/xattr_security.c                        |    1 -
 fs/ext4/xattr_trusted.c                         |    1 -
 fs/ext4/xattr_user.c                            |    1 -
 fs/fifo.c                                       |    1 -
 fs/file_table.c                                 |    1 -
 fs/gfs2/locking/nolock/main.c                   |    1 -
 fs/gfs2/ops_dentry.c                            |    1 -
 fs/gfs2/ops_file.c                              |    1 -
 fs/jbd/commit.c                                 |    1 -
 fs/jbd/journal.c                                |    1 -
 fs/jbd/revoke.c                                 |    1 -
 fs/jbd/transaction.c                            |    1 -
 fs/jbd2/commit.c                                |    1 -
 fs/jbd2/journal.c                               |    1 -
 fs/jbd2/revoke.c                                |    1 -
 fs/jbd2/transaction.c                           |    1 -
 fs/jfs/jfs_logmgr.c                             |    1 -
 fs/jfs/jfs_txnmgr.c                             |    1 -
 fs/lockd/clntproc.c                             |    1 -
 fs/lockd/svclock.c                              |    1 -
 fs/namei.c                                      |    1 -
 fs/ncpfs/file.c                                 |    1 -
 fs/nfs/client.c                                 |    1 -
 fs/nfs/direct.c                                 |    1 -
 fs/nfs/getroot.c                                |    1 -
 fs/nfs/nfs3proc.c                               |    1 -
 fs/nfs/nfs4renewd.c                             |    1 -
 fs/nfs/proc.c                                   |    1 -
 fs/nfs/symlink.c                                |    1 -
 fs/nfs/write.c                                  |    1 -
 fs/nfsd/nfs4idmap.c                             |    1 -
 fs/nfsd/nfs4xdr.c                               |    1 -
 fs/nfsd/nfsfh.c                                 |    1 -
 fs/ntfs/dir.c                                   |    1 -
 fs/ntfs/inode.c                                 |    1 -
 fs/ocfs2/dlm/dlmfs.c                            |    1 -
 fs/ocfs2/dlmglue.c                              |    1 -
 fs/ocfs2/inode.c                                |    1 -
 fs/ocfs2/slot_map.c                             |    1 -
 fs/ocfs2/vote.c                                 |    1 -
 fs/open.c                                       |    1 -
 fs/proc/base.c                                  |    1 -
 fs/proc/proc_misc.c                             |    1 -
 fs/quota.c                                      |    1 -
 fs/ramfs/file-nommu.c                           |    1 -
 fs/ramfs/inode.c                                |    1 -
 fs/readdir.c                                    |    1 -
 fs/reiserfs/dir.c                               |    1 -
 fs/reiserfs/file.c                              |    1 -
 fs/reiserfs/namei.c                             |    1 -
 fs/reiserfs/procfs.c                            |    1 -
 fs/reiserfs/stree.c                             |    1 -
 fs/reiserfs/super.c                             |    1 -
 fs/select.c                                     |    1 -
 fs/smbfs/smbiod.c                               |    1 -
 fs/smbfs/sock.c                                 |    1 -
 fs/smbfs/symlink.c                              |    1 -
 fs/stat.c                                       |    1 -
 fs/sysv/namei.c                                 |    1 -
 fs/udf/fsync.c                                  |    1 -
 fs/ufs/dir.c                                    |    1 -
 fs/xattr.c                                      |    1 -
 ipc/sem.c                                       |    1 -
 ipc/util.c                                      |    1 -
 kernel/cpuset.c                                 |    1 -
 kernel/exit.c                                   |    1 -
 kernel/fork.c                                   |    1 -
 kernel/itimer.c                                 |    1 -
 kernel/kmod.c                                   |    1 -
 kernel/posix-timers.c                           |    1 -
 kernel/power/process.c                          |    1 -
 kernel/power/snapshot.c                         |    1 -
 kernel/power/swap.c                             |    1 -
 kernel/printk.c                                 |    1 -
 kernel/signal.c                                 |    1 -
 kernel/time.c                                   |    1 -
 kernel/uid16.c                                  |    1 -
 net/appletalk/ddp.c                             |    1 -
 net/ax25/af_ax25.c                              |    1 -
 net/bluetooth/bnep/core.c                       |    1 -
 net/bridge/br_stp.c                             |    1 -
 net/bridge/br_stp_if.c                          |    1 -
 net/bridge/br_stp_timer.c                       |    1 -
 net/core/netpoll.c                              |    1 -
 net/core/pktgen.c                               |    1 -
 net/ipv4/af_inet.c                              |    1 -
 net/ipv4/tcp.c                                  |    1 -
 net/ipv4/tcp_output.c                           |    1 -
 net/ipv6/af_inet6.c                             |    1 -
 net/ipx/af_ipx.c                                |    1 -
 net/irda/af_irda.c                              |    1 -
 net/netlink/af_netlink.c                        |    1 -
 net/unix/af_unix.c                              |    1 -
 net/x25/af_x25.c                                |    1 -
 security/capability.c                           |    1 -
 security/commoncap.c                            |    1 -
 security/selinux/hooks.c                        |    1 -
 sound/core/control.c                            |    1 -
 sound/core/hwdep.c                              |    1 -
 sound/core/oss/mixer_oss.c                      |    1 -
 sound/core/oss/pcm_oss.c                        |    1 -
 sound/core/pcm_native.c                         |    1 -
 sound/core/rawmidi.c                            |    1 -
 sound/core/seq/oss/seq_oss.c                    |    1 -
 sound/core/seq/seq_clientmgr.c                  |    1 -
 sound/core/timer.c                              |    1 -
 sound/oss/swarm_cs4297a.c                       |    1 -
 sound/oss/trident.c                             |    1 -
 sound/oss/via82cxxx_audio.c                     |    1 -
 439 files changed, 439 deletions(-)

diff -puN arch/alpha/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/alpha/kernel/process.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff -puN arch/alpha/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/alpha/kernel/signal.c
--- a/arch/alpha/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/alpha/kernel/signal.c
@@ -15,7 +15,6 @@
 #include <linux/unistd.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
diff -puN arch/alpha/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/alpha/kernel/smp.c
@@ -18,7 +18,6 @@
 #include <linux/mm.h>
 #include <linux/threads.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff -puN arch/alpha/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/alpha/mm/fault.c
--- a/arch/alpha/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/alpha/mm/fault.c
@@ -21,7 +21,6 @@
 #include <linux/ptrace.h>
 #include <linux/mman.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 
diff -puN arch/arm/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/arm/kernel/ptrace.c
--- a/arch/arm/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/arm/kernel/ptrace.c
@@ -13,7 +13,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/security.h>
diff -puN arch/arm26/kernel/armksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/arm26/kernel/armksyms.c
--- a/arch/arm26/kernel/armksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/arm26/kernel/armksyms.c
@@ -20,7 +20,6 @@
 #include <linux/pm.h>
 #include <linux/tty.h>
 #include <linux/vt_kern.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 
 #include <asm/byteorder.h>
diff -puN arch/arm26/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/arm26/kernel/ptrace.c
--- a/arch/arm26/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/arm26/kernel/ptrace.c
@@ -13,7 +13,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/security.h>
diff -puN arch/arm26/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/arm26/kernel/signal.c
--- a/arch/arm26/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/arm26/kernel/signal.c
@@ -13,7 +13,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
diff -puN arch/avr32/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/avr32/kernel/ptrace.c
@@ -9,7 +9,6 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
 #include <linux/user.h>
diff -puN arch/cris/arch-v10/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/cris/arch-v10/kernel/ptrace.c
--- a/arch/cris/arch-v10/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/cris/arch-v10/kernel/ptrace.c
@@ -6,7 +6,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/cris/arch-v10/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/cris/arch-v10/kernel/signal.c
--- a/arch/cris/arch-v10/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/cris/arch-v10/kernel/signal.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/cris/arch-v32/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/cris/arch-v32/kernel/ptrace.c
--- a/arch/cris/arch-v32/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/cris/arch-v32/kernel/ptrace.c
@@ -6,7 +6,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/cris/kernel/crisksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/cris/kernel/crisksyms.c
--- a/arch/cris/kernel/crisksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/cris/kernel/crisksyms.c
@@ -4,7 +4,6 @@
 #include <linux/sched.h>
 #include <linux/in6.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/pm.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN arch/cris/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/cris/kernel/ptrace.c
--- a/arch/cris/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/cris/kernel/ptrace.c
@@ -67,7 +67,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/frv/kernel/irq.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/frv/kernel/irq.c
--- a/arch/frv/kernel/irq.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/frv/kernel/irq.c
@@ -18,7 +18,6 @@
 #include <linux/timex.h>
 #include <linux/slab.h>
 #include <linux/random.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
 #include <linux/irq.h>
diff -puN arch/frv/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/frv/kernel/ptrace.c
--- a/arch/frv/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/frv/kernel/ptrace.c
@@ -14,7 +14,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/frv/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/frv/kernel/signal.c
--- a/arch/frv/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/frv/kernel/signal.c
@@ -13,7 +13,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/frv/kernel/sys_frv.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/frv/kernel/sys_frv.c
--- a/arch/frv/kernel/sys_frv.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/frv/kernel/sys_frv.c
@@ -14,7 +14,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/h8300/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/h8300/kernel/ptrace.c
--- a/arch/h8300/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/h8300/kernel/ptrace.c
@@ -19,7 +19,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/h8300/kernel/sys_h8300.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/h8300/kernel/sys_h8300.c
--- a/arch/h8300/kernel/sys_h8300.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/h8300/kernel/sys_h8300.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/i386/kernel/apic.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/apic.c
@@ -19,7 +19,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/bootmem.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/mc146818rtc.h>
 #include <linux/kernel_stat.h>
diff -puN arch/i386/kernel/apm.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/apm.c
@@ -223,7 +223,6 @@
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/dmi.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
diff -puN arch/i386/kernel/i8259.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/i8259.c
--- a/arch/i386/kernel/i8259.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/i8259.c
@@ -5,7 +5,6 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/random.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
diff -puN arch/i386/kernel/io_apic.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/io_apic.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/mc146818rtc.h>
 #include <linux/compiler.h>
 #include <linux/acpi.h>
diff -puN arch/i386/kernel/ioport.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/ioport.c
--- a/arch/i386/kernel/ioport.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/ioport.c
@@ -12,7 +12,6 @@
 #include <linux/types.h>
 #include <linux/ioport.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/thread_info.h>
diff -puN arch/i386/kernel/ldt.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/ldt.c
--- a/arch/i386/kernel/ldt.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/ldt.c
@@ -10,7 +10,6 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 
diff -puN arch/i386/kernel/mpparse.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/mpparse.c
--- a/arch/i386/kernel/mpparse.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/mpparse.c
@@ -18,7 +18,6 @@
 #include <linux/acpi.h>
 #include <linux/delay.h>
 #include <linux/bootmem.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
 #include <linux/bitops.h>
diff -puN arch/i386/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/process.c
@@ -21,7 +21,6 @@
 #include <linux/mm.h>
 #include <linux/elfcore.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
diff -puN arch/i386/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/ptrace.c
@@ -9,7 +9,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/i386/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/signal.c
--- a/arch/i386/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/signal.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/i386/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/smp.c
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
 #include <linux/cache.h>
diff -puN arch/i386/kernel/smpboot.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/smpboot.c
@@ -40,7 +40,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
-#include <linux/smp_lock.h>
 #include <linux/bootmem.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
diff -puN arch/i386/kernel/sys_i386.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/sys_i386.c
--- a/arch/i386/kernel/sys_i386.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/sys_i386.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/i386/kernel/vm86.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/kernel/vm86.c
--- a/arch/i386/kernel/vm86.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/kernel/vm86.c
@@ -39,7 +39,6 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
 #include <linux/audit.h>
diff -puN arch/i386/mach-visws/visws_apic.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/mach-visws/visws_apic.c
--- a/arch/i386/mach-visws/visws_apic.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/mach-visws/visws_apic.c
@@ -18,7 +18,6 @@
 
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 
 #include <asm/io.h>
diff -puN arch/i386/mach-voyager/voyager_smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/mach-voyager/voyager_smp.c
--- a/arch/i386/mach-voyager/voyager_smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/mach-voyager/voyager_smp.c
@@ -16,7 +16,6 @@
 #include <linux/mc146818rtc.h>
 #include <linux/cache.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/bootmem.h>
diff -puN arch/i386/mach-voyager/voyager_thread.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/mach-voyager/voyager_thread.c
--- a/arch/i386/mach-voyager/voyager_thread.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/mach-voyager/voyager_thread.c
@@ -18,7 +18,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/delay.h>
 #include <linux/mc146818rtc.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/kmod.h>
diff -puN arch/i386/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/mm/fault.c
@@ -14,7 +14,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/tty.h>
diff -puN arch/i386/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/i386/mm/hugetlbpage.c
--- a/arch/i386/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/i386/mm/hugetlbpage.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/sysctl.h>
diff -puN arch/ia64/ia32/ia32_ldt.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/ia32/ia32_ldt.c
--- a/arch/ia64/ia32/ia32_ldt.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/ia32/ia32_ldt.c
@@ -10,7 +10,6 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
diff -puN arch/ia64/ia32/ia32_signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/ia32/ia32_signal.c
--- a/arch/ia64/ia32/ia32_signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/ia32/ia32_signal.c
@@ -18,7 +18,6 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
diff -puN arch/ia64/kernel/iosapic.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/iosapic.c
@@ -87,7 +87,6 @@
 #include <linux/list.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/bootmem.h>
 
diff -puN arch/ia64/kernel/irq_ia64.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/irq_ia64.c
--- a/arch/ia64/kernel/irq_ia64.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/irq_ia64.c
@@ -27,7 +27,6 @@
 #include <linux/random.h>	/* for rand_initialize_irq() */
 #include <linux/signal.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/threads.h>
 #include <linux/bitops.h>
 #include <linux/irq.h>
diff -puN arch/ia64/kernel/mca.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/mca.c
@@ -63,7 +63,6 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/smp_lock.h>
 #include <linux/bootmem.h>
 #include <linux/acpi.h>
 #include <linux/timer.h>
diff -puN arch/ia64/kernel/mca_drv.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/mca_drv.c
--- a/arch/ia64/kernel/mca_drv.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/mca_drv.c
@@ -14,7 +14,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/kallsyms.h>
-#include <linux/smp_lock.h>
 #include <linux/bootmem.h>
 #include <linux/acpi.h>
 #include <linux/timer.h>
diff -puN arch/ia64/kernel/perfmon.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/perfmon.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
diff -puN arch/ia64/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/process.c
@@ -20,7 +20,6 @@
 #include <linux/personality.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/thread_info.h>
 #include <linux/unistd.h>
diff -puN arch/ia64/kernel/salinfo.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/salinfo.c
@@ -42,7 +42,6 @@
 #include <linux/proc_fs.h>
 #include <linux/module.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/vmalloc.h>
 
diff -puN arch/ia64/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/signal.c
--- a/arch/ia64/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/signal.c
@@ -14,7 +14,6 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
diff -puN arch/ia64/kernel/smpboot.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/smpboot.c
@@ -35,7 +35,6 @@
 #include <linux/mm.h>
 #include <linux/notifier.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/efi.h>
 #include <linux/percpu.h>
diff -puN arch/ia64/kernel/sys_ia64.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/sys_ia64.c
--- a/arch/ia64/kernel/sys_ia64.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -13,7 +13,6 @@
 #include <linux/shm.h>
 #include <linux/file.h>		/* doh, must come after sched.h... */
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/highuid.h>
 #include <linux/hugetlb.h>
diff -puN arch/ia64/kernel/unaligned.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/kernel/unaligned.c
--- a/arch/ia64/kernel/unaligned.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/kernel/unaligned.c
@@ -15,7 +15,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/tty.h>
 
 #include <asm/intrinsics.h>
diff -puN arch/ia64/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/mm/fault.c
@@ -7,7 +7,6 @@
 #include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
diff -puN arch/ia64/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <asm/mman.h>
diff -puN arch/ia64/pci/pci.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ia64/pci/pci.c
--- a/arch/ia64/pci/pci.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ia64/pci/pci.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 
 #include <asm/machvec.h>
diff -puN arch/m32r/kernel/m32r_ksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m32r/kernel/m32r_ksyms.c
--- a/arch/m32r/kernel/m32r_ksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m32r/kernel/m32r_ksyms.c
@@ -5,7 +5,6 @@
 #include <linux/sched.h>
 #include <linux/in6.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 
 #include <asm/semaphore.h>
diff -puN arch/m32r/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m32r/kernel/signal.c
--- a/arch/m32r/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m32r/kernel/signal.c
@@ -13,7 +13,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/m32r/kernel/smpboot.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m32r/kernel/smpboot.c
@@ -43,7 +43,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/irq.h>
 #include <linux/bootmem.h>
 #include <linux/delay.h>
diff -puN arch/m32r/kernel/sys_m32r.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m32r/kernel/sys_m32r.c
--- a/arch/m32r/kernel/sys_m32r.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m32r/kernel/sys_m32r.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/m32r/mm/fault-nommu.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m32r/mm/fault-nommu.c
--- a/arch/m32r/mm/fault-nommu.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m32r/mm/fault-nommu.c
@@ -17,7 +17,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/vt_kern.h>              /* For unblank_screen() */
diff -puN arch/m32r/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m32r/mm/fault.c
--- a/arch/m32r/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m32r/mm/fault.c
@@ -18,7 +18,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/tty.h>
diff -puN arch/m68k/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m68k/kernel/ptrace.c
--- a/arch/m68k/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m68k/kernel/ptrace.c
@@ -14,7 +14,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/m68k/mvme16x/rtc.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m68k/mvme16x/rtc.c
--- a/arch/m68k/mvme16x/rtc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m68k/mvme16x/rtc.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/mc146818rtc.h>	/* For struct rtc_time and ioctls, etc */
-#include <linux/smp_lock.h>
 #include <linux/bcd.h>
 #include <asm/mvme16xhw.h>
 
diff -puN arch/m68knommu/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m68knommu/kernel/ptrace.c
--- a/arch/m68knommu/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m68knommu/kernel/ptrace.c
@@ -14,7 +14,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/m68knommu/kernel/sys_m68k.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/m68knommu/kernel/sys_m68k.c
--- a/arch/m68knommu/kernel/sys_m68k.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/m68knommu/kernel/sys_m68k.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/mips/jmr3927/rbhma3100/irq.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/jmr3927/rbhma3100/irq.c
diff -puN arch/mips/kernel/irixelf.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/irixelf.c
--- a/arch/mips/kernel/irixelf.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/irixelf.c
@@ -31,7 +31,6 @@
 #include <linux/shm.h>
 #include <linux/personality.h>
 #include <linux/elfcore.h>
-#include <linux/smp_lock.h>
 
 #include <asm/mipsregs.h>
 #include <asm/namei.h>
diff -puN arch/mips/kernel/irixioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/irixioctl.c
--- a/arch/mips/kernel/irixioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/irixioctl.c
@@ -9,7 +9,6 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sockios.h>
 #include <linux/syscalls.h>
 #include <linux/tty.h>
diff -puN arch/mips/kernel/irixsig.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/irixsig.c
--- a/arch/mips/kernel/irixsig.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/irixsig.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/ptrace.h>
 #include <linux/resource.h>
diff -puN arch/mips/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/ptrace.c
--- a/arch/mips/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/ptrace.c
@@ -22,7 +22,6 @@
 #include <linux/ptrace.h>
 #include <linux/audit.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/signal.h>
diff -puN arch/mips/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/signal.c
--- a/arch/mips/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/signal.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/personality.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/mips/kernel/signal32.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/signal32.c
--- a/arch/mips/kernel/signal32.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/signal32.c
@@ -12,7 +12,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/syscalls.h>
diff -puN arch/mips/kernel/signal_n32.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/signal_n32.c
--- a/arch/mips/kernel/signal_n32.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/signal_n32.c
@@ -19,7 +19,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/mips/kernel/syscall.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/syscall.c
--- a/arch/mips/kernel/syscall.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/syscall.c
@@ -13,7 +13,6 @@
 #include <linux/linkage.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/mman.h>
 #include <linux/ptrace.h>
 #include <linux/sched.h>
diff -puN arch/mips/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/traps.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/kallsyms.h>
 #include <linux/bootmem.h>
diff -puN arch/mips/kernel/unaligned.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/kernel/unaligned.c
--- a/arch/mips/kernel/unaligned.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/kernel/unaligned.c
@@ -76,7 +76,6 @@
 #include <linux/module.h>
 #include <linux/signal.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 
 #include <asm/asm.h>
 #include <asm/branch.h>
diff -puN arch/mips/math-emu/dsemul.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/math-emu/dsemul.c
--- a/arch/mips/math-emu/dsemul.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/math-emu/dsemul.c
@@ -2,7 +2,6 @@
 #include <linux/mm.h>
 #include <linux/signal.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 
 #include <asm/asm.h>
 #include <asm/bootinfo.h>
diff -puN arch/mips/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/mm/fault.c
--- a/arch/mips/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/mm/fault.c
@@ -16,7 +16,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/vt_kern.h>		/* For unblank_screen() */
 #include <linux/module.h>
 
diff -puN arch/mips/sgi-ip27/ip27-irq.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/mips/sgi-ip27/ip27-irq.c
--- a/arch/mips/sgi-ip27/ip27-irq.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/mips/sgi-ip27/ip27-irq.c
@@ -19,7 +19,6 @@
 #include <linux/timex.h>
 #include <linux/slab.h>
 #include <linux/random.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/kernel_stat.h>
 #include <linux/delay.h>
diff -puN arch/parisc/hpux/fs.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/parisc/hpux/fs.c
--- a/arch/parisc/hpux/fs.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/parisc/hpux/fs.c
@@ -24,7 +24,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/file.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/ptrace.h>
 #include <asm/errno.h>
diff -puN arch/parisc/hpux/ioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/parisc/hpux/ioctl.c
--- a/arch/parisc/hpux/ioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/parisc/hpux/ioctl.c
@@ -34,7 +34,6 @@
  */
 
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <asm/errno.h>
 #include <asm/ioctl.h>
diff -puN arch/parisc/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/parisc/kernel/ptrace.c
--- a/arch/parisc/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/parisc/kernel/ptrace.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/parisc/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/parisc/kernel/signal.c
--- a/arch/parisc/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/parisc/kernel/signal.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/parisc/kernel/signal32.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/parisc/kernel/signal32.c
--- a/arch/parisc/kernel/signal32.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/parisc/kernel/signal32.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/unistd.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/syscalls.h>
diff -puN arch/parisc/kernel/sys_parisc.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/parisc/kernel/sys_parisc.c
--- a/arch/parisc/kernel/sys_parisc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -29,7 +29,6 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/shm.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/utsname.h>
 #include <linux/personality.h>
diff -puN arch/parisc/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/parisc/kernel/traps.c
--- a/arch/parisc/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/parisc/kernel/traps.c
@@ -20,7 +20,6 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff -puN arch/powerpc/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/kernel/process.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff -puN arch/powerpc/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/kernel/ptrace.c
@@ -19,7 +19,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/powerpc/kernel/signal_32.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/kernel/signal_32.c
--- a/arch/powerpc/kernel/signal_32.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/kernel/signal_32.c
@@ -20,7 +20,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/powerpc/kernel/signal_64.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/kernel/signal_64.c
--- a/arch/powerpc/kernel/signal_64.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/kernel/signal_64.c
@@ -15,7 +15,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/powerpc/kernel/syscalls.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/kernel/syscalls.c
--- a/arch/powerpc/kernel/syscalls.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/kernel/syscalls.c
@@ -24,7 +24,6 @@
 #include <linux/syscalls.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/powerpc/kernel/vdso.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/kernel/vdso.c
--- a/arch/powerpc/kernel/vdso.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/kernel/vdso.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/slab.h>
diff -puN arch/powerpc/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/sysctl.h>
diff -puN arch/powerpc/platforms/cell/spufs/backing_ops.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/platforms/cell/spufs/backing_ops.c
--- a/arch/powerpc/platforms/cell/spufs/backing_ops.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/platforms/cell/spufs/backing_ops.c
@@ -28,7 +28,6 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/poll.h>
diff -puN arch/powerpc/platforms/cell/spufs/hw_ops.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/platforms/cell/spufs/hw_ops.c
--- a/arch/powerpc/platforms/cell/spufs/hw_ops.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/platforms/cell/spufs/hw_ops.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/poll.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 
diff -puN arch/powerpc/platforms/cell/spufs/sched.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/platforms/cell/spufs/sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/platforms/cell/spufs/sched.c
@@ -30,7 +30,6 @@
 #include <linux/completion.h>
 #include <linux/vmalloc.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/numa.h>
diff -puN arch/powerpc/platforms/cell/spufs/switch.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/platforms/cell/spufs/switch.c
--- a/arch/powerpc/platforms/cell/spufs/switch.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/platforms/cell/spufs/switch.c
@@ -39,7 +39,6 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 
diff -puN arch/powerpc/platforms/chrp/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/platforms/chrp/smp.c
--- a/arch/powerpc/platforms/chrp/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/platforms/chrp/smp.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/delay.h>
diff -puN arch/powerpc/platforms/iseries/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/platforms/iseries/smp.c
--- a/arch/powerpc/platforms/iseries/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/platforms/iseries/smp.c
@@ -18,7 +18,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/delay.h>
diff -puN arch/powerpc/platforms/iseries/viopath.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/platforms/iseries/viopath.c
--- a/arch/powerpc/platforms/iseries/viopath.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/platforms/iseries/viopath.c
@@ -36,7 +36,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/wait.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 
 #include <asm/system.h>
diff -puN arch/powerpc/platforms/powermac/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/powerpc/platforms/powermac/smp.c
--- a/arch/powerpc/platforms/powermac/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/powerpc/platforms/powermac/smp.c
@@ -24,7 +24,6 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/delay.h>
diff -puN arch/ppc/kernel/ppc_htab.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ppc/kernel/ppc_htab.c
--- a/arch/ppc/kernel/ppc_htab.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ppc/kernel/ppc_htab.c
@@ -18,7 +18,6 @@
 #include <linux/capability.h>
 #include <linux/ctype.h>
 #include <linux/threads.h>
-#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
diff -puN arch/ppc/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/ppc/kernel/smp.c
--- a/arch/ppc/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/ppc/kernel/smp.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/delay.h>
diff -puN arch/s390/kernel/compat_signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/s390/kernel/compat_signal.c
--- a/arch/s390/kernel/compat_signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/s390/kernel/compat_signal.c
@@ -14,7 +14,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/s390/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/s390/kernel/process.c
--- a/arch/s390/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/s390/kernel/process.c
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff -puN arch/s390/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/s390/kernel/signal.c
--- a/arch/s390/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/s390/kernel/signal.c
@@ -14,7 +14,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/s390/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/s390/kernel/smp.c
--- a/arch/s390/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/s390/kernel/smp.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/spinlock.h>
 #include <linux/kernel_stat.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/cache.h>
 #include <linux/interrupt.h>
diff -puN arch/s390/kernel/sys_s390.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/s390/kernel/sys_s390.c
--- a/arch/s390/kernel/sys_s390.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/s390/kernel/sys_s390.c
@@ -17,7 +17,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/s390/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/s390/kernel/traps.c
--- a/arch/s390/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/s390/kernel/traps.c
@@ -22,7 +22,6 @@
 #include <linux/timer.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
diff -puN arch/s390/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/s390/mm/fault.c
diff -puN arch/sh/drivers/pci/pci-st40.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh/drivers/pci/pci-st40.c
--- a/arch/sh/drivers/pci/pci-st40.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh/drivers/pci/pci-st40.c
@@ -9,7 +9,6 @@
 
 #include <linux/kernel.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/pci.h>
diff -puN arch/sh/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh/kernel/ptrace.c
--- a/arch/sh/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh/kernel/ptrace.c
@@ -12,7 +12,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/sh/kernel/sh_ksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh/kernel/sh_ksyms.c
--- a/arch/sh/kernel/sh_ksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh/kernel/sh_ksyms.c
@@ -5,7 +5,6 @@
 #include <linux/sched.h>
 #include <linux/in6.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/pci.h>
 #include <linux/irq.h>
diff -puN arch/sh/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh/kernel/signal.c
--- a/arch/sh/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh/kernel/signal.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/sh/kernel/sys_sh.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh/kernel/sys_sh.c
--- a/arch/sh/kernel/sys_sh.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh/kernel/sys_sh.c
@@ -12,7 +12,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/sh/mm/fault-nommu.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh/mm/fault-nommu.c
--- a/arch/sh/mm/fault-nommu.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh/mm/fault-nommu.c
@@ -19,7 +19,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 
 #include <asm/system.h>
diff -puN arch/sh/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh/mm/hugetlbpage.c
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 
diff -puN arch/sh64/kernel/irq.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh64/kernel/irq.c
--- a/arch/sh64/kernel/irq.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh64/kernel/irq.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
diff -puN arch/sh64/kernel/pci_sh5.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh64/kernel/pci_sh5.c
--- a/arch/sh64/kernel/pci_sh5.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh64/kernel/pci_sh5.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/rwsem.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/errno.h>
diff -puN arch/sh64/kernel/sh_ksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh64/kernel/sh_ksyms.c
--- a/arch/sh64/kernel/sh_ksyms.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh64/kernel/sh_ksyms.c
@@ -17,7 +17,6 @@
 #include <linux/sched.h>
 #include <linux/in6.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/screen_info.h>
 
 #include <asm/semaphore.h>
diff -puN arch/sh64/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh64/kernel/signal.c
--- a/arch/sh64/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh64/kernel/signal.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/sh64/kernel/sys_sh64.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh64/kernel/sys_sh64.c
--- a/arch/sh64/kernel/sys_sh64.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh64/kernel/sys_sh64.c
@@ -20,7 +20,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/sh64/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh64/kernel/traps.c
--- a/arch/sh64/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh64/kernel/traps.c
@@ -23,7 +23,6 @@
 #include <linux/timer.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
diff -puN arch/sh64/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh64/mm/fault.c
--- a/arch/sh64/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh64/mm/fault.c
@@ -22,7 +22,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 
 #include <asm/system.h>
diff -puN arch/sh64/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh64/mm/hugetlbpage.c
--- a/arch/sh64/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh64/mm/hugetlbpage.c
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 
diff -puN arch/sh64/mm/tlbmiss.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sh64/mm/tlbmiss.c
--- a/arch/sh64/mm/tlbmiss.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sh64/mm/tlbmiss.c
@@ -32,7 +32,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 
 #include <asm/system.h>
diff -puN arch/sparc/kernel/irq.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/irq.c
--- a/arch/sparc/kernel/irq.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/kernel/irq.c
@@ -24,7 +24,6 @@
 #include <linux/random.h>
 #include <linux/init.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/threads.h>
 #include <linux/spinlock.h>
diff -puN arch/sparc/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/process.c
--- a/arch/sparc/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/kernel/process.c
@@ -23,7 +23,6 @@
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
diff -puN arch/sparc/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/signal.c
--- a/arch/sparc/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/kernel/signal.c
@@ -17,7 +17,6 @@
 #include <linux/mm.h>
 #include <linux/tty.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/binfmts.h>	/* do_coredum */
 #include <linux/bitops.h>
 
diff -puN arch/sparc/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/smp.c
--- a/arch/sparc/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/kernel/smp.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/threads.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/init.h>
diff -puN arch/sparc/kernel/sun4d_irq.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/sun4d_irq.c
--- a/arch/sparc/kernel/sun4d_irq.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/kernel/sun4d_irq.c
@@ -17,7 +17,6 @@
 #include <linux/random.h>
 #include <linux/init.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/seq_file.h>
 
diff -puN arch/sparc/kernel/sun4d_smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/sun4d_smp.c
--- a/arch/sparc/kernel/sun4d_smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/kernel/sun4d_smp.c
@@ -12,7 +12,6 @@
 #include <linux/sched.h>
 #include <linux/threads.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/init.h>
diff -puN arch/sparc/kernel/sun4m_smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/sun4m_smp.c
--- a/arch/sparc/kernel/sun4m_smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/kernel/sun4m_smp.c
@@ -9,7 +9,6 @@
 #include <linux/sched.h>
 #include <linux/threads.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/init.h>
diff -puN arch/sparc/kernel/sunos_ioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/sunos_ioctl.c
--- a/arch/sparc/kernel/sunos_ioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/kernel/sunos_ioctl.c
@@ -21,7 +21,6 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
 
diff -puN arch/sparc/kernel/sys_solaris.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/sys_solaris.c
--- a/arch/sparc/kernel/sys_solaris.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/kernel/sys_solaris.c
@@ -12,7 +12,6 @@
 #include <linux/ptrace.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 
 asmlinkage int
diff -puN arch/sparc/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/kernel/traps.c
diff -puN arch/sparc/lib/bitext.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/lib/bitext.c
--- a/arch/sparc/lib/bitext.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/lib/bitext.c
@@ -9,7 +9,6 @@
  * fragmentation.
  */
 
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
 
diff -puN arch/sparc/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc/mm/fault.c
--- a/arch/sparc/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc/mm/fault.c
@@ -18,7 +18,6 @@
 #include <linux/signal.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kdebug.h>
diff -puN arch/sparc64/kernel/pci.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/kernel/pci.c
--- a/arch/sparc64/kernel/pci.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/kernel/pci.c
@@ -12,7 +12,6 @@
 #include <linux/sched.h>
 #include <linux/capability.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/msi.h>
 #include <linux/irq.h>
 #include <linux/init.h>
diff -puN arch/sparc64/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/kernel/process.c
--- a/arch/sparc64/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/kernel/process.c
@@ -19,7 +19,6 @@
 #include <linux/kallsyms.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
diff -puN arch/sparc64/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/kernel/signal.c
--- a/arch/sparc64/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/kernel/signal.c
@@ -20,7 +20,6 @@
 #include <linux/unistd.h>
 #include <linux/mm.h>
 #include <linux/tty.h>
-#include <linux/smp_lock.h>
 #include <linux/binfmts.h>
 #include <linux/bitops.h>
 
diff -puN arch/sparc64/kernel/signal32.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/kernel/signal32.c
--- a/arch/sparc64/kernel/signal32.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/kernel/signal32.c
@@ -17,7 +17,6 @@
 #include <linux/unistd.h>
 #include <linux/mm.h>
 #include <linux/tty.h>
-#include <linux/smp_lock.h>
 #include <linux/binfmts.h>
 #include <linux/compat.h>
 #include <linux/bitops.h>
diff -puN arch/sparc64/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/kernel/smp.c
@@ -10,7 +10,6 @@
 #include <linux/pagemap.h>
 #include <linux/threads.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/delay.h>
diff -puN arch/sparc64/kernel/sunos_ioctl32.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/kernel/sunos_ioctl32.c
--- a/arch/sparc64/kernel/sunos_ioctl32.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/kernel/sunos_ioctl32.c
@@ -22,7 +22,6 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/compat.h>
 
diff -puN arch/sparc64/kernel/sys_sparc.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/kernel/sys_sparc.c
--- a/arch/sparc64/kernel/sys_sparc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/kernel/sys_sparc.c
@@ -19,7 +19,6 @@
 #include <linux/mman.h>
 #include <linux/utsname.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/ipc.h>
diff -puN arch/sparc64/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/kernel/traps.c
--- a/arch/sparc64/kernel/traps.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/kernel/traps.c
@@ -15,7 +15,6 @@
 #include <linux/kallsyms.h>
 #include <linux/signal.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/kdebug.h>
diff -puN arch/sparc64/kernel/unaligned.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/kernel/unaligned.c
--- a/arch/sparc64/kernel/unaligned.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/kernel/unaligned.c
@@ -18,7 +18,6 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/bitops.h>
 #include <linux/kallsyms.h>
 #include <asm/fpumacro.h>
diff -puN arch/sparc64/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/mm/fault.c
--- a/arch/sparc64/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/mm/fault.c
@@ -15,7 +15,6 @@
 #include <linux/signal.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kprobes.h>
diff -puN arch/sparc64/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/mm/hugetlbpage.c
--- a/arch/sparc64/mm/hugetlbpage.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/mm/hugetlbpage.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 
diff -puN arch/sparc64/solaris/ipc.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/solaris/ipc.c
--- a/arch/sparc64/solaris/ipc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/solaris/ipc.c
@@ -6,7 +6,6 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/shm.h>
diff -puN arch/sparc64/solaris/misc.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/solaris/misc.c
--- a/arch/sparc64/solaris/misc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/solaris/misc.c
@@ -6,7 +6,6 @@
 
 #include <linux/module.h> 
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/utsname.h>
 #include <linux/limits.h>
 #include <linux/mm.h>
diff -puN arch/sparc64/solaris/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/solaris/signal.c
--- a/arch/sparc64/solaris/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/solaris/signal.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 
 #include <asm/uaccess.h>
diff -puN arch/sparc64/solaris/socket.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/solaris/socket.c
--- a/arch/sparc64/solaris/socket.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/solaris/socket.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/socket.h>
diff -puN arch/sparc64/solaris/socksys.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/sparc64/solaris/socksys.c
--- a/arch/sparc64/solaris/socksys.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/sparc64/solaris/socksys.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/ioctl.h>
 #include <linux/fs.h>
 #include <linux/file.h>
diff -puN arch/v850/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/v850/kernel/process.c
--- a/arch/v850/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/v850/kernel/process.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff -puN arch/v850/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/v850/kernel/ptrace.c
--- a/arch/v850/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/v850/kernel/ptrace.c
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/ptrace.h>
 #include <linux/signal.h>
 
diff -puN arch/v850/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/v850/kernel/signal.c
--- a/arch/v850/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/v850/kernel/signal.c
@@ -17,7 +17,6 @@
 
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/v850/kernel/syscalls.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/v850/kernel/syscalls.c
--- a/arch/v850/kernel/syscalls.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/v850/kernel/syscalls.c
@@ -18,7 +18,6 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
diff -puN arch/x86_64/ia32/ia32_signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/ia32/ia32_signal.c
--- a/arch/x86_64/ia32/ia32_signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/ia32/ia32_signal.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/x86_64/kernel/apic.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/apic.c
@@ -19,7 +19,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/bootmem.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/mc146818rtc.h>
 #include <linux/kernel_stat.h>
diff -puN arch/x86_64/kernel/i8259.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/i8259.c
--- a/arch/x86_64/kernel/i8259.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/i8259.c
@@ -7,7 +7,6 @@
 #include <linux/timex.h>
 #include <linux/slab.h>
 #include <linux/random.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
diff -puN arch/x86_64/kernel/io_apic.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/io_apic.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/mc146818rtc.h>
 #include <linux/acpi.h>
diff -puN arch/x86_64/kernel/ioport.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/ioport.c
--- a/arch/x86_64/kernel/ioport.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/ioport.c
@@ -12,7 +12,6 @@
 #include <linux/types.h>
 #include <linux/ioport.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/thread_info.h>
diff -puN arch/x86_64/kernel/ldt.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/ldt.c
--- a/arch/x86_64/kernel/ldt.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/ldt.c
@@ -13,7 +13,6 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 
diff -puN arch/x86_64/kernel/mpparse.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/mpparse.c
--- a/arch/x86_64/kernel/mpparse.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/mpparse.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/bootmem.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
 #include <linux/acpi.h>
diff -puN arch/x86_64/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/ptrace.c
--- a/arch/x86_64/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/ptrace.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
diff -puN arch/x86_64/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/signal.c
--- a/arch/x86_64/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/signal.c
@@ -12,7 +12,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN arch/x86_64/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/smp.c
--- a/arch/x86_64/kernel/smp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/smp.c
@@ -14,7 +14,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/smp.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
diff -puN arch/x86_64/kernel/smpboot.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/smpboot.c
@@ -42,7 +42,6 @@
 
 #include <linux/mm.h>
 #include <linux/kernel_stat.h>
-#include <linux/smp_lock.h>
 #include <linux/bootmem.h>
 #include <linux/thread_info.h>
 #include <linux/module.h>
diff -puN arch/x86_64/kernel/sys_x86_64.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/kernel/sys_x86_64.c
--- a/arch/x86_64/kernel/sys_x86_64.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/kernel/sys_x86_64.c
@@ -7,7 +7,6 @@
 #include <linux/syscalls.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff -puN arch/x86_64/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/x86_64/mm/fault.c
@@ -15,7 +15,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/tty.h>
diff -puN arch/xtensa/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/xtensa/kernel/process.c
@@ -20,7 +20,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff -puN arch/xtensa/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/xtensa/kernel/ptrace.c
@@ -19,7 +19,6 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/security.h>
 #include <linux/signal.h>
 
diff -puN arch/xtensa/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used arch/xtensa/kernel/signal.c
--- a/arch/xtensa/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/arch/xtensa/kernel/signal.c
@@ -17,7 +17,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff -puN drivers/acpi/osl.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/acpi/osl.c
@@ -30,7 +30,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kmod.h>
 #include <linux/delay.h>
diff -puN drivers/block/acsi_slm.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/block/acsi_slm.c
--- a/drivers/block/acsi_slm.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/block/acsi_slm.c
@@ -65,7 +65,6 @@ not be guaranteed. There are several way
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
diff -puN drivers/block/umem.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/block/umem.c
--- a/drivers/block/umem.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/block/umem.c
@@ -44,7 +44,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
diff -puN /dev/null /dev/null
diff -puN drivers/char/ds1620.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/ds1620.c
--- a/drivers/char/ds1620.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/ds1620.c
@@ -4,7 +4,6 @@
  */
 #include <linux/module.h>
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
 #include <linux/capability.h>
diff -puN drivers/char/dsp56k.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/dsp56k.c
--- a/drivers/char/dsp56k.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/dsp56k.c
@@ -32,7 +32,6 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 
 #include <asm/atarihw.h>
diff -puN drivers/char/dtlk.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/dtlk.c
--- a/drivers/char/dtlk.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/dtlk.c
@@ -62,7 +62,6 @@
 #include <linux/init.h>		/* for __init, module_{init,exit} */
 #include <linux/poll.h>		/* for POLLIN, etc. */
 #include <linux/dtlk.h>		/* local header file for DoubleTalk values */
-#include <linux/smp_lock.h>
 
 #ifdef TRACING
 #define TRACE_TEXT(str) printk(str);
diff -puN drivers/char/ec3104_keyb.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/ec3104_keyb.c
--- a/drivers/char/ec3104_keyb.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/ec3104_keyb.c
@@ -41,7 +41,6 @@
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
 #include <linux/kbd_kern.h>
-#include <linux/smp_lock.h>
 #include <linux/bitops.h>
 
 #include <asm/keyboard.h>
diff -puN drivers/char/hangcheck-timer.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/hangcheck-timer.c
--- a/drivers/char/hangcheck-timer.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/hangcheck-timer.c
@@ -44,7 +44,6 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/reboot.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <asm/uaccess.h>
diff -puN drivers/char/ip27-rtc.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/ip27-rtc.c
--- a/drivers/char/ip27-rtc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/ip27-rtc.c
@@ -35,7 +35,6 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
-#include <linux/smp_lock.h>
 
 #include <asm/m48t35.h>
 #include <asm/sn/ioc3.h>
diff -puN drivers/char/lp.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/lp.c
--- a/drivers/char/lp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/lp.c
@@ -118,7 +118,6 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/fcntl.h>
 #include <linux/delay.h>
diff -puN drivers/char/mem.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/mem.c
--- a/drivers/char/mem.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/mem.c
@@ -18,7 +18,6 @@
 #include <linux/raw.h>
 #include <linux/tty.h>
 #include <linux/capability.h>
-#include <linux/smp_lock.h>
 #include <linux/ptrace.h>
 #include <linux/device.h>
 #include <linux/highmem.h>
diff -puN drivers/char/mxser.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/mxser.c
--- a/drivers/char/mxser.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/mxser.c
@@ -54,7 +54,6 @@
 #include <linux/gfp.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 
diff -puN drivers/char/mxser_new.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/mxser_new.c
@@ -37,7 +37,6 @@
 #include <linux/gfp.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 
diff -puN drivers/char/ppdev.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/ppdev.c
@@ -66,7 +66,6 @@
 #include <linux/poll.h>
 #include <linux/major.h>
 #include <linux/ppdev.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 #include <asm/uaccess.h>
 
diff -puN drivers/char/sysrq.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/sysrq.c
@@ -24,7 +24,6 @@
 #include <linux/sysrq.h>
 #include <linux/kbd_kern.h>
 #include <linux/quotaops.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
diff -puN drivers/char/vc_screen.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/vc_screen.c
--- a/drivers/char/vc_screen.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/vc_screen.c
@@ -32,7 +32,6 @@
 #include <linux/selection.h>
 #include <linux/kbd_kern.h>
 #include <linux/console.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
diff -puN drivers/char/watchdog/omap_wdt.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/char/watchdog/omap_wdt.c
--- a/drivers/char/watchdog/omap_wdt.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/char/watchdog/omap_wdt.c
@@ -34,7 +34,6 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/reboot.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
diff -puN drivers/hid/hid-core.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/hid/hid-core.c
@@ -20,7 +20,6 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <asm/unaligned.h>
 #include <asm/byteorder.h>
diff -puN drivers/i2c/busses/scx200_acb.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/i2c/busses/scx200_acb.c
--- a/drivers/i2c/busses/scx200_acb.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/i2c/busses/scx200_acb.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
-#include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
diff -puN drivers/i2c/i2c-dev.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/i2c/i2c-dev.c
--- a/drivers/i2c/i2c-dev.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/i2c/i2c-dev.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/i2c.h>
diff -puN drivers/ieee1394/dv1394.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/ieee1394/dv1394.c
--- a/drivers/ieee1394/dv1394.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/ieee1394/dv1394.c
@@ -94,7 +94,6 @@
 #include <linux/pci.h>
 #include <linux/fs.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/bitops.h>
 #include <asm/byteorder.h>
diff -puN drivers/ieee1394/raw1394.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/ieee1394/raw1394.c
--- a/drivers/ieee1394/raw1394.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/ieee1394/raw1394.c
@@ -35,7 +35,6 @@
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
 #include <linux/cdev.h>
diff -puN drivers/ieee1394/video1394.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/ieee1394/video1394.c
--- a/drivers/ieee1394/video1394.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/ieee1394/video1394.c
@@ -39,7 +39,6 @@
 #include <linux/pci.h>
 #include <linux/fs.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
diff -puN drivers/infiniband/ulp/iser/iser_verbs.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/infiniband/ulp/iser/iser_verbs.c
--- a/drivers/infiniband/ulp/iser/iser_verbs.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -35,7 +35,6 @@
 #include <asm/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/version.h>
 
diff -puN drivers/input/evdev.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/input/evdev.c
--- a/drivers/input/evdev.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/input/evdev.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/major.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 #include <linux/compat.h>
 
diff -puN drivers/input/input.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/input/input.c
--- a/drivers/input/input.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/input/input.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/input.h>
 #include <linux/module.h>
 #include <linux/random.h>
diff -puN drivers/input/joydev.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/input/joydev.c
--- a/drivers/input/joydev.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/input/joydev.c
@@ -24,7 +24,6 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
diff -puN drivers/input/misc/uinput.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/input/misc/uinput.c
--- a/drivers/input/misc/uinput.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/input/misc/uinput.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/uinput.h>
diff -puN drivers/input/mousedev.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/input/mousedev.c
@@ -19,7 +19,6 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/input.h>
-#include <linux/smp_lock.h>
 #include <linux/random.h>
 #include <linux/major.h>
 #include <linux/device.h>
diff -puN drivers/input/tsdev.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/input/tsdev.c
--- a/drivers/input/tsdev.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/input/tsdev.c
@@ -48,7 +48,6 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/major.h>
-#include <linux/smp_lock.h>
 #include <linux/random.h>
 #include <linux/time.h>
 #include <linux/device.h>
diff -puN drivers/isdn/capi/capi.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/isdn/capi/capi.c
@@ -19,7 +19,6 @@
 #include <linux/fs.h>
 #include <linux/signal.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
diff -puN drivers/isdn/divert/divert_procfs.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/isdn/divert/divert_procfs.c
--- a/drivers/isdn/divert/divert_procfs.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/isdn/divert/divert_procfs.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
 #else
diff -puN drivers/isdn/hardware/eicon/capimain.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/isdn/hardware/eicon/capimain.c
--- a/drivers/isdn/hardware/eicon/capimain.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/isdn/hardware/eicon/capimain.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
-#include <linux/smp_lock.h>
 #include <linux/skbuff.h>
 
 #include "os_capi.h"
diff -puN drivers/isdn/hardware/eicon/divamnt.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/isdn/hardware/eicon/divamnt.c
--- a/drivers/isdn/hardware/eicon/divamnt.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/isdn/hardware/eicon/divamnt.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <asm/uaccess.h>
 
diff -puN drivers/isdn/hardware/eicon/divasi.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/isdn/hardware/eicon/divasi.c
--- a/drivers/isdn/hardware/eicon/divasi.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/isdn/hardware/eicon/divasi.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
 #include <linux/skbuff.h>
diff -puN drivers/isdn/hardware/eicon/divasmain.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/isdn/hardware/eicon/divasmain.c
--- a/drivers/isdn/hardware/eicon/divasmain.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/isdn/hardware/eicon/divasmain.c
@@ -17,7 +17,6 @@
 #include <linux/ioport.h>
 #include <linux/workqueue.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/poll.h>
diff -puN drivers/isdn/hardware/eicon/platform.h~header-cleaning-dont-include-smp_lockh-when-not-used drivers/isdn/hardware/eicon/platform.h
--- a/drivers/isdn/hardware/eicon/platform.h~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/isdn/hardware/eicon/platform.h
@@ -26,7 +26,6 @@
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/list.h>
 #include <asm/types.h>
diff -puN drivers/isdn/hisax/hfc_usb.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/isdn/hisax/hfc_usb.c
--- a/drivers/isdn/hisax/hfc_usb.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/isdn/hisax/hfc_usb.c
@@ -37,7 +37,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/usb.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include "hisax.h"
 #include "hisax_if.h"
 #include "hfc_usb.h"
diff -puN drivers/macintosh/therm_adt746x.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/macintosh/therm_adt746x.c
--- a/drivers/macintosh/therm_adt746x.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/macintosh/therm_adt746x.c
@@ -19,7 +19,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/wait.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
diff -puN drivers/macintosh/therm_pm72.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/macintosh/therm_pm72.c
--- a/drivers/macintosh/therm_pm72.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/macintosh/therm_pm72.c
@@ -117,7 +117,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/wait.h>
 #include <linux/reboot.h>
 #include <linux/kmod.h>
diff -puN drivers/macintosh/windfarm_core.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/macintosh/windfarm_core.c
--- a/drivers/macintosh/windfarm_core.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/macintosh/windfarm_core.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>
 #include <linux/reboot.h>
diff -puN drivers/media/dvb/bt8xx/dst_common.h~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/dvb/bt8xx/dst_common.h
--- a/drivers/media/dvb/bt8xx/dst_common.h~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/dvb/bt8xx/dst_common.h
@@ -22,7 +22,6 @@
 #ifndef DST_COMMON_H
 #define DST_COMMON_H
 
-#include <linux/smp_lock.h>
 #include <linux/dvb/frontend.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
diff -puN drivers/media/dvb/ttpci/av7110_av.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/dvb/ttpci/av7110_av.c
--- a/drivers/media/dvb/ttpci/av7110_av.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/dvb/ttpci/av7110_av.c
@@ -32,7 +32,6 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 
 #include "av7110.h"
diff -puN drivers/media/dvb/ttpci/av7110_ca.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/dvb/ttpci/av7110_ca.c
--- a/drivers/media/dvb/ttpci/av7110_ca.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/dvb/ttpci/av7110_ca.c
@@ -34,7 +34,6 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 
 #include "av7110.h"
 #include "av7110_hw.h"
diff -puN drivers/media/dvb/ttpci/av7110_hw.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/dvb/ttpci/av7110_hw.c
--- a/drivers/media/dvb/ttpci/av7110_hw.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/dvb/ttpci/av7110_hw.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 
 #include "av7110.h"
diff -puN drivers/media/dvb/ttpci/av7110_v4l.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/dvb/ttpci/av7110_v4l.c
--- a/drivers/media/dvb/ttpci/av7110_v4l.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -31,7 +31,6 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 
 #include "av7110.h"
 #include "av7110_hw.h"
diff -puN drivers/media/radio/dsbr100.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/radio/dsbr100.c
--- a/drivers/media/radio/dsbr100.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/radio/dsbr100.c
@@ -79,7 +79,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/usb.h>
-#include <linux/smp_lock.h>
 
 /*
  * Version Information
diff -puN drivers/media/video/cpia.h~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/cpia.h
--- a/drivers/media/video/cpia.h~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/cpia.h
@@ -47,7 +47,6 @@
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 
 struct cpia_camera_ops
diff -puN drivers/media/video/cpia_pp.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/cpia_pp.c
--- a/drivers/media/video/cpia_pp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/cpia_pp.c
@@ -34,7 +34,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/workqueue.h>
-#include <linux/smp_lock.h>
 #include <linux/sched.h>
 
 #include <linux/kmod.h>
diff -puN drivers/media/video/cx88/cx88-tvaudio.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/cx88/cx88-tvaudio.c
--- a/drivers/media/video/cx88/cx88-tvaudio.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/cx88/cx88-tvaudio.c
@@ -49,7 +49,6 @@
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 
diff -puN drivers/media/video/dabusb.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/dabusb.c
--- a/drivers/media/video/dabusb.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/dabusb.c
@@ -37,7 +37,6 @@
 #include <asm/atomic.h>
 #include <linux/delay.h>
 #include <linux/usb.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 
 #include "dabusb.h"
diff -puN drivers/media/video/ov511.h~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/ov511.h
--- a/drivers/media/video/ov511.h~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/ov511.h
@@ -4,7 +4,6 @@
 #include <asm/uaccess.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
-#include <linux/smp_lock.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
 
diff -puN drivers/media/video/pvrusb2/pvrusb2-main.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/pvrusb2/pvrusb2-main.c
--- a/drivers/media/video/pvrusb2/pvrusb2-main.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/pvrusb2/pvrusb2-main.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/smp_lock.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 
diff -puN drivers/media/video/saa7134/saa7134-tvaudio.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <asm/div64.h>
 
 #include "saa7134-reg.h"
diff -puN drivers/media/video/se401.h~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/se401.h
--- a/drivers/media/video/se401.h~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/se401.h
@@ -5,7 +5,6 @@
 #include <asm/uaccess.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 
 #define se401_DEBUG	/* Turn on debug messages */
diff -puN drivers/media/video/tvaudio.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/tvaudio.c
--- a/drivers/media/video/tvaudio.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/tvaudio.c
@@ -27,7 +27,6 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
diff -puN drivers/media/video/usbvideo/usbvideo.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/usbvideo/usbvideo.c
--- a/drivers/media/video/usbvideo/usbvideo.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/usbvideo/usbvideo.c
@@ -20,7 +20,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
diff -puN drivers/media/video/usbvision/usbvision-core.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/usbvision/usbvision-core.c
--- a/drivers/media/video/usbvision/usbvision-core.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/usbvision/usbvision-core.c
@@ -30,7 +30,6 @@
 #include <linux/mm.h>
 #include <linux/utsname.h>
 #include <linux/highmem.h>
-#include <linux/smp_lock.h>
 #include <linux/videodev.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
diff -puN drivers/media/video/usbvision/usbvision-video.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -52,7 +52,6 @@
 #include <linux/mm.h>
 #include <linux/utsname.h>
 #include <linux/highmem.h>
-#include <linux/smp_lock.h>
 #include <linux/videodev.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
diff -puN drivers/media/video/v4l1-compat.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/v4l1-compat.c
--- a/drivers/media/video/v4l1-compat.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/v4l1-compat.c
@@ -23,7 +23,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/file.h>
diff -puN drivers/media/video/v4l2-common.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/v4l2-common.c
--- a/drivers/media/video/v4l2-common.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/v4l2-common.c
@@ -47,7 +47,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/errno.h>
diff -puN drivers/media/video/videodev.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/media/video/videodev.c
--- a/drivers/media/video/videodev.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/media/video/videodev.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/errno.h>
diff -puN drivers/mfd/ucb1x00-ts.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/mfd/ucb1x00-ts.c
--- a/drivers/mfd/ucb1x00-ts.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/mfd/ucb1x00-ts.c
@@ -21,7 +21,6 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
diff -puN drivers/net/irda/sir_dev.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/net/irda/sir_dev.c
--- a/drivers/net/irda/sir_dev.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/net/irda/sir_dev.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 
 #include <net/irda/irda.h>
diff -puN drivers/net/irda/sir_dongle.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/net/irda/sir_dongle.c
--- a/drivers/net/irda/sir_dongle.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/net/irda/sir_dongle.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/kmod.h>
 #include <linux/mutex.h>
 
diff -puN drivers/net/irda/vlsi_ir.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/net/irda/vlsi_ir.c
--- a/drivers/net/irda/vlsi_ir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/net/irda/vlsi_ir.c
@@ -44,7 +44,6 @@ MODULE_LICENSE("GPL");
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 
diff -puN drivers/net/ns83820.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/net/ns83820.c
--- a/drivers/net/ns83820.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/net/ns83820.c
@@ -107,7 +107,6 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/workqueue.h>
 #include <linux/init.h>
 #include <linux/ip.h>	/* for iph */
diff -puN drivers/net/ppp_generic.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/net/ppp_generic.c
@@ -40,7 +40,6 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/rwsem.h>
 #include <linux/stddef.h>
 #include <linux/device.h>
diff -puN drivers/net/wan/cosa.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/net/wan/cosa.c
--- a/drivers/net/wan/cosa.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/net/wan/cosa.c
@@ -90,7 +90,6 @@
 #include <linux/ioport.h>
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 
 #undef COSA_SLOW_IO	/* for testing purposes only */
diff -puN drivers/net/wireless/airo.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/net/wireless/airo.c
@@ -25,7 +25,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
-#include <linux/smp_lock.h>
 
 #include <linux/sched.h>
 #include <linux/ptrace.h>
diff -puN drivers/net/wireless/hostap/hostap_ioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/net/wireless/hostap/hostap_ioctl.c
--- a/drivers/net/wireless/hostap/hostap_ioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -1,7 +1,6 @@
 /* ioctl() (mostly Linux Wireless Extensions) routines for Host AP driver */
 
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/ethtool.h>
 #include <net/ieee80211_crypt.h>
 
diff -puN drivers/parisc/lba_pci.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/parisc/lba_pci.c
--- a/drivers/parisc/lba_pci.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/parisc/lba_pci.c
@@ -38,7 +38,6 @@
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include <asm/byteorder.h>
 #include <asm/pdc.h>
diff -puN drivers/pci/hotplug/acpiphp_core.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/pci/hotplug/acpiphp_core.c
--- a/drivers/pci/hotplug/acpiphp_core.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/pci/hotplug/acpiphp_core.c
@@ -40,7 +40,6 @@
 #include <linux/pci_hotplug.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include "acpiphp.h"
 
 #define MY_NAME	"acpiphp"
diff -puN drivers/pci/hotplug/acpiphp_glue.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/pci/hotplug/acpiphp_glue.c
--- a/drivers/pci/hotplug/acpiphp_glue.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/pci/hotplug/acpiphp_glue.c
@@ -46,7 +46,6 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 
 #include "../pci.h"
diff -puN drivers/pci/hotplug/ibmphp_core.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/pci/hotplug/ibmphp_core.c
--- a/drivers/pci/hotplug/ibmphp_core.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/pci/hotplug/ibmphp_core.c
@@ -34,7 +34,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
-#include <linux/smp_lock.h>
 #include "../pci.h"
 #include "../../../arch/i386/pci/pci.h"	/* for struct irq_routing_table */
 #include "ibmphp.h"
diff -puN drivers/pci/hotplug/ibmphp_hpc.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/pci/hotplug/ibmphp_hpc.c
--- a/drivers/pci/hotplug/ibmphp_hpc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/pci/hotplug/ibmphp_hpc.c
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
 
diff -puN drivers/pci/hotplug/pci_hotplug_core.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/pci/hotplug/pci_hotplug_core.c
--- a/drivers/pci/hotplug/pci_hotplug_core.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/pci/hotplug/pci_hotplug_core.c
@@ -34,7 +34,6 @@
 #include <linux/sysfs.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
diff -puN drivers/pci/hotplug/rpaphp_core.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/pci/hotplug/rpaphp_core.c
--- a/drivers/pci/hotplug/rpaphp_core.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/pci/hotplug/rpaphp_core.c
@@ -29,7 +29,6 @@
 #include <linux/pci_hotplug.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <asm/eeh.h>       /* for eeh_add_device() */
 #include <asm/rtas.h>		/* rtas_call */
diff -puN drivers/pci/hotplug/shpchp_ctrl.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/pci/hotplug/shpchp_ctrl.c
--- a/drivers/pci/hotplug/shpchp_ctrl.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/pci/hotplug/shpchp_ctrl.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/workqueue.h>
 #include "../pci.h"
diff -puN drivers/pci/msi.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/pci/msi.c
--- a/drivers/pci/msi.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/pci/msi.c
@@ -12,7 +12,6 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/msi.h>
diff -puN drivers/pci/proc.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/pci/proc.c
--- a/drivers/pci/proc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/pci/proc.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
diff -puN drivers/sbus/char/bpp.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/sbus/char/bpp.c
--- a/drivers/sbus/char/bpp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/sbus/char/bpp.c
@@ -15,7 +15,6 @@
 #include <linux/fs.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/ioport.h>
diff -puN drivers/sbus/char/rtc.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/sbus/char/rtc.c
--- a/drivers/sbus/char/rtc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/sbus/char/rtc.c
@@ -19,7 +19,6 @@
 #include <linux/fcntl.h>
 #include <linux/poll.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <asm/io.h>
 #include <asm/mostek.h>
 #include <asm/system.h>
diff -puN drivers/sbus/char/vfc_dev.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/sbus/char/vfc_dev.c
--- a/drivers/sbus/char/vfc_dev.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/sbus/char/vfc_dev.c
@@ -20,7 +20,6 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.h~header-cleaning-dont-include-smp_lockh-when-not-used drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -47,7 +47,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~header-cleaning-dont-include-smp_lockh-when-not-used drivers/scsi/aic7xxx/aic7xxx_osm.h
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -64,7 +64,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff -puN drivers/scsi/dpt_i2o.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/scsi/dpt_i2o.c
@@ -55,7 +55,6 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Dri
 #include <linux/sched.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/dma-mapping.h>
 
 #include <linux/timer.h>
diff -puN drivers/scsi/scsi_debug.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/scsi/scsi_debug.c
@@ -36,7 +36,6 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
 
diff -puN drivers/scsi/sg.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/scsi/sg.c
@@ -41,7 +41,6 @@ static int sg_version_num = 30534;	/* 2 
 #include <linux/fcntl.h>
 #include <linux/init.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/moduleparam.h>
 #include <linux/cdev.h>
 #include <linux/seq_file.h>
diff -puN drivers/serial/icom.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/serial/icom.c
--- a/drivers/serial/icom.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/serial/icom.c
@@ -47,7 +47,6 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/kobject.h>
 #include <linux/firmware.h>
diff -puN drivers/usb/atm/usbatm.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/atm/usbatm.c
@@ -77,7 +77,6 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/stat.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
diff -puN drivers/usb/class/cdc-acm.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/class/cdc-acm.c
@@ -59,7 +59,6 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <linux/usb.h>
diff -puN drivers/usb/class/usblp.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/class/usblp.c
--- a/drivers/usb/class/usblp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/class/usblp.c
@@ -49,7 +49,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/signal.h>
 #include <linux/poll.h>
 #include <linux/init.h>
diff -puN drivers/usb/core/hub.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/core/hub.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/ioctl.h>
 #include <linux/usb.h>
 #include <linux/usbdevice_fs.h>
diff -puN drivers/usb/core/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/core/inode.c
--- a/drivers/usb/core/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/core/inode.c
@@ -36,7 +36,6 @@
 #include <linux/usb.h>
 #include <linux/namei.h>
 #include <linux/usbdevice_fs.h>
-#include <linux/smp_lock.h>
 #include <linux/parser.h>
 #include <linux/notifier.h>
 #include <asm/byteorder.h>
diff -puN drivers/usb/core/usb.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/core/usb.c
@@ -31,7 +31,6 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
diff -puN drivers/usb/gadget/at91_udc.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/gadget/at91_udc.c
--- a/drivers/usb/gadget/at91_udc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/gadget/at91_udc.c
@@ -31,7 +31,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/list.h>
diff -puN drivers/usb/gadget/dummy_hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/gadget/dummy_hcd.c
--- a/drivers/usb/gadget/dummy_hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/gadget/dummy_hcd.c
@@ -41,7 +41,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/gadget/ether.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/gadget/ether.c
--- a/drivers/usb/gadget/ether.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/gadget/ether.c
@@ -28,7 +28,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/gadget/goku_udc.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/gadget/goku_udc.c
--- a/drivers/usb/gadget/goku_udc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/gadget/goku_udc.c
@@ -30,7 +30,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/gadget/net2280.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/gadget/net2280.c
@@ -54,7 +54,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/gadget/serial.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/gadget/serial.c
--- a/drivers/usb/gadget/serial.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/gadget/serial.c
@@ -22,7 +22,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/gadget/zero.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/gadget/zero.c
--- a/drivers/usb/gadget/zero.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/gadget/zero.c
@@ -67,7 +67,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/host/ehci-hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/host/ehci-hcd.c
--- a/drivers/usb/host/ehci-hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/host/ehci-hcd.c
@@ -24,7 +24,6 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/host/ohci-hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/host/ohci-hcd.c
--- a/drivers/usb/host/ohci-hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/host/ohci-hcd.c
@@ -26,7 +26,6 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/host/sl811-hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/host/sl811-hcd.c
--- a/drivers/usb/host/sl811-hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/host/sl811-hcd.c
@@ -38,7 +38,6 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/host/u132-hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/host/u132-hcd.c
--- a/drivers/usb/host/u132-hcd.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/host/u132-hcd.c
@@ -43,7 +43,6 @@
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
diff -puN drivers/usb/image/mdc800.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/image/mdc800.c
--- a/drivers/usb/image/mdc800.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/image/mdc800.c
@@ -94,7 +94,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/wait.h>
 #include <linux/mutex.h>
 
diff -puN drivers/usb/image/microtek.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/image/microtek.c
--- a/drivers/usb/image/microtek.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/image/microtek.c
@@ -128,7 +128,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/usb.h>
 #include <linux/proc_fs.h>
 
diff -puN /dev/null /dev/null
diff -puN /dev/null /dev/null
diff -puN drivers/usb/input/xpad.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/input/xpad.c
--- a/drivers/usb/input/xpad.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/input/xpad.c
@@ -74,7 +74,6 @@
 #include <linux/stat.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/smp_lock.h>
 #include <linux/usb/input.h>
 
 #define DRIVER_VERSION "v0.0.6"
diff -puN drivers/usb/misc/idmouse.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/misc/idmouse.c
--- a/drivers/usb/misc/idmouse.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/misc/idmouse.c
@@ -22,7 +22,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
diff -puN drivers/usb/misc/legousbtower.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/misc/legousbtower.c
--- a/drivers/usb/misc/legousbtower.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/misc/legousbtower.c
@@ -80,7 +80,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
diff -puN drivers/usb/misc/rio500.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/misc/rio500.c
--- a/drivers/usb/misc/rio500.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/misc/rio500.c
@@ -39,7 +39,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/usb.h>
-#include <linux/smp_lock.h>
 #include <linux/wait.h>
 
 #include "rio500_usb.h"
diff -puN drivers/usb/misc/sisusbvga/sisusb_con.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/misc/sisusbvga/sisusb_con.c
--- a/drivers/usb/misc/sisusbvga/sisusb_con.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/misc/sisusbvga/sisusb_con.c
@@ -62,7 +62,6 @@
 #include <linux/selection.h>
 #include <linux/spinlock.h>
 #include <linux/kref.h>
-#include <linux/smp_lock.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
diff -puN drivers/usb/mon/mon_main.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/mon/mon_main.c
--- a/drivers/usb/mon/mon_main.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/mon/mon_main.c
@@ -9,7 +9,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
-#include <linux/smp_lock.h>
 #include <linux/notifier.h>
 #include <linux/mutex.h>
 
diff -puN drivers/usb/serial/usb-serial.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/serial/usb-serial.c
@@ -28,7 +28,6 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
diff -puN drivers/usb/storage/usb.h~header-cleaning-dont-include-smp_lockh-when-not-used drivers/usb/storage/usb.h
--- a/drivers/usb/storage/usb.h~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/usb/storage/usb.h
@@ -47,7 +47,6 @@
 #include <linux/usb.h>
 #include <linux/usb_usual.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
 #include <scsi/scsi_host.h>
diff -puN drivers/video/sis/sis.h~header-cleaning-dont-include-smp_lockh-when-not-used drivers/video/sis/sis.h
--- a/drivers/video/sis/sis.h~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/video/sis/sis.h
@@ -51,7 +51,6 @@
 #include <linux/ioctl32.h>
 #define SIS_OLD_CONFIG_COMPAT
 #else
-#include <linux/smp_lock.h>
 #define SIS_NEW_CONFIG_COMPAT
 #endif
 #endif	/* CONFIG_COMPAT */
diff -puN drivers/video/sis/sis_main.c~header-cleaning-dont-include-smp_lockh-when-not-used drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/drivers/video/sis/sis_main.c
@@ -37,7 +37,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/string.h>
diff -puN fs/9p/vfs_addr.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/9p/vfs_addr.c
--- a/fs/9p/vfs_addr.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/9p/vfs_addr.c
@@ -29,7 +29,6 @@
 #include <linux/file.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/inet.h>
 #include <linux/pagemap.h>
 #include <linux/idr.h>
diff -puN fs/9p/vfs_dentry.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/9p/vfs_dentry.c
--- a/fs/9p/vfs_dentry.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/9p/vfs_dentry.c
@@ -30,7 +30,6 @@
 #include <linux/pagemap.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/inet.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
diff -puN fs/9p/vfs_dir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/9p/vfs_dir.c
--- a/fs/9p/vfs_dir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/9p/vfs_dir.c
@@ -29,7 +29,6 @@
 #include <linux/file.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/sched.h>
 #include <linux/inet.h>
 #include <linux/idr.h>
diff -puN fs/9p/vfs_file.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/9p/vfs_file.c
@@ -30,7 +30,6 @@
 #include <linux/file.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/inet.h>
 #include <linux/list.h>
 #include <asm/uaccess.h>
diff -puN fs/9p/vfs_inode.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/9p/vfs_inode.c
@@ -30,7 +30,6 @@
 #include <linux/pagemap.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/inet.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
diff -puN fs/9p/vfs_super.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/9p/vfs_super.c
--- a/fs/9p/vfs_super.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/9p/vfs_super.c
@@ -31,7 +31,6 @@
 #include <linux/file.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/inet.h>
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
diff -puN fs/afs/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/afs/dir.c
--- a/fs/afs/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/afs/dir.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include "vnode.h"
 #include "volume.h"
 #include <rxrpc/call.h>
diff -puN fs/attr.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/attr.c
--- a/fs/attr.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/attr.c
@@ -9,7 +9,6 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/capability.h>
 #include <linux/fsnotify.h>
 #include <linux/fcntl.h>
diff -puN fs/autofs4/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/autofs4/inode.c
@@ -18,7 +18,6 @@
 #include <linux/pagemap.h>
 #include <linux/parser.h>
 #include <linux/bitops.h>
-#include <linux/smp_lock.h>
 #include <linux/magic.h>
 #include "autofs_i.h"
 #include <linux/module.h>
diff -puN fs/autofs4/root.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/autofs4/root.c
--- a/fs/autofs4/root.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/autofs4/root.c
@@ -17,7 +17,6 @@
 #include <linux/stat.h>
 #include <linux/param.h>
 #include <linux/time.h>
-#include <linux/smp_lock.h>
 #include "autofs_i.h"
 
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
diff -puN fs/bad_inode.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/bad_inode.c
--- a/fs/bad_inode.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/bad_inode.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/stat.h>
 #include <linux/time.h>
-#include <linux/smp_lock.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
 
diff -puN fs/binfmt_elf.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/binfmt_elf.c
@@ -31,7 +31,6 @@
 #include <linux/init.h>
 #include <linux/highuid.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/compiler.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
diff -puN fs/binfmt_elf_fdpic.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/binfmt_elf_fdpic.c
@@ -30,7 +30,6 @@
 #include <linux/personality.h>
 #include <linux/ptrace.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/elf.h>
 #include <linux/elf-fdpic.h>
 #include <linux/elfcore.h>
diff -puN fs/binfmt_em86.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/binfmt_em86.c
@@ -12,7 +12,6 @@
 #include <linux/string.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/binfmts.h>
 #include <linux/elf.h>
 #include <linux/init.h>
diff -puN fs/binfmt_script.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/binfmt_script.c
--- a/fs/binfmt_script.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/binfmt_script.c
@@ -12,7 +12,6 @@
 #include <linux/binfmts.h>
 #include <linux/init.h>
 #include <linux/file.h>
-#include <linux/smp_lock.h>
 #include <linux/err.h>
 #include <linux/fs.h>
 
diff -puN fs/buffer.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/buffer.c
--- a/fs/buffer.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/buffer.c
@@ -24,7 +24,6 @@
 #include <linux/mm.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/capability.h>
 #include <linux/blkdev.h>
 #include <linux/file.h>
diff -puN fs/cifs/file.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/cifs/file.c
--- a/fs/cifs/file.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/cifs/file.c
@@ -27,7 +27,6 @@
 #include <linux/fcntl.h>
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
-#include <linux/smp_lock.h>
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/delay.h>
diff -puN fs/cifs/readdir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/cifs/readdir.c
--- a/fs/cifs/readdir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/cifs/readdir.c
@@ -23,7 +23,6 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/stat.h>
-#include <linux/smp_lock.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
diff -puN fs/compat_ioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/compat_ioctl.c
@@ -17,7 +17,6 @@
 #include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/ioctl.h>
 #include <linux/if.h>
 #include <linux/if_bridge.h>
diff -puN fs/dcache.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/dcache.c
--- a/fs/dcache.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/dcache.c
@@ -21,7 +21,6 @@
 #include <linux/fsnotify.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/hash.h>
 #include <linux/cache.h>
 #include <linux/module.h>
diff -puN fs/dquot.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/dquot.c
--- a/fs/dquot.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/dquot.c
@@ -69,7 +69,6 @@
 #include <linux/file.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
diff -puN fs/ecryptfs/file.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ecryptfs/file.c
@@ -28,7 +28,6 @@
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/security.h>
-#include <linux/smp_lock.h>
 #include <linux/compat.h>
 #include <linux/fs_stack.h>
 #include "ecryptfs_kernel.h"
diff -puN fs/eventpoll.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/eventpoll.c
--- a/fs/eventpoll.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/eventpoll.c
@@ -22,7 +22,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/list.h>
 #include <linux/hash.h>
diff -puN fs/exportfs/expfs.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/exportfs/expfs.c
@@ -2,7 +2,6 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/namei.h>
 
 struct export_operations export_op_default;
diff -puN fs/ext2/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext2/dir.c
--- a/fs/ext2/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext2/dir.c
@@ -23,7 +23,6 @@
 
 #include "ext2.h"
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
 
diff -puN fs/ext2/fsync.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext2/fsync.c
--- a/fs/ext2/fsync.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext2/fsync.c
@@ -23,7 +23,6 @@
  */
 
 #include "ext2.h"
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>		/* for sync_mapping_buffers() */
 
 
diff -puN fs/ext2/xattr_security.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext2/xattr_security.c
--- a/fs/ext2/xattr_security.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext2/xattr_security.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/ext2_fs.h>
 #include <linux/security.h>
 #include "xattr.h"
diff -puN fs/ext2/xattr_trusted.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext2/xattr_trusted.c
--- a/fs/ext2/xattr_trusted.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext2/xattr_trusted.c
@@ -9,7 +9,6 @@
 #include <linux/string.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/ext2_fs.h>
 #include "xattr.h"
 
diff -puN fs/ext3/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext3/dir.c
--- a/fs/ext3/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext3/dir.c
@@ -25,7 +25,6 @@
 #include <linux/jbd.h>
 #include <linux/ext3_fs.h>
 #include <linux/buffer_head.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 
diff -puN fs/ext3/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext3/inode.c
--- a/fs/ext3/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext3/inode.c
@@ -27,7 +27,6 @@
 #include <linux/time.h>
 #include <linux/ext3_jbd.h>
 #include <linux/jbd.h>
-#include <linux/smp_lock.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
diff -puN fs/ext3/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext3/namei.c
--- a/fs/ext3/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext3/namei.c
@@ -36,7 +36,6 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
-#include <linux/smp_lock.h>
 
 #include "namei.h"
 #include "xattr.h"
diff -puN fs/ext3/resize.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext3/resize.c
--- a/fs/ext3/resize.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext3/resize.c
@@ -11,7 +11,6 @@
 
 #define EXT3FS_DEBUG
 
-#include <linux/smp_lock.h>
 #include <linux/ext3_jbd.h>
 
 #include <linux/errno.h>
diff -puN fs/ext3/xattr_security.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext3/xattr_security.c
--- a/fs/ext3/xattr_security.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext3/xattr_security.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/ext3_jbd.h>
 #include <linux/ext3_fs.h>
 #include <linux/security.h>
diff -puN fs/ext3/xattr_trusted.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext3/xattr_trusted.c
--- a/fs/ext3/xattr_trusted.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext3/xattr_trusted.c
@@ -9,7 +9,6 @@
 #include <linux/string.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/ext3_jbd.h>
 #include <linux/ext3_fs.h>
 #include "xattr.h"
diff -puN fs/ext3/xattr_user.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext3/xattr_user.c
--- a/fs/ext3/xattr_user.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext3/xattr_user.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/ext3_jbd.h>
 #include <linux/ext3_fs.h>
 #include "xattr.h"
diff -puN fs/ext4/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext4/dir.c
--- a/fs/ext4/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext4/dir.c
@@ -25,7 +25,6 @@
 #include <linux/jbd2.h>
 #include <linux/ext4_fs.h>
 #include <linux/buffer_head.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 
diff -puN fs/ext4/extents.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext4/extents.c
--- a/fs/ext4/extents.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext4/extents.c
@@ -34,7 +34,6 @@
 #include <linux/time.h>
 #include <linux/ext4_jbd2.h>
 #include <linux/jbd.h>
-#include <linux/smp_lock.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
diff -puN fs/ext4/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext4/inode.c
--- a/fs/ext4/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext4/inode.c
@@ -27,7 +27,6 @@
 #include <linux/time.h>
 #include <linux/ext4_jbd2.h>
 #include <linux/jbd2.h>
-#include <linux/smp_lock.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
diff -puN fs/ext4/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext4/namei.c
--- a/fs/ext4/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext4/namei.c
@@ -36,7 +36,6 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
-#include <linux/smp_lock.h>
 
 #include "namei.h"
 #include "xattr.h"
diff -puN fs/ext4/resize.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext4/resize.c
--- a/fs/ext4/resize.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext4/resize.c
@@ -11,7 +11,6 @@
 
 #define EXT4FS_DEBUG
 
-#include <linux/smp_lock.h>
 #include <linux/ext4_jbd2.h>
 
 #include <linux/errno.h>
diff -puN fs/ext4/xattr_security.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext4/xattr_security.c
--- a/fs/ext4/xattr_security.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext4/xattr_security.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/ext4_jbd2.h>
 #include <linux/ext4_fs.h>
 #include <linux/security.h>
diff -puN fs/ext4/xattr_trusted.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext4/xattr_trusted.c
--- a/fs/ext4/xattr_trusted.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext4/xattr_trusted.c
@@ -9,7 +9,6 @@
 #include <linux/string.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/ext4_jbd2.h>
 #include <linux/ext4_fs.h>
 #include "xattr.h"
diff -puN fs/ext4/xattr_user.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ext4/xattr_user.c
--- a/fs/ext4/xattr_user.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ext4/xattr_user.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/ext4_jbd2.h>
 #include <linux/ext4_fs.h>
 #include "xattr.h"
diff -puN fs/fifo.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/fifo.c
--- a/fs/fifo.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/fifo.c
@@ -11,7 +11,6 @@
 
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/pipe_fs_i.h>
 
diff -puN fs/file_table.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/file_table.c
--- a/fs/file_table.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/file_table.c
@@ -10,7 +10,6 @@
 #include <linux/file.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/security.h>
 #include <linux/eventpoll.h>
diff -puN fs/gfs2/locking/nolock/main.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/gfs2/locking/nolock/main.c
--- a/fs/gfs2/locking/nolock/main.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/gfs2/locking/nolock/main.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/lm_interface.h>
 
 struct nolock_lockspace {
diff -puN fs/gfs2/ops_dentry.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/gfs2/ops_dentry.c
--- a/fs/gfs2/ops_dentry.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/gfs2/ops_dentry.c
@@ -11,7 +11,6 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
-#include <linux/smp_lock.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/lm_interface.h>
diff -puN fs/gfs2/ops_file.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/gfs2/ops_file.c
@@ -15,7 +15,6 @@
 #include <linux/uio.h>
 #include <linux/blkdev.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/ext2_fs.h>
diff -puN fs/jbd/commit.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jbd/commit.c
--- a/fs/jbd/commit.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jbd/commit.c
@@ -20,7 +20,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
diff -puN fs/jbd/journal.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jbd/journal.c
--- a/fs/jbd/journal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jbd/journal.c
@@ -28,7 +28,6 @@
 #include <linux/jbd.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/freezer.h>
diff -puN fs/jbd/revoke.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jbd/revoke.c
@@ -66,7 +66,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #endif
 
diff -puN fs/jbd/transaction.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jbd/transaction.c
@@ -23,7 +23,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 
diff -puN fs/jbd2/commit.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jbd2/commit.c
@@ -20,7 +20,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
diff -puN fs/jbd2/journal.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jbd2/journal.c
@@ -28,7 +28,6 @@
 #include <linux/jbd2.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/freezer.h>
diff -puN fs/jbd2/revoke.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jbd2/revoke.c
--- a/fs/jbd2/revoke.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jbd2/revoke.c
@@ -66,7 +66,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #endif
 
diff -puN fs/jbd2/transaction.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jbd2/transaction.c
@@ -23,7 +23,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 
diff -puN fs/jfs/jfs_logmgr.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jfs/jfs_logmgr.c
--- a/fs/jfs/jfs_logmgr.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jfs/jfs_logmgr.c
@@ -62,7 +62,6 @@
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/completion.h>
 #include <linux/kthread.h>
 #include <linux/buffer_head.h>		/* for sync_blockdev() */
diff -puN fs/jfs/jfs_txnmgr.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/jfs/jfs_txnmgr.c
--- a/fs/jfs/jfs_txnmgr.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/jfs/jfs_txnmgr.c
@@ -44,7 +44,6 @@
 
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
-#include <linux/smp_lock.h>
 #include <linux/completion.h>
 #include <linux/freezer.h>
 #include <linux/module.h>
diff -puN fs/lockd/clntproc.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/lockd/clntproc.c
--- a/fs/lockd/clntproc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/lockd/clntproc.c
@@ -12,7 +12,6 @@
 #include <linux/fs.h>
 #include <linux/nfs_fs.h>
 #include <linux/utsname.h>
-#include <linux/smp_lock.h>
 #include <linux/freezer.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
diff -puN fs/lockd/svclock.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/lockd/svclock.c
@@ -24,7 +24,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/lockd/nlm.h>
diff -puN fs/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/namei.c
--- a/fs/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/namei.c
@@ -22,7 +22,6 @@
 #include <linux/quotaops.h>
 #include <linux/pagemap.h>
 #include <linux/fsnotify.h>
-#include <linux/smp_lock.h>
 #include <linux/personality.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
diff -puN fs/ncpfs/file.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ncpfs/file.c
--- a/fs/ncpfs/file.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ncpfs/file.c
@@ -17,7 +17,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/smp_lock.h>
 
 #include <linux/ncp_fs.h>
 #include "ncplib_kernel.h"
diff -puN fs/nfs/client.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfs/client.c
--- a/fs/nfs/client.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfs/client.c
@@ -27,7 +27,6 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs4_mount.h>
 #include <linux/lockd/bind.h>
-#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/nfs_idmap.h>
diff -puN fs/nfs/direct.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfs/direct.c
--- a/fs/nfs/direct.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfs/direct.c
@@ -41,7 +41,6 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/file.h>
 #include <linux/pagemap.h>
 #include <linux/kref.h>
diff -puN fs/nfs/getroot.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfs/getroot.c
--- a/fs/nfs/getroot.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfs/getroot.c
@@ -25,7 +25,6 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs4_mount.h>
 #include <linux/lockd/bind.h>
-#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/nfs_idmap.h>
diff -puN fs/nfs/nfs3proc.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfs/nfs3proc.c
--- a/fs/nfs/nfs3proc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfs/nfs3proc.c
@@ -16,7 +16,6 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
 #include <linux/lockd/bind.h>
-#include <linux/smp_lock.h>
 #include <linux/nfs_mount.h>
 
 #include "iostat.h"
diff -puN fs/nfs/nfs4renewd.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfs/nfs4renewd.c
--- a/fs/nfs/nfs4renewd.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfs/nfs4renewd.c
@@ -43,7 +43,6 @@
  * child task framework of the RPC layer?
  */
 
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/sunrpc/sched.h>
diff -puN fs/nfs/proc.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfs/proc.c
--- a/fs/nfs/proc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfs/proc.c
@@ -43,7 +43,6 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
 #include <linux/lockd/bind.h>
-#include <linux/smp_lock.h>
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_PROC
diff -puN fs/nfs/symlink.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfs/symlink.c
--- a/fs/nfs/symlink.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfs/symlink.c
@@ -22,7 +22,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/namei.h>
 
 /* Symlink caching in the page cache is even more simplistic
diff -puN fs/nfs/write.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfs/write.c
--- a/fs/nfs/write.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfs/write.c
@@ -21,7 +21,6 @@
 #include <linux/backing-dev.h>
 
 #include <asm/uaccess.h>
-#include <linux/smp_lock.h>
 
 #include "delegation.h"
 #include "internal.h"
diff -puN fs/nfsd/nfs4idmap.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfsd/nfs4idmap.c
--- a/fs/nfsd/nfs4idmap.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfsd/nfs4idmap.c
@@ -46,7 +46,6 @@
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
-#include <linux/smp_lock.h>
 #include <linux/sunrpc/cache.h>
 #include <linux/nfsd_idmap.h>
 #include <linux/list.h>
diff -puN fs/nfsd/nfs4xdr.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfsd/nfs4xdr.c
@@ -44,7 +44,6 @@
 
 #include <linux/param.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/vfs.h>
diff -puN fs/nfsd/nfsfh.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/nfsd/nfsfh.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/unistd.h>
 #include <linux/string.h>
diff -puN fs/ntfs/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ntfs/dir.c
--- a/fs/ntfs/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ntfs/dir.c
@@ -20,7 +20,6 @@
  * Foundation,Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 
 #include "dir.h"
diff -puN fs/ntfs/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ntfs/inode.c
@@ -27,7 +27,6 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include "aops.h"
 #include "attrib.h"
diff -puN fs/ocfs2/dlm/dlmfs.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -42,7 +42,6 @@
 #include <linux/highmem.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 
 #include <asm/uaccess.h>
diff -puN fs/ocfs2/dlmglue.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ocfs2/dlmglue.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/crc32.h>
 #include <linux/kthread.h>
 #include <linux/pagemap.h>
diff -puN fs/ocfs2/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ocfs2/inode.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 
 #include <asm/byteorder.h>
 
diff -puN fs/ocfs2/slot_map.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ocfs2/slot_map.c
@@ -26,7 +26,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/smp_lock.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
diff -puN fs/ocfs2/vote.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ocfs2/vote.c
--- a/fs/ocfs2/vote.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ocfs2/vote.c
@@ -26,7 +26,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 
 #include <cluster/heartbeat.h>
diff -puN fs/open.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/open.c
--- a/fs/open.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/open.c
@@ -7,7 +7,6 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/file.h>
-#include <linux/smp_lock.h>
 #include <linux/quotaops.h>
 #include <linux/fsnotify.h>
 #include <linux/module.h>
diff -puN fs/proc/base.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/proc/base.c
--- a/fs/proc/base.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/proc/base.c
@@ -61,7 +61,6 @@
 #include <linux/namei.h>
 #include <linux/mnt_namespace.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
 #include <linux/module.h>
diff -puN fs/proc/proc_misc.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/proc/proc_misc.c
@@ -35,7 +35,6 @@
 #include <linux/signal.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 #include <linux/times.h>
 #include <linux/profile.h>
diff -puN fs/quota.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/quota.c
--- a/fs/quota.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/quota.c
@@ -11,7 +11,6 @@
 #include <asm/current.h>
 #include <asm/uaccess.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/buffer_head.h>
diff -puN fs/ramfs/file-nommu.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ramfs/file-nommu.c
@@ -16,7 +16,6 @@
 #include <linux/highmem.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 #include <linux/ramfs.h>
 #include <linux/quotaops.h>
diff -puN fs/ramfs/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ramfs/inode.c
@@ -30,7 +30,6 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 #include <linux/ramfs.h>
 
diff -puN fs/readdir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/readdir.c
--- a/fs/readdir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/readdir.c
@@ -10,7 +10,6 @@
 #include <linux/errno.h>
 #include <linux/stat.h>
 #include <linux/file.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/dirent.h>
 #include <linux/security.h>
diff -puN fs/reiserfs/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/reiserfs/dir.c
--- a/fs/reiserfs/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/reiserfs/dir.c
@@ -7,7 +7,6 @@
 #include <linux/fs.h>
 #include <linux/reiserfs_fs.h>
 #include <linux/stat.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <asm/uaccess.h>
 
diff -puN fs/reiserfs/file.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/reiserfs/file.c
@@ -6,7 +6,6 @@
 #include <linux/reiserfs_fs.h>
 #include <linux/reiserfs_acl.h>
 #include <linux/reiserfs_xattr.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
diff -puN fs/reiserfs/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/reiserfs/namei.c
--- a/fs/reiserfs/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/reiserfs/namei.c
@@ -16,7 +16,6 @@
 #include <linux/reiserfs_fs.h>
 #include <linux/reiserfs_acl.h>
 #include <linux/reiserfs_xattr.h>
-#include <linux/smp_lock.h>
 #include <linux/quotaops.h>
 
 #define INC_DIR_INODE_NLINK(i) if (i->i_nlink != 1) { inc_nlink(i); if (i->i_nlink >= REISERFS_LINK_MAX) i->i_nlink=1; }
diff -puN fs/reiserfs/procfs.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/reiserfs/procfs.c
--- a/fs/reiserfs/procfs.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/reiserfs/procfs.c
@@ -16,7 +16,6 @@
 #include <asm/uaccess.h>
 #include <linux/reiserfs_fs.h>
 #include <linux/reiserfs_fs_sb.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 
diff -puN fs/reiserfs/stree.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/reiserfs/stree.c
--- a/fs/reiserfs/stree.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/reiserfs/stree.c
@@ -53,7 +53,6 @@
 #include <linux/string.h>
 #include <linux/pagemap.h>
 #include <linux/reiserfs_fs.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/quotaops.h>
 
diff -puN fs/reiserfs/super.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/reiserfs/super.c
@@ -18,7 +18,6 @@
 #include <linux/reiserfs_fs.h>
 #include <linux/reiserfs_acl.h>
 #include <linux/reiserfs_xattr.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
diff -puN fs/select.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/select.c
--- a/fs/select.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/select.c
@@ -17,7 +17,6 @@
 #include <linux/syscalls.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/personality.h> /* for STICKY_TIMEOUTS */
 #include <linux/file.h>
diff -puN fs/smbfs/smbiod.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/smbfs/smbiod.c
--- a/fs/smbfs/smbiod.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/smbfs/smbiod.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 #include <linux/file.h>
 #include <linux/dcache.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/kthread.h>
diff -puN fs/smbfs/sock.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/smbfs/sock.c
--- a/fs/smbfs/sock.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/smbfs/sock.c
@@ -17,7 +17,6 @@
 #include <linux/net.h>
 #include <linux/mm.h>
 #include <linux/netdevice.h>
-#include <linux/smp_lock.h>
 #include <linux/workqueue.h>
 #include <net/scm.h>
 #include <net/tcp_states.h>
diff -puN fs/smbfs/symlink.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/smbfs/symlink.c
--- a/fs/smbfs/symlink.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/smbfs/symlink.c
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/net.h>
 #include <linux/namei.h>
 
diff -puN fs/stat.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/stat.c
--- a/fs/stat.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/stat.c
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/file.h>
-#include <linux/smp_lock.h>
 #include <linux/highuid.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
diff -puN fs/sysv/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/sysv/namei.c
--- a/fs/sysv/namei.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/sysv/namei.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include "sysv.h"
 
 static int add_nondir(struct dentry *dentry, struct inode *inode)
diff -puN fs/udf/fsync.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/udf/fsync.c
--- a/fs/udf/fsync.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/udf/fsync.c
@@ -21,7 +21,6 @@
 #include "udfdecl.h"
 
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 
 static int udf_fsync_inode(struct inode *, int);
 
diff -puN fs/ufs/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/ufs/dir.c
--- a/fs/ufs/dir.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/ufs/dir.c
@@ -19,7 +19,6 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/ufs_fs.h>
-#include <linux/smp_lock.h>
 
 #include "swab.h"
 #include "util.h"
diff -puN fs/xattr.c~header-cleaning-dont-include-smp_lockh-when-not-used fs/xattr.c
--- a/fs/xattr.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/fs/xattr.c
@@ -9,7 +9,6 @@
  */
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/file.h>
 #include <linux/xattr.h>
 #include <linux/namei.h>
diff -puN ipc/sem.c~header-cleaning-dont-include-smp_lockh-when-not-used ipc/sem.c
--- a/ipc/sem.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/ipc/sem.c
@@ -75,7 +75,6 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/time.h>
-#include <linux/smp_lock.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
diff -puN ipc/util.c~header-cleaning-dont-include-smp_lockh-when-not-used ipc/util.c
--- a/ipc/util.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/ipc/util.c
@@ -21,7 +21,6 @@
 #include <linux/shm.h>
 #include <linux/init.h>
 #include <linux/msg.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/capability.h>
diff -puN kernel/cpuset.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/cpuset.c
--- a/kernel/cpuset.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/cpuset.c
@@ -42,7 +42,6 @@
 #include <linux/seq_file.h>
 #include <linux/security.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/string.h>
diff -puN kernel/exit.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/exit.c
--- a/kernel/exit.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/exit.c
@@ -7,7 +7,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/capability.h>
 #include <linux/completion.h>
diff -puN kernel/fork.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/fork.c
--- a/kernel/fork.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/fork.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/unistd.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/completion.h>
diff -puN kernel/itimer.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/itimer.c
--- a/kernel/itimer.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/itimer.c
@@ -7,7 +7,6 @@
 /* These are all the functions necessary to implement itimers */
 
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/syscalls.h>
 #include <linux/time.h>
diff -puN kernel/kmod.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/kmod.c
--- a/kernel/kmod.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/kmod.c
@@ -23,7 +23,6 @@
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
 #include <linux/kmod.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/mnt_namespace.h>
 #include <linux/completion.h>
diff -puN kernel/posix-timers.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/posix-timers.c
--- a/kernel/posix-timers.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/posix-timers.c
@@ -31,7 +31,6 @@
  * POSIX clocks & timers
  */
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/time.h>
diff -puN kernel/power/process.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/power/process.c
--- a/kernel/power/process.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/power/process.c
@@ -8,7 +8,6 @@
 
 #undef DEBUG
 
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include <linux/module.h>
diff -puN kernel/power/snapshot.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/power/snapshot.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/suspend.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
diff -puN kernel/power/swap.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/power/swap.c
--- a/kernel/power/swap.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/power/swap.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/version.h>
diff -puN kernel/printk.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/printk.c
--- a/kernel/printk.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/printk.c
@@ -20,7 +20,6 @@
 #include <linux/mm.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
-#include <linux/smp_lock.h>
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff -puN kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/signal.c
--- a/kernel/signal.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/signal.c
@@ -12,7 +12,6 @@
 
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
diff -puN kernel/time.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/time.c
--- a/kernel/time.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/time.c
@@ -31,7 +31,6 @@
 #include <linux/timex.h>
 #include <linux/capability.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/security.h>
 #include <linux/fs.h>
diff -puN kernel/uid16.c~header-cleaning-dont-include-smp_lockh-when-not-used kernel/uid16.c
--- a/kernel/uid16.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/kernel/uid16.c
@@ -6,7 +6,6 @@
 #include <linux/mm.h>
 #include <linux/utsname.h>
 #include <linux/mman.h>
-#include <linux/smp_lock.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/prctl.h>
diff -puN net/appletalk/ddp.c~header-cleaning-dont-include-smp_lockh-when-not-used net/appletalk/ddp.c
--- a/net/appletalk/ddp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/appletalk/ddp.c
@@ -1841,7 +1841,6 @@ static const struct proto_ops SOCKOPS_WR
 	.sendpage	= sock_no_sendpage,
 };
 
-#include <linux/smp_lock.h>
 SOCKOPS_WRAP(atalk_dgram, PF_APPLETALK);
 
 static struct notifier_block ddp_notifier = {
diff -puN net/ax25/af_ax25.c~header-cleaning-dont-include-smp_lockh-when-not-used net/ax25/af_ax25.c
--- a/net/ax25/af_ax25.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/ax25/af_ax25.c
@@ -23,7 +23,6 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/sockios.h>
 #include <linux/net.h>
 #include <net/ax25.h>
diff -puN net/bluetooth/bnep/core.c~header-cleaning-dont-include-smp_lockh-when-not-used net/bluetooth/bnep/core.c
--- a/net/bluetooth/bnep/core.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/bluetooth/bnep/core.c
@@ -37,7 +37,6 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/net.h>
 #include <net/sock.h>
 
diff -puN net/bridge/br_stp.c~header-cleaning-dont-include-smp_lockh-when-not-used net/bridge/br_stp.c
--- a/net/bridge/br_stp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/bridge/br_stp.c
@@ -13,7 +13,6 @@
  *	2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 
 #include "br_private.h"
 #include "br_private_stp.h"
diff -puN net/bridge/br_stp_if.c~header-cleaning-dont-include-smp_lockh-when-not-used net/bridge/br_stp_if.c
--- a/net/bridge/br_stp_if.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/bridge/br_stp_if.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 
diff -puN net/bridge/br_stp_timer.c~header-cleaning-dont-include-smp_lockh-when-not-used net/bridge/br_stp_timer.c
--- a/net/bridge/br_stp_timer.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/bridge/br_stp_timer.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include <linux/times.h>
-#include <linux/smp_lock.h>
 
 #include "br_private.h"
 #include "br_private_stp.h"
diff -puN net/core/netpoll.c~header-cleaning-dont-include-smp_lockh-when-not-used net/core/netpoll.c
--- a/net/core/netpoll.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/core/netpoll.c
@@ -9,7 +9,6 @@
  * Copyright (C) 2002  Red Hat, Inc.
  */
 
-#include <linux/smp_lock.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/string.h>
diff -puN net/core/pktgen.c~header-cleaning-dont-include-smp_lockh-when-not-used net/core/pktgen.c
--- a/net/core/pktgen.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/core/pktgen.c
@@ -117,7 +117,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff -puN net/ipv4/af_inet.c~header-cleaning-dont-include-smp_lockh-when-not-used net/ipv4/af_inet.c
--- a/net/ipv4/af_inet.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/ipv4/af_inet.c
@@ -92,7 +92,6 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#include <linux/smp_lock.h>
 #include <linux/inet.h>
 #include <linux/igmp.h>
 #include <linux/inetdevice.h>
diff -puN net/ipv4/tcp.c~header-cleaning-dont-include-smp_lockh-when-not-used net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/ipv4/tcp.c
@@ -252,7 +252,6 @@
 #include <linux/fcntl.h>
 #include <linux/poll.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/random.h>
 #include <linux/bootmem.h>
diff -puN net/ipv4/tcp_output.c~header-cleaning-dont-include-smp_lockh-when-not-used net/ipv4/tcp_output.c
--- a/net/ipv4/tcp_output.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/ipv4/tcp_output.c
@@ -40,7 +40,6 @@
 
 #include <linux/compiler.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 
 /* People can turn this off for buggy TCP's found in printers etc. */
 int sysctl_tcp_retrans_collapse __read_mostly = 1;
diff -puN net/ipv6/af_inet6.c~header-cleaning-dont-include-smp_lockh-when-not-used net/ipv6/af_inet6.c
--- a/net/ipv6/af_inet6.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/ipv6/af_inet6.c
@@ -42,7 +42,6 @@
 #include <linux/inet.h>
 #include <linux/netdevice.h>
 #include <linux/icmpv6.h>
-#include <linux/smp_lock.h>
 #include <linux/netfilter_ipv6.h>
 
 #include <net/ip.h>
diff -puN net/ipx/af_ipx.c~header-cleaning-dont-include-smp_lockh-when-not-used net/ipx/af_ipx.c
--- a/net/ipx/af_ipx.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/ipx/af_ipx.c
@@ -1961,7 +1961,6 @@ static const struct proto_ops SOCKOPS_WR
 	.sendpage	= sock_no_sendpage,
 };
 
-#include <linux/smp_lock.h>
 SOCKOPS_WRAP(ipx_dgram, PF_IPX);
 
 static struct packet_type ipx_8023_packet_type = {
diff -puN net/irda/af_irda.c~header-cleaning-dont-include-smp_lockh-when-not-used net/irda/af_irda.c
--- a/net/irda/af_irda.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/irda/af_irda.c
@@ -2580,7 +2580,6 @@ static const struct proto_ops SOCKOPS_WR
 };
 #endif /* CONFIG_IRDA_ULTRA */
 
-#include <linux/smp_lock.h>
 SOCKOPS_WRAP(irda_stream, PF_IRDA);
 SOCKOPS_WRAP(irda_seqpacket, PF_IRDA);
 SOCKOPS_WRAP(irda_dgram, PF_IRDA);
diff -puN net/netlink/af_netlink.c~header-cleaning-dont-include-smp_lockh-when-not-used net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/netlink/af_netlink.c
@@ -45,7 +45,6 @@
 #include <linux/rtnetlink.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/notifier.h>
 #include <linux/security.h>
 #include <linux/jhash.h>
diff -puN net/unix/af_unix.c~header-cleaning-dont-include-smp_lockh-when-not-used net/unix/af_unix.c
--- a/net/unix/af_unix.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/unix/af_unix.c
@@ -111,7 +111,6 @@
 #include <net/scm.h>
 #include <linux/init.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/rtnetlink.h>
 #include <linux/mount.h>
 #include <net/checksum.h>
diff -puN net/x25/af_x25.c~header-cleaning-dont-include-smp_lockh-when-not-used net/x25/af_x25.c
--- a/net/x25/af_x25.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/net/x25/af_x25.c
@@ -1605,7 +1605,6 @@ static const struct proto_ops SOCKOPS_WR
 	.sendpage =	sock_no_sendpage,
 };
 
-#include <linux/smp_lock.h>
 SOCKOPS_WRAP(x25_proto, AF_X25);
 
 static struct packet_type x25_packet_type = {
diff -puN security/capability.c~header-cleaning-dont-include-smp_lockh-when-not-used security/capability.c
--- a/security/capability.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/security/capability.c
@@ -17,7 +17,6 @@
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
-#include <linux/smp_lock.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <linux/ptrace.h>
diff -puN security/commoncap.c~header-cleaning-dont-include-smp_lockh-when-not-used security/commoncap.c
--- a/security/commoncap.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/security/commoncap.c
@@ -17,7 +17,6 @@
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
-#include <linux/smp_lock.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <linux/ptrace.h>
diff -puN security/selinux/hooks.c~header-cleaning-dont-include-smp_lockh-when-not-used security/selinux/hooks.c
--- a/security/selinux/hooks.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/security/selinux/hooks.c
@@ -35,7 +35,6 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
diff -puN sound/core/control.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/core/control.c
--- a/sound/core/control.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/core/control.c
@@ -22,7 +22,6 @@
 #include <sound/driver.h>
 #include <linux/threads.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/time.h>
diff -puN sound/core/hwdep.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/core/hwdep.c
--- a/sound/core/hwdep.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/core/hwdep.c
@@ -22,7 +22,6 @@
 #include <sound/driver.h>
 #include <linux/major.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/mutex.h>
diff -puN sound/core/oss/mixer_oss.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/core/oss/mixer_oss.c
--- a/sound/core/oss/mixer_oss.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/core/oss/mixer_oss.c
@@ -21,7 +21,6 @@
 
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/string.h>
diff -puN sound/core/oss/pcm_oss.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/core/oss/pcm_oss.c
--- a/sound/core/oss/pcm_oss.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/core/oss/pcm_oss.c
@@ -28,7 +28,6 @@
 
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
diff -puN sound/core/pcm_native.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/core/pcm_native.c
@@ -21,7 +21,6 @@
 
 #include <sound/driver.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/file.h>
 #include <linux/slab.h>
 #include <linux/time.h>
diff -puN sound/core/rawmidi.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/core/rawmidi.c
--- a/sound/core/rawmidi.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/core/rawmidi.c
@@ -23,7 +23,6 @@
 #include <sound/core.h>
 #include <linux/major.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/time.h>
diff -puN sound/core/seq/oss/seq_oss.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/core/seq/oss/seq_oss.c
--- a/sound/core/seq/oss/seq_oss.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/core/seq/oss/seq_oss.c
@@ -22,7 +22,6 @@
 
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <sound/core.h>
diff -puN sound/core/seq/seq_clientmgr.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/core/seq/seq_clientmgr.c
--- a/sound/core/seq/seq_clientmgr.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/core/seq/seq_clientmgr.c
@@ -23,7 +23,6 @@
 
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/minors.h>
diff -puN sound/core/timer.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/core/timer.c
--- a/sound/core/timer.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/core/timer.c
@@ -22,7 +22,6 @@
 #include <sound/driver.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/mutex.h>
diff -puN /dev/null /dev/null
diff -puN /dev/null /dev/null
diff -puN sound/oss/swarm_cs4297a.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/oss/swarm_cs4297a.c
--- a/sound/oss/swarm_cs4297a.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/oss/swarm_cs4297a.c
@@ -75,7 +75,6 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/kernel.h>
 
diff -puN sound/oss/trident.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/oss/trident.c
--- a/sound/oss/trident.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/oss/trident.c
@@ -207,7 +207,6 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/ac97_codec.h>
 #include <linux/bitops.h>
 #include <linux/proc_fs.h>
diff -puN sound/oss/via82cxxx_audio.c~header-cleaning-dont-include-smp_lockh-when-not-used sound/oss/via82cxxx_audio.c
--- a/sound/oss/via82cxxx_audio.c~header-cleaning-dont-include-smp_lockh-when-not-used
+++ a/sound/oss/via82cxxx_audio.c
@@ -32,7 +32,6 @@
 #include <linux/poll.h>
 #include <linux/soundcard.h>
 #include <linux/ac97_codec.h>
-#include <linux/smp_lock.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-drm.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
