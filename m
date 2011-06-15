From: akpm@linux-foundation.org
Subject: [failures] atomic-use-linux-atomich.patch removed from -mm tree
Date: Wed, 15 Jun 2011 15:54:17 -0700
Message-ID: <201106152331.p5FNVWva026195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab1FOXcP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 19:32:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: asharma@fb.com, davem@davemloft.net, eric.dumazet@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     atomic: use <linux/atomic.h>
has been removed from the -mm tree.  Its filename was
     atomic-use-linux-atomich.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atomic: use <linux/atomic.h>
From: Arun Sharma <asharma@fb.com>

This allows us to move duplicated code in <asm/atomic.h>
(atomic_inc_not_zero() for now) to <linux/atomic.h>

More cleanup patches to follow.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/atomic.h                         |    1 -
 arch/alpha/include/asm/local.h                          |    2 +-
 arch/alpha/kernel/perf_event.c                          |    2 +-
 arch/alpha/kernel/smp.c                                 |    2 +-
 arch/alpha/lib/dec_and_lock.c                           |    2 +-
 arch/arm/include/asm/atomic.h                           |    1 -
 arch/arm/kernel/smp.c                                   |    2 +-
 arch/arm/kernel/traps.c                                 |    2 +-
 arch/arm/mach-at91/pm.c                                 |    2 +-
 arch/arm/mach-bcmring/dma.c                             |    2 +-
 arch/arm/mach-cns3xxx/include/mach/pm.h                 |    2 +-
 arch/arm/mach-cns3xxx/pm.c                              |    2 +-
 arch/arm/mach-omap1/pm.c                                |    2 +-
 arch/arm/mach-s3c2440/clock.c                           |    2 +-
 arch/arm/mach-s3c2440/s3c2442.c                         |    2 +-
 arch/arm/mach-s3c2440/s3c244x-clock.c                   |    2 +-
 arch/avr32/include/asm/atomic.h                         |    1 -
 arch/blackfin/include/asm/atomic.h                      |    1 -
 arch/blackfin/include/asm/dma.h                         |    2 +-
 arch/blackfin/include/asm/ipipe.h                       |    2 +-
 arch/blackfin/include/asm/spinlock.h                    |    2 +-
 arch/blackfin/kernel/ftrace.c                           |    2 +-
 arch/blackfin/kernel/ipipe.c                            |    2 +-
 arch/blackfin/kernel/nmi.c                              |    2 +-
 arch/blackfin/mach-common/smp.c                         |    2 +-
 arch/cris/arch-v32/drivers/cryptocop.c                  |    2 +-
 arch/cris/arch-v32/kernel/smp.c                         |    2 +-
 arch/cris/include/asm/atomic.h                          |    1 -
 arch/cris/include/asm/bitops.h                          |    2 +-
 arch/cris/kernel/process.c                              |    2 +-
 arch/frv/include/asm/atomic.h                           |    1 -
 arch/frv/include/asm/hardirq.h                          |    2 +-
 arch/frv/kernel/irq.c                                   |    2 +-
 arch/h8300/include/asm/atomic.h                         |    1 -
 arch/ia64/include/asm/atomic.h                          |    1 -
 arch/ia64/include/asm/processor.h                       |    2 +-
 arch/ia64/include/asm/spinlock.h                        |    2 +-
 arch/ia64/kernel/smp.c                                  |    2 +-
 arch/ia64/kernel/smpboot.c                              |    2 +-
 arch/ia64/kernel/uncached.c                             |    2 +-
 arch/m32r/include/asm/atomic.h                          |    1 -
 arch/m32r/include/asm/mmu_context.h                     |    2 +-
 arch/m32r/include/asm/spinlock.h                        |    2 +-
 arch/m32r/kernel/smp.c                                  |    2 +-
 arch/m32r/kernel/traps.c                                |    2 +-
 arch/m68k/include/asm/atomic.h                          |    1 -
 arch/microblaze/include/asm/mmu_context_mm.h            |    2 +-
 arch/microblaze/include/asm/prom.h                      |    2 +-
 arch/mips/include/asm/atomic.h                          |    1 -
 arch/mips/include/asm/hw_irq.h                          |    2 +-
 arch/mips/include/asm/local.h                           |    2 +-
 arch/mips/include/asm/smp.h                             |    2 +-
 arch/mips/kernel/irq.c                                  |    2 +-
 arch/mips/kernel/mips-mt.c                              |    2 +-
 arch/mips/kernel/rtlx.c                                 |    2 +-
 arch/mips/kernel/smp-cmp.c                              |    2 +-
 arch/mips/kernel/smp-mt.c                               |    2 +-
 arch/mips/kernel/smp.c                                  |    2 +-
 arch/mips/kernel/smtc-proc.c                            |    2 +-
 arch/mips/kernel/smtc.c                                 |    2 +-
 arch/mips/kernel/sync-r4k.c                             |    2 +-
 arch/mips/kernel/vpe.c                                  |    2 +-
 arch/mips/mipssim/sim_smtc.c                            |    2 +-
 arch/mips/sgi-ip27/ip27-nmi.c                           |    2 +-
 arch/mn10300/include/asm/atomic.h                       |    1 -
 arch/mn10300/include/asm/mmu_context.h                  |    2 +-
 arch/mn10300/include/asm/spinlock.h                     |    2 +-
 arch/mn10300/include/asm/system.h                       |    2 +-
 arch/mn10300/kernel/mn10300-watchdog.c                  |    2 +-
 arch/mn10300/kernel/traps.c                             |    2 +-
 arch/mn10300/mm/misalignment.c                          |    2 +-
 arch/mn10300/proc-mn2ws0050/proc-init.c                 |    2 +-
 arch/parisc/include/asm/atomic.h                        |    1 -
 arch/parisc/include/asm/bitops.h                        |    2 +-
 arch/parisc/include/asm/mmu_context.h                   |    2 +-
 arch/parisc/kernel/parisc_ksyms.c                       |    2 +-
 arch/parisc/kernel/smp.c                                |    2 +-
 arch/parisc/kernel/traps.c                              |    2 +-
 arch/parisc/lib/bitops.c                                |    2 +-
 arch/powerpc/include/asm/atomic.h                       |    1 -
 arch/powerpc/include/asm/emulated_ops.h                 |    2 +-
 arch/powerpc/include/asm/irq.h                          |    2 +-
 arch/powerpc/include/asm/local.h                        |    2 +-
 arch/powerpc/include/asm/prom.h                         |    2 +-
 arch/powerpc/kernel/of_platform.c                       |    2 +-
 arch/powerpc/kernel/ppc_ksyms.c                         |    2 +-
 arch/powerpc/kernel/rtas.c                              |    2 +-
 arch/powerpc/kernel/rtasd.c                             |    2 +-
 arch/powerpc/kernel/smp-tbsync.c                        |    2 +-
 arch/powerpc/kernel/smp.c                               |    2 +-
 arch/powerpc/platforms/83xx/km83xx.c                    |    2 +-
 arch/powerpc/platforms/83xx/mpc832x_mds.c               |    2 +-
 arch/powerpc/platforms/83xx/mpc834x_itx.c               |    2 +-
 arch/powerpc/platforms/83xx/mpc834x_mds.c               |    2 +-
 arch/powerpc/platforms/83xx/mpc836x_mds.c               |    2 +-
 arch/powerpc/platforms/83xx/sbc834x.c                   |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c               |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c               |    2 +-
 arch/powerpc/platforms/85xx/sbc8548.c                   |    2 +-
 arch/powerpc/platforms/cell/cpufreq_spudemand.c         |    2 +-
 arch/powerpc/platforms/cell/smp.c                       |    2 +-
 arch/powerpc/platforms/cell/spufs/context.c             |    2 +-
 arch/powerpc/platforms/chrp/smp.c                       |    2 +-
 arch/powerpc/platforms/iseries/smp.c                    |    2 +-
 arch/powerpc/platforms/powermac/backlight.c             |    2 +-
 arch/powerpc/platforms/powermac/smp.c                   |    2 +-
 arch/powerpc/platforms/pseries/eeh.c                    |    2 +-
 arch/powerpc/platforms/pseries/eeh_cache.c              |    2 +-
 arch/powerpc/platforms/pseries/smp.c                    |    2 +-
 arch/powerpc/sysdev/fsl_soc.c                           |    2 +-
 arch/powerpc/sysdev/tsi108_dev.c                        |    2 +-
 arch/s390/include/asm/atomic.h                          |    1 -
 arch/s390/kernel/dis.c                                  |    2 +-
 arch/s390/kernel/traps.c                                |    2 +-
 arch/sh/include/asm/atomic.h                            |    1 -
 arch/sh/include/asm/hw_irq.h                            |    2 +-
 arch/sh/include/asm/smp.h                               |    2 +-
 arch/sh/kernel/idle.c                                   |    2 +-
 arch/sh/kernel/smp.c                                    |    2 +-
 arch/sh/kernel/traps_64.c                               |    2 +-
 arch/sh/kernel/unwinder.c                               |    2 +-
 arch/sparc/include/asm/atomic_32.h                      |    1 -
 arch/sparc/include/asm/atomic_64.h                      |    1 -
 arch/sparc/include/asm/prom.h                           |    2 +-
 arch/sparc/include/asm/smp_32.h                         |    2 +-
 arch/sparc/include/asm/smp_64.h                         |    2 +-
 arch/sparc/kernel/irq_64.c                              |    2 +-
 arch/sparc/kernel/leon_smp.c                            |    2 +-
 arch/sparc/kernel/perf_event.c                          |    2 +-
 arch/sparc/kernel/smp_32.c                              |    2 +-
 arch/sparc/kernel/smp_64.c                              |    2 +-
 arch/sparc/lib/atomic32.c                               |    2 +-
 arch/tile/include/asm/atomic.h                          |    9 ---------
 arch/tile/include/asm/atomic_32.h                       |    4 ++--
 arch/tile/include/asm/atomic_64.h                       |    2 +-
 arch/tile/include/asm/bitops_32.h                       |    2 +-
 arch/tile/include/asm/bitops_64.h                       |    2 +-
 arch/tile/include/asm/spinlock_32.h                     |    2 +-
 arch/tile/kernel/intvec_32.S                            |    2 +-
 arch/tile/lib/atomic_32.c                               |    2 +-
 arch/tile/lib/atomic_asm_32.S                           |    2 +-
 arch/x86/ia32/sys_ia32.c                                |    2 +-
 arch/x86/include/asm/apic.h                             |    2 +-
 arch/x86/include/asm/atomic.h                           |    1 -
 arch/x86/include/asm/hw_irq.h                           |    2 +-
 arch/x86/include/asm/local.h                            |    2 +-
 arch/x86/include/asm/mce.h                              |    2 +-
 arch/x86/include/asm/mmu_context.h                      |    2 +-
 arch/x86/include/asm/prom.h                             |    2 +-
 arch/x86/include/asm/spinlock.h                         |    2 +-
 arch/x86/include/asm/thread_info.h                      |    2 +-
 arch/x86/kernel/amd_gart_64.c                           |    2 +-
 arch/x86/kernel/apic/apic.c                             |    2 +-
 arch/x86/kernel/apic/es7000_32.c                        |    2 +-
 arch/x86/kernel/cpu/common.c                            |    2 +-
 arch/x86/kernel/i8259.c                                 |    2 +-
 arch/x86/kernel/irqinit.c                               |    2 +-
 arch/x86/kernel/traps.c                                 |    2 +-
 arch/x86/kvm/lapic.c                                    |    2 +-
 arch/x86/kvm/timer.c                                    |    2 +-
 arch/x86/lib/atomic64_32.c                              |    2 +-
 arch/x86/mm/mmio-mod.c                                  |    2 +-
 arch/xtensa/include/asm/atomic.h                        |    1 -
 arch/xtensa/kernel/process.c                            |    2 +-
 crypto/af_alg.c                                         |    2 +-
 crypto/proc.c                                           |    2 +-
 crypto/rng.c                                            |    2 +-
 drivers/atm/ambassador.c                                |    2 +-
 drivers/atm/atmtcp.c                                    |    2 +-
 drivers/atm/eni.c                                       |    2 +-
 drivers/atm/eni.h                                       |    2 +-
 drivers/atm/firestream.c                                |    2 +-
 drivers/atm/fore200e.c                                  |    2 +-
 drivers/atm/horizon.c                                   |    2 +-
 drivers/atm/idt77252.c                                  |    2 +-
 drivers/atm/iphase.c                                    |    2 +-
 drivers/atm/nicstar.c                                   |    2 +-
 drivers/atm/suni.c                                      |    2 +-
 drivers/atm/uPD98402.c                                  |    2 +-
 drivers/atm/zatm.c                                      |    2 +-
 drivers/base/memory.c                                   |    2 +-
 drivers/base/power/sysfs.c                              |    2 +-
 drivers/block/cciss_scsi.c                              |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c                       |    2 +-
 drivers/char/mspec.c                                    |    2 +-
 drivers/connector/cn_proc.c                             |    2 +-
 drivers/edac/edac_stub.c                                |    2 +-
 drivers/firewire/core-card.c                            |    2 +-
 drivers/firewire/core-device.c                          |    2 +-
 drivers/firewire/core-topology.c                        |    2 +-
 drivers/firewire/core.h                                 |    2 +-
 drivers/firewire/nosy.c                                 |    2 +-
 drivers/gpu/drm/radeon/radeon.h                         |    2 +-
 drivers/gpu/drm/radeon/radeon_fence.c                   |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                            |    2 +-
 drivers/gpu/drm/ttm/ttm_lock.c                          |    2 +-
 drivers/gpu/drm/ttm/ttm_object.c                        |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c                    |    2 +-
 drivers/hwmon/sht15.c                                   |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c                       |    2 +-
 drivers/infiniband/hw/ehca/ehca_tools.h                 |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c                      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h                    |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                     |    2 +-
 drivers/isdn/gigaset/gigaset.h                          |    2 +-
 drivers/md/dm-crypt.c                                   |    2 +-
 drivers/md/dm-kcopyd.c                                  |    2 +-
 drivers/md/dm-mpath.c                                   |    2 +-
 drivers/md/dm-queue-length.c                            |    2 +-
 drivers/md/dm-table.c                                   |    2 +-
 drivers/media/video/hdpvr/hdpvr-core.c                  |    2 +-
 drivers/media/video/tlg2300/pd-dvb.c                    |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c                      |    2 +-
 drivers/media/video/uvc/uvc_driver.c                    |    2 +-
 drivers/media/video/uvc/uvc_queue.c                     |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c                      |    2 +-
 drivers/media/video/uvc/uvc_video.c                     |    2 +-
 drivers/message/i2o/i2o_scsi.c                          |    2 +-
 drivers/misc/phantom.c                                  |    2 +-
 drivers/net/atlx/atl1.c                                 |    2 +-
 drivers/net/atlx/atl2.c                                 |    2 +-
 drivers/net/atlx/atl2.h                                 |    2 +-
 drivers/net/cassini.c                                   |    2 +-
 drivers/net/cpmac.c                                     |    2 +-
 drivers/net/cxgb3/cxgb3_offload.c                       |    2 +-
 drivers/net/cxgb3/l2t.h                                 |    2 +-
 drivers/net/cxgb3/t3cdev.h                              |    2 +-
 drivers/net/cxgb4/cxgb4_uld.h                           |    2 +-
 drivers/net/cxgb4/l2t.h                                 |    2 +-
 drivers/net/hamradio/6pack.c                            |    2 +-
 drivers/net/hamradio/dmascc.c                           |    2 +-
 drivers/net/ibmveth.c                                   |    2 +-
 drivers/net/phy/phy.c                                   |    2 +-
 drivers/net/ppp_generic.c                               |    2 +-
 drivers/net/wimax/i2400m/i2400m.h                       |    2 +-
 drivers/net/wireless/b43legacy/b43legacy.h              |    2 +-
 drivers/net/wireless/b43legacy/dma.h                    |    2 +-
 drivers/oprofile/oprofile_stats.h                       |    2 +-
 drivers/pci/hotplug/cpci_hotplug_core.c                 |    2 +-
 drivers/pci/xen-pcifront.c                              |    2 +-
 drivers/s390/block/dasd_eer.c                           |    2 +-
 drivers/s390/char/sclp_quiesce.c                        |    2 +-
 drivers/s390/char/vmlogrdr.c                            |    2 +-
 drivers/s390/cio/device.h                               |    2 +-
 drivers/s390/cio/qdio_main.c                            |    2 +-
 drivers/s390/cio/qdio_thinint.c                         |    2 +-
 drivers/s390/crypto/ap_bus.c                            |    2 +-
 drivers/s390/crypto/zcrypt_api.c                        |    2 +-
 drivers/s390/crypto/zcrypt_cex2a.c                      |    2 +-
 drivers/s390/crypto/zcrypt_mono.c                       |    2 +-
 drivers/s390/crypto/zcrypt_pcica.c                      |    2 +-
 drivers/s390/crypto/zcrypt_pcicc.c                      |    2 +-
 drivers/s390/crypto/zcrypt_pcixcc.c                     |    2 +-
 drivers/s390/net/fsm.h                                  |    2 +-
 drivers/s390/scsi/zfcp_scsi.c                           |    2 +-
 drivers/sbus/char/display7seg.c                         |    2 +-
 drivers/scsi/dpt/dpti_i2o.h                             |    2 +-
 drivers/scsi/hpsa.c                                     |    2 +-
 drivers/scsi/pm8001/pm8001_sas.h                        |    2 +-
 drivers/staging/octeon/ethernet-rx.c                    |    2 +-
 drivers/staging/octeon/ethernet-tx.c                    |    2 +-
 drivers/staging/rtl8712/osdep_service.h                 |    2 +-
 drivers/staging/solo6x10/solo6x10.h                     |    2 +-
 drivers/staging/tidspbridge/include/dspbridge/host_os.h |    2 +-
 drivers/staging/winbond/mds_s.h                         |    2 +-
 drivers/staging/winbond/wb35reg_s.h                     |    2 +-
 drivers/tty/bfin_jtag_comm.c                            |    2 +-
 drivers/tty/rocket.c                                    |    2 +-
 drivers/tty/serial/dz.c                                 |    2 +-
 drivers/tty/serial/sb1250-duart.c                       |    2 +-
 drivers/tty/serial/zs.c                                 |    2 +-
 drivers/usb/gadget/f_audio.c                            |    2 +-
 drivers/usb/gadget/f_rndis.c                            |    2 +-
 drivers/usb/gadget/uvc_queue.c                          |    2 +-
 drivers/usb/image/microtek.c                            |    2 +-
 drivers/usb/misc/appledisplay.c                         |    2 +-
 drivers/usb/serial/garmin_gps.c                         |    2 +-
 drivers/usb/wusbcore/wa-rpipe.c                         |    2 +-
 drivers/vhost/vhost.h                                   |    2 +-
 drivers/video/sh_mobile_lcdcfb.c                        |    2 +-
 drivers/video/vermilion/vermilion.h                     |    2 +-
 drivers/w1/masters/matrox_w1.c                          |    2 +-
 drivers/w1/w1.c                                         |    2 +-
 drivers/w1/w1_family.h                                  |    2 +-
 drivers/watchdog/intel_scu_watchdog.c                   |    2 +-
 drivers/watchdog/sbc7240_wdt.c                          |    2 +-
 fs/btrfs/delayed-inode.h                                |    2 +-
 fs/direct-io.c                                          |    2 +-
 fs/eventpoll.c                                          |    2 +-
 fs/file_table.c                                         |    2 +-
 fs/gfs2/main.c                                          |    2 +-
 fs/nfs/cache_lib.h                                      |    2 +-
 fs/nfs/direct.c                                         |    2 +-
 fs/notify/group.c                                       |    2 +-
 fs/notify/inode_mark.c                                  |    2 +-
 fs/notify/mark.c                                        |    2 +-
 fs/notify/notification.c                                |    2 +-
 fs/notify/vfsmount_mark.c                               |    2 +-
 fs/ntfs/inode.h                                         |    2 +-
 fs/posix_acl.c                                          |    2 +-
 fs/proc/meminfo.c                                       |    2 +-
 include/acpi/platform/aclinux.h                         |    2 +-
 include/asm-generic/local.h                             |    2 +-
 include/asm-generic/local64.h                           |    2 +-
 include/drm/ttm/ttm_lock.h                              |    2 +-
 include/linux/aio.h                                     |    2 +-
 include/linux/atmdev.h                                  |    2 +-
 include/linux/atomic.h                                  |    9 +++++++++
 include/linux/backing-dev.h                             |    2 +-
 include/linux/bit_spinlock.h                            |    2 +-
 include/linux/buffer_head.h                             |    2 +-
 include/linux/configfs.h                                |    2 +-
 include/linux/connector.h                               |    2 +-
 include/linux/cred.h                                    |    2 +-
 include/linux/crypto.h                                  |    2 +-
 include/linux/dcache.h                                  |    2 +-
 include/linux/debug_locks.h                             |    2 +-
 include/linux/device.h                                  |    2 +-
 include/linux/edac.h                                    |    2 +-
 include/linux/fault-inject.h                            |    2 +-
 include/linux/fdtable.h                                 |    2 +-
 include/linux/filter.h                                  |    2 +-
 include/linux/firewire.h                                |    2 +-
 include/linux/fs.h                                      |    2 +-
 include/linux/fsnotify_backend.h                        |    2 +-
 include/linux/interrupt.h                               |    2 +-
 include/linux/jump_label.h                              |    2 +-
 include/linux/kdb.h                                     |    2 +-
 include/linux/key.h                                     |    2 +-
 include/linux/kgdb.h                                    |    2 +-
 include/linux/kobject.h                                 |    2 +-
 include/linux/mlx4/device.h                             |    2 +-
 include/linux/mman.h                                    |    2 +-
 include/linux/mmzone.h                                  |    2 +-
 include/linux/mount.h                                   |    2 +-
 include/linux/mutex.h                                   |    2 +-
 include/linux/netdevice.h                               |    2 +-
 include/linux/nfs_fs_sb.h                               |    2 +-
 include/linux/oprofile.h                                |    2 +-
 include/linux/pci.h                                     |    2 +-
 include/linux/perf_event.h                              |    2 +-
 include/linux/phy.h                                     |    2 +-
 include/linux/proc_fs.h                                 |    2 +-
 include/linux/quota.h                                   |    2 +-
 include/linux/rwsem.h                                   |    2 +-
 include/linux/sem.h                                     |    2 +-
 include/linux/skbuff.h                                  |    2 +-
 include/linux/sonet.h                                   |    2 +-
 include/linux/spinlock.h                                |    2 +-
 include/linux/sunrpc/auth.h                             |    2 +-
 include/linux/sunrpc/cache.h                            |    2 +-
 include/linux/sunrpc/timer.h                            |    2 +-
 include/linux/swap.h                                    |    2 +-
 include/linux/sysfs.h                                   |    2 +-
 include/linux/vmstat.h                                  |    2 +-
 include/linux/workqueue.h                               |    2 +-
 include/net/ax25.h                                      |    2 +-
 include/net/cipso_ipv4.h                                |    2 +-
 include/net/flow.h                                      |    2 +-
 include/net/inet_hashtables.h                           |    2 +-
 include/net/inet_timewait_sock.h                        |    2 +-
 include/net/inetpeer.h                                  |    2 +-
 include/net/ip_vs.h                                     |    2 +-
 include/net/lib80211.h                                  |    2 +-
 include/net/llc.h                                       |    2 +-
 include/net/neighbour.h                                 |    2 +-
 include/net/net_namespace.h                             |    2 +-
 include/net/netfilter/nf_conntrack.h                    |    2 +-
 include/net/netlabel.h                                  |    2 +-
 include/net/netns/conntrack.h                           |    2 +-
 include/net/sctp/structs.h                              |    2 +-
 include/pcmcia/ds.h                                     |    2 +-
 include/rdma/ib_sa.h                                    |    2 +-
 include/rdma/ib_verbs.h                                 |    2 +-
 include/rxrpc/types.h                                   |    2 +-
 include/scsi/scsi_device.h                              |    2 +-
 include/video/omapdss.h                                 |    2 +-
 kernel/async.c                                          |    2 +-
 kernel/audit.c                                          |    2 +-
 kernel/auditsc.c                                        |    2 +-
 kernel/cgroup.c                                         |    2 +-
 kernel/cpuset.c                                         |    2 +-
 kernel/debug/debug_core.c                               |    2 +-
 kernel/rcupdate.c                                       |    2 +-
 kernel/rcutorture.c                                     |    2 +-
 kernel/rcutree_trace.c                                  |    2 +-
 kernel/rwsem.c                                          |    2 +-
 kernel/stop_machine.c                                   |    2 +-
 kernel/taskstats.c                                      |    2 +-
 kernel/trace/trace.h                                    |    2 +-
 kernel/trace/trace_mmiotrace.c                          |    2 +-
 lib/atomic64.c                                          |    2 +-
 lib/atomic64_test.c                                     |    2 +-
 lib/crc32.c                                             |    2 +-
 lib/dec_and_lock.c                                      |    2 +-
 mm/init-mm.c                                            |    2 +-
 mm/kmemleak.c                                           |    2 +-
 mm/slob.c                                               |    2 +-
 mm/vmalloc.c                                            |    2 +-
 net/atm/atm_misc.c                                      |    2 +-
 net/atm/clip.c                                          |    2 +-
 net/atm/common.c                                        |    2 +-
 net/atm/lec.c                                           |    2 +-
 net/atm/proc.c                                          |    2 +-
 net/bridge/br_fdb.c                                     |    2 +-
 net/core/flow.c                                         |    2 +-
 net/decnet/dn_fib.c                                     |    2 +-
 net/decnet/dn_neigh.c                                   |    2 +-
 net/decnet/dn_table.c                                   |    2 +-
 net/decnet/dn_timer.c                                   |    2 +-
 net/ipv4/cipso_ipv4.c                                   |    2 +-
 net/ipv4/raw.c                                          |    2 +-
 net/ipv6/ip6_tunnel.c                                   |    2 +-
 net/iucv/iucv.c                                         |    2 +-
 net/l2tp/l2tp_core.c                                    |    2 +-
 net/l2tp/l2tp_ppp.c                                     |    2 +-
 net/netfilter/nfnetlink_log.c                           |    2 +-
 net/netfilter/nfnetlink_queue.c                         |    2 +-
 net/netlabel/netlabel_cipso_v4.c                        |    2 +-
 net/netlabel/netlabel_kapi.c                            |    2 +-
 net/netlabel/netlabel_mgmt.c                            |    2 +-
 net/netlabel/netlabel_mgmt.h                            |    2 +-
 net/netlabel/netlabel_unlabeled.c                       |    2 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                         |    2 +-
 net/tipc/core.h                                         |    2 +-
 security/selinux/hooks.c                                |    2 +-
 security/selinux/xfrm.c                                 |    2 +-
 sound/pci/echoaudio/darla20.c                           |    2 +-
 sound/pci/echoaudio/darla24.c                           |    2 +-
 sound/pci/echoaudio/echo3g.c                            |    2 +-
 sound/pci/echoaudio/gina20.c                            |    2 +-
 sound/pci/echoaudio/gina24.c                            |    2 +-
 sound/pci/echoaudio/indigo.c                            |    2 +-
 sound/pci/echoaudio/indigodj.c                          |    2 +-
 sound/pci/echoaudio/indigodjx.c                         |    2 +-
 sound/pci/echoaudio/indigoio.c                          |    2 +-
 sound/pci/echoaudio/indigoiox.c                         |    2 +-
 sound/pci/echoaudio/layla20.c                           |    2 +-
 sound/pci/echoaudio/layla24.c                           |    2 +-
 sound/pci/echoaudio/mia.c                               |    2 +-
 sound/pci/echoaudio/mona.c                              |    2 +-
 sound/pci/lx6464es/lx6464es.h                           |    2 +-
 sound/sparc/dbri.c                                      |    2 +-
 443 files changed, 431 insertions(+), 451 deletions(-)

diff -puN arch/alpha/include/asm/atomic.h~atomic-use-linux-atomich arch/alpha/include/asm/atomic.h
--- a/arch/alpha/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/alpha/include/asm/atomic.h
@@ -199,7 +199,6 @@ static __inline__ int atomic_add_unless(
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /**
  * atomic64_add_unless - add unless the number is a given value
diff -puN arch/alpha/include/asm/local.h~atomic-use-linux-atomich arch/alpha/include/asm/local.h
--- a/arch/alpha/include/asm/local.h~atomic-use-linux-atomich
+++ a/arch/alpha/include/asm/local.h
@@ -2,7 +2,7 @@
 #define _ALPHA_LOCAL_H
 
 #include <linux/percpu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 typedef struct
 {
diff -puN arch/alpha/kernel/perf_event.c~atomic-use-linux-atomich arch/alpha/kernel/perf_event.c
--- a/arch/alpha/kernel/perf_event.c~atomic-use-linux-atomich
+++ a/arch/alpha/kernel/perf_event.c
@@ -17,7 +17,7 @@
 #include <linux/init.h>
 
 #include <asm/hwrpb.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/irq_regs.h>
 #include <asm/pal.h>
diff -puN arch/alpha/kernel/smp.c~atomic-use-linux-atomich arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c~atomic-use-linux-atomich
+++ a/arch/alpha/kernel/smp.c
@@ -31,7 +31,7 @@
 
 #include <asm/hwrpb.h>
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
diff -puN arch/alpha/lib/dec_and_lock.c~atomic-use-linux-atomich arch/alpha/lib/dec_and_lock.c
--- a/arch/alpha/lib/dec_and_lock.c~atomic-use-linux-atomich
+++ a/arch/alpha/lib/dec_and_lock.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
   asm (".text					\n\
 	.global _atomic_dec_and_lock		\n\
diff -puN arch/arm/include/asm/atomic.h~atomic-use-linux-atomich arch/arm/include/asm/atomic.h
--- a/arch/arm/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/arm/include/asm/atomic.h
@@ -217,7 +217,6 @@ static inline int atomic_add_unless(atom
 		c = old;
 	return c != u;
 }
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_inc(v)		atomic_add(1, v)
 #define atomic_dec(v)		atomic_sub(1, v)
diff -puN arch/arm/kernel/smp.c~atomic-use-linux-atomich arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c~atomic-use-linux-atomich
+++ a/arch/arm/kernel/smp.c
@@ -27,7 +27,7 @@
 #include <linux/clockchips.h>
 #include <linux/completion.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
diff -puN arch/arm/kernel/traps.c~atomic-use-linux-atomich arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~atomic-use-linux-atomich
+++ a/arch/arm/kernel/traps.c
@@ -25,7 +25,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/system.h>
 #include <asm/unistd.h>
diff -puN arch/arm/mach-at91/pm.c~atomic-use-linux-atomich arch/arm/mach-at91/pm.c
--- a/arch/arm/mach-at91/pm.c~atomic-use-linux-atomich
+++ a/arch/arm/mach-at91/pm.c
@@ -20,7 +20,7 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mach/time.h>
 #include <asm/mach/irq.h>
 
diff -puN arch/arm/mach-bcmring/dma.c~atomic-use-linux-atomich arch/arm/mach-bcmring/dma.c
--- a/arch/arm/mach-bcmring/dma.c~atomic-use-linux-atomich
+++ a/arch/arm/mach-bcmring/dma.c
@@ -34,7 +34,7 @@
 
 #include <linux/mm.h>
 #include <linux/pfn.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <mach/dma.h>
 
 /* I don't quite understand why dc4 fails when this is set to 1 and DMA is enabled */
diff -puN arch/arm/mach-cns3xxx/include/mach/pm.h~atomic-use-linux-atomich arch/arm/mach-cns3xxx/include/mach/pm.h
--- a/arch/arm/mach-cns3xxx/include/mach/pm.h~atomic-use-linux-atomich
+++ a/arch/arm/mach-cns3xxx/include/mach/pm.h
@@ -11,7 +11,7 @@
 #ifndef __CNS3XXX_PM_H
 #define __CNS3XXX_PM_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 void cns3xxx_pwr_clk_en(unsigned int block);
 void cns3xxx_pwr_clk_dis(unsigned int block);
diff -puN arch/arm/mach-cns3xxx/pm.c~atomic-use-linux-atomich arch/arm/mach-cns3xxx/pm.c
--- a/arch/arm/mach-cns3xxx/pm.c~atomic-use-linux-atomich
+++ a/arch/arm/mach-cns3xxx/pm.c
@@ -10,7 +10,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <mach/system.h>
 #include <mach/cns3xxx.h>
 #include <mach/pm.h>
diff -puN arch/arm/mach-omap1/pm.c~atomic-use-linux-atomich arch/arm/mach-omap1/pm.c
--- a/arch/arm/mach-omap1/pm.c~atomic-use-linux-atomich
+++ a/arch/arm/mach-omap1/pm.c
@@ -44,7 +44,7 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mach/time.h>
 #include <asm/mach/irq.h>
 
diff -puN arch/arm/mach-s3c2440/clock.c~atomic-use-linux-atomich arch/arm/mach-s3c2440/clock.c
--- a/arch/arm/mach-s3c2440/clock.c~atomic-use-linux-atomich
+++ a/arch/arm/mach-s3c2440/clock.c
@@ -36,7 +36,7 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 
 #include <mach/regs-clock.h>
diff -puN arch/arm/mach-s3c2440/s3c2442.c~atomic-use-linux-atomich arch/arm/mach-s3c2440/s3c2442.c
--- a/arch/arm/mach-s3c2440/s3c2442.c~atomic-use-linux-atomich
+++ a/arch/arm/mach-s3c2440/s3c2442.c
@@ -38,7 +38,7 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 
 #include <mach/regs-clock.h>
diff -puN arch/arm/mach-s3c2440/s3c244x-clock.c~atomic-use-linux-atomich arch/arm/mach-s3c2440/s3c244x-clock.c
--- a/arch/arm/mach-s3c2440/s3c244x-clock.c~atomic-use-linux-atomich
+++ a/arch/arm/mach-s3c2440/s3c244x-clock.c
@@ -35,7 +35,7 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 
 #include <mach/regs-clock.h>
diff -puN arch/avr32/include/asm/atomic.h~atomic-use-linux-atomich arch/avr32/include/asm/atomic.h
--- a/arch/avr32/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/avr32/include/asm/atomic.h
@@ -188,7 +188,6 @@ static inline int atomic_sub_if_positive
 #define atomic_dec_and_test(v) (atomic_sub_return(1, v) == 0)
 #define atomic_add_negative(i, v) (atomic_add_return(i, v) < 0)
 
-#define atomic_inc_not_zero(v)	atomic_add_unless(v, 1, 0)
 #define atomic_dec_if_positive(v) atomic_sub_if_positive(1, v)
 
 #define smp_mb__before_atomic_dec()	barrier()
diff -puN arch/blackfin/include/asm/atomic.h~atomic-use-linux-atomich arch/blackfin/include/asm/atomic.h
--- a/arch/blackfin/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/blackfin/include/asm/atomic.h
@@ -102,7 +102,6 @@ static inline int atomic_test_mask(int m
 		c = old;					\
 	c != (u);						\
 })
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /*
  * atomic_inc_and_test - increment and test
diff -puN arch/blackfin/include/asm/dma.h~atomic-use-linux-atomich arch/blackfin/include/asm/dma.h
--- a/arch/blackfin/include/asm/dma.h~atomic-use-linux-atomich
+++ a/arch/blackfin/include/asm/dma.h
@@ -10,7 +10,7 @@
 
 #include <linux/interrupt.h>
 #include <mach/dma.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/blackfin.h>
 #include <asm/page.h>
 #include <asm-generic/dma.h>
diff -puN arch/blackfin/include/asm/ipipe.h~atomic-use-linux-atomich arch/blackfin/include/asm/ipipe.h
--- a/arch/blackfin/include/asm/ipipe.h~atomic-use-linux-atomich
+++ a/arch/blackfin/include/asm/ipipe.h
@@ -32,7 +32,7 @@
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/bitops.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/traps.h>
 #include <asm/bitsperlong.h>
 
diff -puN arch/blackfin/include/asm/spinlock.h~atomic-use-linux-atomich arch/blackfin/include/asm/spinlock.h
--- a/arch/blackfin/include/asm/spinlock.h~atomic-use-linux-atomich
+++ a/arch/blackfin/include/asm/spinlock.h
@@ -11,7 +11,7 @@
 # include <asm-generic/spinlock.h>
 #else
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 asmlinkage int __raw_spin_is_locked_asm(volatile int *ptr);
 asmlinkage void __raw_spin_lock_asm(volatile int *ptr);
diff -puN arch/blackfin/kernel/ftrace.c~atomic-use-linux-atomich arch/blackfin/kernel/ftrace.c
--- a/arch/blackfin/kernel/ftrace.c~atomic-use-linux-atomich
+++ a/arch/blackfin/kernel/ftrace.c
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff -puN arch/blackfin/kernel/ipipe.c~atomic-use-linux-atomich arch/blackfin/kernel/ipipe.c
--- a/arch/blackfin/kernel/ipipe.c~atomic-use-linux-atomich
+++ a/arch/blackfin/kernel/ipipe.c
@@ -32,7 +32,7 @@
 #include <linux/unistd.h>
 #include <linux/io.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq_handler.h>
 
 DEFINE_PER_CPU(struct pt_regs, __ipipe_tick_regs);
diff -puN arch/blackfin/kernel/nmi.c~atomic-use-linux-atomich arch/blackfin/kernel/nmi.c
--- a/arch/blackfin/kernel/nmi.c~atomic-use-linux-atomich
+++ a/arch/blackfin/kernel/nmi.c
@@ -18,7 +18,7 @@
 #include <linux/smp.h>
 #include <linux/timer.h>
 #include <asm/blackfin.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/bfin_watchdog.h>
 
diff -puN arch/blackfin/mach-common/smp.c~atomic-use-linux-atomich arch/blackfin/mach-common/smp.c
--- a/arch/blackfin/mach-common/smp.c~atomic-use-linux-atomich
+++ a/arch/blackfin/mach-common/smp.c
@@ -23,7 +23,7 @@
 #include <linux/seq_file.h>
 #include <linux/irq.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/irq_handler.h>
 #include <asm/mmu_context.h>
diff -puN arch/cris/arch-v32/drivers/cryptocop.c~atomic-use-linux-atomich arch/cris/arch-v32/drivers/cryptocop.c
--- a/arch/cris/arch-v32/drivers/cryptocop.c~atomic-use-linux-atomich
+++ a/arch/cris/arch-v32/drivers/cryptocop.c
@@ -16,7 +16,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/list.h>
 #include <linux/interrupt.h>
diff -puN arch/cris/arch-v32/kernel/smp.c~atomic-use-linux-atomich arch/cris/arch-v32/kernel/smp.c
--- a/arch/cris/arch-v32/kernel/smp.c~atomic-use-linux-atomich
+++ a/arch/cris/arch-v32/kernel/smp.c
@@ -7,7 +7,7 @@
 #include <asm/mmu_context.h>
 #include <hwregs/asm/mmu_defs_asm.h>
 #include <hwregs/supp_reg.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/err.h>
 #include <linux/init.h>
diff -puN arch/cris/include/asm/atomic.h~atomic-use-linux-atomich arch/cris/include/asm/atomic.h
--- a/arch/cris/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/cris/include/asm/atomic.h
@@ -150,7 +150,6 @@ static inline int atomic_add_unless(atom
 	cris_atomic_restore(v, flags);
 	return ret != u;
 }
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /* Atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()    barrier()
diff -puN arch/cris/include/asm/bitops.h~atomic-use-linux-atomich arch/cris/include/asm/bitops.h
--- a/arch/cris/include/asm/bitops.h~atomic-use-linux-atomich
+++ a/arch/cris/include/asm/bitops.h
@@ -20,7 +20,7 @@
 
 #include <arch/bitops.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/compiler.h>
 
 /*
diff -puN arch/cris/kernel/process.c~atomic-use-linux-atomich arch/cris/kernel/process.c
--- a/arch/cris/kernel/process.c~atomic-use-linux-atomich
+++ a/arch/cris/kernel/process.c
@@ -12,7 +12,7 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
diff -puN arch/frv/include/asm/atomic.h~atomic-use-linux-atomich arch/frv/include/asm/atomic.h
--- a/arch/frv/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/frv/include/asm/atomic.h
@@ -256,7 +256,6 @@ static __inline__ int atomic_add_unless(
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #include <asm-generic/atomic-long.h>
 #endif /* _ASM_ATOMIC_H */
diff -puN arch/frv/include/asm/hardirq.h~atomic-use-linux-atomich arch/frv/include/asm/hardirq.h
--- a/arch/frv/include/asm/hardirq.h~atomic-use-linux-atomich
+++ a/arch/frv/include/asm/hardirq.h
@@ -12,7 +12,7 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern atomic_t irq_err_count;
 static inline void ack_bad_irq(int irq)
diff -puN arch/frv/kernel/irq.c~atomic-use-linux-atomich arch/frv/kernel/irq.c
--- a/arch/frv/kernel/irq.c~atomic-use-linux-atomich
+++ a/arch/frv/kernel/irq.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/system.h>
diff -puN arch/h8300/include/asm/atomic.h~atomic-use-linux-atomich arch/h8300/include/asm/atomic.h
--- a/arch/h8300/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/h8300/include/asm/atomic.h
@@ -116,7 +116,6 @@ static inline int atomic_add_unless(atom
 	local_irq_restore(flags);
 	return ret != u;
 }
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static __inline__ void atomic_clear_mask(unsigned long mask, unsigned long *v)
 {
diff -puN arch/ia64/include/asm/atomic.h~atomic-use-linux-atomich arch/ia64/include/asm/atomic.h
--- a/arch/ia64/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/ia64/include/asm/atomic.h
@@ -105,7 +105,6 @@ static __inline__ int atomic_add_unless(
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static __inline__ long atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff -puN arch/ia64/include/asm/processor.h~atomic-use-linux-atomich arch/ia64/include/asm/processor.h
--- a/arch/ia64/include/asm/processor.h~atomic-use-linux-atomich
+++ a/arch/ia64/include/asm/processor.h
@@ -75,7 +75,7 @@
 #include <asm/percpu.h>
 #include <asm/rse.h>
 #include <asm/unwind.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #ifdef CONFIG_NUMA
 #include <asm/nodedata.h>
 #endif
diff -puN arch/ia64/include/asm/spinlock.h~atomic-use-linux-atomich arch/ia64/include/asm/spinlock.h
--- a/arch/ia64/include/asm/spinlock.h~atomic-use-linux-atomich
+++ a/arch/ia64/include/asm/spinlock.h
@@ -13,7 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/intrinsics.h>
 #include <asm/system.h>
 
diff -puN arch/ia64/kernel/smp.c~atomic-use-linux-atomich arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c~atomic-use-linux-atomich
+++ a/arch/ia64/kernel/smp.c
@@ -32,7 +32,7 @@
 #include <linux/bitops.h>
 #include <linux/kexec.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/current.h>
 #include <asm/delay.h>
 #include <asm/machvec.h>
diff -puN arch/ia64/kernel/smpboot.c~atomic-use-linux-atomich arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~atomic-use-linux-atomich
+++ a/arch/ia64/kernel/smpboot.c
@@ -40,7 +40,7 @@
 #include <linux/percpu.h>
 #include <linux/bitops.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cache.h>
 #include <asm/current.h>
 #include <asm/delay.h>
diff -puN arch/ia64/kernel/uncached.c~atomic-use-linux-atomich arch/ia64/kernel/uncached.c
--- a/arch/ia64/kernel/uncached.c~atomic-use-linux-atomich
+++ a/arch/ia64/kernel/uncached.c
@@ -25,7 +25,7 @@
 #include <asm/pal.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/tlbflush.h>
 #include <asm/sn/arch.h>
 
diff -puN arch/m32r/include/asm/atomic.h~atomic-use-linux-atomich arch/m32r/include/asm/atomic.h
--- a/arch/m32r/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/m32r/include/asm/atomic.h
@@ -262,7 +262,6 @@ static __inline__ int atomic_add_unless(
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
 {
diff -puN arch/m32r/include/asm/mmu_context.h~atomic-use-linux-atomich arch/m32r/include/asm/mmu_context.h
--- a/arch/m32r/include/asm/mmu_context.h~atomic-use-linux-atomich
+++ a/arch/m32r/include/asm/mmu_context.h
@@ -11,7 +11,7 @@
 
 #ifndef __ASSEMBLY__
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu.h>
 #include <asm/tlbflush.h>
diff -puN arch/m32r/include/asm/spinlock.h~atomic-use-linux-atomich arch/m32r/include/asm/spinlock.h
--- a/arch/m32r/include/asm/spinlock.h~atomic-use-linux-atomich
+++ a/arch/m32r/include/asm/spinlock.h
@@ -10,7 +10,7 @@
  */
 
 #include <linux/compiler.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 
 /*
diff -puN arch/m32r/kernel/smp.c~atomic-use-linux-atomich arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c~atomic-use-linux-atomich
+++ a/arch/m32r/kernel/smp.c
@@ -26,7 +26,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/pgalloc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
 #include <asm/m32r.h>
diff -puN arch/m32r/kernel/traps.c~atomic-use-linux-atomich arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~atomic-use-linux-atomich
+++ a/arch/m32r/kernel/traps.c
@@ -21,7 +21,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/smp.h>
 
diff -puN arch/m68k/include/asm/atomic.h~atomic-use-linux-atomich arch/m68k/include/asm/atomic.h
--- a/arch/m68k/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/m68k/include/asm/atomic.h
@@ -198,7 +198,6 @@ static __inline__ int atomic_add_unless(
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /* Atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()	barrier()
diff -puN arch/microblaze/include/asm/mmu_context_mm.h~atomic-use-linux-atomich arch/microblaze/include/asm/mmu_context_mm.h
--- a/arch/microblaze/include/asm/mmu_context_mm.h~atomic-use-linux-atomich
+++ a/arch/microblaze/include/asm/mmu_context_mm.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_MICROBLAZE_MMU_CONTEXT_H
 #define _ASM_MICROBLAZE_MMU_CONTEXT_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/bitops.h>
 #include <asm/mmu.h>
 #include <asm-generic/mm_hooks.h>
diff -puN arch/microblaze/include/asm/prom.h~atomic-use-linux-atomich arch/microblaze/include/asm/prom.h
--- a/arch/microblaze/include/asm/prom.h~atomic-use-linux-atomich
+++ a/arch/microblaze/include/asm/prom.h
@@ -21,7 +21,7 @@
 
 #include <linux/types.h>
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
diff -puN arch/mips/include/asm/atomic.h~atomic-use-linux-atomich arch/mips/include/asm/atomic.h
--- a/arch/mips/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/mips/include/asm/atomic.h
@@ -325,7 +325,6 @@ static __inline__ int atomic_add_unless(
 	}
 	return c != (u);
 }
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_dec_return(v) atomic_sub_return(1, (v))
 #define atomic_inc_return(v) atomic_add_return(1, (v))
diff -puN arch/mips/include/asm/hw_irq.h~atomic-use-linux-atomich arch/mips/include/asm/hw_irq.h
--- a/arch/mips/include/asm/hw_irq.h~atomic-use-linux-atomich
+++ a/arch/mips/include/asm/hw_irq.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_HW_IRQ_H
 #define __ASM_HW_IRQ_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern atomic_t irq_err_count;
 
diff -puN arch/mips/include/asm/local.h~atomic-use-linux-atomich arch/mips/include/asm/local.h
--- a/arch/mips/include/asm/local.h~atomic-use-linux-atomich
+++ a/arch/mips/include/asm/local.h
@@ -3,7 +3,7 @@
 
 #include <linux/percpu.h>
 #include <linux/bitops.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cmpxchg.h>
 #include <asm/war.h>
 
diff -puN arch/mips/include/asm/smp.h~atomic-use-linux-atomich arch/mips/include/asm/smp.h
--- a/arch/mips/include/asm/smp.h~atomic-use-linux-atomich
+++ a/arch/mips/include/asm/smp.h
@@ -17,7 +17,7 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp-ops.h>
 
 extern int smp_num_siblings;
diff -puN arch/mips/kernel/irq.c~atomic-use-linux-atomich arch/mips/kernel/irq.c
--- a/arch/mips/kernel/irq.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/irq.c
@@ -23,7 +23,7 @@
 #include <linux/kgdb.h>
 #include <linux/ftrace.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
diff -puN arch/mips/kernel/mips-mt.c~atomic-use-linux-atomich arch/mips/kernel/mips-mt.c
--- a/arch/mips/kernel/mips-mt.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/mips-mt.c
@@ -12,7 +12,7 @@
 
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
diff -puN arch/mips/kernel/rtlx.c~atomic-use-linux-atomich arch/mips/kernel/rtlx.c
--- a/arch/mips/kernel/rtlx.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/rtlx.c
@@ -36,7 +36,7 @@
 #include <asm/mipsmtregs.h>
 #include <asm/mips_mt.h>
 #include <asm/cacheflush.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/system.h>
diff -puN arch/mips/kernel/smp-cmp.c~atomic-use-linux-atomich arch/mips/kernel/smp-cmp.c
--- a/arch/mips/kernel/smp-cmp.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/smp-cmp.c
@@ -25,7 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/compiler.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
diff -puN arch/mips/kernel/smp-mt.c~atomic-use-linux-atomich arch/mips/kernel/smp-mt.c
--- a/arch/mips/kernel/smp-mt.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/smp-mt.c
@@ -24,7 +24,7 @@
 #include <linux/compiler.h>
 #include <linux/smp.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
diff -puN arch/mips/kernel/smp.c~atomic-use-linux-atomich arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/smp.c
@@ -34,7 +34,7 @@
 #include <linux/err.h>
 #include <linux/ftrace.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/r4k-timer.h>
diff -puN arch/mips/kernel/smtc-proc.c~atomic-use-linux-atomich arch/mips/kernel/smtc-proc.c
--- a/arch/mips/kernel/smtc-proc.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/smtc-proc.c
@@ -10,7 +10,7 @@
 
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
diff -puN arch/mips/kernel/smtc.c~atomic-use-linux-atomich arch/mips/kernel/smtc.c
--- a/arch/mips/kernel/smtc.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/smtc.c
@@ -30,7 +30,7 @@
 
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/hazards.h>
diff -puN arch/mips/kernel/sync-r4k.c~atomic-use-linux-atomich arch/mips/kernel/sync-r4k.c
--- a/arch/mips/kernel/sync-r4k.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/sync-r4k.c
@@ -16,7 +16,7 @@
 #include <linux/cpumask.h>
 
 #include <asm/r4k-timer.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/barrier.h>
 #include <asm/mipsregs.h>
 
diff -puN arch/mips/kernel/vpe.c~atomic-use-linux-atomich arch/mips/kernel/vpe.c
--- a/arch/mips/kernel/vpe.c~atomic-use-linux-atomich
+++ a/arch/mips/kernel/vpe.c
@@ -46,7 +46,7 @@
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
 #include <asm/cacheflush.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/mips_mt.h>
 #include <asm/processor.h>
diff -puN arch/mips/mipssim/sim_smtc.c~atomic-use-linux-atomich arch/mips/mipssim/sim_smtc.c
--- a/arch/mips/mipssim/sim_smtc.c~atomic-use-linux-atomich
+++ a/arch/mips/mipssim/sim_smtc.c
@@ -24,7 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/smp.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/smtc.h>
diff -puN arch/mips/sgi-ip27/ip27-nmi.c~atomic-use-linux-atomich arch/mips/sgi-ip27/ip27-nmi.c
--- a/arch/mips/sgi-ip27/ip27-nmi.c~atomic-use-linux-atomich
+++ a/arch/mips/sgi-ip27/ip27-nmi.c
@@ -3,7 +3,7 @@
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
 #include <linux/smp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/sn/types.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/nmi.h>
diff -puN arch/mn10300/include/asm/atomic.h~atomic-use-linux-atomich arch/mn10300/include/asm/atomic.h
--- a/arch/mn10300/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/mn10300/include/asm/atomic.h
@@ -269,7 +269,6 @@ static inline void atomic_dec(atomic_t *
 	c != (u);						\
 })
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /**
  * atomic_clear_mask - Atomically clear bits in memory
diff -puN arch/mn10300/include/asm/mmu_context.h~atomic-use-linux-atomich arch/mn10300/include/asm/mmu_context.h
--- a/arch/mn10300/include/asm/mmu_context.h~atomic-use-linux-atomich
+++ a/arch/mn10300/include/asm/mmu_context.h
@@ -22,7 +22,7 @@
 #ifndef _ASM_MMU_CONTEXT_H
 #define _ASM_MMU_CONTEXT_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm-generic/mm_hooks.h>
diff -puN arch/mn10300/include/asm/spinlock.h~atomic-use-linux-atomich arch/mn10300/include/asm/spinlock.h
--- a/arch/mn10300/include/asm/spinlock.h~atomic-use-linux-atomich
+++ a/arch/mn10300/include/asm/spinlock.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_SPINLOCK_H
 #define _ASM_SPINLOCK_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/rwlock.h>
 #include <asm/page.h>
 
diff -puN arch/mn10300/include/asm/system.h~atomic-use-linux-atomich arch/mn10300/include/asm/system.h
--- a/arch/mn10300/include/asm/system.h~atomic-use-linux-atomich
+++ a/arch/mn10300/include/asm/system.h
@@ -19,7 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #if !defined(CONFIG_LAZY_SAVE_FPU)
 struct fpu_state_struct;
diff -puN arch/mn10300/kernel/mn10300-watchdog.c~atomic-use-linux-atomich arch/mn10300/kernel/mn10300-watchdog.c
--- a/arch/mn10300/kernel/mn10300-watchdog.c~atomic-use-linux-atomich
+++ a/arch/mn10300/kernel/mn10300-watchdog.c
@@ -19,7 +19,7 @@
 #include <linux/nmi.h>
 #include <asm/processor.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/intctl-regs.h>
 #include <asm/rtc-regs.h>
 #include <asm/div64.h>
diff -puN arch/mn10300/kernel/traps.c~atomic-use-linux-atomich arch/mn10300/kernel/traps.c
--- a/arch/mn10300/kernel/traps.c~atomic-use-linux-atomich
+++ a/arch/mn10300/kernel/traps.c
@@ -30,7 +30,7 @@
 #include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
diff -puN arch/mn10300/mm/misalignment.c~atomic-use-linux-atomich arch/mn10300/mm/misalignment.c
--- a/arch/mn10300/mm/misalignment.c~atomic-use-linux-atomich
+++ a/arch/mn10300/mm/misalignment.c
@@ -26,7 +26,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/cpu-regs.h>
diff -puN arch/mn10300/proc-mn2ws0050/proc-init.c~atomic-use-linux-atomich arch/mn10300/proc-mn2ws0050/proc-init.c
--- a/arch/mn10300/proc-mn2ws0050/proc-init.c~atomic-use-linux-atomich
+++ a/arch/mn10300/proc-mn2ws0050/proc-init.c
@@ -18,7 +18,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/busctl-regs.h>
diff -puN arch/parisc/include/asm/atomic.h~atomic-use-linux-atomich arch/parisc/include/asm/atomic.h
--- a/arch/parisc/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/parisc/include/asm/atomic.h
@@ -220,7 +220,6 @@ static __inline__ int atomic_add_unless(
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_add(i,v)	((void)(__atomic_add_return( (i),(v))))
 #define atomic_sub(i,v)	((void)(__atomic_add_return(-(i),(v))))
diff -puN arch/parisc/include/asm/bitops.h~atomic-use-linux-atomich arch/parisc/include/asm/bitops.h
--- a/arch/parisc/include/asm/bitops.h~atomic-use-linux-atomich
+++ a/arch/parisc/include/asm/bitops.h
@@ -8,7 +8,7 @@
 #include <linux/compiler.h>
 #include <asm/types.h>		/* for BITS_PER_LONG/SHIFT_PER_LONG */
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * HP-PARISC specific bit operations
diff -puN arch/parisc/include/asm/mmu_context.h~atomic-use-linux-atomich arch/parisc/include/asm/mmu_context.h
--- a/arch/parisc/include/asm/mmu_context.h~atomic-use-linux-atomich
+++ a/arch/parisc/include/asm/mmu_context.h
@@ -3,7 +3,7 @@
 
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm-generic/mm_hooks.h>
diff -puN arch/parisc/kernel/parisc_ksyms.c~atomic-use-linux-atomich arch/parisc/kernel/parisc_ksyms.c
--- a/arch/parisc/kernel/parisc_ksyms.c~atomic-use-linux-atomich
+++ a/arch/parisc/kernel/parisc_ksyms.c
@@ -31,7 +31,7 @@
 #include <linux/string.h>
 EXPORT_SYMBOL(memset);
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
 EXPORT_SYMBOL(__xchg32);
 EXPORT_SYMBOL(__cmpxchg_u32);
diff -puN arch/parisc/kernel/smp.c~atomic-use-linux-atomich arch/parisc/kernel/smp.c
--- a/arch/parisc/kernel/smp.c~atomic-use-linux-atomich
+++ a/arch/parisc/kernel/smp.c
@@ -33,7 +33,7 @@
 #include <linux/ftrace.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/current.h>
 #include <asm/delay.h>
 #include <asm/tlbflush.h>
diff -puN arch/parisc/kernel/traps.c~atomic-use-linux-atomich arch/parisc/kernel/traps.c
--- a/arch/parisc/kernel/traps.c~atomic-use-linux-atomich
+++ a/arch/parisc/kernel/traps.c
@@ -33,7 +33,7 @@
 #include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/unaligned.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/pdc.h>
 #include <asm/pdc_chassis.h>
diff -puN arch/parisc/lib/bitops.c~atomic-use-linux-atomich arch/parisc/lib/bitops.c
--- a/arch/parisc/lib/bitops.c~atomic-use-linux-atomich
+++ a/arch/parisc/lib/bitops.c
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_SMP
 arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
diff -puN arch/powerpc/include/asm/atomic.h~atomic-use-linux-atomich arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/powerpc/include/asm/atomic.h
@@ -212,7 +212,6 @@ static __inline__ int atomic_add_unless(
 	return t != u;
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_sub_and_test(a, v)	(atomic_sub_return((a), (v)) == 0)
 #define atomic_dec_and_test(v)		(atomic_dec_return((v)) == 0)
diff -puN arch/powerpc/include/asm/emulated_ops.h~atomic-use-linux-atomich arch/powerpc/include/asm/emulated_ops.h
--- a/arch/powerpc/include/asm/emulated_ops.h~atomic-use-linux-atomich
+++ a/arch/powerpc/include/asm/emulated_ops.h
@@ -18,7 +18,7 @@
 #ifndef _ASM_POWERPC_EMULATED_OPS_H
 #define _ASM_POWERPC_EMULATED_OPS_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/perf_event.h>
 
 
diff -puN arch/powerpc/include/asm/irq.h~atomic-use-linux-atomich arch/powerpc/include/asm/irq.h
--- a/arch/powerpc/include/asm/irq.h~atomic-use-linux-atomich
+++ a/arch/powerpc/include/asm/irq.h
@@ -14,7 +14,7 @@
 #include <linux/radix-tree.h>
 
 #include <asm/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 
 /* Define a way to iterate across irqs. */
diff -puN arch/powerpc/include/asm/local.h~atomic-use-linux-atomich arch/powerpc/include/asm/local.h
--- a/arch/powerpc/include/asm/local.h~atomic-use-linux-atomich
+++ a/arch/powerpc/include/asm/local.h
@@ -2,7 +2,7 @@
 #define _ARCH_POWERPC_LOCAL_H
 
 #include <linux/percpu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 typedef struct
 {
diff -puN arch/powerpc/include/asm/prom.h~atomic-use-linux-atomich arch/powerpc/include/asm/prom.h
--- a/arch/powerpc/include/asm/prom.h~atomic-use-linux-atomich
+++ a/arch/powerpc/include/asm/prom.h
@@ -18,7 +18,7 @@
  */
 #include <linux/types.h>
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
diff -puN arch/powerpc/kernel/of_platform.c~atomic-use-linux-atomich arch/powerpc/kernel/of_platform.c
--- a/arch/powerpc/kernel/of_platform.c~atomic-use-linux-atomich
+++ a/arch/powerpc/kernel/of_platform.c
@@ -26,7 +26,7 @@
 #include <asm/topology.h>
 #include <asm/pci-bridge.h>
 #include <asm/ppc-pci.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_PPC_OF_PLATFORM_PCI
 
diff -puN arch/powerpc/kernel/ppc_ksyms.c~atomic-use-linux-atomich arch/powerpc/kernel/ppc_ksyms.c
--- a/arch/powerpc/kernel/ppc_ksyms.c~atomic-use-linux-atomich
+++ a/arch/powerpc/kernel/ppc_ksyms.c
@@ -18,7 +18,7 @@
 #include <asm/cacheflush.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/checksum.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
diff -puN arch/powerpc/kernel/rtas.c~atomic-use-linux-atomich arch/powerpc/kernel/rtas.c
--- a/arch/powerpc/kernel/rtas.c~atomic-use-linux-atomich
+++ a/arch/powerpc/kernel/rtas.c
@@ -38,7 +38,7 @@
 #include <asm/udbg.h>
 #include <asm/syscalls.h>
 #include <asm/smp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/mmu.h>
 #include <asm/topology.h>
diff -puN arch/powerpc/kernel/rtasd.c~atomic-use-linux-atomich arch/powerpc/kernel/rtasd.c
--- a/arch/powerpc/kernel/rtasd.c~atomic-use-linux-atomich
+++ a/arch/powerpc/kernel/rtasd.c
@@ -27,7 +27,7 @@
 #include <asm/rtas.h>
 #include <asm/prom.h>
 #include <asm/nvram.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/machdep.h>
 
 
diff -puN arch/powerpc/kernel/smp-tbsync.c~atomic-use-linux-atomich arch/powerpc/kernel/smp-tbsync.c
--- a/arch/powerpc/kernel/smp-tbsync.c~atomic-use-linux-atomich
+++ a/arch/powerpc/kernel/smp-tbsync.c
@@ -11,7 +11,7 @@
 #include <linux/unistd.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 #include <asm/time.h>
 
diff -puN arch/powerpc/kernel/smp.c~atomic-use-linux-atomich arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~atomic-use-linux-atomich
+++ a/arch/powerpc/kernel/smp.c
@@ -33,7 +33,7 @@
 #include <linux/topology.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff -puN arch/powerpc/platforms/83xx/km83xx.c~atomic-use-linux-atomich arch/powerpc/platforms/83xx/km83xx.c
--- a/arch/powerpc/platforms/83xx/km83xx.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/83xx/km83xx.c
@@ -28,7 +28,7 @@
 #include <linux/of_device.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/83xx/mpc832x_mds.c~atomic-use-linux-atomich arch/powerpc/platforms/83xx/mpc832x_mds.c
--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -27,7 +27,7 @@
 #include <linux/of_device.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/83xx/mpc834x_itx.c~atomic-use-linux-atomich arch/powerpc/platforms/83xx/mpc834x_itx.c
--- a/arch/powerpc/platforms/83xx/mpc834x_itx.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/83xx/mpc834x_itx.c
@@ -26,7 +26,7 @@
 #include <linux/of_platform.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/83xx/mpc834x_mds.c~atomic-use-linux-atomich arch/powerpc/platforms/83xx/mpc834x_mds.c
--- a/arch/powerpc/platforms/83xx/mpc834x_mds.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/83xx/mpc834x_mds.c
@@ -26,7 +26,7 @@
 #include <linux/of_platform.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/83xx/mpc836x_mds.c~atomic-use-linux-atomich arch/powerpc/platforms/83xx/mpc836x_mds.c
--- a/arch/powerpc/platforms/83xx/mpc836x_mds.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/83xx/mpc836x_mds.c
@@ -34,7 +34,7 @@
 #include <linux/of_device.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/83xx/sbc834x.c~atomic-use-linux-atomich arch/powerpc/platforms/83xx/sbc834x.c
--- a/arch/powerpc/platforms/83xx/sbc834x.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/83xx/sbc834x.c
@@ -28,7 +28,7 @@
 #include <linux/of_platform.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/85xx/mpc85xx_cds.c~atomic-use-linux-atomich arch/powerpc/platforms/85xx/mpc85xx_cds.c
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -31,7 +31,7 @@
 #include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/85xx/mpc85xx_mds.c~atomic-use-linux-atomich arch/powerpc/platforms/85xx/mpc85xx_mds.c
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -36,7 +36,7 @@
 #include <linux/memblock.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/85xx/sbc8548.c~atomic-use-linux-atomich arch/powerpc/platforms/85xx/sbc8548.c
--- a/arch/powerpc/platforms/85xx/sbc8548.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/85xx/sbc8548.c
@@ -34,7 +34,7 @@
 #include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/cell/cpufreq_spudemand.c~atomic-use-linux-atomich arch/powerpc/platforms/cell/cpufreq_spudemand.c
--- a/arch/powerpc/platforms/cell/cpufreq_spudemand.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/cell/cpufreq_spudemand.c
@@ -24,7 +24,7 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/machdep.h>
 #include <asm/spu.h>
 
diff -puN arch/powerpc/platforms/cell/smp.c~atomic-use-linux-atomich arch/powerpc/platforms/cell/smp.c
--- a/arch/powerpc/platforms/cell/smp.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/cell/smp.c
@@ -28,7 +28,7 @@
 #include <linux/cpu.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff -puN arch/powerpc/platforms/cell/spufs/context.c~atomic-use-linux-atomich arch/powerpc/platforms/cell/spufs/context.c
--- a/arch/powerpc/platforms/cell/spufs/context.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/cell/spufs/context.c
@@ -24,7 +24,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/spu.h>
 #include <asm/spu_csa.h>
 #include "spufs.h"
diff -puN arch/powerpc/platforms/chrp/smp.c~atomic-use-linux-atomich arch/powerpc/platforms/chrp/smp.c
--- a/arch/powerpc/platforms/chrp/smp.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/chrp/smp.c
@@ -18,7 +18,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff -puN arch/powerpc/platforms/iseries/smp.c~atomic-use-linux-atomich arch/powerpc/platforms/iseries/smp.c
--- a/arch/powerpc/platforms/iseries/smp.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/iseries/smp.c
@@ -29,7 +29,7 @@
 #include <linux/cpu.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff -puN arch/powerpc/platforms/powermac/backlight.c~atomic-use-linux-atomich arch/powerpc/platforms/powermac/backlight.c
--- a/arch/powerpc/platforms/powermac/backlight.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/powermac/backlight.c
@@ -12,7 +12,7 @@
 #include <linux/backlight.h>
 #include <linux/adb.h>
 #include <linux/pmu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/prom.h>
 #include <asm/backlight.h>
 
diff -puN arch/powerpc/platforms/powermac/smp.c~atomic-use-linux-atomich arch/powerpc/platforms/powermac/smp.c
--- a/arch/powerpc/platforms/powermac/smp.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/powermac/smp.c
@@ -35,7 +35,7 @@
 #include <linux/compiler.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/code-patching.h>
 #include <asm/irq.h>
 #include <asm/page.h>
diff -puN arch/powerpc/platforms/pseries/eeh.c~atomic-use-linux-atomich arch/powerpc/platforms/pseries/eeh.c
--- a/arch/powerpc/platforms/pseries/eeh.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/pseries/eeh.c
@@ -31,7 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/of.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/eeh.h>
 #include <asm/eeh_event.h>
 #include <asm/io.h>
diff -puN arch/powerpc/platforms/pseries/eeh_cache.c~atomic-use-linux-atomich arch/powerpc/platforms/pseries/eeh_cache.c
--- a/arch/powerpc/platforms/pseries/eeh_cache.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/pseries/eeh_cache.c
@@ -25,7 +25,7 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pci-bridge.h>
 #include <asm/ppc-pci.h>
 
diff -puN arch/powerpc/platforms/pseries/smp.c~atomic-use-linux-atomich arch/powerpc/platforms/pseries/smp.c
--- a/arch/powerpc/platforms/pseries/smp.c~atomic-use-linux-atomich
+++ a/arch/powerpc/platforms/pseries/smp.c
@@ -27,7 +27,7 @@
 #include <linux/cpu.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff -puN arch/powerpc/sysdev/fsl_soc.c~atomic-use-linux-atomich arch/powerpc/sysdev/fsl_soc.c
--- a/arch/powerpc/sysdev/fsl_soc.c~atomic-use-linux-atomich
+++ a/arch/powerpc/sysdev/fsl_soc.c
@@ -32,7 +32,7 @@
 #include <linux/fs_uart_pd.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/time.h>
diff -puN arch/powerpc/sysdev/tsi108_dev.c~atomic-use-linux-atomich arch/powerpc/sysdev/tsi108_dev.c
--- a/arch/powerpc/sysdev/tsi108_dev.c~atomic-use-linux-atomich
+++ a/arch/powerpc/sysdev/tsi108_dev.c
@@ -23,7 +23,7 @@
 #include <asm/tsi108.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/prom.h>
diff -puN arch/s390/include/asm/atomic.h~atomic-use-linux-atomich arch/s390/include/asm/atomic.h
--- a/arch/s390/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/s390/include/asm/atomic.h
@@ -108,7 +108,6 @@ static inline int atomic_add_unless(atom
 	return c != u;
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #undef __CS_LOOP
 
diff -puN arch/s390/kernel/dis.c~atomic-use-linux-atomich arch/s390/kernel/dis.c
--- a/arch/s390/kernel/dis.c~atomic-use-linux-atomich
+++ a/arch/s390/kernel/dis.c
@@ -27,7 +27,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mathemu.h>
 #include <asm/cpcmd.h>
 #include <asm/lowcore.h>
diff -puN arch/s390/kernel/traps.c~atomic-use-linux-atomich arch/s390/kernel/traps.c
--- a/arch/s390/kernel/traps.c~atomic-use-linux-atomich
+++ a/arch/s390/kernel/traps.c
@@ -36,7 +36,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mathemu.h>
 #include <asm/cpcmd.h>
 #include <asm/lowcore.h>
diff -puN arch/sh/include/asm/atomic.h~atomic-use-linux-atomich arch/sh/include/asm/atomic.h
--- a/arch/sh/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/sh/include/asm/atomic.h
@@ -30,7 +30,6 @@
 #define atomic_inc_and_test(v)		(atomic_inc_return(v) == 0)
 #define atomic_sub_and_test(i,v)	(atomic_sub_return((i), (v)) == 0)
 #define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
-#define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
 
 #define atomic_inc(v)			atomic_add(1, (v))
 #define atomic_dec(v)			atomic_sub(1, (v))
diff -puN arch/sh/include/asm/hw_irq.h~atomic-use-linux-atomich arch/sh/include/asm/hw_irq.h
--- a/arch/sh/include/asm/hw_irq.h~atomic-use-linux-atomich
+++ a/arch/sh/include/asm/hw_irq.h
@@ -3,7 +3,7 @@
 
 #include <linux/init.h>
 #include <linux/sh_intc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern atomic_t irq_err_count;
 
diff -puN arch/sh/include/asm/smp.h~atomic-use-linux-atomich arch/sh/include/asm/smp.h
--- a/arch/sh/include/asm/smp.h~atomic-use-linux-atomich
+++ a/arch/sh/include/asm/smp.h
@@ -8,7 +8,7 @@
 #ifdef CONFIG_SMP
 
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/current.h>
 #include <asm/percpu.h>
 
diff -puN arch/sh/kernel/idle.c~atomic-use-linux-atomich arch/sh/kernel/idle.c
--- a/arch/sh/kernel/idle.c~atomic-use-linux-atomich
+++ a/arch/sh/kernel/idle.c
@@ -18,7 +18,7 @@
 #include <linux/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/smp.h>
 
 void (*pm_idle)(void) = NULL;
diff -puN arch/sh/kernel/smp.c~atomic-use-linux-atomich arch/sh/kernel/smp.c
--- a/arch/sh/kernel/smp.c~atomic-use-linux-atomich
+++ a/arch/sh/kernel/smp.c
@@ -21,7 +21,7 @@
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/mmu_context.h>
diff -puN arch/sh/kernel/traps_64.c~atomic-use-linux-atomich arch/sh/kernel/traps_64.c
--- a/arch/sh/kernel/traps_64.c~atomic-use-linux-atomich
+++ a/arch/sh/kernel/traps_64.c
@@ -28,7 +28,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/fpu.h>
diff -puN arch/sh/kernel/unwinder.c~atomic-use-linux-atomich arch/sh/kernel/unwinder.c
--- a/arch/sh/kernel/unwinder.c~atomic-use-linux-atomich
+++ a/arch/sh/kernel/unwinder.c
@@ -13,7 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/module.h>
 #include <asm/unwinder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * This is the most basic stack unwinder an architecture can
diff -puN arch/sparc/include/asm/atomic_32.h~atomic-use-linux-atomich arch/sparc/include/asm/atomic_32.h
--- a/arch/sparc/include/asm/atomic_32.h~atomic-use-linux-atomich
+++ a/arch/sparc/include/asm/atomic_32.h
@@ -52,7 +52,6 @@ extern void atomic_set(atomic_t *, int);
 #define atomic_dec_and_test(v) (atomic_dec_return(v) == 0)
 #define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /* This is the old 24-bit implementation.  It's still used internally
  * by some sparc-specific code, notably the semaphore implementation.
diff -puN arch/sparc/include/asm/atomic_64.h~atomic-use-linux-atomich arch/sparc/include/asm/atomic_64.h
--- a/arch/sparc/include/asm/atomic_64.h~atomic-use-linux-atomich
+++ a/arch/sparc/include/asm/atomic_64.h
@@ -85,7 +85,6 @@ static inline int atomic_add_unless(atom
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic64_cmpxchg(v, o, n) \
 	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
diff -puN arch/sparc/include/asm/prom.h~atomic-use-linux-atomich arch/sparc/include/asm/prom.h
--- a/arch/sparc/include/asm/prom.h~atomic-use-linux-atomich
+++ a/arch/sparc/include/asm/prom.h
@@ -21,7 +21,7 @@
 #include <linux/of_pdt.h>
 #include <linux/proc_fs.h>
 #include <linux/mutex.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define OF_ROOT_NODE_ADDR_CELLS_DEFAULT	2
 #define OF_ROOT_NODE_SIZE_CELLS_DEFAULT	1
diff -puN arch/sparc/include/asm/smp_32.h~atomic-use-linux-atomich arch/sparc/include/asm/smp_32.h
--- a/arch/sparc/include/asm/smp_32.h~atomic-use-linux-atomich
+++ a/arch/sparc/include/asm/smp_32.h
@@ -22,7 +22,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/asi.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  *	Private routines/data
diff -puN arch/sparc/include/asm/smp_64.h~atomic-use-linux-atomich arch/sparc/include/asm/smp_64.h
--- a/arch/sparc/include/asm/smp_64.h~atomic-use-linux-atomich
+++ a/arch/sparc/include/asm/smp_64.h
@@ -27,7 +27,7 @@
  */
 
 #include <linux/bitops.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/percpu.h>
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
diff -puN arch/sparc/kernel/irq_64.c~atomic-use-linux-atomich arch/sparc/kernel/irq_64.c
--- a/arch/sparc/kernel/irq_64.c~atomic-use-linux-atomich
+++ a/arch/sparc/kernel/irq_64.c
@@ -26,7 +26,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/io.h>
diff -puN arch/sparc/kernel/leon_smp.c~atomic-use-linux-atomich arch/sparc/kernel/leon_smp.c
--- a/arch/sparc/kernel/leon_smp.c~atomic-use-linux-atomich
+++ a/arch/sparc/kernel/leon_smp.c
@@ -28,7 +28,7 @@
 #include <asm/tlbflush.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq_regs.h>
 #include <asm/traps.h>
 
diff -puN arch/sparc/kernel/perf_event.c~atomic-use-linux-atomich arch/sparc/kernel/perf_event.c
--- a/arch/sparc/kernel/perf_event.c~atomic-use-linux-atomich
+++ a/arch/sparc/kernel/perf_event.c
@@ -22,7 +22,7 @@
 #include <asm/stacktrace.h>
 #include <asm/cpudata.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/nmi.h>
 #include <asm/pcr.h>
 
diff -puN arch/sparc/kernel/smp_32.c~atomic-use-linux-atomich arch/sparc/kernel/smp_32.c
--- a/arch/sparc/kernel/smp_32.c~atomic-use-linux-atomich
+++ a/arch/sparc/kernel/smp_32.c
@@ -22,7 +22,7 @@
 #include <linux/delay.h>
 
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/irq.h>
 #include <asm/page.h>
diff -puN arch/sparc/kernel/smp_64.c~atomic-use-linux-atomich arch/sparc/kernel/smp_64.c
--- a/arch/sparc/kernel/smp_64.c~atomic-use-linux-atomich
+++ a/arch/sparc/kernel/smp_64.c
@@ -28,7 +28,7 @@
 
 #include <asm/head.h>
 #include <asm/ptrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/cpudata.h>
diff -puN arch/sparc/lib/atomic32.c~atomic-use-linux-atomich arch/sparc/lib/atomic32.c
--- a/arch/sparc/lib/atomic32.c~atomic-use-linux-atomich
+++ a/arch/sparc/lib/atomic32.c
@@ -7,7 +7,7 @@
  * Based on asm-parisc/atomic.h Copyright (C) 2000 Philipp Rumpf
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
 
diff -puN arch/tile/include/asm/atomic.h~atomic-use-linux-atomich arch/tile/include/asm/atomic.h
--- a/arch/tile/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/tile/include/asm/atomic.h
@@ -121,15 +121,6 @@ static inline int atomic_read(const atom
  */
 #define atomic_add_negative(i, v)	(atomic_add_return((i), (v)) < 0)
 
-/**
- * atomic_inc_not_zero - increment unless the number is zero
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1, so long as @v is non-zero.
- * Returns non-zero if @v was non-zero, and zero otherwise.
- */
-#define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
-
 /* Nonexistent functions intended to cause link errors. */
 extern unsigned long __xchg_called_with_bad_pointer(void);
 extern unsigned long __cmpxchg_called_with_bad_pointer(void);
diff -puN arch/tile/include/asm/atomic_32.h~atomic-use-linux-atomich arch/tile/include/asm/atomic_32.h
--- a/arch/tile/include/asm/atomic_32.h~atomic-use-linux-atomich
+++ a/arch/tile/include/asm/atomic_32.h
@@ -11,7 +11,7 @@
  *   NON INFRINGEMENT.  See the GNU General Public License for
  *   more details.
  *
- * Do not include directly; use <asm/atomic.h>.
+ * Do not include directly; use <linux/atomic.h>.
  */
 
 #ifndef _ASM_TILE_ATOMIC_32_H
@@ -21,7 +21,7 @@
 
 #ifndef __ASSEMBLY__
 
-/* Tile-specific routines to support <asm/atomic.h>. */
+/* Tile-specific routines to support <linux/atomic.h>. */
 int _atomic_xchg(atomic_t *v, int n);
 int _atomic_xchg_add(atomic_t *v, int i);
 int _atomic_xchg_add_unless(atomic_t *v, int a, int u);
diff -puN arch/tile/include/asm/atomic_64.h~atomic-use-linux-atomich arch/tile/include/asm/atomic_64.h
--- a/arch/tile/include/asm/atomic_64.h~atomic-use-linux-atomich
+++ a/arch/tile/include/asm/atomic_64.h
@@ -11,7 +11,7 @@
  *   NON INFRINGEMENT.  See the GNU General Public License for
  *   more details.
  *
- * Do not include directly; use <asm/atomic.h>.
+ * Do not include directly; use <linux/atomic.h>.
  */
 
 #ifndef _ASM_TILE_ATOMIC_64_H
diff -puN arch/tile/include/asm/bitops_32.h~atomic-use-linux-atomich arch/tile/include/asm/bitops_32.h
--- a/arch/tile/include/asm/bitops_32.h~atomic-use-linux-atomich
+++ a/arch/tile/include/asm/bitops_32.h
@@ -16,7 +16,7 @@
 #define _ASM_TILE_BITOPS_32_H
 
 #include <linux/compiler.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 /* Tile-specific routines to support <asm/bitops.h>. */
diff -puN arch/tile/include/asm/bitops_64.h~atomic-use-linux-atomich arch/tile/include/asm/bitops_64.h
--- a/arch/tile/include/asm/bitops_64.h~atomic-use-linux-atomich
+++ a/arch/tile/include/asm/bitops_64.h
@@ -16,7 +16,7 @@
 #define _ASM_TILE_BITOPS_64_H
 
 #include <linux/compiler.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 /* See <asm/bitops.h> for API comments. */
diff -puN arch/tile/include/asm/spinlock_32.h~atomic-use-linux-atomich arch/tile/include/asm/spinlock_32.h
--- a/arch/tile/include/asm/spinlock_32.h~atomic-use-linux-atomich
+++ a/arch/tile/include/asm/spinlock_32.h
@@ -17,7 +17,7 @@
 #ifndef _ASM_TILE_SPINLOCK_32_H
 #define _ASM_TILE_SPINLOCK_32_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 #include <asm/system.h>
 #include <linux/compiler.h>
diff -puN arch/tile/kernel/intvec_32.S~atomic-use-linux-atomich arch/tile/kernel/intvec_32.S
--- a/arch/tile/kernel/intvec_32.S~atomic-use-linux-atomich
+++ a/arch/tile/kernel/intvec_32.S
@@ -21,7 +21,7 @@
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 #include <asm/irqflags.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/asm-offsets.h>
 #include <hv/hypervisor.h>
 #include <arch/abi.h>
diff -puN arch/tile/lib/atomic_32.c~atomic-use-linux-atomich arch/tile/lib/atomic_32.c
--- a/arch/tile/lib/atomic_32.c~atomic-use-linux-atomich
+++ a/arch/tile/lib/atomic_32.c
@@ -17,7 +17,7 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/futex.h>
 #include <arch/chip.h>
 
diff -puN arch/tile/lib/atomic_asm_32.S~atomic-use-linux-atomich arch/tile/lib/atomic_asm_32.S
--- a/arch/tile/lib/atomic_asm_32.S~atomic-use-linux-atomich
+++ a/arch/tile/lib/atomic_asm_32.S
@@ -70,7 +70,7 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 
diff -puN arch/x86/ia32/sys_ia32.c~atomic-use-linux-atomich arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~atomic-use-linux-atomich
+++ a/arch/x86/ia32/sys_ia32.c
@@ -43,7 +43,7 @@
 #include <asm/mman.h>
 #include <asm/types.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/vgtod.h>
 #include <asm/sys_ia32.h>
 
diff -puN arch/x86/include/asm/apic.h~atomic-use-linux-atomich arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h~atomic-use-linux-atomich
+++ a/arch/x86/include/asm/apic.h
@@ -8,7 +8,7 @@
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
 #include <asm/apicdef.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
 #include <asm/system.h>
diff -puN arch/x86/include/asm/atomic.h~atomic-use-linux-atomich arch/x86/include/asm/atomic.h
--- a/arch/x86/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/x86/include/asm/atomic.h
@@ -244,7 +244,6 @@ static inline int atomic_add_unless(atom
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /*
  * atomic_dec_if_positive - decrement by 1 if old value positive
diff -puN arch/x86/include/asm/hw_irq.h~atomic-use-linux-atomich arch/x86/include/asm/hw_irq.h
--- a/arch/x86/include/asm/hw_irq.h~atomic-use-linux-atomich
+++ a/arch/x86/include/asm/hw_irq.h
@@ -21,7 +21,7 @@
 #include <linux/profile.h>
 #include <linux/smp.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/sections.h>
 
diff -puN arch/x86/include/asm/local.h~atomic-use-linux-atomich arch/x86/include/asm/local.h
--- a/arch/x86/include/asm/local.h~atomic-use-linux-atomich
+++ a/arch/x86/include/asm/local.h
@@ -4,7 +4,7 @@
 #include <linux/percpu.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/asm.h>
 
 typedef struct {
diff -puN arch/x86/include/asm/mce.h~atomic-use-linux-atomich arch/x86/include/asm/mce.h
--- a/arch/x86/include/asm/mce.h~atomic-use-linux-atomich
+++ a/arch/x86/include/asm/mce.h
@@ -119,7 +119,7 @@ extern struct atomic_notifier_head x86_m
 
 #include <linux/percpu.h>
 #include <linux/init.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern int mce_disabled;
 extern int mce_p5_enabled;
diff -puN arch/x86/include/asm/mmu_context.h~atomic-use-linux-atomich arch/x86/include/asm/mmu_context.h
--- a/arch/x86/include/asm/mmu_context.h~atomic-use-linux-atomich
+++ a/arch/x86/include/asm/mmu_context.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_MMU_CONTEXT_H
 
 #include <asm/desc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
diff -puN arch/x86/include/asm/prom.h~atomic-use-linux-atomich arch/x86/include/asm/prom.h
--- a/arch/x86/include/asm/prom.h~atomic-use-linux-atomich
+++ a/arch/x86/include/asm/prom.h
@@ -19,7 +19,7 @@
 #include <linux/pci.h>
 
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/setup.h>
 #include <asm/irq_controller.h>
 
diff -puN arch/x86/include/asm/spinlock.h~atomic-use-linux-atomich arch/x86/include/asm/spinlock.h
--- a/arch/x86/include/asm/spinlock.h~atomic-use-linux-atomich
+++ a/arch/x86/include/asm/spinlock.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_SPINLOCK_H
 #define _ASM_X86_SPINLOCK_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/rwlock.h>
 #include <asm/page.h>
 #include <asm/processor.h>
diff -puN arch/x86/include/asm/thread_info.h~atomic-use-linux-atomich arch/x86/include/asm/thread_info.h
--- a/arch/x86/include/asm/thread_info.h~atomic-use-linux-atomich
+++ a/arch/x86/include/asm/thread_info.h
@@ -21,7 +21,7 @@ struct task_struct;
 struct exec_domain;
 #include <asm/processor.h>
 #include <asm/ftrace.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
diff -puN arch/x86/kernel/amd_gart_64.c~atomic-use-linux-atomich arch/x86/kernel/amd_gart_64.c
--- a/arch/x86/kernel/amd_gart_64.c~atomic-use-linux-atomich
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -30,7 +30,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/io.h>
 #include <linux/gfp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
diff -puN arch/x86/kernel/apic/apic.c~atomic-use-linux-atomich arch/x86/kernel/apic/apic.c
--- a/arch/x86/kernel/apic/apic.c~atomic-use-linux-atomich
+++ a/arch/x86/kernel/apic/apic.c
@@ -38,7 +38,7 @@
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
 #include <asm/pgalloc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/mpspec.h>
 #include <asm/i8259.h>
 #include <asm/proto.h>
diff -puN arch/x86/kernel/apic/es7000_32.c~atomic-use-linux-atomich arch/x86/kernel/apic/es7000_32.c
--- a/arch/x86/kernel/apic/es7000_32.c~atomic-use-linux-atomich
+++ a/arch/x86/kernel/apic/es7000_32.c
@@ -48,7 +48,7 @@
 #include <linux/io.h>
 
 #include <asm/apicdef.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
diff -puN arch/x86/kernel/cpu/common.c~atomic-use-linux-atomich arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~atomic-use-linux-atomich
+++ a/arch/x86/kernel/cpu/common.c
@@ -21,7 +21,7 @@
 #include <linux/topology.h>
 #include <linux/cpumask.h>
 #include <asm/pgtable.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
 #include <asm/apic.h>
diff -puN arch/x86/kernel/i8259.c~atomic-use-linux-atomich arch/x86/kernel/i8259.c
--- a/arch/x86/kernel/i8259.c~atomic-use-linux-atomich
+++ a/arch/x86/kernel/i8259.c
@@ -14,7 +14,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
diff -puN arch/x86/kernel/irqinit.c~atomic-use-linux-atomich arch/x86/kernel/irqinit.c
--- a/arch/x86/kernel/irqinit.c~atomic-use-linux-atomich
+++ a/arch/x86/kernel/irqinit.c
@@ -15,7 +15,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
diff -puN arch/x86/kernel/traps.c~atomic-use-linux-atomich arch/x86/kernel/traps.c
--- a/arch/x86/kernel/traps.c~atomic-use-linux-atomich
+++ a/arch/x86/kernel/traps.c
@@ -49,7 +49,7 @@
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
 #include <asm/debugreg.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
diff -puN arch/x86/kvm/lapic.c~atomic-use-linux-atomich arch/x86/kvm/lapic.c
--- a/arch/x86/kvm/lapic.c~atomic-use-linux-atomich
+++ a/arch/x86/kvm/lapic.c
@@ -33,7 +33,7 @@
 #include <asm/page.h>
 #include <asm/current.h>
 #include <asm/apicdef.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "kvm_cache_regs.h"
 #include "irq.h"
 #include "trace.h"
diff -puN arch/x86/kvm/timer.c~atomic-use-linux-atomich arch/x86/kvm/timer.c
--- a/arch/x86/kvm/timer.c~atomic-use-linux-atomich
+++ a/arch/x86/kvm/timer.c
@@ -15,7 +15,7 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/hrtimer.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "kvm_timer.h"
 
 static int __kvm_timer_fn(struct kvm_vcpu *vcpu, struct kvm_timer *ktimer)
diff -puN arch/x86/lib/atomic64_32.c~atomic-use-linux-atomich arch/x86/lib/atomic64_32.c
--- a/arch/x86/lib/atomic64_32.c~atomic-use-linux-atomich
+++ a/arch/x86/lib/atomic64_32.c
@@ -4,7 +4,7 @@
 
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 long long atomic64_read_cx8(long long, const atomic64_t *v);
 EXPORT_SYMBOL(atomic64_read_cx8);
diff -puN arch/x86/mm/mmio-mod.c~atomic-use-linux-atomich arch/x86/mm/mmio-mod.c
--- a/arch/x86/mm/mmio-mod.c~atomic-use-linux-atomich
+++ a/arch/x86/mm/mmio-mod.c
@@ -34,7 +34,7 @@
 #include <asm/pgtable.h>
 #include <linux/mmiotrace.h>
 #include <asm/e820.h> /* for ISA_START_ADDRESS */
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
 
diff -puN arch/xtensa/include/asm/atomic.h~atomic-use-linux-atomich arch/xtensa/include/asm/atomic.h
--- a/arch/xtensa/include/asm/atomic.h~atomic-use-linux-atomich
+++ a/arch/xtensa/include/asm/atomic.h
@@ -248,7 +248,6 @@ static __inline__ int atomic_add_unless(
 	return c != (u);
 }
 
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
diff -puN arch/xtensa/kernel/process.c~atomic-use-linux-atomich arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c~atomic-use-linux-atomich
+++ a/arch/xtensa/kernel/process.c
@@ -40,7 +40,7 @@
 #include <asm/platform.h>
 #include <asm/mmu.h>
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/asm-offsets.h>
 #include <asm/regs.h>
 
diff -puN crypto/af_alg.c~atomic-use-linux-atomich crypto/af_alg.c
--- a/crypto/af_alg.c~atomic-use-linux-atomich
+++ a/crypto/af_alg.c
@@ -12,7 +12,7 @@
  *
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <crypto/if_alg.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
diff -puN crypto/proc.c~atomic-use-linux-atomich crypto/proc.c
--- a/crypto/proc.c~atomic-use-linux-atomich
+++ a/crypto/proc.c
@@ -13,7 +13,7 @@
  *
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/init.h>
 #include <linux/crypto.h>
 #include <linux/rwsem.h>
diff -puN crypto/rng.c~atomic-use-linux-atomich crypto/rng.c
--- a/crypto/rng.c~atomic-use-linux-atomich
+++ a/crypto/rng.c
@@ -12,7 +12,7 @@
  *
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <crypto/internal/rng.h>
 #include <linux/err.h>
 #include <linux/module.h>
diff -puN drivers/atm/ambassador.c~atomic-use-linux-atomich drivers/atm/ambassador.c
--- a/drivers/atm/ambassador.c~atomic-use-linux-atomich
+++ a/drivers/atm/ambassador.c
@@ -38,7 +38,7 @@
 #include <linux/ihex.h>
 #include <linux/slab.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
 
diff -puN drivers/atm/atmtcp.c~atomic-use-linux-atomich drivers/atm/atmtcp.c
--- a/drivers/atm/atmtcp.c~atomic-use-linux-atomich
+++ a/drivers/atm/atmtcp.c
@@ -11,7 +11,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 
 extern int atm_init_aal5(struct atm_vcc *vcc); /* "raw" AAL5 transport */
diff -puN drivers/atm/eni.c~atomic-use-linux-atomich drivers/atm/eni.c
--- a/drivers/atm/eni.c~atomic-use-linux-atomich
+++ a/drivers/atm/eni.c
@@ -21,7 +21,7 @@
 #include <linux/slab.h>
 #include <asm/system.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/string.h>
 #include <asm/byteorder.h>
diff -puN drivers/atm/eni.h~atomic-use-linux-atomich drivers/atm/eni.h
--- a/drivers/atm/eni.h~atomic-use-linux-atomich
+++ a/drivers/atm/eni.h
@@ -14,7 +14,7 @@
 #include <linux/time.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "midway.h"
 
diff -puN drivers/atm/firestream.c~atomic-use-linux-atomich drivers/atm/firestream.c
--- a/drivers/atm/firestream.c~atomic-use-linux-atomich
+++ a/drivers/atm/firestream.c
@@ -52,7 +52,7 @@
 #include <asm/system.h>
 #include <asm/string.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <linux/wait.h>
 
diff -puN drivers/atm/fore200e.c~atomic-use-linux-atomich drivers/atm/fore200e.c
--- a/drivers/atm/fore200e.c~atomic-use-linux-atomich
+++ a/drivers/atm/fore200e.c
@@ -44,7 +44,7 @@
 #include <asm/dma.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_SBUS
 #include <linux/of.h>
diff -puN drivers/atm/horizon.c~atomic-use-linux-atomich drivers/atm/horizon.c
--- a/drivers/atm/horizon.c~atomic-use-linux-atomich
+++ a/drivers/atm/horizon.c
@@ -45,7 +45,7 @@
 
 #include <asm/system.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/string.h>
 #include <asm/byteorder.h>
diff -puN drivers/atm/idt77252.c~atomic-use-linux-atomich drivers/atm/idt77252.c
--- a/drivers/atm/idt77252.c~atomic-use-linux-atomich
+++ a/drivers/atm/idt77252.c
@@ -46,7 +46,7 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #ifdef CONFIG_ATM_IDT77252_USE_SUNI
diff -puN drivers/atm/iphase.c~atomic-use-linux-atomich drivers/atm/iphase.c
--- a/drivers/atm/iphase.c~atomic-use-linux-atomich
+++ a/drivers/atm/iphase.c
@@ -58,7 +58,7 @@
 #include <linux/slab.h>
 #include <asm/system.h>  
 #include <asm/io.h>  
-#include <asm/atomic.h>  
+#include <linux/atomic.h>
 #include <asm/uaccess.h>  
 #include <asm/string.h>  
 #include <asm/byteorder.h>  
diff -puN drivers/atm/nicstar.c~atomic-use-linux-atomich drivers/atm/nicstar.c
--- a/drivers/atm/nicstar.c~atomic-use-linux-atomich
+++ a/drivers/atm/nicstar.c
@@ -51,7 +51,7 @@
 #include <linux/idr.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "nicstar.h"
 #ifdef CONFIG_ATM_NICSTAR_USE_SUNI
 #include "suni.h"
diff -puN drivers/atm/suni.c~atomic-use-linux-atomich drivers/atm/suni.c
--- a/drivers/atm/suni.c~atomic-use-linux-atomich
+++ a/drivers/atm/suni.c
@@ -25,7 +25,7 @@
 #include <asm/system.h>
 #include <asm/param.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "suni.h"
 
diff -puN drivers/atm/uPD98402.c~atomic-use-linux-atomich drivers/atm/uPD98402.c
--- a/drivers/atm/uPD98402.c~atomic-use-linux-atomich
+++ a/drivers/atm/uPD98402.c
@@ -11,7 +11,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "uPD98402.h"
 
diff -puN drivers/atm/zatm.c~atomic-use-linux-atomich drivers/atm/zatm.c
--- a/drivers/atm/zatm.c~atomic-use-linux-atomich
+++ a/drivers/atm/zatm.c
@@ -27,7 +27,7 @@
 #include <asm/system.h>
 #include <asm/string.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "uPD98401.h"
diff -puN drivers/base/memory.c~atomic-use-linux-atomich drivers/base/memory.c
--- a/drivers/base/memory.c~atomic-use-linux-atomich
+++ a/drivers/base/memory.c
@@ -24,7 +24,7 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 static DEFINE_MUTEX(mem_sysfs_mutex);
diff -puN drivers/base/power/sysfs.c~atomic-use-linux-atomich drivers/base/power/sysfs.c
--- a/drivers/base/power/sysfs.c~atomic-use-linux-atomich
+++ a/drivers/base/power/sysfs.c
@@ -5,7 +5,7 @@
 #include <linux/device.h>
 #include <linux/string.h>
 #include <linux/pm_runtime.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/jiffies.h>
 #include "power.h"
 
diff -puN drivers/block/cciss_scsi.c~atomic-use-linux-atomich drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~atomic-use-linux-atomich
+++ a/drivers/block/cciss_scsi.c
@@ -33,7 +33,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
diff -puN drivers/char/ipmi/ipmi_watchdog.c~atomic-use-linux-atomich drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~atomic-use-linux-atomich
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -52,7 +52,7 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_X86
 /*
diff -puN drivers/char/mspec.c~atomic-use-linux-atomich drivers/char/mspec.c
--- a/drivers/char/mspec.c~atomic-use-linux-atomich
+++ a/drivers/char/mspec.c
@@ -46,7 +46,7 @@
 #include <asm/page.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/tlbflush.h>
 #include <asm/uncached.h>
 #include <asm/sn/addrs.h>
diff -puN drivers/connector/cn_proc.c~atomic-use-linux-atomich drivers/connector/cn_proc.c
--- a/drivers/connector/cn_proc.c~atomic-use-linux-atomich
+++ a/drivers/connector/cn_proc.c
@@ -28,7 +28,7 @@
 #include <linux/init.h>
 #include <linux/connector.h>
 #include <linux/gfp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 
 #include <linux/cn_proc.h>
diff -puN drivers/edac/edac_stub.c~atomic-use-linux-atomich drivers/edac/edac_stub.c
--- a/drivers/edac/edac_stub.c~atomic-use-linux-atomich
+++ a/drivers/edac/edac_stub.c
@@ -14,7 +14,7 @@
  */
 #include <linux/module.h>
 #include <linux/edac.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/edac.h>
 
 int edac_op_state = EDAC_OPSTATE_INVAL;
diff -puN drivers/firewire/core-card.c~atomic-use-linux-atomich drivers/firewire/core-card.c
--- a/drivers/firewire/core-card.c~atomic-use-linux-atomich
+++ a/drivers/firewire/core-card.c
@@ -32,7 +32,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #include "core.h"
diff -puN drivers/firewire/core-device.c~atomic-use-linux-atomich drivers/firewire/core-device.c
--- a/drivers/firewire/core-device.c~atomic-use-linux-atomich
+++ a/drivers/firewire/core-device.c
@@ -38,7 +38,7 @@
 #include <linux/string.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 #include <asm/system.h>
 
diff -puN drivers/firewire/core-topology.c~atomic-use-linux-atomich drivers/firewire/core-topology.c
--- a/drivers/firewire/core-topology.c~atomic-use-linux-atomich
+++ a/drivers/firewire/core-topology.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 #include <asm/system.h>
 
diff -puN drivers/firewire/core.h~atomic-use-linux-atomich drivers/firewire/core.h
--- a/drivers/firewire/core.h~atomic-use-linux-atomich
+++ a/drivers/firewire/core.h
@@ -9,7 +9,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct device;
 struct fw_card;
diff -puN drivers/firewire/nosy.c~atomic-use-linux-atomich drivers/firewire/nosy.c
--- a/drivers/firewire/nosy.c~atomic-use-linux-atomich
+++ a/drivers/firewire/nosy.c
@@ -37,7 +37,7 @@
 #include <linux/uaccess.h>
 #include <linux/wait.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #include "nosy.h"
diff -puN drivers/gpu/drm/radeon/radeon.h~atomic-use-linux-atomich drivers/gpu/drm/radeon/radeon.h
--- a/drivers/gpu/drm/radeon/radeon.h~atomic-use-linux-atomich
+++ a/drivers/gpu/drm/radeon/radeon.h
@@ -60,7 +60,7 @@
  *                          are considered as fatal)
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <linux/kref.h>
diff -puN drivers/gpu/drm/radeon/radeon_fence.c~atomic-use-linux-atomich drivers/gpu/drm/radeon/radeon_fence.c
--- a/drivers/gpu/drm/radeon/radeon_fence.c~atomic-use-linux-atomich
+++ a/drivers/gpu/drm/radeon/radeon_fence.c
@@ -29,7 +29,7 @@
  *    Dave Airlie
  */
 #include <linux/seq_file.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <linux/kref.h>
diff -puN drivers/gpu/drm/ttm/ttm_bo.c~atomic-use-linux-atomich drivers/gpu/drm/ttm/ttm_bo.c
--- a/drivers/gpu/drm/ttm/ttm_bo.c~atomic-use-linux-atomich
+++ a/drivers/gpu/drm/ttm/ttm_bo.c
@@ -37,7 +37,7 @@
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define TTM_ASSERT_LOCKED(param)
 #define TTM_DEBUG(fmt, arg...)
diff -puN drivers/gpu/drm/ttm/ttm_lock.c~atomic-use-linux-atomich drivers/gpu/drm/ttm/ttm_lock.c
--- a/drivers/gpu/drm/ttm/ttm_lock.c~atomic-use-linux-atomich
+++ a/drivers/gpu/drm/ttm/ttm_lock.c
@@ -30,7 +30,7 @@
 
 #include "ttm/ttm_lock.h"
 #include "ttm/ttm_module.h"
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
diff -puN drivers/gpu/drm/ttm/ttm_object.c~atomic-use-linux-atomich drivers/gpu/drm/ttm/ttm_object.c
--- a/drivers/gpu/drm/ttm/ttm_object.c~atomic-use-linux-atomich
+++ a/drivers/gpu/drm/ttm/ttm_object.c
@@ -55,7 +55,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct ttm_object_file {
 	struct ttm_object_device *tdev;
diff -puN drivers/gpu/drm/ttm/ttm_page_alloc.c~atomic-use-linux-atomich drivers/gpu/drm/ttm/ttm_page_alloc.c
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c~atomic-use-linux-atomich
+++ a/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -40,7 +40,7 @@
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "ttm/ttm_bo_driver.h"
 #include "ttm/ttm_page_alloc.h"
diff -puN drivers/hwmon/sht15.c~atomic-use-linux-atomich drivers/hwmon/sht15.c
--- a/drivers/hwmon/sht15.c~atomic-use-linux-atomich
+++ a/drivers/hwmon/sht15.c
@@ -32,7 +32,7 @@
 #include <linux/sht15.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /* Commands */
 #define SHT15_MEASURE_TEMP		0x03
diff -puN drivers/infiniband/hw/cxgb4/mem.c~atomic-use-linux-atomich drivers/infiniband/hw/cxgb4/mem.c
--- a/drivers/infiniband/hw/cxgb4/mem.c~atomic-use-linux-atomich
+++ a/drivers/infiniband/hw/cxgb4/mem.c
@@ -31,7 +31,7 @@
  */
 
 #include <rdma/ib_umem.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "iw_cxgb4.h"
 
diff -puN drivers/infiniband/hw/ehca/ehca_tools.h~atomic-use-linux-atomich drivers/infiniband/hw/ehca/ehca_tools.h
--- a/drivers/infiniband/hw/ehca/ehca_tools.h~atomic-use-linux-atomich
+++ a/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -58,7 +58,7 @@
 #include <linux/cpu.h>
 #include <linux/device.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/abs_addr.h>
 #include <asm/ibmebus.h>
 #include <asm/io.h>
diff -puN drivers/infiniband/hw/nes/nes_cm.c~atomic-use-linux-atomich drivers/infiniband/hw/nes/nes_cm.c
--- a/drivers/infiniband/hw/nes/nes_cm.c~atomic-use-linux-atomich
+++ a/drivers/infiniband/hw/nes/nes_cm.c
@@ -34,7 +34,7 @@
 
 #define TCPOPT_TIMESTAMP 8
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
diff -puN drivers/infiniband/ulp/ipoib/ipoib.h~atomic-use-linux-atomich drivers/infiniband/ulp/ipoib/ipoib.h
--- a/drivers/infiniband/ulp/ipoib/ipoib.h~atomic-use-linux-atomich
+++ a/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -45,7 +45,7 @@
 
 #include <net/neighbour.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_pack.h>
diff -puN drivers/infiniband/ulp/srp/ib_srp.c~atomic-use-linux-atomich drivers/infiniband/ulp/srp/ib_srp.c
--- a/drivers/infiniband/ulp/srp/ib_srp.c~atomic-use-linux-atomich
+++ a/drivers/infiniband/ulp/srp/ib_srp.c
@@ -39,7 +39,7 @@
 #include <linux/random.h>
 #include <linux/jiffies.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
diff -puN drivers/isdn/gigaset/gigaset.h~atomic-use-linux-atomich drivers/isdn/gigaset/gigaset.h
--- a/drivers/isdn/gigaset/gigaset.h~atomic-use-linux-atomich
+++ a/drivers/isdn/gigaset/gigaset.h
@@ -34,7 +34,7 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/list.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define GIG_VERSION {0, 5, 0, 0}
 #define GIG_COMPAT  {0, 4, 0, 0}
diff -puN drivers/md/dm-crypt.c~atomic-use-linux-atomich drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~atomic-use-linux-atomich
+++ a/drivers/md/dm-crypt.c
@@ -19,7 +19,7 @@
 #include <linux/workqueue.h>
 #include <linux/backing-dev.h>
 #include <linux/percpu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/scatterlist.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
diff -puN drivers/md/dm-kcopyd.c~atomic-use-linux-atomich drivers/md/dm-kcopyd.c
--- a/drivers/md/dm-kcopyd.c~atomic-use-linux-atomich
+++ a/drivers/md/dm-kcopyd.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/blkdev.h>
 #include <linux/fs.h>
 #include <linux/init.h>
diff -puN drivers/md/dm-mpath.c~atomic-use-linux-atomich drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~atomic-use-linux-atomich
+++ a/drivers/md/dm-mpath.c
@@ -19,7 +19,7 @@
 #include <linux/time.h>
 #include <linux/workqueue.h>
 #include <scsi/scsi_dh.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define DM_MSG_PREFIX "multipath"
 #define MESG_STR(x) x, sizeof(x)
diff -puN drivers/md/dm-queue-length.c~atomic-use-linux-atomich drivers/md/dm-queue-length.c
--- a/drivers/md/dm-queue-length.c~atomic-use-linux-atomich
+++ a/drivers/md/dm-queue-length.c
@@ -20,7 +20,7 @@
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define DM_MSG_PREFIX	"multipath queue-length"
 #define QL_MIN_IO	128
diff -puN drivers/md/dm-table.c~atomic-use-linux-atomich drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~atomic-use-linux-atomich
+++ a/drivers/md/dm-table.c
@@ -17,7 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define DM_MSG_PREFIX "table"
 
diff -puN drivers/media/video/hdpvr/hdpvr-core.c~atomic-use-linux-atomich drivers/media/video/hdpvr/hdpvr-core.c
--- a/drivers/media/video/hdpvr/hdpvr-core.c~atomic-use-linux-atomich
+++ a/drivers/media/video/hdpvr/hdpvr-core.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
 #include <linux/i2c.h>
diff -puN drivers/media/video/tlg2300/pd-dvb.c~atomic-use-linux-atomich drivers/media/video/tlg2300/pd-dvb.c
--- a/drivers/media/video/tlg2300/pd-dvb.c~atomic-use-linux-atomich
+++ a/drivers/media/video/tlg2300/pd-dvb.c
@@ -7,7 +7,7 @@
 
 #include "vendorcmds.h"
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 static void dvb_urb_cleanup(struct pd_dvb_adapter *pd_dvb);
 
diff -puN drivers/media/video/uvc/uvc_ctrl.c~atomic-use-linux-atomich drivers/media/video/uvc/uvc_ctrl.c
--- a/drivers/media/video/uvc/uvc_ctrl.c~atomic-use-linux-atomich
+++ a/drivers/media/video/uvc/uvc_ctrl.c
@@ -20,7 +20,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "uvcvideo.h"
 
diff -puN drivers/media/video/uvc/uvc_driver.c~atomic-use-linux-atomich drivers/media/video/uvc/uvc_driver.c
--- a/drivers/media/video/uvc/uvc_driver.c~atomic-use-linux-atomich
+++ a/drivers/media/video/uvc/uvc_driver.c
@@ -31,7 +31,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 
 #include <media/v4l2-common.h>
diff -puN drivers/media/video/uvc/uvc_queue.c~atomic-use-linux-atomich drivers/media/video/uvc/uvc_queue.c
--- a/drivers/media/video/uvc/uvc_queue.c~atomic-use-linux-atomich
+++ a/drivers/media/video/uvc/uvc_queue.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "uvcvideo.h"
 
diff -puN drivers/media/video/uvc/uvc_v4l2.c~atomic-use-linux-atomich drivers/media/video/uvc/uvc_v4l2.c
--- a/drivers/media/video/uvc/uvc_v4l2.c~atomic-use-linux-atomich
+++ a/drivers/media/video/uvc/uvc_v4l2.c
@@ -21,7 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
diff -puN drivers/media/video/uvc/uvc_video.c~atomic-use-linux-atomich drivers/media/video/uvc/uvc_video.c
--- a/drivers/media/video/uvc/uvc_video.c~atomic-use-linux-atomich
+++ a/drivers/media/video/uvc/uvc_video.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 
 #include <media/v4l2-common.h>
diff -puN drivers/message/i2o/i2o_scsi.c~atomic-use-linux-atomich drivers/message/i2o/i2o_scsi.c
--- a/drivers/message/i2o/i2o_scsi.c~atomic-use-linux-atomich
+++ a/drivers/message/i2o/i2o_scsi.c
@@ -59,7 +59,7 @@
 #include <asm/dma.h>
 #include <asm/system.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
diff -puN drivers/misc/phantom.c~atomic-use-linux-atomich drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~atomic-use-linux-atomich
+++ a/drivers/misc/phantom.c
@@ -26,7 +26,7 @@
 #include <linux/sched.h>
 #include <linux/mutex.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 
 #define PHANTOM_VERSION		"n0.9.8"
diff -puN drivers/net/atlx/atl1.c~atomic-use-linux-atomich drivers/net/atlx/atl1.c
--- a/drivers/net/atlx/atl1.c~atomic-use-linux-atomich
+++ a/drivers/net/atlx/atl1.c
@@ -44,7 +44,7 @@
  * SMP torture testing
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #include <linux/compiler.h>
diff -puN drivers/net/atlx/atl2.c~atomic-use-linux-atomich drivers/net/atlx/atl2.c
--- a/drivers/net/atlx/atl2.c~atomic-use-linux-atomich
+++ a/drivers/net/atlx/atl2.c
@@ -20,7 +20,7 @@
  * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/crc32.h>
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
diff -puN drivers/net/atlx/atl2.h~atomic-use-linux-atomich drivers/net/atlx/atl2.h
--- a/drivers/net/atlx/atl2.h~atomic-use-linux-atomich
+++ a/drivers/net/atlx/atl2.h
@@ -25,7 +25,7 @@
 #ifndef _ATL2_H_
 #define _ATL2_H_
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/netdevice.h>
 
 #ifndef _ATL2_HW_H_
diff -puN drivers/net/cassini.c~atomic-use-linux-atomich drivers/net/cassini.c
--- a/drivers/net/cassini.c~atomic-use-linux-atomich
+++ a/drivers/net/cassini.c
@@ -98,7 +98,7 @@
 
 #include <net/checksum.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
diff -puN drivers/net/cpmac.c~atomic-use-linux-atomich drivers/net/cpmac.c
--- a/drivers/net/cpmac.c~atomic-use-linux-atomich
+++ a/drivers/net/cpmac.c
@@ -40,7 +40,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
 #include <linux/gpio.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 MODULE_AUTHOR("Eugene Konev <ejka@imfi.kspu.ru>");
 MODULE_DESCRIPTION("TI AR7 ethernet driver (CPMAC)");
diff -puN drivers/net/cxgb3/cxgb3_offload.c~atomic-use-linux-atomich drivers/net/cxgb3/cxgb3_offload.c
--- a/drivers/net/cxgb3/cxgb3_offload.c~atomic-use-linux-atomich
+++ a/drivers/net/cxgb3/cxgb3_offload.c
@@ -34,7 +34,7 @@
 #include <linux/slab.h>
 #include <net/neighbour.h>
 #include <linux/notifier.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/proc_fs.h>
 #include <linux/if_vlan.h>
 #include <net/netevent.h>
diff -puN drivers/net/cxgb3/l2t.h~atomic-use-linux-atomich drivers/net/cxgb3/l2t.h
--- a/drivers/net/cxgb3/l2t.h~atomic-use-linux-atomich
+++ a/drivers/net/cxgb3/l2t.h
@@ -34,7 +34,7 @@
 
 #include <linux/spinlock.h>
 #include "t3cdev.h"
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 enum {
 	L2T_STATE_VALID,	/* entry is up to date */
diff -puN drivers/net/cxgb3/t3cdev.h~atomic-use-linux-atomich drivers/net/cxgb3/t3cdev.h
--- a/drivers/net/cxgb3/t3cdev.h~atomic-use-linux-atomich
+++ a/drivers/net/cxgb3/t3cdev.h
@@ -33,7 +33,7 @@
 #define _T3CDEV_H_
 
 #include <linux/list.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/netdevice.h>
 #include <linux/proc_fs.h>
 #include <linux/skbuff.h>
diff -puN drivers/net/cxgb4/cxgb4_uld.h~atomic-use-linux-atomich drivers/net/cxgb4/cxgb4_uld.h
--- a/drivers/net/cxgb4/cxgb4_uld.h~atomic-use-linux-atomich
+++ a/drivers/net/cxgb4/cxgb4_uld.h
@@ -38,7 +38,7 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /* CPL message priority levels */
 enum {
diff -puN drivers/net/cxgb4/l2t.h~atomic-use-linux-atomich drivers/net/cxgb4/l2t.h
--- a/drivers/net/cxgb4/l2t.h~atomic-use-linux-atomich
+++ a/drivers/net/cxgb4/l2t.h
@@ -37,7 +37,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/if_ether.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct adapter;
 struct l2t_data;
diff -puN drivers/net/hamradio/6pack.c~atomic-use-linux-atomich drivers/net/hamradio/6pack.c
--- a/drivers/net/hamradio/6pack.c~atomic-use-linux-atomich
+++ a/drivers/net/hamradio/6pack.c
@@ -36,7 +36,7 @@
 #include <linux/tcp.h>
 #include <linux/semaphore.h>
 #include <linux/compat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define SIXPACK_VERSION    "Revision: 0.3.0"
 
diff -puN drivers/net/hamradio/dmascc.c~atomic-use-linux-atomich drivers/net/hamradio/dmascc.c
--- a/drivers/net/hamradio/dmascc.c~atomic-use-linux-atomich
+++ a/drivers/net/hamradio/dmascc.c
@@ -36,7 +36,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/sockios.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff -puN drivers/net/ibmveth.c~atomic-use-linux-atomich drivers/net/ibmveth.c
--- a/drivers/net/ibmveth.c~atomic-use-linux-atomich
+++ a/drivers/net/ibmveth.c
@@ -43,7 +43,7 @@
 #include <linux/ipv6.h>
 #include <linux/slab.h>
 #include <asm/hvcall.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/vio.h>
 #include <asm/iommu.h>
 #include <asm/firmware.h>
diff -puN drivers/net/phy/phy.c~atomic-use-linux-atomich drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~atomic-use-linux-atomich
+++ a/drivers/net/phy/phy.c
@@ -33,7 +33,7 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
diff -puN drivers/net/ppp_generic.c~atomic-use-linux-atomich drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~atomic-use-linux-atomich
+++ a/drivers/net/ppp_generic.c
@@ -48,7 +48,7 @@
 #include <linux/slab.h>
 #include <asm/unaligned.h>
 #include <net/slhc_vj.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
diff -puN drivers/net/wimax/i2400m/i2400m.h~atomic-use-linux-atomich drivers/net/wimax/i2400m/i2400m.h
--- a/drivers/net/wimax/i2400m/i2400m.h~atomic-use-linux-atomich
+++ a/drivers/net/wimax/i2400m/i2400m.h
@@ -155,7 +155,7 @@
 #include <linux/netdevice.h>
 #include <linux/completion.h>
 #include <linux/rwsem.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <net/wimax.h>
 #include <linux/wimax/i2400m.h>
 #include <asm/byteorder.h>
diff -puN drivers/net/wireless/b43legacy/b43legacy.h~atomic-use-linux-atomich drivers/net/wireless/b43legacy/b43legacy.h
--- a/drivers/net/wireless/b43legacy/b43legacy.h~atomic-use-linux-atomich
+++ a/drivers/net/wireless/b43legacy/b43legacy.h
@@ -8,7 +8,7 @@
 #include <linux/stringify.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/io.h>
 
 #include <linux/ssb/ssb.h>
diff -puN drivers/net/wireless/b43legacy/dma.h~atomic-use-linux-atomich drivers/net/wireless/b43legacy/dma.h
--- a/drivers/net/wireless/b43legacy/dma.h~atomic-use-linux-atomich
+++ a/drivers/net/wireless/b43legacy/dma.h
@@ -5,7 +5,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/linkage.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "b43legacy.h"
 
diff -puN drivers/oprofile/oprofile_stats.h~atomic-use-linux-atomich drivers/oprofile/oprofile_stats.h
--- a/drivers/oprofile/oprofile_stats.h~atomic-use-linux-atomich
+++ a/drivers/oprofile/oprofile_stats.h
@@ -10,7 +10,7 @@
 #ifndef OPROFILE_STATS_H
 #define OPROFILE_STATS_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct oprofile_stat_struct {
 	atomic_t sample_lost_no_mm;
diff -puN drivers/pci/hotplug/cpci_hotplug_core.c~atomic-use-linux-atomich drivers/pci/hotplug/cpci_hotplug_core.c
--- a/drivers/pci/hotplug/cpci_hotplug_core.c~atomic-use-linux-atomich
+++ a/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -32,7 +32,7 @@
 #include <linux/pci_hotplug.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include "cpci_hotplug.h"
diff -puN drivers/pci/xen-pcifront.c~atomic-use-linux-atomich drivers/pci/xen-pcifront.c
--- a/drivers/pci/xen-pcifront.c~atomic-use-linux-atomich
+++ a/drivers/pci/xen-pcifront.c
@@ -16,7 +16,7 @@
 #include <xen/interface/io/pciif.h>
 #include <asm/xen/pci.h>
 #include <linux/interrupt.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
 #include <linux/time.h>
diff -puN drivers/s390/block/dasd_eer.c~atomic-use-linux-atomich drivers/s390/block/dasd_eer.c
--- a/drivers/s390/block/dasd_eer.c~atomic-use-linux-atomich
+++ a/drivers/s390/block/dasd_eer.c
@@ -21,7 +21,7 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/ebcdic.h>
 
 #include "dasd_int.h"
diff -puN drivers/s390/char/sclp_quiesce.c~atomic-use-linux-atomich drivers/s390/char/sclp_quiesce.c
--- a/drivers/s390/char/sclp_quiesce.c~atomic-use-linux-atomich
+++ a/drivers/s390/char/sclp_quiesce.c
@@ -13,7 +13,7 @@
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/reboot.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/sigp.h>
 #include <asm/smp.h>
diff -puN drivers/s390/char/vmlogrdr.c~atomic-use-linux-atomich drivers/s390/char/vmlogrdr.c
--- a/drivers/s390/char/vmlogrdr.c~atomic-use-linux-atomich
+++ a/drivers/s390/char/vmlogrdr.c
@@ -21,7 +21,7 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/cpcmd.h>
 #include <asm/debug.h>
diff -puN drivers/s390/cio/device.h~atomic-use-linux-atomich drivers/s390/cio/device.h
--- a/drivers/s390/cio/device.h~atomic-use-linux-atomich
+++ a/drivers/s390/cio/device.h
@@ -2,7 +2,7 @@
 #define S390_DEVICE_H
 
 #include <asm/ccwdev.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/wait.h>
 #include <linux/notifier.h>
 #include "io_sch.h"
diff -puN drivers/s390/cio/qdio_main.c~atomic-use-linux-atomich drivers/s390/cio/qdio_main.c
--- a/drivers/s390/cio/qdio_main.c~atomic-use-linux-atomich
+++ a/drivers/s390/cio/qdio_main.c
@@ -15,7 +15,7 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 #include <linux/kernel_stat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/debug.h>
 #include <asm/qdio.h>
 
diff -puN drivers/s390/cio/qdio_thinint.c~atomic-use-linux-atomich drivers/s390/cio/qdio_thinint.c
--- a/drivers/s390/cio/qdio_thinint.c~atomic-use-linux-atomich
+++ a/drivers/s390/cio/qdio_thinint.c
@@ -9,7 +9,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/kernel_stat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/debug.h>
 #include <asm/qdio.h>
 #include <asm/airq.h>
diff -puN drivers/s390/crypto/ap_bus.c~atomic-use-linux-atomich drivers/s390/crypto/ap_bus.c
--- a/drivers/s390/crypto/ap_bus.c~atomic-use-linux-atomich
+++ a/drivers/s390/crypto/ap_bus.c
@@ -40,7 +40,7 @@
 #include <linux/mutex.h>
 #include <asm/reset.h>
 #include <asm/airq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 #include <asm/isc.h>
 #include <linux/hrtimer.h>
diff -puN drivers/s390/crypto/zcrypt_api.c~atomic-use-linux-atomich drivers/s390/crypto/zcrypt_api.c
--- a/drivers/s390/crypto/zcrypt_api.c~atomic-use-linux-atomich
+++ a/drivers/s390/crypto/zcrypt_api.c
@@ -36,7 +36,7 @@
 #include <linux/seq_file.h>
 #include <linux/compat.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <linux/hw_random.h>
 
diff -puN drivers/s390/crypto/zcrypt_cex2a.c~atomic-use-linux-atomich drivers/s390/crypto/zcrypt_cex2a.c
--- a/drivers/s390/crypto/zcrypt_cex2a.c~atomic-use-linux-atomich
+++ a/drivers/s390/crypto/zcrypt_cex2a.c
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff -puN drivers/s390/crypto/zcrypt_mono.c~atomic-use-linux-atomich drivers/s390/crypto/zcrypt_mono.c
--- a/drivers/s390/crypto/zcrypt_mono.c~atomic-use-linux-atomich
+++ a/drivers/s390/crypto/zcrypt_mono.c
@@ -32,7 +32,7 @@
 #include <linux/fs.h>
 #include <linux/proc_fs.h>
 #include <linux/compat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff -puN drivers/s390/crypto/zcrypt_pcica.c~atomic-use-linux-atomich drivers/s390/crypto/zcrypt_pcica.c
--- a/drivers/s390/crypto/zcrypt_pcica.c~atomic-use-linux-atomich
+++ a/drivers/s390/crypto/zcrypt_pcica.c
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff -puN drivers/s390/crypto/zcrypt_pcicc.c~atomic-use-linux-atomich drivers/s390/crypto/zcrypt_pcicc.c
--- a/drivers/s390/crypto/zcrypt_pcicc.c~atomic-use-linux-atomich
+++ a/drivers/s390/crypto/zcrypt_pcicc.c
@@ -30,7 +30,7 @@
 #include <linux/init.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff -puN drivers/s390/crypto/zcrypt_pcixcc.c~atomic-use-linux-atomich drivers/s390/crypto/zcrypt_pcixcc.c
--- a/drivers/s390/crypto/zcrypt_pcixcc.c~atomic-use-linux-atomich
+++ a/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -31,7 +31,7 @@
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 #include "ap_bus.h"
diff -puN drivers/s390/net/fsm.h~atomic-use-linux-atomich drivers/s390/net/fsm.h
--- a/drivers/s390/net/fsm.h~atomic-use-linux-atomich
+++ a/drivers/s390/net/fsm.h
@@ -8,7 +8,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /**
  * Define this to get debugging messages.
diff -puN drivers/s390/scsi/zfcp_scsi.c~atomic-use-linux-atomich drivers/s390/scsi/zfcp_scsi.c
--- a/drivers/s390/scsi/zfcp_scsi.c~atomic-use-linux-atomich
+++ a/drivers/s390/scsi/zfcp_scsi.c
@@ -13,7 +13,7 @@
 #include <linux/slab.h>
 #include <scsi/fc/fc_fcp.h>
 #include <scsi/scsi_eh.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "zfcp_ext.h"
 #include "zfcp_dbf.h"
 #include "zfcp_fc.h"
diff -puN drivers/sbus/char/display7seg.c~atomic-use-linux-atomich drivers/sbus/char/display7seg.c
--- a/drivers/sbus/char/display7seg.c~atomic-use-linux-atomich
+++ a/drivers/sbus/char/display7seg.c
@@ -16,7 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>		/* put_/get_user			*/
 #include <asm/io.h>
 
diff -puN drivers/scsi/dpt/dpti_i2o.h~atomic-use-linux-atomich drivers/scsi/dpt/dpti_i2o.h
--- a/drivers/scsi/dpt/dpti_i2o.h~atomic-use-linux-atomich
+++ a/drivers/scsi/dpt/dpti_i2o.h
@@ -22,7 +22,7 @@
 #include <linux/i2o-dev.h>
 
 #include <linux/notifier.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 
 /*
diff -puN drivers/scsi/hpsa.c~atomic-use-linux-atomich drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~atomic-use-linux-atomich
+++ a/drivers/scsi/hpsa.c
@@ -46,7 +46,7 @@
 #include <linux/cciss_ioctl.h>
 #include <linux/string.h>
 #include <linux/bitmap.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/kthread.h>
 #include "hpsa_cmd.h"
 #include "hpsa.h"
diff -puN drivers/scsi/pm8001/pm8001_sas.h~atomic-use-linux-atomich drivers/scsi/pm8001/pm8001_sas.h
--- a/drivers/scsi/pm8001/pm8001_sas.h~atomic-use-linux-atomich
+++ a/drivers/scsi/pm8001/pm8001_sas.h
@@ -54,7 +54,7 @@
 #include <scsi/libsas.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "pm8001_defs.h"
 
 #define DRV_NAME		"pm8001"
diff -puN drivers/staging/octeon/ethernet-rx.c~atomic-use-linux-atomich drivers/staging/octeon/ethernet-rx.c
--- a/drivers/staging/octeon/ethernet-rx.c~atomic-use-linux-atomich
+++ a/drivers/staging/octeon/ethernet-rx.c
@@ -41,7 +41,7 @@
 #include <net/xfrm.h>
 #endif /* CONFIG_XFRM */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/octeon/octeon.h>
 
diff -puN drivers/staging/octeon/ethernet-tx.c~atomic-use-linux-atomich drivers/staging/octeon/ethernet-tx.c
--- a/drivers/staging/octeon/ethernet-tx.c~atomic-use-linux-atomich
+++ a/drivers/staging/octeon/ethernet-tx.c
@@ -37,7 +37,7 @@
 #include <net/xfrm.h>
 #endif /* CONFIG_XFRM */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <asm/octeon/octeon.h>
 
diff -puN drivers/staging/rtl8712/osdep_service.h~atomic-use-linux-atomich drivers/staging/rtl8712/osdep_service.h
--- a/drivers/staging/rtl8712/osdep_service.h~atomic-use-linux-atomich
+++ a/drivers/staging/rtl8712/osdep_service.h
@@ -30,7 +30,7 @@
 #include <linux/circ_buf.h>
 #include <linux/uaccess.h>
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/wireless.h>
 #include <linux/rtnetlink.h>
 #include "ethernet.h"
diff -puN drivers/staging/solo6x10/solo6x10.h~atomic-use-linux-atomich drivers/staging/solo6x10/solo6x10.h
--- a/drivers/staging/solo6x10/solo6x10.h~atomic-use-linux-atomich
+++ a/drivers/staging/solo6x10/solo6x10.h
@@ -29,7 +29,7 @@
 #include <linux/wait.h>
 #include <linux/delay.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
diff -puN drivers/staging/tidspbridge/include/dspbridge/host_os.h~atomic-use-linux-atomich drivers/staging/tidspbridge/include/dspbridge/host_os.h
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h~atomic-use-linux-atomich
+++ a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -18,7 +18,7 @@
 #define _HOST_OS_H_
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/semaphore.h>
 #include <linux/uaccess.h>
 #include <linux/irq.h>
diff -puN drivers/staging/winbond/mds_s.h~atomic-use-linux-atomich drivers/staging/winbond/mds_s.h
--- a/drivers/staging/winbond/mds_s.h~atomic-use-linux-atomich
+++ a/drivers/staging/winbond/mds_s.h
@@ -3,7 +3,7 @@
 
 #include <linux/timer.h>
 #include <linux/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "localpara.h"
 #include "mac_structures.h"
diff -puN drivers/staging/winbond/wb35reg_s.h~atomic-use-linux-atomich drivers/staging/winbond/wb35reg_s.h
--- a/drivers/staging/winbond/wb35reg_s.h~atomic-use-linux-atomich
+++ a/drivers/staging/winbond/wb35reg_s.h
@@ -3,7 +3,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct hw_data;
 
diff -puN drivers/tty/bfin_jtag_comm.c~atomic-use-linux-atomich drivers/tty/bfin_jtag_comm.c
--- a/drivers/tty/bfin_jtag_comm.c~atomic-use-linux-atomich
+++ a/drivers/tty/bfin_jtag_comm.c
@@ -25,7 +25,7 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define pr_init(fmt, args...) ({ static const __initconst char __fmt[] = fmt; printk(__fmt, ## args); })
 
diff -puN drivers/tty/rocket.c~atomic-use-linux-atomich drivers/tty/rocket.c
--- a/drivers/tty/rocket.c~atomic-use-linux-atomich
+++ a/drivers/tty/rocket.c
@@ -83,7 +83,7 @@
 #include <linux/wait.h>
 #include <linux/pci.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
diff -puN drivers/tty/serial/dz.c~atomic-use-linux-atomich drivers/tty/serial/dz.c
--- a/drivers/tty/serial/dz.c~atomic-use-linux-atomich
+++ a/drivers/tty/serial/dz.c
@@ -48,7 +48,7 @@
 #include <linux/sysrq.h>
 #include <linux/tty.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/bootinfo.h>
 #include <asm/io.h>
 #include <asm/system.h>
diff -puN drivers/tty/serial/sb1250-duart.c~atomic-use-linux-atomich drivers/tty/serial/sb1250-duart.c
--- a/drivers/tty/serial/sb1250-duart.c~atomic-use-linux-atomich
+++ a/drivers/tty/serial/sb1250-duart.c
@@ -39,7 +39,7 @@
 #include <linux/tty.h>
 #include <linux/types.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/war.h>
 
diff -puN drivers/tty/serial/zs.c~atomic-use-linux-atomich drivers/tty/serial/zs.c
--- a/drivers/tty/serial/zs.c~atomic-use-linux-atomich
+++ a/drivers/tty/serial/zs.c
@@ -65,7 +65,7 @@
 #include <linux/tty.h>
 #include <linux/types.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
diff -puN drivers/usb/gadget/f_audio.c~atomic-use-linux-atomich drivers/usb/gadget/f_audio.c
--- a/drivers/usb/gadget/f_audio.c~atomic-use-linux-atomich
+++ a/drivers/usb/gadget/f_audio.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "u_audio.h"
 
diff -puN drivers/usb/gadget/f_rndis.c~atomic-use-linux-atomich drivers/usb/gadget/f_rndis.c
--- a/drivers/usb/gadget/f_rndis.c~atomic-use-linux-atomich
+++ a/drivers/usb/gadget/f_rndis.c
@@ -29,7 +29,7 @@
 #include <linux/device.h>
 #include <linux/etherdevice.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "u_ether.h"
 #include "rndis.h"
diff -puN drivers/usb/gadget/uvc_queue.c~atomic-use-linux-atomich drivers/usb/gadget/uvc_queue.c
--- a/drivers/usb/gadget/uvc_queue.c~atomic-use-linux-atomich
+++ a/drivers/usb/gadget/uvc_queue.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "uvc.h"
 
diff -puN drivers/usb/image/microtek.c~atomic-use-linux-atomich drivers/usb/image/microtek.c
--- a/drivers/usb/image/microtek.c~atomic-use-linux-atomich
+++ a/drivers/usb/image/microtek.c
@@ -131,7 +131,7 @@
 #include <linux/usb.h>
 #include <linux/proc_fs.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/blkdev.h>
 #include "../../scsi/scsi.h"
 #include <scsi/scsi_host.h>
diff -puN drivers/usb/misc/appledisplay.c~atomic-use-linux-atomich drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c~atomic-use-linux-atomich
+++ a/drivers/usb/misc/appledisplay.c
@@ -29,7 +29,7 @@
 #include <linux/backlight.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define APPLE_VENDOR_ID		0x05AC
 
diff -puN drivers/usb/serial/garmin_gps.c~atomic-use-linux-atomich drivers/usb/serial/garmin_gps.c
--- a/drivers/usb/serial/garmin_gps.c~atomic-use-linux-atomich
+++ a/drivers/usb/serial/garmin_gps.c
@@ -34,7 +34,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
diff -puN drivers/usb/wusbcore/wa-rpipe.c~atomic-use-linux-atomich drivers/usb/wusbcore/wa-rpipe.c
--- a/drivers/usb/wusbcore/wa-rpipe.c~atomic-use-linux-atomich
+++ a/drivers/usb/wusbcore/wa-rpipe.c
@@ -58,7 +58,7 @@
  *  destination address.
  */
 #include <linux/init.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/slab.h>
 
diff -puN drivers/vhost/vhost.h~atomic-use-linux-atomich drivers/vhost/vhost.h
--- a/drivers/vhost/vhost.h~atomic-use-linux-atomich
+++ a/drivers/vhost/vhost.h
@@ -11,7 +11,7 @@
 #include <linux/uio.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_ring.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct vhost_device;
 
diff -puN drivers/video/sh_mobile_lcdcfb.c~atomic-use-linux-atomich drivers/video/sh_mobile_lcdcfb.c
--- a/drivers/video/sh_mobile_lcdcfb.c~atomic-use-linux-atomich
+++ a/drivers/video/sh_mobile_lcdcfb.c
@@ -24,7 +24,7 @@
 #include <linux/backlight.h>
 #include <linux/gpio.h>
 #include <video/sh_mobile_lcdc.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "sh_mobile_lcdcfb.h"
 #include "sh_mobile_meram.h"
diff -puN drivers/video/vermilion/vermilion.h~atomic-use-linux-atomich drivers/video/vermilion/vermilion.h
--- a/drivers/video/vermilion/vermilion.h~atomic-use-linux-atomich
+++ a/drivers/video/vermilion/vermilion.h
@@ -31,7 +31,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/mutex.h>
 
 #define VML_DEVICE_GPU 0x5002
diff -puN drivers/w1/masters/matrox_w1.c~atomic-use-linux-atomich drivers/w1/masters/matrox_w1.c
--- a/drivers/w1/masters/matrox_w1.c~atomic-use-linux-atomich
+++ a/drivers/w1/masters/matrox_w1.c
@@ -20,7 +20,7 @@
  */
 
 #include <asm/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/io.h>
 
 #include <linux/delay.h>
diff -puN drivers/w1/w1.c~atomic-use-linux-atomich drivers/w1/w1.c
--- a/drivers/w1/w1.c~atomic-use-linux-atomich
+++ a/drivers/w1/w1.c
@@ -33,7 +33,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "w1.h"
 #include "w1_log.h"
diff -puN drivers/w1/w1_family.h~atomic-use-linux-atomich drivers/w1/w1_family.h
--- a/drivers/w1/w1_family.h~atomic-use-linux-atomich
+++ a/drivers/w1/w1_family.h
@@ -24,7 +24,7 @@
 
 #include <linux/types.h>
 #include <linux/device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define W1_FAMILY_DEFAULT	0
 #define W1_FAMILY_SMEM_01	0x01
diff -puN drivers/watchdog/intel_scu_watchdog.c~atomic-use-linux-atomich drivers/watchdog/intel_scu_watchdog.c
--- a/drivers/watchdog/intel_scu_watchdog.c~atomic-use-linux-atomich
+++ a/drivers/watchdog/intel_scu_watchdog.c
@@ -43,7 +43,7 @@
 #include <linux/signal.h>
 #include <linux/sfi.h>
 #include <asm/irq.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/intel_scu_ipc.h>
 #include <asm/apb_timer.h>
 #include <asm/mrst.h>
diff -puN drivers/watchdog/sbc7240_wdt.c~atomic-use-linux-atomich drivers/watchdog/sbc7240_wdt.c
--- a/drivers/watchdog/sbc7240_wdt.c~atomic-use-linux-atomich
+++ a/drivers/watchdog/sbc7240_wdt.c
@@ -29,7 +29,7 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 #define SBC7240_PREFIX "sbc7240_wdt: "
diff -puN fs/btrfs/delayed-inode.h~atomic-use-linux-atomich fs/btrfs/delayed-inode.h
--- a/fs/btrfs/delayed-inode.h~atomic-use-linux-atomich
+++ a/fs/btrfs/delayed-inode.h
@@ -25,7 +25,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "ctree.h"
 
diff -puN fs/direct-io.c~atomic-use-linux-atomich fs/direct-io.c
--- a/fs/direct-io.c~atomic-use-linux-atomich
+++ a/fs/direct-io.c
@@ -35,7 +35,7 @@
 #include <linux/buffer_head.h>
 #include <linux/rwsem.h>
 #include <linux/uio.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
diff -puN fs/eventpoll.c~atomic-use-linux-atomich fs/eventpoll.c
--- a/fs/eventpoll.c~atomic-use-linux-atomich
+++ a/fs/eventpoll.c
@@ -37,7 +37,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/mman.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * LOCKING:
diff -puN fs/file_table.c~atomic-use-linux-atomich fs/file_table.c
--- a/fs/file_table.c~atomic-use-linux-atomich
+++ a/fs/file_table.c
@@ -25,7 +25,7 @@
 #include <linux/percpu.h>
 #include <linux/ima.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "internal.h"
 
diff -puN fs/gfs2/main.c~atomic-use-linux-atomich fs/gfs2/main.c
--- a/fs/gfs2/main.c~atomic-use-linux-atomich
+++ a/fs/gfs2/main.c
@@ -16,7 +16,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist_bl.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff -puN fs/nfs/cache_lib.h~atomic-use-linux-atomich fs/nfs/cache_lib.h
--- a/fs/nfs/cache_lib.h~atomic-use-linux-atomich
+++ a/fs/nfs/cache_lib.h
@@ -6,7 +6,7 @@
 
 #include <linux/completion.h>
 #include <linux/sunrpc/cache.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Deferred request handling
diff -puN fs/nfs/direct.c~atomic-use-linux-atomich fs/nfs/direct.c
--- a/fs/nfs/direct.c~atomic-use-linux-atomich
+++ a/fs/nfs/direct.c
@@ -53,7 +53,7 @@
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "internal.h"
 #include "iostat.h"
diff -puN fs/notify/group.c~atomic-use-linux-atomich fs/notify/group.c
--- a/fs/notify/group.c~atomic-use-linux-atomich
+++ a/fs/notify/group.c
@@ -26,7 +26,7 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Final freeing of a group
diff -puN fs/notify/inode_mark.c~atomic-use-linux-atomich fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~atomic-use-linux-atomich
+++ a/fs/notify/inode_mark.c
@@ -23,7 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
diff -puN fs/notify/mark.c~atomic-use-linux-atomich fs/notify/mark.c
--- a/fs/notify/mark.c~atomic-use-linux-atomich
+++ a/fs/notify/mark.c
@@ -92,7 +92,7 @@
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
diff -puN fs/notify/notification.c~atomic-use-linux-atomich fs/notify/notification.c
--- a/fs/notify/notification.c~atomic-use-linux-atomich
+++ a/fs/notify/notification.c
@@ -43,7 +43,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
diff -puN fs/notify/vfsmount_mark.c~atomic-use-linux-atomich fs/notify/vfsmount_mark.c
--- a/fs/notify/vfsmount_mark.c~atomic-use-linux-atomich
+++ a/fs/notify/vfsmount_mark.c
@@ -24,7 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
diff -puN fs/ntfs/inode.h~atomic-use-linux-atomich fs/ntfs/inode.h
--- a/fs/ntfs/inode.h~atomic-use-linux-atomich
+++ a/fs/ntfs/inode.h
@@ -24,7 +24,7 @@
 #ifndef _LINUX_NTFS_INODE_H
 #define _LINUX_NTFS_INODE_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/fs.h>
 #include <linux/list.h>
diff -puN fs/posix_acl.c~atomic-use-linux-atomich fs/posix_acl.c
--- a/fs/posix_acl.c~atomic-use-linux-atomich
+++ a/fs/posix_acl.c
@@ -14,7 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/posix_acl.h>
diff -puN fs/proc/meminfo.c~atomic-use-linux-atomich fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~atomic-use-linux-atomich
+++ a/fs/proc/meminfo.c
@@ -10,7 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/swap.h>
 #include <linux/vmstat.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include "internal.h"
diff -puN include/acpi/platform/aclinux.h~atomic-use-linux-atomich include/acpi/platform/aclinux.h
--- a/include/acpi/platform/aclinux.h~atomic-use-linux-atomich
+++ a/include/acpi/platform/aclinux.h
@@ -59,7 +59,7 @@
 #include <linux/ctype.h>
 #include <linux/sched.h>
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/div64.h>
 #include <asm/acpi.h>
 #include <linux/slab.h>
diff -puN include/asm-generic/local.h~atomic-use-linux-atomich include/asm-generic/local.h
--- a/include/asm-generic/local.h~atomic-use-linux-atomich
+++ a/include/asm-generic/local.h
@@ -2,7 +2,7 @@
 #define _ASM_GENERIC_LOCAL_H
 
 #include <linux/percpu.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/types.h>
 
 /*
diff -puN include/asm-generic/local64.h~atomic-use-linux-atomich include/asm-generic/local64.h
--- a/include/asm-generic/local64.h~atomic-use-linux-atomich
+++ a/include/asm-generic/local64.h
@@ -55,7 +55,7 @@ typedef struct {
 
 #else /* BITS_PER_LONG != 64 */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /* Don't use typedef: don't want them to be mixed with atomic_t's. */
 typedef struct {
diff -puN include/drm/ttm/ttm_lock.h~atomic-use-linux-atomich include/drm/ttm/ttm_lock.h
--- a/include/drm/ttm/ttm_lock.h~atomic-use-linux-atomich
+++ a/include/drm/ttm/ttm_lock.h
@@ -51,7 +51,7 @@
 
 #include "ttm/ttm_object.h"
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /**
  * struct ttm_lock
diff -puN include/linux/aio.h~atomic-use-linux-atomich include/linux/aio.h
--- a/include/linux/aio.h~atomic-use-linux-atomich
+++ a/include/linux/aio.h
@@ -7,7 +7,7 @@
 #include <linux/uio.h>
 #include <linux/rcupdate.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define AIO_MAXSEGS		4
 #define AIO_KIOGRP_NR_ATOMIC	8
diff -puN include/linux/atmdev.h~atomic-use-linux-atomich include/linux/atmdev.h
--- a/include/linux/atmdev.h~atomic-use-linux-atomich
+++ a/include/linux/atmdev.h
@@ -220,7 +220,7 @@ struct atm_cirange {
 #include <linux/skbuff.h> /* struct sk_buff */
 #include <linux/uio.h>
 #include <net/sock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
diff -puN include/linux/atomic.h~atomic-use-linux-atomich include/linux/atomic.h
--- a/include/linux/atomic.h~atomic-use-linux-atomich
+++ a/include/linux/atomic.h
@@ -3,6 +3,15 @@
 #include <asm/atomic.h>
 
 /**
+ * atomic_inc_not_zero - increment unless the number is zero
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1, so long as @v is non-zero.
+ * Returns non-zero if @v was non-zero, and zero otherwise.
+ */
+#define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
+
+/**
  * atomic_inc_not_zero_hint - increment if not null
  * @v: pointer of type atomic_t
  * @hint: probable value of the atomic before the increment
diff -puN include/linux/backing-dev.h~atomic-use-linux-atomich include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~atomic-use-linux-atomich
+++ a/include/linux/backing-dev.h
@@ -16,7 +16,7 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/writeback.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct page;
 struct device;
diff -puN include/linux/bit_spinlock.h~atomic-use-linux-atomich include/linux/bit_spinlock.h
--- a/include/linux/bit_spinlock.h~atomic-use-linux-atomich
+++ a/include/linux/bit_spinlock.h
@@ -3,7 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/preempt.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  *  bit-based spin_lock()
diff -puN include/linux/buffer_head.h~atomic-use-linux-atomich include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~atomic-use-linux-atomich
+++ a/include/linux/buffer_head.h
@@ -12,7 +12,7 @@
 #include <linux/linkage.h>
 #include <linux/pagemap.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_BLOCK
 
diff -puN include/linux/configfs.h~atomic-use-linux-atomich include/linux/configfs.h
--- a/include/linux/configfs.h~atomic-use-linux-atomich
+++ a/include/linux/configfs.h
@@ -42,7 +42,7 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define CONFIGFS_ITEM_NAME_LEN	20
 
diff -puN include/linux/connector.h~atomic-use-linux-atomich include/linux/connector.h
--- a/include/linux/connector.h~atomic-use-linux-atomich
+++ a/include/linux/connector.h
@@ -75,7 +75,7 @@ struct cn_msg {
 
 #ifdef __KERNEL__
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/list.h>
 #include <linux/workqueue.h>
diff -puN include/linux/cred.h~atomic-use-linux-atomich include/linux/cred.h
--- a/include/linux/cred.h~atomic-use-linux-atomich
+++ a/include/linux/cred.h
@@ -16,7 +16,7 @@
 #include <linux/init.h>
 #include <linux/key.h>
 #include <linux/selinux.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct user_struct;
 struct cred;
diff -puN include/linux/crypto.h~atomic-use-linux-atomich include/linux/crypto.h
--- a/include/linux/crypto.h~atomic-use-linux-atomich
+++ a/include/linux/crypto.h
@@ -17,7 +17,7 @@
 #ifndef _LINUX_CRYPTO_H
 #define _LINUX_CRYPTO_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
diff -puN include/linux/dcache.h~atomic-use-linux-atomich include/linux/dcache.h
--- a/include/linux/dcache.h~atomic-use-linux-atomich
+++ a/include/linux/dcache.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_DCACHE_H
 #define __LINUX_DCACHE_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/rculist_bl.h>
diff -puN include/linux/debug_locks.h~atomic-use-linux-atomich include/linux/debug_locks.h
--- a/include/linux/debug_locks.h~atomic-use-linux-atomich
+++ a/include/linux/debug_locks.h
@@ -2,7 +2,7 @@
 #define __LINUX_DEBUG_LOCKING_H
 
 #include <linux/kernel.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 struct task_struct;
diff -puN include/linux/device.h~atomic-use-linux-atomich include/linux/device.h
--- a/include/linux/device.h~atomic-use-linux-atomich
+++ a/include/linux/device.h
@@ -22,7 +22,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/device.h>
 
 struct device;
diff -puN include/linux/edac.h~atomic-use-linux-atomich include/linux/edac.h
--- a/include/linux/edac.h~atomic-use-linux-atomich
+++ a/include/linux/edac.h
@@ -12,7 +12,7 @@
 #ifndef _LINUX_EDAC_H_
 #define _LINUX_EDAC_H_
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/sysdev.h>
 
 #define EDAC_OPSTATE_INVAL	-1
diff -puN include/linux/fault-inject.h~atomic-use-linux-atomich include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~atomic-use-linux-atomich
+++ a/include/linux/fault-inject.h
@@ -5,7 +5,7 @@
 
 #include <linux/types.h>
 #include <linux/debugfs.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * For explanation of the elements of this struct, see
diff -puN include/linux/fdtable.h~atomic-use-linux-atomich include/linux/fdtable.h
--- a/include/linux/fdtable.h~atomic-use-linux-atomich
+++ a/include/linux/fdtable.h
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * The default fd array needs to be at least BITS_PER_LONG,
diff -puN include/linux/filter.h~atomic-use-linux-atomich include/linux/filter.h
--- a/include/linux/filter.h~atomic-use-linux-atomich
+++ a/include/linux/filter.h
@@ -9,7 +9,7 @@
 #include <linux/types.h>
 
 #ifdef __KERNEL__
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #endif
 
 /*
diff -puN include/linux/firewire.h~atomic-use-linux-atomich include/linux/firewire.h
--- a/include/linux/firewire.h~atomic-use-linux-atomich
+++ a/include/linux/firewire.h
@@ -14,7 +14,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 #define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
diff -puN include/linux/fs.h~atomic-use-linux-atomich include/linux/fs.h
--- a/include/linux/fs.h~atomic-use-linux-atomich
+++ a/include/linux/fs.h
@@ -393,7 +393,7 @@ struct inodes_stat_t {
 #include <linux/fiemap.h>
 #include <linux/rculist_bl.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 struct export_operations;
diff -puN include/linux/fsnotify_backend.h~atomic-use-linux-atomich include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~atomic-use-linux-atomich
+++ a/include/linux/fsnotify_backend.h
@@ -16,7 +16,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
diff -puN include/linux/interrupt.h~atomic-use-linux-atomich include/linux/interrupt.h
--- a/include/linux/interrupt.h~atomic-use-linux-atomich
+++ a/include/linux/interrupt.h
@@ -17,7 +17,7 @@
 #include <linux/kref.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
 #include <trace/events/irq.h>
diff -puN include/linux/jump_label.h~atomic-use-linux-atomich include/linux/jump_label.h
--- a/include/linux/jump_label.h~atomic-use-linux-atomich
+++ a/include/linux/jump_label.h
@@ -54,7 +54,7 @@ extern void jump_label_apply_nops(struct
 
 #else
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define JUMP_LABEL_INIT {ATOMIC_INIT(0)}
 
diff -puN include/linux/kdb.h~atomic-use-linux-atomich include/linux/kdb.h
--- a/include/linux/kdb.h~atomic-use-linux-atomich
+++ a/include/linux/kdb.h
@@ -16,7 +16,7 @@
 #ifdef	CONFIG_KGDB_KDB
 #include <linux/init.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define KDB_POLL_FUNC_MAX	5
 extern int kdb_poll_idx;
diff -puN include/linux/key.h~atomic-use-linux-atomich include/linux/key.h
--- a/include/linux/key.h~atomic-use-linux-atomich
+++ a/include/linux/key.h
@@ -21,7 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sysctl.h>
 #include <linux/rwsem.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef __KERNEL__
 
diff -puN include/linux/kgdb.h~atomic-use-linux-atomich include/linux/kgdb.h
--- a/include/linux/kgdb.h~atomic-use-linux-atomich
+++ a/include/linux/kgdb.h
@@ -16,7 +16,7 @@
 #include <linux/serial_8250.h>
 #include <linux/linkage.h>
 #include <linux/init.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #ifdef CONFIG_HAVE_ARCH_KGDB
 #include <asm/kgdb.h>
 #endif
diff -puN include/linux/kobject.h~atomic-use-linux-atomich include/linux/kobject.h
--- a/include/linux/kobject.h~atomic-use-linux-atomich
+++ a/include/linux/kobject.h
@@ -25,7 +25,7 @@
 #include <linux/kobject_ns.h>
 #include <linux/kernel.h>
 #include <linux/wait.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define UEVENT_HELPER_PATH_LEN		256
 #define UEVENT_NUM_ENVP			32	/* number of env pointers */
diff -puN include/linux/mlx4/device.h~atomic-use-linux-atomich include/linux/mlx4/device.h
--- a/include/linux/mlx4/device.h~atomic-use-linux-atomich
+++ a/include/linux/mlx4/device.h
@@ -37,7 +37,7 @@
 #include <linux/completion.h>
 #include <linux/radix-tree.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define MAX_MSIX_P_PORT		17
 #define MAX_MSIX		64
diff -puN include/linux/mman.h~atomic-use-linux-atomich include/linux/mman.h
--- a/include/linux/mman.h~atomic-use-linux-atomich
+++ a/include/linux/mman.h
@@ -14,7 +14,7 @@
 #include <linux/mm.h>
 #include <linux/percpu_counter.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
diff -puN include/linux/mmzone.h~atomic-use-linux-atomich include/linux/mmzone.h
--- a/include/linux/mmzone.h~atomic-use-linux-atomich
+++ a/include/linux/mmzone.h
@@ -16,7 +16,7 @@
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
 #include <generated/bounds.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
diff -puN include/linux/mount.h~atomic-use-linux-atomich include/linux/mount.h
--- a/include/linux/mount.h~atomic-use-linux-atomich
+++ a/include/linux/mount.h
@@ -14,7 +14,7 @@
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
 #include <linux/seqlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct super_block;
 struct vfsmount;
diff -puN include/linux/mutex.h~atomic-use-linux-atomich include/linux/mutex.h
--- a/include/linux/mutex.h~atomic-use-linux-atomich
+++ a/include/linux/mutex.h
@@ -15,7 +15,7 @@
 #include <linux/linkage.h>
 #include <linux/lockdep.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Simple, straightforward mutexes with strict semantics:
diff -puN include/linux/netdevice.h~atomic-use-linux-atomich include/linux/netdevice.h
--- a/include/linux/netdevice.h~atomic-use-linux-atomich
+++ a/include/linux/netdevice.h
@@ -35,7 +35,7 @@
 #include <linux/timer.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/cache.h>
 #include <asm/byteorder.h>
 
diff -puN include/linux/nfs_fs_sb.h~atomic-use-linux-atomich include/linux/nfs_fs_sb.h
--- a/include/linux/nfs_fs_sb.h~atomic-use-linux-atomich
+++ a/include/linux/nfs_fs_sb.h
@@ -7,7 +7,7 @@
 #include <linux/nfs_xdr.h>
 #include <linux/sunrpc/xprt.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct nfs4_session;
 struct nfs_iostats;
diff -puN include/linux/oprofile.h~atomic-use-linux-atomich include/linux/oprofile.h
--- a/include/linux/oprofile.h~atomic-use-linux-atomich
+++ a/include/linux/oprofile.h
@@ -18,7 +18,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/printk.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
  
 /* Each escaped entry is prefixed by ESCAPE_CODE
  * then one of the following codes, then the
diff -puN include/linux/pci.h~atomic-use-linux-atomich include/linux/pci.h
--- a/include/linux/pci.h~atomic-use-linux-atomich
+++ a/include/linux/pci.h
@@ -49,7 +49,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/kobject.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/irqreturn.h>
diff -puN include/linux/perf_event.h~atomic-use-linux-atomich include/linux/perf_event.h
--- a/include/linux/perf_event.h~atomic-use-linux-atomich
+++ a/include/linux/perf_event.h
@@ -508,7 +508,7 @@ struct perf_guest_info_callbacks {
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
 #include <linux/jump_label.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/local.h>
 
 #define PERF_MAX_STACK_DEPTH		255
diff -puN include/linux/phy.h~atomic-use-linux-atomich include/linux/phy.h
--- a/include/linux/phy.h~atomic-use-linux-atomich
+++ a/include/linux/phy.h
@@ -26,7 +26,7 @@
 #include <linux/workqueue.h>
 #include <linux/mod_devicetable.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define PHY_BASIC_FEATURES	(SUPPORTED_10baseT_Half | \
 				 SUPPORTED_10baseT_Full | \
diff -puN include/linux/proc_fs.h~atomic-use-linux-atomich include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~atomic-use-linux-atomich
+++ a/include/linux/proc_fs.h
@@ -5,7 +5,7 @@
 #include <linux/fs.h>
 #include <linux/spinlock.h>
 #include <linux/magic.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct net;
 struct completion;
diff -puN include/linux/quota.h~atomic-use-linux-atomich include/linux/quota.h
--- a/include/linux/quota.h~atomic-use-linux-atomich
+++ a/include/linux/quota.h
@@ -180,7 +180,7 @@ enum {
 #include <linux/dqblk_v1.h>
 #include <linux/dqblk_v2.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
 typedef long long qsize_t;	/* Type in which we store sizes */
diff -puN include/linux/rwsem.h~atomic-use-linux-atomich include/linux/rwsem.h
--- a/include/linux/rwsem.h~atomic-use-linux-atomich
+++ a/include/linux/rwsem.h
@@ -15,7 +15,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct rw_semaphore;
 
diff -puN include/linux/sem.h~atomic-use-linux-atomich include/linux/sem.h
--- a/include/linux/sem.h~atomic-use-linux-atomich
+++ a/include/linux/sem.h
@@ -77,7 +77,7 @@ struct  seminfo {
 #define SEMUSZ  20		/* sizeof struct sem_undo */
 
 #ifdef __KERNEL__
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/rcupdate.h>
 #include <linux/cache.h>
 
diff -puN include/linux/skbuff.h~atomic-use-linux-atomich include/linux/skbuff.h
--- a/include/linux/skbuff.h~atomic-use-linux-atomich
+++ a/include/linux/skbuff.h
@@ -20,7 +20,7 @@
 #include <linux/time.h>
 #include <linux/cache.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/types.h>
 #include <linux/spinlock.h>
 #include <linux/net.h>
diff -puN include/linux/sonet.h~atomic-use-linux-atomich include/linux/sonet.h
--- a/include/linux/sonet.h~atomic-use-linux-atomich
+++ a/include/linux/sonet.h
@@ -58,7 +58,7 @@ struct sonet_stats {
 
 #ifdef __KERNEL__
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct k_sonet_stats {
 #define __HANDLE_ITEM(i) atomic_t i
diff -puN include/linux/spinlock.h~atomic-use-linux-atomich include/linux/spinlock.h
--- a/include/linux/spinlock.h~atomic-use-linux-atomich
+++ a/include/linux/spinlock.h
@@ -384,7 +384,7 @@ static inline void assert_spin_locked(sp
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
  */
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 /**
  * atomic_dec_and_lock - lock on reaching reference count zero
  * @atomic: the atomic counter
diff -puN include/linux/sunrpc/auth.h~atomic-use-linux-atomich include/linux/sunrpc/auth.h
--- a/include/linux/sunrpc/auth.h~atomic-use-linux-atomich
+++ a/include/linux/sunrpc/auth.h
@@ -15,7 +15,7 @@
 #include <linux/sunrpc/msg_prot.h>
 #include <linux/sunrpc/xdr.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/rcupdate.h>
 
 /* size of the nodename buffer */
diff -puN include/linux/sunrpc/cache.h~atomic-use-linux-atomich include/linux/sunrpc/cache.h
--- a/include/linux/sunrpc/cache.h~atomic-use-linux-atomich
+++ a/include/linux/sunrpc/cache.h
@@ -15,7 +15,7 @@
 
 #include <linux/kref.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/proc_fs.h>
 
 /*
diff -puN include/linux/sunrpc/timer.h~atomic-use-linux-atomich include/linux/sunrpc/timer.h
--- a/include/linux/sunrpc/timer.h~atomic-use-linux-atomich
+++ a/include/linux/sunrpc/timer.h
@@ -9,7 +9,7 @@
 #ifndef _LINUX_SUNRPC_TIMER_H
 #define _LINUX_SUNRPC_TIMER_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct rpc_rtt {
 	unsigned long timeo;	/* default timeout value */
diff -puN include/linux/swap.h~atomic-use-linux-atomich include/linux/swap.h
--- a/include/linux/swap.h~atomic-use-linux-atomich
+++ a/include/linux/swap.h
@@ -9,7 +9,7 @@
 #include <linux/sched.h>
 #include <linux/node.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/page.h>
 
 struct notifier_block;
diff -puN include/linux/sysfs.h~atomic-use-linux-atomich include/linux/sysfs.h
--- a/include/linux/sysfs.h~atomic-use-linux-atomich
+++ a/include/linux/sysfs.h
@@ -17,7 +17,7 @@
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/kobject_ns.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct kobject;
 struct module;
diff -puN include/linux/vmstat.h~atomic-use-linux-atomich include/linux/vmstat.h
--- a/include/linux/vmstat.h~atomic-use-linux-atomich
+++ a/include/linux/vmstat.h
@@ -6,7 +6,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/vm_event_item.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 extern int sysctl_stat_interval;
 
diff -puN include/linux/workqueue.h~atomic-use-linux-atomich include/linux/workqueue.h
--- a/include/linux/workqueue.h~atomic-use-linux-atomich
+++ a/include/linux/workqueue.h
@@ -10,7 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
 #include <linux/threads.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct workqueue_struct;
 
diff -puN include/net/ax25.h~atomic-use-linux-atomich include/net/ax25.h
--- a/include/net/ax25.h~atomic-use-linux-atomich
+++ a/include/net/ax25.h
@@ -11,7 +11,7 @@
 #include <linux/timer.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define	AX25_T1CLAMPLO  		1
 #define	AX25_T1CLAMPHI 			(30 * HZ)
diff -puN include/net/cipso_ipv4.h~atomic-use-linux-atomich include/net/cipso_ipv4.h
--- a/include/net/cipso_ipv4.h~atomic-use-linux-atomich
+++ a/include/net/cipso_ipv4.h
@@ -41,7 +41,7 @@
 #include <linux/skbuff.h>
 #include <net/netlabel.h>
 #include <net/request_sock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /* known doi values */
 #define CIPSO_V4_DOI_UNKNOWN          0x00000000
diff -puN include/net/flow.h~atomic-use-linux-atomich include/net/flow.h
--- a/include/net/flow.h~atomic-use-linux-atomich
+++ a/include/net/flow.h
@@ -8,7 +8,7 @@
 #define _NET_FLOW_H
 
 #include <linux/in6.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct flowi_common {
 	int	flowic_oif;
diff -puN include/net/inet_hashtables.h~atomic-use-linux-atomich include/net/inet_hashtables.h
--- a/include/net/inet_hashtables.h~atomic-use-linux-atomich
+++ a/include/net/inet_hashtables.h
@@ -33,7 +33,7 @@
 #include <net/tcp_states.h>
 #include <net/netns/hash.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 
 /* This is for all connections with a full identity, no wildcards.
diff -puN include/net/inet_timewait_sock.h~atomic-use-linux-atomich include/net/inet_timewait_sock.h
--- a/include/net/inet_timewait_sock.h~atomic-use-linux-atomich
+++ a/include/net/inet_timewait_sock.h
@@ -28,7 +28,7 @@
 #include <net/tcp_states.h>
 #include <net/timewait_sock.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct inet_hashinfo;
 
diff -puN include/net/inetpeer.h~atomic-use-linux-atomich include/net/inetpeer.h
--- a/include/net/inetpeer.h~atomic-use-linux-atomich
+++ a/include/net/inetpeer.h
@@ -13,7 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/rtnetlink.h>
 #include <net/ipv6.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct inetpeer_addr_base {
 	union {
diff -puN include/net/ip_vs.h~atomic-use-linux-atomich include/net/ip_vs.h
--- a/include/net/ip_vs.h~atomic-use-linux-atomich
+++ a/include/net/ip_vs.h
@@ -13,7 +13,7 @@
 #include <linux/sysctl.h>               /* for ctl_path */
 #include <linux/list.h>                 /* for struct list_head */
 #include <linux/spinlock.h>             /* for struct rwlock_t */
-#include <asm/atomic.h>                 /* for struct atomic_t */
+#include <linux/atomic.h>                 /* for struct atomic_t */
 #include <linux/compiler.h>
 #include <linux/timer.h>
 
diff -puN include/net/lib80211.h~atomic-use-linux-atomich include/net/lib80211.h
--- a/include/net/lib80211.h~atomic-use-linux-atomich
+++ a/include/net/lib80211.h
@@ -26,7 +26,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/if.h>
 #include <linux/skbuff.h>
 #include <linux/ieee80211.h>
diff -puN include/net/llc.h~atomic-use-linux-atomich include/net/llc.h
--- a/include/net/llc.h~atomic-use-linux-atomich
+++ a/include/net/llc.h
@@ -20,7 +20,7 @@
 #include <linux/hash.h>
 #include <linux/jhash.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct net_device;
 struct packet_type;
diff -puN include/net/neighbour.h~atomic-use-linux-atomich include/net/neighbour.h
--- a/include/net/neighbour.h~atomic-use-linux-atomich
+++ a/include/net/neighbour.h
@@ -16,7 +16,7 @@
  *		- Add neighbour cache statistics like rtstat
  */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/rcupdate.h>
diff -puN include/net/net_namespace.h~atomic-use-linux-atomich include/net/net_namespace.h
--- a/include/net/net_namespace.h~atomic-use-linux-atomich
+++ a/include/net/net_namespace.h
@@ -4,7 +4,7 @@
 #ifndef __NET_NET_NAMESPACE_H
 #define __NET_NET_NAMESPACE_H
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
 #include <linux/sysctl.h>
diff -puN include/net/netfilter/nf_conntrack.h~atomic-use-linux-atomich include/net/netfilter/nf_conntrack.h
--- a/include/net/netfilter/nf_conntrack.h~atomic-use-linux-atomich
+++ a/include/net/netfilter/nf_conntrack.h
@@ -16,7 +16,7 @@
 
 #include <linux/bitops.h>
 #include <linux/compiler.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/netfilter/nf_conntrack_tcp.h>
 #include <linux/netfilter/nf_conntrack_dccp.h>
diff -puN include/net/netlabel.h~atomic-use-linux-atomich include/net/netlabel.h
--- a/include/net/netlabel.h~atomic-use-linux-atomich
+++ a/include/net/netlabel.h
@@ -38,7 +38,7 @@
 #include <linux/in6.h>
 #include <net/netlink.h>
 #include <net/request_sock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct cipso_v4_doi;
 
diff -puN include/net/netns/conntrack.h~atomic-use-linux-atomich include/net/netns/conntrack.h
--- a/include/net/netns/conntrack.h~atomic-use-linux-atomich
+++ a/include/net/netns/conntrack.h
@@ -3,7 +3,7 @@
 
 #include <linux/list.h>
 #include <linux/list_nulls.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct ctl_table_header;
 struct nf_conntrack_ecache;
diff -puN include/net/sctp/structs.h~atomic-use-linux-atomich include/net/sctp/structs.h
--- a/include/net/sctp/structs.h~atomic-use-linux-atomich
+++ a/include/net/sctp/structs.h
@@ -60,7 +60,7 @@
 #include <linux/in6.h>		/* We get struct in6_addr     */
 #include <linux/ipv6.h>
 #include <asm/param.h>		/* We get MAXHOSTNAMELEN.     */
-#include <asm/atomic.h>		/* This gets us atomic counters.  */
+#include <linux/atomic.h>		/* This gets us atomic counters.  */
 #include <linux/skbuff.h>	/* We need sk_buff_head. */
 #include <linux/workqueue.h>	/* We need tq_struct.	 */
 #include <linux/sctp.h>		/* We need sctp* header structs.  */
diff -puN include/pcmcia/ds.h~atomic-use-linux-atomich include/pcmcia/ds.h
--- a/include/pcmcia/ds.h~atomic-use-linux-atomich
+++ a/include/pcmcia/ds.h
@@ -26,7 +26,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <pcmcia/ss.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 
 /*
diff -puN include/rdma/ib_sa.h~atomic-use-linux-atomich include/rdma/ib_sa.h
--- a/include/rdma/ib_sa.h~atomic-use-linux-atomich
+++ a/include/rdma/ib_sa.h
@@ -38,7 +38,7 @@
 #include <linux/completion.h>
 #include <linux/compiler.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_mad.h>
diff -puN include/rdma/ib_verbs.h~atomic-use-linux-atomich include/rdma/ib_verbs.h
--- a/include/rdma/ib_verbs.h~atomic-use-linux-atomich
+++ a/include/rdma/ib_verbs.h
@@ -49,7 +49,7 @@
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 extern struct workqueue_struct *ib_wq;
diff -puN include/rxrpc/types.h~atomic-use-linux-atomich include/rxrpc/types.h
--- a/include/rxrpc/types.h~atomic-use-linux-atomich
+++ a/include/rxrpc/types.h
@@ -17,7 +17,7 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 typedef uint32_t	rxrpc_seq_t;	/* Rx message sequence number */
 typedef uint32_t	rxrpc_serial_t;	/* Rx message serial number */
diff -puN include/scsi/scsi_device.h~atomic-use-linux-atomich include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~atomic-use-linux-atomich
+++ a/include/scsi/scsi_device.h
@@ -7,7 +7,7 @@
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
 #include <scsi/scsi.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 struct request_queue;
 struct scsi_cmnd;
diff -puN include/video/omapdss.h~atomic-use-linux-atomich include/video/omapdss.h
--- a/include/video/omapdss.h~atomic-use-linux-atomich
+++ a/include/video/omapdss.h
@@ -22,7 +22,7 @@
 #include <linux/kobject.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define DISPC_IRQ_FRAMEDONE		(1 << 0)
 #define DISPC_IRQ_VSYNC			(1 << 1)
diff -puN kernel/async.c~atomic-use-linux-atomich kernel/async.c
--- a/kernel/async.c~atomic-use-linux-atomich
+++ a/kernel/async.c
@@ -54,7 +54,7 @@ asynchronous and synchronous parts of th
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 static async_cookie_t next_cookie = 1;
 
diff -puN kernel/audit.c~atomic-use-linux-atomich kernel/audit.c
--- a/kernel/audit.c~atomic-use-linux-atomich
+++ a/kernel/audit.c
@@ -43,7 +43,7 @@
 
 #include <linux/init.h>
 #include <asm/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff -puN kernel/auditsc.c~atomic-use-linux-atomich kernel/auditsc.c
--- a/kernel/auditsc.c~atomic-use-linux-atomich
+++ a/kernel/auditsc.c
@@ -44,7 +44,7 @@
 
 #include <linux/init.h>
 #include <asm/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/mm.h>
diff -puN kernel/cgroup.c~atomic-use-linux-atomich kernel/cgroup.c
--- a/kernel/cgroup.c~atomic-use-linux-atomich
+++ a/kernel/cgroup.c
@@ -61,7 +61,7 @@
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 static DEFINE_MUTEX(cgroup_mutex);
 
diff -puN kernel/cpuset.c~atomic-use-linux-atomich kernel/cpuset.c
--- a/kernel/cpuset.c~atomic-use-linux-atomich
+++ a/kernel/cpuset.c
@@ -55,7 +55,7 @@
 #include <linux/sort.h>
 
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
diff -puN kernel/debug/debug_core.c~atomic-use-linux-atomich kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~atomic-use-linux-atomich
+++ a/kernel/debug/debug_core.c
@@ -51,7 +51,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/system.h>
 
 #include "debug_core.h"
diff -puN kernel/rcupdate.c~atomic-use-linux-atomich kernel/rcupdate.c
--- a/kernel/rcupdate.c~atomic-use-linux-atomich
+++ a/kernel/rcupdate.c
@@ -37,7 +37,7 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
diff -puN kernel/rcutorture.c~atomic-use-linux-atomich kernel/rcutorture.c
--- a/kernel/rcutorture.c~atomic-use-linux-atomich
+++ a/kernel/rcutorture.c
@@ -33,7 +33,7 @@
 #include <linux/rcupdate.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
diff -puN kernel/rcutree_trace.c~atomic-use-linux-atomich kernel/rcutree_trace.c
--- a/kernel/rcutree_trace.c~atomic-use-linux-atomich
+++ a/kernel/rcutree_trace.c
@@ -31,7 +31,7 @@
 #include <linux/rcupdate.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/completion.h>
diff -puN kernel/rwsem.c~atomic-use-linux-atomich kernel/rwsem.c
--- a/kernel/rwsem.c~atomic-use-linux-atomich
+++ a/kernel/rwsem.c
@@ -11,7 +11,7 @@
 #include <linux/rwsem.h>
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * lock for reading
diff -puN kernel/stop_machine.c~atomic-use-linux-atomich kernel/stop_machine.c
--- a/kernel/stop_machine.c~atomic-use-linux-atomich
+++ a/kernel/stop_machine.c
@@ -19,7 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
diff -puN kernel/taskstats.c~atomic-use-linux-atomich kernel/taskstats.c
--- a/kernel/taskstats.c~atomic-use-linux-atomich
+++ a/kernel/taskstats.c
@@ -28,7 +28,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <net/genetlink.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * Maximum length of a cpumask that can be specified in
diff -puN kernel/trace/trace.h~atomic-use-linux-atomich kernel/trace/trace.h
--- a/kernel/trace/trace.h~atomic-use-linux-atomich
+++ a/kernel/trace/trace.h
@@ -2,7 +2,7 @@
 #define _LINUX_KERNEL_TRACE_H
 
 #include <linux/fs.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/sched.h>
 #include <linux/clocksource.h>
 #include <linux/ring_buffer.h>
diff -puN kernel/trace/trace_mmiotrace.c~atomic-use-linux-atomich kernel/trace/trace_mmiotrace.c
--- a/kernel/trace/trace_mmiotrace.c~atomic-use-linux-atomich
+++ a/kernel/trace/trace_mmiotrace.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "trace.h"
 #include "trace_output.h"
diff -puN lib/atomic64.c~atomic-use-linux-atomich lib/atomic64.c
--- a/lib/atomic64.c~atomic-use-linux-atomich
+++ a/lib/atomic64.c
@@ -14,7 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * We use a hashed array of spinlocks to provide exclusive access
diff -puN lib/atomic64_test.c~atomic-use-linux-atomich lib/atomic64_test.c
--- a/lib/atomic64_test.c~atomic-use-linux-atomich
+++ a/lib/atomic64_test.c
@@ -10,7 +10,7 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
 static __init int test_atomic64(void)
diff -puN lib/crc32.c~atomic-use-linux-atomich lib/crc32.c
--- a/lib/crc32.c~atomic-use-linux-atomich
+++ a/lib/crc32.c
@@ -26,7 +26,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/init.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "crc32defs.h"
 #if CRC_LE_BITS == 8
 # define tole(x) __constant_cpu_to_le32(x)
diff -puN lib/dec_and_lock.c~atomic-use-linux-atomich lib/dec_and_lock.c
--- a/lib/dec_and_lock.c~atomic-use-linux-atomich
+++ a/lib/dec_and_lock.c
@@ -1,6 +1,6 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * This is an implementation of the notion of "decrement a
diff -puN mm/init-mm.c~atomic-use-linux-atomich mm/init-mm.c
--- a/mm/init-mm.c~atomic-use-linux-atomich
+++ a/mm/init-mm.c
@@ -5,7 +5,7 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/pgtable.h>
 #include <asm/mmu.h>
 
diff -puN mm/kmemleak.c~atomic-use-linux-atomich mm/kmemleak.c
--- a/mm/kmemleak.c~atomic-use-linux-atomich
+++ a/mm/kmemleak.c
@@ -96,7 +96,7 @@
 
 #include <asm/sections.h>
 #include <asm/processor.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
diff -puN mm/slob.c~atomic-use-linux-atomich mm/slob.c
--- a/mm/slob.c~atomic-use-linux-atomich
+++ a/mm/slob.c
@@ -70,7 +70,7 @@
 
 #include <trace/events/kmem.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * slob_block has a field 'units', which indicates size of block if +ve,
diff -puN mm/vmalloc.c~atomic-use-linux-atomich mm/vmalloc.c
--- a/mm/vmalloc.c~atomic-use-linux-atomich
+++ a/mm/vmalloc.c
@@ -26,7 +26,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
diff -puN net/atm/atm_misc.c~atomic-use-linux-atomich net/atm/atm_misc.c
--- a/net/atm/atm_misc.c~atomic-use-linux-atomich
+++ a/net/atm/atm_misc.c
@@ -9,7 +9,7 @@
 #include <linux/sonet.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 int atm_charge(struct atm_vcc *vcc, int truesize)
 {
diff -puN net/atm/clip.c~atomic-use-linux-atomich net/atm/clip.c
--- a/net/atm/clip.c~atomic-use-linux-atomich
+++ a/net/atm/clip.c
@@ -37,7 +37,7 @@
 #include <linux/uaccess.h>
 #include <asm/byteorder.h> /* for htons etc. */
 #include <asm/system.h> /* save/restore_flags */
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "common.h"
 #include "resources.h"
diff -puN net/atm/common.c~atomic-use-linux-atomich net/atm/common.c
--- a/net/atm/common.c~atomic-use-linux-atomich
+++ a/net/atm/common.c
@@ -23,7 +23,7 @@
 #include <linux/uaccess.h>
 #include <linux/poll.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "resources.h"		/* atm_find_dev */
 #include "common.h"		/* prototypes */
diff -puN net/atm/lec.c~atomic-use-linux-atomich net/atm/lec.c
--- a/net/atm/lec.c~atomic-use-linux-atomich
+++ a/net/atm/lec.c
@@ -1335,7 +1335,7 @@ static void lane2_associate_ind(struct n
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/param.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/inetdevice.h>
 #include <net/route.h>
 
diff -puN net/atm/proc.c~atomic-use-linux-atomich net/atm/proc.c
--- a/net/atm/proc.c~atomic-use-linux-atomich
+++ a/net/atm/proc.c
@@ -27,7 +27,7 @@
 #include <net/atmclip.h>
 #include <linux/uaccess.h>
 #include <linux/param.h> /* for HZ */
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "resources.h"
 #include "common.h" /* atm_proc_init prototype */
 #include "signaling.h" /* to get sigd - ugly too */
diff -puN net/bridge/br_fdb.c~atomic-use-linux-atomich net/bridge/br_fdb.c
--- a/net/bridge/br_fdb.c~atomic-use-linux-atomich
+++ a/net/bridge/br_fdb.c
@@ -21,7 +21,7 @@
 #include <linux/jhash.h>
 #include <linux/random.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/unaligned.h>
 #include "br_private.h"
 
diff -puN net/core/flow.c~atomic-use-linux-atomich net/core/flow.c
--- a/net/core/flow.c~atomic-use-linux-atomich
+++ a/net/core/flow.c
@@ -22,7 +22,7 @@
 #include <linux/cpumask.h>
 #include <linux/mutex.h>
 #include <net/flow.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/security.h>
 
 struct flow_cache_entry {
diff -puN net/decnet/dn_fib.c~atomic-use-linux-atomich net/decnet/dn_fib.c
--- a/net/decnet/dn_fib.c~atomic-use-linux-atomich
+++ a/net/decnet/dn_fib.c
@@ -30,7 +30,7 @@
 #include <linux/netdevice.h>
 #include <linux/timer.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
diff -puN net/decnet/dn_neigh.c~atomic-use-linux-atomich net/decnet/dn_neigh.c
--- a/net/decnet/dn_neigh.c~atomic-use-linux-atomich
+++ a/net/decnet/dn_neigh.c
@@ -38,7 +38,7 @@
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
 #include <linux/jhash.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <net/net_namespace.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
diff -puN net/decnet/dn_table.c~atomic-use-linux-atomich net/decnet/dn_table.c
--- a/net/decnet/dn_table.c~atomic-use-linux-atomich
+++ a/net/decnet/dn_table.c
@@ -25,7 +25,7 @@
 #include <linux/netdevice.h>
 #include <linux/timer.h>
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <linux/route.h> /* RTF_xxx */
 #include <net/neighbour.h>
diff -puN net/decnet/dn_timer.c~atomic-use-linux-atomich net/decnet/dn_timer.c
--- a/net/decnet/dn_timer.c~atomic-use-linux-atomich
+++ a/net/decnet/dn_timer.c
@@ -22,7 +22,7 @@
 #include <linux/timer.h>
 #include <linux/spinlock.h>
 #include <net/sock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <net/flow.h>
 #include <net/dn.h>
 
diff -puN net/ipv4/cipso_ipv4.c~atomic-use-linux-atomich net/ipv4/cipso_ipv4.c
--- a/net/ipv4/cipso_ipv4.c~atomic-use-linux-atomich
+++ a/net/ipv4/cipso_ipv4.c
@@ -50,7 +50,7 @@
 #include <net/tcp.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/bug.h>
 #include <asm/unaligned.h>
 
diff -puN net/ipv4/raw.c~atomic-use-linux-atomich net/ipv4/raw.c
--- a/net/ipv4/raw.c~atomic-use-linux-atomich
+++ a/net/ipv4/raw.c
@@ -38,7 +38,7 @@
  */
 
 #include <linux/types.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/byteorder.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
diff -puN net/ipv6/ip6_tunnel.c~atomic-use-linux-atomich net/ipv6/ip6_tunnel.c
--- a/net/ipv6/ip6_tunnel.c~atomic-use-linux-atomich
+++ a/net/ipv6/ip6_tunnel.c
@@ -40,7 +40,7 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <net/icmp.h>
 #include <net/ip.h>
diff -puN net/iucv/iucv.c~atomic-use-linux-atomich net/iucv/iucv.c
--- a/net/iucv/iucv.c~atomic-use-linux-atomich
+++ a/net/iucv/iucv.c
@@ -51,7 +51,7 @@
 #include <linux/cpu.h>
 #include <linux/reboot.h>
 #include <net/iucv/iucv.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/ebcdic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff -puN net/l2tp/l2tp_core.c~atomic-use-linux-atomich net/l2tp/l2tp_core.c
--- a/net/l2tp/l2tp_core.c~atomic-use-linux-atomich
+++ a/net/l2tp/l2tp_core.c
@@ -55,7 +55,7 @@
 #include <net/protocol.h>
 
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "l2tp_core.h"
 
diff -puN net/l2tp/l2tp_ppp.c~atomic-use-linux-atomich net/l2tp/l2tp_ppp.c
--- a/net/l2tp/l2tp_ppp.c~atomic-use-linux-atomich
+++ a/net/l2tp/l2tp_ppp.c
@@ -97,7 +97,7 @@
 #include <net/xfrm.h>
 
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "l2tp_core.h"
 
diff -puN net/netfilter/nfnetlink_log.c~atomic-use-linux-atomich net/netfilter/nfnetlink_log.c
--- a/net/netfilter/nfnetlink_log.c~atomic-use-linux-atomich
+++ a/net/netfilter/nfnetlink_log.c
@@ -33,7 +33,7 @@
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/nfnetlink_log.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_BRIDGE_NETFILTER
 #include "../bridge/br_private.h"
diff -puN net/netfilter/nfnetlink_queue.c~atomic-use-linux-atomich net/netfilter/nfnetlink_queue.c
--- a/net/netfilter/nfnetlink_queue.c~atomic-use-linux-atomich
+++ a/net/netfilter/nfnetlink_queue.c
@@ -31,7 +31,7 @@
 #include <net/sock.h>
 #include <net/netfilter/nf_queue.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #ifdef CONFIG_BRIDGE_NETFILTER
 #include "../bridge/br_private.h"
diff -puN net/netlabel/netlabel_cipso_v4.c~atomic-use-linux-atomich net/netlabel/netlabel_cipso_v4.c
--- a/net/netlabel/netlabel_cipso_v4.c~atomic-use-linux-atomich
+++ a/net/netlabel/netlabel_cipso_v4.c
@@ -39,7 +39,7 @@
 #include <net/genetlink.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "netlabel_user.h"
 #include "netlabel_cipso_v4.h"
diff -puN net/netlabel/netlabel_kapi.c~atomic-use-linux-atomich net/netlabel/netlabel_kapi.c
--- a/net/netlabel/netlabel_kapi.c~atomic-use-linux-atomich
+++ a/net/netlabel/netlabel_kapi.c
@@ -39,7 +39,7 @@
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <asm/bug.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "netlabel_domainhash.h"
 #include "netlabel_unlabeled.h"
diff -puN net/netlabel/netlabel_mgmt.c~atomic-use-linux-atomich net/netlabel/netlabel_mgmt.c
--- a/net/netlabel/netlabel_mgmt.c~atomic-use-linux-atomich
+++ a/net/netlabel/netlabel_mgmt.c
@@ -42,7 +42,7 @@
 #include <net/ipv6.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "netlabel_domainhash.h"
 #include "netlabel_user.h"
diff -puN net/netlabel/netlabel_mgmt.h~atomic-use-linux-atomich net/netlabel/netlabel_mgmt.h
--- a/net/netlabel/netlabel_mgmt.h~atomic-use-linux-atomich
+++ a/net/netlabel/netlabel_mgmt.h
@@ -32,7 +32,7 @@
 #define _NETLABEL_MGMT_H
 
 #include <net/netlabel.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 /*
  * The following NetLabel payloads are supported by the management interface.
diff -puN net/netlabel/netlabel_unlabeled.c~atomic-use-linux-atomich net/netlabel/netlabel_unlabeled.c
--- a/net/netlabel/netlabel_unlabeled.c~atomic-use-linux-atomich
+++ a/net/netlabel/netlabel_unlabeled.c
@@ -52,7 +52,7 @@
 #include <net/net_namespace.h>
 #include <net/netlabel.h>
 #include <asm/bug.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "netlabel_user.h"
 #include "netlabel_addrlist.h"
diff -puN net/sunrpc/xprtrdma/xprt_rdma.h~atomic-use-linux-atomich net/sunrpc/xprtrdma/xprt_rdma.h
--- a/net/sunrpc/xprtrdma/xprt_rdma.h~atomic-use-linux-atomich
+++ a/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -42,7 +42,7 @@
 
 #include <linux/wait.h> 		/* wait_queue_head_t, etc */
 #include <linux/spinlock.h> 		/* spinlock_t, etc */
-#include <asm/atomic.h>			/* atomic_t, etc */
+#include <linux/atomic.h>			/* atomic_t, etc */
 
 #include <rdma/rdma_cm.h>		/* RDMA connection api */
 #include <rdma/ib_verbs.h>		/* RDMA verbs api */
diff -puN net/tipc/core.h~atomic-use-linux-atomich net/tipc/core.h
--- a/net/tipc/core.h~atomic-use-linux-atomich
+++ a/net/tipc/core.h
@@ -47,7 +47,7 @@
 #include <linux/string.h>
 #include <asm/uaccess.h>
 #include <linux/interrupt.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/hardirq.h>
 #include <linux/netdevice.h>
 #include <linux/in.h>
diff -puN security/selinux/hooks.c~atomic-use-linux-atomich security/selinux/hooks.c
--- a/security/selinux/hooks.c~atomic-use-linux-atomich
+++ a/security/selinux/hooks.c
@@ -57,7 +57,7 @@
 #include <net/netlabel.h>
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>	/* for network interface checks */
diff -puN security/selinux/xfrm.c~atomic-use-linux-atomich security/selinux/xfrm.c
--- a/security/selinux/xfrm.c~atomic-use-linux-atomich
+++ a/security/selinux/xfrm.c
@@ -46,7 +46,7 @@
 #include <net/xfrm.h>
 #include <net/checksum.h>
 #include <net/udp.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "avc.h"
 #include "objsec.h"
diff -puN sound/pci/echoaudio/darla20.c~atomic-use-linux-atomich sound/pci/echoaudio/darla20.c
--- a/sound/pci/echoaudio/darla20.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/darla20.c
@@ -52,7 +52,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/darla20_dsp.fw");
diff -puN sound/pci/echoaudio/darla24.c~atomic-use-linux-atomich sound/pci/echoaudio/darla24.c
--- a/sound/pci/echoaudio/darla24.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/darla24.c
@@ -56,7 +56,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/darla24_dsp.fw");
diff -puN sound/pci/echoaudio/echo3g.c~atomic-use-linux-atomich sound/pci/echoaudio/echo3g.c
--- a/sound/pci/echoaudio/echo3g.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/echo3g.c
@@ -64,7 +64,7 @@
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/echoaudio/gina20.c~atomic-use-linux-atomich sound/pci/echoaudio/gina20.c
--- a/sound/pci/echoaudio/gina20.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/gina20.c
@@ -56,7 +56,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/gina20_dsp.fw");
diff -puN sound/pci/echoaudio/gina24.c~atomic-use-linux-atomich sound/pci/echoaudio/gina24.c
--- a/sound/pci/echoaudio/gina24.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/gina24.c
@@ -62,7 +62,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/echoaudio/indigo.c~atomic-use-linux-atomich sound/pci/echoaudio/indigo.c
--- a/sound/pci/echoaudio/indigo.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/indigo.c
@@ -54,7 +54,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/echoaudio/indigodj.c~atomic-use-linux-atomich sound/pci/echoaudio/indigodj.c
--- a/sound/pci/echoaudio/indigodj.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/indigodj.c
@@ -54,7 +54,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/echoaudio/indigodjx.c~atomic-use-linux-atomich sound/pci/echoaudio/indigodjx.c
--- a/sound/pci/echoaudio/indigodjx.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/indigodjx.c
@@ -54,7 +54,7 @@
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
 #include <sound/initval.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/echoaudio/indigoio.c~atomic-use-linux-atomich sound/pci/echoaudio/indigoio.c
--- a/sound/pci/echoaudio/indigoio.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/indigoio.c
@@ -55,7 +55,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/echoaudio/indigoiox.c~atomic-use-linux-atomich sound/pci/echoaudio/indigoiox.c
--- a/sound/pci/echoaudio/indigoiox.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/indigoiox.c
@@ -55,7 +55,7 @@
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
 #include <sound/initval.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/echoaudio/layla20.c~atomic-use-linux-atomich sound/pci/echoaudio/layla20.c
--- a/sound/pci/echoaudio/layla20.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/layla20.c
@@ -62,7 +62,7 @@
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/layla20_dsp.fw");
diff -puN sound/pci/echoaudio/layla24.c~atomic-use-linux-atomich sound/pci/echoaudio/layla24.c
--- a/sound/pci/echoaudio/layla24.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/layla24.c
@@ -64,7 +64,7 @@
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/echoaudio/mia.c~atomic-use-linux-atomich sound/pci/echoaudio/mia.c
--- a/sound/pci/echoaudio/mia.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/mia.c
@@ -63,7 +63,7 @@
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/echoaudio/mona.c~atomic-use-linux-atomich sound/pci/echoaudio/mona.c
--- a/sound/pci/echoaudio/mona.c~atomic-use-linux-atomich
+++ a/sound/pci/echoaudio/mona.c
@@ -60,7 +60,7 @@
 #include <sound/asoundef.h>
 #include <sound/initval.h>
 #include <asm/io.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include "echoaudio.h"
 
 MODULE_FIRMWARE("ea/loader_dsp.fw");
diff -puN sound/pci/lx6464es/lx6464es.h~atomic-use-linux-atomich sound/pci/lx6464es/lx6464es.h
--- a/sound/pci/lx6464es/lx6464es.h~atomic-use-linux-atomich
+++ a/sound/pci/lx6464es/lx6464es.h
@@ -26,7 +26,7 @@
 #define LX6464ES_H
 
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
diff -puN sound/sparc/dbri.c~atomic-use-linux-atomich sound/sparc/dbri.c
--- a/sound/sparc/dbri.c~atomic-use-linux-atomich
+++ a/sound/sparc/dbri.c
@@ -69,7 +69,7 @@
 
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 MODULE_AUTHOR("Rudolf Koenig, Brent Baccala and Martin Habets");
 MODULE_DESCRIPTION("Sun DBRI");
_

Patches currently in -mm which might be from asharma@fb.com are

atomic-move-atomic_add_unless-to-generic-code.patch

