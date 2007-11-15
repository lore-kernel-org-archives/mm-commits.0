From: akpm@linux-foundation.org
Subject: - mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch removed from -mm tree
Date: Thu, 15 Nov 2007 15:31:33 -0800
Message-ID: <200711152331.lAFNVXPg021532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755045AbXKOXcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 18:32:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, urade.masakazu@jp.panasonic.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     MN10300: Add the MN10300/AM33 architecture to the kernel
has been removed from the -mm tree.  Its filename was
     mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: MN10300: Add the MN10300/AM33 architecture to the kernel
From: David Howells <dhowells@redhat.com>

Add architecture support for the MN10300/AM33 CPUs produced by MEI to the
kernel.

This patch also adds board support for the ASB2303 with the ASB2308 daughter
board, and the ASB2305.  The only processor supported is the MN103E010, which
is an AM33v2 core plus on-chip devices.

Signed-off-by: Masakazu Urade <urade.masakazu@jp.panasonic.com>
Signed-off-by: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mn10300/ABI.txt                  |  149 +
 Documentation/mn10300/compartmentalisation.txt |   60 
 MAINTAINERS                                    |    9 
 arch/mn10300/Kconfig                           |  378 ++
 arch/mn10300/Kconfig.debug                     |  135 +
 arch/mn10300/Makefile                          |  135 +
 arch/mn10300/boot/.gitignore                   |    1 
 arch/mn10300/boot/Makefile                     |   28 
 arch/mn10300/boot/compressed/Makefile          |   22 
 arch/mn10300/boot/compressed/head.S            |   86 
 arch/mn10300/boot/compressed/misc.c            |  413 +++
 arch/mn10300/boot/compressed/vmlinux.lds       |    9 
 arch/mn10300/boot/install.sh                   |   67 
 arch/mn10300/boot/tools/build.c                |  189 +
 arch/mn10300/configs/asb2303_defconfig         |  553 ++++
 arch/mn10300/kernel/Makefile                   |   27 
 arch/mn10300/kernel/asm-offsets.c              |  108 
 arch/mn10300/kernel/entry.S                    |  713 +++++
 arch/mn10300/kernel/fpu-low.S                  |  197 +
 arch/mn10300/kernel/fpu.c                      |  219 +
 arch/mn10300/kernel/gdb-cache.S                |  102 
 arch/mn10300/kernel/gdb-io-serial-low.S        |   90 
 arch/mn10300/kernel/gdb-io-serial.c            |  154 +
 arch/mn10300/kernel/gdb-io-ttysm-low.S         |   93 
 arch/mn10300/kernel/gdb-io-ttysm.c             |  297 ++
 arch/mn10300/kernel/gdb-low.S                  |  115 
 arch/mn10300/kernel/gdb-stub.c                 | 1908 +++++++++++++++
 arch/mn10300/kernel/head.S                     |  254 +
 arch/mn10300/kernel/init_task.c                |   47 
 arch/mn10300/kernel/io.c                       |   31 
 arch/mn10300/kernel/irq.c                      |  232 +
 arch/mn10300/kernel/kernel_execve.S            |   37 
 arch/mn10300/kernel/kprobes.c                  |  654 +++++
 arch/mn10300/kernel/kthread.S                  |   31 
 arch/mn10300/kernel/mn10300-debug.c            |   58 
 arch/mn10300/kernel/mn10300-serial-low.S       |  186 +
 arch/mn10300/kernel/mn10300-serial.c           | 1467 +++++++++++
 arch/mn10300/kernel/mn10300-serial.h           |  126 
 arch/mn10300/kernel/mn10300-watchdog-low.S     |   58 
 arch/mn10300/kernel/mn10300-watchdog.c         |  180 +
 arch/mn10300/kernel/mn10300_ksyms.c            |   37 
 arch/mn10300/kernel/module.c                   |  206 +
 arch/mn10300/kernel/process.c                  |  301 ++
 arch/mn10300/kernel/profile-low.S              |   72 
 arch/mn10300/kernel/profile.c                  |   51 
 arch/mn10300/kernel/ptrace.c                   |  369 ++
 arch/mn10300/kernel/rtc.c                      |  167 +
 arch/mn10300/kernel/semaphore.c                |  152 +
 arch/mn10300/kernel/setup.c                    |  298 ++
 arch/mn10300/kernel/sigframe.h                 |   33 
 arch/mn10300/kernel/signal.c                   |  561 ++++
 arch/mn10300/kernel/switch_to.S                |   71 
 arch/mn10300/kernel/sys_mn10300.c              |  191 +
 arch/mn10300/kernel/time.c                     |  127 
 arch/mn10300/kernel/traps.c                    |  618 ++++
 arch/mn10300/kernel/vmlinux.lds.S              |  159 +
 arch/mn10300/lib/Makefile                      |    7 
 arch/mn10300/lib/__ashldi3.S                   |   49 
 arch/mn10300/lib/__ashrdi3.S                   |   50 
 arch/mn10300/lib/__lshrdi3.S                   |   50 
 arch/mn10300/lib/ashrdi3.c                     |   63 
 arch/mn10300/lib/bitops.c                      |   51 
 arch/mn10300/lib/checksum.c                    |  109 
 arch/mn10300/lib/delay.c                       |   51 
 arch/mn10300/lib/do_csum.S                     |  162 +
 arch/mn10300/lib/lshrdi3.c                     |   62 
 arch/mn10300/lib/memcpy.S                      |  133 +
 arch/mn10300/lib/memmove.S                     |  157 +
 arch/mn10300/lib/memset.S                      |  119 
 arch/mn10300/lib/negdi2.c                      |   58 
 arch/mn10300/lib/usercopy.c                    |  166 +
 arch/mn10300/mm/Makefile                       |   14 
 arch/mn10300/mm/cache-flush-mn10300.S          |  182 +
 arch/mn10300/mm/cache-mn10300.S                |  280 ++
 arch/mn10300/mm/cache.c                        |  123 
 arch/mn10300/mm/dma-alloc.c                    |   56 
 arch/mn10300/mm/extable.c                      |   26 
 arch/mn10300/mm/fault.c                        |  396 +++
 arch/mn10300/mm/init.c                         |  157 +
 arch/mn10300/mm/misalignment.c                 |  661 +++++
 arch/mn10300/mm/mmu-context.c                  |   80 
 arch/mn10300/mm/pgtable.c                      |  197 +
 arch/mn10300/mm/tlb-mn10300.S                  |  199 +
 arch/mn10300/oprofile/Kconfig                  |   23 
 arch/mn10300/oprofile/Makefile                 |   13 
 arch/mn10300/oprofile/op_model_null.c          |   22 
 arch/mn10300/proc-mn103e010/Makefile           |    5 
 arch/mn10300/proc-mn103e010/proc-init.c        |   75 
 arch/mn10300/unit-asb2303/Makefile             |    6 
 arch/mn10300/unit-asb2303/leds.c               |   52 
 arch/mn10300/unit-asb2303/smc91111.c           |   52 
 arch/mn10300/unit-asb2303/unit-init.c          |   60 
 arch/mn10300/unit-asb2305/Makefile             |    8 
 arch/mn10300/unit-asb2305/leds.c               |  124 
 arch/mn10300/unit-asb2305/pci-asb2305.c        |  282 ++
 arch/mn10300/unit-asb2305/pci-asb2305.h        |   81 
 arch/mn10300/unit-asb2305/pci-iomap.c          |   32 
 arch/mn10300/unit-asb2305/pci-irq.c            |   50 
 arch/mn10300/unit-asb2305/pci.c                |  541 ++++
 arch/mn10300/unit-asb2305/unit-init.c          |   61 
 drivers/input/joystick/analog.c                |    4 
 drivers/net/Kconfig                            |    3 
 drivers/net/smc91x.h                           |   12 
 drivers/parport/Kconfig                        |    3 
 drivers/pci/Makefile                           |    1 
 drivers/video/console/Kconfig                  |    2 
 include/asm-mn10300/.gitignore                 |    2 
 include/asm-mn10300/Kbuild                     |    5 
 include/asm-mn10300/atomic.h                   |  172 +
 include/asm-mn10300/auxvec.h                   |    4 
 include/asm-mn10300/bitops.h                   |  234 +
 include/asm-mn10300/bug.h                      |   35 
 include/asm-mn10300/bugs.h                     |   20 
 include/asm-mn10300/busctl-regs.h              |  151 +
 include/asm-mn10300/byteorder.h                |   46 
 include/asm-mn10300/cache.h                    |   53 
 include/asm-mn10300/cacheflush.h               |  113 
 include/asm-mn10300/checksum.h                 |   86 
 include/asm-mn10300/cpu-regs.h                 |  290 ++
 include/asm-mn10300/cputime.h                  |    1 
 include/asm-mn10300/current.h                  |   37 
 include/asm-mn10300/delay.h                    |   19 
 include/asm-mn10300/device.h                   |    1 
 include/asm-mn10300/div64.h                    |   98 
 include/asm-mn10300/dma-mapping.h              |  234 +
 include/asm-mn10300/dma.h                      |  118 
 include/asm-mn10300/dmactl-regs.h              |  102 
 include/asm-mn10300/elf.h                      |  147 +
 include/asm-mn10300/emergency-restart.h        |    1 
 include/asm-mn10300/errno.h                    |    1 
 include/asm-mn10300/exceptions.h               |  118 
 include/asm-mn10300/fb.h                       |   23 
 include/asm-mn10300/fcntl.h                    |    1 
 include/asm-mn10300/fpu.h                      |   85 
 include/asm-mn10300/frame.inc                  |   91 
 include/asm-mn10300/futex.h                    |    1 
 include/asm-mn10300/gdb-stub.h                 |  183 +
 include/asm-mn10300/hardirq.h                  |   47 
 include/asm-mn10300/highmem.h                  |  114 
 include/asm-mn10300/hw_irq.h                   |   14 
 include/asm-mn10300/ide.h                      |   39 
 include/asm-mn10300/intctl-regs.h              |   73 
 include/asm-mn10300/io.h                       |  292 ++
 include/asm-mn10300/ioctl.h                    |    1 
 include/asm-mn10300/ioctls.h                   |   87 
 include/asm-mn10300/ipc.h                      |    1 
 include/asm-mn10300/ipcbuf.h                   |   29 
 include/asm-mn10300/irq.h                      |   32 
 include/asm-mn10300/irq_regs.h                 |   24 
 include/asm-mn10300/kdebug.h                   |   22 
 include/asm-mn10300/kmap_types.h               |   31 
 include/asm-mn10300/kprobes.h                  |   48 
 include/asm-mn10300/linkage.h                  |   22 
 include/asm-mn10300/local.h                    |    1 
 include/asm-mn10300/mc146818rtc.h              |    1 
 include/asm-mn10300/mman.h                     |   28 
 include/asm-mn10300/mmu.h                      |   18 
 include/asm-mn10300/mmu_context.h              |  138 +
 include/asm-mn10300/module.h                   |   27 
 include/asm-mn10300/msgbuf.h                   |   31 
 include/asm-mn10300/mutex.h                    |   16 
 include/asm-mn10300/namei.h                    |   22 
 include/asm-mn10300/nmi.h                      |   14 
 include/asm-mn10300/page.h                     |  129 +
 include/asm-mn10300/page_offset.h              |   11 
 include/asm-mn10300/param.h                    |   33 
 include/asm-mn10300/pci.h                      |  131 +
 include/asm-mn10300/percpu.h                   |    1 
 include/asm-mn10300/pgalloc.h                  |   54 
 include/asm-mn10300/pgtable.h                  |  471 +++
 include/asm-mn10300/pio-regs.h                 |  233 +
 include/asm-mn10300/poll.h                     |    1 
 include/asm-mn10300/posix_types.h              |  132 +
 include/asm-mn10300/proc-mn103e010/cache.h     |   33 
 include/asm-mn10300/proc-mn103e010/clock.h     |   18 
 include/asm-mn10300/proc-mn103e010/irq.h       |   34 
 include/asm-mn10300/proc-mn103e010/proc.h      |   18 
 include/asm-mn10300/processor.h                |  180 +
 include/asm-mn10300/ptrace.h                   |   99 
 include/asm-mn10300/reset-regs.h               |   63 
 include/asm-mn10300/resource.h                 |    1 
 include/asm-mn10300/rtc-regs.h                 |   85 
 include/asm-mn10300/rtc.h                      |   41 
 include/asm-mn10300/scatterlist.h              |   46 
 include/asm-mn10300/sections.h                 |    1 
 include/asm-mn10300/semaphore.h                |  168 +
 include/asm-mn10300/sembuf.h                   |   25 
 include/asm-mn10300/serial-regs.h              |  160 +
 include/asm-mn10300/serial.h                   |   36 
 include/asm-mn10300/setup.h                    |   17 
 include/asm-mn10300/shmbuf.h                   |   42 
 include/asm-mn10300/shmparam.h                 |    6 
 include/asm-mn10300/sigcontext.h               |   52 
 include/asm-mn10300/siginfo.h                  |    1 
 include/asm-mn10300/signal.h                   |  171 +
 include/asm-mn10300/smp.h                      |   18 
 include/asm-mn10300/socket.h                   |   55 
 include/asm-mn10300/sockios.h                  |   13 
 include/asm-mn10300/spinlock.h                 |   16 
 include/asm-mn10300/stat.h                     |   78 
 include/asm-mn10300/statfs.h                   |    1 
 include/asm-mn10300/string.h                   |   32 
 include/asm-mn10300/system.h                   |  231 +
 include/asm-mn10300/termbits.h                 |  200 +
 include/asm-mn10300/termios.h                  |   88 
 include/asm-mn10300/thread_info.h              |  166 +
 include/asm-mn10300/timer-regs.h               |  293 ++
 include/asm-mn10300/timex.h                    |   33 
 include/asm-mn10300/tlb.h                      |   34 
 include/asm-mn10300/tlbflush.h                 |   80 
 include/asm-mn10300/topology.h                 |    1 
 include/asm-mn10300/types.h                    |   67 
 include/asm-mn10300/uaccess.h                  |  483 +++
 include/asm-mn10300/ucontext.h                 |   22 
 include/asm-mn10300/unaligned.h                |  132 +
 include/asm-mn10300/unistd.h                   |  382 +++
 include/asm-mn10300/unit-asb2303/clock.h       |   45 
 include/asm-mn10300/unit-asb2303/leds.h        |   43 
 include/asm-mn10300/unit-asb2303/serial.h      |  124 
 include/asm-mn10300/unit-asb2303/smc91111.h    |   50 
 include/asm-mn10300/unit-asb2303/timex.h       |  135 +
 include/asm-mn10300/unit-asb2305/clock.h       |   45 
 include/asm-mn10300/unit-asb2305/leds.h        |   51 
 include/asm-mn10300/unit-asb2305/serial.h      |  108 
 include/asm-mn10300/unit-asb2305/timex.h       |  135 +
 include/asm-mn10300/user.h                     |   53 
 include/asm-mn10300/vga.h                      |   17 
 include/asm-mn10300/xor.h                      |    1 
 include/linux/elf-em.h                         |    3 
 include/linux/kprobes.h                        |    1 
 lib/Kconfig.debug                              |    4 
 231 files changed, 27573 insertions(+), 5 deletions(-)

diff -puN /dev/null arch/mn10300/boot/compressed/head.S
--- /dev/null
+++ a/arch/mn10300/boot/compressed/head.S
@@ -0,0 +1,86 @@
+/* Boot entry point for a compressed MN10300 kernel
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+	.section	.text
+
+#define DEBUG
+
+#include <linux/linkage.h>
+#include <asm/cpu-regs.h>
+
+	.globl startup_32
+startup_32:
+	# first save off parameters from bootloader
+	mov	param_save_area,a0
+	mov	d0,(a0)
+	mov	d1,(4,a0)
+	mov	d2,(8,a0)
+
+	mov	sp,a3
+	mov	decomp_stack+0x2000-4,a0
+	mov	a0,sp
+
+	# invalidate and enable both of the caches
+	mov	CHCTR,a0
+	clr	d0
+	movhu	d0,(a0)					# turn off first
+	mov	CHCTR_ICINV|CHCTR_DCINV,d0
+	movhu	d0,(a0)
+	setlb
+	mov	(a0),d0
+	btst	CHCTR_ICBUSY|CHCTR_DCBUSY,d0		# wait till not busy (use CPU loop buffer)
+	lne
+	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD,d0	# writethru dcache
+	movhu	d0,(a0)					# enable
+
+	# clear the BSS area
+	mov	__bss_start,a0
+	mov	_end,a1
+	clr	d0
+bssclear:
+	cmp	a1,a0
+	bge	bssclear_end
+	movbu	d0,(a0)
+	inc	a0
+	bra	bssclear
+bssclear_end:
+
+	# decompress the kernel
+	call	decompress_kernel[],0
+
+	# disable caches again
+	mov	CHCTR,a0
+	clr	d0
+	movhu	d0,(a0)
+	setlb
+	mov	(a0),d0
+	btst	CHCTR_ICBUSY|CHCTR_DCBUSY,d0		# wait till not busy (use CPU loop buffer)
+	lne
+
+	mov	param_save_area,a0
+	mov	(a0),d0
+	mov	(4,a0),d1
+	mov	(8,a0),d2
+	
+	mov	a3,sp
+	mov	CONFIG_KERNEL_TEXT_ADDRESS,a0
+	jmp	(a0)
+	
+	.data
+	.align		4
+param_save_area:
+	.rept 3
+	.word		0
+	.endr
+
+	.section	.bss
+	.align		4
+decomp_stack:
+	.space		0x2000
diff -puN /dev/null arch/mn10300/boot/compressed/Makefile
--- /dev/null
+++ a/arch/mn10300/boot/compressed/Makefile
@@ -0,0 +1,22 @@
+#
+# Create a compressed vmlinux image from the original vmlinux
+#
+
+targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o
+
+LDFLAGS_vmlinux := -Ttext $(CONFIG_KERNEL_ZIMAGE_BASE_ADDRESS) -e startup_32
+
+$(obj)/vmlinux: $(obj)/head.o $(obj)/misc.o $(obj)/piggy.o FORCE
+	$(call if_changed,ld)
+	@:
+
+$(obj)/vmlinux.bin: vmlinux FORCE
+	$(call if_changed,objcopy)
+
+$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,gzip)
+
+LDFLAGS_piggy.o := -r --format binary --oformat elf32-am33lin -T
+
+$(obj)/piggy.o: $(obj)/vmlinux.lds $(obj)/vmlinux.bin.gz FORCE
+	$(call if_changed,ld)
diff -puN /dev/null arch/mn10300/boot/compressed/misc.c
--- /dev/null
+++ a/arch/mn10300/boot/compressed/misc.c
@@ -0,0 +1,413 @@
+/* MN10300 Miscellaneous helper routines for kernel decompressor
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ * - Derived from arch/x86/boot/compressed/misc_32.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/compiler.h>
+#include <asm/serial-regs.h>
+
+#ifndef CONFIG_GDBSTUB_ON_TTYSx
+/* display 'Uncompressing Linux... ' messages on ttyS0 or ttyS1 */
+#if 1	/* ttyS0 */
+#define CYG_DEV_BASE	0xA6FB0000
+#else   /* ttyS1 */
+#define CYG_DEV_BASE	0xA6FC0000
+#endif
+
+#define CYG_DEV_THR	(*((volatile __u8*)(CYG_DEV_BASE + 0x00)))
+#define CYG_DEV_MCR	(*((volatile __u8*)(CYG_DEV_BASE + 0x10)))
+#define SIO_MCR_DTR	0x01
+#define SIO_MCR_RTS	0x02
+#define CYG_DEV_LSR	(*((volatile __u8*)(CYG_DEV_BASE + 0x14)))
+#define SIO_LSR_THRE	0x20            // transmitter holding register empty
+#define SIO_LSR_TEMT	0x40            // transmitter register empty
+#define CYG_DEV_MSR	(*((volatile __u8*)(CYG_DEV_BASE + 0x18)))
+#define SIO_MSR_CTS	0x10              // clear to send
+#define SIO_MSR_DSR	0x20              // data set ready
+
+#define LSR_WAIT_FOR(STATE)	do { while (!(CYG_DEV_LSR & SIO_LSR_##STATE)) {;} } while(0)
+#define FLOWCTL_QUERY(LINE)	({ CYG_DEV_MSR & SIO_MSR_##LINE; })
+#define FLOWCTL_WAIT_FOR(LINE)	do { while (!(CYG_DEV_MSR & SIO_MSR_##LINE)) {;} } while(0)
+#define FLOWCTL_CLEAR(LINE)	do { CYG_DEV_MCR &= ~SIO_MCR_##LINE; } while (0)
+#define FLOWCTL_SET(LINE)	do { CYG_DEV_MCR |= SIO_MCR_##LINE; } while (0)
+#endif
+
+/*
+ * gzip declarations
+ */
+
+#define OF(args)  args
+#define STATIC static
+
+#undef memset
+#undef memcpy
+
+static inline void *memset(void* s, int c, size_t n)
+{
+	int i;
+	char *ss = (char *) s;
+
+	for (i = 0; i < n; i++)
+		ss[i] = c;
+	return s;
+}
+
+#define memzero(s, n) memset((s), 0, (n))
+
+static inline void *memcpy(void* __dest, __const void* __src, size_t __n)
+{
+	int i;
+	char *d = (char *) __dest, *s = (char *) __src;
+
+	for (i = 0; i < __n; i++)
+		d[i] = s[i];
+	return __dest;
+}
+
+typedef unsigned char  uch;
+typedef unsigned short ush;
+typedef unsigned long  ulg;
+
+#define WSIZE 0x8000		/* Window size must be at least 32k, */
+				/* and a power of two */
+
+static uch *inbuf;	     /* input buffer */
+static uch window[WSIZE];    /* Sliding window buffer */
+
+static unsigned insize = 0;  /* valid bytes in inbuf */
+static unsigned inptr = 0;   /* index of next byte to be processed in inbuf */
+static unsigned outcnt = 0;  /* bytes in output buffer */
+
+/* gzip flag byte */
+#define ASCII_FLAG   0x01 /* bit 0 set: file probably ASCII text */
+#define CONTINUATION 0x02 /* bit 1 set: continuation of multi-part gzip file */
+#define EXTRA_FIELD  0x04 /* bit 2 set: extra field present */
+#define ORIG_NAME    0x08 /* bit 3 set: original file name present */
+#define COMMENT      0x10 /* bit 4 set: file comment present */
+#define ENCRYPTED    0x20 /* bit 5 set: file is encrypted */
+#define RESERVED     0xC0 /* bit 6,7:   reserved */
+
+/* Diagnostic functions */
+#ifdef DEBUG
+#  define Assert(cond,msg) {if(!(cond)) error(msg);}
+#  define Trace(x) fprintf x
+#  define Tracev(x) {if (verbose) fprintf x ;}
+#  define Tracevv(x) {if (verbose>1) fprintf x ;}
+#  define Tracec(c,x) {if (verbose && (c)) fprintf x ;}
+#  define Tracecv(c,x) {if (verbose>1 && (c)) fprintf x ;}
+#else
+#  define Assert(cond,msg)
+#  define Trace(x)
+#  define Tracev(x)
+#  define Tracevv(x)
+#  define Tracec(c,x)
+#  define Tracecv(c,x)
+#endif
+
+static int  fill_inbuf(void);
+static void flush_window(void);
+static void error(char *m);
+static void kputs(const char *);
+
+
+//#define get_byte()  (inptr < insize ? inbuf[inptr++] : fill_inbuf())
+
+static inline unsigned char get_byte(void)
+{
+	unsigned char ch = inptr < insize ? inbuf[inptr++] : fill_inbuf();
+
+//	char hex[3];
+//	hex[0] = ((ch & 0x0f) > 9) ? ((ch & 0x0f) + 'A' - 0xa) : ((ch & 0x0f) + '0');
+//	hex[1] = ((ch >> 4) > 9) ? ((ch >> 4) + 'A' - 0xa) : ((ch >> 4) + '0');
+//	hex[2] = 0;
+//	kputs(hex);
+
+	return ch;
+}
+
+/*
+ * This is set up by the setup-routine at boot-time
+ */
+#define EXT_MEM_K (*(unsigned short *)0x90002)
+#ifndef STANDARD_MEMORY_BIOS_CALL
+#define ALT_MEM_K (*(unsigned long *) 0x901e0)
+#endif
+#define SCREEN_INFO (*(struct screen_info *)0x90000)
+
+extern char input_data[] asm("input_data");
+extern int input_len  asm("input_len");
+
+static long bytes_out = 0;
+static uch *output_data;
+static unsigned long output_ptr = 0;
+
+
+static void *malloc(int size);
+
+static inline void free(void *where)
+{	/* Don't care */
+}
+
+static void error(char *m);
+
+extern int end;
+static unsigned long free_mem_ptr = (unsigned long) &end;
+static unsigned long free_mem_end_ptr = (unsigned long) &end + 0x90000;
+
+static inline void gzip_mark(void **ptr)
+{
+	kputs(".");
+	*ptr = (void *) free_mem_ptr;
+}
+
+static inline void gzip_release(void **ptr)
+{
+	free_mem_ptr = (unsigned long) *ptr;
+}
+
+#define INPLACE_MOVE_ROUTINE  0x1000
+#define LOW_BUFFER_START      0x2000
+#define LOW_BUFFER_END       0x90000
+#define LOW_BUFFER_SIZE      ( LOW_BUFFER_END - LOW_BUFFER_START )
+#define HEAP_SIZE             0x3000
+static int high_loaded =0;
+static uch *high_buffer_start /* = (uch *)(((ulg)&end) + HEAP_SIZE)*/;
+
+static char *vidmem = (char *)0xb8000;
+static int lines, cols;
+
+#include "../../../../lib/inflate.c"
+
+static void *malloc(int size)
+{
+	void *p;
+
+	if (size <0) error("Malloc error\n");
+	if (free_mem_ptr == 0) error("Memory error\n");
+
+	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
+
+	p = (void *)free_mem_ptr;
+	free_mem_ptr += size;
+
+	if (free_mem_ptr >= free_mem_end_ptr)
+		error("\nOut of memory\n");
+
+	return p;
+}
+
+static inline void scroll(void)
+{
+	int i;
+
+	memcpy ( vidmem, vidmem + cols * 2, ( lines - 1 ) * cols * 2 );
+	for ( i = ( lines - 1 ) * cols * 2; i < lines * cols * 2; i += 2 )
+		vidmem[i] = ' ';
+}
+
+static inline void kputchar(unsigned char ch)
+{
+#ifdef CONFIG_MN10300_UNIT_ASB2305
+	while (SC0STR & SC01STR_TBF)
+		continue;
+
+	if (ch == 0x0a) {
+		SC0TXB = 0x0d;
+		while (SC0STR & SC01STR_TBF)
+			continue;
+	}
+
+	SC0TXB = ch;
+
+#else
+	while (SC1STR & SC01STR_TBF)
+		continue;
+
+	if (ch == 0x0a) {
+		SC1TXB = 0x0d;
+		while (SC1STR & SC01STR_TBF)
+			continue;
+	}
+
+	SC1TXB = ch;
+
+#endif
+}
+
+static void kputs(const char *s)
+{
+#ifdef CONFIG_DEBUG_DECOMPRESS_KERNEL
+#ifndef CONFIG_GDBSTUB_ON_TTYSx
+	char ch;
+
+	FLOWCTL_SET(DTR);
+
+	while (*s) {
+		LSR_WAIT_FOR(THRE);
+
+		ch = *s++;
+		if (ch == 0x0a) {
+			CYG_DEV_THR = 0x0d;
+			LSR_WAIT_FOR(THRE);
+		}
+		CYG_DEV_THR = ch;
+	}
+
+	FLOWCTL_CLEAR(DTR);
+#else
+
+	for (; *s; s++)
+		kputchar(*s);
+
+#endif
+#endif /* CONFIG_DEBUG_DECOMPRESS_KERNEL */
+}
+
+/* ===========================================================================
+ * Fill the input buffer. This is called only when the buffer is empty
+ * and at least one byte is really needed.
+ */
+static int fill_inbuf()
+{
+	if (insize != 0) {
+		error("ran out of input data\n");
+	}
+
+	inbuf = input_data;
+	insize = input_len;
+	inptr = 1;
+	return inbuf[0];
+}
+
+/* ===========================================================================
+ * Write the output window window[0..outcnt-1] and update crc and bytes_out.
+ * (Used for the decompressed data only.)
+ */
+static void flush_window_low(void)
+{
+    ulg c = crc;         /* temporary variable */
+    unsigned n;
+    uch *in, *out, ch;
+
+    in = window;
+    out = &output_data[output_ptr];
+    for (n = 0; n < outcnt; n++) {
+	    ch = *out++ = *in++;
+	    c = crc_32_tab[((int)c ^ ch) & 0xff] ^ (c >> 8);
+    }
+    crc = c;
+    bytes_out += (ulg)outcnt;
+    output_ptr += (ulg)outcnt;
+    outcnt = 0;
+}
+
+static void flush_window_high(void)
+{
+    ulg c = crc;         /* temporary variable */
+    unsigned n;
+    uch *in,  ch;
+    in = window;
+    for (n = 0; n < outcnt; n++) {
+	ch = *output_data++ = *in++;
+	if ((ulg)output_data == LOW_BUFFER_END) output_data=high_buffer_start;
+	c = crc_32_tab[((int)c ^ ch) & 0xff] ^ (c >> 8);
+    }
+    crc = c;
+    bytes_out += (ulg)outcnt;
+    outcnt = 0;
+}
+
+static void flush_window(void)
+{
+	if (high_loaded) flush_window_high();
+	else flush_window_low();
+}
+
+static void error(char *x)
+{
+	kputs("\n\n");
+	kputs(x);
+	kputs("\n\n -- System halted");
+
+	while(1);	/* Halt */
+}
+
+#define STACK_SIZE (4096)
+
+long user_stack [STACK_SIZE];
+
+struct {
+	long * a;
+	short b;
+	} stack_start = { & user_stack [STACK_SIZE] , 0 };
+
+void setup_normal_output_buffer(void)
+{
+#ifdef STANDARD_MEMORY_BIOS_CALL
+	if (EXT_MEM_K < 1024) error("Less than 2MB of memory.\n");
+#else
+	if ((ALT_MEM_K > EXT_MEM_K ? ALT_MEM_K : EXT_MEM_K) < 1024) error("Less than 2MB of memory.\n");
+#endif
+	output_data = (char *)0x100000; /* Points to 1M */
+}
+
+struct moveparams {
+	uch *low_buffer_start;  int lcount;
+	uch *high_buffer_start; int hcount;
+};
+
+void setup_output_buffer_if_we_run_high(struct moveparams *mv)
+{
+	high_buffer_start = (uch *)(((ulg)&end) + HEAP_SIZE);
+#ifdef STANDARD_MEMORY_BIOS_CALL
+	if (EXT_MEM_K < (3*1024)) error("Less than 4MB of memory.\n");
+#else
+	if ((ALT_MEM_K > EXT_MEM_K ? ALT_MEM_K : EXT_MEM_K) < (3*1024)) error("Less than 4MB of memory.\n");
+#endif
+	mv->low_buffer_start = output_data = (char *)LOW_BUFFER_START;
+	high_loaded = 1;
+	free_mem_end_ptr = (long)high_buffer_start;
+	if ( (0x100000 + LOW_BUFFER_SIZE) > ((ulg)high_buffer_start)) {
+		high_buffer_start = (uch *)(0x100000 + LOW_BUFFER_SIZE);
+		mv->hcount = 0; /* say: we need not to move high_buffer */
+	}
+	else mv->hcount = -1;
+	mv->high_buffer_start = high_buffer_start;
+}
+
+void close_output_buffer_if_we_run_high(struct moveparams *mv)
+{
+	mv->lcount = bytes_out;
+	if (bytes_out > LOW_BUFFER_SIZE) {
+		mv->lcount = LOW_BUFFER_SIZE;
+		if (mv->hcount) mv->hcount = bytes_out - LOW_BUFFER_SIZE;
+	}
+	else mv->hcount = 0;
+}
+
+#undef DEBUGFLAG
+#ifdef DEBUGFLAG
+volatile int debugflag = 0;
+#endif
+
+int decompress_kernel(struct moveparams *mv)
+{
+#ifdef DEBUGFLAG
+	while(!debugflag) ;
+#endif
+
+	output_data = (char*)CONFIG_KERNEL_TEXT_ADDRESS;
+
+	makecrc();
+	kputs("Uncompressing Linux... ");
+	gunzip();
+	kputs("Ok, booting the kernel.\n");
+	return 0;
+}
diff -puN /dev/null arch/mn10300/boot/compressed/vmlinux.lds
--- /dev/null
+++ a/arch/mn10300/boot/compressed/vmlinux.lds
@@ -0,0 +1,9 @@
+SECTIONS
+{
+  .data : { 
+	input_len = .;
+	LONG(input_data_end - input_data) input_data = .; 
+	*(.data) 
+	input_data_end = .; 
+	}
+}
diff -puN /dev/null arch/mn10300/boot/.gitignore
--- /dev/null
+++ a/arch/mn10300/boot/.gitignore
@@ -0,0 +1 @@
+zImage
diff -puN /dev/null arch/mn10300/boot/install.sh
--- /dev/null
+++ a/arch/mn10300/boot/install.sh
@@ -0,0 +1,67 @@
+#!/bin/sh
+#
+# arch/mn10300/boot/install -c.sh
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# Licence.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 1995 by Linus Torvalds
+#
+# Adapted from code in arch/i386/boot/Makefile by H. Peter Anvin
+#
+# "make install -c" script for i386 architecture
+#
+# Arguments:
+#   $1 - kernel version
+#   $2 - kernel image file
+#   $3 - kernel map file
+#   $4 - default install -c path (blank if root directory)
+#   $5 - boot rom file
+#
+
+# User may have a custom install -c script
+
+rm -fr $4/../usr/include/linux $4/../usr/include/asm
+install -c -m 0755 $2 $4/vmlinuz
+install -c -m 0755 $5 $4/boot.rom
+install -c -m 0755 -d $4/../usr/include/linux
+cd $TOPDIR/include/linux
+for i in `find . -maxdepth 1 -name '*.h' -print`; do
+  install -c -m 0644 $i $4/../usr/include/linux
+done
+install -c -m 0755 -d $4/../usr/include/linux/byteorder
+cd $TOPDIR/include/linux/byteorder
+for i in `find . -name '*.h' -print`; do
+  install -c -m 0644 $i $4/../usr/include/linux/byteorder
+done
+install -c -m 0755 -d $4/../usr/include/linux/lockd
+cd $TOPDIR/include/linux/lockd
+for i in `find . -name '*.h' -print`; do
+  install -c -m 0644 $i $4/../usr/include/linux/lockd
+done
+install -c -m 0755 -d $4/../usr/include/linux/netfilter_ipv4
+cd $TOPDIR/include/linux/netfilter_ipv4
+for i in `find . -name '*.h' -print`; do
+  install -c -m 0644 $i $4/../usr/include/linux/netfilter_ipv4
+done
+install -c -m 0755 -d $4/../usr/include/linux/nfsd
+cd $TOPDIR/include/linux/nfsd
+for i in `find . -name '*.h' -print`; do
+  install -c -m 0644 $i $4/../usr/include/linux/nfsd/$i
+done
+install -c -m 0755 -d $4/../usr/include/linux/raid
+cd $TOPDIR/include/linux/raid
+for i in `find . -name '*.h' -print`; do
+  install -c -m 0644 $i $4/../usr/include/linux/raid
+done
+install -c -m 0755 -d $4/../usr/include/linux/sunrpc
+cd $TOPDIR/include/linux/sunrpc
+for i in `find . -name '*.h' -print`; do
+  install -c -m 0644 $i $4/../usr/include/linux/sunrpc
+done
+install -c -m 0755 -d $4/../usr/include/asm
+cd $TOPDIR/include/asm
+for i in `find . -name '*.h' -print`; do
+  install -c -m 0644 $i $4/../usr/include/asm
+done
diff -puN /dev/null arch/mn10300/boot/Makefile
--- /dev/null
+++ a/arch/mn10300/boot/Makefile
@@ -0,0 +1,28 @@
+# MN10300 kernel compressor and wrapper
+#
+# Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+
+targets		:= vmlinux.bin zImage
+
+subdir- 	:= compressed
+
+# ---------------------------------------------------------------------------
+
+
+$(obj)/zImage: $(obj)/compressed/vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo 'Kernel: $@ is ready'
+
+$(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
+	$(call if_changed,objcopy)
+
+$(obj)/compressed/vmlinux: FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/compressed IMAGE_OFFSET=$(IMAGE_OFFSET) $@
diff -puN /dev/null arch/mn10300/boot/tools/build.c
--- /dev/null
+++ a/arch/mn10300/boot/tools/build.c
@@ -0,0 +1,189 @@
+/*
+ *  $Id: build.c,v 1.1.2.1 2002/11/12 13:25:46 dhowells Exp $
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 1997 Martin Mares
+ */
+
+/*
+ * This file builds a disk-image from three different files:
+ *
+ * - bootsect: exactly 512 bytes of 8086 machine code, loads the rest
+ * - setup: 8086 machine code, sets up system parm
+ * - system: 80386 code for actual system
+ *
+ * It does some checking that all files are of the correct type, and
+ * just writes the result to stdout, removing headers and padding to
+ * the right amount. It also writes some system data to stderr.
+ */
+
+/*
+ * Changes by tytso to allow root device specification
+ * High loaded stuff by Hans Lermen & Werner Almesberger, Feb. 1996
+ * Cross compiling fixes by Gertjan van Wingerde, July 1996
+ * Rewritten by Martin Mares, April 1997
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <asm/boot.h>
+
+typedef unsigned char byte;
+typedef unsigned short word;
+typedef unsigned long u32;
+
+#define DEFAULT_MAJOR_ROOT 0
+#define DEFAULT_MINOR_ROOT 0
+
+/* Minimal number of setup sectors (see also bootsect.S) */
+#define SETUP_SECTS 4
+
+byte buf[1024];
+int fd;
+int is_big_kernel;
+
+void die(const char * str, ...)
+{
+	va_list args;
+	va_start(args, str);
+	vfprintf(stderr, str, args);
+	fputc('\n', stderr);
+	exit(1);
+}
+
+void file_open(const char *name)
+{
+	if ((fd = open(name, O_RDONLY, 0)) < 0)
+		die("Unable to open `%s': %m", name);
+}
+
+void usage(void)
+{
+	die("Usage: build [-b] bootsect setup system [rootdev] [> image]");
+}
+
+int main(int argc, char ** argv)
+{
+	unsigned int i, c, sz, setup_sectors;
+	u32 sys_size;
+	byte major_root, minor_root;
+	struct stat sb;
+
+	if (argc > 2 && !strcmp(argv[1], "-b"))
+	  {
+	    is_big_kernel = 1;
+	    argc--, argv++;
+	  }
+	if ((argc < 4) || (argc > 5))
+		usage();
+	if (argc > 4) {
+		if (!strcmp(argv[4], "CURRENT")) {
+			if (stat("/", &sb)) {
+				perror("/");
+				die("Couldn't stat /");
+			}
+			major_root = major(sb.st_dev);
+			minor_root = minor(sb.st_dev);
+		} else if (strcmp(argv[4], "FLOPPY")) {
+			if (stat(argv[4], &sb)) {
+				perror(argv[4]);
+				die("Couldn't stat root device.");
+			}
+			major_root = major(sb.st_rdev);
+			minor_root = minor(sb.st_rdev);
+		} else {
+			major_root = 0;
+			minor_root = 0;
+		}
+	} else {
+		major_root = DEFAULT_MAJOR_ROOT;
+		minor_root = DEFAULT_MINOR_ROOT;
+	}
+	fprintf(stderr, "Root device is (%d, %d)\n", major_root, minor_root);
+
+	file_open(argv[1]);
+	i = read(fd, buf, sizeof(buf));
+	fprintf(stderr,"Boot sector %d bytes.\n",i);
+	if (i != 512)
+		die("Boot block must be exactly 512 bytes");
+	if (buf[510] != 0x55 || buf[511] != 0xaa)
+		die("Boot block hasn't got boot flag (0xAA55)");
+	buf[508] = minor_root;
+	buf[509] = major_root;
+	if (write(1, buf, 512) != 512)
+		die("Write call failed");
+	close (fd);
+
+	file_open(argv[2]);				    /* Copy the setup code */
+	for (i=0 ; (c=read(fd, buf, sizeof(buf)))>0 ; i+=c )
+		if (write(1, buf, c) != c)
+			die("Write call failed");
+	if (c != 0)
+		die("read-error on `setup'");
+	close (fd);
+
+	setup_sectors = (i + 511) / 512;	/* Pad unused space with zeros */
+	/* for compatibility with ancient versions of LILO. */
+	if (setup_sectors < SETUP_SECTS)
+		setup_sectors = SETUP_SECTS;
+	fprintf(stderr, "Setup is %d bytes.\n", i);
+	memset(buf, 0, sizeof(buf));
+	while (i < setup_sectors * 512) {
+		c = setup_sectors * 512 - i;
+		if (c > sizeof(buf))
+			c = sizeof(buf);
+		if (write(1, buf, c) != c)
+			die("Write call failed");
+		i += c;
+	}
+
+	file_open(argv[3]);
+	if (fstat (fd, &sb))
+		die("Unable to stat `%s': %m", argv[3]);
+	sz = sb.st_size;
+	fprintf (stderr, "System is %d kB\n", sz/1024);
+	sys_size = (sz + 15) / 16;
+	/* 0x28000*16 = 2.5 MB, conservative estimate for the current maximum */
+	if (sys_size > (is_big_kernel ? 0x28000 : DEF_SYSSIZE))
+		die("System is too big. Try using %smodules.",
+			is_big_kernel ? "" : "bzImage or ");
+	if (sys_size > 0xffff)
+		fprintf(stderr,"warning: kernel is too big for standalone boot "
+		    "from floppy\n");
+	while (sz > 0) {
+		int l, n;
+
+		l = (sz > sizeof(buf)) ? sizeof(buf) : sz;
+		if ((n=read(fd, buf, l)) != l) {
+			if (n < 0)
+				die("Error reading %s: %m", argv[3]);
+			else
+				die("%s: Unexpected EOF", argv[3]);
+		}
+		if (write(1, buf, l) != l)
+			die("Write failed");
+		sz -= l;
+	}
+	close(fd);
+
+	if (lseek(1, 497, SEEK_SET) != 497)		    /* Write sizes to the bootsector */
+		die("Output: seek failed");
+	buf[0] = setup_sectors;
+	if (write(1, buf, 1) != 1)
+		die("Write of setup sector count failed");
+	if (lseek(1, 500, SEEK_SET) != 500)
+		die("Output: seek failed");
+	buf[0] = (sys_size & 0xff);
+	buf[1] = ((sys_size >> 8) & 0xff);
+	if (write(1, buf, 2) != 2)
+		die("Write of image length failed");
+
+	return 0;					    /* Everything is OK */
+}
diff -puN /dev/null arch/mn10300/configs/asb2303_defconfig
--- /dev/null
+++ a/arch/mn10300/configs/asb2303_defconfig
@@ -0,0 +1,553 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.24-rc2
+# Thu Nov  8 13:50:24 2007
+#
+CONFIG_MN10300=y
+CONFIG_AM33=y
+CONFIG_MMU=y
+# CONFIG_HIGHMEM is not set
+# CONFIG_NUMA is not set
+CONFIG_UID16=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_BUG=y
+CONFIG_QUICKLIST=y
+CONFIG_ARCH_HAS_ILOG2_U32=y
+CONFIG_GENERIC_HARDIRQS=y
+# CONFIG_HOTPLUG_CPU is not set
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_LOCK_KERNEL=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+# CONFIG_POSIX_MQUEUE is not set
+CONFIG_BSD_PROCESS_ACCT=y
+# CONFIG_BSD_PROCESS_ACCT_V3 is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_AUDIT is not set
+# CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+# CONFIG_FAIR_GROUP_SCHED is not set
+# CONFIG_SYSFS_DEPRECATED is not set
+# CONFIG_RELAY is not set
+# CONFIG_BLK_DEV_INITRD is not set
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_KALLSYMS is not set
+# CONFIG_HOTPLUG is not set
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_EVENTFD=y
+CONFIG_SHMEM=y
+# CONFIG_VM_EVENT_COUNTERS is not set
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+CONFIG_RT_MUTEXES=y
+# CONFIG_TINY_SHMEM is not set
+CONFIG_BASE_SMALL=0
+# CONFIG_MODULES is not set
+# CONFIG_BLOCK is not set
+
+#
+# Matsushita MN10300 system setup
+#
+CONFIG_MN10300_UNIT_ASB2303=y
+# CONFIG_MN10300_UNIT_ASB2305 is not set
+CONFIG_MN10300_PROC_MN103E010=y
+CONFIG_MN10300_CPU_AM33V2=y
+CONFIG_FPU=y
+CONFIG_MN10300_CACHE_WBACK=y
+# CONFIG_MN10300_CACHE_WTHRU is not set
+# CONFIG_MN10300_CACHE_DISABLED is not set
+
+#
+# Memory layout options
+#
+CONFIG_KERNEL_RAM_BASE_ADDRESS=0x90000000
+CONFIG_INTERRUPT_VECTOR_BASE=0x90000000
+CONFIG_KERNEL_TEXT_ADDRESS=0x90001000
+CONFIG_KERNEL_ZIMAGE_BASE_ADDRESS=0x90700000
+CONFIG_PREEMPT=y
+CONFIG_PREEMPT_BKL=y
+CONFIG_MN10300_CURRENT_IN_E2=y
+CONFIG_MN10300_USING_JTAG=y
+CONFIG_MN10300_RTC=y
+CONFIG_MN10300_WD_TIMER=y
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+
+#
+# MN10300 internal serial options
+#
+CONFIG_MN10300_PROC_HAS_TTYSM0=y
+CONFIG_MN10300_PROC_HAS_TTYSM1=y
+CONFIG_MN10300_PROC_HAS_TTYSM2=y
+CONFIG_MN10300_TTYSM=y
+CONFIG_MN10300_TTYSM_CONSOLE=y
+CONFIG_MN10300_TTYSM0=y
+CONFIG_MN10300_TTYSM0_TIMER8=y
+# CONFIG_MN10300_TTYSM0_TIMER2 is not set
+CONFIG_MN10300_TTYSM1=y
+CONFIG_MN10300_TTYSM1_TIMER9=y
+# CONFIG_MN10300_TTYSM1_TIMER3 is not set
+# CONFIG_MN10300_TTYSM2 is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=0
+CONFIG_NR_QUICK=1
+CONFIG_VIRT_TO_BUS=y
+
+#
+# Power management options
+#
+# CONFIG_PM is not set
+
+#
+# Executable formats
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_BINFMT_MISC is not set
+
+#
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+CONFIG_PACKET_MMAP=y
+CONFIG_UNIX=y
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+# CONFIG_IP_PNP_DHCP is not set
+CONFIG_IP_PNP_BOOTP=y
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_IP_MROUTE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
+# CONFIG_IEEE80211 is not set
+# CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_SYS_HYPERVISOR is not set
+# CONFIG_CONNECTOR is not set
+CONFIG_MTD=y
+CONFIG_MTD_DEBUG=y
+CONFIG_MTD_DEBUG_VERBOSE=0
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_REDBOOT_PARTS=y
+CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
+CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
+# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=y
+# CONFIG_MTD_OOPS is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+CONFIG_MTD_CFI=y
+CONFIG_MTD_JEDECPROBE=y
+CONFIG_MTD_GEN_PROBE=y
+CONFIG_MTD_CFI_ADV_OPTIONS=y
+CONFIG_MTD_CFI_NOSWAP=y
+# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
+# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
+CONFIG_MTD_CFI_GEOMETRY=y
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+CONFIG_MTD_CFI_I2=y
+CONFIG_MTD_CFI_I4=y
+# CONFIG_MTD_CFI_I8 is not set
+# CONFIG_MTD_OTP is not set
+# CONFIG_MTD_CFI_INTELEXT is not set
+CONFIG_MTD_CFI_AMDSTD=y
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=y
+# CONFIG_MTD_RAM is not set
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+# CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+# CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+# CONFIG_PARPORT is not set
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
+
+#
+# SCSI device support
+#
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
+CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+# CONFIG_PHYLIB is not set
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+CONFIG_SMC91X=y
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_SHAPER is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_ISDN is not set
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+# CONFIG_INPUT is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_VT is not set
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_NR_UARTS=4
+CONFIG_SERIAL_8250_RUNTIME_UARTS=4
+CONFIG_SERIAL_8250_EXTENDED=y
+# CONFIG_SERIAL_8250_MANY_PORTS is not set
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+# CONFIG_SERIAL_8250_DETECT_IRQ is not set
+# CONFIG_SERIAL_8250_RSA is not set
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_UNIX98_PTYS=y
+CONFIG_LEGACY_PTYS=y
+CONFIG_LEGACY_PTY_COUNT=256
+# CONFIG_IPMI_HANDLER is not set
+# CONFIG_HW_RANDOM is not set
+CONFIG_RTC=y
+# CONFIG_R3964 is not set
+# CONFIG_TCG_TPM is not set
+# CONFIG_I2C is not set
+
+#
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_HWMON is not set
+# CONFIG_WATCHDOG is not set
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
+# Multimedia devices
+#
+# CONFIG_VIDEO_DEV is not set
+# CONFIG_DVB_CORE is not set
+# CONFIG_DAB is not set
+
+#
+# Graphics support
+#
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+
+#
+# Sound
+#
+# CONFIG_SOUND is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_MMC is not set
+# CONFIG_NEW_LEDS is not set
+# CONFIG_RTC_CLASS is not set
+
+#
+# Userspace I/O
+#
+# CONFIG_UIO is not set
+
+#
+# File systems
+#
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+CONFIG_DNOTIFY=y
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+
+#
+# Miscellaneous filesystems
+#
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_FS_DEBUG=0
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
+# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
+CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
+CONFIG_JFFS2_RTIME=y
+# CONFIG_JFFS2_RUBIN is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+# CONFIG_NFSD is not set
+CONFIG_ROOT_NFS=y
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+# CONFIG_NLS is not set
+# CONFIG_DLM is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_MAGIC_SYSRQ=y
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
+
+#
+# Profiling support
+#
+CONFIG_PROFILING=y
+CONFIG_OPROFILE=y
diff -puN /dev/null arch/mn10300/Kconfig
--- /dev/null
+++ a/arch/mn10300/Kconfig
@@ -0,0 +1,378 @@
+#
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+#
+
+mainmenu "Linux Kernel Configuration"
+
+config MN10300
+	def_bool y
+
+config AM33
+	def_bool y
+
+config MMU
+	def_bool y
+
+config HIGHMEM
+	def_bool n
+
+config NUMA
+	def_bool n
+
+config UID16
+	def_bool y
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+config RWSEM_XCHGADD_ALGORITHM
+	bool
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+config GENERIC_FIND_NEXT_BIT
+	def_bool y
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_TIME
+	def_bool y
+
+config GENERIC_BUG
+	def_bool y
+
+config QUICKLIST
+	def_bool y
+
+config ARCH_HAS_ILOG2_U32
+	def_bool y
+
+# Use the generic interrupt handling code in kernel/irq/
+config GENERIC_HARDIRQS
+	def_bool y
+
+config HOTPLUG_CPU
+	def_bool n
+
+mainmenu "Matsushita MN10300/AM33 Kernel Configuration"
+
+source "init/Kconfig"
+
+
+menu "Matsushita MN10300 system setup"
+
+choice
+	prompt "Unit type"
+	default MN10300_UNIT_ASB2303
+	help
+	  This option specifies board for which the kernel will be
+	  compiled. It affects the external peripherals catered for.
+
+config MN10300_UNIT_ASB2303
+	bool "ASB2303"
+
+config MN10300_UNIT_ASB2305
+	bool "ASB2305"
+
+endchoice
+
+choice
+	prompt "Processor support"
+	default MN10300_PROC_MN103E010
+	help
+	  This option specifies the processor for which the kernel will be
+	  compiled. It affects the on-chip peripherals catered for.
+
+config MN10300_PROC_MN103E010
+	bool "MN103E010"
+	depends on MN10300_UNIT_ASB2303 || MN10300_UNIT_ASB2305
+	select MN10300_PROC_HAS_TTYSM0
+	select MN10300_PROC_HAS_TTYSM1
+	select MN10300_PROC_HAS_TTYSM2
+
+endchoice
+
+choice
+	prompt "Processor core support"
+	default MN10300_CPU_AM33V2
+	help
+	  This option specifies the processor core for which the kernel will be
+	  compiled. It affects the instruction set used.
+
+config MN10300_CPU_AM33V2
+	bool "AM33v2"
+
+endchoice
+
+config FPU
+	bool "FPU present"
+	default y
+	depends on MN10300_PROC_MN103E010
+
+choice
+	prompt "CPU Caching mode"
+	default MN10300_CACHE_WBACK
+	help
+	  This option determines the caching mode for the kernel.
+
+	  Write-Back caching mode involves the all reads and writes causing
+	  the affected cacheline to be read into the cache first before being
+	  operated upon. Memory is not then updated by a write until the cache
+	  is filled and a cacheline needs to be displaced from the cache to
+	  make room. Only at that point is it written back.
+
+	  Write-Through caching only fetches cachelines from memory on a
+	  read. Writes always get written directly to memory. If the affected
+	  cacheline is also in cache, it will be updated too.
+
+	  The final option is to turn of caching entirely.
+
+config MN10300_CACHE_WBACK
+	bool "Write-Back"
+
+config MN10300_CACHE_WTHRU
+	bool "Write-Through"
+
+config MN10300_CACHE_DISABLED
+	bool "Disabled"
+
+endchoice
+
+menu "Memory layout options"
+
+config KERNEL_RAM_BASE_ADDRESS
+	hex "Base address of kernel RAM"
+	default "0x90000000"
+
+config INTERRUPT_VECTOR_BASE
+	hex "Base address of vector table"
+	default "0x90000000"
+	help
+	  The base address of the vector table will be programmed into
+          the TBR register. It must be on 16MiB address boundary.
+
+config KERNEL_TEXT_ADDRESS
+	hex "Base address of kernel"
+	default "0x90001000"
+
+config KERNEL_ZIMAGE_BASE_ADDRESS
+	hex "Base address of compressed vmlinux image"
+	default "0x90700000"
+
+endmenu
+
+config PREEMPT
+	bool "Preemptible Kernel"
+	help
+	  This option reduces the latency of the kernel when reacting to
+	  real-time or interactive events by allowing a low priority process to
+	  be preempted even if it is in kernel mode executing a system call.
+	  This allows applications to run more reliably even when the system is
+	  under load.
+
+	  Say Y here if you are building a kernel for a desktop, embedded
+	  or real-time system.  Say N if you are unsure.
+
+config PREEMPT_BKL
+	bool "Preempt The Big Kernel Lock"
+	depends on PREEMPT
+	default y
+	help
+	  This option reduces the latency of the kernel by making the
+	  big kernel lock preemptible.
+
+	  Say Y here if you are building a kernel for a desktop system.
+	  Say N if you are unsure.
+
+config MN10300_CURRENT_IN_E2
+	bool "Hold current task address in E2 register"
+	default y
+	help
+	  This option removes the E2/R2 register from the set available to gcc
+	  for normal use and instead uses it to store the address of the
+	  current process's task_struct whilst in the kernel.
+
+	  This means the kernel doesn't need to calculate the address each time
+	  "current" is used (take SP, AND with mask and dereference pointer
+	  just to get the address), and instead can just use E2+offset
+	  addressing each time.
+
+	  This has no effect on userspace.
+
+config MN10300_USING_JTAG
+	bool "Using JTAG to debug kernel"
+	default y
+	help
+	  This options indicates that JTAG will be used to debug the kernel. It
+	  suppresses the use of certain hardware debugging features, such as
+	  single-stepping, which are taken over completely by the JTAG unit.
+
+config MN10300_RTC
+	bool "Using MN10300 RTC"
+	depends on MN10300_PROC_MN103E010
+	default n
+	help
+
+	  This option enables support for the RTC, thus enabling time to be
+	  tracked, even when system is powered down. This is available on-chip
+	  on the MN103E010.
+
+config MN10300_WD_TIMER
+	bool "Using MN10300 watchdog timer"
+	default y
+	help
+	  This options indicates that the watchdog timer will be used.
+
+config PCI
+	bool "Use PCI"
+	depends on MN10300_UNIT_ASB2305
+	default y
+	help
+	  Some systems (such as the ASB2305) have PCI onboard. If you have one
+	  of these boards and you wish to use the PCI facilities, say Y here.
+
+	  The PCI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>, contains valuable
+	  information about which PCI hardware does work under Linux and which
+	  doesn't.
+
+source "drivers/pci/Kconfig"
+
+source "drivers/pcmcia/Kconfig"
+
+menu "MN10300 internal serial options"
+
+config MN10300_PROC_HAS_TTYSM0
+	bool
+	default n
+
+config MN10300_PROC_HAS_TTYSM1
+	bool
+	default n
+
+config MN10300_PROC_HAS_TTYSM2
+	bool
+	default n
+
+config MN10300_TTYSM
+	bool "Support for ttySM serial ports"
+	depends on MN10300
+	default y
+	select SERIAL_CORE
+	help
+	  This option enables support for the on-chip serial ports that the
+	  MN10300 has available.
+
+config MN10300_TTYSM_CONSOLE
+	bool "Support for console on ttySM serial ports"
+	depends on MN10300_TTYSM
+	select SERIAL_CORE_CONSOLE
+	help
+	  This option enables support for a console on the on-chip serial ports
+	  that the MN10300 has available.
+
+#
+# /dev/ttySM0
+#
+config MN10300_TTYSM0
+	bool "Enable SIF0 (/dev/ttySM0)"
+	depends on MN10300_TTYSM && MN10300_PROC_HAS_TTYSM0
+	help
+	  Enable access to SIF0 through /dev/ttySM0 or gdb-stub
+
+choice
+	prompt "Select the timer to supply the clock for SIF0"
+	default MN10300_TTYSM0_TIMER8
+	depends on MN10300_TTYSM0
+
+config MN10300_TTYSM0_TIMER8
+	bool "Use timer 8 (16-bit)"
+
+config MN10300_TTYSM0_TIMER2
+	bool "Use timer 2 (8-bit)"
+
+endchoice
+
+#
+# /dev/ttySM1
+#
+config MN10300_TTYSM1
+	bool "Enable SIF1 (/dev/ttySM1)"
+	depends on MN10300_TTYSM && MN10300_PROC_HAS_TTYSM1
+	help
+	  Enable access to SIF1 through /dev/ttySM1 or gdb-stub
+
+choice
+	prompt "Select the timer to supply the clock for SIF1"
+	default MN10300_TTYSM0_TIMER9
+	depends on MN10300_TTYSM1
+
+config MN10300_TTYSM1_TIMER9
+	bool "Use timer 9 (16-bit)"
+
+config MN10300_TTYSM1_TIMER3
+	bool "Use timer 3 (8-bit)"
+
+endchoice
+
+#
+# /dev/ttySM2
+#
+config MN10300_TTYSM2
+	bool "Enable SIF2 (/dev/ttySM2)"
+	depends on MN10300_TTYSM && MN10300_PROC_HAS_TTYSM2
+	help
+	  Enable access to SIF2 through /dev/ttySM2 or gdb-stub
+
+choice
+	prompt "Select the timer to supply the clock for SIF2"
+	default MN10300_TTYSM0_TIMER10
+	depends on MN10300_TTYSM2
+
+config MN10300_TTYSM2_TIMER10
+	bool "Use timer 10 (16-bit)"
+
+endchoice
+
+config MN10300_TTYSM2_CTS
+	bool "Enable the use of the CTS line /dev/ttySM2"
+	depends on MN10300_TTYSM2
+
+endmenu
+
+source "mm/Kconfig"
+
+menu "Power management options"
+source kernel/power/Kconfig
+endmenu
+
+endmenu
+
+
+menu "Executable formats"
+
+source "fs/Kconfig.binfmt"
+
+endmenu
+
+source "net/Kconfig"
+
+source "drivers/Kconfig"
+
+source "fs/Kconfig"
+
+source "arch/mn10300/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
+
+source "arch/mn10300/oprofile/Kconfig"
diff -puN /dev/null arch/mn10300/Kconfig.debug
--- /dev/null
+++ a/arch/mn10300/Kconfig.debug
@@ -0,0 +1,135 @@
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on DEBUG_KERNEL
+
+config DEBUG_DECOMPRESS_KERNEL
+	bool "Using serial port during decompressing kernel"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  If you say Y here you will confirm the start and the end of
+	  decompressing Linux seeing "Uncompressing Linux... " and
+	  "Ok, booting the kernel.\n" on console.
+
+config KPROBES
+	bool "Kprobes"
+	depends on DEBUG_KERNEL
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
+
+config GDBSTUB
+	bool "Remote GDB kernel debugging"
+	depends on DEBUG_KERNEL
+	select DEBUG_INFO
+	select FRAME_POINTER
+	help
+	  If you say Y here, it will be possible to remotely debug the kernel
+	  using gdb. This enlarges your kernel ELF image disk size by several
+	  megabytes and requires a machine with more than 16 MB, better 32 MB
+	  RAM to avoid excessive linking time. This is only useful for kernel
+	  hackers. If unsure, say N.
+
+config GDBSTUB_IMMEDIATE
+	bool "Break into GDB stub immediately"
+	depends on GDBSTUB
+	help
+	  If you say Y here, GDB stub will break into the program as soon as
+	  possible, leaving the program counter at the beginning of
+	  start_kernel() in init/main.c.
+
+config GDB_CONSOLE
+	bool "Console output to GDB"
+	depends on GDBSTUB
+	help
+	  If you are using GDB for remote debugging over a serial port and
+	  would like kernel messages to be formatted into GDB $O packets so
+	  that GDB prints them as program output, say 'Y'.
+
+config GDBSTUB_DEBUGGING
+	bool "Debug GDB stub by messages to serial port"
+	depends on GDBSTUB
+	help
+	  This causes debugging messages to be displayed at various points
+	  during execution of the GDB stub routines. Such messages will be
+	  displayed on ttyS0 if that isn't the GDB stub's port, or ttySM0
+	  otherwise.
+
+config GDBSTUB_DEBUG_ENTRY
+	bool "Debug GDB stub entry"
+	depends on GDBSTUB_DEBUGGING
+	help
+	  This option causes information to be displayed about entry to or exit
+	  from the main GDB stub routine.
+
+config GDBSTUB_DEBUG_PROTOCOL
+	bool "Debug GDB stub protocol"
+	depends on GDBSTUB_DEBUGGING
+	help
+	  This option causes information to be displayed about the GDB remote
+	  protocol messages generated exchanged with GDB.
+
+config GDBSTUB_DEBUG_IO
+	bool "Debug GDB stub I/O"
+	depends on GDBSTUB_DEBUGGING
+	help
+	  This option causes information to be displayed about GDB stub's
+	  low-level I/O.
+
+config GDBSTUB_DEBUG_BREAKPOINT
+	bool "Debug GDB stub breakpoint management"
+	depends on GDBSTUB_DEBUGGING
+	help
+	  This option causes information to be displayed about GDB stub's
+	  breakpoint management.
+
+choice
+	prompt "GDB stub port"
+	default GDBSTUB_TTYSM0
+	depends on GDBSTUB
+	help
+	  Select the serial port used for GDB-stub.
+
+config GDBSTUB_ON_TTYSM0
+	bool "/dev/ttySM0 [SIF0]"
+	depends on MN10300_TTYSM0
+	select GDBSTUB_ON_TTYSMx
+
+config GDBSTUB_ON_TTYSM1
+	bool "/dev/ttySM1 [SIF1]"
+	depends on MN10300_TTYSM1
+	select GDBSTUB_ON_TTYSMx
+
+config GDBSTUB_ON_TTYSM2
+	bool "/dev/ttySM2 [SIF2]"
+	depends on MN10300_TTYSM2
+	select GDBSTUB_ON_TTYSMx
+
+config GDBSTUB_ON_TTYS0
+	bool "/dev/ttyS0"
+	select GDBSTUB_ON_TTYSx
+
+config GDBSTUB_ON_TTYS1
+	bool "/dev/ttyS1"
+	select GDBSTUB_ON_TTYSx
+
+endchoice
+
+config GDBSTUB_ON_TTYSMx
+	bool
+	depends on GDBSTUB_ON_TTYSM0 || GDBSTUB_ON_TTYSM1 || GDBSTUB_ON_TTYSM2
+	default y
+
+config GDBSTUB_ON_TTYSx
+	bool
+	depends on GDBSTUB_ON_TTYS0 || GDBSTUB_ON_TTYS1
+	default y
+
+endmenu
diff -puN /dev/null arch/mn10300/kernel/asm-offsets.c
--- /dev/null
+++ a/arch/mn10300/kernel/asm-offsets.c
@@ -0,0 +1,108 @@
+/*
+ * Generate definitions needed by assembly language modules.
+ * This code generates raw asm output which is post-processed
+ * to extract and format the required data.
+ */
+
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/personality.h>
+#include <asm/ucontext.h>
+#include <asm/processor.h>
+#include <asm/thread_info.h>
+#include <asm/ptrace.h>
+#include "sigframe.h"
+#include "mn10300-serial.h"
+
+#define DEFINE(sym, val) \
+        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+
+#define BLANK() asm volatile("\n->" : : )
+
+#define OFFSET(sym, str, mem) \
+	DEFINE(sym, offsetof(struct str, mem));
+
+void foo(void)
+{
+	OFFSET(SIGCONTEXT_d0, sigcontext, d0);
+	OFFSET(SIGCONTEXT_d1, sigcontext, d1);
+	BLANK();
+
+	OFFSET(TI_task,			thread_info, task);
+	OFFSET(TI_exec_domain,		thread_info, exec_domain);
+	OFFSET(TI_flags,		thread_info, flags);
+	OFFSET(TI_cpu,			thread_info, cpu);
+	OFFSET(TI_preempt_count,	thread_info, preempt_count);
+	OFFSET(TI_addr_limit,		thread_info, addr_limit);
+	OFFSET(TI_restart_block,	thread_info, restart_block);
+	BLANK();
+
+	OFFSET(REG_D0,			pt_regs, d0);
+	OFFSET(REG_D1,			pt_regs, d1);
+	OFFSET(REG_D2,			pt_regs, d2);
+	OFFSET(REG_D3,			pt_regs, d3);
+	OFFSET(REG_A0,			pt_regs, a0);
+	OFFSET(REG_A1,			pt_regs, a1);
+	OFFSET(REG_A2,			pt_regs, a2);
+	OFFSET(REG_A3,			pt_regs, a3);
+	OFFSET(REG_E0,			pt_regs, e0);
+	OFFSET(REG_E1,			pt_regs, e1);
+	OFFSET(REG_E2,			pt_regs, e2);
+	OFFSET(REG_E3,			pt_regs, e3);
+	OFFSET(REG_E4,			pt_regs, e4);
+	OFFSET(REG_E5,			pt_regs, e5);
+	OFFSET(REG_E6,			pt_regs, e6);
+	OFFSET(REG_E7,			pt_regs, e7);
+	OFFSET(REG_SP,			pt_regs, sp);
+	OFFSET(REG_EPSW,		pt_regs, epsw);
+	OFFSET(REG_PC,			pt_regs, pc);
+	OFFSET(REG_LAR,			pt_regs, lar);
+	OFFSET(REG_LIR,			pt_regs, lir);
+	OFFSET(REG_MDR,			pt_regs, mdr);
+	OFFSET(REG_MCVF,		pt_regs, mcvf);
+	OFFSET(REG_MCRL,		pt_regs, mcrl);
+	OFFSET(REG_MCRH,		pt_regs, mcrh);
+	OFFSET(REG_MDRQ,		pt_regs, mdrq);
+	OFFSET(REG_ORIG_D0,		pt_regs, orig_d0);
+	OFFSET(REG_NEXT,		pt_regs, next);
+	DEFINE(REG__END,		sizeof(struct pt_regs));
+	BLANK();
+
+	OFFSET(THREAD_UREGS,		thread_struct, uregs);
+	OFFSET(THREAD_PC,		thread_struct, pc);
+	OFFSET(THREAD_SP,		thread_struct, sp);
+	OFFSET(THREAD_A3,		thread_struct, a3);
+	OFFSET(THREAD_USP,		thread_struct, usp);
+	OFFSET(THREAD_FRAME,		thread_struct, __frame);
+	BLANK();
+
+	DEFINE(CLONE_VM_asm,		CLONE_VM);
+	DEFINE(CLONE_FS_asm,		CLONE_FS);
+	DEFINE(CLONE_FILES_asm,		CLONE_FILES);
+	DEFINE(CLONE_SIGHAND_asm,	CLONE_SIGHAND);
+	DEFINE(CLONE_UNTRACED_asm,	CLONE_UNTRACED);
+	DEFINE(SIGCHLD_asm,		SIGCHLD);
+	BLANK();
+
+	OFFSET(EXEC_DOMAIN_handler,	exec_domain, handler);
+	OFFSET(RT_SIGFRAME_sigcontext,	rt_sigframe, uc.uc_mcontext);
+
+	DEFINE(PAGE_SIZE_asm,		PAGE_SIZE);
+
+	OFFSET(__rx_buffer,		mn10300_serial_port, rx_buffer);
+	OFFSET(__rx_inp,		mn10300_serial_port, rx_inp);
+	OFFSET(__rx_outp,		mn10300_serial_port, rx_outp);
+	OFFSET(__tx_info_buffer,	mn10300_serial_port, uart.info);
+	OFFSET(__tx_xchar,		mn10300_serial_port, tx_xchar);
+	OFFSET(__tx_break,		mn10300_serial_port, tx_break);
+	OFFSET(__intr_flags,		mn10300_serial_port, intr_flags);
+	OFFSET(__rx_icr,		mn10300_serial_port, rx_icr);
+	OFFSET(__tx_icr,		mn10300_serial_port, tx_icr);
+	OFFSET(__tm_icr,		mn10300_serial_port, _tmicr);
+	OFFSET(__iobase,		mn10300_serial_port, _iobase);
+
+	DEFINE(__UART_XMIT_SIZE,	UART_XMIT_SIZE);
+	OFFSET(__xmit_buffer,		uart_info, xmit.buf);
+	OFFSET(__xmit_head,		uart_info, xmit.head);
+	OFFSET(__xmit_tail,		uart_info, xmit.tail);
+}
diff -puN /dev/null arch/mn10300/kernel/entry.S
--- /dev/null
+++ a/arch/mn10300/kernel/entry.S
@@ -0,0 +1,713 @@
+###############################################################################
+#
+# MN10300 Exception and interrupt entry points
+#
+# Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Modified by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/system.h>
+#include <asm/thread_info.h>
+#include <asm/intctl-regs.h>
+#include <asm/busctl-regs.h>
+#include <asm/timer-regs.h>
+#include <asm/unit/leds.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/errno.h>
+#include <asm/asm-offsets.h>
+#include <asm/frame.inc>
+
+#ifdef CONFIG_PREEMPT
+#define preempt_stop		__cli
+#else
+#define preempt_stop
+#define resume_kernel		restore_all
+#endif
+
+	.macro __cli
+	and	~EPSW_IM,epsw
+	or	EPSW_IE|MN10300_CLI_LEVEL,epsw
+	nop
+	nop
+	nop
+	.endm
+	.macro __sti
+	or	EPSW_IE|EPSW_IM_7,epsw
+	.endm
+
+
+	.am33_2
+
+###################################################################################################
+#
+# the return path for a forked child
+# - on entry, D0 holds the address of the previous task to run
+#
+###################################################################################################
+ENTRY(ret_from_fork)
+	call	schedule_tail[],0
+	GET_THREAD_INFO a2
+	
+	# return 0 to indicate child process
+	clr	d0
+	mov	d0,(REG_D0,fp)
+	jmp	syscall_exit
+
+###################################################################################################
+#
+# system call handler
+#
+###################################################################################################
+ENTRY(system_call)
+	add	-4,sp
+	SAVE_ALL
+	mov	d0,(REG_ORIG_D0,fp)
+	GET_THREAD_INFO a2
+	cmp	nr_syscalls,d0
+	bcc	syscall_badsys
+	btst	_TIF_SYSCALL_TRACE,(TI_flags,a2)
+	bne	syscall_trace_entry
+syscall_call:
+	add	d0,d0,a1
+	add	a1,a1
+	mov	(REG_A0,fp),d0
+	mov	(sys_call_table,a1),a0
+	calls	(a0)
+	mov	d0,(REG_D0,fp)
+syscall_exit:
+	# make sure we don't miss an interrupt setting need_resched or
+	# sigpending between sampling and the rti
+	__cli
+	mov	(TI_flags,a2),d2
+	btst	_TIF_ALLWORK_MASK,d2
+	bne	syscall_exit_work
+restore_all:
+	RESTORE_ALL
+
+###################################################################################################
+#
+# perform work that needs to be done immediately before resumption and syscall tracing
+#
+###################################################################################################
+	ALIGN
+syscall_exit_work:
+	btst	_TIF_SYSCALL_TRACE,d2
+	beq	work_pending
+	__sti				# could let do_syscall_trace() call schedule() instead
+	mov	fp,d0
+	mov	1,d1
+	call	do_syscall_trace[],0	# do_syscall_trace(regs,entryexit)
+	jmp	resume_userspace
+
+	ALIGN
+work_pending:
+	btst	_TIF_NEED_RESCHED,d2
+	beq	work_notifysig
+
+work_resched:
+	call	schedule[],0
+
+	# make sure we don't miss an interrupt setting need_resched or
+	# sigpending between sampling and the rti
+	__cli
+
+	# is there any work to be done other than syscall tracing?
+	mov	(TI_flags,a2),d2
+	btst	_TIF_WORK_MASK,d2
+	beq	restore_all
+	btst	_TIF_NEED_RESCHED,d2
+	bne	work_resched
+
+work_notifysig:				# deal with pending signals and notify-resume requests
+	mov	fp,d0
+	mov	d2,d1
+	call	do_notify_resume[],0
+	jmp	resume_userspace
+
+	# perform syscall entry tracing
+syscall_trace_entry:
+	mov	-ENOSYS,d0
+	mov	d0,(REG_D0,fp)
+	mov	fp,d0
+	clr	d1
+	call	do_syscall_trace[],0
+	mov	(REG_ORIG_D0,fp),d0
+	mov	(REG_D1,fp),d1
+	cmp	nr_syscalls,d0
+	bcs	syscall_call
+	jmp	syscall_exit
+
+syscall_badsys:
+	mov	-ENOSYS,d0
+	mov	d0,(REG_D0,fp)
+	jmp	resume_userspace
+
+	# userspace resumption stub bypassing syscall exit tracing
+	.globl	ret_from_exception, ret_from_intr
+	ALIGN
+ret_from_exception:
+	preempt_stop
+ret_from_intr:
+	GET_THREAD_INFO a2
+	mov	(REG_EPSW,fp),d0	# need to deliver signals before returning to userspace
+	and	EPSW_nSL,d0
+	beq	resume_kernel		# returning to supervisor mode
+
+ENTRY(resume_userspace)
+	# make sure we don't miss an interrupt setting need_resched or
+	# sigpending between sampling and the rti
+	__cli
+
+	# is there any work to be done on int/exception return?
+	mov	(TI_flags,a2),d2
+	btst	_TIF_WORK_MASK,d2
+	bne	work_pending
+	jmp	restore_all
+
+#ifdef CONFIG_PREEMPT
+ENTRY(resume_kernel)
+	mov	(TI_preempt_count,a2),d0	# non-zero preempt_count ?
+	cmp	0,d0
+	bne	restore_all
+
+need_resched:
+	btst	_TIF_NEED_RESCHED,(TI_flags,a2)
+	beq	restore_all
+	mov	(REG_EPSW,fp),d0
+	and	EPSW_IM,d0
+	cmp	EPSW_IM_7,d0		# interrupts off (exception path) ?
+	beq	restore_all
+	call	preempt_schedule_irq[],0
+	jmp	need_resched
+#endif
+
+
+###################################################################################################
+#
+# IRQ handler entry point
+# - intended to be entered at multiple priorities
+#
+###################################################################################################
+ENTRY(irq_handler)
+	add	-4,sp
+	SAVE_ALL
+
+	# it's not a syscall
+	mov	0xffffffff,d0
+	mov	d0,(REG_ORIG_D0,fp)
+
+	mov	fp,d0
+	call	do_IRQ[],0			# do_IRQ(regs)
+
+	jmp	ret_from_intr
+
+###################################################################################################
+#
+# Monitor Signal handler entry point
+#
+###################################################################################################
+ENTRY(monitor_signal)
+	movbu	(0xae000001),d1
+	cmp	1,d1
+	beq	monsignal
+	ret	[],0
+
+monsignal:
+	or	EPSW_NMID,epsw
+	mov	d0,a0
+	mov	a0,sp
+	mov	(REG_EPSW,fp),d1
+	and	~EPSW_nSL,d1
+	mov	d1,(REG_EPSW,fp)
+	movm	(sp),[d2,d3,a2,a3,exreg0,exreg1,exother]
+	mov	(sp),a1
+	mov	a1,usp
+	movm	(sp),[other]
+	add	4,sp
+here:	jmp	0x8e000008-here+0x8e000008
+
+###################################################################################################
+#
+# Double Fault handler entry point
+# - note that there will not be a stack, D0/A0 will hold EPSW/PC as were
+#
+###################################################################################################
+	.section .bss
+	.balign	THREAD_SIZE
+	.space	THREAD_SIZE
+__df_stack:
+	.previous	
+
+ENTRY(double_fault)
+	mov	a0,(__df_stack-4)	# PC as was
+	mov	d0,(__df_stack-8)	# EPSW as was
+	mn10300_set_dbfleds		# display 'db-f' on the LEDs
+	mov	0xaa55aa55,d0
+	mov	d0,(__df_stack-12)	# no ORIG_D0
+	mov	sp,a0			# save corrupted SP
+	mov	__df_stack-12,sp	# emergency supervisor stack
+	SAVE_ALL
+	mov	a0,(REG_A0,fp)	# save corrupted SP as A0 (which got clobbered by the CPU)
+	mov	fp,d0
+	calls	do_double_fault
+double_fault_loop:
+	bra	double_fault_loop
+
+###################################################################################################
+#
+# Bus Error handler entry point
+# - handle external (async) bus errors separately
+#
+###################################################################################################
+ENTRY(raw_bus_error)
+	add	-4,sp
+	mov	d0,(sp)
+	mov	(BCBERR),d0		# what
+	btst	BCBERR_BEMR_DMA,d0	# see if it was an external bus error
+	beq	__common_exception_aux	# it wasn't
+
+	SAVE_ALL
+	mov	(BCBEAR),d1		# destination of erroneous access
+
+	mov	(REG_ORIG_D0,fp),d2
+	mov	d2,(REG_D0,fp)
+	mov	-1,d2
+	mov	d2,(REG_ORIG_D0,fp)
+
+	add	-4,sp
+	mov	fp,(12,sp)		# frame pointer
+	call	io_bus_error[],0
+	jmp	restore_all
+
+###################################################################################################
+#
+# Miscellaneous exception entry points
+#
+###################################################################################################
+ENTRY(nmi_handler)
+	add	-4,sp
+	mov	d0,(sp)
+	mov	(TBR),d0
+	bra	__common_exception_nonmi
+
+ENTRY(__common_exception)
+	add	-4,sp
+	mov	d0,(sp)
+
+__common_exception_aux:
+	mov	(TBR),d0
+	and	~EPSW_NMID,epsw		# turn non-maskable ints back on if not NMI
+	or	EPSW_IE,epsw
+
+__common_exception_nonmi:
+	and	0x0000FFFF,d0		# turn the exception code into a vector table index
+
+	btst	0x00000007,d0
+	bne	1f
+	cmp	0x00000400,d0
+	bge	1f
+
+	SAVE_ALL			# build the stack frame
+
+	mov	(REG_D0,fp),a2		# get the exception number
+	mov	(REG_ORIG_D0,fp),d0
+	mov	d0,(REG_D0,fp)
+	mov	-1,d0
+	mov	d0,(REG_ORIG_D0,fp)
+
+#ifdef CONFIG_GDBSTUB
+	btst	0x01,(gdbstub_busy)
+	beq	2f
+	and	~EPSW_IE,epsw
+	mov	fp,d0
+	mov	a2,d1
+	call	gdbstub_exception[],0	# gdbstub itself caused an exception
+	bra	restore_all
+2:
+#endif
+
+	mov	fp,d0			# arg 0: stacked register file
+	mov	a2,d1			# arg 1: exception number
+	lsr	1,a2
+
+	mov	(exception_table,a2),a2
+	calls	(a2)
+	jmp	ret_from_exception
+
+1:	pi				# BUG() equivalent
+
+###################################################################################################
+#
+# Exception handler functions table
+#
+###################################################################################################
+	.data
+ENTRY(exception_table)
+	.rept	0x400>>1
+	 .long	uninitialised_exception
+	.endr
+	.previous
+
+###################################################################################################
+#
+# Change an entry in the exception table
+# - D0 exception code, D1 handler
+#
+###################################################################################################
+ENTRY(set_excp_vector)
+	lsr	1,d0
+	add	exception_table,d0
+	mov	d1,(d0)
+	mov	4,d1
+#if defined(CONFIG_MN10300_CACHE_WBACK)
+	jmp	mn10300_dcache_flush_inv_range2
+#else
+	ret	[],0
+#endif
+
+###################################################################################################
+#
+# System call table
+#
+###################################################################################################
+	.data
+ENTRY(sys_call_table)
+	.long sys_restart_syscall	/* 0 - old "setup()" system call, used for restarting */
+	.long sys_exit
+	.long sys_fork
+	.long sys_read
+	.long sys_write
+	.long sys_open		/* 5 */
+	.long sys_close
+	.long sys_waitpid
+	.long sys_creat
+	.long sys_link
+	.long sys_unlink	/* 10 */
+	.long sys_execve
+	.long sys_chdir
+	.long sys_time
+	.long sys_mknod
+	.long sys_chmod		/* 15 */
+	.long sys_lchown16
+	.long sys_ni_syscall	/* old break syscall holder */
+	.long sys_stat
+	.long sys_lseek
+	.long sys_getpid	/* 20 */
+	.long sys_mount
+	.long sys_oldumount
+	.long sys_setuid16
+	.long sys_getuid16
+	.long sys_stime		/* 25 */
+	.long sys_ptrace
+	.long sys_alarm
+	.long sys_fstat
+	.long sys_pause
+	.long sys_utime		/* 30 */
+	.long sys_ni_syscall	/* old stty syscall holder */
+	.long sys_ni_syscall	/* old gtty syscall holder */
+	.long sys_access
+	.long sys_nice
+	.long sys_ni_syscall	/* 35 - old ftime syscall holder */
+	.long sys_sync
+	.long sys_kill
+	.long sys_rename
+	.long sys_mkdir
+	.long sys_rmdir		/* 40 */
+	.long sys_dup
+	.long sys_pipe
+	.long sys_times
+	.long sys_ni_syscall	/* old prof syscall holder */
+	.long sys_brk		/* 45 */
+	.long sys_setgid16
+	.long sys_getgid16
+	.long sys_signal
+	.long sys_geteuid16
+	.long sys_getegid16	/* 50 */
+	.long sys_acct
+	.long sys_umount	/* recycled never used phys() */
+	.long sys_ni_syscall	/* old lock syscall holder */
+	.long sys_ioctl
+	.long sys_fcntl		/* 55 */
+	.long sys_ni_syscall	/* old mpx syscall holder */
+	.long sys_setpgid
+	.long sys_ni_syscall	/* old ulimit syscall holder */
+	.long sys_ni_syscall	/* old sys_olduname */
+	.long sys_umask		/* 60 */
+	.long sys_chroot
+	.long sys_ustat
+	.long sys_dup2
+	.long sys_getppid
+	.long sys_getpgrp	/* 65 */
+	.long sys_setsid
+	.long sys_sigaction
+	.long sys_sgetmask
+	.long sys_ssetmask
+	.long sys_setreuid16	/* 70 */
+	.long sys_setregid16
+	.long sys_sigsuspend
+	.long sys_sigpending
+	.long sys_sethostname
+	.long sys_setrlimit	/* 75 */
+	.long sys_old_getrlimit
+	.long sys_getrusage
+	.long sys_gettimeofday
+	.long sys_settimeofday
+	.long sys_getgroups16	/* 80 */
+	.long sys_setgroups16
+	.long old_select
+	.long sys_symlink
+	.long sys_lstat
+	.long sys_readlink	/* 85 */
+	.long sys_uselib
+	.long sys_swapon
+	.long sys_reboot
+	.long old_readdir
+	.long old_mmap		/* 90 */
+	.long sys_munmap
+	.long sys_truncate
+	.long sys_ftruncate
+	.long sys_fchmod
+	.long sys_fchown16	/* 95 */
+	.long sys_getpriority
+	.long sys_setpriority
+	.long sys_ni_syscall	/* old profil syscall holder */
+	.long sys_statfs
+	.long sys_fstatfs	/* 100 */
+	.long sys_ni_syscall	/* ioperm */
+	.long sys_socketcall
+	.long sys_syslog
+	.long sys_setitimer
+	.long sys_getitimer	/* 105 */
+	.long sys_newstat
+	.long sys_newlstat
+	.long sys_newfstat
+	.long sys_ni_syscall	/* old sys_uname */
+	.long sys_ni_syscall	/* 110 - iopl */
+	.long sys_vhangup
+	.long sys_ni_syscall	/* old "idle" system call */
+	.long sys_ni_syscall	/* vm86old */
+	.long sys_wait4
+	.long sys_swapoff	/* 115 */
+	.long sys_sysinfo
+	.long sys_ipc
+	.long sys_fsync
+	.long sys_sigreturn
+	.long sys_clone		/* 120 */
+	.long sys_setdomainname
+	.long sys_newuname
+	.long sys_ni_syscall	/* modify_ldt */
+	.long sys_adjtimex
+	.long sys_mprotect	/* 125 */
+	.long sys_sigprocmask
+	.long sys_ni_syscall	/* old "create_module" */
+	.long sys_init_module
+	.long sys_delete_module
+	.long sys_ni_syscall	/* 130:	old "get_kernel_syms" */
+	.long sys_quotactl
+	.long sys_getpgid
+	.long sys_fchdir
+	.long sys_bdflush
+	.long sys_sysfs		/* 135 */
+	.long sys_personality
+	.long sys_ni_syscall	/* reserved for afs_syscall */
+	.long sys_setfsuid16
+	.long sys_setfsgid16
+	.long sys_llseek	/* 140 */
+	.long sys_getdents
+	.long sys_select
+	.long sys_flock
+	.long sys_msync
+	.long sys_readv		/* 145 */
+	.long sys_writev
+	.long sys_getsid
+	.long sys_fdatasync
+	.long sys_sysctl
+	.long sys_mlock		/* 150 */
+	.long sys_munlock
+	.long sys_mlockall
+	.long sys_munlockall
+	.long sys_sched_setparam
+	.long sys_sched_getparam   /* 155 */
+	.long sys_sched_setscheduler
+	.long sys_sched_getscheduler
+	.long sys_sched_yield
+	.long sys_sched_get_priority_max
+	.long sys_sched_get_priority_min  /* 160 */
+	.long sys_sched_rr_get_interval
+	.long sys_nanosleep
+	.long sys_mremap
+	.long sys_setresuid16
+	.long sys_getresuid16	/* 165 */
+	.long sys_ni_syscall	/* vm86 */
+	.long sys_ni_syscall	/* Old sys_query_module */
+	.long sys_poll
+	.long sys_nfsservctl
+	.long sys_setresgid16	/* 170 */
+	.long sys_getresgid16
+	.long sys_prctl
+	.long sys_rt_sigreturn
+	.long sys_rt_sigaction
+	.long sys_rt_sigprocmask	/* 175 */
+	.long sys_rt_sigpending
+	.long sys_rt_sigtimedwait
+	.long sys_rt_sigqueueinfo
+	.long sys_rt_sigsuspend
+	.long sys_pread64	/* 180 */
+	.long sys_pwrite64
+	.long sys_chown16
+	.long sys_getcwd
+	.long sys_capget
+	.long sys_capset	/* 185 */
+	.long sys_sigaltstack
+	.long sys_sendfile
+	.long sys_ni_syscall	/* reserved for streams1 */
+	.long sys_ni_syscall	/* reserved for streams2 */
+	.long sys_vfork		/* 190 */
+	.long sys_getrlimit
+	.long sys_mmap2
+	.long sys_truncate64
+	.long sys_ftruncate64
+	.long sys_stat64	/* 195 */
+	.long sys_lstat64
+	.long sys_fstat64
+	.long sys_lchown
+	.long sys_getuid
+	.long sys_getgid	/* 200 */
+	.long sys_geteuid
+	.long sys_getegid
+	.long sys_setreuid
+	.long sys_setregid
+	.long sys_getgroups	/* 205 */
+	.long sys_setgroups
+	.long sys_fchown
+	.long sys_setresuid
+	.long sys_getresuid
+	.long sys_setresgid	/* 210 */
+	.long sys_getresgid
+	.long sys_chown
+	.long sys_setuid
+	.long sys_setgid
+	.long sys_setfsuid	/* 215 */
+	.long sys_setfsgid
+	.long sys_pivot_root
+	.long sys_mincore
+	.long sys_madvise
+	.long sys_getdents64	/* 220 */
+	.long sys_fcntl64
+	.long sys_ni_syscall	/* reserved for TUX */
+	.long sys_ni_syscall
+	.long sys_gettid
+	.long sys_readahead	/* 225 */
+	.long sys_setxattr
+	.long sys_lsetxattr
+	.long sys_fsetxattr
+	.long sys_getxattr
+	.long sys_lgetxattr	/* 230 */
+	.long sys_fgetxattr
+	.long sys_listxattr
+	.long sys_llistxattr
+	.long sys_flistxattr
+	.long sys_removexattr	/* 235 */
+	.long sys_lremovexattr
+	.long sys_fremovexattr
+	.long sys_tkill
+	.long sys_sendfile64
+	.long sys_futex		/* 240 */
+	.long sys_sched_setaffinity
+	.long sys_sched_getaffinity
+	.long sys_ni_syscall	/* sys_set_thread_area */
+	.long sys_ni_syscall	/* sys_get_thread_area */
+	.long sys_io_setup	/* 245 */
+	.long sys_io_destroy
+	.long sys_io_getevents
+	.long sys_io_submit
+	.long sys_io_cancel
+	.long sys_fadvise64	/* 250 */
+	.long sys_ni_syscall
+	.long sys_exit_group
+	.long sys_lookup_dcookie
+	.long sys_epoll_create
+	.long sys_epoll_ctl	/* 255 */
+	.long sys_epoll_wait
+ 	.long sys_remap_file_pages
+ 	.long sys_set_tid_address
+ 	.long sys_timer_create
+ 	.long sys_timer_settime		/* 260 */
+ 	.long sys_timer_gettime
+ 	.long sys_timer_getoverrun
+ 	.long sys_timer_delete
+ 	.long sys_clock_settime
+ 	.long sys_clock_gettime		/* 265 */
+ 	.long sys_clock_getres
+ 	.long sys_clock_nanosleep
+	.long sys_statfs64
+	.long sys_fstatfs64
+	.long sys_tgkill		/* 270 */
+	.long sys_utimes
+ 	.long sys_fadvise64_64
+	.long sys_ni_syscall	/* sys_vserver */
+	.long sys_mbind
+	.long sys_get_mempolicy		/* 275 */
+	.long sys_set_mempolicy
+	.long sys_mq_open
+	.long sys_mq_unlink
+	.long sys_mq_timedsend
+	.long sys_mq_timedreceive	/* 280 */
+	.long sys_mq_notify
+	.long sys_mq_getsetattr
+	.long sys_kexec_load
+	.long sys_waitid
+	.long sys_ni_syscall		/* 285 */ /* available */
+	.long sys_add_key
+	.long sys_request_key
+	.long sys_keyctl
+	.long sys_cacheflush
+	.long sys_ioprio_set		/* 290 */
+	.long sys_ioprio_get
+	.long sys_inotify_init
+	.long sys_inotify_add_watch
+	.long sys_inotify_rm_watch
+	.long sys_migrate_pages		/* 295 */
+	.long sys_openat
+	.long sys_mkdirat
+	.long sys_mknodat
+	.long sys_fchownat
+	.long sys_futimesat		/* 300 */
+	.long sys_fstatat64
+	.long sys_unlinkat
+	.long sys_renameat
+	.long sys_linkat
+	.long sys_symlinkat		/* 305 */
+	.long sys_readlinkat
+	.long sys_fchmodat
+	.long sys_faccessat
+	.long sys_pselect6
+	.long sys_ppoll			/* 310 */
+	.long sys_unshare
+	.long sys_set_robust_list
+	.long sys_get_robust_list
+	.long sys_splice
+	.long sys_sync_file_range	/* 315 */
+	.long sys_tee
+	.long sys_vmsplice
+	.long sys_move_pages
+	.long sys_getcpu
+	.long sys_epoll_pwait		/* 320 */
+	.long sys_utimensat
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
+	.long sys_fallocate		/* 325 */
+
+
+nr_syscalls=(.-sys_call_table)/4
diff -puN /dev/null arch/mn10300/kernel/fpu.c
--- /dev/null
+++ a/arch/mn10300/kernel/fpu.c
@@ -0,0 +1,219 @@
+/* MN10300 FPU management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/uaccess.h>
+#include <asm/fpu.h>
+#include <asm/elf.h>
+#include <asm/exceptions.h>
+
+struct task_struct * volatile fpu_state_owner = NULL;
+
+/*
+ * handle an exception due to the FPU being disabled
+ */
+asmlinkage void fpu_disabled(struct pt_regs *regs, exception_code_t code)
+{
+	struct task_struct *tsk = current;
+
+	if (!user_mode(regs))
+		die_if_no_fixup("An FPU Disabled exception happened in"
+				" kernel space\n",
+				regs, code);
+
+#ifdef CONFIG_FPU
+	preempt_disable();
+
+	/* transfer the last process's FPU state to memory */
+	if (fpu_state_owner) {
+		fpu_save(&fpu_state_owner->thread.fpu_state);
+		fpu_state_owner->thread.uregs->epsw &= ~EPSW_FE;
+	}
+
+	/* the current process now owns the FPU state */
+	fpu_state_owner = tsk;
+	regs->epsw |= EPSW_FE;
+
+	/* load the FPU with the current process's FPU state or invent a new
+	 * clean one if the process doesn't have one */
+	if (is_using_fpu(tsk)) {
+		fpu_restore(&tsk->thread.fpu_state);
+	} else {
+		fpu_init_state();
+		set_using_fpu(tsk);
+	}
+
+	preempt_enable();
+#else
+	{
+		siginfo_t info;
+
+		info.si_signo = SIGFPE;
+		info.si_errno = 0;
+		info.si_addr = (void *) tsk->thread.uregs->pc;
+		info.si_code = FPE_FLTINV;
+
+		force_sig_info(SIGFPE, &info, tsk);
+	}
+#endif  /* CONFIG_FPU */
+}
+
+/*
+ * handle an FPU operational exception
+ * - there's a possibility that if the FPU is asynchronous, the signal might
+ *   be meant for a process other than the current one
+ */
+asmlinkage void fpu_exception(struct pt_regs *regs, exception_code_t code)
+{
+	struct task_struct *tsk = fpu_state_owner;
+	siginfo_t info;
+
+	if (!user_mode(regs))
+		die_if_no_fixup("An FPU Operation exception happened in"
+				" kernel space\n",
+				regs, code);
+
+	if (!tsk)
+		die_if_no_fixup("An FPU Operation exception happened,"
+				" but the FPU is not in use",
+				regs, code);
+
+	info.si_signo = SIGFPE;
+	info.si_errno = 0;
+	info.si_addr = (void *) tsk->thread.uregs->pc;
+	info.si_code = FPE_FLTINV;
+
+#ifdef CONFIG_FPU
+	{
+		u32 fpcr;
+
+		/* get FPCR (we need to enable the FPU whilst we do this) */
+		asm volatile("	or	%1,epsw		\n"
+#ifdef CONFIG_MN10300_PROC_MN103E010
+			     "	nop			\n"
+			     "	nop			\n"
+			     "	nop			\n"
+#endif
+			     "	fmov	fpcr,%0		\n"
+#ifdef CONFIG_MN10300_PROC_MN103E010
+			     "	nop			\n"
+			     "	nop			\n"
+			     "	nop			\n"
+#endif
+			     "	and	%2,epsw		\n"
+			     : "=&d"(fpcr)
+			     : "i"(EPSW_FE), "i"(~EPSW_FE)
+		    	);
+
+		if	(fpcr & FPCR_EC_Z)	info.si_code = FPE_FLTDIV;
+		else if	(fpcr & FPCR_EC_O)	info.si_code = FPE_FLTOVF;
+		else if	(fpcr & FPCR_EC_U)	info.si_code = FPE_FLTUND;
+		else if	(fpcr & FPCR_EC_I)	info.si_code = FPE_FLTRES;
+	}
+#endif
+
+	force_sig_info(SIGFPE, &info, tsk);
+}
+
+/*
+ * save the FPU state to a signal context
+ */
+int fpu_setup_sigcontext(struct fpucontext *fpucontext)
+{
+#ifdef CONFIG_FPU
+	struct task_struct *tsk = current;
+
+	if (!is_using_fpu(tsk))
+		return 0;
+
+	/* transfer the current FPU state to memory and cause fpu_init() to be
+	 * triggered by the next attempted FPU operation by the current
+	 * process.
+	 */
+	preempt_disable();
+
+	if (fpu_state_owner == tsk) {
+		fpu_save(&tsk->thread.fpu_state);
+		fpu_state_owner->thread.uregs->epsw &= ~EPSW_FE;
+		fpu_state_owner = NULL;
+	}
+
+	preempt_enable();
+
+	/* we no longer have a valid current FPU state */
+	clear_using_fpu(tsk);
+
+	/* transfer the saved FPU state onto the userspace stack */
+	if (copy_to_user(fpucontext,
+			 &tsk->thread.fpu_state,
+			 min(sizeof(struct fpu_state_struct),
+			     sizeof(struct fpucontext))))
+		return -1;
+
+	return 1;
+#else
+	return 0;
+#endif
+}
+
+/*
+ * kill a process's FPU state during restoration after signal handling
+ */
+void fpu_kill_state(struct task_struct *tsk)
+{
+#ifdef CONFIG_FPU
+	/* disown anything left in the FPU */
+	preempt_disable();
+
+	if (fpu_state_owner == tsk) {
+		fpu_state_owner->thread.uregs->epsw &= ~EPSW_FE;
+		fpu_state_owner = NULL;
+	}
+
+	preempt_enable();
+#endif
+	/* we no longer have a valid current FPU state */
+	clear_using_fpu(tsk);
+}
+
+/*
+ * restore the FPU state from a signal context
+ */
+int fpu_restore_sigcontext(struct fpucontext *fpucontext)
+{
+	struct task_struct *tsk = current;
+	int ret;
+
+	/* load up the old FPU state */
+	ret = copy_from_user(&tsk->thread.fpu_state,
+			     fpucontext,
+			     min(sizeof(struct fpu_state_struct),
+				 sizeof(struct fpucontext)));
+	if (!ret)
+		set_using_fpu(tsk);
+
+	return ret;
+}
+
+/*
+ * fill in the FPU structure for a core dump
+ */
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpreg)
+{
+	struct task_struct *tsk = current;
+	int fpvalid;
+
+	fpvalid = is_using_fpu(tsk);
+	if (fpvalid) {
+		unlazy_fpu(tsk);
+		memcpy(fpreg, &tsk->thread.fpu_state, sizeof(*fpreg));
+	}
+
+	return fpvalid;
+}
diff -puN /dev/null arch/mn10300/kernel/fpu-low.S
--- /dev/null
+++ a/arch/mn10300/kernel/fpu-low.S
@@ -0,0 +1,197 @@
+/* MN10300 Low level FPU management operations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/cpu-regs.h>
+
+###############################################################################
+#
+# void fpu_init_state(void)
+# - initialise the FPU
+#
+###############################################################################
+	.globl	fpu_init_state
+	.type	fpu_init_state,@function
+fpu_init_state:
+	mov	epsw,d0
+	or	EPSW_FE,epsw
+
+#ifdef CONFIG_MN10300_PROC_MN103E010
+	nop
+	nop
+	nop
+#endif
+	fmov	0,fs0
+	fmov	fs0,fs1
+	fmov	fs0,fs2
+	fmov	fs0,fs3
+	fmov	fs0,fs4
+	fmov	fs0,fs5
+	fmov	fs0,fs6
+	fmov	fs0,fs7
+	fmov	fs0,fs8
+	fmov	fs0,fs9
+	fmov	fs0,fs10
+	fmov	fs0,fs11
+	fmov	fs0,fs12
+	fmov	fs0,fs13
+	fmov	fs0,fs14
+	fmov	fs0,fs15
+	fmov	fs0,fs16
+	fmov	fs0,fs17
+	fmov	fs0,fs18
+	fmov	fs0,fs19
+	fmov	fs0,fs20
+	fmov	fs0,fs21
+	fmov	fs0,fs22
+	fmov	fs0,fs23
+	fmov	fs0,fs24
+	fmov	fs0,fs25
+	fmov	fs0,fs26
+	fmov	fs0,fs27
+	fmov	fs0,fs28
+	fmov	fs0,fs29
+	fmov	fs0,fs30
+	fmov	fs0,fs31
+	fmov	FPCR_INIT,fpcr
+
+#ifdef CONFIG_MN10300_PROC_MN103E010
+	nop
+	nop
+	nop
+#endif
+	mov	d0,epsw
+	ret	[],0
+
+	.size	fpu_init_state,.-fpu_init_state
+
+###############################################################################
+#
+# void fpu_save(struct fpu_state_struct *)
+# - save the fpu state
+# - note that an FPU Operational exception might occur during this process
+#
+###############################################################################
+	.globl	fpu_save
+	.type	fpu_save,@function
+fpu_save:
+	mov	epsw,d1
+	or	EPSW_FE,epsw		/* enable the FPU so we can access it */
+
+#ifdef CONFIG_MN10300_PROC_MN103E010
+	nop
+	nop
+#endif
+	mov	d0,a0
+	fmov	fs0,(a0+)
+	fmov	fs1,(a0+)
+	fmov	fs2,(a0+)
+	fmov	fs3,(a0+)
+	fmov	fs4,(a0+)
+	fmov	fs5,(a0+)
+	fmov	fs6,(a0+)
+	fmov	fs7,(a0+)
+	fmov	fs8,(a0+)
+	fmov	fs9,(a0+)
+	fmov	fs10,(a0+)
+	fmov	fs11,(a0+)
+	fmov	fs12,(a0+)
+	fmov	fs13,(a0+)
+	fmov	fs14,(a0+)
+	fmov	fs15,(a0+)
+	fmov	fs16,(a0+)
+	fmov	fs17,(a0+)
+	fmov	fs18,(a0+)
+	fmov	fs19,(a0+)
+	fmov	fs20,(a0+)
+	fmov	fs21,(a0+)
+	fmov	fs22,(a0+)
+	fmov	fs23,(a0+)
+	fmov	fs24,(a0+)
+	fmov	fs25,(a0+)
+	fmov	fs26,(a0+)
+	fmov	fs27,(a0+)
+	fmov	fs28,(a0+)
+	fmov	fs29,(a0+)
+	fmov	fs30,(a0+)
+	fmov	fs31,(a0+)
+	fmov	fpcr,d0
+	mov	d0,(a0)
+#ifdef CONFIG_MN10300_PROC_MN103E010
+	nop
+	nop
+#endif
+
+	mov	d1,epsw
+	ret	[],0
+
+	.size	fpu_save,.-fpu_save
+
+###############################################################################
+#
+# void fpu_restore(struct fpu_state_struct *)
+# - restore the fpu state
+# - note that an FPU Operational exception might occur during this process
+#
+###############################################################################
+	.globl	fpu_restore
+	.type	fpu_restore,@function
+fpu_restore:
+	mov	epsw,d1
+	or	EPSW_FE,epsw		/* enable the FPU so we can access it */
+
+#ifdef CONFIG_MN10300_PROC_MN103E010
+	nop
+	nop
+#endif
+	mov	d0,a0
+	fmov	(a0+),fs0
+	fmov	(a0+),fs1
+	fmov	(a0+),fs2
+	fmov	(a0+),fs3
+	fmov	(a0+),fs4
+	fmov	(a0+),fs5
+	fmov	(a0+),fs6
+	fmov	(a0+),fs7
+	fmov	(a0+),fs8
+	fmov	(a0+),fs9
+	fmov	(a0+),fs10
+	fmov	(a0+),fs11
+	fmov	(a0+),fs12
+	fmov	(a0+),fs13
+	fmov	(a0+),fs14
+	fmov	(a0+),fs15
+	fmov	(a0+),fs16
+	fmov	(a0+),fs17
+	fmov	(a0+),fs18
+	fmov	(a0+),fs19
+	fmov	(a0+),fs20
+	fmov	(a0+),fs21
+	fmov	(a0+),fs22
+	fmov	(a0+),fs23
+	fmov	(a0+),fs24
+	fmov	(a0+),fs25
+	fmov	(a0+),fs26
+	fmov	(a0+),fs27
+	fmov	(a0+),fs28
+	fmov	(a0+),fs29
+	fmov	(a0+),fs30
+	fmov	(a0+),fs31
+	mov	(a0),d0
+	fmov	d0,fpcr
+#ifdef CONFIG_MN10300_PROC_MN103E010
+	nop
+	nop
+	nop
+#endif
+
+	mov	d1,epsw
+	ret	[],0
+
+	.size	fpu_restore,.-fpu_restore
diff -puN /dev/null arch/mn10300/kernel/gdb-cache.S
--- /dev/null
+++ a/arch/mn10300/kernel/gdb-cache.S
@@ -0,0 +1,102 @@
+###############################################################################
+#
+# MN10300 Low-level cache purging routines for gdbstub
+#
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/cache.h>
+#include <asm/cpu-regs.h>
+#include <asm/exceptions.h>
+#include <asm/frame.inc>
+#include <asm/serial-regs.h>
+
+	.text
+
+###################################################################################################
+#
+# GDB stub cache purge
+#
+###################################################################################################
+	.type	gdbstub_purge_cache,@function
+ENTRY(gdbstub_purge_cache)
+	#######################################################################
+	# read the addresses tagged in the cache's tag RAM and attempt to flush
+	# those addresses specifically
+	# - we rely on the hardware to filter out invalid tag entry addresses
+	mov	DCACHE_TAG(0,0),a0		# dcache tag RAM access address
+	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
+	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1	# total number of entries
+
+mn10300_dcache_flush_loop:
+	mov	(a0),d0
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0
+	or	L1_CACHE_TAG_VALID,d0		# retain valid entries in the cache
+	mov	d0,(a1)				# conditional purge
+
+mn10300_dcache_flush_skip:
+	add	L1_CACHE_BYTES,a0
+	add	L1_CACHE_BYTES,a1
+	add	-1,d1
+	bne	mn10300_dcache_flush_loop
+
+;; 	# unconditionally flush and invalidate the dcache
+;; 	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
+;; 	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1	# total number of entries
+
+;; gdbstub_purge_cache__dcache_loop:
+;; 	mov	(a1),d0				# unconditional purge
+
+;; 	add	L1_CACHE_BYTES,a1
+;; 	add	-1,d1
+;; 	bne	gdbstub_purge_cache__dcache_loop
+
+	#######################################################################
+	# now invalidate the icache
+	mov	CHCTR,a0
+	movhu	(a0),a1
+
+	mov	epsw,d1
+	and	~EPSW_IE,epsw
+	nop
+	nop
+
+	# disable the icache
+	and	~CHCTR_ICEN,d0
+	movhu	d0,(a0)
+
+	# and wait for it to calm down
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_ICBUSY,d0
+	lne
+
+	# invalidate
+	or	CHCTR_ICINV,d0
+	movhu	d0,(a0)
+
+	# wait for the cache to finish
+	mov	CHCTR,a0
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_ICBUSY,d0
+	lne
+
+	# and reenable it
+	movhu	a1,(a0)
+	movhu	(a0),d0			# read back to flush (SIGILLs all over without this)
+
+	mov	d1,epsw
+
+	ret	[],0
+
+	.size	gdbstub_purge_cache,.-gdbstub_purge_cache
diff -puN /dev/null arch/mn10300/kernel/gdb-io-serial.c
--- /dev/null
+++ a/arch/mn10300/kernel/gdb-io-serial.c
@@ -0,0 +1,154 @@
+/* 16550 serial driver for gdbstub I/O
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/nmi.h>
+
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/gdb-stub.h>
+#include <asm/exceptions.h>
+#include <asm/serial-regs.h>
+#include <asm/unit/serial.h>
+
+/*
+ * initialise the GDB stub
+ */
+void gdbstub_io_init(void)
+{
+	u16 tmp;
+
+	/* set up the serial port */
+	GDBPORT_SERIAL_LCR = UART_LCR_WLEN8; /* 1N8 */
+	GDBPORT_SERIAL_FCR = UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT;
+
+	FLOWCTL_CLEAR(DTR);
+	FLOWCTL_SET(RTS);
+
+	gdbstub_io_set_baud(115200);
+
+	/* we want to get serial receive interrupts */
+	XIRQxICR(GDBPORT_SERIAL_IRQ) = 0;
+	tmp = XIRQxICR(GDBPORT_SERIAL_IRQ);
+
+	IVAR0 = EXCEP_IRQ_LEVEL0;
+	set_intr_stub(EXCEP_IRQ_LEVEL0, gdbstub_io_rx_handler);
+
+	XIRQxICR(GDBPORT_SERIAL_IRQ) &= ~GxICR_REQUEST;
+	XIRQxICR(GDBPORT_SERIAL_IRQ) = GxICR_ENABLE | GxICR_LEVEL_0;
+	tmp = XIRQxICR(GDBPORT_SERIAL_IRQ);
+
+	GDBPORT_SERIAL_IER = UART_IER_RDI | UART_IER_RLSI;
+
+	/* permit level 0 IRQs to take place */
+	asm volatile(
+		"	and %0,epsw	\n"
+		"	or %1,epsw	\n"
+		:
+		: "i"(~EPSW_IM), "i"(EPSW_IE | EPSW_IM_1)
+		);
+}
+
+/*
+ * set up the GDB stub serial port baud rate timers
+ */
+void gdbstub_io_set_baud(unsigned baud)
+{
+	unsigned value;
+	u8 lcr;
+
+	value = 18432000 / 16 / baud;
+
+	lcr = GDBPORT_SERIAL_LCR;
+	GDBPORT_SERIAL_LCR |= UART_LCR_DLAB;
+	GDBPORT_SERIAL_DLL = value & 0xff;
+	GDBPORT_SERIAL_DLM = (value >> 8) & 0xff;
+	GDBPORT_SERIAL_LCR = lcr;
+}
+
+/*
+ * wait for a character to come from the debugger
+ */
+int gdbstub_io_rx_char(unsigned char *_ch, int nonblock)
+{
+	unsigned ix;
+	u8 ch, st;
+
+	*_ch = 0xff;
+
+	if (gdbstub_rx_unget) {
+		*_ch = gdbstub_rx_unget;
+		gdbstub_rx_unget = 0;
+		return 0;
+	}
+
+ try_again:
+	/* pull chars out of the buffer */
+	ix = gdbstub_rx_outp;
+	if (ix == gdbstub_rx_inp) {
+		if (nonblock)
+			return -EAGAIN;
+#ifdef CONFIG_MN10300_WD_TIMER
+		watchdog_alert_counter = 0;
+#endif /* CONFIG_MN10300_WD_TIMER */
+		goto try_again;
+	}
+
+	ch = gdbstub_rx_buffer[ix++];
+	st = gdbstub_rx_buffer[ix++];
+	gdbstub_rx_outp = ix & 0x00000fff;
+
+	if (st & UART_LSR_BI) {
+		gdbstub_proto("### GDB Rx Break Detected ###\n");
+		return -EINTR;
+	} else if (st & (UART_LSR_FE | UART_LSR_OE | UART_LSR_PE)) {
+		gdbstub_proto("### GDB Rx Error (st=%02x) ###\n", st);
+		return -EIO;
+	} else {
+		gdbstub_proto("### GDB Rx %02x (st=%02x) ###\n", ch, st);
+		*_ch = ch & 0x7f;
+		return 0;
+	}
+}
+
+/*
+ * send a character to the debugger
+ */
+void gdbstub_io_tx_char(unsigned char ch)
+{
+	FLOWCTL_SET(DTR);
+	LSR_WAIT_FOR(THRE);
+//	FLOWCTL_WAIT_FOR(CTS);
+
+	if (ch==0x0a) {
+		GDBPORT_SERIAL_TX = 0x0d;
+		LSR_WAIT_FOR(THRE);
+//		FLOWCTL_WAIT_FOR(CTS);
+	}
+	GDBPORT_SERIAL_TX = ch;
+
+	FLOWCTL_CLEAR(DTR);
+}
+
+/*
+ * send a character to the debugger
+ */
+void gdbstub_io_tx_flush(void)
+{
+	LSR_WAIT_FOR(TEMT);
+	LSR_WAIT_FOR(THRE);
+	FLOWCTL_CLEAR(DTR);
+}
diff -puN /dev/null arch/mn10300/kernel/gdb-io-serial-low.S
--- /dev/null
+++ a/arch/mn10300/kernel/gdb-io-serial-low.S
@@ -0,0 +1,90 @@
+###############################################################################
+#
+# 16550 serial Rx interrupt handler for gdbstub I/O
+#
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/cpu-regs.h>
+#include <asm/thread_info.h>
+#include <asm/frame.inc>
+#include <asm/intctl-regs.h>
+#include <asm/unit/serial.h>
+
+	.text
+
+###################################################################################################
+#
+# GDB stub serial receive interrupt entry point
+# - intended to run at interrupt priority 0
+#
+###################################################################################################
+	.globl	gdbstub_io_rx_handler
+	.type	gdbstub_io_rx_handler,@function
+gdbstub_io_rx_handler:
+	movm	[d2,d3,a2,a3],(sp)
+
+#if 1
+	movbu	(GDBPORT_SERIAL_IIR),d2
+#endif
+
+	mov	(gdbstub_rx_inp),a3
+gdbstub_io_rx_more:
+	mov	a3,a2
+	add	2,a3
+	and	0x00000fff,a3
+	mov	(gdbstub_rx_outp),d3
+	cmp	a3,d3
+	beq	gdbstub_io_rx_overflow
+
+	movbu	(GDBPORT_SERIAL_LSR),d3
+	btst	UART_LSR_DR,d3
+	beq	gdbstub_io_rx_done
+	movbu	(GDBPORT_SERIAL_RX),d2
+	movbu	d3,(gdbstub_rx_buffer+1,a2)
+	movbu	d2,(gdbstub_rx_buffer,a2)
+	mov	a3,(gdbstub_rx_inp)
+	bra	gdbstub_io_rx_more
+
+gdbstub_io_rx_done:
+	mov	GxICR_DETECT,d2
+	movbu	d2,(XIRQxICR(GDBPORT_SERIAL_IRQ))	# ACK the interrupt
+	movhu	(XIRQxICR(GDBPORT_SERIAL_IRQ)),d2	# flush
+	movm	(sp),[d2,d3,a2,a3]
+	bset	0x01,(gdbstub_busy)
+	beq	gdbstub_io_rx_enter
+	rti
+
+gdbstub_io_rx_overflow:
+	bset	0x01,(gdbstub_rx_overflow)
+	bra	gdbstub_io_rx_done
+
+gdbstub_io_rx_enter:
+	or	EPSW_IE|EPSW_IM_1,epsw
+	add	-4,sp
+	SAVE_ALL
+
+	mov	0xffffffff,d0
+	mov	d0,(REG_ORIG_D0,fp)
+	mov	0x280,d1
+
+	mov	fp,d0
+	call	gdbstub_rx_irq[],0	# gdbstub_rx_irq(regs,excep)
+
+	and	~EPSW_IE,epsw
+	bclr	0x01,(gdbstub_busy)
+
+	.globl gdbstub_return
+gdbstub_return:
+	RESTORE_ALL
+
+	.size	gdbstub_io_rx_handler,.-gdbstub_io_rx_handler
diff -puN /dev/null arch/mn10300/kernel/gdb-io-ttysm.c
--- /dev/null
+++ a/arch/mn10300/kernel/gdb-io-ttysm.c
@@ -0,0 +1,297 @@
+/* MN10300 On-chip serial driver for gdbstub I/O
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/tty.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/gdb-stub.h>
+#include <asm/exceptions.h>
+#include <asm/unit/clock.h>
+#include "mn10300-serial.h"
+
+#if defined(CONFIG_GDBSTUB_ON_TTYSM0)
+struct mn10300_serial_port *const gdbstub_port = &mn10300_serial_port_sif0;
+#elif defined(CONFIG_GDBSTUB_ON_TTYSM1)
+struct mn10300_serial_port *const gdbstub_port = &mn10300_serial_port_sif1;
+#else
+struct mn10300_serial_port *const gdbstub_port = &mn10300_serial_port_sif2;
+#endif
+
+
+/*
+ * initialise the GDB stub I/O routines
+ */
+void __init gdbstub_io_init(void)
+{
+	uint16_t scxctr;
+	int tmp;
+
+	switch (gdbstub_port->clock_src) {
+	case MNSCx_CLOCK_SRC_IOCLK:
+		gdbstub_port->ioclk = MN10300_IOCLK;
+		break;
+
+#ifdef MN10300_IOBCLK
+	case MNSCx_CLOCK_SRC_IOBCLK:
+		gdbstub_port->ioclk = MN10300_IOBCLK;
+		break;
+#endif
+	default:
+		BUG();
+	}
+
+	/* set up the serial port */
+	gdbstub_io_set_baud(115200);
+
+	/* we want to get serial receive interrupts */
+	set_intr_level(gdbstub_port->rx_irq, GxICR_LEVEL_0);
+	set_intr_level(gdbstub_port->tx_irq, GxICR_LEVEL_0);
+	set_intr_stub(EXCEP_IRQ_LEVEL0, gdbstub_io_rx_handler);
+
+	*gdbstub_port->rx_icr |= GxICR_ENABLE;
+	tmp = *gdbstub_port->rx_icr;
+
+	/* enable the device */
+	scxctr = SC01CTR_CLN_8BIT;	/* 1N8 */
+	switch (gdbstub_port->div_timer) {
+	case MNSCx_DIV_TIMER_16BIT:
+		scxctr |= SC0CTR_CK_TM8UFLOW_8; /* == SC1CTR_CK_TM9UFLOW_8
+						   == SC2CTR_CK_TM10UFLOW_8 */
+		break;
+
+	case MNSCx_DIV_TIMER_8BIT:
+		scxctr |= SC0CTR_CK_TM2UFLOW_8;
+		break;
+	}
+
+	scxctr |= SC01CTR_TXE | SC01CTR_RXE;
+
+	*gdbstub_port->_control = scxctr;
+	tmp = *gdbstub_port->_control;
+
+	/* permit level 0 IRQs only */
+	asm volatile(
+		"	and %0,epsw	\n"
+		"	or %1,epsw	\n"
+		:
+		: "i"(~EPSW_IM), "i"(EPSW_IE|EPSW_IM_1)
+		);
+}
+
+/*
+ * set up the GDB stub serial port baud rate timers
+ */
+void gdbstub_io_set_baud(unsigned baud)
+{
+	const unsigned bits = 10; /* 1 [start] + 8 [data] + 0 [parity] + 1 [stop] */
+	unsigned long ioclk = gdbstub_port->ioclk;
+	unsigned xdiv, tmp;
+	uint16_t tmxbr;
+	uint8_t tmxmd;
+
+	if (!baud) {
+		baud = 9600;
+	}
+	else if (baud == 134) {
+		baud = 269;	/* 134 is really 134.5 */
+		xdiv = 2;
+	}
+
+try_alternative:
+	xdiv = 1;
+
+	switch (gdbstub_port->div_timer) {
+	case MNSCx_DIV_TIMER_16BIT:
+		tmxmd = TM8MD_SRC_IOCLK;
+		tmxbr = tmp = (ioclk / (baud * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 65535)
+			goto timer_okay;
+
+		tmxmd = TM8MD_SRC_IOCLK_8;
+		tmxbr = tmp = (ioclk / (baud * 8 * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 65535)
+			goto timer_okay;
+
+		tmxmd = TM8MD_SRC_IOCLK_32;
+		tmxbr = tmp = (ioclk / (baud * 32 * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 65535)
+			goto timer_okay;
+
+		break;
+
+	case MNSCx_DIV_TIMER_8BIT:
+		tmxmd = TM2MD_SRC_IOCLK;
+		tmxbr = tmp = (ioclk / (baud * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 255)
+			goto timer_okay;
+
+		tmxmd = TM2MD_SRC_IOCLK_8;
+		tmxbr = tmp = (ioclk / (baud * 8 * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 255)
+			goto timer_okay;
+
+		tmxmd = TM2MD_SRC_IOCLK_32;
+		tmxbr = tmp = (ioclk / (baud * 32 * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 255)
+			goto timer_okay;
+		break;
+	}
+
+	/* as a last resort, if the quotient is zero, default to 9600 bps */
+	baud = 9600;
+	goto try_alternative;
+
+timer_okay:
+	gdbstub_port->uart.timeout = (2 * bits * HZ) / baud;
+	gdbstub_port->uart.timeout += HZ / 50;
+
+	/* set the timer to produce the required baud rate */
+	switch (gdbstub_port->div_timer) {
+	case MNSCx_DIV_TIMER_16BIT:
+		*gdbstub_port->_tmxmd = 0;
+		*gdbstub_port->_tmxbr = tmxbr;
+		*gdbstub_port->_tmxmd = TM8MD_INIT_COUNTER;
+		*gdbstub_port->_tmxmd = tmxmd | TM8MD_COUNT_ENABLE;
+		break;
+
+	case MNSCx_DIV_TIMER_8BIT:
+		*gdbstub_port->_tmxmd = 0;
+		*(volatile u8 *) gdbstub_port->_tmxbr = (u8)tmxbr;
+		*gdbstub_port->_tmxmd = TM2MD_INIT_COUNTER;
+		*gdbstub_port->_tmxmd = tmxmd | TM2MD_COUNT_ENABLE;
+		break;
+	}
+}
+
+/*
+ * wait for a character to come from the debugger
+ */
+int gdbstub_io_rx_char(unsigned char *_ch, int nonblock)
+{
+	unsigned ix;
+	u8 ch, st;
+
+	*_ch = 0xff;
+
+	if (gdbstub_rx_unget) {
+		*_ch = gdbstub_rx_unget;
+		gdbstub_rx_unget = 0;
+		return 0;
+	}
+
+try_again:
+	/* pull chars out of the buffer */
+	ix = gdbstub_rx_outp;
+	if (ix == gdbstub_rx_inp) {
+		if (nonblock)
+			return -EAGAIN;
+#ifdef CONFIG_MN10300_WD_TIMER
+		watchdog_alert_counter = 0;
+#endif /* CONFIG_MN10300_WD_TIMER */
+		goto try_again;
+	}
+
+	ch = gdbstub_rx_buffer[ix++];
+	st = gdbstub_rx_buffer[ix++];
+	gdbstub_rx_outp = ix & (PAGE_SIZE - 1);
+
+	st &= SC01STR_RXF | SC01STR_RBF | SC01STR_FEF | SC01STR_PEF | SC01STR_OEF;
+
+	/* deal with what we've got
+	 * - note that the UART doesn't do BREAK-detection for us
+	 */
+	if (st & SC01STR_FEF && ch == 0) {
+		switch (gdbstub_port->rx_brk) {
+		case 0:	gdbstub_port->rx_brk = 1;	goto try_again;
+		case 1:	gdbstub_port->rx_brk = 2;	goto try_again;
+		case 2:
+			gdbstub_port->rx_brk = 3;
+			gdbstub_proto("### GDB MNSERIAL Rx Break Detected ###\n");
+			return -EINTR;
+		default:
+			goto try_again;
+		}
+	} else if (st & SC01STR_FEF) {
+		if (gdbstub_port->rx_brk)
+			goto try_again;
+
+		gdbstub_proto("### GDB MNSERIAL Framing Error ###\n");
+		return -EIO;
+	} else if (st & SC01STR_OEF) {
+		if (gdbstub_port->rx_brk)
+			goto try_again;
+
+		gdbstub_proto("### GDB MNSERIAL Overrun Error ###\n");
+		return -EIO;
+	} else if (st & SC01STR_PEF) {
+		if (gdbstub_port->rx_brk)
+			goto try_again;
+
+		gdbstub_proto("### GDB MNSERIAL Parity Error ###\n");
+		return -EIO;
+	} else {
+		/* look for the tail-end char on a break run */
+		if (gdbstub_port->rx_brk == 3) {
+			switch (ch) {
+			case 0xFF:
+			case 0xFE:
+			case 0xFC:
+			case 0xF8:
+			case 0xF0:
+			case 0xE0:
+			case 0xC0:
+			case 0x80:
+			case 0x00:
+				gdbstub_port->rx_brk = 0;
+				goto try_again;
+			default:
+				break;
+			}
+		}
+
+		gdbstub_port->rx_brk = 0;
+		gdbstub_io("### GDB Rx %02x (st=%02x) ###\n", ch, st);
+		*_ch = ch & 0x7f;
+		return 0;
+	}
+}
+
+/*
+ * send a character to the debugger
+ */
+void gdbstub_io_tx_char(unsigned char ch)
+{
+	while (*gdbstub_port->_status & SC01STR_TBF)
+		continue;
+
+	if (ch == 0x0a) {
+		*(u8 *) gdbstub_port->_txb = 0x0d;
+		while (*gdbstub_port->_status & SC01STR_TBF)
+			continue;
+	}
+
+	*(u8 *) gdbstub_port->_txb = ch;
+}
+
+/*
+ * flush the transmission buffers
+ */
+void gdbstub_io_tx_flush(void)
+{
+	while (*gdbstub_port->_status & (SC01STR_TBF | SC01STR_TXF))
+		continue;
+}
diff -puN /dev/null arch/mn10300/kernel/gdb-io-ttysm-low.S
--- /dev/null
+++ a/arch/mn10300/kernel/gdb-io-ttysm-low.S
@@ -0,0 +1,93 @@
+###############################################################################
+#
+# MN10300 On-chip serial Rx interrupt handler for GDB stub I/O
+#
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/thread_info.h>
+#include <asm/cpu-regs.h>
+#include <asm/frame.inc>
+#include <asm/intctl-regs.h>
+#include <asm/unit/serial.h>
+#include "mn10300-serial.h"
+
+	.text
+
+###################################################################################################
+#
+# GDB stub serial receive interrupt entry point
+# - intended to run at interrupt priority 0
+#
+###################################################################################################
+	.globl	gdbstub_io_rx_handler
+	.type	gdbstub_io_rx_handler,@function
+gdbstub_io_rx_handler:
+	movm	[d2,d3,a2,a3],(sp)
+		
+	mov	(gdbstub_rx_inp),a3
+gdbstub_io_rx_more:
+	mov	a3,a2
+	add	2,a3
+	and	PAGE_SIZE_asm-1,a3
+	mov	(gdbstub_rx_outp),d3
+	cmp	a3,d3
+	beq	gdbstub_io_rx_overflow
+
+	movbu	(SCgSTR),d3
+	btst	SC01STR_RBF,d3
+	beq	gdbstub_io_rx_done
+	movbu	(SCgRXB),d2
+	movbu	d3,(gdbstub_rx_buffer+1,a2)
+	movbu	d2,(gdbstub_rx_buffer,a2)
+	mov	a3,(gdbstub_rx_inp)
+	bra	gdbstub_io_rx_more
+
+gdbstub_io_rx_done:
+	mov	GxICR_DETECT,d2
+	movbu	d2,(GxICR(SCgRXIRQ))	# ACK the interrupt
+	movhu	(GxICR(SCgRXIRQ)),d2	# flush
+	
+	movm	(sp),[d2,d3,a2,a3]
+	bset	0x01,(gdbstub_busy)
+	beq	gdbstub_io_rx_enter
+	rti
+
+gdbstub_io_rx_overflow:
+	bset	0x01,(gdbstub_rx_overflow)
+	bra	gdbstub_io_rx_done
+	
+###############################################################################
+#
+# debugging interrupt - enter the GDB stub proper
+#
+###############################################################################
+gdbstub_io_rx_enter:
+	or	EPSW_IE|EPSW_IM_1,epsw
+	add	-4,sp
+	SAVE_ALL
+
+	mov	0xffffffff,d0
+	mov	d0,(REG_ORIG_D0,fp)
+	mov	0x280,d1
+
+	mov	fp,d0
+	call	gdbstub_rx_irq[],0	# gdbstub_io_rx_irq(regs,excep)
+
+	and	~EPSW_IE,epsw
+	bclr	0x01,(gdbstub_busy)
+
+	.globl gdbstub_return
+gdbstub_return:
+	RESTORE_ALL
+
+	.size	gdbstub_io_rx_handler,.-gdbstub_io_rx_handler
diff -puN /dev/null arch/mn10300/kernel/gdb-low.S
--- /dev/null
+++ a/arch/mn10300/kernel/gdb-low.S
@@ -0,0 +1,115 @@
+###############################################################################
+#
+# MN10300 Low-level gdbstub routines
+#
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/cache.h>
+#include <asm/cpu-regs.h>
+#include <asm/exceptions.h>
+#include <asm/frame.inc>
+#include <asm/serial-regs.h>
+
+	.text
+
+###################################################################################################
+#
+# GDB stub read memory with guard
+# - D0 holds the memory address to read
+# - D1 holds the address to store the byte into
+#
+###################################################################################################
+	.globl gdbstub_read_byte_guard
+	.globl gdbstub_read_byte_cont
+ENTRY(gdbstub_read_byte)
+	mov	d0,a0
+	mov	d1,a1
+	clr	d0
+gdbstub_read_byte_guard:
+	movbu	(a0),d1
+gdbstub_read_byte_cont:
+	movbu	d1,(a1)
+	ret	[],0
+
+	.globl gdbstub_read_word_guard
+	.globl gdbstub_read_word_cont
+ENTRY(gdbstub_read_word)
+	mov	d0,a0
+	mov	d1,a1
+	clr	d0
+gdbstub_read_word_guard:
+	movhu	(a0),d1
+gdbstub_read_word_cont:
+	movhu	d1,(a1)
+	ret	[],0
+
+	.globl gdbstub_read_dword_guard
+	.globl gdbstub_read_dword_cont
+ENTRY(gdbstub_read_dword)
+	mov	d0,a0
+	mov	d1,a1
+	clr	d0
+gdbstub_read_dword_guard:
+	mov	(a0),d1
+gdbstub_read_dword_cont:
+	mov	d1,(a1)
+	ret	[],0
+
+###################################################################################################
+#
+# GDB stub write memory with guard
+# - D0 holds the byte to store
+# - D1 holds the memory address to write
+#
+###################################################################################################
+	.globl gdbstub_write_byte_guard
+	.globl gdbstub_write_byte_cont
+ENTRY(gdbstub_write_byte)
+	mov	d0,a0
+	mov	d1,a1
+	clr	d0
+gdbstub_write_byte_guard:
+	movbu	a0,(a1)
+gdbstub_write_byte_cont:
+	ret	[],0
+
+	.globl gdbstub_write_word_guard
+	.globl gdbstub_write_word_cont
+ENTRY(gdbstub_write_word)
+	mov	d0,a0
+	mov	d1,a1
+	clr	d0
+gdbstub_write_word_guard:
+	movhu	a0,(a1)
+gdbstub_write_word_cont:
+	ret	[],0
+
+	.globl gdbstub_write_dword_guard
+	.globl gdbstub_write_dword_cont
+ENTRY(gdbstub_write_dword)
+	mov	d0,a0
+	mov	d1,a1
+	clr	d0
+gdbstub_write_dword_guard:
+	mov	a0,(a1)
+gdbstub_write_dword_cont:
+	ret	[],0
+
+###################################################################################################
+#
+# GDB stub BUG() trap
+#
+###################################################################################################
+ENTRY(__gdbstub_bug_trap)
+	.byte	0xF7,0xF7	# don't use 0xFF as the JTAG unit preempts that
+	ret	[],0
diff -puN /dev/null arch/mn10300/kernel/gdb-stub.c
--- /dev/null
+++ a/arch/mn10300/kernel/gdb-stub.c
@@ -0,0 +1,1908 @@
+/* MN10300 GDB stub
+ *
+ * Originally written by Glenn Engel, Lake Stevens Instrument Division
+ *
+ * Contributed by HP Systems
+ *
+ * Modified for SPARC by Stu Grossman, Cygnus Support.
+ *
+ * Modified for Linux/MIPS (and MIPS in general) by Andreas Busse
+ * Send complaints, suggestions etc. to <andy@waldorf-gmbh.de>
+ *
+ * Copyright (C) 1995 Andreas Busse
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified for Linux/mn10300 by David Howells <dhowells@redhat.com>
+ */
+
+/*
+ *  To enable debugger support, two things need to happen.  One, a
+ *  call to set_debug_traps() is necessary in order to allow any breakpoints
+ *  or error conditions to be properly intercepted and reported to gdb.
+ *  Two, a breakpoint needs to be generated to begin communication.  This
+ *  is most easily accomplished by a call to breakpoint().  Breakpoint()
+ *  simulates a breakpoint by executing a BREAK instruction.
+ *
+ *
+ *    The following gdb commands are supported:
+ *
+ * command          function                               Return value
+ *
+ *    g             return the value of the CPU registers  hex data or ENN
+ *    G             set the value of the CPU registers     OK or ENN
+ *
+ *    mAA..AA,LLLL  Read LLLL bytes at address AA..AA      hex data or ENN
+ *    MAA..AA,LLLL: Write LLLL bytes at address AA.AA      OK or ENN
+ *
+ *    c             Resume at current address              SNN   ( signal NN)
+ *    cAA..AA       Continue at address AA..AA             SNN
+ *
+ *    s             Step one instruction                   SNN
+ *    sAA..AA       Step one instruction from AA..AA       SNN
+ *
+ *    k             kill
+ *
+ *    ?             What was the last sigval ?             SNN   (signal NN)
+ *
+ *    bBB..BB	    Set baud rate to BB..BB		   OK or BNN, then sets
+ *							   baud rate
+ *
+ * All commands and responses are sent with a packet which includes a
+ * checksum.  A packet consists of
+ *
+ * $<packet info>#<checksum>.
+ *
+ * where
+ * <packet info> :: <characters representing the command or response>
+ * <checksum>    :: < two hex digits computed as modulo 256 sum of <packetinfo>>
+ *
+ * When a packet is received, it is first acknowledged with either '+' or '-'.
+ * '+' indicates a successful transfer.  '-' indicates a failed transfer.
+ *
+ * Example:
+ *
+ * Host:                  Reply:
+ * $m0,10#2a               +$00010203040506070809101112131415#42
+ *
+ *
+ *  ==============
+ *  MORE EXAMPLES:
+ *  ==============
+ *
+ *  For reference -- the following are the steps that one
+ *  company took (RidgeRun Inc) to get remote gdb debugging
+ *  going. In this scenario the host machine was a PC and the
+ *  target platform was a Galileo EVB64120A MIPS evaluation
+ *  board.
+ *
+ *  Step 1:
+ *  First download gdb-5.0.tar.gz from the internet.
+ *  and then build/install the package.
+ *
+ *  Example:
+ *    $ tar zxf gdb-5.0.tar.gz
+ *    $ cd gdb-5.0
+ *    $ ./configure --target=am33_2.0-linux-gnu
+ *    $ make
+ *    $ install
+ *    /usr/cygnus/am33-020219/H-i686-pc-linux-gnulibc2.2/bin/am33_2.0-linux-gnu-gdb
+ *
+ *  Step 2:
+ *  Configure linux for remote debugging and build it.
+ *
+ *  Example:
+ *    $ cd ~/linux
+ *    $ make menuconfig <go to "Kernel Hacking" and turn on remote debugging>
+ *    $ make dep; make vmlinux
+ *
+ *  Step 3:
+ *  Download the kernel to the remote target and start
+ *  the kernel running. It will promptly halt and wait
+ *  for the host gdb session to connect. It does this
+ *  since the "Kernel Hacking" option has defined
+ *  CONFIG_REMOTE_DEBUG which in turn enables your calls
+ *  to:
+ *     set_debug_traps();
+ *     breakpoint();
+ *
+ *  Step 4:
+ *  Start the gdb session on the host.
+ *
+ *  Example:
+ *    $ am33_2.0-linux-gnu-gdb vmlinux
+ *    (gdb) set remotebaud 115200
+ *    (gdb) target remote /dev/ttyS1
+ *    ...at this point you are connected to
+ *       the remote target and can use gdb
+ *       in the normal fasion. Setting
+ *       breakpoints, single stepping,
+ *       printing variables, etc.
+ *
+ */
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/bug.h>
+
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/gdb-stub.h>
+#include <asm/exceptions.h>
+#include <asm/cacheflush.h>
+#include <asm/serial-regs.h>
+#include <asm/busctl-regs.h>
+#include <asm/unit/leds.h>
+#include <asm/unit/serial.h>
+
+#undef GDBSTUB_USE_F7F7_AS_BREAKPOINT	/* rather than FF which is subverted by JTAG debugger */
+
+extern void debug_to_serial(const char *p, int n);
+extern void xxx_debug_to_serial(const char *p, int n);
+
+/*
+ * BUFMAX defines the maximum number of characters in inbound/outbound buffers
+ * at least NUMREGBYTES*2 are needed for register packets
+ */
+#define BUFMAX 2048
+
+static const char gdbstub_banner[] =
+	"Linux/MN10300 GDB Stub (c) RedHat 2005\n";
+
+volatile u8	gdbstub_rx_buffer[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+volatile u32	gdbstub_rx_inp;
+volatile u32	gdbstub_rx_outp;
+volatile u8	gdbstub_busy;
+volatile u8	gdbstub_rx_overflow;
+u8		gdbstub_rx_unget;
+
+static u8	gdbstub_flush_caches;
+static char	input_buffer[BUFMAX];
+static char	output_buffer[BUFMAX];
+static char	trans_buffer[BUFMAX];
+
+static const char hexchars[] = "0123456789abcdef";
+
+struct gdbstub_bkpt {
+	u8	*addr;		/* address of breakpoint */
+	u8	len;		/* size of breakpoint */
+	u8	origbytes[7];	/* original bytes */
+};
+
+static struct gdbstub_bkpt gdbstub_bkpts[256];
+
+/*
+ * local prototypes
+ */
+static void getpacket(char *buffer);
+static int putpacket(char *buffer);
+static int computeSignal(exception_code_t excep);
+static int hex(unsigned char ch);
+static int hexToInt(char **ptr, int *intValue);
+static unsigned char *mem2hex(const void *mem, char *buf, int count, int may_fault);
+static const char *hex2mem(const char *buf, void *_mem, int count, int may_fault);
+
+/*
+ * Convert ch from a hex digit to an int
+ */
+static int hex(unsigned char ch)
+{
+	if (ch >= 'a' && ch <= 'f')
+		return ch - 'a' + 10;
+	if (ch >= '0' && ch <= '9')
+		return ch - '0';
+	if (ch >= 'A' && ch <= 'F')
+		return ch - 'A' + 10;
+	return -1;
+}
+
+#ifdef CONFIG_GDBSTUB_DEBUGGING
+
+void debug_to_serial(const char *p, int n)
+{
+	__debug_to_serial(p, n);
+	//gdbstub_console_write(NULL, p, n);
+}
+
+void gdbstub_printk(const char *fmt, ...)
+{
+	va_list args;
+	int len;
+
+	/* Emit the output into the temporary buffer */
+	va_start(args, fmt);
+	len = vsnprintf(trans_buffer, sizeof(trans_buffer), fmt, args);
+	va_end(args);
+	debug_to_serial(trans_buffer, len);
+}
+
+#endif
+
+static inline char *gdbstub_strcpy(char *dst, const char *src)
+{
+	int loop = 0;
+	while ((dst[loop] = src[loop]))
+	       loop++;
+	return dst;
+}
+
+/*
+ * scan for the sequence $<data>#<checksum>
+ */
+static void getpacket(char *buffer)
+{
+	unsigned char checksum;
+	unsigned char xmitcsum;
+	unsigned char ch;
+	int count, i, ret, error;
+
+	for (;;) {
+		/*
+		 * wait around for the start character,
+		 * ignore all other characters
+		 */
+		do {
+			gdbstub_io_rx_char(&ch, 0);
+		} while (ch != '$');
+
+		checksum = 0;
+		xmitcsum = -1;
+		count = 0;
+		error = 0;
+
+		/*
+		 * now, read until a # or end of buffer is found
+		 */
+		while (count < BUFMAX) {
+			ret = gdbstub_io_rx_char(&ch, 0);
+			if (ret<0)
+				error = ret;
+
+			if (ch == '#')
+				break;
+			checksum += ch;
+			buffer[count] = ch;
+			count++;
+		}
+
+		if (error == -EIO) {
+			gdbstub_proto("### GDB Rx Error - Skipping packet ###\n");
+			gdbstub_proto("### GDB Tx NAK\n");
+			gdbstub_io_tx_char('-');
+			continue;
+		}
+
+		if (count >= BUFMAX || error)
+			continue;
+
+		buffer[count] = 0;
+
+		/* read the checksum */
+		ret = gdbstub_io_rx_char(&ch, 0);
+		if (ret < 0)
+			error = ret;
+		xmitcsum = hex(ch) << 4;
+
+		ret = gdbstub_io_rx_char(&ch, 0);
+		if (ret < 0)
+			error = ret;
+		xmitcsum |= hex(ch);
+
+		if (error) {
+			if (error == -EIO)
+				gdbstub_io("### GDB Rx Error - Skipping packet\n");
+			gdbstub_io("### GDB Tx NAK\n");
+			gdbstub_io_tx_char('-');
+			continue;
+		}
+
+		/* check the checksum */
+		if (checksum != xmitcsum) {
+			gdbstub_io("### GDB Tx NAK\n");
+			gdbstub_io_tx_char('-');	/* failed checksum */
+			continue;
+		}
+
+		gdbstub_proto("### GDB Rx '$%s#%02x' ###\n", buffer, checksum);
+		gdbstub_io("### GDB Tx ACK\n");
+		gdbstub_io_tx_char('+'); /* successful transfer */
+
+		/*
+		 * if a sequence char is present,
+		 * reply the sequence ID
+		 */
+		if (buffer[2] == ':') {
+			gdbstub_io_tx_char(buffer[0]);
+			gdbstub_io_tx_char(buffer[1]);
+
+			/*
+			 * remove sequence chars from buffer
+			 */
+			count = 0;
+			while (buffer[count])
+				count++;
+			for (i = 3; i <= count; i++)
+				buffer[i - 3] = buffer[i];
+		}
+
+		break;
+	}
+}
+
+/*
+ * send the packet in buffer.
+ * - return 0 if successfully ACK'd
+ * - return 1 if abandoned due to new incoming packet
+ */
+static int putpacket(char *buffer)
+{
+	unsigned char checksum;
+	unsigned char ch;
+	int count;
+
+	/*
+	 * $<packet info>#<checksum>.
+	 */
+	gdbstub_proto("### GDB Tx $'%s'#?? ###\n", buffer);
+
+	do {
+		gdbstub_io_tx_char('$');
+		checksum = 0;
+		count = 0;
+
+		while ((ch = buffer[count]) != 0) {
+			gdbstub_io_tx_char(ch);
+			checksum += ch;
+			count += 1;
+		}
+
+		gdbstub_io_tx_char('#');
+		gdbstub_io_tx_char(hexchars[checksum >> 4]);
+		gdbstub_io_tx_char(hexchars[checksum & 0xf]);
+
+	} while (gdbstub_io_rx_char(&ch, 0),
+		 ch == '-' && (gdbstub_io("### GDB Rx NAK\n"), 0),
+		 ch != '-' && ch != '+' && (gdbstub_io("### GDB Rx ??? %02x\n", ch), 0),
+		 ch != '+' && ch != '$');
+
+	if (ch == '+') {
+		gdbstub_io("### GDB Rx ACK\n");
+		return 0;
+	}
+
+	gdbstub_io("### GDB Tx Abandoned\n");
+	gdbstub_rx_unget = ch;
+	return 1;
+}
+
+/*
+ * While we find nice hex chars, build an int.
+ * Return number of chars processed.
+ */
+static int hexToInt(char **ptr, int *intValue)
+{
+	int numChars = 0;
+	int hexValue;
+
+	*intValue = 0;
+
+	while (**ptr) {
+		hexValue = hex(**ptr);
+		if (hexValue < 0)
+			break;
+
+		*intValue = (*intValue << 4) | hexValue;
+		numChars ++;
+
+		(*ptr)++;
+	}
+
+	return (numChars);
+}
+
+/*
+ * We single-step by setting breakpoints. When an exception
+ * is handled, we need to restore the instructions hoisted
+ * when the breakpoints were set.
+ *
+ * This is where we save the original instructions.
+ */
+static struct gdb_bp_save {
+	u8	*addr;
+        u8	opcode[2];
+} step_bp[2];
+
+static const unsigned char gdbstub_insn_sizes[256] =
+{
+	// 1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
+	1, 3, 3, 3, 1, 3, 3, 3, 1, 3, 3, 3, 1, 3, 3, 3,	// 0
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 1
+	2, 2, 2, 2, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 3, 3, // 2
+	3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, // 3
+	1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2, // 4
+	1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, // 5
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 6
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 7
+	2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, // 8
+	2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, // 9
+	2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, // a
+	2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, // b
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 2, // c
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // d
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // e
+	0, 2, 2, 2, 2, 2, 2, 4, 0, 3, 0, 4, 0, 6, 7, 1  // f
+};
+
+static int __gdbstub_mark_bp(u8 *addr, int ix)
+{
+	if (addr < (u8 *) 0x70000000UL) return 0;
+	if (addr < (u8 *) 0x80000000UL) goto okay;	/* 70000000-7fffffff: vmalloc area */
+	if (addr < (u8 *) 0x8c000000UL) return 0;
+	if (addr < (u8 *) 0x94000000UL) goto okay;	/* 8c000000-93ffffff: SRAM, SDRAM */
+	return 0;
+
+ okay:
+	if (gdbstub_read_byte(addr + 0, &step_bp[ix].opcode[0]) < 0 ||
+	    gdbstub_read_byte(addr + 1, &step_bp[ix].opcode[1]) < 0)
+		return 0;
+
+	step_bp[ix].addr = addr;
+	return 1;
+}
+
+static inline void __gdbstub_restore_bp(void)
+{
+#ifdef GDBSTUB_USE_F7F7_AS_BREAKPOINT
+	if (step_bp[0].addr) {
+		gdbstub_write_byte(step_bp[0].opcode[0], step_bp[0].addr + 0);
+		gdbstub_write_byte(step_bp[0].opcode[1], step_bp[0].addr + 1);
+	}
+	if (step_bp[1].addr) {
+		gdbstub_write_byte(step_bp[1].opcode[0], step_bp[1].addr + 0);
+		gdbstub_write_byte(step_bp[1].opcode[1], step_bp[1].addr + 1);
+	}
+#else
+	if (step_bp[0].addr) {
+		gdbstub_write_byte(step_bp[0].opcode[0], step_bp[0].addr + 0);
+	}
+	if (step_bp[1].addr) {
+		gdbstub_write_byte(step_bp[1].opcode[0], step_bp[1].addr + 0);
+	}
+#endif
+
+	gdbstub_flush_caches = 1;
+
+	step_bp[0].addr		= NULL;
+	step_bp[0].opcode[0]	= 0;
+	step_bp[0].opcode[1]	= 0;
+	step_bp[1].addr		= NULL;
+	step_bp[1].opcode[0]	= 0;
+	step_bp[1].opcode[1]	= 0;
+}
+
+/*
+ * emulate single stepping by means of breakpoint instructions
+ */
+static int gdbstub_single_step(struct pt_regs *regs)
+{
+	unsigned size;
+	uint32_t x;
+	uint8_t cur, *pc, *sp;
+
+	step_bp[0].addr		= NULL;
+	step_bp[0].opcode[0]	= 0;
+	step_bp[0].opcode[1]	= 0;
+	step_bp[1].addr		= NULL;
+	step_bp[1].opcode[0]	= 0;
+	step_bp[1].opcode[1]	= 0;
+	x = 0;
+
+	pc = (u8 *) regs->pc;
+	sp = (u8 *) (regs + 1);
+	if (gdbstub_read_byte(pc, &cur) < 0)
+		return -EFAULT;
+
+	gdbstub_bkpt("Single Step from %p { %02x }\n", pc, cur);
+
+	gdbstub_flush_caches = 1;
+
+	size = gdbstub_insn_sizes[cur];
+	if (size>0) {
+		if (!__gdbstub_mark_bp(pc + size, 0))
+			goto fault;
+	} else {
+		switch (cur) {
+			/* Bxx (d8,PC) */
+		case 0xc0:
+		case 0xc1:
+		case 0xc2:
+		case 0xc3:
+		case 0xc4:
+		case 0xc5:
+		case 0xc6:
+		case 0xc7:
+		case 0xc8:
+		case 0xc9:
+		case 0xca:
+			if (gdbstub_read_byte(pc + 1, (u8 *) &x) < 0)
+				goto fault;
+			if (!__gdbstub_mark_bp(pc + 2, 0))
+				goto fault;
+			if ((x < 0 || x > 2) &&
+			    !__gdbstub_mark_bp(pc + (s8) x, 1))
+				goto fault;
+			break;
+
+			/* LXX (d8,PC) */
+		case 0xd0:
+		case 0xd1:
+		case 0xd2:
+		case 0xd3:
+		case 0xd4:
+		case 0xd5:
+		case 0xd6:
+		case 0xd7:
+		case 0xd8:
+		case 0xd9:
+		case 0xda:
+			if (!__gdbstub_mark_bp(pc + 1,0))
+				goto fault;
+			if (regs->pc != regs->lar &&
+			    !__gdbstub_mark_bp((u8 *) regs->lar, 1))
+				goto fault;
+			break;
+
+			/* SETLB - loads the next for bytes into the LIR register */
+		case 0xdb:
+			if (!__gdbstub_mark_bp(pc + 1, 0))
+				goto fault;
+			break;
+
+			/* JMP (d16,PC) or CALL (d16,PC) */
+		case 0xcc:
+		case 0xcd:
+			if (gdbstub_read_byte(pc + 1,((u8 *) &x) + 0) < 0 ||
+			    gdbstub_read_byte(pc + 2,((u8 *) &x) + 1) < 0)
+				goto fault;
+			if (!__gdbstub_mark_bp(pc + (s16) x, 0))
+				goto fault;
+			break;
+
+			/* JMP (d32,PC) or CALL (d32,PC) */
+		case 0xdc:
+		case 0xdd:
+			if (gdbstub_read_byte(pc + 1, ((u8 *) &x) + 0) < 0 ||
+			    gdbstub_read_byte(pc + 2, ((u8 *) &x) + 1) < 0 ||
+			    gdbstub_read_byte(pc + 3, ((u8 *) &x) + 2) < 0 ||
+			    gdbstub_read_byte(pc + 4, ((u8 *) &x) + 3) < 0)
+				goto fault;
+			if (!__gdbstub_mark_bp(pc + (s32) x, 0))
+				goto fault;
+			break;
+
+			/* RETF */
+		case 0xde:
+			if (!__gdbstub_mark_bp((u8 *) regs->mdr, 0))
+				goto fault;
+			break;
+
+			/* RET */
+		case 0xdf:
+			if (gdbstub_read_byte(pc + 2, (u8 *) &x) < 0)
+				goto fault;
+			sp += (s8)x;
+			if (gdbstub_read_byte(sp + 0, ((u8 *) &x) + 0) < 0 ||
+			    gdbstub_read_byte(sp + 1, ((u8 *) &x) + 1) < 0 ||
+			    gdbstub_read_byte(sp + 2, ((u8 *) &x) + 2) < 0 ||
+			    gdbstub_read_byte(sp + 3, ((u8 *) &x) + 3) < 0)
+				goto fault;
+			if (!__gdbstub_mark_bp((u8 *) x, 0))
+				goto fault;
+			break;
+
+		case 0xf0:
+			if (gdbstub_read_byte(pc + 1, &cur) < 0)
+				goto fault;
+
+			if (cur >= 0xf0 && cur <= 0xf7) {
+				/* JMP (An) / CALLS (An) */
+				switch (cur & 3) {
+				case 0: x = regs->a0; break;
+				case 1: x = regs->a1; break;
+				case 2: x = regs->a2; break;
+				case 3: x = regs->a3; break;
+				}
+				if (!__gdbstub_mark_bp((u8 *) x, 0))
+					goto fault;
+			} else if (cur == 0xfc) {
+				/* rets */
+				if (gdbstub_read_byte(sp + 0, ((u8 *) &x) + 0) < 0 ||
+				    gdbstub_read_byte(sp + 1, ((u8 *) &x) + 1) < 0 ||
+				    gdbstub_read_byte(sp + 2, ((u8 *) &x) + 2) < 0 ||
+				    gdbstub_read_byte(sp + 3, ((u8 *) &x) + 3) < 0)
+					goto fault;
+				if (!__gdbstub_mark_bp((u8 *) x, 0))
+					goto fault;
+			} else if (cur == 0xfd) {
+				/* rti */
+				if (gdbstub_read_byte(sp + 4, ((u8 *) &x) + 0) < 0 ||
+				    gdbstub_read_byte(sp + 5, ((u8 *) &x) + 1) < 0 ||
+				    gdbstub_read_byte(sp + 6, ((u8 *) &x) + 2) < 0 ||
+				    gdbstub_read_byte(sp + 7, ((u8 *) &x) + 3) < 0)
+					goto fault;
+				if (!__gdbstub_mark_bp((u8 *) x, 0))
+					goto fault;
+			} else {
+				if (!__gdbstub_mark_bp(pc + 2, 0))
+					goto fault;
+			}
+
+			break;
+
+			/* potential 3-byte conditional branches */
+		case 0xf8:
+			if (gdbstub_read_byte(pc + 1, &cur) < 0)
+				goto fault;
+			if (!__gdbstub_mark_bp(pc + 3, 0))
+				goto fault;
+
+			if (cur >= 0xe8 && cur <= 0xeb) {
+				if (gdbstub_read_byte(pc + 2, ((u8 *) &x) + 0) < 0)
+					goto fault;
+				if ((x < 0 || x > 3) &&
+				    !__gdbstub_mark_bp(pc + (s8) x, 1))
+					goto fault;
+			}
+			break;
+
+		case 0xfa:
+			if (gdbstub_read_byte(pc + 1, &cur) < 0)
+				goto fault;
+
+			if (cur == 0xff) {
+				/* CALLS (d16,PC) */
+				if (gdbstub_read_byte(pc + 2, ((u8 *) &x) + 0) < 0 ||
+				    gdbstub_read_byte(pc + 3, ((u8 *) &x) + 1) < 0)
+					goto fault;
+				if (!__gdbstub_mark_bp(pc + (s16) x, 0))
+					goto fault;
+			} else {
+				if (!__gdbstub_mark_bp(pc + 4, 0))
+					goto fault;
+			}
+			break;
+
+		case 0xfc:
+			if (gdbstub_read_byte(pc + 1, &cur) < 0)
+				goto fault;
+			if (cur == 0xff) {
+				/* CALLS (d32,PC) */
+				if (gdbstub_read_byte(pc + 2, ((u8 *) &x) + 0) < 0 ||
+				    gdbstub_read_byte(pc + 3, ((u8 *) &x) + 1) < 0 ||
+				    gdbstub_read_byte(pc + 4, ((u8 *) &x) + 2) < 0 ||
+				    gdbstub_read_byte(pc + 5, ((u8 *) &x) + 3) < 0)
+					goto fault;
+				if (!__gdbstub_mark_bp(pc + (s32) x, 0))
+					goto fault;
+			} else {
+				if (!__gdbstub_mark_bp(pc + 6, 0))
+					goto fault;
+			}
+			break;
+
+		}
+	}
+
+	gdbstub_bkpt("Step: %02x at %p; %02x at %p\n",
+		     step_bp[0].opcode[0], step_bp[0].addr,
+		     step_bp[1].opcode[0], step_bp[1].addr);
+
+	if (step_bp[0].addr) {
+#ifdef GDBSTUB_USE_F7F7_AS_BREAKPOINT
+		if (gdbstub_write_byte(0xF7, step_bp[0].addr + 0) < 0 ||
+		    gdbstub_write_byte(0xF7, step_bp[0].addr + 1) < 0)
+			goto fault;
+#else
+		if (gdbstub_write_byte(0xFF, step_bp[0].addr + 0) < 0)
+			goto fault;
+#endif
+	}
+
+	if (step_bp[1].addr) {
+#ifdef GDBSTUB_USE_F7F7_AS_BREAKPOINT
+		if (gdbstub_write_byte(0xF7, step_bp[1].addr + 0) < 0 ||
+		    gdbstub_write_byte(0xF7, step_bp[1].addr + 1) < 0)
+			goto fault;
+#else
+		if (gdbstub_write_byte(0xFF, step_bp[1].addr + 0) < 0)
+			goto fault;
+#endif
+	}
+
+	return 0;
+
+ fault:
+	/* uh-oh - silly address alert, try and restore things */
+	__gdbstub_restore_bp();
+	return -EFAULT;
+}
+
+#ifdef CONFIG_GDBSTUB_CONSOLE
+
+void gdbstub_console_write(struct console *con, const char *p, unsigned n)
+{
+	static const char gdbstub_cr[] = { 0x0d };
+	char outbuf[26];
+	int qty;
+	u8 busy;
+
+	busy = gdbstub_busy;
+	gdbstub_busy = 1;
+
+	outbuf[0] = 'O';
+
+	while (n > 0) {
+		qty = 1;
+
+		while (n > 0 && qty < 20) {
+			mem2hex(p, outbuf + qty, 2, 0);
+			qty += 2;
+			if (*p == 0x0a) {
+				mem2hex(gdbstub_cr, outbuf + qty, 2, 0);
+				qty += 2;
+			}
+			p++;
+			n--;
+		}
+
+		outbuf[qty] = 0;
+		putpacket(outbuf);
+	}
+
+	gdbstub_busy = busy;
+}
+
+static kdev_t gdbstub_console_dev(struct console *con)
+{
+	return MKDEV(1, 3); /* /dev/null */
+}
+
+static struct console gdbstub_console = {
+	.name	= "gdb",
+	.write	= gdbstub_console_write,
+	.device	= gdbstub_console_dev,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1,
+};
+
+#endif
+
+/*
+ * Convert the memory pointed to by mem into hex, placing result in buf.
+ * - if successful, return a pointer to the last char put in buf (NUL)
+ * - in case of mem fault, return NULL
+ * may_fault is non-zero if we are reading from arbitrary memory, but is currently
+ * not used.
+ */
+static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
+{
+	const u8 *mem = _mem;
+	u8 ch[4];
+
+	if ((u32) mem & 1 && count >= 1) {
+		if (gdbstub_read_byte(mem, ch) != 0)
+			return 0;
+		*buf++ = hexchars[ch[0] >> 4];
+		*buf++ = hexchars[ch[0] & 0xf];
+		mem++;
+		count--;
+	}
+
+	if ((u32) mem & 3 && count >= 2) {
+		if (gdbstub_read_word(mem, ch) != 0)
+			return 0;
+		*buf++ = hexchars[ch[0] >> 4];
+		*buf++ = hexchars[ch[0] & 0xf];
+		*buf++ = hexchars[ch[1] >> 4];
+		*buf++ = hexchars[ch[1] & 0xf];
+		mem += 2;
+		count -= 2;
+	}
+
+	while (count >= 4) {
+		if (gdbstub_read_dword(mem, ch) != 0)
+			return 0;
+		*buf++ = hexchars[ch[0] >> 4];
+		*buf++ = hexchars[ch[0] & 0xf];
+		*buf++ = hexchars[ch[1] >> 4];
+		*buf++ = hexchars[ch[1] & 0xf];
+		*buf++ = hexchars[ch[2] >> 4];
+		*buf++ = hexchars[ch[2] & 0xf];
+		*buf++ = hexchars[ch[3] >> 4];
+		*buf++ = hexchars[ch[3] & 0xf];
+		mem += 4;
+		count -= 4;
+	}
+
+	if (count >= 2) {
+		if (gdbstub_read_word(mem, ch) != 0)
+			return 0;
+		*buf++ = hexchars[ch[0] >> 4];
+		*buf++ = hexchars[ch[0] & 0xf];
+		*buf++ = hexchars[ch[1] >> 4];
+		*buf++ = hexchars[ch[1] & 0xf];
+		mem += 2;
+		count -= 2;
+	}
+
+	if (count >= 1) {
+		if (gdbstub_read_byte(mem, ch) != 0)
+			return 0;
+		*buf++ = hexchars[ch[0] >> 4];
+		*buf++ = hexchars[ch[0] & 0xf];
+	}
+
+	*buf = 0;
+	return buf;
+}
+
+/*
+ * convert the hex array pointed to by buf into binary to be placed in mem
+ * return a pointer to the character AFTER the last byte written
+ * may_fault is non-zero if we are reading from arbitrary memory, but is currently
+ * not used.
+ */
+static const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
+{
+	u8 *mem = _mem;
+	union {
+		u32 val;
+		u8 b[4];
+	} ch;
+
+	if ((u32) mem & 1 && count >= 1) {
+		ch.b[0]  = hex(*buf++) << 4;
+		ch.b[0] |= hex(*buf++);
+		if (gdbstub_write_byte(ch.val, mem) != 0)
+			return 0;
+		mem++;
+		count--;
+	}
+
+	if ((u32) mem & 3 && count >= 2) {
+		ch.b[0]  = hex(*buf++) << 4;
+		ch.b[0] |= hex(*buf++);
+		ch.b[1]  = hex(*buf++) << 4;
+		ch.b[1] |= hex(*buf++);
+		if (gdbstub_write_word(ch.val, mem) != 0)
+			return 0;
+		mem += 2;
+		count -= 2;
+	}
+
+	while (count >= 4) {
+		ch.b[0]  = hex(*buf++) << 4;
+		ch.b[0] |= hex(*buf++);
+		ch.b[1]  = hex(*buf++) << 4;
+		ch.b[1] |= hex(*buf++);
+		ch.b[2]  = hex(*buf++) << 4;
+		ch.b[2] |= hex(*buf++);
+		ch.b[3]  = hex(*buf++) << 4;
+		ch.b[3] |= hex(*buf++);
+		if (gdbstub_write_dword(ch.val, mem) != 0)
+			return 0;
+		mem += 4;
+		count -= 4;
+	}
+
+	if (count >= 2) {
+		ch.b[0]  = hex(*buf++) << 4;
+		ch.b[0] |= hex(*buf++);
+		ch.b[1]  = hex(*buf++) << 4;
+		ch.b[1] |= hex(*buf++);
+		if (gdbstub_write_word(ch.val, mem) != 0)
+			return 0;
+		mem += 2;
+		count -= 2;
+	}
+
+	if (count >= 1) {
+		ch.b[0]  = hex(*buf++) << 4;
+		ch.b[0] |= hex(*buf++);
+		if (gdbstub_write_byte(ch.val, mem) != 0)
+			return 0;
+	}
+
+	return buf;
+}
+
+/*
+ * This table contains the mapping between MN10300 exception codes, and
+ * signals, which are primarily what GDB understands.  It also indicates
+ * which hardware traps we need to commandeer when initializing the stub.
+ */
+static const struct excep_to_sig_map {
+	exception_code_t	excep;	/* MN10300 exception code */
+	unsigned char		signo;	/* Signal that we map this into */
+} excep_to_sig_map[] = {
+	{ EXCEP_ITLBMISS,	SIGSEGV		},
+	{ EXCEP_DTLBMISS,	SIGSEGV		},
+	{ EXCEP_TRAP,		SIGTRAP		},
+	{ EXCEP_ISTEP,		SIGTRAP		},
+	{ EXCEP_IBREAK,		SIGTRAP		},
+	{ EXCEP_OBREAK,		SIGTRAP		},
+	{ EXCEP_UNIMPINS,	SIGILL		},
+	{ EXCEP_UNIMPEXINS,	SIGILL		},
+	{ EXCEP_MEMERR,		SIGSEGV		},
+	{ EXCEP_MISALIGN,	SIGSEGV		},
+	{ EXCEP_BUSERROR,	SIGBUS		},
+	{ EXCEP_ILLINSACC,	SIGSEGV		},
+	{ EXCEP_ILLDATACC,	SIGSEGV		},
+	{ EXCEP_IOINSACC,	SIGSEGV		},
+	{ EXCEP_PRIVINSACC,	SIGSEGV		},
+	{ EXCEP_PRIVDATACC,	SIGSEGV		},
+	{ EXCEP_FPU_DISABLED,	SIGFPE		},
+	{ EXCEP_FPU_UNIMPINS,	SIGFPE		},
+	{ EXCEP_FPU_OPERATION,	SIGFPE		},
+	{ EXCEP_WDT,		SIGALRM		},
+	{ EXCEP_NMI,		SIGQUIT		},
+	{ EXCEP_IRQ_LEVEL0,	SIGINT		},
+	{ EXCEP_IRQ_LEVEL1,	SIGINT		},
+	{ EXCEP_IRQ_LEVEL2,	SIGINT		},
+	{ EXCEP_IRQ_LEVEL3,	SIGINT		},
+	{ EXCEP_IRQ_LEVEL4,	SIGINT		},
+	{ EXCEP_IRQ_LEVEL5,	SIGINT		},
+	{ EXCEP_IRQ_LEVEL6,	SIGINT		},
+	{ 0, 0}
+};
+
+/*
+ * convert the MN10300 exception code into a UNIX signal number
+ */
+static int computeSignal(exception_code_t excep)
+{
+	const struct excep_to_sig_map *map;
+
+	for (map = excep_to_sig_map; map->signo; map++)
+		if (map->excep == excep)
+			return map->signo;
+
+	return SIGHUP; /* default for things we don't know about */
+}
+
+static u32 gdbstub_fpcr, gdbstub_fpufs_array[32];
+
+/*
+ *
+ */
+static void gdbstub_store_fpu(void)
+{
+#ifdef CONFIG_FPU
+
+	asm volatile(
+		"or %2,epsw\n"
+#ifdef CONFIG_MN10300_PROC_MN103E010
+		"nop\n"
+		"nop\n"
+#endif
+		"mov %1, a1\n"
+		"fmov fs0,  (a1+)\n"
+		"fmov fs1,  (a1+)\n"
+		"fmov fs2,  (a1+)\n"
+		"fmov fs3,  (a1+)\n"
+		"fmov fs4,  (a1+)\n"
+		"fmov fs5,  (a1+)\n"
+		"fmov fs6,  (a1+)\n"
+		"fmov fs7,  (a1+)\n"
+		"fmov fs8,  (a1+)\n"
+		"fmov fs9,  (a1+)\n"
+		"fmov fs10, (a1+)\n"
+		"fmov fs11, (a1+)\n"
+		"fmov fs12, (a1+)\n"
+		"fmov fs13, (a1+)\n"
+		"fmov fs14, (a1+)\n"
+		"fmov fs15, (a1+)\n"
+		"fmov fs16, (a1+)\n"
+		"fmov fs17, (a1+)\n"
+		"fmov fs18, (a1+)\n"
+		"fmov fs19, (a1+)\n"
+		"fmov fs20, (a1+)\n"
+		"fmov fs21, (a1+)\n"
+		"fmov fs22, (a1+)\n"
+		"fmov fs23, (a1+)\n"
+		"fmov fs24, (a1+)\n"
+		"fmov fs25, (a1+)\n"
+		"fmov fs26, (a1+)\n"
+		"fmov fs27, (a1+)\n"
+		"fmov fs28, (a1+)\n"
+		"fmov fs29, (a1+)\n"
+		"fmov fs30, (a1+)\n"
+		"fmov fs31, (a1+)\n"
+		"fmov fpcr, %0\n"
+		: "=d"(gdbstub_fpcr)
+		: "g" (&gdbstub_fpufs_array), "i"(EPSW_FE)
+		: "a1"
+		);
+#endif
+}
+
+/*
+ *
+ */
+static void gdbstub_load_fpu(void)
+{
+#ifdef CONFIG_FPU
+
+	asm volatile(
+		"or %1,epsw\n"
+#ifdef CONFIG_MN10300_PROC_MN103E010
+		"nop\n"
+		"nop\n"
+#endif
+		"mov %0, a1\n"
+		"fmov (a1+), fs0\n"
+		"fmov (a1+), fs1\n"
+		"fmov (a1+), fs2\n"
+		"fmov (a1+), fs3\n"
+		"fmov (a1+), fs4\n"
+		"fmov (a1+), fs5\n"
+		"fmov (a1+), fs6\n"
+		"fmov (a1+), fs7\n"
+		"fmov (a1+), fs8\n"
+		"fmov (a1+), fs9\n"
+		"fmov (a1+), fs10\n"
+		"fmov (a1+), fs11\n"
+		"fmov (a1+), fs12\n"
+		"fmov (a1+), fs13\n"
+		"fmov (a1+), fs14\n"
+		"fmov (a1+), fs15\n"
+		"fmov (a1+), fs16\n"
+		"fmov (a1+), fs17\n"
+		"fmov (a1+), fs18\n"
+		"fmov (a1+), fs19\n"
+		"fmov (a1+), fs20\n"
+		"fmov (a1+), fs21\n"
+		"fmov (a1+), fs22\n"
+		"fmov (a1+), fs23\n"
+		"fmov (a1+), fs24\n"
+		"fmov (a1+), fs25\n"
+		"fmov (a1+), fs26\n"
+		"fmov (a1+), fs27\n"
+		"fmov (a1+), fs28\n"
+		"fmov (a1+), fs29\n"
+		"fmov (a1+), fs30\n"
+		"fmov (a1+), fs31\n"
+		"fmov %2, fpcr\n"
+		:
+		: "g" (&gdbstub_fpufs_array), "i"(EPSW_FE), "d"(gdbstub_fpcr)
+		: "a1"
+	);
+#endif
+}
+
+/*
+ * set a software breakpoint
+ */
+int gdbstub_set_breakpoint(u8 *addr, int len)
+{
+	int bkpt, loop, xloop;
+
+#ifdef GDBSTUB_USE_F7F7_AS_BREAKPOINT
+	len = (len + 1) & ~1;
+#endif
+
+	gdbstub_bkpt("setbkpt(%p,%d)\n", addr, len);
+
+	for (bkpt = 255; bkpt >= 0; bkpt--)
+		if (!gdbstub_bkpts[bkpt].addr)
+			break;
+	if (bkpt < 0)
+		return -ENOSPC;
+
+	for (loop = 0; loop < len; loop++)
+		if (gdbstub_read_byte(&addr[loop],
+				      &gdbstub_bkpts[bkpt].origbytes[loop]
+				      ) < 0)
+			return -EFAULT;
+
+	gdbstub_flush_caches = 1;
+
+#ifdef GDBSTUB_USE_F7F7_AS_BREAKPOINT
+	for (loop = 0; loop < len; loop++)
+		if (gdbstub_write_byte(0xF7, &addr[loop]) < 0)
+			goto restore;
+#else
+	for (loop = 0; loop < len; loop++)
+		if (gdbstub_write_byte(0xFF, &addr[loop]) < 0)
+			goto restore;
+#endif
+
+	gdbstub_bkpts[bkpt].addr = addr;
+	gdbstub_bkpts[bkpt].len = len;
+
+	gdbstub_bkpt("Set BKPT[%02x]: %p-%p {%02x%02x%02x%02x%02x%02x%02x}\n",
+		     bkpt,
+		     gdbstub_bkpts[bkpt].addr,
+		     gdbstub_bkpts[bkpt].addr + gdbstub_bkpts[bkpt].len - 1,
+		     gdbstub_bkpts[bkpt].origbytes[0],
+		     gdbstub_bkpts[bkpt].origbytes[1],
+		     gdbstub_bkpts[bkpt].origbytes[2],
+		     gdbstub_bkpts[bkpt].origbytes[3],
+		     gdbstub_bkpts[bkpt].origbytes[4],
+		     gdbstub_bkpts[bkpt].origbytes[5],
+		     gdbstub_bkpts[bkpt].origbytes[6]
+		     );
+
+	return 0;
+
+restore:
+	for (xloop = 0; xloop < loop; xloop++)
+		gdbstub_write_byte(gdbstub_bkpts[bkpt].origbytes[xloop],
+				   addr + xloop);
+	return -EFAULT;
+}
+
+/*
+ * clear a software breakpoint
+ */
+int gdbstub_clear_breakpoint(u8 *addr, int len)
+{
+	int bkpt, loop;
+
+#ifdef GDBSTUB_USE_F7F7_AS_BREAKPOINT
+	len = (len + 1) & ~1;
+#endif
+
+	gdbstub_bkpt("clearbkpt(%p,%d)\n", addr, len);
+
+	for (bkpt = 255; bkpt >= 0; bkpt--)
+		if (gdbstub_bkpts[bkpt].addr == addr &&
+		    gdbstub_bkpts[bkpt].len == len)
+			break;
+	if (bkpt < 0)
+		return -ENOENT;
+
+	gdbstub_bkpts[bkpt].addr = NULL;
+
+	gdbstub_flush_caches = 1;
+
+	for (loop = 0; loop < len; loop++)
+		if (gdbstub_write_byte(gdbstub_bkpts[bkpt].origbytes[loop],
+				       addr + loop) < 0)
+			return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * This function does all command processing for interfacing to gdb
+ * - returns 1 if the exception should be skipped, 0 otherwise.
+ */
+static int gdbstub(struct pt_regs *regs, exception_code_t excep)
+{
+	unsigned long *stack;
+	unsigned long epsw, mdr;
+	uint32_t zero, ssp;
+	uint8_t broke;
+	char *ptr;
+	int sigval;
+	int addr;
+	int length;
+	int loop;
+
+	if (excep == EXCEP_FPU_DISABLED)
+		return 0;
+
+	gdbstub_flush_caches = 0;
+
+	mn10300_set_gdbleds(1);
+
+	asm volatile("mov mdr,%0" : "=d"(mdr));
+	asm volatile("mov epsw,%0" : "=d"(epsw));
+	asm volatile("mov %0,epsw"
+		     :: "d"((epsw & ~EPSW_IM) | EPSW_IE | EPSW_IM_1));
+
+	gdbstub_store_fpu();
+
+#ifdef CONFIG_GDBSTUB_IMMEDIATE
+	/* skip the initial pause loop */
+	if (regs->pc == (unsigned long) __gdbstub_pause)
+		regs->pc = (unsigned long) start_kernel;
+#endif
+
+	/* if we were single stepping, restore the opcodes hoisted for the
+	 * breakpoint[s] */
+	broke = 0;
+	if ((step_bp[0].addr && step_bp[0].addr == (u8 *) regs->pc) ||
+	    (step_bp[1].addr && step_bp[1].addr == (u8 *) regs->pc))
+		broke = 1;
+
+	__gdbstub_restore_bp();
+
+	if (gdbstub_rx_unget) {
+		sigval = SIGINT;
+		if (gdbstub_rx_unget != 3)
+			goto packet_waiting;
+		gdbstub_rx_unget = 0;
+	}
+
+	stack = (unsigned long *) regs->sp;
+	sigval = broke ? SIGTRAP : computeSignal(excep);
+
+	/* send information about a BUG() */
+	if (!user_mode(regs) && excep == EXCEP_SYSCALL15) {
+		const struct bug_entry *bug;
+
+		bug = find_bug(regs->pc);
+		if (bug)
+			goto found_bug;
+		length = snprintf(trans_buffer, sizeof(trans_buffer),
+				  "BUG() at address %lx\n", regs->pc);
+		goto send_bug_pkt;
+
+	found_bug:
+		length = snprintf(trans_buffer, sizeof(trans_buffer),
+				  "BUG() at address %lx (%s:%d)\n",
+				  regs->pc, bug->file, bug->line);
+
+	send_bug_pkt:
+		ptr = output_buffer;
+		*ptr++ = 'O';
+		ptr = mem2hex(trans_buffer, ptr, length, 0);
+		*ptr = 0;
+		putpacket(output_buffer);
+
+		regs->pc -= 2;
+		sigval = SIGABRT;
+	} else if (regs->pc == (unsigned long) __gdbstub_bug_trap) {
+		regs->pc = regs->mdr;
+		sigval = SIGABRT;
+	}
+
+	/*
+	 * send a message to the debugger's user saying what happened if it may
+	 * not be clear cut (we can't map exceptions onto signals properly)
+	 */
+	if (sigval != SIGINT && sigval != SIGTRAP && sigval != SIGILL) {
+		static const char title[] = "Excep ", tbcberr[] = "BCBERR ";
+		static const char crlf[] = "\r\n";
+		char hx;
+		u32 bcberr = BCBERR;
+
+		ptr = output_buffer;
+		*ptr++ = 'O';
+		ptr = mem2hex(title, ptr, sizeof(title) - 1, 0);
+
+		hx = hexchars[(excep & 0xf000) >> 12];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(excep & 0x0f00) >> 8];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(excep & 0x00f0) >> 4];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(excep & 0x000f)];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+
+		ptr = mem2hex(crlf,ptr,sizeof(crlf)-1,0);
+		*ptr = 0;
+		putpacket(output_buffer);	/* send it off... */
+
+		/* BCBERR */
+		ptr = output_buffer;
+		*ptr++ = 'O';
+		ptr = mem2hex(tbcberr, ptr, sizeof(tbcberr) - 1, 0);
+
+		hx = hexchars[(bcberr & 0xf0000000) >> 28];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(bcberr & 0x0f000000) >> 24];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(bcberr & 0x00f00000) >> 20];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(bcberr & 0x000f0000) >> 16];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(bcberr & 0x0000f000) >> 12];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(bcberr & 0x00000f00) >> 8];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(bcberr & 0x000000f0) >> 4];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hexchars[(bcberr & 0x0000000f)];
+		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+
+		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
+		*ptr = 0;
+		putpacket(output_buffer);	/* send it off... */
+	}
+
+	/*
+	 * tell the debugger that an exception has occurred
+	 */
+	ptr = output_buffer;
+
+	/*
+	 * Send trap type (converted to signal)
+	 */
+	*ptr++ = 'T';
+	*ptr++ = hexchars[sigval >> 4];
+	*ptr++ = hexchars[sigval & 0xf];
+
+	/*
+	 * Send Error PC
+	 */
+	*ptr++ = hexchars[GDB_REGID_PC >> 4];
+	*ptr++ = hexchars[GDB_REGID_PC & 0xf];
+	*ptr++ = ':';
+	ptr = mem2hex(&regs->pc, ptr, 4, 0);
+	*ptr++ = ';';
+
+	/*
+	 * Send frame pointer
+	 */
+	*ptr++ = hexchars[GDB_REGID_FP >> 4];
+	*ptr++ = hexchars[GDB_REGID_FP & 0xf];
+	*ptr++ = ':';
+	ptr = mem2hex(&regs->a3, ptr, 4, 0);
+	*ptr++ = ';';
+
+	/*
+	 * Send stack pointer
+	 */
+	ssp = (unsigned long) (regs + 1);
+	*ptr++ = hexchars[GDB_REGID_SP >> 4];
+	*ptr++ = hexchars[GDB_REGID_SP & 0xf];
+	*ptr++ = ':';
+	ptr = mem2hex(&ssp, ptr, 4, 0);
+	*ptr++ = ';';
+
+	*ptr++ = 0;
+	putpacket(output_buffer);	/* send it off... */
+
+packet_waiting:
+	/*
+	 * Wait for input from remote GDB
+	 */
+	while (1) {
+		output_buffer[0] = 0;
+		getpacket(input_buffer);
+
+		switch (input_buffer[0]) {
+			/* request repeat of last signal number */
+		case '?':
+			output_buffer[0] = 'S';
+			output_buffer[1] = hexchars[sigval >> 4];
+			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[3] = 0;
+			break;
+
+		case 'd':
+			/* toggle debug flag */
+			break;
+
+			/*
+			 * Return the value of the CPU registers
+			 */
+		case 'g':
+			zero = 0;
+			ssp = (u32) (regs + 1);
+			ptr = output_buffer;
+			ptr = mem2hex(&regs->d0, ptr, 4, 0);
+			ptr = mem2hex(&regs->d1, ptr, 4, 0);
+			ptr = mem2hex(&regs->d2, ptr, 4, 0);
+			ptr = mem2hex(&regs->d3, ptr, 4, 0);
+			ptr = mem2hex(&regs->a0, ptr, 4, 0);
+			ptr = mem2hex(&regs->a1, ptr, 4, 0);
+			ptr = mem2hex(&regs->a2, ptr, 4, 0);
+			ptr = mem2hex(&regs->a3, ptr, 4, 0);
+
+			ptr = mem2hex(&ssp, ptr, 4, 0);		/* 8 */
+			ptr = mem2hex(&regs->pc, ptr, 4, 0);
+			ptr = mem2hex(&regs->mdr, ptr, 4, 0);
+			ptr = mem2hex(&regs->epsw, ptr, 4, 0);
+			ptr = mem2hex(&regs->lir, ptr, 4, 0);
+			ptr = mem2hex(&regs->lar, ptr, 4, 0);
+			ptr = mem2hex(&regs->mdrq, ptr, 4, 0);
+
+			ptr = mem2hex(&regs->e0, ptr, 4, 0);	/* 15 */
+			ptr = mem2hex(&regs->e1, ptr, 4, 0);
+			ptr = mem2hex(&regs->e2, ptr, 4, 0);
+			ptr = mem2hex(&regs->e3, ptr, 4, 0);
+			ptr = mem2hex(&regs->e4, ptr, 4, 0);
+			ptr = mem2hex(&regs->e5, ptr, 4, 0);
+			ptr = mem2hex(&regs->e6, ptr, 4, 0);
+			ptr = mem2hex(&regs->e7, ptr, 4, 0);
+
+			ptr = mem2hex(&ssp, ptr, 4, 0);
+			ptr = mem2hex(&regs, ptr, 4, 0);
+			ptr = mem2hex(&regs->sp, ptr, 4, 0);
+			ptr = mem2hex(&regs->mcrh, ptr, 4, 0);	/* 26 */
+			ptr = mem2hex(&regs->mcrl, ptr, 4, 0);
+			ptr = mem2hex(&regs->mcvf, ptr, 4, 0);
+
+			ptr = mem2hex(&gdbstub_fpcr, ptr, 4, 0); /* 29 - FPCR */
+			ptr = mem2hex(&zero, ptr, 4, 0);
+			ptr = mem2hex(&zero, ptr, 4, 0);
+			for (loop = 0; loop < 32; loop++)
+				ptr = mem2hex(&gdbstub_fpufs_array[loop],
+					      ptr, 4, 0); /* 32 - FS0-31 */
+
+			break;
+
+			/*
+			 * set the value of the CPU registers - return OK
+			 */
+		case 'G':
+		{
+			const char *ptr;
+
+			ptr = &input_buffer[1];
+			ptr = hex2mem(ptr, &regs->d0, 4, 0);
+			ptr = hex2mem(ptr, &regs->d1, 4, 0);
+			ptr = hex2mem(ptr, &regs->d2, 4, 0);
+			ptr = hex2mem(ptr, &regs->d3, 4, 0);
+			ptr = hex2mem(ptr, &regs->a0, 4, 0);
+			ptr = hex2mem(ptr, &regs->a1, 4, 0);
+			ptr = hex2mem(ptr, &regs->a2, 4, 0);
+			ptr = hex2mem(ptr, &regs->a3, 4, 0);
+
+			ptr = hex2mem(ptr, &ssp, 4, 0);		/* 8 */
+			ptr = hex2mem(ptr, &regs->pc, 4, 0);
+			ptr = hex2mem(ptr, &regs->mdr, 4, 0);
+			ptr = hex2mem(ptr, &regs->epsw, 4, 0);
+			ptr = hex2mem(ptr, &regs->lir, 4, 0);
+			ptr = hex2mem(ptr, &regs->lar, 4, 0);
+			ptr = hex2mem(ptr, &regs->mdrq, 4, 0);
+
+			ptr = hex2mem(ptr, &regs->e0, 4, 0);	/* 15 */
+			ptr = hex2mem(ptr, &regs->e1, 4, 0);
+			ptr = hex2mem(ptr, &regs->e2, 4, 0);
+			ptr = hex2mem(ptr, &regs->e3, 4, 0);
+			ptr = hex2mem(ptr, &regs->e4, 4, 0);
+			ptr = hex2mem(ptr, &regs->e5, 4, 0);
+			ptr = hex2mem(ptr, &regs->e6, 4, 0);
+			ptr = hex2mem(ptr, &regs->e7, 4, 0);
+
+			ptr = hex2mem(ptr, &ssp, 4, 0);
+			ptr = hex2mem(ptr, &zero, 4, 0);
+			ptr = hex2mem(ptr, &regs->sp, 4, 0);
+			ptr = hex2mem(ptr, &regs->mcrh, 4, 0);	/* 26 */
+			ptr = hex2mem(ptr, &regs->mcrl, 4, 0);
+			ptr = hex2mem(ptr, &regs->mcvf, 4, 0);
+
+			ptr = hex2mem(ptr, &zero, 4, 0);	/* 29 - FPCR */
+			ptr = hex2mem(ptr, &zero, 4, 0);
+			ptr = hex2mem(ptr, &zero, 4, 0);
+			for (loop = 0; loop < 32; loop++)
+				ptr = hex2mem(ptr, &zero, 4, 0); /* 32 - FS0-31 */
+
+#if 0
+			/*
+			 * See if the stack pointer has moved. If so, then copy
+			 * the saved locals and ins to the new location.
+			 */
+			unsigned long *newsp = (unsigned long *) registers[SP];
+			if (sp != newsp)
+				sp = memcpy(newsp, sp, 16 * 4);
+#endif
+
+			gdbstub_strcpy(output_buffer,"OK");
+		}
+		break;
+
+		/*
+		 * mAA..AA,LLLL  Read LLLL bytes at address AA..AA
+		 */
+		case 'm':
+			ptr = &input_buffer[1];
+
+			if (hexToInt(&ptr, &addr) &&
+			    *ptr++ == ',' &&
+			    hexToInt(&ptr, &length)
+			    ) {
+				if (mem2hex((char *) addr, output_buffer,
+					    length, 1))
+					break;
+				gdbstub_strcpy(output_buffer, "E03");
+			} else {
+				gdbstub_strcpy(output_buffer,"E01");
+			}
+			break;
+
+			/*
+			 * MAA..AA,LLLL: Write LLLL bytes at address AA.AA
+			 * return OK
+			 */
+		case 'M':
+			ptr = &input_buffer[1];
+
+			if (hexToInt(&ptr, &addr) &&
+			    *ptr++ == ',' &&
+			    hexToInt(&ptr, &length) &&
+			    *ptr++ == ':'
+			    ) {
+				if (hex2mem(ptr, (char *) addr, length, 1))
+					gdbstub_strcpy(output_buffer, "OK");
+				else
+					gdbstub_strcpy(output_buffer, "E03");
+
+				gdbstub_flush_caches = 1;
+			} else {
+				gdbstub_strcpy(output_buffer, "E02");
+			}
+			break;
+
+			/*
+			 * cAA..AA    Continue at address AA..AA(optional)
+			 */
+		case 'c':
+			/* try to read optional parameter, pc unchanged if no
+			 * parm */
+
+			ptr = &input_buffer[1];
+			if (hexToInt(&ptr, &addr))
+				regs->pc = addr;
+			goto done;
+
+			/*
+			 * kill the program
+			 */
+		case 'k' :
+			goto done;	/* just continue */
+
+			/*
+			 * Reset the whole machine (FIXME: system dependent)
+			 */
+		case 'r':
+			break;
+
+			/*
+			 * Step to next instruction
+			 */
+		case 's':
+			/*
+			 * using the T flag doesn't seem to perform single
+			 * stepping (it seems to wind up being caught by the
+			 * JTAG unit), so we have to use breakpoints and
+			 * continue instead.
+			 */
+			if (gdbstub_single_step(regs) < 0) {
+				/* ignore any fault error for now */
+				gdbstub_printk("unable to set single-step bp\n");
+			}
+
+			goto done;
+
+			/*
+			 * Set baud rate (bBB)
+			 */
+		case 'b':
+			do {
+				int baudrate;
+
+				ptr = &input_buffer[1];
+				if (!hexToInt(&ptr, &baudrate)) {
+					gdbstub_strcpy(output_buffer, "B01");
+					break;
+				}
+
+				if (baudrate) {
+					/* ACK before changing speed */
+					putpacket("OK");
+					gdbstub_io_set_baud(baudrate);
+				}
+			} while(0);
+			break;
+
+			/*
+			 * Set breakpoint
+			 */
+		case 'Z':
+			ptr = &input_buffer[1];
+
+			if (!hexToInt(&ptr, &loop) || *ptr++ != ',' ||
+			    !hexToInt(&ptr, &addr) || *ptr++ != ',' ||
+			    !hexToInt(&ptr, &length)
+			    ) {
+				gdbstub_strcpy(output_buffer, "E01");
+				break;
+			}
+
+			/* only support software breakpoints */
+			gdbstub_strcpy(output_buffer, "E03");
+			if (loop != 0 ||
+			    length < 1 ||
+			    length > 7 ||
+			    (unsigned long) addr < 4096)
+				break;
+
+			if (gdbstub_set_breakpoint((u8 *) addr, length) < 0)
+				break;
+
+			gdbstub_strcpy(output_buffer, "OK");
+			break;
+
+			/*
+			 * Clear breakpoint
+			 */
+		case 'z':
+			ptr = &input_buffer[1];
+
+			if (!hexToInt(&ptr, &loop) || *ptr++ != ',' ||
+			    !hexToInt(&ptr, &addr) || *ptr++ != ',' ||
+			    !hexToInt(&ptr, &length)
+			    ) {
+				gdbstub_strcpy(output_buffer,"E01");
+				break;
+			}
+
+			/* only support software breakpoints */
+			gdbstub_strcpy(output_buffer,"E03");
+			if (loop != 0 ||
+			    length < 1 ||
+			    length > 7 ||
+			    (unsigned long) addr < 4096)
+				break;
+
+			if (gdbstub_clear_breakpoint((u8 *) addr, length) < 0)
+				break;
+
+			gdbstub_strcpy(output_buffer,"OK");
+			break;
+
+		default:
+			gdbstub_proto("### GDB Unsupported Cmd '%s'\n",
+				      input_buffer);
+			break;
+		}
+
+		/* reply to the request */
+		putpacket(output_buffer);
+	}
+
+done:
+	/*
+	 * Need to flush the instruction cache here, as we may
+	 * have deposited a breakpoint, and the icache probably
+	 * has no way of knowing that a data ref to some location
+	 * may have changed something that is in the instruction
+	 * cache.
+	 * NB: We flush both caches, just to be sure...
+	 */
+	if (gdbstub_flush_caches)
+		gdbstub_purge_cache();
+
+	gdbstub_load_fpu();
+	mn10300_set_gdbleds(0);
+	if (excep == EXCEP_NMI)
+		NMICR = NMICR_NMIF;
+
+	touch_softlockup_watchdog();
+
+	local_irq_restore(epsw);
+	return 1;
+}
+
+/*
+ * handle event interception
+ */
+asmlinkage int gdbstub_intercept(struct pt_regs *regs, exception_code_t excep)
+{
+	static u8 notfirst = 1;
+	int ret;
+
+	if (gdbstub_busy)
+		gdbstub_printk("--> gdbstub reentered itself\n");
+	gdbstub_busy = 1;
+
+	if (notfirst) {
+		unsigned long mdr;
+		asm("mov mdr,%0" : "=d"(mdr));
+
+		gdbstub_entry("--> gdbstub_intercept(%p,%04x) [MDR=%lx PC=%lx]\n",
+			      regs, excep, mdr, regs->pc);
+
+		gdbstub_entry("PC:  %08lx EPSW:  %08lx  SSP: %08lx mode: %s\n",
+			      regs->pc, regs->epsw, (unsigned long) &ret,
+			      user_mode(regs) ? "User" : "Super");
+		gdbstub_entry("d0:  %08lx   d1:  %08lx   d2: %08lx   d3: %08lx\n",
+			      regs->d0, regs->d1, regs->d2, regs->d3);
+		gdbstub_entry("a0:  %08lx   a1:  %08lx   a2: %08lx   a3: %08lx\n",
+			      regs->a0, regs->a1, regs->a2, regs->a3);
+		gdbstub_entry("e0:  %08lx   e1:  %08lx   e2: %08lx   e3: %08lx\n",
+			      regs->e0, regs->e1, regs->e2, regs->e3);
+		gdbstub_entry("e4:  %08lx   e5:  %08lx   e6: %08lx   e7: %08lx\n",
+			      regs->e4, regs->e5, regs->e6, regs->e7);
+		gdbstub_entry("lar: %08lx   lir: %08lx  mdr: %08lx  usp: %08lx\n",
+			      regs->lar, regs->lir, regs->mdr, regs->sp);
+		gdbstub_entry("cvf: %08lx   crl: %08lx  crh: %08lx  drq: %08lx\n",
+			      regs->mcvf, regs->mcrl, regs->mcrh, regs->mdrq);
+		gdbstub_entry("threadinfo=%p task=%p)\n",
+			      current_thread_info(), current);
+	} else {
+		notfirst = 1;
+	}
+
+	ret = gdbstub(regs, excep);
+
+	gdbstub_entry("<-- gdbstub_intercept()\n");
+	gdbstub_busy = 0;
+	return ret;
+}
+
+/*
+ * handle the GDB stub itself causing an exception
+ */
+asmlinkage void gdbstub_exception(struct pt_regs *regs, exception_code_t excep)
+{
+	unsigned long mdr;
+
+	asm("mov mdr,%0" : "=d"(mdr));
+	gdbstub_entry("--> gdbstub exception({%p},%04x) [MDR=%lx]\n",
+		      regs, excep, mdr);
+
+	while ((unsigned long) regs == 0xffffffff) {}
+
+	/* handle guarded memory accesses where we know it might fault */
+	if (regs->pc == (unsigned) gdbstub_read_byte_guard) {
+		regs->pc = (unsigned) gdbstub_read_byte_cont;
+		goto fault;
+	}
+
+	if (regs->pc == (unsigned) gdbstub_read_word_guard) {
+		regs->pc = (unsigned) gdbstub_read_word_cont;
+		goto fault;
+	}
+
+	if (regs->pc == (unsigned) gdbstub_read_dword_guard) {
+		regs->pc = (unsigned) gdbstub_read_dword_cont;
+		goto fault;
+	}
+
+	if (regs->pc == (unsigned) gdbstub_write_byte_guard) {
+		regs->pc = (unsigned) gdbstub_write_byte_cont;
+		goto fault;
+	}
+
+	if (regs->pc == (unsigned) gdbstub_write_word_guard) {
+		regs->pc = (unsigned) gdbstub_write_word_cont;
+		goto fault;
+	}
+
+	if (regs->pc == (unsigned) gdbstub_write_dword_guard) {
+		regs->pc = (unsigned) gdbstub_write_dword_cont;
+		goto fault;
+	}
+
+	gdbstub_printk("\n### GDB stub caused an exception ###\n");
+
+	/* something went horribly wrong */
+	console_verbose();
+	show_registers(regs);
+
+	panic("GDB Stub caused an unexpected exception - can't continue\n");
+
+	/* we caught an attempt by the stub to access silly memory */
+fault:
+	gdbstub_entry("<-- gdbstub exception() = EFAULT\n");
+	regs->d0 = -EFAULT;
+	return;
+}
+
+/*
+ * send an exit message to GDB
+ */
+void gdbstub_exit(int status)
+{
+	unsigned char checksum;
+	unsigned char ch;
+	int count;
+
+	gdbstub_busy = 1;
+	output_buffer[0] = 'W';
+	output_buffer[1] = hexchars[(status >> 4) & 0x0F];
+	output_buffer[2] = hexchars[status & 0x0F];
+	output_buffer[3] = 0;
+
+	gdbstub_io_tx_char('$');
+	checksum = 0;
+	count = 0;
+
+	while ((ch = output_buffer[count]) != 0) {
+		gdbstub_io_tx_char(ch);
+		checksum += ch;
+		count += 1;
+	}
+
+	gdbstub_io_tx_char('#');
+	gdbstub_io_tx_char(hexchars[checksum >> 4]);
+	gdbstub_io_tx_char(hexchars[checksum & 0xf]);
+
+	/* make sure the output is flushed, or else RedBoot might clobber it */
+	gdbstub_io_tx_flush();
+
+	gdbstub_busy = 0;
+}
+
+/*
+ * initialise the GDB stub
+ */
+asmlinkage void __init gdbstub_init(void)
+{
+#ifdef CONFIG_GDBSTUB_IMMEDIATE
+	unsigned char ch;
+	int ret;
+#endif
+
+	gdbstub_busy = 1;
+
+	printk("%s", gdbstub_banner);
+
+	gdbstub_io_init();
+
+	gdbstub_entry("--> gdbstub_init\n");
+
+	/* try to talk to GDB (or anyone insane enough to want to type GDB
+	 * protocol by hand) */
+	gdbstub_io("### GDB Tx ACK\n");
+	gdbstub_io_tx_char('+'); /* 'hello world' */
+
+#ifdef CONFIG_GDBSTUB_IMMEDIATE
+	gdbstub_printk("GDB Stub waiting for packet\n");
+
+	/* in case GDB is started before us, ACK any packets that are already
+	 * sitting there (presumably "$?#xx")
+	 */
+	do { gdbstub_io_rx_char(&ch, 0); } while (ch != '$');
+	do { gdbstub_io_rx_char(&ch, 0); } while (ch != '#');
+	do { ret = gdbstub_io_rx_char(&ch, 0); } while (ret != 0); /* eat first csum byte */
+	do { ret = gdbstub_io_rx_char(&ch, 0); } while (ret != 0); /* eat second csum byte */
+
+	gdbstub_io("### GDB Tx NAK\n");
+	gdbstub_io_tx_char('-'); /* nak it */
+
+#else
+	printk("GDB Stub ready\n");
+#endif
+
+	gdbstub_busy = 0;
+	gdbstub_entry("<-- gdbstub_init\n");
+}
+
+/*
+ * register the console at a more appropriate time
+ */
+#ifdef CONFIG_GDBSTUB_CONSOLE
+static int __init gdbstub_postinit(void)
+{
+	printk("registering console\n");
+	register_console(&gdbstub_console);
+	return 0;
+}
+
+__initcall(gdbstub_postinit);
+#endif
+
+/*
+ * handle character reception on GDB serial port
+ * - jump into the GDB stub if BREAK is detected on the serial line
+ */
+asmlinkage void gdbstub_rx_irq(struct pt_regs *regs, exception_code_t excep)
+{
+	char ch;
+	int ret;
+
+	gdbstub_entry("--> gdbstub_rx_irq\n");
+
+	do {
+		ret = gdbstub_io_rx_char(&ch, 1);
+		if (ret != -EIO && ret != -EAGAIN) {
+			if (ret != -EINTR)
+				gdbstub_rx_unget = ch;
+			gdbstub(regs, excep);
+		}
+	} while (ret != -EAGAIN);
+
+	gdbstub_entry("<-- gdbstub_rx_irq\n");
+}
diff -puN /dev/null arch/mn10300/kernel/head.S
--- /dev/null
+++ a/arch/mn10300/kernel/head.S
@@ -0,0 +1,254 @@
+/* Boot entry point for MN10300 kernel
+ *
+ * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/threads.h>
+#include <linux/linkage.h>
+#include <linux/serial_reg.h>
+#include <asm/thread_info.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/frame.inc>
+#include <asm/param.h>
+#include <asm/unit/serial.h>
+
+	.section .text.head,"ax"
+
+###############################################################################
+#
+# bootloader entry point
+#
+###############################################################################
+	.globl	_start
+	.type	_start,@function
+_start:
+	# save commandline pointer
+	mov	d0,a3
+	
+	# preload the PGD pointer register
+	mov	swapper_pg_dir,d0
+	mov	d0,(PTBR)
+
+	# turn on the TLBs
+	mov	MMUCTR_IIV|MMUCTR_DIV,d0
+	mov	d0,(MMUCTR)
+	mov	MMUCTR_ITE|MMUCTR_DTE|MMUCTR_CE,d0
+	mov	d0,(MMUCTR)
+
+	# turn on AM33v2 exception handling mode and set the trap table base
+	movhu	(CPUP),d0
+	or	CPUP_EXM_AM33V2,d0
+	movhu	d0,(CPUP)
+	mov	CONFIG_INTERRUPT_VECTOR_BASE,d0
+	mov	d0,(TBR)
+
+	# invalidate and enable both of the caches
+	mov	CHCTR,a0
+	clr	d0
+	movhu	d0,(a0)					# turn off first
+	mov	CHCTR_ICINV|CHCTR_DCINV,d0
+	movhu	d0,(a0)
+	setlb
+	mov	(a0),d0
+	btst	CHCTR_ICBUSY|CHCTR_DCBUSY,d0		# wait till not busy (use CPU loop buffer)
+	lne
+
+#ifndef CONFIG_MN10300_CACHE_DISABLED
+#ifdef CONFIG_MN10300_CACHE_WBACK
+#ifndef CONFIG_MN10300_CACHE_WBACK_NOWRALLOC
+	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRBACK,d0
+#else
+	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRBACK|CHCTR_DCALMD,d0
+#endif /* CACHE_DISABLED */
+#else
+	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRTHROUGH,d0
+#endif /* WBACK */
+	movhu	d0,(a0)					# enable
+#endif /* NOWRALLOC */
+
+	# turn on RTS on the debug serial port if applicable
+#ifdef CONFIG_MN10300_UNIT_ASB2305
+	bset	UART_MCR_RTS,(ASB2305_DEBUG_MCR)
+#endif
+
+	# clear the BSS area
+	mov	__bss_start,a0
+	mov	__bss_stop,a1
+	clr	d0
+bssclear:
+	cmp	a1,a0
+	bge	bssclear_end
+	mov	d0,(a0)
+	inc4	a0
+	bra	bssclear
+bssclear_end:
+
+	# retrieve the parameters (including command line) before we overwrite them
+	cmp	0xabadcafe,d1
+	bne	__no_parameters
+
+__copy_parameters:
+	mov	redboot_command_line,a0
+	mov	a0,a1
+	add	COMMAND_LINE_SIZE,a1
+1:
+	movbu	(a3),d0
+	inc	a3
+	movbu	d0,(a0)
+	inc	a0
+	cmp	a1,a0
+	blt	1b
+
+	mov	redboot_platform_name,a0
+	mov	a0,a1
+	add	COMMAND_LINE_SIZE,a1
+	mov	d2,a3
+1:
+	movbu	(a3),d0
+	inc	a3
+	movbu	d0,(a0)
+	inc	a0
+	cmp	a1,a0
+	blt	1b
+	
+__no_parameters:
+	
+	# set up the registers with recognisable rubbish in them
+	mov	init_thread_union+THREAD_SIZE-12,sp
+
+	mov	0xea01eaea,d0
+	mov	d0,(4,sp)		# EPSW save area
+	mov	0xea02eaea,d0
+	mov	d0,(8,sp)		# PC save area
+
+	mov	0xeb0060ed,d0
+	mov	d0,mdr
+	mov	0xeb0061ed,d0
+	mov	d0,mdrq
+	mov	0xeb0062ed,d0
+	mov	d0,mcrh
+	mov	0xeb0063ed,d0
+	mov	d0,mcrl
+	mov	0xeb0064ed,d0
+	mov	d0,mcvf
+	mov	0xed0065ed,a3
+	mov	a3,usp
+
+	mov	0xed00e0ed,e0
+	mov	0xed00e1ed,e1
+	mov	0xed00e2ed,e2
+	mov	0xed00e3ed,e3
+	mov	0xed00e4ed,e4
+	mov	0xed00e5ed,e5
+	mov	0xed00e6ed,e6
+	mov	0xed00e7ed,e7
+
+	mov	0xed00d0ed,d0
+	mov	0xed00d1ed,d1
+	mov	0xed00d2ed,d2
+	mov	0xed00d3ed,d3
+	mov	0xed00a0ed,a0
+	mov	0xed00a1ed,a1
+	mov	0xed00a2ed,a2
+	mov	0,a3
+
+	# set up the initial kernel stack
+	SAVE_ALL
+	mov	0xffffffff,d0
+	mov	d0,(REG_ORIG_D0,fp)
+
+	# put different recognisable rubbish in the regs
+	mov	0xfb0060ed,d0
+	mov	d0,mdr
+	mov	0xfb0061ed,d0
+	mov	d0,mdrq
+	mov	0xfb0062ed,d0
+	mov	d0,mcrh
+	mov	0xfb0063ed,d0
+	mov	d0,mcrl
+	mov	0xfb0064ed,d0
+	mov	d0,mcvf
+	mov	0xfd0065ed,a0
+	mov	a0,usp
+
+	mov	0xfd00e0ed,e0
+	mov	0xfd00e1ed,e1
+	mov	0xfd00e2ed,e2
+	mov	0xfd00e3ed,e3
+	mov	0xfd00e4ed,e4
+	mov	0xfd00e5ed,e5
+	mov	0xfd00e6ed,e6
+	mov	0xfd00e7ed,e7
+
+	mov	0xfd00d0ed,d0
+	mov	0xfd00d1ed,d1
+	mov	0xfd00d2ed,d2
+	mov	0xfd00d3ed,d3
+	mov	0xfd00a0ed,a0
+	mov	0xfd00a1ed,a1
+	mov	0xfd00a2ed,a2
+
+	# we may be holding current in E2
+#ifdef CONFIG_MN10300_CURRENT_IN_E2
+	mov	init_task,e2
+#endif
+
+	# initialise the processor and the unit
+	call	processor_init[],0
+	call	unit_init[],0
+
+#ifdef CONFIG_GDBSTUB
+	call	gdbstub_init[],0
+
+#ifdef CONFIG_GDBSTUB_IMMEDIATE
+	.globl	__gdbstub_pause
+__gdbstub_pause:
+	bra	__gdbstub_pause
+#endif
+#endif
+
+	jmp	start_kernel
+	.size	_start, _start-.
+ENTRY(__head_end)
+
+/*
+ * This is initialized to disallow all access to the low 2G region
+ * - the high 2G region is managed directly by the MMU
+ * - range 0x70000000-0x7C000000 are initialised for use by VMALLOC
+ */
+	.section .bss
+	.balign PAGE_SIZE
+ENTRY(swapper_pg_dir)
+        .space PTRS_PER_PGD*4
+
+/*
+ * The page tables are initialized to only 8MB here - the final page
+ * tables are set up later depending on memory size.
+ */
+
+	.balign PAGE_SIZE
+ENTRY(empty_zero_page)
+	.space PAGE_SIZE
+
+	.balign PAGE_SIZE
+ENTRY(empty_bad_page)
+	.space PAGE_SIZE
+
+	.balign PAGE_SIZE
+ENTRY(empty_bad_pte_table)
+	.space PAGE_SIZE
+
+	.balign PAGE_SIZE
+ENTRY(large_page_table)
+	.space PAGE_SIZE
+
+	.balign PAGE_SIZE
+ENTRY(kernel_vmalloc_ptes)
+	.space ((VMALLOC_END-VMALLOC_START)/PAGE_SIZE)*4
diff -puN /dev/null arch/mn10300/kernel/init_task.c
--- /dev/null
+++ a/arch/mn10300/kernel/init_task.c
@@ -0,0 +1,47 @@
+/* MN10300 Initial task definitions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/init_task.h>
+#include <linux/fs.h>
+#include <linux/mqueue.h>
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+
+static struct fs_struct init_fs = INIT_FS;
+static struct files_struct init_files = INIT_FILES;
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+struct mm_struct init_mm = INIT_MM(init_mm);
+
+EXPORT_SYMBOL(init_mm);
+
+/*
+ * Initial thread structure.
+ *
+ * We need to make sure that this is THREAD_SIZE aligned due to the
+ * way process stacks are handled. This is done by having a special
+ * "init_task" linker map entry..
+ */
+union thread_union init_thread_union
+	__attribute__((__section__(".data.init_task"))) =
+		{ INIT_THREAD_INFO(init_task) };
+
+/*
+ * Initial task structure.
+ *
+ * All other task structs will be allocated on slabs in fork.c
+ */
+struct task_struct init_task = INIT_TASK(init_task);
+
+EXPORT_SYMBOL(init_task);
diff -puN /dev/null arch/mn10300/kernel/io.c
--- /dev/null
+++ a/arch/mn10300/kernel/io.c
@@ -0,0 +1,31 @@
+/* MN10300 Misaligned multibyte-word I/O
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <asm/io.h>
+
+/*
+ * output data from a potentially misaligned buffer
+ */
+void __outsl(unsigned long addr, const void *buffer, int count)
+{
+	const unsigned char *buf = buffer;
+	unsigned long val;
+
+	while (count--) {
+		memcpy(&val, buf, 4);
+		outl(val, addr);
+		buf += 4;
+	}
+}
+
+EXPORT_SYMBOL(__outsl);
diff -puN /dev/null arch/mn10300/kernel/irq.c
--- /dev/null
+++ a/arch/mn10300/kernel/irq.c
@@ -0,0 +1,232 @@
+/* MN10300 Arch-specific interrupt handling
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+#include <linux/seq_file.h>
+#include <asm/setup.h>
+
+unsigned long __mn10300_irq_enabled_epsw = EPSW_IE | EPSW_IM_7;
+EXPORT_SYMBOL(__mn10300_irq_enabled_epsw);
+
+atomic_t irq_err_count;
+
+/*
+ * MN10300 INTC controller operations
+ */
+static void mn10300_cpupic_disable(unsigned int irq)
+{
+	u16 tmp = GxICR(irq);
+	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_DETECT;
+	tmp = GxICR(irq);
+}
+
+static void mn10300_cpupic_enable(unsigned int irq)
+{
+	u16 tmp = GxICR(irq);
+	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE;
+	tmp = GxICR(irq);
+}
+
+static void mn10300_cpupic_ack(unsigned int irq)
+{
+	u16 tmp;
+	*(volatile u8 *) &GxICR(irq) = GxICR_DETECT;
+	tmp = GxICR(irq);
+}
+
+static void mn10300_cpupic_mask(unsigned int irq)
+{
+	u16 tmp = GxICR(irq);
+	GxICR(irq) = (tmp & GxICR_LEVEL);
+	tmp = GxICR(irq);
+}
+
+static void mn10300_cpupic_mask_ack(unsigned int irq)
+{
+	u16 tmp = GxICR(irq);
+	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_DETECT;
+	tmp = GxICR(irq);
+}
+
+static void mn10300_cpupic_unmask(unsigned int irq)
+{
+	u16 tmp = GxICR(irq);
+	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
+	tmp = GxICR(irq);
+}
+
+static void mn10300_cpupic_end(unsigned int irq)
+{
+	u16 tmp = GxICR(irq);
+	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE;
+	tmp = GxICR(irq);
+}
+
+static struct irq_chip mn10300_cpu_pic = {
+	.name		= "cpu",
+	.disable	= mn10300_cpupic_disable,
+	.enable		= mn10300_cpupic_enable,
+	.ack		= mn10300_cpupic_ack,
+	.mask		= mn10300_cpupic_mask,
+	.mask_ack	= mn10300_cpupic_mask_ack,
+	.unmask		= mn10300_cpupic_unmask,
+	.end		= mn10300_cpupic_end,
+};
+
+/*
+ * 'what should we do if we get a hw irq event on an illegal vector'.
+ * each architecture has to answer this themselves.
+ */
+void ack_bad_irq(int irq)
+{
+	printk("unexpected IRQ trap at vector %02x\n", irq);
+}
+
+/*
+ * change the level at which an IRQ executes
+ * - must not be called whilst interrupts are being processed!
+ */
+void set_intr_level(int irq, u16 level)
+{
+	u16 tmp;
+
+	if (in_interrupt())
+		BUG();
+
+	tmp = GxICR(irq);
+	GxICR(irq) = (tmp & GxICR_ENABLE) | level;
+	tmp = GxICR(irq);
+}
+
+/*
+ * mark an interrupt to be ACK'd after interrupt handlers have been run rather
+ * than before
+ * - see Documentation/mn10300/features.txt
+ */
+void set_intr_postackable(int irq)
+{
+	set_irq_handler(irq, handle_level_irq);
+}
+
+/*
+ * initialise the interrupt system
+ */
+void __init init_IRQ(void)
+{
+	int irq;
+
+	for (irq = 0; irq < NR_IRQS; irq++)
+		if (irq_desc[irq].chip == &no_irq_type)
+			set_irq_chip_and_handler(irq, &mn10300_cpu_pic,
+						 handle_edge_irq);
+	unit_init_IRQ();
+}
+
+/*
+ * handle normal device IRQs
+ */
+asmlinkage void do_IRQ(void)
+{
+	unsigned long sp, epsw, irq_disabled_epsw, old_irq_enabled_epsw;
+	int irq;
+
+	sp = current_stack_pointer();
+	if (sp - (sp & ~(THREAD_SIZE - 1)) < STACK_WARN)
+		BUG();
+
+	/* make sure local_irq_enable() doesn't muck up the interrupt priority
+	 * setting in EPSW */
+	old_irq_enabled_epsw = __mn10300_irq_enabled_epsw;
+	local_save_flags(epsw);
+	__mn10300_irq_enabled_epsw = EPSW_IE | (EPSW_IM & epsw);
+	irq_disabled_epsw = EPSW_IE | MN10300_CLI_LEVEL;
+
+	__IRQ_STAT(smp_processor_id(), __irq_count)++;
+
+	irq_enter();
+
+	for (;;) {
+		/* ask the interrupt controller for the next IRQ to process
+		 * - the result we get depends on EPSW.IM
+		 */
+		irq = IAGR & IAGR_GN;
+		if (!irq)
+			break;
+
+		local_irq_restore(irq_disabled_epsw);
+
+		generic_handle_irq(irq >> 2);
+
+		/* restore IRQ controls for IAGR access */
+		local_irq_restore(epsw);
+	}
+
+	__mn10300_irq_enabled_epsw = old_irq_enabled_epsw;
+
+	irq_exit();
+}
+
+/*
+ * Display interrupt management information through /proc/interrupts
+ */
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i = *(loff_t *) v, j, cpu;
+	struct irqaction * action;
+	unsigned long flags;
+
+	switch (i) {
+		/* display column title bar naming CPUs */
+	case 0:
+		seq_printf(p, "           ");
+		for (j = 0; j < NR_CPUS; j++)
+			if (cpu_online(j))
+				seq_printf(p, "CPU%d       ", j);
+		seq_putc(p, '\n');
+		break;
+
+		/* display information rows, one per active CPU */
+	case 1 ... NR_IRQS - 1:
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+
+		action = irq_desc[i].action;
+		if (action) {
+			seq_printf(p, "%3d: ",i);
+			for_each_present_cpu(cpu)
+				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+			seq_printf(p, " %14s.%u", irq_desc[i].chip->name,
+				   (GxICR(i) & GxICR_LEVEL) >> GxICR_LEVEL_SHIFT);
+			seq_printf(p, "  %s", action->name);
+
+			for (action = action->next; action; action = action->next)
+				seq_printf(p, ", %s", action->name);
+
+			seq_putc(p, '\n');
+		}
+
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		break;
+
+		/* polish off with NMI and error counters */
+	case NR_IRQS:
+		seq_printf(p, "NMI: ");
+		for (j = 0; j < NR_CPUS; j++)
+			if (cpu_online(j))
+				seq_printf(p, "%10u ", nmi_count(j));
+		seq_putc(p, '\n');
+
+		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
+		break;
+	}
+
+	return 0;
+}
diff -puN /dev/null arch/mn10300/kernel/kernel_execve.S
--- /dev/null
+++ a/arch/mn10300/kernel/kernel_execve.S
@@ -0,0 +1,37 @@
+/* MN10300 In-kernel program execution
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/linkage.h>
+#include <asm/unistd.h>
+
+###############################################################################
+#
+# Do a system call from kernel instead of calling sys_execve so we end up with
+# proper pt_regs.
+#
+# int kernel_execve(const char *filename, char *const argv[],
+#		    char *const envp[])
+#
+# On entry: D0/D1/8(SP): arguments to function
+# On return: D0: syscall return.
+#
+###############################################################################
+	.globl		kernel_execve
+	.type		kernel_execve,@function
+kernel_execve:
+	mov		a3,a1
+	mov		d0,a0
+	mov		(12,sp),a3
+	mov		+__NR_execve,d0
+	syscall		0
+	mov		a1,a3
+	rets
+
+	.size		kernel_execve,.-kernel_execve
diff -puN /dev/null arch/mn10300/kernel/kprobes.c
--- /dev/null
+++ a/arch/mn10300/kernel/kprobes.c
@@ -0,0 +1,654 @@
+/* MN10300 Kernel probes implementation
+ *
+ * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
+ * Written by Mark Salter (msalter@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public Licence as published by
+ * the Free Software Foundation; either version 2 of the Licence, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public Licence for more details.
+ *
+ * You should have received a copy of the GNU General Public Licence
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+#include <linux/spinlock.h>
+#include <linux/preempt.h>
+#include <linux/kdebug.h>
+#include <asm/cacheflush.h>
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
+/* kprobe_status settings */
+#define KPROBE_HIT_ACTIVE	0x00000001
+#define KPROBE_HIT_SS		0x00000002
+
+static struct kprobe *current_kprobe;
+static unsigned long current_kprobe_orig_pc;
+static unsigned long current_kprobe_next_pc;
+static int current_kprobe_ss_flags;
+static unsigned long kprobe_status;
+static kprobe_opcode_t current_kprobe_ss_buf[MAX_INSN_SIZE + 2];
+static unsigned long current_kprobe_bp_addr;
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+
+
+/* singlestep flag bits */
+#define SINGLESTEP_BRANCH 1
+#define SINGLESTEP_PCREL  2
+
+#define READ_BYTE(p, valp) \
+	do { *(u8 *)(valp) = *(u8 *)(p); } while(0)
+
+#define READ_WORD16(p, valp)					\
+	do {							\
+		READ_BYTE((p), (valp));				\
+		READ_BYTE((u8 *)(p) + 1, (u8 *)(valp) + 1);	\
+	} while(0)
+
+#define READ_WORD32(p, valp)					\
+	do {							\
+		READ_BYTE((p), (valp));				\
+		READ_BYTE((u8 *)(p) + 1, (u8 *)(valp) + 1);	\
+		READ_BYTE((u8 *)(p) + 2, (u8 *)(valp) + 2);	\
+		READ_BYTE((u8 *)(p) + 3, (u8 *)(valp) + 3);	\
+	} while(0)
+
+
+static const u8 mn10300_insn_sizes[256] =
+{
+	// 1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
+	1, 3, 3, 3, 1, 3, 3, 3, 1, 3, 3, 3, 1, 3, 3, 3,	// 0
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 1
+	2, 2, 2, 2, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 3, 3, // 2
+	3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, // 3
+	1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2, // 4
+	1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, // 5
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 6
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 7
+	2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, // 8
+	2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, // 9
+	2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, // a
+	2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, // b
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 2, // c
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // d
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // e
+	0, 2, 2, 2, 2, 2, 2, 4, 0, 3, 0, 4, 0, 6, 7, 1  // f
+};
+
+#define LT (1 << 0)
+#define GT (1 << 1)
+#define GE (1 << 2)
+#define LE (1 << 3)
+#define CS (1 << 4)
+#define HI (1 << 5)
+#define CC (1 << 6)
+#define LS (1 << 7)
+#define EQ (1 << 8)
+#define NE (1 << 9)
+#define RA (1 << 10)
+#define VC (1 << 11)
+#define VS (1 << 12)
+#define NC (1 << 13)
+#define NS (1 << 14)
+
+static const u16 cond_table[] = {
+	/*  V  C  N  Z  */
+	/*  0  0  0  0  */ (NE | NC | CC | VC | GE | GT | HI),
+	/*  0  0  0  1  */ (EQ | NC | CC | VC | GE | LE | LS),
+	/*  0  0  1  0  */ (NE | NS | CC | VC | LT | LE | HI),
+	/*  0  0  1  1  */ (EQ | NS | CC | VC | LT | LE | LS),
+	/*  0  1  0  0  */ (NE | NC | CS | VC | GE | GT | LS),
+	/*  0  1  0  1  */ (EQ | NC | CS | VC | GE | LE | LS),
+	/*  0  1  1  0  */ (NE | NS | CS | VC | LT | LE | LS),
+	/*  0  1  1  1  */ (EQ | NS | CS | VC | LT | LE | LS),
+	/*  1  0  0  0  */ (NE | NC | CC | VS | LT | LE | HI),
+	/*  1  0  0  1  */ (EQ | NC | CC | VS | LT | LE | LS),
+	/*  1  0  1  0  */ (NE | NS | CC | VS | GE | GT | HI),
+	/*  1  0  1  1  */ (EQ | NS | CC | VS | GE | LE | LS),
+	/*  1  1  0  0  */ (NE | NC | CS | VS | LT | LE | LS),
+	/*  1  1  0  1  */ (EQ | NC | CS | VS | LT | LE | LS),
+	/*  1  1  1  0  */ (NE | NS | CS | VS | GE | GT | LS),
+	/*  1  1  1  1  */ (EQ | NS | CS | VS | GE | LE | LS),
+};
+
+/*
+ * Calculate what the PC will be after executing next instruction
+ */
+static unsigned find_nextpc(struct pt_regs *regs, int *flags)
+{
+	unsigned size;
+	s8  x8;
+	s16 x16;
+	s32 x32;
+	u8 opc, *pc, *sp, *next;
+
+	next = 0;
+	*flags = SINGLESTEP_PCREL;
+
+	pc = (u8 *) regs->pc;
+	sp = (u8 *) (regs + 1);
+	opc = *pc;
+
+	size = mn10300_insn_sizes[opc];
+	if (size > 0) {
+		next = pc + size;
+	} else {
+	    	switch (opc) {
+			/* Bxx (d8,PC) */
+		case 0xc0 ... 0xca:
+			x8 = 2;
+			if (cond_table[regs->epsw & 0xf] & (1 << (opc & 0xf)))
+				x8 = (s8)pc[1];
+			next = pc + x8;
+			*flags |= SINGLESTEP_BRANCH;
+			break;
+
+			/* JMP (d16,PC) or CALL (d16,PC) */
+		case 0xcc:
+		case 0xcd:
+			READ_WORD16(pc + 1, &x16);
+			next = pc + x16;
+			*flags |= SINGLESTEP_BRANCH;
+			break;
+
+			/* JMP (d32,PC) or CALL (d32,PC) */
+		case 0xdc:
+		case 0xdd:
+			READ_WORD32(pc + 1, &x32);
+			next = pc + x32;
+			*flags |= SINGLESTEP_BRANCH;
+			break;
+
+			/* RETF */
+		case 0xde:
+			next = (u8 *)regs->mdr;
+			*flags &= ~SINGLESTEP_PCREL;
+			*flags |= SINGLESTEP_BRANCH;
+			break;
+
+			/* RET */
+		case 0xdf:
+			sp += pc[2];
+			READ_WORD32(sp, &x32);
+			next = (u8 *)x32;
+			*flags &= ~SINGLESTEP_PCREL;
+			*flags |= SINGLESTEP_BRANCH;
+			break;
+
+		case 0xf0:
+			next = pc + 2;
+			opc = pc[1];
+			if (opc >= 0xf0 && opc <= 0xf7) {
+				/* JMP (An) / CALLS (An) */
+				switch (opc & 3) {
+				case 0:
+					next = (u8 *)regs->a0;
+					break;
+				case 1:
+					next = (u8 *)regs->a1;
+					break;
+				case 2:
+					next = (u8 *)regs->a2;
+					break;
+				case 3:
+					next = (u8 *)regs->a3;
+					break;
+				}
+				*flags &= ~SINGLESTEP_PCREL;
+				*flags |= SINGLESTEP_BRANCH;
+			} else if (opc == 0xfc) {
+				/* RETS */
+				READ_WORD32(sp, &x32);
+				next = (u8 *)x32;
+				*flags &= ~SINGLESTEP_PCREL;
+				*flags |= SINGLESTEP_BRANCH;
+			} else if (opc == 0xfd) {
+				/* RTI */
+				READ_WORD32(sp + 4, &x32);
+				next = (u8 *)x32;
+				*flags &= ~SINGLESTEP_PCREL;
+				*flags |= SINGLESTEP_BRANCH;
+			}
+			break;
+
+			/* potential 3-byte conditional branches */
+		case 0xf8:
+			next = pc + 3;
+			opc = pc[1];
+			if (opc >= 0xe8 && opc <= 0xeb &&
+			    (cond_table[regs->epsw & 0xf] &
+			     (1 << ((opc & 0xf) + 3)))
+			    ) {
+				READ_BYTE(pc+2, &x8);
+				next = pc + x8;
+				*flags |= SINGLESTEP_BRANCH;
+			}
+			break;
+
+		case 0xfa:
+			if (pc[1] == 0xff) {
+				/* CALLS (d16,PC) */
+				READ_WORD16(pc + 2, &x16);
+				next = pc + x16;
+			} else
+				next = pc + 4;
+			*flags |= SINGLESTEP_BRANCH;
+			break;
+
+		case 0xfc:
+			x32 = 6;
+			if (pc[1] == 0xff) {
+				/* CALLS (d32,PC) */
+				READ_WORD32(pc + 2, &x32);
+			}
+			next = pc + x32;
+			*flags |= SINGLESTEP_BRANCH;
+			break;
+			/* LXX (d8,PC) */
+			/* SETLB - loads the next four bytes into the LIR reg */
+		case 0xd0 ... 0xda:
+		case 0xdb:
+			panic("Can't singlestep Lxx/SETLB\n");
+			break;
+		}
+	}
+	return (unsigned)next;
+
+}
+
+/*
+ * set up out of place singlestep of some branching instructions
+ */
+static unsigned __kprobes singlestep_branch_setup(struct pt_regs *regs)
+{
+	u8 opc, *pc, *sp, *next;
+
+	next = NULL;
+	pc = (u8 *) regs->pc;
+	sp = (u8 *) (regs + 1);
+
+    	switch (pc[0]) {
+	case 0xc0 ... 0xca:	/* Bxx (d8,PC) */
+	case 0xcc:		/* JMP (d16,PC) */
+	case 0xdc:		/* JMP (d32,PC) */
+	case 0xf8:              /* Bxx (d8,PC)  3-byte version */
+		/* don't really need to do anything except cause trap  */
+		next = pc;
+		break;
+
+	case 0xcd:		/* CALL (d16,PC) */
+		pc[1] = 5;
+		pc[2] = 0;
+		next = pc + 5;
+		break;
+
+	case 0xdd:		/* CALL (d32,PC) */
+		pc[1] = 7;
+		pc[2] = 0;
+		pc[3] = 0;
+		pc[4] = 0;
+		next = pc + 7;
+		break;
+
+	case 0xde:		/* RETF */
+		next = pc + 3;
+		regs->mdr = (unsigned) next;
+		break;
+
+	case 0xdf:		/* RET */
+		sp += pc[2];
+		next = pc + 3;
+		*(unsigned *)sp = (unsigned) next;
+		break;
+
+	case 0xf0:
+		next = pc + 2;
+		opc = pc[1];
+		if (opc >= 0xf0 && opc <= 0xf3) {
+			/* CALLS (An) */
+		        /* use CALLS (d16,PC) to avoid mucking with An */
+			pc[0] = 0xfa;
+			pc[1] = 0xff;
+			pc[2] = 4;
+			pc[3] = 0;
+			next = pc + 4;
+		} else if (opc >= 0xf4 && opc <= 0xf7) {
+			/* JMP (An) */
+			next = pc;
+		} else if (opc == 0xfc) {
+			/* RETS */
+			next = pc + 2;
+			*(unsigned *) sp = (unsigned) next;
+		} else if (opc == 0xfd) {
+			/* RTI */
+			next = pc + 2;
+			*(unsigned *)(sp + 4) = (unsigned) next;
+		}
+		break;
+
+	case 0xfa:	/* CALLS (d16,PC) */
+		pc[2] = 4;
+		pc[3] = 0;
+		next = pc + 4;
+		break;
+
+	case 0xfc:	/* CALLS (d32,PC) */
+		pc[2] = 6;
+		pc[3] = 0;
+		pc[4] = 0;
+		pc[5] = 0;
+		next = pc + 6;
+		break;
+
+	case 0xd0 ... 0xda:	/* LXX (d8,PC) */
+	case 0xdb:		/* SETLB */
+		panic("Can't singlestep Lxx/SETLB\n");
+	}
+
+	return (unsigned) next;
+}
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	return 0;
+}
+
+void __kprobes arch_copy_kprobe(struct kprobe *p)
+{
+	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	*p->addr = BREAKPOINT_INSTRUCTION;
+	flush_icache_range((unsigned long) p->addr,
+			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	mn10300_dcache_flush();
+	mn10300_icache_inv();
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+}
+
+static inline
+void __kprobes disarm_kprobe(struct kprobe *p, struct pt_regs *regs)
+{
+	*p->addr = p->opcode;
+	regs->pc = (unsigned long) p->addr;
+	mn10300_dcache_flush();
+	mn10300_icache_inv();
+}
+
+static inline
+void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
+{
+	unsigned long nextpc;
+
+	current_kprobe_orig_pc = regs->pc;
+	memcpy(current_kprobe_ss_buf, &p->ainsn.insn[0], MAX_INSN_SIZE);
+	regs->pc = (unsigned long) current_kprobe_ss_buf;
+
+	nextpc = find_nextpc(regs, &current_kprobe_ss_flags);
+	if (current_kprobe_ss_flags & SINGLESTEP_PCREL)
+		current_kprobe_next_pc =
+			current_kprobe_orig_pc + (nextpc - regs->pc);
+	else
+		current_kprobe_next_pc = nextpc;
+
+	/* branching instructions need special handling */
+	if (current_kprobe_ss_flags & SINGLESTEP_BRANCH)
+		nextpc = singlestep_branch_setup(regs);
+
+	current_kprobe_bp_addr = nextpc;
+
+	*(u8 *) nextpc = BREAKPOINT_INSTRUCTION;
+	mn10300_dcache_flush_range2((unsigned) current_kprobe_ss_buf,
+				    sizeof(current_kprobe_ss_buf));
+	mn10300_icache_inv();
+}
+
+static inline int __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p;
+	int ret = 0;
+	unsigned int *addr = (unsigned int *) regs->pc;
+
+	/* We're in an interrupt, but this is clear and BUG()-safe. */
+	preempt_disable();
+
+	/* Check we're not actually recursing */
+	if (kprobe_running()) {
+		/* We *are* holding lock here, so this is safe.
+		   Disarm the probe we just hit, and ignore it. */
+		p = get_kprobe(addr);
+		if (p) {
+			disarm_kprobe(p, regs);
+			ret = 1;
+		} else {
+			p = current_kprobe;
+			if (p->break_handler && p->break_handler(p, regs))
+				goto ss_probe;
+		}
+		/* If it's not ours, can't be delete race, (we hold lock). */
+		goto no_kprobe;
+	}
+
+	p = get_kprobe(addr);
+	if (!p) {
+		if (*addr != BREAKPOINT_INSTRUCTION) {
+			/* The breakpoint instruction was removed right after
+			 * we hit it.  Another cpu has removed either a
+			 * probepoint or a debugger breakpoint at this address.
+			 * In either case, no further handling of this
+			 * interrupt is appropriate.
+			 */
+			ret = 1;
+		}
+		/* Not one of ours: let kernel handle it */
+		goto no_kprobe;
+	}
+
+	kprobe_status = KPROBE_HIT_ACTIVE;
+	current_kprobe = p;
+	if (p->pre_handler(p, regs)) {
+		/* handler has already set things up, so skip ss setup */
+		return 1;
+	}
+
+ss_probe:
+	prepare_singlestep(p, regs);
+	kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+}
+
+/*
+ * Called after single-stepping.  p->addr is the address of the
+ * instruction whose first byte has been replaced by the "breakpoint"
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is p->ainsn.insn.
+ */
+static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
+{
+	/* we may need to fixup regs/stack after singlestepping a call insn */
+	if (current_kprobe_ss_flags & SINGLESTEP_BRANCH) {
+		regs->pc = current_kprobe_orig_pc;
+		switch (p->ainsn.insn[0]) {
+		case 0xcd:	/* CALL (d16,PC) */
+			*(unsigned *) regs->sp = regs->mdr = regs->pc + 5;
+			break;
+		case 0xdd:	/* CALL (d32,PC) */
+			/* fixup mdr and return address on stack */
+			*(unsigned *) regs->sp = regs->mdr = regs->pc + 7;
+			break;
+		case 0xf0:
+			if (p->ainsn.insn[1] >= 0xf0 &&
+			    p->ainsn.insn[1] <= 0xf3) {
+				/* CALLS (An) */
+				/* fixup MDR and return address on stack */
+				regs->mdr = regs->pc + 2;
+				*(unsigned *) regs->sp = regs->mdr;
+			}
+			break;
+
+		case 0xfa:	/* CALLS (d16,PC) */
+			/* fixup MDR and return address on stack */
+			*(unsigned *) regs->sp = regs->mdr = regs->pc + 4;
+			break;
+
+		case 0xfc:	/* CALLS (d32,PC) */
+			/* fixup MDR and return address on stack */
+			*(unsigned *) regs->sp = regs->mdr = regs->pc + 6;
+			break;
+		}
+	}
+
+	regs->pc = current_kprobe_next_pc;
+	current_kprobe_bp_addr = 0;
+}
+
+static inline int __kprobes post_kprobe_handler(struct pt_regs *regs)
+{
+	if (!kprobe_running())
+		return 0;
+
+	if (current_kprobe->post_handler)
+		current_kprobe->post_handler(current_kprobe, regs, 0);
+
+	resume_execution(current_kprobe, regs);
+	reset_current_kprobe();
+	preempt_enable_no_resched();
+	return 1;
+}
+
+/* Interrupts disabled, kprobe_lock held. */
+static inline
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	if (current_kprobe->fault_handler &&
+	    current_kprobe->fault_handler(current_kprobe, regs, trapnr))
+		return 1;
+
+	if (kprobe_status & KPROBE_HIT_SS) {
+		resume_execution(current_kprobe, regs);
+		reset_current_kprobe();
+		preempt_enable_no_resched();
+	}
+	return 0;
+}
+
+/*
+ * Wrapper routine to for handling exceptions.
+ */
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = data;
+
+	switch (val) {
+	case DIE_BREAKPOINT:
+		if (current_kprobe_bp_addr != args->regs->pc) {
+			if (kprobe_handler(args->regs))
+				return NOTIFY_STOP;
+		} else {
+			if (post_kprobe_handler(args->regs))
+				return NOTIFY_STOP;
+		}
+		break;
+	case DIE_GPF:
+		if (kprobe_running() &&
+		    kprobe_fault_handler(args->regs, args->trapnr))
+			return NOTIFY_STOP;
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+/* Jprobes support.  */
+static struct pt_regs jprobe_saved_regs;
+static struct pt_regs *jprobe_saved_regs_location;
+static kprobe_opcode_t jprobe_saved_stack[MAX_STACK_SIZE];
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+
+	jprobe_saved_regs_location = regs;
+	memcpy(&jprobe_saved_regs, regs, sizeof(struct pt_regs));
+
+	/* Save a whole stack frame, this gets arguments
+	 * pushed onto the stack after using up all the
+	 * arg registers.
+	 */
+	memcpy(&jprobe_saved_stack, regs + 1, sizeof(jprobe_saved_stack));
+
+	/* setup return addr to the jprobe handler routine */
+	regs->pc = (unsigned long) jp->entry;
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	void *orig_sp = jprobe_saved_regs_location + 1;
+
+	preempt_enable_no_resched();
+	__asm__ __volatile__(
+		"mov %0,sp\n"
+		".globl	jprobe_return_bp_addr\n"
+		"jprobe_return_bp_addr:\n\t"
+		".byte 0xff\n"
+	        : : "d" (orig_sp) );
+}
+
+extern void jprobe_return_bp_addr(void);
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	u8 *addr = (u8 *) regs->pc;
+
+	if (addr == (u8 *) jprobe_return_bp_addr) {
+		if (jprobe_saved_regs_location != regs) {
+			printk(KERN_ERR"JPROBE:"
+			       " Current regs (%p) does not match saved regs"
+			       " (%p).\n",
+			       regs, jprobe_saved_regs_location);
+			BUG();
+		}
+
+		/* Restore old register state.
+		 */
+		memcpy(regs, &jprobe_saved_regs, sizeof(struct pt_regs));
+
+		memcpy(regs + 1, &jprobe_saved_stack,
+		       sizeof(jprobe_saved_stack));
+		return 1;
+	}
+	return 0;
+}
+
+int __init arch_init_kprobes(void)
+{
+	return 0;
+}
diff -puN /dev/null arch/mn10300/kernel/kthread.S
--- /dev/null
+++ a/arch/mn10300/kernel/kthread.S
@@ -0,0 +1,31 @@
+/* MN10300 Kernel thread trampoline function
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by Mark Salter (msalter@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+	.text
+
+###############################################################################
+#
+# kernel_thread_helper - trampoline for kernel_thread()
+#
+# On entry:
+#   A2 = address of function to call
+#   D2 = function argument
+#
+###############################################################################
+	.globl	kernel_thread_helper
+	.type	kernel_thread_helper,@function
+kernel_thread_helper:
+	mov	do_exit,d1
+	mov	d1,(sp)
+	mov	d1,mdr
+	mov	d2,d0
+	jmp	(a2)
+
+	.size	kernel_thread_helper,.-kernel_thread_helper
diff -puN /dev/null arch/mn10300/kernel/Makefile
--- /dev/null
+++ a/arch/mn10300/kernel/Makefile
@@ -0,0 +1,27 @@
+#
+# Makefile for the MN10300-specific core kernel code
+#
+extra-y := head.o init_task.o vmlinux.lds
+
+obj-y   := process.o semaphore.o signal.o entry.o fpu.o traps.o irq.o \
+	   ptrace.o setup.o time.o sys_mn10300.o io.o kthread.o \
+	   switch_to.o mn10300_ksyms.o kernel_execve.o
+
+obj-$(CONFIG_MN10300_WD_TIMER) += mn10300-watchdog.o mn10300-watchdog-low.o
+
+obj-$(CONFIG_FPU) += fpu-low.o
+
+obj-$(CONFIG_MN10300_TTYSM) += mn10300-serial.o mn10300-serial-low.o \
+			       mn10300-debug.o
+obj-$(CONFIG_GDBSTUB) += gdb-stub.o gdb-low.o
+obj-$(CONFIG_GDBSTUB_ON_TTYSx) += gdb-io-serial.o gdb-io-serial-low.o
+obj-$(CONFIG_GDBSTUB_ON_TTYSMx) += gdb-io-ttysm.o gdb-io-ttysm-low.o
+
+ifneq ($(CONFIG_MN10300_CACHE_DISABLED),y)
+obj-$(CONFIG_GDBSTUB) += gdb-cache.o
+endif
+
+obj-$(CONFIG_MN10300_RTC) += rtc.o
+obj-$(CONFIG_PROFILE) += profile.o profile-low.o
+obj-$(CONFIG_MODULES) += module.o
+obj-$(CONFIG_KPROBES) += kprobes.o
diff -puN /dev/null arch/mn10300/kernel/mn10300-debug.c
--- /dev/null
+++ a/arch/mn10300/kernel/mn10300-debug.c
@@ -0,0 +1,58 @@
+/* Debugging stuff for the MN10300-based processors
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/sched.h>
+#include <asm/serial-regs.h>
+
+#undef MN10300_CONSOLE_ON_SERIO
+
+/*
+ * write a string directly through one of the serial ports on-board the MN10300
+ */
+#ifdef MN10300_CONSOLE_ON_SERIO
+void debug_to_serial_mnser(const char *p, int n)
+{
+	char ch;
+
+	for (; n > 0; n--) {
+		ch = *p++;
+
+#if MN10300_CONSOLE_ON_SERIO == 0
+		while (SC0STR & (SC01STR_TBF)) continue;
+		SC0TXB = ch;
+		while (SC0STR & (SC01STR_TBF)) continue;
+		if (ch == 0x0a) {
+			SC0TXB = 0x0d;
+			while (SC0STR & (SC01STR_TBF)) continue;
+		}
+
+#elif MN10300_CONSOLE_ON_SERIO == 1
+		while (SC1STR & (SC01STR_TBF)) continue;
+		SC1TXB = ch;
+		while (SC1STR & (SC01STR_TBF)) continue;
+		if (ch == 0x0a) {
+			SC1TXB = 0x0d;
+			while (SC1STR & (SC01STR_TBF)) continue;
+		}
+
+#elif MN10300_CONSOLE_ON_SERIO == 2
+		while (SC2STR & (SC2STR_TBF)) continue;
+		SC2TXB = ch;
+		while (SC2STR & (SC2STR_TBF)) continue;
+		if (ch == 0x0a) {
+			SC2TXB = 0x0d;
+			while (SC2STR & (SC2STR_TBF)) continue;
+		}
+
+#endif
+	}
+}
+#endif
+
diff -puN /dev/null arch/mn10300/kernel/mn10300_ksyms.c
--- /dev/null
+++ a/arch/mn10300/kernel/mn10300_ksyms.c
@@ -0,0 +1,37 @@
+/* MN10300 Miscellaneous and library kernel exports
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <asm/uaccess.h>
+
+
+EXPORT_SYMBOL(change_bit);
+EXPORT_SYMBOL(test_and_change_bit);
+
+EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(memmove);
+EXPORT_SYMBOL(memset);
+
+EXPORT_SYMBOL(strncpy_from_user);
+EXPORT_SYMBOL(__strncpy_from_user);
+EXPORT_SYMBOL(clear_user);
+EXPORT_SYMBOL(__clear_user);
+EXPORT_SYMBOL(__generic_copy_from_user);
+EXPORT_SYMBOL(__generic_copy_to_user);
+EXPORT_SYMBOL(strnlen_user);
+
+extern u64 __ashrdi3(u64, unsigned);
+extern u64 __ashldi3(u64, unsigned);
+extern u64 __lshrdi3(u64, unsigned);
+extern s64 __negdi2(s64);
+EXPORT_SYMBOL(__ashrdi3);
+EXPORT_SYMBOL(__ashldi3);
+EXPORT_SYMBOL(__lshrdi3);
+EXPORT_SYMBOL(__negdi2);
diff -puN /dev/null arch/mn10300/kernel/mn10300-serial.c
--- /dev/null
+++ a/arch/mn10300/kernel/mn10300-serial.c
@@ -0,0 +1,1467 @@
+/* MN10300 On-chip serial port UART driver
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+static const char serial_name[] = "MN10300 Serial driver";
+static const char serial_version[] = "mn10300_serial-1.0";
+static const char serial_revdate[] = "2007-11-06";
+
+#if defined(CONFIG_MN10300_TTYSM_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/serial.h>
+#include <linux/circ_buf.h>
+#include <linux/errno.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/major.h>
+#include <linux/string.h>
+#include <linux/ioport.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/sysrq.h>
+
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/bitops.h>
+#include <asm/serial-regs.h>
+#include <asm/unit/timex.h>
+#include "mn10300-serial.h"
+
+static inline __attribute__((format(printf,1, 2)))
+void no_printk(const char *fmt, ...)
+{
+}
+
+#define kenter(FMT,...)	   printk("-->%s(" FMT ")\n", __func__ ,##__VA_ARGS__ )
+#define _enter(FMT,...) no_printk("-->%s(" FMT ")\n", __func__ ,##__VA_ARGS__ )
+#define kdebug(FMT,...)    printk("--- " FMT "\n" ,##__VA_ARGS__ )
+#define _debug(FMT,...) no_printk("--- " FMT "\n" ,##__VA_ARGS__ )
+#define kproto(FMT,...)    printk("### MNSERIAL " FMT " ###\n" ,##__VA_ARGS__ )
+#define _proto(FMT,...) no_printk("### MNSERIAL " FMT " ###\n" ,##__VA_ARGS__ )
+
+#define NR_UARTS 3
+
+#ifdef CONFIG_MN10300_TTYSM_CONSOLE
+static void mn10300_serial_console_write(struct console *co,
+					   const char *s, unsigned count);
+static int __init mn10300_serial_console_setup(struct console *co,
+						 char *options);
+
+static struct uart_driver mn10300_serial_driver;
+static struct console mn10300_serial_console = {
+	.name		= "ttySM",
+	.write		= mn10300_serial_console_write,
+	.device		= uart_console_device,
+	.setup		= mn10300_serial_console_setup,
+	.flags		= CON_PRINTBUFFER,
+	.index		= -1,
+	.data		= &mn10300_serial_driver,
+};
+#endif
+
+static struct uart_driver mn10300_serial_driver = {
+	.owner		= NULL,
+	.driver_name	= "mn10300-serial",
+	.dev_name	= "ttySM",
+	.major		= TTY_MAJOR,
+	.minor		= 128,
+	.nr		= NR_UARTS,
+#ifdef CONFIG_MN10300_TTYSM_CONSOLE
+	.cons		= &mn10300_serial_console,
+#endif
+};
+
+static unsigned int mn10300_serial_tx_empty(struct uart_port *);
+static void mn10300_serial_set_mctrl(struct uart_port *, unsigned int mctrl);
+static unsigned int mn10300_serial_get_mctrl(struct uart_port *);
+static void mn10300_serial_stop_tx(struct uart_port *);
+static void mn10300_serial_start_tx(struct uart_port *);
+static void mn10300_serial_send_xchar(struct uart_port *, char ch);
+static void mn10300_serial_stop_rx(struct uart_port *);
+static void mn10300_serial_enable_ms(struct uart_port *);
+static void mn10300_serial_break_ctl(struct uart_port *, int ctl);
+static int mn10300_serial_startup(struct uart_port *);
+static void mn10300_serial_shutdown(struct uart_port *);
+static void mn10300_serial_set_termios(struct uart_port *,
+					 struct ktermios *new,
+					 struct ktermios *old);
+static const char *mn10300_serial_type(struct uart_port *);
+static void mn10300_serial_release_port(struct uart_port *);
+static int mn10300_serial_request_port(struct uart_port *);
+static void mn10300_serial_config_port(struct uart_port *, int);
+static int mn10300_serial_verify_port(struct uart_port *,
+					struct serial_struct *);
+
+static const struct uart_ops mn10300_serial_ops = {
+	.tx_empty	= mn10300_serial_tx_empty,
+	.set_mctrl	= mn10300_serial_set_mctrl,
+	.get_mctrl	= mn10300_serial_get_mctrl,
+	.stop_tx	= mn10300_serial_stop_tx,
+	.start_tx	= mn10300_serial_start_tx,
+	.send_xchar	= mn10300_serial_send_xchar,
+	.stop_rx	= mn10300_serial_stop_rx,
+	.enable_ms	= mn10300_serial_enable_ms,
+	.break_ctl	= mn10300_serial_break_ctl,
+	.startup	= mn10300_serial_startup,
+	.shutdown	= mn10300_serial_shutdown,
+	.set_termios	= mn10300_serial_set_termios,
+	.type		= mn10300_serial_type,
+	.release_port	= mn10300_serial_release_port,
+	.request_port	= mn10300_serial_request_port,
+	.config_port	= mn10300_serial_config_port,
+	.verify_port	= mn10300_serial_verify_port,
+};
+
+static irqreturn_t mn10300_serial_interrupt(int irq, void *dev_id);
+
+/*
+ * the first on-chip serial port: ttySM0 (aka SIF0)
+ */
+#ifdef CONFIG_MN10300_TTYSM0
+struct mn10300_serial_port mn10300_serial_port_sif0 = {
+	.uart.ops	= &mn10300_serial_ops,
+	.uart.membase	= (void __iomem *) &SC0CTR,
+	.uart.mapbase	= (unsigned long) &SC0CTR,
+	.uart.iotype	= UPIO_MEM,
+	.uart.irq	= 0,
+	.uart.uartclk	= 0, //MN10300_IOCLK,
+	.uart.fifosize	= 1,
+	.uart.flags	= UPF_BOOT_AUTOCONF,
+	.uart.line	= 0,
+	.uart.type	= PORT_MN10300,
+	.uart.lock	= SPIN_LOCK_UNLOCKED,
+	.name		= "ttySM0",
+	._iobase	= &SC0CTR,
+	._control	= &SC0CTR,
+	._status	= (volatile u8 *) &SC0STR,
+	._intr		= &SC0ICR,
+	._rxb		= &SC0RXB,
+	._txb		= &SC0TXB,
+	.rx_name	= "ttySM0/Rx",
+	.tx_name	= "ttySM0/Tx",
+#ifdef CONFIG_MN10300_TTYSM0_TIMER8
+	.tm_name	= "ttySM0/Timer8",
+	._tmxmd		= &TM8MD,
+	._tmxbr		= &TM8BR,
+	._tmicr		= &TM8ICR,
+	.tm_irq		= TM8IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_16BIT,
+#else /* CONFIG_MN10300_TTYSM0_TIMER2 */
+	.tm_name	= "ttySM0/Timer2",
+	._tmxmd		= &TM2MD,
+	._tmxbr		= (volatile u16 *) &TM2BR,
+	._tmicr		= &TM2ICR,
+	.tm_irq		= TM2IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_8BIT,
+#endif
+	.rx_irq		= SC0RXIRQ,
+	.tx_irq		= SC0TXIRQ,
+	.rx_icr		= &GxICR(SC0RXIRQ),
+	.tx_icr		= &GxICR(SC0TXIRQ),
+	.clock_src	= MNSCx_CLOCK_SRC_IOCLK,
+	.options	= 0,
+#ifdef CONFIG_GDBSTUB_ON_TTYSM0
+	.gdbstub	= 1,
+#endif
+};
+#endif /* CONFIG_MN10300_TTYSM0 */
+
+/*
+ * the second on-chip serial port: ttySM1 (aka SIF1)
+ */
+#ifdef CONFIG_MN10300_TTYSM1
+struct mn10300_serial_port mn10300_serial_port_sif1 = {
+	.uart.ops	= &mn10300_serial_ops,
+	.uart.membase	= (void __iomem *) &SC1CTR,
+	.uart.mapbase	= (unsigned long) &SC1CTR,
+	.uart.iotype	= UPIO_MEM,
+	.uart.irq	= 0,
+	.uart.uartclk	= 0, //MN10300_IOCLK,
+	.uart.fifosize	= 1,
+	.uart.flags	= UPF_BOOT_AUTOCONF,
+	.uart.line	= 1,
+	.uart.type	= PORT_MN10300,
+	.uart.lock	= SPIN_LOCK_UNLOCKED,
+	.name		= "ttySM1",
+	._iobase	= &SC1CTR,
+	._control	= &SC1CTR,
+	._status	= (volatile u8 *) &SC1STR,
+	._intr		= &SC1ICR,
+	._rxb		= &SC1RXB,
+	._txb		= &SC1TXB,
+	.rx_name	= "ttySM1/Rx",
+	.tx_name	= "ttySM1/Tx",
+#ifdef CONFIG_MN10300_TTYSM1_TIMER9
+	.tm_name	= "ttySM1/Timer9",
+	._tmxmd		= &TM9MD,
+	._tmxbr		= &TM9BR,
+	._tmicr		= &TM9ICR,
+	.tm_irq		= TM9IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_16BIT,
+#else /* CONFIG_MN10300_TTYSM1_TIMER3 */
+	.tm_name	= "ttySM1/Timer3",
+	._tmxmd		= &TM3MD,
+	._tmxbr		= (volatile u16 *) &TM3BR,
+	._tmicr		= &TM3ICR,
+	.tm_irq		= TM3IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_8BIT,
+#endif
+	.rx_irq		= SC1RXIRQ,
+	.tx_irq		= SC1TXIRQ,
+	.rx_icr		= &GxICR(SC1RXIRQ),
+	.tx_icr		= &GxICR(SC1TXIRQ),
+	.clock_src	= MNSCx_CLOCK_SRC_IOCLK,
+	.options	= 0,
+#ifdef CONFIG_GDBSTUB_ON_TTYSM1
+	.gdbstub	= 1,
+#endif
+};
+#endif /* CONFIG_MN10300_TTYSM1 */
+
+/*
+ * the third on-chip serial port: ttySM2 (aka SIF2)
+ */
+#ifdef CONFIG_MN10300_TTYSM2
+struct mn10300_serial_port mn10300_serial_port_sif2 = {
+	.uart.ops	= &mn10300_serial_ops,
+	.uart.membase	= (void __iomem *) &SC2CTR,
+	.uart.mapbase	= (unsigned long) &SC2CTR,
+	.uart.iotype	= UPIO_MEM,
+	.uart.irq	= 0,
+	.uart.uartclk	= 0, //MN10300_IOCLK,
+	.uart.fifosize	= 1,
+	.uart.flags	= UPF_BOOT_AUTOCONF,
+	.uart.line	= 2,
+#ifdef CONFIG_MN10300_TTYSM2_CTS
+	.uart.type	= PORT_MN10300_CTS,
+#else
+	.uart.type	= PORT_MN10300,
+#endif
+	.uart.lock	= SPIN_LOCK_UNLOCKED,
+	.name		= "ttySM2",
+	.rx_name	= "ttySM2/Rx",
+	.tx_name	= "ttySM2/Tx",
+	.tm_name	= "ttySM2/Timer10",
+	._iobase	= &SC2CTR,
+	._control	= &SC2CTR,
+	._status	= &SC2STR,
+	._intr		= &SC2ICR,
+	._rxb		= &SC2RXB,
+	._txb		= &SC2TXB,
+	._tmxmd		= &TM10MD,
+	._tmxbr		= &TM10BR,
+	._tmicr		= &TM10ICR,
+	.tm_irq		= TM10IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_16BIT,
+	.rx_irq		= SC2RXIRQ,
+	.tx_irq		= SC2TXIRQ,
+	.rx_icr		= &GxICR(SC2RXIRQ),
+	.tx_icr		= &GxICR(SC2TXIRQ),
+	.clock_src	= MNSCx_CLOCK_SRC_IOCLK,
+#ifdef CONFIG_MN10300_TTYSM2_CTS
+	.options	= MNSCx_OPT_CTS,
+#else
+	.options	= 0,
+#endif
+#ifdef CONFIG_GDBSTUB_ON_TTYSM2
+	.gdbstub	= 1,
+#endif
+};
+#endif /* CONFIG_MN10300_TTYSM2 */
+
+
+/*
+ * list of available serial ports
+ */
+struct mn10300_serial_port *mn10300_serial_ports[NR_UARTS + 1] = {
+#ifdef CONFIG_MN10300_TTYSM0
+	[0]	= &mn10300_serial_port_sif0,
+#endif
+#ifdef CONFIG_MN10300_TTYSM1
+	[1]	= &mn10300_serial_port_sif1,
+#endif
+#ifdef CONFIG_MN10300_TTYSM2
+	[2]	= &mn10300_serial_port_sif2,
+#endif
+	[NR_UARTS] = NULL,
+};
+
+
+/*
+ * we abuse the serial ports' baud timers' interrupt lines to get the ability
+ * to deliver interrupts to userspace as we use the ports' interrupt lines to
+ * do virtual DMA on account of the ports having no hardware FIFOs
+ *
+ * we can generate an interrupt manually in the assembly stubs by writing to
+ * the enable and detect bits in the interrupt control register, so all we need
+ * to do here is disable the interrupt line
+ *
+ * note that we can't just leave the line enabled as the baud rate timer *also*
+ * generates interrupts
+ */
+static void mn10300_serial_mask_ack(unsigned int irq)
+{
+	u16 tmp;
+	GxICR(irq) = GxICR_LEVEL_6;
+	tmp = GxICR(irq); /* flush write buffer */
+}
+
+static void mn10300_serial_nop(unsigned int irq)
+{
+}
+
+static struct irq_chip mn10300_serial_pic = {
+	.name		= "mnserial",
+	.ack		= mn10300_serial_mask_ack,
+	.mask		= mn10300_serial_mask_ack,
+	.mask_ack	= mn10300_serial_mask_ack,
+	.unmask		= mn10300_serial_nop,
+	.end		= mn10300_serial_nop,
+};
+
+
+/*
+ * serial virtual DMA interrupt jump table
+ */
+struct mn10300_serial_int mn10300_serial_int_tbl[NR_IRQS];
+
+static void mn10300_serial_dis_tx_intr(struct mn10300_serial_port *port)
+{
+	u16 x;
+	*port->tx_icr = GxICR_LEVEL_1 | GxICR_DETECT;
+	x = *port->tx_icr;
+}
+
+static void mn10300_serial_en_tx_intr(struct mn10300_serial_port *port)
+{
+	u16 x;
+	*port->tx_icr = GxICR_LEVEL_1 | GxICR_ENABLE;
+	x = *port->tx_icr;
+}
+
+static void mn10300_serial_dis_rx_intr(struct mn10300_serial_port *port)
+{
+	u16 x;
+	*port->rx_icr = GxICR_LEVEL_1 | GxICR_DETECT;
+	x = *port->rx_icr;
+}
+
+/*
+ * multi-bit equivalent of test_and_clear_bit()
+ */
+static int mask_test_and_clear(volatile u8 *ptr, u8 mask)
+{
+	u32 epsw;
+	asm volatile("	bclr	%1,(%2)		\n"
+		     "	mov	epsw,%0		\n"
+		     : "=d"(epsw) : "d"(mask), "a"(ptr));
+	return !(epsw & EPSW_FLAG_Z);
+}
+
+/*
+ * receive chars from the ring buffer for this serial port
+ * - must do break detection here (not done in the UART)
+ */
+static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
+{
+	struct uart_icount *icount = &port->uart.icount;
+	struct tty_struct *tty = port->uart.info->tty;
+	unsigned ix;
+	int count;
+	u8 st, ch, push, status, overrun;
+
+	_enter("%s", port->name);
+
+	push = 0;
+
+	count = CIRC_CNT(port->rx_inp, port->rx_outp, MNSC_BUFFER_SIZE);
+	count = tty_buffer_request_room(tty, count);
+	if (count == 0) {
+		if (!tty->low_latency)
+			tty_flip_buffer_push(tty);
+		return;
+	}
+
+try_again:
+	/* pull chars out of the hat */
+	ix = port->rx_outp;
+	if (ix == port->rx_inp) {
+		if (push && !tty->low_latency)
+			tty_flip_buffer_push(tty);
+		return;
+	}
+
+	ch = port->rx_buffer[ix++];
+	st = port->rx_buffer[ix++];
+	port->rx_outp = ix & (MNSC_BUFFER_SIZE - 1);
+	port->uart.icount.rx++;
+
+	st &= SC01STR_FEF | SC01STR_PEF | SC01STR_OEF;
+	status = 0;
+	overrun = 0;
+
+	/* the UART doesn't detect BREAK, so we have to do that ourselves
+	 * - it starts as a framing error on a NUL character
+	 * - then we count another two NUL characters before issuing TTY_BREAK
+	 * - then we end on a normal char or one that has all the bottom bits
+	 *   zero and the top bits set
+	 */
+	switch (port->rx_brk) {
+	case 0:
+		/* not breaking at the moment */
+		break;
+
+	case 1:
+		if (st & SC01STR_FEF && ch == 0) {
+			port->rx_brk = 2;
+			goto try_again;
+		}
+		goto not_break;
+
+	case 2:
+		if (st & SC01STR_FEF && ch == 0) {
+			port->rx_brk = 3;
+			_proto("Rx Break Detected");
+			icount->brk++;
+			if (uart_handle_break(&port->uart))
+				goto ignore_char;
+			status |= 1 << TTY_BREAK;
+			goto insert;
+		}
+		goto not_break;
+
+	default:
+		if (st & (SC01STR_FEF | SC01STR_PEF | SC01STR_OEF))
+			goto try_again; /* still breaking */
+
+		port->rx_brk = 0; /* end of the break */
+
+		switch (ch) {
+		case 0xFF:
+		case 0xFE:
+		case 0xFC:
+		case 0xF8:
+		case 0xF0:
+		case 0xE0:
+		case 0xC0:
+		case 0x80:
+		case 0x00:
+			/* discard char at probable break end */
+			goto try_again;
+		}
+		break;
+	}
+
+process_errors:
+	/* handle framing error */
+	if (st & SC01STR_FEF) {
+		if (ch == 0) {
+			/* framing error with NUL char is probably a BREAK */
+			port->rx_brk = 1;
+			goto try_again;
+		}
+
+		_proto("Rx Framing Error");
+		icount->frame++;
+		status |= 1 << TTY_FRAME;
+	}
+
+	/* handle parity error */
+	if (st & SC01STR_PEF) {
+		_proto("Rx Parity Error");
+		icount->parity++;
+		status = TTY_PARITY;
+	}
+
+	/* handle normal char */
+	if (status == 0) {
+		if (uart_handle_sysrq_char(&port->uart, ch))
+			goto ignore_char;
+		status = (1 << TTY_NORMAL);
+	}
+
+	/* handle overrun error */
+	if (st & SC01STR_OEF) {
+		if (port->rx_brk)
+			goto try_again;
+
+		_proto("Rx Overrun Error");
+		icount->overrun++;
+		overrun = 1;
+	}
+
+insert:
+	status &= port->uart.read_status_mask;
+
+	if (!overrun && !(status & port->uart.ignore_status_mask)) {
+		int flag;
+
+		if (status & (1 << TTY_BREAK))
+			flag = TTY_BREAK;
+		else if (status & (1 << TTY_PARITY))
+			flag = TTY_PARITY;
+		else if (status & (1 << TTY_FRAME))
+			flag = TTY_FRAME;
+		else
+			flag = TTY_NORMAL;
+
+		tty_insert_flip_char(tty, ch, flag);
+	}
+
+	/* overrun is special, since it's reported immediately, and doesn't
+	 * affect the current character
+	 */
+	if (overrun)
+		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+
+	count--;
+	if (count <= 0) {
+		if (!tty->low_latency)
+			tty_flip_buffer_push(tty);
+		return;
+	}
+
+ignore_char:
+	push = 1;
+	goto try_again;
+
+not_break:
+	port->rx_brk = 0;
+	goto process_errors;
+}
+
+/*
+ * handle an interrupt from the serial transmission "virtual DMA" driver
+ * - note: the interrupt routine will disable its own interrupts when the Tx
+ *   buffer is empty
+ */
+static void mn10300_serial_transmit_interrupt(struct mn10300_serial_port *port)
+{
+	_enter("%s", port->name);
+
+	if (uart_tx_stopped(&port->uart) ||
+	    uart_circ_empty(&port->uart.info->xmit))
+		mn10300_serial_dis_tx_intr(port);
+
+	if (uart_circ_chars_pending(&port->uart.info->xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&port->uart);
+}
+
+/*
+ * deal with a change in the status of the CTS line
+ */
+static void mn10300_serial_cts_changed(struct mn10300_serial_port *port,
+					 u8 st)
+{
+	u16 ctr;
+
+	port->tx_cts = st;
+	port->uart.icount.cts++;
+
+	/* flip the CTS state selector flag to interrupt when it changes
+	 * back */
+	ctr = *port->_control;
+	ctr ^= SC2CTR_TWS;
+	*port->_control = ctr;
+
+	uart_handle_cts_change(&port->uart, st & SC2STR_CTS);
+	wake_up_interruptible(&port->uart.info->delta_msr_wait);
+}
+
+/*
+ * handle a virtual interrupt generated by the lower level "virtual DMA"
+ * routines (irq is the baud timer interrupt)
+ */
+static irqreturn_t mn10300_serial_interrupt(int irq, void *dev_id)
+{
+	struct mn10300_serial_port *port = dev_id;
+	u8 st;
+
+	spin_lock(&port->uart.lock);
+
+	if (port->intr_flags) {
+		_debug("INT %s: %x", port->name, port->intr_flags);
+
+		if (mask_test_and_clear(&port->intr_flags, MNSCx_RX_AVAIL))
+			mn10300_serial_receive_interrupt(port);
+
+		if (mask_test_and_clear(&port->intr_flags,
+					MNSCx_TX_SPACE | MNSCx_TX_EMPTY))
+			mn10300_serial_transmit_interrupt(port);
+	}
+
+	/* the only modem control line amongst the whole lot is CTS on
+	 * serial port 2 */
+	if (port->type == PORT_MN10300_CTS) {
+		st = *port->_status;
+		if ((port->tx_cts ^ st) & SC2STR_CTS)
+			mn10300_serial_cts_changed(port, st);
+	}
+
+	spin_unlock(&port->uart.lock);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * return indication of whether the hardware transmit buffer is empty
+ */
+static unsigned int mn10300_serial_tx_empty(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s", port->name);
+
+	return (*port->_status & (SC01STR_TXF | SC01STR_TBF)) ?
+		0 : TIOCSER_TEMT;
+}
+
+/*
+ * set the modem control lines (we don't have any)
+ */
+static void mn10300_serial_set_mctrl(struct uart_port *_port, unsigned int mctrl)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s,%x", port->name, mctrl);
+}
+
+/*
+ * get the modem control line statuses
+ */
+static unsigned int mn10300_serial_get_mctrl(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s", port->name);
+
+	if (port->type == PORT_MN10300_CTS && !(*port->_status & SC2STR_CTS))
+		return TIOCM_CAR | TIOCM_DSR;
+
+	return TIOCM_CAR | TIOCM_CTS | TIOCM_DSR;
+}
+
+/*
+ * stop transmitting characters
+ */
+static void mn10300_serial_stop_tx(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s", port->name);
+
+	/* disable the virtual DMA */
+	mn10300_serial_dis_tx_intr(port);
+}
+
+/*
+ * start transmitting characters
+ * - jump-start transmission if it has stalled
+ *   - enable the serial Tx interrupt (used by the virtual DMA controller)
+ *   - force an interrupt to happen if necessary
+ */
+static void mn10300_serial_start_tx(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	u16 x;
+
+	_enter("%s{%lu}",
+	       port->name,
+	       CIRC_CNT(&port->uart.info->xmit.head,
+			&port->uart.info->xmit.tail,
+			UART_XMIT_SIZE));
+
+	/* kick the virtual DMA controller */
+	x = *port->tx_icr;
+	x |= GxICR_ENABLE;
+
+	if (*port->_status & SC01STR_TBF)
+		x &= ~(GxICR_REQUEST | GxICR_DETECT);
+	else
+		x |= GxICR_REQUEST | GxICR_DETECT;
+
+	_debug("CTR=%04hx ICR=%02hx STR=%04x TMD=%02hx TBR=%04hx ICR=%04hx",
+	       *port->_control, *port->_intr, *port->_status,
+	       *port->_tmxmd, *port->_tmxbr, *port->tx_icr);
+
+	*port->tx_icr = x;
+	x = *port->tx_icr;
+}
+
+/*
+ * transmit a high-priority XON/XOFF character
+ */
+static void mn10300_serial_send_xchar(struct uart_port *_port, char ch)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s,%02x", port->name, ch);
+
+	if (likely(port->gdbstub)) {
+		port->tx_xchar = ch;
+		if (ch)
+			mn10300_serial_en_tx_intr(port);
+	}
+}
+
+/*
+ * stop receiving characters
+ * - called whilst the port is being closed
+ */
+static void mn10300_serial_stop_rx(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	u16 ctr;
+
+	_enter("%s", port->name);
+
+	ctr = *port->_control;
+	ctr &= ~SC01CTR_RXE;
+	*port->_control = ctr;
+
+	mn10300_serial_dis_rx_intr(port);
+}
+
+/*
+ * enable modem status interrupts
+ */
+static void mn10300_serial_enable_ms(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	u16 ctr, cts;
+
+	_enter("%s", port->name);
+
+	if (port->type == PORT_MN10300_CTS) {
+		/* want to interrupt when CTS goes low if CTS is now high and
+		 * vice versa
+		 */
+		port->tx_cts = *port->_status;
+
+		cts = (port->tx_cts & SC2STR_CTS) ?
+			SC2CTR_TWE : SC2CTR_TWE | SC2CTR_TWS;
+
+		ctr = *port->_control;
+		ctr &= ~SC2CTR_TWS;
+		ctr |= cts;
+		*port->_control = ctr;
+
+		mn10300_serial_en_tx_intr(port);
+	}
+}
+
+/*
+ * transmit or cease transmitting a break signal
+ */
+static void mn10300_serial_break_ctl(struct uart_port *_port, int ctl)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s,%d", port->name, ctl);
+
+	if (ctl) {
+		/* tell the virtual DMA handler to assert BREAK */
+		port->tx_break = 1;
+		mn10300_serial_en_tx_intr(port);
+	} else {
+		port->tx_break = 0;
+		*port->_control &= ~SC01CTR_BKE;
+		mn10300_serial_en_tx_intr(port);
+	}
+}
+
+/*
+ * grab the interrupts and enable the port for reception
+ */
+static int mn10300_serial_startup(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+	struct mn10300_serial_int *pint;
+
+	_enter("%s{%d}", port->name, port->gdbstub);
+
+	if (unlikely(port->gdbstub))
+		return -EBUSY;
+
+	/* allocate an Rx buffer for the virtual DMA handler */
+	port->rx_buffer = (u8 *) kmalloc(MNSC_BUFFER_SIZE, GFP_KERNEL);
+	if (!port->rx_buffer)
+		return -ENOMEM;
+
+	port->rx_inp = port->rx_outp = 0;
+
+	/* finally, enable the device */
+	*port->_intr = SC01ICR_TI;
+	*port->_control |= SC01CTR_TXE | SC01CTR_RXE;
+
+	pint = &mn10300_serial_int_tbl[port->rx_irq];
+	pint->port = port;
+	pint->vdma = mn10300_serial_vdma_rx_handler;
+	pint = &mn10300_serial_int_tbl[port->tx_irq];
+	pint->port = port;
+	pint->vdma = mn10300_serial_vdma_tx_handler;
+
+	set_intr_level(port->rx_irq, GxICR_LEVEL_1);
+	set_intr_level(port->tx_irq, GxICR_LEVEL_1);
+	set_irq_chip(port->tm_irq, &mn10300_serial_pic);
+
+	if (request_irq(port->rx_irq, mn10300_serial_interrupt,
+			IRQF_DISABLED, port->rx_name, port) < 0)
+		goto error;
+
+	if (request_irq(port->tx_irq, mn10300_serial_interrupt,
+			IRQF_DISABLED, port->tx_name, port) < 0)
+		goto error2;
+
+	if (request_irq(port->tm_irq, mn10300_serial_interrupt,
+			IRQF_DISABLED, port->tm_name, port) < 0)
+		goto error3;
+	mn10300_serial_mask_ack(port->tm_irq);
+
+	return 0;
+
+error3:
+	free_irq(port->tx_irq, port);
+error2:
+	free_irq(port->rx_irq, port);
+error:
+	kfree(port->rx_buffer);
+	port->rx_buffer = NULL;
+	return -EBUSY;
+}
+
+/*
+ * shutdown the port and release interrupts
+ */
+static void mn10300_serial_shutdown(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s", port->name);
+
+	/* disable the serial port and its baud rate timer */
+	port->tx_break = 0;
+	*port->_control &= ~(SC01CTR_TXE | SC01CTR_RXE | SC01CTR_BKE);
+	*port->_tmxmd = 0;
+
+	if (port->rx_buffer) {
+		void *buf = port->rx_buffer;
+		port->rx_buffer = NULL;
+		kfree(buf);
+	}
+
+	/* disable all intrs */
+	free_irq(port->tm_irq, port);
+	free_irq(port->rx_irq, port);
+	free_irq(port->tx_irq, port);
+
+	*port->rx_icr = GxICR_LEVEL_1;
+	*port->tx_icr = GxICR_LEVEL_1;
+}
+
+/*
+ * this routine is called to set the UART divisor registers to match the
+ * specified baud rate for a serial port.
+ */
+static void mn10300_serial_change_speed(struct mn10300_serial_port *port,
+					  struct ktermios *new,
+					  struct ktermios *old)
+{
+	unsigned long flags;
+	unsigned long ioclk = port->ioclk;
+	unsigned cflag;
+	int baud, bits, xdiv, tmp;
+	u16 tmxbr, scxctr;
+	u8 tmxmd, battempt;
+	u8 div_timer = port->div_timer;
+
+	_enter("%s{%lu}", port->name, ioclk);
+
+	/* byte size and parity */
+	cflag = new->c_cflag;
+	switch (cflag & CSIZE) {
+	case CS7: scxctr = SC01CTR_CLN_7BIT; bits = 9;  break;
+	case CS8: scxctr = SC01CTR_CLN_8BIT; bits = 10; break;
+	default:  scxctr = SC01CTR_CLN_8BIT; bits = 10; break;
+	}
+
+	if (cflag & CSTOPB) {
+		scxctr |= SC01CTR_STB_2BIT;
+		bits++;
+	}
+
+	if (cflag & PARENB) {
+		bits++;
+		if (cflag & PARODD)
+			scxctr |= SC01CTR_PB_ODD;
+#ifdef CMSPAR
+		else if (cflag & CMSPAR)
+			scxctr |= SC01CTR_PB_FIXED0;
+#endif
+		else
+			scxctr |= SC01CTR_PB_EVEN;
+	}
+
+	/* Determine divisor based on baud rate */
+	battempt = 0;
+
+	if (div_timer == MNSCx_DIV_TIMER_16BIT)
+		scxctr |= SC0CTR_CK_TM8UFLOW_8; /* ( == SC1CTR_CK_TM9UFLOW_8
+						 *   == SC2CTR_CK_TM10UFLOW) */
+	else if (div_timer == MNSCx_DIV_TIMER_8BIT)
+		scxctr |= SC0CTR_CK_TM2UFLOW_8;
+
+try_alternative:
+	baud = uart_get_baud_rate(&port->uart, new, old, 0,
+				  port->ioclk / 8);
+
+	_debug("ALT %d [baud %d]", battempt, baud);
+
+	if (!baud)
+		baud = 9600;	/* B0 transition handled in rs_set_termios */
+	xdiv = 1;
+	if (baud == 134) {
+		baud = 269;	/* 134 is really 134.5 */
+		xdiv = 2;
+	}
+
+	if (baud == 38400 &&
+	    (port->uart.flags & UPF_SPD_MASK) == UPF_SPD_CUST
+	    ) {
+		_debug("CUSTOM %u", port->uart.custom_divisor);
+
+		if (div_timer == MNSCx_DIV_TIMER_16BIT) {
+			if (port->uart.custom_divisor <= 65535) {
+				tmxmd = TM8MD_SRC_IOCLK;
+				tmxbr = port->uart.custom_divisor;
+				port->uart.uartclk = ioclk;
+				goto timer_okay;
+			}
+			if (port->uart.custom_divisor / 8 <= 65535) {
+				tmxmd = TM8MD_SRC_IOCLK_8;
+				tmxbr = port->uart.custom_divisor / 8;
+				port->uart.custom_divisor = tmxbr * 8;
+				port->uart.uartclk = ioclk / 8;
+				goto timer_okay;
+			}
+			if (port->uart.custom_divisor / 32 <= 65535) {
+				tmxmd = TM8MD_SRC_IOCLK_32;
+				tmxbr = port->uart.custom_divisor / 32;
+				port->uart.custom_divisor = tmxbr * 32;
+				port->uart.uartclk = ioclk / 32;
+				goto timer_okay;
+			}
+
+		} else if (div_timer == MNSCx_DIV_TIMER_8BIT) {
+			if (port->uart.custom_divisor <= 255) {
+				tmxmd = TM2MD_SRC_IOCLK;
+				tmxbr = port->uart.custom_divisor;
+				port->uart.uartclk = ioclk;
+				goto timer_okay;
+			}
+			if (port->uart.custom_divisor / 8 <= 255) {
+				tmxmd = TM2MD_SRC_IOCLK_8;
+				tmxbr = port->uart.custom_divisor / 8;
+				port->uart.custom_divisor = tmxbr * 8;
+				port->uart.uartclk = ioclk / 8;
+				goto timer_okay;
+			}
+			if (port->uart.custom_divisor / 32 <= 255) {
+				tmxmd = TM2MD_SRC_IOCLK_32;
+				tmxbr = port->uart.custom_divisor / 32;
+				port->uart.custom_divisor = tmxbr * 32;
+				port->uart.uartclk = ioclk / 32;
+				goto timer_okay;
+			}
+		}
+	}
+
+	switch (div_timer) {
+	case MNSCx_DIV_TIMER_16BIT:
+		port->uart.uartclk = ioclk;
+		tmxmd = TM8MD_SRC_IOCLK;
+		tmxbr = tmp = (ioclk / (baud * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 65535)
+			goto timer_okay;
+
+		port->uart.uartclk = ioclk / 8;
+		tmxmd = TM8MD_SRC_IOCLK_8;
+		tmxbr = tmp = (ioclk / (baud * 8 * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 65535)
+			goto timer_okay;
+
+		port->uart.uartclk = ioclk / 32;
+		tmxmd = TM8MD_SRC_IOCLK_32;
+		tmxbr = tmp = (ioclk / (baud * 32 * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 65535)
+			goto timer_okay;
+		break;
+
+	case MNSCx_DIV_TIMER_8BIT:
+		port->uart.uartclk = ioclk;
+		tmxmd = TM2MD_SRC_IOCLK;
+		tmxbr = tmp = (ioclk / (baud * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 255)
+			goto timer_okay;
+
+		port->uart.uartclk = ioclk / 8;
+		tmxmd = TM2MD_SRC_IOCLK_8;
+		tmxbr = tmp = (ioclk / (baud * 8 * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 255)
+			goto timer_okay;
+
+		port->uart.uartclk = ioclk / 32;
+		tmxmd = TM2MD_SRC_IOCLK_32;
+		tmxbr = tmp = (ioclk / (baud * 32 * xdiv) + 4) / 8 - 1;
+		if (tmp > 0 && tmp <= 255)
+			goto timer_okay;
+		break;
+
+	default:
+		BUG();
+		return;
+	}
+
+	/* refuse to change to a baud rate we can't support */
+	_debug("CAN'T SUPPORT");
+
+	switch (battempt) {
+	case 0:
+		if (old) {
+			new->c_cflag &= ~CBAUD;
+			new->c_cflag |= (old->c_cflag & CBAUD);
+			battempt = 1;
+			goto try_alternative;
+		}
+
+	case 1:
+		/* as a last resort, if the quotient is zero, default to 9600
+		 * bps */
+		new->c_cflag &= ~CBAUD;
+		new->c_cflag |= B9600;
+		battempt = 2;
+		goto try_alternative;
+
+	default:
+		/* hmmm... can't seem to support 9600 either
+		 * - we could try iterating through the speeds we know about to
+		 *   find the lowest
+		 */
+		new->c_cflag &= ~CBAUD;
+		new->c_cflag |= B0;
+
+		if (div_timer == MNSCx_DIV_TIMER_16BIT)
+			tmxmd = TM8MD_SRC_IOCLK_32;
+		else if (div_timer == MNSCx_DIV_TIMER_8BIT)
+			tmxmd = TM2MD_SRC_IOCLK_32;
+		tmxbr = 1;
+
+		port->uart.uartclk = ioclk / 32;
+		break;
+	}
+timer_okay:
+
+	_debug("UARTCLK: %u / %hu", port->uart.uartclk, tmxbr);
+
+	/* make the changes */
+	spin_lock_irqsave(&port->uart.lock, flags);
+
+	uart_update_timeout(&port->uart, new->c_cflag, baud);
+
+	/* set the timer to produce the required baud rate */
+	switch (div_timer) {
+	case MNSCx_DIV_TIMER_16BIT:
+		*port->_tmxmd = 0;
+		*port->_tmxbr = tmxbr;
+		*port->_tmxmd = TM8MD_INIT_COUNTER;
+		*port->_tmxmd = tmxmd | TM8MD_COUNT_ENABLE;
+		break;
+
+	case MNSCx_DIV_TIMER_8BIT:
+		*port->_tmxmd = 0;
+		*(volatile u8 *) port->_tmxbr = (u8) tmxbr;
+		*port->_tmxmd = TM2MD_INIT_COUNTER;
+		*port->_tmxmd = tmxmd | TM2MD_COUNT_ENABLE;
+		break;
+	}
+
+	/* CTS flow control flag and modem status interrupts */
+	scxctr &= ~(SC2CTR_TWE | SC2CTR_TWS);
+
+	if (port->type == PORT_MN10300_CTS && cflag & CRTSCTS) {
+		/* want to interrupt when CTS goes low if CTS is now
+		 * high and vice versa
+		 */
+		port->tx_cts = *port->_status;
+
+		if (port->tx_cts & SC2STR_CTS)
+			scxctr |= SC2CTR_TWE;
+		else
+			scxctr |= SC2CTR_TWE | SC2CTR_TWS;
+	}
+
+	/* set up parity check flag */
+	port->uart.read_status_mask = (1 << TTY_NORMAL) | (1 << TTY_OVERRUN);
+	if (new->c_iflag & INPCK)
+		port->uart.read_status_mask |= (1 << TTY_PARITY) | (1 << TTY_FRAME);
+	if (new->c_iflag & (BRKINT | PARMRK))
+		port->uart.read_status_mask |= (1 << TTY_BREAK);
+
+	/* characters to ignore */
+	port->uart.ignore_status_mask = 0;
+	if (new->c_iflag & IGNPAR)
+		port->uart.ignore_status_mask |= (1 << TTY_PARITY) | (1 << TTY_FRAME);
+	if (new->c_iflag & IGNBRK) {
+		port->uart.ignore_status_mask |= (1 << TTY_BREAK);
+		/*
+		 * If we're ignoring parity and break indicators,
+		 * ignore overruns to (for real raw support).
+		 */
+		if (new->c_iflag & IGNPAR)
+			port->uart.ignore_status_mask |= (1 << TTY_OVERRUN);
+	}
+
+	/* Ignore all characters if CREAD is not set */
+	if ((new->c_cflag & CREAD) == 0)
+		port->uart.ignore_status_mask |= (1 << TTY_NORMAL);
+
+	scxctr |= *port->_control & (SC01CTR_TXE | SC01CTR_RXE | SC01CTR_BKE);
+	*port->_control = scxctr;
+
+	spin_unlock_irqrestore(&port->uart.lock, flags);
+}
+
+/*
+ * set the terminal I/O parameters
+ */
+static void mn10300_serial_set_termios(struct uart_port *_port,
+					 struct ktermios *new,
+					 struct ktermios *old)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s,%p,%p", port->name, new, old);
+
+	mn10300_serial_change_speed(port, new, old);
+
+	/* handle turning off CRTSCTS */
+	if (!(new->c_cflag & CRTSCTS)) {
+		u16 ctr = *port->_control;
+		ctr &= ~SC2CTR_TWE;
+		*port->_control = ctr;
+	}
+}
+
+/*
+ * return description of port type
+ */
+static const char *mn10300_serial_type(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	if (port->uart.type == PORT_MN10300_CTS)
+		return "MN10300 SIF_CTS";
+
+	return "MN10300 SIF";
+}
+
+/*
+ * release I/O and memory regions in use by port
+ */
+static void mn10300_serial_release_port(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s", port->name);
+
+	release_mem_region((unsigned long) port->_iobase, 16);
+}
+
+/*
+ * request I/O and memory regions for port
+ */
+static int mn10300_serial_request_port(struct uart_port *_port)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s", port->name);
+
+	request_mem_region((unsigned long) port->_iobase, 16, port->name);
+	return 0;
+}
+
+/*
+ * configure the type and reserve the ports
+ */
+static void mn10300_serial_config_port(struct uart_port *_port, int type)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s", port->name);
+
+	port->uart.type = PORT_MN10300;
+
+	if (port->options & MNSCx_OPT_CTS)
+		port->uart.type = PORT_MN10300_CTS;
+
+	mn10300_serial_request_port(_port);
+}
+
+/*
+ * verify serial parameters are suitable for this port type
+ */
+static int mn10300_serial_verify_port(struct uart_port *_port,
+					struct serial_struct *ss)
+{
+	struct mn10300_serial_port *port =
+		container_of(_port, struct mn10300_serial_port, uart);
+
+	_enter("%s", port->name);
+
+	/* these things may not be changed */
+	if (ss->irq		!= port->uart.irq	||
+	    ss->port		!= port->uart.iobase	||
+	    ss->io_type		!= port->uart.iotype	||
+	    ss->iomem_base	!= (void *) (unsigned long) port->uart.mapbase ||
+	    ss->iomem_reg_shift	!= port->uart.regshift	||
+	    ss->hub6		!= port->uart.hub6	||
+	    ss->xmit_fifo_size	!= port->uart.fifosize)
+		return -EINVAL;
+
+	/* type may be changed on a port that supports CTS */
+	if (ss->type != port->uart.type) {
+		if (!(port->options & MNSCx_OPT_CTS))
+			return -EINVAL;
+
+		if (ss->type != PORT_MN10300 &&
+		    ss->type != PORT_MN10300_CTS)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * initialise the MN10300 on-chip UARTs
+ */
+static int __init mn10300_serial_init(void)
+{
+	struct mn10300_serial_port *port;
+	int ret, i;
+
+ 	printk(KERN_INFO "%s version %s (%s)\n",
+	       serial_name, serial_version, serial_revdate);
+
+#ifdef CONFIG_MN10300_TTYSM2
+	SC2TIM = 8; /* make the baud base of timer 2 IOCLK/8 */
+#endif
+
+	set_intr_stub(EXCEP_IRQ_LEVEL1, mn10300_serial_vdma_interrupt);
+
+	ret = uart_register_driver(&mn10300_serial_driver);
+	if (!ret) {
+		for (i = 0 ; i < NR_PORTS ; i++) {
+			port = mn10300_serial_ports[i];
+			if (!port || port->gdbstub)
+				continue;
+
+			switch (port->clock_src) {
+			case MNSCx_CLOCK_SRC_IOCLK:
+				port->ioclk = MN10300_IOCLK;
+				break;
+
+#ifdef MN10300_IOBCLK
+			case MNSCx_CLOCK_SRC_IOBCLK:
+				port->ioclk = MN10300_IOBCLK;
+				break;
+#endif
+			default:
+				BUG();
+			}
+
+			ret = uart_add_one_port(&mn10300_serial_driver,
+						&port->uart);
+
+			if (ret < 0) {
+				_debug("ERROR %d", -ret);
+				break;
+			}
+		}
+
+		if (ret)
+			uart_unregister_driver(&mn10300_serial_driver);
+	}
+
+	return ret;
+}
+
+__initcall(mn10300_serial_init);
+
+
+#ifdef CONFIG_MN10300_TTYSM_CONSOLE
+
+/*
+ * print a string to the serial port without disturbing the real user of the
+ * port too much
+ * - the console must be locked by the caller
+ */
+static void mn10300_serial_console_write(struct console *co,
+					   const char *s, unsigned count)
+{
+	struct mn10300_serial_port *port;
+	unsigned i;
+	u16 scxctr, txicr, tmp;
+	u8 tmxmd;
+
+	port = mn10300_serial_ports[co->index];
+
+	/* firstly hijack the serial port from the "virtual DMA" controller */
+	txicr = *port->tx_icr;
+	*port->tx_icr = GxICR_LEVEL_1;
+	tmp = *port->tx_icr;
+
+	/* the transmitter may be disabled */
+	scxctr = *port->_control;
+	if (!(scxctr & SC01CTR_TXE)) {
+		/* restart the UART clock */
+		tmxmd = *port->_tmxmd;
+
+		switch (port->div_timer) {
+		case MNSCx_DIV_TIMER_16BIT:
+			*port->_tmxmd = 0;
+			*port->_tmxmd = TM8MD_INIT_COUNTER;
+			*port->_tmxmd = tmxmd | TM8MD_COUNT_ENABLE;
+			break;
+
+		case MNSCx_DIV_TIMER_8BIT:
+			*port->_tmxmd = 0;
+			*port->_tmxmd = TM2MD_INIT_COUNTER;
+			*port->_tmxmd = tmxmd | TM2MD_COUNT_ENABLE;
+			break;
+		}
+
+		/* enable the transmitter */
+		*port->_control = (scxctr & ~SC01CTR_BKE) | SC01CTR_TXE;
+
+	} else if (scxctr & SC01CTR_BKE) {
+		/* stop transmitting BREAK */
+		*port->_control = (scxctr & ~SC01CTR_BKE);
+	}
+
+	/* send the chars into the serial port (with LF -> LFCR conversion) */
+	for (i = 0; i < count; i++) {
+		char ch = *s++;
+
+		while (*port->_status & SC01STR_TBF)
+			continue;
+		*(u8 *) port->_txb = ch;
+
+		if (ch == 0x0a) {
+			while (*port->_status & SC01STR_TBF)
+				continue;
+			*(u8 *) port->_txb = 0xd;
+		}
+	}
+
+	/* can't let the transmitter be turned off if it's actually
+	 * transmitting */
+	while (*port->_status & (SC01STR_TXF | SC01STR_TBF))
+		continue;
+
+	/* disable the transmitter if we re-enabled it */
+	if (!(scxctr & SC01CTR_TXE))
+		*port->_control = scxctr;
+
+	*port->tx_icr = txicr;
+	tmp = *port->tx_icr;
+}
+
+/*
+ * set up a serial port as a console
+ * - construct a cflag setting for the first rs_open()
+ * - initialize the serial port
+ * - return non-zero if we didn't find a serial port.
+ */
+static int __init mn10300_serial_console_setup(struct console *co,
+						 char *options)
+{
+	struct mn10300_serial_port *port;
+	int i, parity = 'n', baud = 9600, bits = 8, flow = 0;
+
+	for (i = 0 ; i < NR_PORTS ; i++) {
+		port = mn10300_serial_ports[i];
+		if (port && !port->gdbstub && port->uart.line == co->index)
+			goto found_device;
+	}
+
+	return -ENODEV;
+
+found_device:
+	switch (port->clock_src) {
+	case MNSCx_CLOCK_SRC_IOCLK:
+		port->ioclk = MN10300_IOCLK;
+		break;
+
+#ifdef MN10300_IOBCLK
+	case MNSCx_CLOCK_SRC_IOBCLK:
+		port->ioclk = MN10300_IOBCLK;
+		break;
+#endif
+	default:
+		BUG();
+	}
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	return uart_set_options(&port->uart, co, baud, parity, bits, flow);
+}
+
+/*
+ * register console
+ */
+static int __init mn10300_serial_console_init(void)
+{
+	register_console(&mn10300_serial_console);
+	return 0;
+}
+
+console_initcall(mn10300_serial_console_init);
+#endif
diff -puN /dev/null arch/mn10300/kernel/mn10300-serial.h
--- /dev/null
+++ a/arch/mn10300/kernel/mn10300-serial.h
@@ -0,0 +1,126 @@
+/* MN10300 On-chip serial port driver definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _MN10300_SERIAL_H
+#define _MN10300_SERIAL_H
+
+#ifndef __ASSEMBLY__
+#include <linux/serial_core.h>
+#include <linux/termios.h>
+#endif
+
+#include <asm/page.h>
+#include <asm/serial-regs.h>
+
+#define NR_PORTS		3		// should be set 3 or 9 or 16
+
+#define MNSC_BUFFER_SIZE	+(PAGE_SIZE/2)
+
+/* intr_flags bits */
+#define MNSCx_RX_AVAIL		0x01
+#define MNSCx_RX_OVERF		0x02
+#define MNSCx_TX_SPACE		0x04
+#define MNSCx_TX_EMPTY		0x08
+
+#ifndef __ASSEMBLY__
+
+struct mn10300_serial_port {
+	char			*rx_buffer;	/* reception buffer base */
+	volatile unsigned	rx_inp;		/* pointer to rx input offset */
+	volatile unsigned	rx_outp;	/* pointer to rx output offset */
+	volatile u8		tx_xchar;	/* high-priority XON/XOFF buffer */
+	volatile u8		tx_break;	/* transmit break request */
+	volatile u8		intr_flags;	/* interrupt flags */
+	volatile u16		*rx_icr;	/* Rx interrupt control register */
+	volatile u16		*tx_icr;	/* Tx interrupt control register */
+	int			rx_irq;		/* reception IRQ */
+	int			tx_irq;		/* transmission IRQ */
+	int			tm_irq;		/* timer IRQ */
+
+	const char		*name;		/* name of serial port */
+	const char		*rx_name;	/* Rx interrupt handler name of serial port */
+	const char		*tx_name;	/* Tx interrupt handler name of serial port */
+	const char		*tm_name;	/* Timer interrupt handler name */
+	unsigned short		type;		/* type of serial port */
+	unsigned char		isconsole;	/* T if it's a console */
+	volatile void		*_iobase;	/* pointer to base of I/O control regs */
+	volatile u16		*_control;	/* control register pointer */
+	volatile u8		*_status;	/* status register pointer */
+	volatile u8		*_intr;		/* interrupt register pointer */
+	volatile void		*_rxb;		/* receive buffer register pointer */
+	volatile void		*_txb;		/* transmit buffer register pointer */
+	volatile u16		*_tmicr;	/* timer interrupt control register */
+	volatile u8		*_tmxmd;	/* baud rate timer mode register */
+	volatile u16		*_tmxbr;	/* baud rate timer base register */
+
+	/* this must come down here so that assembly can use BSET to access the
+	 * above fields */
+	struct uart_port	uart;
+
+	unsigned short		rx_brk;		/* current break reception status */
+	u16			tx_cts;		/* current CTS status */
+	int			gdbstub;	/* preemptively stolen by GDB stub */
+
+	u8			clock_src;	/* clock source */
+#define MNSCx_CLOCK_SRC_IOCLK	0
+#define MNSCx_CLOCK_SRC_IOBCLK	1
+
+	u8			div_timer;	/* timer used as divisor */
+#define MNSCx_DIV_TIMER_16BIT	0
+#define MNSCx_DIV_TIMER_8BIT	1
+
+	u16			options;	/* options */
+#define MNSCx_OPT_CTS		0x0001
+
+	unsigned long		ioclk;		/* base clock rate */
+};
+
+#ifdef CONFIG_MN10300_TTYSM0
+extern struct mn10300_serial_port mn10300_serial_port_sif0;
+#endif
+
+#ifdef CONFIG_MN10300_TTYSM1
+extern struct mn10300_serial_port mn10300_serial_port_sif1;
+#endif
+
+#ifdef CONFIG_MN10300_TTYSM2
+extern struct mn10300_serial_port mn10300_serial_port_sif2;
+#endif
+
+extern struct mn10300_serial_port *mn10300_serial_ports[];
+
+struct mn10300_serial_int {
+	struct mn10300_serial_port *port;
+	asmlinkage void (*vdma)(void);
+};
+
+extern struct mn10300_serial_int mn10300_serial_int_tbl[];
+
+extern asmlinkage void mn10300_serial_vdma_interrupt(void);
+extern asmlinkage void mn10300_serial_vdma_rx_handler(void);
+extern asmlinkage void mn10300_serial_vdma_tx_handler(void);
+
+#endif /* __ASSEMBLY__ */
+
+#if defined(CONFIG_GDBSTUB_ON_TTYSM0)
+#define SCgSTR SC0STR
+#define SCgRXB SC0RXB
+#define SCgRXIRQ SC0RXIRQ
+#elif defined(CONFIG_GDBSTUB_ON_TTYSM1)
+#define SCgSTR SC1STR
+#define SCgRXB SC1RXB
+#define SCgRXIRQ SC1RXIRQ
+#elif defined(CONFIG_GDBSTUB_ON_TTYSM2)
+#define SCgSTR SC2STR
+#define SCgRXB SC2RXB
+#define SCgRXIRQ SC2RXIRQ
+#endif
+
+#endif /* _MN10300_SERIAL_H */
diff -puN /dev/null arch/mn10300/kernel/mn10300-serial-low.S
--- /dev/null
+++ a/arch/mn10300/kernel/mn10300-serial-low.S
@@ -0,0 +1,186 @@
+###############################################################################
+#
+# Virtual DMA driver for MN10300 serial ports
+#
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/page.h>
+#include <asm/smp.h>
+#include <asm/cpu-regs.h>
+#include <asm/frame.inc>
+#include <asm/timer-regs.h>
+#include <asm/proc/cache.h>
+#include <asm/unit/timex.h>
+#include "mn10300-serial.h"
+
+#define	SCxCTR	0x00
+#define	SCxICR	0x04
+#define	SCxTXB	0x08
+#define	SCxRXB	0x09
+#define	SCxSTR	0x0c
+#define	SCxTIM	0x0d
+
+	.text
+
+###################################################################################################
+#
+# serial port interrupt virtual DMA entry point
+# - intended to run at interrupt priority 1 (not affected by local_irq_disable)
+#
+###################################################################################################
+	.balign	L1_CACHE_BYTES
+ENTRY(mn10300_serial_vdma_interrupt)
+	or	EPSW_IE,psw			# permit overriding by debugging interrupts
+	movm	[d2,d3,a2,a3,exreg0],(sp)
+
+	movhu	(IAGR),a2			# see if which interrupt is pending
+	and	IAGR_GN,a2
+	add	a2,a2
+	add	mn10300_serial_int_tbl,a2
+
+	mov	(a2+),a3
+	mov	(__iobase,a3),e2
+	mov	(a2),a2
+	jmp	(a2)
+
+###################################################################################################
+#
+# serial port receive interrupt virtual DMA entry point
+# - intended to run at interrupt priority 1 (not affected by local_irq_disable)
+# - stores data/status byte pairs in the ring buffer
+# - induces a scheduler tick timer interrupt when done, which we then subvert
+# on entry:
+#	A3	struct mn10300_serial_port *
+#	E2	I/O port base
+#
+###################################################################################################
+ENTRY(mn10300_serial_vdma_rx_handler)
+	mov	(__rx_icr,a3),e3
+	mov	GxICR_DETECT,d2
+	movbu	d2,(e3)				# ACK the interrupt
+	movhu	(e3),d2				# flush
+
+	mov	(__rx_inp,a3),d3
+	mov	d3,a2
+	add	2,d3
+	and	MNSC_BUFFER_SIZE-1,d3
+	mov	(__rx_outp,a3),d2
+	cmp	d3,d2
+	beq	mnsc_vdma_rx_overflow
+
+	mov	(__rx_buffer,a3),d2
+	add	d2,a2
+	movhu	(SCxSTR,e2),d2
+	movbu	d2,(1,a2)
+	movbu	(SCxRXB,e2),d2
+	movbu	d2,(a2)
+	mov	d3,(__rx_inp,a3)
+	bset	MNSCx_RX_AVAIL,(__intr_flags,a3)
+
+mnsc_vdma_rx_done:
+	mov	(__tm_icr,a3),a2
+	mov	GxICR_LEVEL_6|GxICR_ENABLE|GxICR_REQUEST|GxICR_DETECT,d2
+	movhu	d2,(a2)				# request a slow interrupt
+	movhu	(a2),d2				# flush
+
+	movm	(sp),[d2,d3,a2,a3,exreg0]
+	rti
+
+mnsc_vdma_rx_overflow:
+	bset	MNSCx_RX_OVERF,(__intr_flags,a3)
+	bra	mnsc_vdma_rx_done
+
+###################################################################################################
+#
+# serial port transmit interrupt virtual DMA entry point
+# - intended to run at interrupt priority 1 (not affected by local_irq_disable)
+# - retrieves data bytes from the ring buffer and passes them to the serial port
+# - induces a scheduler tick timer interrupt when done, which we then subvert
+#	A3	struct mn10300_serial_port *
+#	E2	I/O port base
+#
+###################################################################################################
+	.balign	L1_CACHE_BYTES
+ENTRY(mn10300_serial_vdma_tx_handler)
+	mov	(__tx_icr,a3),e3
+	mov	GxICR_DETECT,d2
+	movbu	d2,(e3)			# ACK the interrupt
+	movhu	(e3),d2			# flush
+
+	btst	0x01,(__tx_break,a3)	# handle transmit break request
+	bne	mnsc_vdma_tx_break
+
+	movbu	(SCxSTR,e2),d2		# don't try and transmit a char if the buffer is not empty
+	btst	SC01STR_TBF,d2		# (may have tried to jumpstart)
+	bne	mnsc_vdma_tx_noint
+
+	movbu	(__tx_xchar,a3),d2	# handle hi-pri XON/XOFF
+	or	d2,d2
+	bne	mnsc_vdma_tx_xchar
+
+	mov	(__tx_info_buffer,a3),a2	# get the uart_info struct for Tx
+	mov	(__xmit_tail,a2),d3
+	mov	(__xmit_head,a2),d2
+	cmp	d3,d2
+	beq	mnsc_vdma_tx_empty
+
+	mov	(__xmit_buffer,a2),d2	# get a char from the buffer and transmit it
+	movbu	(d3,d2),d2
+	movbu	d2,(SCxTXB,e2)		# Tx
+
+	inc	d3			# advance the buffer pointer
+	and	__UART_XMIT_SIZE-1,d3
+	mov	(__xmit_head,a2),d2
+	mov	d3,(__xmit_tail,a2)
+
+	sub	d3,d2			# see if we've written everything
+	beq	mnsc_vdma_tx_empty
+
+	and	__UART_XMIT_SIZE-1,d2	# see if we just made a hole
+	cmp	__UART_XMIT_SIZE-2,d2
+	beq	mnsc_vdma_tx_made_hole
+
+mnsc_vdma_tx_done:
+	mov	(__tm_icr,a3),a2
+	mov	GxICR_LEVEL_6|GxICR_ENABLE|GxICR_REQUEST|GxICR_DETECT,d2
+	movhu	d2,(a2)			# request a slow interrupt
+	movhu	(a2),d2			# flush
+
+mnsc_vdma_tx_noint:
+	movm	(sp),[d2,d3,a2,a3,exreg0]
+	rti
+
+mnsc_vdma_tx_empty:
+	mov	+(GxICR_LEVEL_1|GxICR_DETECT),d2
+	movhu	d2,(e3)			# disable the interrupt
+	movhu	(e3),d2			# flush
+
+	bset	MNSCx_TX_EMPTY,(__intr_flags,a3)
+	bra	mnsc_vdma_tx_done
+
+mnsc_vdma_tx_break:
+	movhu	(SCxCTR,e2),d2		# turn on break mode
+	or	SC01CTR_BKE,d2
+	movhu	d2,(SCxCTR,e2)
+	mov	+(GxICR_LEVEL_1|GxICR_DETECT),d2
+	movhu	d2,(e3)			# disable transmit interrupts on this channel
+	movhu	(e3),d2			# flush
+	bra	mnsc_vdma_tx_noint
+
+mnsc_vdma_tx_xchar:
+	bclr	0xff,(__tx_xchar,a3)
+	movbu	d2,(SCxTXB,e2)
+	bra	mnsc_vdma_tx_done
+
+mnsc_vdma_tx_made_hole:
+	bset	MNSCx_TX_SPACE,(__intr_flags,a3)
+	bra	mnsc_vdma_tx_done
diff -puN /dev/null arch/mn10300/kernel/mn10300-watchdog.c
--- /dev/null
+++ a/arch/mn10300/kernel/mn10300-watchdog.c
@@ -0,0 +1,180 @@
+/* MN10300 Watchdog timer
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from arch/i386/kernel/nmi.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+#include <linux/nmi.h>
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/atomic.h>
+#include <asm/intctl-regs.h>
+#include <asm/rtc-regs.h>
+#include <asm/div64.h>
+#include <asm/smp.h>
+#include <asm/gdb-stub.h>
+#include <asm/proc/clock.h>
+
+static spinlock_t watchdog_print_lock = SPIN_LOCK_UNLOCKED;
+static unsigned int watchdog = 0;
+static unsigned int watchdog_hz = 1;
+unsigned int watchdog_alert_counter = 0;
+
+EXPORT_SYMBOL(touch_nmi_watchdog);
+
+/*
+ * the best way to detect whether a CPU has a 'hard lockup' problem
+ * is to check its timer makes IRQ counts. If they are not
+ * changing then that CPU has some problem.
+ *
+ * as these watchdog NMI IRQs are generated on every CPU, we only
+ * have to check the current processor.
+ *
+ * since NMIs dont listen to _any_ locks, we have to be extremely
+ * careful not to rely on unsafe variables. The printk might lock
+ * up though, so we have to break up any console locks first ...
+ * [when there will be more tty-related locks, break them up
+ *  here too!]
+ */
+static unsigned int last_irq_sums[NR_CPUS];
+
+int __init check_watchdog(void)
+{
+	irq_cpustat_t tmp[1];
+
+	printk(KERN_INFO "Testing Watchdog... ");
+
+	memcpy(tmp, irq_stat, sizeof(tmp));
+	local_irq_enable();
+	mdelay((10 * 1000) / watchdog_hz); // wait 10 ticks
+	local_irq_disable();
+
+	if (nmi_count(0) - tmp[0].__nmi_count <= 5) {
+		printk("CPU#%d: Watchdog appears to be stuck!\n", 0);
+		return -1;
+	}
+
+	printk("OK.\n");
+
+	/* now that we know it works we can reduce NMI frequency to
+	 * something more reasonable; makes a difference in some configs
+	 */
+	watchdog_hz = 1;
+
+	return 0;
+}
+
+static int __init setup_watchdog(char *str)
+{
+	unsigned tmp;
+	int opt;
+	u8 ctr;
+
+	get_option(&str, &opt);
+	if (opt != 1)
+		return 0;
+
+	watchdog = opt;
+	if (watchdog) {
+		set_intr_stub(EXCEP_WDT, watchdog_handler);
+		ctr = WDCTR_WDCK_65536th;
+		WDCTR = WDCTR_WDRST | ctr;
+		WDCTR = ctr;
+		tmp = WDCTR;
+
+		tmp = __muldiv64u(1 << (16 + ctr * 2), 1000000, MN10300_WDCLK);
+		tmp = 1000000000 / tmp;
+		watchdog_hz = (tmp + 500) / 1000;
+	}
+
+	return 1;
+}
+
+__setup("watchdog=", setup_watchdog);
+
+void __init watchdog_go(void)
+{
+	u8 wdt;
+
+	if (watchdog) {
+		printk("Watchdog: running at %uHz\n", watchdog_hz);
+		wdt = WDCTR & ~WDCTR_WDCNE;
+		WDCTR = wdt | WDCTR_WDRST;
+		wdt = WDCTR;
+		WDCTR = wdt | WDCTR_WDCNE;
+		wdt = WDCTR;
+
+		check_watchdog();
+	}
+}
+
+asmlinkage void watchdog_interrupt(struct pt_regs *regs, exception_code_t excep)
+{
+
+	/*
+	 * Since current-> is always on the stack, and we always switch
+	 * the stack NMI-atomically, it's safe to use smp_processor_id().
+	 */
+	int sum, cpu = smp_processor_id();
+	u8 wdt, tmp;
+
+	wdt = WDCTR & ~WDCTR_WDCNE;
+	WDCTR = wdt;
+	tmp = WDCTR;
+	NMICR = NMICR_WDIF;
+
+	nmi_count(cpu)++;
+	kstat_this_cpu.irqs[NMIIRQ]++;
+	sum = irq_stat[cpu].__irq_count;
+
+	if (last_irq_sums[cpu] == sum) {
+		/*
+		 * Ayiee, looks like this CPU is stuck ...
+		 * wait a few IRQs (5 seconds) before doing the oops ...
+		 */
+		watchdog_alert_counter++;
+		if (watchdog_alert_counter == 5 * watchdog_hz) {
+			spin_lock(&watchdog_print_lock);
+			/*
+			 * We are in trouble anyway, lets at least try
+			 * to get a message out.
+			 */
+			bust_spinlocks(1);
+			printk("NMI Watchdog detected LOCKUP on CPU%d,"
+			       " pc %08lx, registers:\n",
+			       cpu, regs->pc);
+			show_registers(regs);
+			printk("console shuts up ...\n");
+			console_silent();
+			spin_unlock(&watchdog_print_lock);
+			bust_spinlocks(0);
+#ifdef CONFIG_GDBSTUB
+			if (gdbstub_busy)
+				gdbstub_exception(regs, excep);
+			else
+				gdbstub_intercept(regs, excep);
+#endif
+			do_exit(SIGSEGV);
+		}
+	} else {
+		last_irq_sums[cpu] = sum;
+		watchdog_alert_counter = 0;
+	}
+
+	WDCTR = wdt | WDCTR_WDRST;
+	tmp = WDCTR;
+	WDCTR = wdt | WDCTR_WDCNE;
+	tmp = WDCTR;
+}
diff -puN /dev/null arch/mn10300/kernel/mn10300-watchdog-low.S
--- /dev/null
+++ a/arch/mn10300/kernel/mn10300-watchdog-low.S
@@ -0,0 +1,58 @@
+###############################################################################
+#
+# MN10300 Watchdog interrupt handler
+#
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/intctl-regs.h>
+#include <asm/timer-regs.h>
+#include <asm/frame.inc>
+
+	.text
+
+###################################################################################################
+#
+# Watchdog handler entry point
+# - special non-maskable interrupt
+#
+###################################################################################################
+	.globl	watchdog_handler
+	.type	watchdog_handler,@function
+watchdog_handler:
+	add	-4,sp
+	SAVE_ALL
+
+	mov	0xffffffff,d0
+	mov	d0,(REG_ORIG_D0,fp)
+
+	mov	fp,d0
+	lsr	2,d1
+	call	watchdog_interrupt[],0		# watchdog_interrupt(regs,irq)
+
+	jmp	ret_from_intr
+
+	.size	watchdog_handler,.-watchdog_handler
+
+###################################################################################################
+#
+# Watchdog touch entry point
+# - kept to absolute minimum (unfortunately, it's prototyped in linux/nmi.h so we can't inline it)
+#
+###################################################################################################
+	.globl	touch_nmi_watchdog
+	.type	touch_nmi_watchdog,@function
+touch_nmi_watchdog:
+	clr	d0
+	mov	d0,(watchdog_alert_counter)
+	ret	[],0
+
+	.size	touch_nmi_watchdog,.-touch_nmi_watchdog
diff -puN /dev/null arch/mn10300/kernel/module.c
--- /dev/null
+++ a/arch/mn10300/kernel/module.c
@@ -0,0 +1,206 @@
+/* MN10300 Kernel module helper routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by Mark Salter (msalter@redhat.com)
+ * - Derived from arch/i386/kernel/module.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public Licence as published by
+ * the Free Software Foundation; either version 2 of the Licence, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public Licence for more details.
+ *
+ * You should have received a copy of the GNU General Public Licence
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/moduleloader.h>
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(fmt, ...)
+#endif
+
+/*
+ * allocate storage for a module
+ */
+void *module_alloc(unsigned long size)
+{
+	if (size == 0)
+		return NULL;
+	return vmalloc_exec(size);
+}
+
+/*
+ * free memory returned from module_alloc()
+ */
+void module_free(struct module *mod, void *module_region)
+{
+	vfree(module_region);
+	/* FIXME: If module_region == mod->init_region, trim exception
+	 * table entries. */
+}
+
+/*
+ * allow the arch to fix up the section table
+ * - we don't need anything special
+ */
+int module_frob_arch_sections(Elf_Ehdr *hdr,
+			      Elf_Shdr *sechdrs,
+			      char *secstrings,
+			      struct module *mod)
+{
+	return 0;
+}
+
+static uint32_t reloc_get16(uint8_t *p)
+{
+	return p[0] | (p[1] << 8);
+}
+
+static uint32_t reloc_get24(uint8_t *p)
+{
+	return reloc_get16(p) | (p[2] << 16);
+}
+
+static uint32_t reloc_get32(uint8_t *p)
+{
+	return reloc_get16(p) | (reloc_get16(p+2) << 16);
+}
+
+static void reloc_put16(uint8_t *p, uint32_t val)
+{
+	p[0] = val & 0xff;
+	p[1] = (val >> 8) & 0xff;
+}
+
+static void reloc_put24(uint8_t *p, uint32_t val)
+{
+	reloc_put16(p, val);
+	p[2] = (val >> 16) & 0xff;
+}
+
+static void reloc_put32(uint8_t *p, uint32_t val)
+{
+	reloc_put16(p, val);
+	reloc_put16(p+2, val >> 16);
+}
+
+/*
+ * apply a REL relocation
+ */
+int apply_relocate(Elf32_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	printk(KERN_ERR "module %s: RELOCATION unsupported\n",
+	       me->name);
+	return -ENOEXEC;
+}
+
+/*
+ * apply a RELA relocation
+ */
+int apply_relocate_add(Elf32_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+	unsigned int i;
+	Elf32_Rela *rel = (void *)sechdrs[relsec].sh_addr;
+	Elf32_Sym *sym;
+	Elf32_Addr relocation;
+	uint8_t *location;
+	uint32_t value;
+
+	DEBUGP("Applying relocate section %u to %u\n",
+	       relsec, sechdrs[relsec].sh_info);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* this is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+
+		/* this is the symbol the relocation is referring to (note that
+		 * all undefined symbols have been resolved by the caller) */
+		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr
+			+ ELF32_R_SYM(rel[i].r_info);
+
+		/* this is the adjustment to be made */
+		relocation = sym->st_value + rel[i].r_addend;
+
+		switch (ELF32_R_TYPE(rel[i].r_info)) {
+			/* for the first four relocation types, we add the
+			 * adjustment into the value at the location given */
+		case R_MN10300_32:
+			value = reloc_get32(location);
+			value += relocation;
+			reloc_put32(location, value);
+			break;
+		case R_MN10300_24:
+			value = reloc_get24(location);
+			value += relocation;
+			reloc_put24(location, value);
+			break;
+		case R_MN10300_16:
+			value = reloc_get16(location);
+			value += relocation;
+			reloc_put16(location, value);
+			break;
+		case R_MN10300_8:
+			*location += relocation;
+			break;
+
+			/* for the next three relocation types, we write the
+			 * adjustment with the address subtracted over the
+			 * value at the location given */
+		case R_MN10300_PCREL32:
+			value = relocation - (uint32_t) location;
+			reloc_put32(location, value);
+			break;
+		case R_MN10300_PCREL16:
+			value = relocation - (uint32_t) location;
+			reloc_put16(location, value);
+			break;
+		case R_MN10300_PCREL8:
+			*location = relocation - (uint32_t) location;
+			break;
+
+		default:
+			printk(KERN_ERR "module %s: Unknown relocation: %u\n",
+			       me->name, ELF32_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+}
+
+/*
+ * finish loading the module
+ */
+int module_finalize(const Elf_Ehdr *hdr,
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
+{
+	return 0;
+}
+
+/*
+ * finish clearing the module
+ */
+void module_arch_cleanup(struct module *mod)
+{
+}
diff -puN /dev/null arch/mn10300/kernel/process.c
--- /dev/null
+++ a/arch/mn10300/kernel/process.c
@@ -0,0 +1,301 @@
+/* MN10300  Process handling code
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/user.h>
+#include <linux/a.out.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/reboot.h>
+#include <linux/percpu.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/mmu_context.h>
+#include <asm/fpu.h>
+#include <asm/reset-regs.h>
+#include <asm/gdb-stub.h>
+
+extern asmlinkage void ret_from_fork(void);
+
+/*
+ * power management idle function, if any..
+ */
+void (*pm_idle)(void);
+EXPORT_SYMBOL(pm_idle);
+
+/*
+ * return saved PC of a blocked thread.
+ */
+unsigned long thread_saved_pc(struct task_struct *tsk)
+{
+	return ((unsigned long *) tsk->thread.sp)[3];
+}
+
+/*
+ * power off function, if any
+ */
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
+/*
+ * we use this if we don't have any better idle routine
+ */
+static void default_idle(void)
+{
+	local_irq_disable();
+	if (!need_resched())
+		safe_halt();
+	else
+		local_irq_enable();
+}
+
+/*
+ * the idle thread
+ * - there's no useful work to be done, so just try to conserve power and have
+ *   a low exit latency (ie sit in a loop waiting for somebody to say that
+ *   they'd like to reschedule)
+ */
+void cpu_idle(void)
+{
+	int cpu = smp_processor_id();
+
+	/* endless idle loop with no priority at all */
+	for (;;) {
+		while (!need_resched()) {
+			void (*idle)(void);
+
+			smp_rmb();
+			idle = pm_idle;
+			if (!idle)
+				idle = default_idle;
+
+			irq_stat[cpu].idle_timestamp = jiffies;
+			idle();
+		}
+
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
+
+void release_segments(struct mm_struct *mm)
+{
+}
+
+void machine_restart(char *cmd)
+{
+#ifdef CONFIG_GDBSTUB
+	gdbstub_exit(0);
+#endif
+
+#ifdef mn10300_unit_hard_reset
+	mn10300_unit_hard_reset();
+#else
+	mn10300_proc_hard_reset();
+#endif
+}
+
+void machine_halt(void)
+{
+#ifdef CONFIG_GDBSTUB
+	gdbstub_exit(0);
+#endif
+}
+
+void machine_power_off(void)
+{
+#ifdef CONFIG_GDBSTUB
+	gdbstub_exit(0);
+#endif
+}
+
+void show_regs(struct pt_regs * regs)
+{
+}
+
+/*
+ * create a kernel thread
+ */
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	extern asmlinkage void kernel_thread_helper(void);
+	struct pt_regs regs;
+
+	memset(&regs, 0, sizeof(regs));
+
+	regs.a2 = (unsigned long) fn;
+	regs.d2 = (unsigned long) arg;
+	regs.pc = (unsigned long) kernel_thread_helper;
+	local_save_flags(regs.epsw);
+	regs.epsw |= EPSW_IE | EPSW_IM_7;
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0,
+		       NULL, NULL);
+}
+
+EXPORT_SYMBOL(kernel_thread);
+
+/*
+ * free current thread data structures etc..
+ */
+void exit_thread(void)
+{
+	exit_fpu();
+}
+
+void flush_thread(void)
+{
+	flush_fpu();
+}
+
+void release_thread(struct task_struct *dead_task)
+{
+}
+
+/*
+ * we do not have to muck with descriptors here, that is
+ * done in switch_mm() as needed.
+ */
+void copy_segments(struct task_struct *p, struct mm_struct *new_mm)
+{
+}
+
+/*
+ * this gets called before we allocate a new thread and copy the current task
+ * into it so that we can store lazy state into memory
+ */
+void prepare_to_copy(struct task_struct *tsk)
+{
+	unlazy_fpu(tsk);
+}
+
+/*
+ * set up the kernel stack for a new thread and copy arch-specific thread
+ * control information
+ */
+int copy_thread(int nr, unsigned long clone_flags,
+		unsigned long c_usp, unsigned long ustk_size,
+		struct task_struct *p, struct pt_regs *kregs)
+{
+	struct pt_regs *c_uregs, *c_kregs, *uregs;
+	unsigned long c_ksp;
+
+	uregs = current->thread.uregs;
+
+	c_ksp = (unsigned long) task_stack_page(p) + THREAD_SIZE;
+
+	/* allocate the userspace exception frame and set it up */
+	c_ksp -= sizeof(struct pt_regs);
+	c_uregs = (struct pt_regs *) c_ksp;
+
+	p->thread.uregs = c_uregs;
+	*c_uregs = *uregs;
+	c_uregs->sp = c_usp;
+	c_uregs->epsw &= ~EPSW_FE; /* my FPU */
+
+	c_ksp -= 12; /* allocate function call ABI slack */
+
+	/* the new TLS pointer is passed in as arg #5 to sys_clone() */
+	if (clone_flags & CLONE_SETTLS)
+		c_uregs->e2 = __frame->d3;
+
+	/* set up the return kernel frame if called from kernel_thread() */
+	c_kregs = c_uregs;
+	if (kregs != uregs) {
+		c_ksp -= sizeof(struct pt_regs);
+		c_kregs = (struct pt_regs *) c_ksp;
+		*c_kregs = *kregs;
+		c_kregs->sp = c_usp;
+		c_kregs->next = c_uregs;
+#ifdef CONFIG_MN10300_CURRENT_IN_E2
+		c_kregs->e2 = (unsigned long) p; /* current */
+#endif
+
+		c_ksp -= 12; /* allocate function call ABI slack */
+	}
+
+	/* set up things up so the scheduler can start the new task */
+	p->thread.__frame = c_kregs;
+	p->thread.a3	= (unsigned long) c_kregs;
+	p->thread.sp	= c_ksp;
+	p->thread.pc	= (unsigned long) ret_from_fork;
+	p->thread.wchan	= (unsigned long) ret_from_fork;
+	p->thread.usp	= c_usp;
+
+	return 0;
+}
+
+/*
+ * clone a process
+ * - tlsptr is retrieved by copy_thread() from __frame->d3
+ */
+asmlinkage long sys_clone(unsigned long clone_flags, unsigned long newsp,
+			  int __user *parent_tidptr, int __user *child_tidptr,
+			  int __user *tlsptr)
+{
+	return do_fork(clone_flags, newsp ?: __frame->sp, __frame, 0,
+		       parent_tidptr, child_tidptr);
+}
+
+asmlinkage long sys_fork(void)
+{
+	return do_fork(SIGCHLD, __frame->sp, __frame, 0, NULL, NULL);
+}
+
+asmlinkage long sys_vfork(void)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, __frame->sp, __frame, 0,
+		       NULL, NULL);
+}
+
+asmlinkage long sys_execve(char __user *name,
+			   char __user * __user *argv,
+			   char __user * __user *envp)
+{
+	char *filename;
+	int error;
+
+	lock_kernel();
+
+	filename = getname(name);
+	error = PTR_ERR(filename);
+	if (!IS_ERR(filename)) {
+		error = do_execve(filename, argv, envp, __frame);
+		if (error == 0)
+			current->ptrace &= ~PT_DTRACE;
+
+		putname(filename);
+	}
+
+	unlock_kernel();
+	return error;
+}
+
+unsigned long get_wchan(struct task_struct *p)
+{
+	return p->thread.wchan;
+}
diff -puN /dev/null arch/mn10300/kernel/profile.c
--- /dev/null
+++ a/arch/mn10300/kernel/profile.c
@@ -0,0 +1,51 @@
+/* MN10300 Profiling setup
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+/*
+ * initialise the profiling if enabled
+ * - using with gdbstub will give anomalous results
+ * - can't be used with gdbstub if running at IRQ priority 0
+ */
+static __init int profile_init(void)
+{
+	u16 tmp;
+
+	if (!prof_buffer)
+		return 0;
+
+	/* use timer 11 to drive the profiling interrupts */
+	set_intr_stub(EXCEP_IRQ_LEVEL0, profile_handler);
+
+	/* set IRQ priority at which to run */
+	set_intr_level(TM11IRQ, GxICR_LEVEL_0);
+
+	/* set up timer 11
+	 * - source: (IOCLK 33MHz)*2 = 66MHz
+	 * - frequency: (33330000*2) / 8 / 20625 = 202Hz
+	 */
+	TM11BR = 20625 - 1;
+	TM11MD = TM8MD_SRC_IOCLK_8;
+	TM11MD |= TM8MD_INIT_COUNTER;
+	TM11MD &= ~TM8MD_INIT_COUNTER;
+	TM11MD |= TM8MD_COUNT_ENABLE;
+
+	TM11ICR |= GxICR_ENABLE;
+	tmp = TM11ICR;
+
+	printk("Profiling initiated on timer 11, priority 0, %uHz\n",
+	       mn10300_ioclk / 8 / (TM11BR + 1));
+	printk("Profile histogram stored %p-%p\n",
+	       prof_buffer, (u8 *)(prof_buffer + prof_len) - 1);
+
+	return 0;
+}
+
+__initcall(profile_init);
diff -puN /dev/null arch/mn10300/kernel/profile-low.S
--- /dev/null
+++ a/arch/mn10300/kernel/profile-low.S
@@ -0,0 +1,72 @@
+###############################################################################
+#
+# Fast profiling interrupt handler
+#
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/smp.h>
+#include <asm/intctl-regs.h>
+#include <asm/timer-regs.h>
+
+#define pi break
+
+	.balign	4
+counter:
+	.long	-1
+
+###################################################################################################
+#
+# Profiling interrupt entry point
+# - intended to run at interrupt priority 1
+#
+###################################################################################################
+ENTRY(profile_handler)
+	movm	[d2,d3,a2],(sp)
+
+	# ignore userspace
+	mov	(12,sp),d2
+	and	EPSW_nSL,d2
+	bne	out
+
+	# do nothing if there's no buffer
+	mov	(prof_buffer),a2
+	and	a2,a2
+	beq	out
+	or	0x20000000,a2
+
+	# calculate relative position in text segment
+	mov	(16,sp),d2
+	sub	_stext,d2
+	mov	(prof_shift),d3
+	lsr	d3,d2
+	mov	(prof_len),d3
+	cmp	d3,d2
+	bcc	outside_text
+
+	# increment the appropriate profile bucket
+do_inc:
+	asl2	d2
+	mov	(a2,d2),d3
+	inc	d3
+	mov	d3,(a2,d2)
+out:
+	mov	GxICR_DETECT,d2
+	movbu	d2,(TM11ICR)		# ACK the interrupt
+	movbu	(TM11ICR),d2
+	movm	(sp),[d2,d3,a2]
+	rti
+
+outside_text:
+	sub	1,d3
+	mov	d3,d2
+	bra	do_inc
diff -puN /dev/null arch/mn10300/kernel/ptrace.c
--- /dev/null
+++ a/arch/mn10300/kernel/ptrace.c
@@ -0,0 +1,369 @@
+/* MN10300 Process tracing
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/user.h>
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+#include <asm/cacheflush.h>
+#include <asm/fpu.h>
+#include <asm/asm-offsets.h>
+
+/*
+ * translate ptrace register IDs into struct pt_regs offsets
+ */
+static const u8 ptrace_regid_to_frame[] = {
+	[PT_A3 << 2]		= REG_A3,
+	[PT_A2 << 2]		= REG_A2,
+	[PT_D3 << 2]		= REG_D3,
+	[PT_D2 << 2]		= REG_D2,
+	[PT_MCVF << 2]		= REG_MCVF,
+	[PT_MCRL << 2]		= REG_MCRL,
+	[PT_MCRH << 2]		= REG_MCRH,
+	[PT_MDRQ << 2]		= REG_MDRQ,
+	[PT_E1 << 2]		= REG_E1,
+	[PT_E0 << 2]		= REG_E0,
+	[PT_E7 << 2]		= REG_E7,
+	[PT_E6 << 2]		= REG_E6,
+	[PT_E5 << 2]		= REG_E5,
+	[PT_E4 << 2]		= REG_E4,
+	[PT_E3 << 2]		= REG_E3,
+	[PT_E2 << 2]		= REG_E2,
+	[PT_SP << 2]		= REG_SP,
+	[PT_LAR << 2]		= REG_LAR,
+	[PT_LIR << 2]		= REG_LIR,
+	[PT_MDR << 2]		= REG_MDR,
+	[PT_A1 << 2]		= REG_A1,
+	[PT_A0 << 2]		= REG_A0,
+	[PT_D1 << 2]		= REG_D1,
+	[PT_D0 << 2]		= REG_D0,
+	[PT_ORIG_D0 << 2]	= REG_ORIG_D0,
+	[PT_EPSW << 2]		= REG_EPSW,
+	[PT_PC << 2]		= REG_PC,
+};
+
+static inline int get_stack_long(struct task_struct *task, int offset)
+{
+	return *(unsigned long *)
+		((unsigned long) task->thread.uregs + offset);
+}
+
+/*
+ * this routine will put a word on the processes privileged stack.
+ * the offset is how far from the base addr as stored in the TSS.
+ * this routine assumes that all the privileged stacks are in our
+ * data space.
+ */
+static inline int put_stack_long(struct task_struct *task, int offset, unsigned long data)
+{
+	unsigned long stack;
+
+	stack = (unsigned long) task->thread.uregs + offset;
+	*(unsigned long *) stack = data;
+	return 0;
+}
+
+static inline unsigned long get_fpregs(struct fpu_state_struct *buf,
+				       struct task_struct *tsk)
+{
+	return __copy_to_user(buf, &tsk->thread.fpu_state,
+			      sizeof(struct fpu_state_struct));
+}
+
+static inline unsigned long set_fpregs(struct task_struct *tsk,
+				       struct fpu_state_struct *buf)
+{
+	return __copy_from_user(&tsk->thread.fpu_state, buf,
+				sizeof(struct fpu_state_struct));
+}
+
+static inline void fpsave_init(struct task_struct *task)
+{
+	memset(&task->thread.fpu_state, 0, sizeof(struct fpu_state_struct));
+}
+
+/*
+ * make sure the single step bit is not set
+ */
+void ptrace_disable(struct task_struct *child)
+{
+#ifndef CONFIG_MN10300_USING_JTAG
+	struct user *dummy = NULL;
+	long tmp;
+
+	tmp = get_stack_long(child, (unsigned long) &dummy->regs.epsw);
+	tmp &= ~EPSW_T;
+	put_stack_long(child, (unsigned long) &dummy->regs.epsw, tmp);
+#endif
+}
+
+/*
+ * set the single step bit
+ */
+void ptrace_enable(struct task_struct *child)
+{
+#ifndef CONFIG_MN10300_USING_JTAG
+	struct user *dummy = NULL;
+	long tmp;
+
+	tmp = get_stack_long(child, (unsigned long) &dummy->regs.epsw);
+	tmp |= EPSW_T;
+	put_stack_long(child, (unsigned long) &dummy->regs.epsw, tmp);
+#endif
+}
+
+/*
+ * handle the arch-specific side of process tracing
+ */
+long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+{
+	struct fpu_state_struct fpu_state;
+	int i, ret;
+
+	switch (request) {
+	/* read the word at location addr. */
+	case PTRACE_PEEKTEXT: {
+		unsigned long tmp;
+		int copied;
+
+		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
+		ret = -EIO;
+		if (copied != sizeof(tmp))
+			break;
+		ret = put_user(tmp,(unsigned long *) data);
+		break;
+	}
+
+	/* read the word at location addr. */
+	case PTRACE_PEEKDATA: {
+		unsigned long tmp;
+		int copied;
+
+		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
+		ret = -EIO;
+		if (copied != sizeof(tmp))
+			break;
+		ret = put_user(tmp,(unsigned long *) data);
+		break;
+	}
+
+	/* read the word at location addr in the USER area. */
+	case PTRACE_PEEKUSR: {
+		unsigned long tmp;
+
+		ret = -EIO;
+		if ((addr & 3) || addr < 0 ||
+		    addr > sizeof(struct user) - 3)
+			break;
+
+		tmp = 0;  /* Default return condition */
+		if (addr < NR_PTREGS << 2)
+			tmp = get_stack_long(child, ptrace_regid_to_frame[addr]);
+		ret = put_user(tmp,(unsigned long *) data);
+		break;
+	}
+
+	/* write the word at location addr. */
+	case PTRACE_POKETEXT:
+	case PTRACE_POKEDATA:
+		if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
+			ret = 0;
+		else
+			ret = -EIO;
+		break;
+
+	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
+		ret = -EIO;
+		if ((addr & 3) || addr < 0 ||
+		    addr > sizeof(struct user) - 3)
+			break;
+
+		ret = 0;
+		if (addr < NR_PTREGS << 2)
+			ret = put_stack_long(child, ptrace_regid_to_frame[addr], data);
+		break;
+
+	case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
+	case PTRACE_CONT: /* restart after signal. */
+		ret = -EIO;
+		if ((unsigned long) data > _NSIG)
+			break;
+		if (request == PTRACE_SYSCALL)
+			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+		else
+			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+		child->exit_code = data;
+		ptrace_disable(child);
+		wake_up_process(child);
+		ret = 0;
+		break;
+
+		/*
+		 * make the child exit
+		 * - the best I can do is send it a sigkill
+		 * - perhaps it should be put in the status that it wants to
+		 *   exit
+		 */
+	case PTRACE_KILL:
+		ret = 0;
+		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
+			break;
+		child->exit_code = SIGKILL;
+		clear_tsk_thread_flag(child, TIF_SINGLESTEP);
+		ptrace_disable(child);
+		wake_up_process(child);
+		break;
+
+	case PTRACE_SINGLESTEP: /* set the trap flag. */
+#ifndef CONFIG_MN10300_USING_JTAG
+		ret = -EIO;
+		if ((unsigned long) data > _NSIG)
+			break;
+		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+		ptrace_enable(child);
+		child->exit_code = data;
+		wake_up_process(child);
+		ret = 0;
+#else
+		ret = -EINVAL;
+#endif
+		break;
+
+	case PTRACE_DETACH:	/* detach a process that was attached. */
+		ret = ptrace_detach(child, data);
+		break;
+
+		/* Get all gp regs from the child. */
+	case PTRACE_GETREGS: {
+		unsigned long tmp;
+
+	  	if (!access_ok(VERIFY_WRITE, (unsigned *) data, NR_PTREGS << 2)) {
+			ret = -EIO;
+			break;
+		}
+
+		for (i = 0; i < NR_PTREGS << 2; i += 4) {
+			tmp = get_stack_long(child, ptrace_regid_to_frame[i]);
+			__put_user(tmp, (unsigned long *) data);
+			data += sizeof(tmp);
+		}
+		ret = 0;
+		break;
+	}
+
+	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
+		unsigned long tmp;
+
+	  	if (!access_ok(VERIFY_READ, (unsigned long *)data, sizeof(struct pt_regs))) {
+			ret = -EIO;
+			break;
+		}
+
+		for (i = 0; i < NR_PTREGS << 2; i += 4) {
+			__get_user(tmp, (unsigned long *) data);
+			put_stack_long(child, ptrace_regid_to_frame[i], tmp);
+			data += sizeof(tmp);
+		}
+		ret = 0;
+		break;
+	}
+
+	case PTRACE_GETFPREGS: { /* Get the child FPU state. */
+		if (is_using_fpu(child)) {
+			unlazy_fpu(child);
+			fpu_state = child->thread.fpu_state;
+		} else {
+			memset(&fpu_state, 0, sizeof(fpu_state));
+		}
+
+		ret = -EIO;
+		if (copy_to_user((void *) data, &fpu_state, sizeof(fpu_state)) == 0)
+			ret = 0;
+		break;
+	}
+
+	case PTRACE_SETFPREGS: { /* Set the child FPU state. */
+		ret = -EFAULT;
+		if (copy_from_user(&fpu_state, (const void *) data, sizeof(fpu_state)) == 0) {
+			fpu_kill_state(child);
+			child->thread.fpu_state = fpu_state;
+			set_using_fpu(child);
+			ret = 0;
+		}
+		break;
+	}
+
+	case PTRACE_SETOPTIONS: {
+		if (data & PTRACE_O_TRACESYSGOOD)
+			child->ptrace |= PT_TRACESYSGOOD;
+		else
+			child->ptrace &= ~PT_TRACESYSGOOD;
+		ret = 0;
+		break;
+	}
+
+	default:
+		ret = -EIO;
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * notification of system call entry/exit
+ * - triggered by current->work.syscall_trace
+ */
+asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
+{
+#if 0
+	/* just in case... */
+	printk("[%d] syscall_%lu(%lx,%lx,%lx,%lx) = %lx\n",
+	       current->pid,
+	       regs->orig_d0,
+	       regs->a0,
+	       regs->d1,
+	       regs->a3,
+	       regs->a2,
+	       regs->d0);
+	return;
+#endif
+
+	if (!test_thread_flag(TIF_SYSCALL_TRACE) &&
+	    !test_thread_flag(TIF_SINGLESTEP))
+		return;
+	if (!(current->ptrace & PT_PTRACED))
+		return;
+
+	/* the 0x80 provides a way for the tracing parent to distinguish
+	   between a syscall stop and SIGTRAP delivery */
+	ptrace_notify(SIGTRAP |
+		      ((current->ptrace & PT_TRACESYSGOOD) &&
+		       !test_thread_flag(TIF_SINGLESTEP) ? 0x80 : 0));
+
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+}
diff -puN /dev/null arch/mn10300/kernel/rtc.c
--- /dev/null
+++ a/arch/mn10300/kernel/rtc.c
@@ -0,0 +1,167 @@
+/* MN10300 RTC management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/mc146818rtc.h>
+#include <linux/bcd.h>
+#include <linux/timex.h>
+#include <asm/rtc-regs.h>
+#include <asm/rtc.h>
+
+spinlock_t rtc_lock = SPIN_LOCK_UNLOCKED;
+
+EXPORT_SYMBOL(rtc_lock);
+
+static long last_rtc_update = 0;	/* last time the RTC got updated */
+static unsigned long mn10300_rtc_update_period; /* time for RTC to update itself in ioclks */
+
+/*
+ * read the current RTC time
+ */
+unsigned long __init get_initial_rtc_time(void)
+{
+	struct rtc_time tm;
+
+	get_rtc_time(&tm);
+
+	return mktime(tm.tm_year, tm.tm_mon, tm.tm_mday,
+		      tm.tm_hour, tm.tm_min, tm.tm_sec);
+}
+
+/*
+ * In order to set the CMOS clock precisely, set_rtc_mmss has to be called 500
+ * ms after the second nowtime has started, because when nowtime is written
+ * into the registers of the CMOS clock, it will jump to the next second
+ * precisely 500 ms later.  Check the Motorola MC146818A or Dallas DS12887 data
+ * sheet for details.
+ *
+ * BUG: This routine does not handle hour overflow properly; it just
+ *      sets the minutes. Usually you'll only notice that after reboot!
+ */
+static int set_rtc_mmss(unsigned long nowtime)
+{
+	unsigned char save_control, save_freq_select;
+	int retval = 0;
+	int real_seconds, real_minutes, cmos_minutes;
+
+	/* gets recalled with irq locally disabled */
+	spin_lock(&rtc_lock);
+	save_control = CMOS_READ(RTC_CONTROL); /* tell the clock it's being set */
+	CMOS_WRITE(save_control | RTC_SET, RTC_CONTROL);
+
+	save_freq_select = CMOS_READ(RTC_FREQ_SELECT); /* stop and reset prescaler */
+	CMOS_WRITE(save_freq_select | RTC_DIV_RESET2, RTC_FREQ_SELECT);
+
+	cmos_minutes = CMOS_READ(RTC_MINUTES);
+	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
+		BCD_TO_BIN(cmos_minutes);
+
+	/*
+	 * since we're only adjusting minutes and seconds,
+	 * don't interfere with hour overflow. This avoids
+	 * messing with unknown time zones but requires your
+	 * RTC not to be off by more than 15 minutes
+	 */
+	real_seconds = nowtime % 60;
+	real_minutes = nowtime / 60;
+	if (((abs(real_minutes - cmos_minutes) + 15) / 30) & 1)
+		real_minutes += 30;		/* correct for half hour time zone */
+	real_minutes %= 60;
+
+	if (abs(real_minutes - cmos_minutes) < 30) {
+		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
+			BIN_TO_BCD(real_seconds);
+			BIN_TO_BCD(real_minutes);
+		}
+		CMOS_WRITE(real_seconds,RTC_SECONDS);
+		CMOS_WRITE(real_minutes,RTC_MINUTES);
+	} else {
+		printk(KERN_WARNING
+		       "set_rtc_mmss: can't update from %d to %d\n",
+		       cmos_minutes, real_minutes);
+		retval = -1;
+	}
+
+	/* The following flags have to be released exactly in this order,
+	 * otherwise the DS12887 (popular MC146818A clone with integrated
+	 * battery and quartz) will not reset the oscillator and will not
+	 * update precisely 500 ms later. You won't find this mentioned in
+	 * the Dallas Semiconductor data sheets, but who believes data
+	 * sheets anyway ...                           -- Markus Kuhn
+	 */
+	CMOS_WRITE(save_control, RTC_CONTROL);
+	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
+	spin_unlock(&rtc_lock);
+
+	return retval;
+}
+
+void check_rtc_time(void)
+{
+	/* the RTC clock just finished ticking over again this second
+	 * - if we have an externally synchronized Linux clock, then update
+	 *   RTC clock accordingly every ~11 minutes. set_rtc_mmss() has to be
+	 *   called as close as possible to 500 ms before the new second starts.
+	 */
+	if ((time_status & STA_UNSYNC) == 0 &&
+	    xtime.tv_sec > last_rtc_update + 660 &&
+	    xtime.tv_nsec / 1000 >= 500000 - ((unsigned) TICK_SIZE) / 2 &&
+	    xtime.tv_nsec / 1000 <= 500000 + ((unsigned) TICK_SIZE) / 2
+	    ) {
+		if (set_rtc_mmss(xtime.tv_sec) == 0)
+			last_rtc_update = xtime.tv_sec;
+		else
+			last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
+	}
+}
+
+/*
+ * calibrate the TSC clock against the RTC
+ */
+void __init calibrate_clock(void)
+{
+	unsigned long count0, counth, count1;
+	unsigned char status;
+
+	/* make sure the RTC is running and is set to operate in 24hr mode */
+	status = RTSRC;
+	RTCRB |= RTCRB_SET;
+	RTCRB |= RTCRB_TM_24HR;
+	RTCRA |= RTCRA_DVR;
+	RTCRA &= ~RTCRA_DVR;
+	RTCRB &= ~RTCRB_SET;
+
+	/* work out the clock speed by counting clock cycles between ends of
+	 * the RTC update cycle - track the RTC through one complete update
+	 * cycle (1 second)
+	 */
+	startup_timestamp_counter();
+
+	while (!(RTCRA & RTCRA_UIP)) {}
+	while ((RTCRA & RTCRA_UIP)) {}
+
+	count0 = TMTSCBC;
+
+	while (!(RTCRA & RTCRA_UIP)) {}
+
+	counth = TMTSCBC;
+
+	while ((RTCRA & RTCRA_UIP)) {}
+
+	count1 = TMTSCBC;
+
+	shutdown_timestamp_counter();
+
+	MN10300_TSCCLK = count0 - count1; /* the timers count down */
+	mn10300_rtc_update_period = counth - count1;
+	MN10300_TSC_PER_HZ = MN10300_TSCCLK / HZ;
+}
diff -puN /dev/null arch/mn10300/kernel/semaphore.c
--- /dev/null
+++ a/arch/mn10300/kernel/semaphore.c
@@ -0,0 +1,152 @@
+/* MN10300 Semaphore implementation
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <asm/semaphore.h>
+
+struct sem_waiter {
+	struct list_head	list;
+	struct task_struct	*task;
+};
+
+#if SEMAPHORE_DEBUG
+void semtrace(struct semaphore *sem, const char *str)
+{
+	if (sem->debug)
+		printk("[%d] %s({%d,%d})\n",
+		       current->pid,
+		       str,
+		       atomic_read(&sem->count),
+		       list_empty(&sem->wait_list) ? 0 : 1);
+}
+#else
+#define semtrace(SEM,STR) do { } while(0)
+#endif
+
+/*
+ * wait for a token to be granted from a semaphore
+ * - entered with lock held and interrupts disabled
+ */
+void __down(struct semaphore *sem, unsigned long flags)
+{
+	struct task_struct *tsk = current;
+	struct sem_waiter waiter;
+
+	semtrace(sem, "Entering __down");
+
+	/* set up my own style of waitqueue */
+	waiter.task = tsk;
+	get_task_struct(tsk);
+
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* we don't need to touch the semaphore struct anymore */
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
+
+	/* wait to be given the semaphore */
+	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+
+	for (;;) {
+		if (!waiter.task)
+			break;
+		schedule();
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	}
+
+	tsk->state = TASK_RUNNING;
+	semtrace(sem, "Leaving __down");
+}
+
+EXPORT_SYMBOL(__down);
+
+/*
+ * interruptibly wait for a token to be granted from a semaphore
+ * - entered with lock held and interrupts disabled
+ */
+int __down_interruptible(struct semaphore *sem, unsigned long flags)
+{
+	struct task_struct *tsk = current;
+	struct sem_waiter waiter;
+	int ret;
+
+	semtrace(sem,"Entering __down_interruptible");
+
+	/* set up my own style of waitqueue */
+	waiter.task = tsk;
+	get_task_struct(tsk);
+
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* we don't need to touch the semaphore struct anymore */
+	set_task_state(tsk, TASK_INTERRUPTIBLE);
+
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
+
+	/* wait to be given the semaphore */
+	ret = 0;
+	for (;;) {
+		if (!waiter.task)
+			break;
+		if (unlikely(signal_pending(current)))
+			goto interrupted;
+		schedule();
+		set_task_state(tsk, TASK_INTERRUPTIBLE);
+	}
+
+ out:
+	tsk->state = TASK_RUNNING;
+	semtrace(sem, "Leaving __down_interruptible");
+	return ret;
+
+ interrupted:
+	spin_lock_irqsave(&sem->wait_lock, flags);
+	list_del(&waiter.list);
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
+
+	ret = 0;
+	if (!waiter.task) {
+		put_task_struct(current);
+		ret = -EINTR;
+	}
+	goto out;
+}
+
+EXPORT_SYMBOL(__down_interruptible);
+
+/*
+ * release a single token back to a semaphore
+ * - entered with lock held and interrupts disabled
+ */
+void __up(struct semaphore *sem)
+{
+	struct task_struct *tsk;
+	struct sem_waiter *waiter;
+
+	semtrace(sem,"Entering __up");
+
+	/* grant the token to the process at the front of the queue */
+	waiter = list_entry(sem->wait_list.next, struct sem_waiter, list);
+
+	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
+	 * It is an allocated on the waiter's stack and may become invalid at
+	 * any time after that point (due to a wakeup from another source).
+	 */
+	list_del_init(&waiter->list);
+	tsk = waiter->task;
+	smp_mb();
+	waiter->task = NULL;
+	wake_up_process(tsk);
+	put_task_struct(tsk);
+
+	semtrace(sem,"Leaving __up");
+}
+
+EXPORT_SYMBOL(__up);
diff -puN /dev/null arch/mn10300/kernel/setup.c
--- /dev/null
+++ a/arch/mn10300/kernel/setup.c
@@ -0,0 +1,298 @@
+/* MN10300 Arch-specific initialisation
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/user.h>
+#include <linux/a.out.h>
+#include <linux/tty.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/seq_file.h>
+#include <asm/processor.h>
+#include <linux/console.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/setup.h>
+#include <asm/io.h>
+#include <asm/smp.h>
+#include <asm/proc/proc.h>
+#include <asm/busctl-regs.h>
+#include <asm/fpu.h>
+#include <asm/sections.h>
+
+struct mn10300_cpuinfo boot_cpu_data;
+
+/* For PCI or other memory-mapped resources */
+unsigned long pci_mem_start = 0x18000000;
+
+char redboot_command_line[COMMAND_LINE_SIZE] =
+	"console=ttyS0,115200 root=/dev/mtdblock3 rw";
+
+char __initdata redboot_platform_name[COMMAND_LINE_SIZE];
+
+static struct resource code_resource = {
+	.start	= 0x100000,
+	.end	= 0,
+	.name	= "Kernel code",
+};
+
+static struct resource data_resource = {
+	.start	= 0,
+	.end	= 0,
+	.name	= "Kernel data",
+};
+
+extern int root_mountflags;
+extern unsigned long cpu_hz;
+
+static unsigned long __initdata phys_memory_base;
+static unsigned long __initdata phys_memory_end;
+static unsigned long __initdata memory_end;
+unsigned long memory_size;
+
+struct thread_info *__current_ti = &init_thread_union.thread_info;
+struct task_struct *__current = &init_task;
+
+#define mn10300_known_cpus 3
+static const char *const mn10300_cputypes[] = {
+	"am33v1",
+	"am33v2",
+	"am34v1",
+	"unknown"
+};
+
+/*
+ *
+ */
+static void __init parse_mem_cmdline(char **cmdline_p)
+{
+	char *from, *to, c;
+
+	/* save unparsed command line copy for /proc/cmdline */
+	strcpy(boot_command_line, redboot_command_line);
+
+	/* see if there's an explicit memory size option */
+	from = redboot_command_line;
+	to = redboot_command_line;
+	c = ' ';
+
+	for (;;) {
+		if (c == ' ' && !memcmp(from, "mem=", 4)) {
+			if (to != redboot_command_line)
+				to--;
+			memory_size = memparse(from + 4, &from);
+		}
+
+		c = *(from++);
+		if (!c)
+			break;
+
+		*(to++) = c;
+	}
+
+	*to = '\0';
+	*cmdline_p = redboot_command_line;
+
+	if (memory_size == 0)
+		panic("Memory size not known\n");
+
+	memory_end = (unsigned long) CONFIG_KERNEL_RAM_BASE_ADDRESS + memory_size;
+	if (memory_end > phys_memory_end)
+		memory_end = phys_memory_end;
+}
+
+/*
+ * architecture specific setup
+ */
+void __init setup_arch(char **cmdline_p)
+{
+	unsigned long bootmap_size;
+	unsigned long kstart_pfn, start_pfn, free_pfn, end_pfn;
+
+	cpu_init();
+	unit_setup();
+	parse_mem_cmdline(cmdline_p);
+
+	init_mm.start_code = (unsigned long)&_text;
+	init_mm.end_code = (unsigned long) &_etext;
+	init_mm.end_data = (unsigned long) &_edata;
+	init_mm.brk = (unsigned long) &_end;
+
+	code_resource.start = virt_to_bus(&_text);
+	code_resource.end = virt_to_bus(&_etext)-1;
+	data_resource.start = virt_to_bus(&_etext);
+	data_resource.end = virt_to_bus(&_edata)-1;
+
+#define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
+#define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
+#define PFN_PHYS(x)	((x) << PAGE_SHIFT)
+
+	start_pfn = (CONFIG_KERNEL_RAM_BASE_ADDRESS >> PAGE_SHIFT);
+	kstart_pfn = PFN_UP(__pa(&_text));
+	free_pfn = PFN_UP(__pa(&_end));
+	end_pfn = PFN_DOWN(__pa(memory_end));
+
+	bootmap_size = init_bootmem_node(&contig_page_data,
+					 free_pfn,
+					 start_pfn,
+					 end_pfn);
+
+	if (kstart_pfn > start_pfn)
+		free_bootmem(PFN_PHYS(start_pfn),
+			     PFN_PHYS(kstart_pfn - start_pfn));
+
+	free_bootmem(PFN_PHYS(free_pfn),
+		     PFN_PHYS(end_pfn - free_pfn));
+
+	/* If interrupt vector table is in main ram, then we need to
+	   reserve the page it is occupying. */
+	if (CONFIG_INTERRUPT_VECTOR_BASE >= CONFIG_KERNEL_RAM_BASE_ADDRESS &&
+	    CONFIG_INTERRUPT_VECTOR_BASE < memory_end)
+		reserve_bootmem(CONFIG_INTERRUPT_VECTOR_BASE, 1);
+
+	reserve_bootmem(PAGE_ALIGN(PFN_PHYS(free_pfn)), bootmap_size);
+
+#ifdef CONFIG_VT
+#if defined(CONFIG_VGA_CONSOLE)
+	conswitchp = &vga_con;
+#elif defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+#endif
+
+	paging_init();
+}
+
+/*
+ * perform CPU initialisation
+ */
+void __init cpu_init(void)
+{
+	unsigned long cpurev = CPUREV, type;
+	unsigned long base, size;
+
+	type = (CPUREV & CPUREV_TYPE) >> CPUREV_TYPE_S;
+	if (type > mn10300_known_cpus)
+		type = mn10300_known_cpus;
+
+	printk("Matsushita %s, rev %ld\n",
+	       mn10300_cputypes[type],
+	       (cpurev & CPUREV_REVISION) >> CPUREV_REVISION_S);
+
+	/* determine the memory size and base from the memory controller regs */
+	memory_size = 0;
+
+	base = SDBASE(0);
+	if (base & SDBASE_CE) {
+		size = (base & SDBASE_CBAM) << SDBASE_CBAM_SHIFT;
+		size = ~size + 1;
+		base &= SDBASE_CBA;
+
+		printk("SDRAM[0]: %luMb @%08lx\n", size >> 20, base);
+		memory_size += size;
+		phys_memory_base = base;
+	}
+
+	base = SDBASE(1);
+	if (base & SDBASE_CE) {
+		size = (base & SDBASE_CBAM) << SDBASE_CBAM_SHIFT;
+		size = ~size + 1;
+		base &= SDBASE_CBA;
+
+		printk("SDRAM[1]: %luMb @%08lx\n", size >> 20, base);
+		memory_size += size;
+		if (phys_memory_base == 0)
+			phys_memory_base = base;
+	}
+
+	phys_memory_end = phys_memory_base + memory_size;
+
+#ifdef CONFIG_FPU
+	fpu_init_state();
+#endif
+}
+
+/*
+ * Get CPU information for use by the procfs.
+ */
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	unsigned long cpurev = CPUREV, type, icachesz, dcachesz;
+
+	type = (CPUREV & CPUREV_TYPE) >> CPUREV_TYPE_S;
+	if (type > mn10300_known_cpus)
+		type = mn10300_known_cpus;
+
+	icachesz =
+		((cpurev & CPUREV_ICWAY ) >> CPUREV_ICWAY_S ) *
+		((cpurev & CPUREV_ICSIZE) >> CPUREV_ICSIZE_S) *
+		1024;
+
+	dcachesz =
+		((cpurev & CPUREV_DCWAY ) >> CPUREV_DCWAY_S ) *
+		((cpurev & CPUREV_DCSIZE) >> CPUREV_DCSIZE_S) *
+		1024;
+
+	seq_printf(m,
+		   "processor  : 0\n"
+		   "vendor_id  : Matsushita\n"
+		   "cpu core   : %s\n"
+		   "cpu rev    : %lu\n"
+		   "model name : " PROCESSOR_MODEL_NAME		"\n"
+		   "icache size: %lu\n"
+		   "dcache size: %lu\n",
+		   mn10300_cputypes[type],
+		   (cpurev & CPUREV_REVISION) >> CPUREV_REVISION_S,
+		   icachesz,
+		   dcachesz
+		   );
+
+	seq_printf(m,
+		   "ioclk speed: %lu.%02luMHz\n"
+		   "bogomips   : %lu.%02lu\n\n",
+		   MN10300_IOCLK / 1000000,
+		   (MN10300_IOCLK / 10000) % 100,
+		   loops_per_jiffy / (500000 / HZ),
+		   (loops_per_jiffy / (5000 / HZ)) % 100
+		   );
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	return *pos < NR_CPUS ? cpu_data + *pos : NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return c_start(m, pos);
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+struct seq_operations cpuinfo_op = {
+	start:	c_start,
+	next:	c_next,
+	stop:	c_stop,
+	show:	show_cpuinfo,
+};
diff -puN /dev/null arch/mn10300/kernel/sigframe.h
--- /dev/null
+++ a/arch/mn10300/kernel/sigframe.h
@@ -0,0 +1,33 @@
+/* MN10300 Signal frame definitions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+struct sigframe
+{
+	void (*pretcode)(void);
+	int sig;
+	struct sigcontext *psc;
+	struct sigcontext sc;
+	struct fpucontext fpuctx;
+	unsigned long extramask[_NSIG_WORDS-1];
+	char retcode[8];
+};
+
+struct rt_sigframe
+{
+	void (*pretcode)(void);
+	int sig;
+	struct siginfo *pinfo;
+	void *puc;
+	struct siginfo info;
+	struct ucontext uc;
+	struct fpucontext fpuctx;
+	char retcode[8];
+};
diff -puN /dev/null arch/mn10300/kernel/signal.c
--- /dev/null
+++ a/arch/mn10300/kernel/signal.c
@@ -0,0 +1,561 @@
+/* MN10300 Signal handling
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/ptrace.h>
+#include <linux/unistd.h>
+#include <linux/stddef.h>
+#include <linux/tty.h>
+#include <linux/personality.h>
+#include <linux/suspend.h>
+#include <asm/cacheflush.h>
+#include <asm/ucontext.h>
+#include <asm/uaccess.h>
+#include <asm/fpu.h>
+#include "sigframe.h"
+
+#define DEBUG_SIG 0
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+/*
+ * atomically swap in the new signal mask, and wait for a signal.
+ */
+asmlinkage long sys_sigsuspend(int history0, int history1, old_sigset_t mask)
+{
+	mask &= _BLOCKABLE;
+	spin_lock_irq(&current->sighand->siglock);
+	current->saved_sigmask = current->blocked;
+	siginitset(&current->blocked, mask);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	current->state = TASK_INTERRUPTIBLE;
+	schedule();
+	set_thread_flag(TIF_RESTORE_SIGMASK);
+	return -ERESTARTNOHAND;
+}
+
+/*
+ * set signal action syscall
+ */
+asmlinkage long sys_sigaction(int sig,
+			      const struct old_sigaction __user *act,
+			      struct old_sigaction __user *oact)
+{
+	struct k_sigaction new_ka, old_ka;
+	int ret;
+
+	if (act) {
+		old_sigset_t mask;
+		if (verify_area(VERIFY_READ, act, sizeof(*act)) ||
+		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
+		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
+			return -EFAULT;
+		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
+		__get_user(mask, &act->sa_mask);
+		siginitset(&new_ka.sa.sa_mask, mask);
+	}
+
+	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
+
+	if (!ret && oact) {
+		if (verify_area(VERIFY_WRITE, oact, sizeof(*oact)) ||
+		    __put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
+		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
+			return -EFAULT;
+		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
+		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
+	}
+
+	return ret;
+}
+
+/*
+ * set alternate signal stack syscall
+ */
+asmlinkage long sys_sigaltstack(const stack_t __user *uss, stack_t *uoss)
+{
+	return do_sigaltstack(uss, uoss, __frame->sp);
+}
+
+/*
+ * do a signal return; undo the signal stack.
+ */
+static int restore_sigcontext(struct pt_regs *regs,
+			      struct sigcontext __user *sc, long *_d0)
+{
+	unsigned int err = 0;
+
+	if (is_using_fpu(current))
+		fpu_kill_state(current);
+
+#define COPY(x)		err |= __get_user(regs->x, &sc->x)
+	          COPY(d1); COPY(d2); COPY(d3);
+	COPY(a0); COPY(a1); COPY(a2); COPY(a3);
+	COPY(e0); COPY(e1); COPY(e2); COPY(e3);
+	COPY(e4); COPY(e5); COPY(e6); COPY(e7);
+	COPY(lar); COPY(lir);
+	COPY(mdr); COPY(mdrq);
+	COPY(mcvf); COPY(mcrl); COPY(mcrh);
+	COPY(sp); COPY(pc);
+#undef COPY
+
+	{
+		unsigned int tmpflags;
+#ifndef CONFIG_MN10300_USING_JTAG
+#define USER_EPSW (EPSW_FLAG_Z|EPSW_FLAG_N|EPSW_FLAG_C|EPSW_FLAG_V|EPSW_T|EPSW_nAR)
+#else
+#define USER_EPSW (EPSW_FLAG_Z|EPSW_FLAG_N|EPSW_FLAG_C|EPSW_FLAG_V|EPSW_nAR)
+#endif
+		err |= __get_user(tmpflags, &sc->epsw);
+		regs->epsw = (regs->epsw & ~USER_EPSW) |
+		  (tmpflags & USER_EPSW);
+		regs->orig_d0 = -1;		/* disable syscall checks */
+	}
+
+	{
+		struct fpucontext * buf;
+		err |= __get_user(buf, &sc->fpucontext);
+		if (buf) {
+			if (verify_area(VERIFY_READ, buf, sizeof(*buf)))
+				goto badframe;
+			err |= fpu_restore_sigcontext(buf);
+		}
+	}
+
+	err |= __get_user(*_d0, &sc->d0);
+	return err;
+
+badframe:
+	return 1;
+}
+
+/*
+ * standard signal return syscall
+ */
+asmlinkage long sys_sigreturn(void)
+{
+	struct sigframe __user *frame = (struct sigframe __user *) __frame->sp;
+	sigset_t set;
+	long d0;
+
+	if (verify_area(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__get_user(set.sig[0], &frame->sc.oldmask))
+		goto badframe;
+
+	if (_NSIG_WORDS > 1 &&
+	    __copy_from_user(&set.sig[1], &frame->extramask, sizeof(frame->extramask)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(__frame, &frame->sc, &d0))
+		goto badframe;
+
+	return d0;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+/*
+ * realtime signal return syscall
+ */
+asmlinkage long sys_rt_sigreturn(void)
+{
+	struct rt_sigframe __user *frame =
+		(struct rt_sigframe __user *) __frame->sp;
+	sigset_t set;
+	unsigned long d0;
+
+	if (verify_area(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(__frame, &frame->uc.uc_mcontext, &d0))
+		goto badframe;
+
+	if (do_sigaltstack(&frame->uc.uc_stack, NULL, __frame->sp) == -EFAULT)
+		goto badframe;
+
+	return d0;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+/*
+ * store the userspace context into a signal frame
+ */
+static int setup_sigcontext(struct sigcontext __user *sc,
+			    struct fpucontext *fpuctx,
+			    struct pt_regs *regs,
+			    unsigned long mask)
+{
+	int tmp, err = 0;
+
+#define COPY(x) err |= __put_user(regs->x, &sc->x)
+	COPY(d0); COPY(d1); COPY(d2); COPY(d3);
+	COPY(a0); COPY(a1); COPY(a2); COPY(a3);
+	COPY(e0); COPY(e1); COPY(e2); COPY(e3);
+	COPY(e4); COPY(e5); COPY(e6); COPY(e7);
+	COPY(lar); COPY(lir);
+	COPY(mdr); COPY(mdrq);
+	COPY(mcvf); COPY(mcrl); COPY(mcrh);
+	COPY(sp); COPY(epsw); COPY(pc);
+#undef COPY
+
+	tmp = fpu_setup_sigcontext(fpuctx);
+	if (tmp < 0)
+		err = 1;
+	else
+		err |= __put_user(tmp ? fpuctx : NULL, &sc->fpucontext);
+
+	/* non-iBCS2 extensions.. */
+	err |= __put_user(mask, &sc->oldmask);
+
+	return err;
+}
+
+/*
+ * determine which stack to use..
+ */
+static inline void __user *get_sigframe(struct k_sigaction *ka,
+					struct pt_regs *regs,
+					size_t frame_size)
+{
+	unsigned long sp;
+
+	/* default to using normal stack */
+	sp = regs->sp;
+
+	/* this is the X/Open sanctioned signal stack switching.  */
+	if (ka->sa.sa_flags & SA_ONSTACK) {
+		if (! on_sig_stack(sp))
+			sp = current->sas_ss_sp + current->sas_ss_size;
+	}
+
+	return (void __user *) ((sp - frame_size) & ~7UL);
+}
+
+/*
+ * set up a normal signal frame
+ */
+static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
+		       struct pt_regs *regs)
+{
+	struct sigframe __user *frame;
+	int rsig;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto give_sigsegv;
+
+	rsig = sig;
+	if (sig < 32 &&
+	    current_thread_info()->exec_domain &&
+	    current_thread_info()->exec_domain->signal_invmap)
+		rsig = current_thread_info()->exec_domain->signal_invmap[sig];
+
+	if (__put_user(rsig, &frame->sig) < 0 ||
+	    __put_user(&frame->sc, &frame->psc) < 0)
+		goto give_sigsegv;
+
+	if (setup_sigcontext(&frame->sc, &frame->fpuctx, regs, set->sig[0]))
+		goto give_sigsegv;
+
+	if (_NSIG_WORDS > 1) {
+		if (__copy_to_user(frame->extramask, &set->sig[1],
+				   sizeof(frame->extramask)))
+			goto give_sigsegv;
+	}
+
+	/* set up to return from userspace.  If provided, use a stub already in
+	 * userspace */
+	if (ka->sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ka->sa.sa_restorer, &frame->pretcode))
+			goto give_sigsegv;
+	} else {
+		if (__put_user((void (*)(void))frame->retcode,
+			       &frame->pretcode))
+			goto give_sigsegv;
+		/* this is mov $,d0; syscall 0 */
+		if (__put_user(0x2c, (char *)(frame->retcode + 0)) ||
+		    __put_user(__NR_sigreturn, (char *)(frame->retcode + 1)) ||
+		    __put_user(0x00, (char *)(frame->retcode + 2)) ||
+		    __put_user(0xf0, (char *)(frame->retcode + 3)) ||
+		    __put_user(0xe0, (char *)(frame->retcode + 4)))
+			goto give_sigsegv;
+		flush_icache_range((unsigned long) frame->retcode,
+				   (unsigned long) frame->retcode + 5);
+	}
+
+	/* set up registers for signal handler */
+	regs->sp = (unsigned long) frame;
+	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->d0 = sig;
+	regs->d1 = (unsigned long) &frame->sc;
+
+	set_fs(USER_DS);
+
+	/* the tracer may want to single-step inside the handler */
+	if (test_thread_flag(TIF_SINGLESTEP))
+		ptrace_notify(SIGTRAP);
+
+#if DEBUG_SIG
+	printk("SIG deliver %d (%s:%d): sp=%p pc=%lx ra=%p\n",
+		sig, current->comm, current->pid, frame, regs->pc,
+	       frame->pretcode);
+#endif
+
+	return 0;
+
+give_sigsegv:
+	force_sig(SIGSEGV, current);
+	return -EFAULT;
+}
+
+/*
+ * set up a realtime signal frame
+ */
+static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			  sigset_t *set, struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	int rsig;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto give_sigsegv;
+
+	rsig = sig;
+	if (sig < 32 &&
+	    current_thread_info()->exec_domain &&
+	    current_thread_info()->exec_domain->signal_invmap)
+		rsig = current_thread_info()->exec_domain->signal_invmap[sig];
+
+	if (__put_user(rsig, &frame->sig) ||
+	    __put_user(&frame->info, &frame->pinfo) ||
+	    __put_user(&frame->uc, &frame->puc) ||
+	    copy_siginfo_to_user(&frame->info, info))
+		goto give_sigsegv;
+
+	/* create the ucontext.  */
+	if (__put_user(0, &frame->uc.uc_flags) ||
+	    __put_user(0, &frame->uc.uc_link) ||
+	    __put_user((void*)current->sas_ss_sp, &frame->uc.uc_stack.ss_sp) ||
+	    __put_user(sas_ss_flags(regs->sp), &frame->uc.uc_stack.ss_flags) ||
+	    __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size) ||
+	    setup_sigcontext(&frame->uc.uc_mcontext,
+			     &frame->fpuctx, regs, set->sig[0]) ||
+	    __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set)))
+		goto give_sigsegv;
+
+	/* set up to return from userspace.  If provided, use a stub already in
+	 * userspace */
+	if (ka->sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ka->sa.sa_restorer, &frame->pretcode))
+			goto give_sigsegv;
+	} else {
+		if (__put_user((void(*)(void))frame->retcode,
+			       &frame->pretcode) ||
+		    /* This is mov $,d0; syscall 0 */
+		    __put_user(0x2c, (char *)(frame->retcode + 0)) ||
+		    __put_user(__NR_rt_sigreturn,
+			       (char *)(frame->retcode + 1)) ||
+		    __put_user(0x00, (char *)(frame->retcode + 2)) ||
+		    __put_user(0xf0, (char *)(frame->retcode + 3)) ||
+		    __put_user(0xe0, (char *)(frame->retcode + 4)))
+			goto give_sigsegv;
+
+		flush_icache_range((u_long) frame->retcode,
+				   (u_long) frame->retcode + 5);
+	}
+
+	/* Set up registers for signal handler */
+	regs->sp = (unsigned long) frame;
+	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->d0 = sig;
+	regs->d1 = (long) &frame->info;
+
+	set_fs(USER_DS);
+
+	/* the tracer may want to single-step inside the handler */
+	if (test_thread_flag(TIF_SINGLESTEP))
+		ptrace_notify(SIGTRAP);
+
+#if DEBUG_SIG
+	printk("SIG deliver %d (%s:%d): sp=%p pc=%lx ra=%p\n",
+	       sig, current->comm, current->pid, frame, regs->pc,
+	       frame->pretcode);
+#endif
+
+	return 0;
+
+give_sigsegv:
+	force_sig(SIGSEGV, current);
+	return -EFAULT;
+}
+
+/*
+ * handle the actual delivery of a signal to userspace
+ */
+static int handle_signal(int sig,
+			 siginfo_t *info, struct k_sigaction *ka,
+			 sigset_t *oldset, struct pt_regs *regs)
+{
+	int ret;
+
+	/* Are we from a system call? */
+	if (regs->orig_d0 >= 0) {
+		/* If so, check system call restarting.. */
+		switch (regs->d0) {
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			regs->d0 = -EINTR;
+			break;
+
+		case -ERESTARTSYS:
+			if (!(ka->sa.sa_flags & SA_RESTART)) {
+				regs->d0 = -EINTR;
+				break;
+			}
+
+			/* fallthrough */
+		case -ERESTARTNOINTR:
+			regs->d0 = regs->orig_d0;
+			regs->pc -= 2;
+		}
+	}
+
+	/* Set up the stack frame */
+	if (ka->sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	else
+		ret = setup_frame(sig, ka, oldset, regs);
+
+	if (ret == 0) {
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked, &current->blocked,
+			  &ka->sa.sa_mask);
+		if (!(ka->sa.sa_flags & SA_NODEFER))
+			sigaddset(&current->blocked, sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
+
+	return ret;
+}
+
+/*
+ * handle a potential signal
+ */
+static void do_signal(struct pt_regs *regs)
+{
+	struct k_sigaction ka;
+	siginfo_t info;
+	sigset_t *oldset;
+	int signr;
+
+	/* we want the common case to go fast, which is why we may in certain
+	 * cases get here from kernel mode */
+	if (!user_mode(regs))
+		return;
+
+	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		oldset = &current->saved_sigmask;
+	else
+		oldset = &current->blocked;
+
+	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+	if (signr > 0) {
+		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
+			/* a signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TIF_RESTORE_SIGMASK flag */
+			if (test_thread_flag(TIF_RESTORE_SIGMASK))
+				clear_thread_flag(TIF_RESTORE_SIGMASK);
+		}
+
+		return;
+	}
+
+	/* did we come from a system call? */
+	if (regs->orig_d0 >= 0) {
+		/* restart the system call - no handlers present */
+		switch (regs->d0) {
+		case -ERESTARTNOHAND:
+		case -ERESTARTSYS:
+		case -ERESTARTNOINTR:
+			regs->d0 = regs->orig_d0;
+			regs->pc -= 2;
+			break;
+
+		case -ERESTART_RESTARTBLOCK:
+			regs->d0 = __NR_restart_syscall;
+			regs->pc -= 2;
+			break;
+		}
+	}
+
+	/* if there's no signal to deliver, we just put the saved sigmask
+	 * back */
+	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
+}
+
+/*
+ * notification of userspace execution resumption
+ * - triggered by current->work.notify_resume
+ */
+asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
+{
+	/* Pending single-step? */
+	if (thread_info_flags & _TIF_SINGLESTEP) {
+#ifndef CONFIG_MN10300_USING_JTAG
+		regs->epsw |= EPSW_T;
+		clear_thread_flag(TIF_SINGLESTEP);
+#else
+		BUG(); /* no h/w single-step if using JTAG unit */
+#endif
+	}
+
+	/* deal with pending signal delivery */
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
+		do_signal(regs);
+}
diff -puN /dev/null arch/mn10300/kernel/switch_to.S
--- /dev/null
+++ a/arch/mn10300/kernel/switch_to.S
@@ -0,0 +1,71 @@
+###############################################################################
+#
+# MN10300 Context switch operation
+#
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/thread_info.h>
+#include <asm/cpu-regs.h>
+
+	.text
+
+###############################################################################
+#
+# struct task_struct *__switch_to(struct thread_struct *prev,
+#				  struct thread_struct *next,
+#				  struct task_struct *prev_task)
+#
+###############################################################################
+ENTRY(__switch_to)
+	movm	[d2,d3,a2,a3,exreg1],(sp)
+	or	EPSW_NMID,epsw
+
+	mov	(44,sp),d2
+
+	mov	d0,a0
+	mov	d1,a1
+
+	# save prev context
+	mov	(__frame),d0
+	mov	d0,(THREAD_FRAME,a0)
+	mov	__switch_back,d0
+	mov	d0,(THREAD_PC,a0)
+	mov	sp,a2
+	mov	a2,(THREAD_SP,a0)
+	mov	a3,(THREAD_A3,a0)
+
+	mov	(THREAD_A3,a1),a3
+	mov	(THREAD_SP,a1),a2
+
+	# switch
+	mov	a2,sp
+
+	# load next context
+	GET_THREAD_INFO a2
+	mov	a2,(__current_ti)
+	mov	(TI_task,a2),a2
+	mov	a2,(__current)
+#ifdef CONFIG_MN10300_CURRENT_IN_E2
+	mov	a2,e2
+#endif
+
+	mov	(THREAD_FRAME,a1),a2
+	mov	a2,(__frame)
+	mov	(THREAD_PC,a1),a2
+	mov	d2,d0			# for ret_from_fork
+	mov	d0,a0			# for __switch_to
+
+	jmp	(a2)
+
+__switch_back:
+	and	~EPSW_NMID,epsw
+	ret	[d2,d3,a2,a3,exreg1],32
diff -puN /dev/null arch/mn10300/kernel/sys_mn10300.c
--- /dev/null
+++ a/arch/mn10300/kernel/sys_mn10300.c
@@ -0,0 +1,191 @@
+/* MN10300 Weird system calls
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/syscalls.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/sem.h>
+#include <linux/msg.h>
+#include <linux/shm.h>
+#include <linux/stat.h>
+#include <linux/mman.h>
+#include <linux/file.h>
+#include <linux/utsname.h>
+#include <linux/syscalls.h>
+#include <linux/tty.h>
+
+#include <asm/uaccess.h>
+
+#define MIN_MAP_ADDR	PAGE_SIZE	/* minimum fixed mmap address */
+
+/*
+ * sys_pipe() is the normal C calling standard for creating
+ * a pipe. It's not the way Unix traditionally does this, though.
+ */
+asmlinkage long sys_pipe(unsigned long __user *fildes)
+{
+	int fd[2];
+	int error;
+
+	error = do_pipe(fd);
+	if (!error) {
+		if (copy_to_user(fildes, fd, 2 * sizeof(int)))
+			error = -EFAULT;
+	}
+	return error;
+}
+
+/*
+ * memory mapping syscall
+ */
+asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
+			  unsigned long prot, unsigned long flags,
+			  unsigned long fd, unsigned long pgoff)
+{
+	struct file * file = NULL;
+	long error = -EINVAL;
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+
+	if (flags & MAP_FIXED && addr < MIN_MAP_ADDR)
+		goto out;
+
+	error = -EBADF;
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file)
+			goto out;
+	}
+
+	down_write(&current->mm->mmap_sem);
+	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+
+	if (file)
+		fput(file);
+out:
+	return error;
+}
+
+asmlinkage long old_mmap(unsigned long addr, unsigned long len,
+			 unsigned long prot, unsigned long flags,
+			 unsigned long fd, unsigned long offset)
+{
+	if (offset & ~PAGE_MASK)
+		return -EINVAL;
+	return sys_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+}
+
+struct sel_arg_struct {
+	unsigned long n;
+	fd_set *inp, *outp, *exp;
+	struct timeval *tvp;
+};
+
+asmlinkage int old_select(struct sel_arg_struct __user *arg)
+{
+	struct sel_arg_struct a;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+	/* sys_select() does the appropriate kernel locking */
+	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
+}
+
+/*
+ * sys_ipc() is the de-multiplexer for the SysV IPC calls..
+ *
+ * This is really horribly ugly.
+ */
+asmlinkage long sys_ipc(uint call, int first, int second,
+			int third, void __user *ptr, long fifth)
+{
+	int version, ret;
+
+	version = call >> 16; /* hack for backward compatibility */
+	call &= 0xffff;
+
+	switch (call) {
+	case SEMOP:
+		return sys_semtimedop(first, (struct sembuf __user *)ptr,
+				      second, NULL);
+	case SEMTIMEDOP:
+		return sys_semtimedop(first, (struct sembuf __user *)ptr,
+				      second,
+				      (const struct timespec __user *)fifth);
+	case SEMGET:
+		return sys_semget(first, second, third);
+	case SEMCTL: {
+		union semun fourth;
+		if (!ptr)
+			return -EINVAL;
+		if (get_user(fourth.__pad, (void __user * __user *) ptr))
+			return -EFAULT;
+		return sys_semctl(first, second, third, fourth);
+	}
+
+	case MSGSND:
+		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
+				  second, third);
+	case MSGRCV:
+		switch (version) {
+		case 0: {
+			struct ipc_kludge tmp;
+			if (!ptr)
+				return -EINVAL;
+
+			if (copy_from_user(&tmp,
+					   (struct ipc_kludge __user *) ptr,
+					   sizeof (tmp)))
+				return -EFAULT;
+			return sys_msgrcv(first, tmp.msgp, second,
+					  tmp.msgtyp, third);
+		}
+		default:
+			return sys_msgrcv(first,
+					  (struct msgbuf __user *) ptr,
+					   second, fifth, third);
+		}
+	case MSGGET:
+		return sys_msgget((key_t) first, second);
+	case MSGCTL:
+		return sys_msgctl(first, second,
+				   (struct msqid_ds __user *) ptr);
+
+	case SHMAT:
+		switch (version) {
+		default: {
+			ulong raddr;
+			ret = do_shmat(first, (char __user *) ptr, second,
+				       &raddr);
+			if (ret)
+				return ret;
+			return put_user(raddr, (ulong *) third);
+		}
+		case 1:	/* iBCS2 emulator entry point */
+			if (!segment_eq(get_fs(), get_ds()))
+				return -EINVAL;
+			return do_shmat(first, (char __user *) ptr, second,
+					(ulong *) third);
+		}
+	case SHMDT:
+		return sys_shmdt((char __user *)ptr);
+	case SHMGET:
+		return sys_shmget(first, second, third);
+	case SHMCTL:
+		return sys_shmctl(first, second,
+				  (struct shmid_ds __user *) ptr);
+	default:
+		return -EINVAL;
+	}
+}
diff -puN /dev/null arch/mn10300/kernel/time.c
--- /dev/null
+++ a/arch/mn10300/kernel/time.c
@@ -0,0 +1,127 @@
+/* MN10300 Low level time management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from arch/i386/kernel/time.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/time.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/profile.h>
+#include <asm/irq.h>
+#include <asm/div64.h>
+#include <asm/processor.h>
+#include <asm/intctl-regs.h>
+#include <asm/rtc.h>
+
+#ifdef CONFIG_MN10300_RTC
+unsigned long mn10300_ioclk;		/* system I/O clock frequency */
+unsigned long mn10300_iobclk;		/* system I/O clock frequency */
+unsigned long mn10300_tsc_per_HZ;	/* number of ioclks per jiffy */
+#endif /* CONFIG_MN10300_RTC */
+
+static unsigned long mn10300_last_tsc;	/* time-stamp counter at last time
+					 * interrupt occurred */
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id);
+
+static struct irqaction timer_irq = {
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER,
+	.mask		= CPU_MASK_NONE,
+	.name		= "timer",
+};
+
+/*
+ * scheduler clock - returns current time in nanosec units.
+ */
+unsigned long long sched_clock(void)
+{
+	union {
+		unsigned long long l;
+		u32 w[2];
+	} quot;
+
+	quot.w[0] = mn10300_last_tsc - get_cycles();
+	quot.w[1] = 1000000000;
+
+	asm("mulu %2,%3,%0,%1"
+	    : "=r"(quot.w[1]), "=r"(quot.w[0])
+	    : "0"(quot.w[1]), "1"(quot.w[0])
+	    : "cc");
+
+	do_div(quot.l, MN10300_TSCCLK);
+
+	return quot.l;
+}
+
+/*
+ * advance the kernel's time keeping clocks (xtime and jiffies)
+ * - we use Timer 0 & 1 cascaded as a clock to nudge us the next time
+ *   there's a need to update
+ */
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	unsigned tsc, elapse;
+
+	write_seqlock(&xtime_lock);
+
+	while (tsc = get_cycles(),
+	       elapse = mn10300_last_tsc - tsc, /* time elapsed since last tick */
+	       elapse > MN10300_TSC_PER_HZ
+	       ) {
+		mn10300_last_tsc -= MN10300_TSC_PER_HZ;
+
+		/* advance the kernel's time tracking system */
+		profile_tick(CPU_PROFILING);
+		do_timer(1);
+		update_process_times(user_mode(get_irq_regs()));
+		check_rtc_time();
+	}
+
+	write_sequnlock(&xtime_lock);
+	return IRQ_HANDLED;
+}
+
+/*
+ * initialise the various timers used by the main part of the kernel
+ */
+void __init time_init(void)
+{
+	/* we need the prescalar running to be able to use IOCLK/8
+	 * - IOCLK runs at 1/4 (ST5 open) or 1/8 (ST5 closed) internal CPU clock
+	 * - IOCLK runs at Fosc rate (crystal speed)
+	 */
+	TMPSCNT |= TMPSCNT_ENABLE;
+
+	startup_timestamp_counter();
+
+	printk("timestamp counter I/O clock running at %lu.%02lu"
+	       " (calibrated against RTC)\n",
+	       MN10300_TSCCLK / 1000000, (MN10300_TSCCLK / 10000) % 100);
+
+	xtime.tv_sec = get_initial_rtc_time();
+	xtime.tv_nsec = 0;
+
+	mn10300_last_tsc = TMTSCBC;
+
+	/* use timer 0 & 1 cascaded to tick at as close to HZ as possible */
+	setup_irq(TMJCIRQ, &timer_irq);
+
+	set_intr_level(TMJCIRQ, TMJCICR_LEVEL);
+
+	startup_jiffies_counter();
+
+#ifdef CONFIG_MN10300_WD_TIMER
+	/* start the watchdog timer */
+	watchdog_go();
+#endif
+}
diff -puN /dev/null arch/mn10300/kernel/traps.c
--- /dev/null
+++ a/arch/mn10300/kernel/traps.c
@@ -0,0 +1,618 @@
+/* MN10300 Exception handling
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/timer.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/kallsyms.h>
+#include <linux/pci.h>
+#include <linux/kdebug.h>
+#include <linux/bug.h>
+#include <linux/irq.h>
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+#include <asm/io.h>
+#include <asm/atomic.h>
+#include <asm/smp.h>
+#include <asm/pgalloc.h>
+#include <asm/cacheflush.h>
+#include <asm/cpu-regs.h>
+#include <asm/busctl-regs.h>
+#include <asm/unit/leds.h>
+#include <asm/fpu.h>
+#include <asm/gdb-stub.h>
+#include <asm/sections.h>
+
+#if (CONFIG_INTERRUPT_VECTOR_BASE & 0xffffff)
+#error "INTERRUPT_VECTOR_BASE not aligned to 16MiB boundary!"
+#endif
+
+struct pt_regs *__frame; /* current frame pointer */
+EXPORT_SYMBOL(__frame);
+
+int kstack_depth_to_print = 24;
+
+spinlock_t die_lock = SPIN_LOCK_UNLOCKED;
+
+ATOMIC_NOTIFIER_HEAD(mn10300_die_chain);
+
+/*
+ * These constants are for searching for possible module text
+ * segments. MODULE_RANGE is a guess of how much space is likely
+ * to be vmalloced.
+ */
+#define MODULE_RANGE (8 * 1024 * 1024)
+
+#define DO_ERROR(signr, prologue, str, name)			\
+asmlinkage void name(struct pt_regs *regs, u32 intcode)		\
+{								\
+	prologue;						\
+	if (die_if_no_fixup(str, regs, intcode))		\
+		return;						\
+	force_sig(signr, current);				\
+}
+
+#define DO_EINFO(signr, prologue, str, name, sicode)			\
+asmlinkage void name(struct pt_regs *regs, u32 intcode)			\
+{									\
+	siginfo_t info;							\
+	prologue;							\
+	if (die_if_no_fixup(str, regs, intcode))			\
+		return;							\
+	info.si_signo = signr;						\
+	if (signr == SIGILL && sicode == ILL_ILLOPC) {			\
+ 		uint8_t opcode;						\
+		if (get_user(opcode, (uint8_t __user *)regs->pc) == 0)	\
+			if (opcode == 0xff)				\
+				info.si_signo = SIGTRAP;		\
+	}								\
+	info.si_errno = 0;						\
+	info.si_code = sicode;						\
+	info.si_addr = (void *) regs->pc;				\
+	force_sig_info(info.si_signo, &info, current);			\
+}
+
+DO_ERROR(SIGTRAP, {}, "trap",			trap);
+DO_ERROR(SIGSEGV, {}, "ibreak",			ibreak);
+DO_ERROR(SIGSEGV, {}, "obreak",			obreak);
+DO_EINFO(SIGSEGV, {}, "access error",		access_error,	SEGV_ACCERR);
+DO_EINFO(SIGSEGV, {}, "insn access error",	insn_acc_error,	SEGV_ACCERR);
+DO_EINFO(SIGSEGV, {}, "data access error",	data_acc_error,	SEGV_ACCERR);
+DO_EINFO(SIGILL,  {}, "privileged opcode",	priv_op,	ILL_PRVOPC);
+DO_EINFO(SIGILL,  {}, "invalid opcode",		invalid_op,	ILL_ILLOPC);
+DO_EINFO(SIGILL,  {}, "invalid ex opcode",	invalid_exop,	ILL_ILLOPC);
+DO_EINFO(SIGBUS,  {}, "invalid address",	mem_error,	BUS_ADRERR);
+DO_EINFO(SIGBUS,  {}, "bus error",		bus_error,	BUS_ADRERR);
+DO_EINFO(SIGILL,  {}, "FPU invalid opcode", 	fpu_invalid_op,	ILL_COPROC);
+
+DO_ERROR(SIGTRAP,
+#ifndef CONFIG_MN10300_USING_JTAG
+	 DCR &= ~0x0001,
+#else
+	 {},
+#endif
+	 "single step", istep);
+
+/*
+ * handle NMI
+ */
+asmlinkage void nmi(struct pt_regs *regs, exception_code_t code)
+{
+	/* see if gdbstub wants to deal with it */
+#ifdef CONFIG_GDBSTUB
+	if (gdbstub_intercept(regs, code))
+		return;
+#endif
+
+	printk("--- Register Dump ---\n");
+	show_registers(regs);
+	printk("---------------------\n");
+}
+
+/*
+ * show a stack trace from the specified stack pointer
+ */
+void show_trace(unsigned long *sp)
+{
+	unsigned long *stack, addr, module_start, module_end;
+	int i;
+
+	printk("\nCall Trace:");
+
+	stack = sp;
+	i = 0;
+	module_start = VMALLOC_START;
+	module_end = VMALLOC_END;
+
+	while (((long) stack & (THREAD_SIZE - 1)) != 0) {
+		addr = *stack++;
+		if (__kernel_text_address(addr)) {
+#if 1
+			printk(" [<%08lx>]", addr);
+			print_symbol(" %s", addr);
+			printk("\n");
+#else
+			if ((i % 6) == 0)
+				printk("\n  ");
+			printk("[<%08lx>] ", addr);
+			i++;
+#endif
+		}
+	}
+
+	printk("\n");
+}
+
+/*
+ * show the raw stack from the specified stack pointer
+ */
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	unsigned long *stack;
+	int i;
+
+	// debugging aid: "show_stack(NULL);" prints the
+	// back trace for this cpu.
+
+	if (!sp)
+		sp = (unsigned long *) &sp;
+
+	stack = sp;
+	printk("Stack:");
+	for (i = 0; i < kstack_depth_to_print; i++) {
+		if (((long) stack & (THREAD_SIZE - 1)) == 0)
+			break;
+		if ((i % 8) == 0)
+			printk("\n  ");
+		printk("%08lx ", *stack++);
+	}
+
+	show_trace(sp);
+}
+
+/*
+ * the architecture-independent dump_stack generator
+ */
+void dump_stack(void)
+{
+	unsigned long stack;
+
+	show_stack(current, &stack);
+}
+
+EXPORT_SYMBOL(dump_stack);
+
+/*
+ * dump the register file in the specified exception frame
+ */
+void show_registers_only(struct pt_regs *regs)
+{
+	unsigned long ssp;
+
+	ssp = (unsigned long) regs + sizeof(*regs);
+
+	printk("PC:  %08lx EPSW:  %08lx  SSP: %08lx mode: %s\n",
+	       regs->pc, regs->epsw, ssp, user_mode(regs) ? "User" : "Super");
+	printk("d0:  %08lx   d1:  %08lx   d2: %08lx   d3: %08lx\n",
+	       regs->d0, regs->d1, regs->d2, regs->d3);
+	printk("a0:  %08lx   a1:  %08lx   a2: %08lx   a3: %08lx\n",
+	       regs->a0, regs->a1, regs->a2, regs->a3);
+	printk("e0:  %08lx   e1:  %08lx   e2: %08lx   e3: %08lx\n",
+	       regs->e0, regs->e1, regs->e2, regs->e3);
+	printk("e4:  %08lx   e5:  %08lx   e6: %08lx   e7: %08lx\n",
+	       regs->e4, regs->e5, regs->e6, regs->e7);
+	printk("lar: %08lx   lir: %08lx  mdr: %08lx  usp: %08lx\n",
+	       regs->lar, regs->lir, regs->mdr, regs->sp);
+	printk("cvf: %08lx   crl: %08lx  crh: %08lx  drq: %08lx\n",
+	       regs->mcvf, regs->mcrl, regs->mcrh, regs->mdrq);
+	printk("threadinfo=%p task=%p)\n",
+	       current_thread_info(), current);
+
+	if ((unsigned long) current >= 0x90000000UL &&
+	    (unsigned long) current < 0x94000000UL)
+		printk("Process %s (pid: %d)\n",
+		       current->comm, current->pid);
+
+	printk("CPUP:   %04hx\n", CPUP);
+	printk("TBR:    %08x\n", TBR);
+	printk("DEAR:   %08x\n", DEAR);
+	printk("sISR:   %08x\n", sISR);
+	printk("NMICR:  %04hx\n", NMICR);
+	printk("BCBERR: %08x\n", BCBERR);
+	printk("BCBEAR: %08x\n", BCBEAR);
+	printk("MMUFCR: %08x\n", MMUFCR);
+	printk("IPTEU : %08x  IPTEL2: %08x\n", IPTEU, IPTEL2);
+	printk("DPTEU:  %08x  DPTEL2: %08x\n", DPTEU, DPTEL2);
+}
+
+/*
+ * dump the registers and the stack
+ */
+void show_registers(struct pt_regs *regs)
+{
+	unsigned long sp;
+	int i;
+
+	show_registers_only(regs);
+
+	if (!user_mode(regs))
+		sp = (unsigned long) regs + sizeof(*regs);
+	else
+		sp = regs->sp;
+
+	/* when in-kernel, we also print out the stack and code at the
+	 * time of the fault..
+	 */
+	if (!user_mode(regs)) {
+		printk("\n");
+		show_stack(current, (unsigned long *) sp);
+
+#if 0
+		printk("\nCode: ");
+		if (regs->pc < PAGE_OFFSET)
+			goto bad;
+
+		for(i = 0; i < 20; i++) {
+			unsigned char c;
+			if (__get_user(c, &((unsigned char *) regs->pc)[i]))
+				goto bad;
+			printk("%02x ", c);
+		}
+#else
+		i = 0;
+#endif
+	}
+
+	printk("\n");
+	return;
+
+#if 0
+bad:
+	printk(" Bad PC value.");
+	break;
+#endif
+}
+
+/*
+ *
+ */
+void show_trace_task(struct task_struct *tsk)
+{
+	unsigned long sp = tsk->thread.sp;
+
+	/* User space on another CPU? */
+	if ((sp ^ (unsigned long) tsk) & (PAGE_MASK << 1))
+		return;
+
+	show_trace((unsigned long *) sp);
+}
+
+/*
+ * note the untimely death of part of the kernel
+ */
+void die(const char *str, struct pt_regs *regs, exception_code_t code)
+{
+	console_verbose();
+	spin_lock_irq(&die_lock);
+	printk("\n%s: %04x\n", str, code & 0xffff);
+	show_registers(regs);
+
+	if (regs->pc >= 0x02000000 && regs->pc < 0x04000000 &&
+            (regs->epsw & (EPSW_IM | EPSW_IE)) != (EPSW_IM | EPSW_IE)) {
+		printk ("Exception in usermode interrupt handler\n");
+		printk ("\n  Please connect to kernel debugger !!\n");
+		asm volatile ("0: bra 0b");
+	}
+
+	spin_unlock_irq(&die_lock);
+	do_exit(SIGSEGV);
+}
+
+/*
+ * see if there's a fixup handler we can force a jump to when an exception
+ * happens due to something kernel code did
+ */
+int die_if_no_fixup(const char *str, struct pt_regs *regs,
+		    exception_code_t code)
+{
+	if (user_mode(regs))
+		return 0;
+
+	peripheral_leds_display_exception(code);
+
+	switch (code) {
+		/* see if we can fixup the kernel accessing memory */
+	case EXCEP_ITLBMISS:
+	case EXCEP_DTLBMISS:
+	case EXCEP_IAERROR:
+	case EXCEP_DAERROR:
+	case EXCEP_MEMERR:
+	case EXCEP_MISALIGN:
+	case EXCEP_BUSERROR:
+	case EXCEP_ILLDATACC:
+	case EXCEP_IOINSACC:
+	case EXCEP_PRIVINSACC:
+	case EXCEP_PRIVDATACC:
+	case EXCEP_DATINSACC:
+		if (fixup_exception(regs))
+			return 1;
+	case EXCEP_UNIMPINS:
+		if (regs->pc && *(uint8_t *)regs->pc == 0xff)
+			if (notify_die(DIE_BREAKPOINT, str, regs, code, 0, 0))
+				return 1;
+		break;
+	default:
+		break;
+	}
+
+	/* see if gdbstub wants to deal with it */
+#ifdef CONFIG_GDBSTUB
+	if (gdbstub_intercept(regs, code))
+		return 1;
+#endif
+
+	if (notify_die(DIE_GPF, str, regs, code, 0, 0))
+		return 1;
+
+	/* make the process die as the last resort */
+	die(str, regs, code);
+}
+
+/*
+ * handle unsupported syscall instructions (syscall 1-15)
+ */
+static asmlinkage void unsupported_syscall(struct pt_regs *regs,
+					   exception_code_t code)
+{
+	struct task_struct *tsk = current;
+	siginfo_t info;
+
+	/* catch a kernel BUG() */
+	if (code == EXCEP_SYSCALL15 && !user_mode(regs)) {
+		if (report_bug(regs->pc, regs) == BUG_TRAP_TYPE_BUG) {
+#ifdef CONFIG_GDBSTUB
+			__gdbstub_bug_trap();
+#endif
+		}
+	}
+
+	regs->pc -= 2; /* syscall return addr is _after_ the instruction */
+
+	die_if_no_fixup("An unsupported syscall insn was used by the kernel\n",
+			regs, code);
+
+	info.si_signo	= SIGILL;
+	info.si_errno	= ENOSYS;
+	info.si_code	= ILL_ILLTRP;
+	info.si_addr	= (void *) regs->pc;
+	force_sig_info(SIGILL, &info, tsk);
+}
+
+/*
+ * display the register file when the stack pointer gets clobbered
+ */
+asmlinkage void do_double_fault(struct pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+
+	strcpy(tsk->comm, "emergency tsk");
+	tsk->pid = 0;
+	console_verbose();
+	printk("--- double fault ---\n");
+	show_registers(regs);
+}
+
+/*
+ * asynchronous bus error (external, usually I/O DMA)
+ */
+asmlinkage void io_bus_error(u32 bcberr, u32 bcbear, struct pt_regs *regs)
+{
+	console_verbose();
+
+	printk("\n"
+	       "Asynchronous I/O Bus Error\n"
+	       "==========================\n");
+
+	if (bcberr & BCBERR_BEME)
+		printk("- Multiple recorded errors\n");
+
+	printk("- Faulting Buses:%s%s%s\n",
+	       bcberr & BCBERR_BEMR_CI  ? " CPU-Ins-Fetch" : "",
+	       bcberr & BCBERR_BEMR_CD  ? " CPU-Data" : "",
+	       bcberr & BCBERR_BEMR_DMA ? " DMA" : "");
+
+	printk("- %s %s access made to %s at address %08x\n",
+	       bcberr &	BCBERR_BEBST ? "Burst" : "Single",
+	       bcberr &	BCBERR_BERW ? "Read" : "Write",
+	       bcberr &	BCBERR_BESB_MON  ? "Monitor Space" :
+	       bcberr &	BCBERR_BESB_IO   ? "Internal CPU I/O Space" :
+	       bcberr &	BCBERR_BESB_EX   ? "External I/O Bus" :
+	       bcberr &	BCBERR_BESB_OPEX ? "External Memory Bus" :
+	       "On Chip Memory",
+	       bcbear
+	       );
+
+	printk("- Detected by the %s\n",
+	       bcberr&BCBERR_BESD ? "Bus Control Unit" : "Slave Bus");
+
+#ifdef CONFIG_PCI
+#define BRIDGEREGB(X) (*(volatile __u8  *)(0xBE040000 + (X)))
+#define BRIDGEREGW(X) (*(volatile __u16 *)(0xBE040000 + (X)))
+#define BRIDGEREGL(X) (*(volatile __u32 *)(0xBE040000 + (X)))
+
+	printk("- PCI Memory Paging Reg:         %08x\n",
+	       *(volatile __u32 *) (0xBFFFFFF4));
+	printk("- PCI Bridge Base Address 0:     %08x\n",
+	       BRIDGEREGL(PCI_BASE_ADDRESS_0));
+	printk("- PCI Bridge AMPCI Base Address: %08x\n",
+	       BRIDGEREGL(0x48));
+	printk("- PCI Bridge Command:                %04hx\n",
+	       BRIDGEREGW(PCI_COMMAND));
+	printk("- PCI Bridge Status:                 %04hx\n",
+	       BRIDGEREGW(PCI_STATUS));
+	printk("- PCI Bridge Int Status:         %08hx\n",
+	       BRIDGEREGL(0x4c));
+#endif
+
+	printk("\n");
+	show_registers(regs);
+
+	panic("Halted due to asynchronous I/O Bus Error\n");
+}
+
+/*
+ * handle an exception for which a handler has not yet been installed
+ */
+asmlinkage void uninitialised_exception(struct pt_regs *regs,
+					exception_code_t code)
+{
+
+	/* see if gdbstub wants to deal with it */
+#ifdef CONFIG_GDBSTUB
+	if (gdbstub_intercept(regs, code))
+		return;
+#endif
+
+	peripheral_leds_display_exception(code);
+	printk("Uninitialised Exception 0x%04x\n", code & 0xFFFF);
+	show_registers(regs);
+
+	for (;;)
+		continue;
+}
+
+/*
+ * set an interrupt stub to jump to a handler
+ * ! NOTE: this does *not* flush the caches
+ */
+void __init __set_intr_stub(exception_code_t code, void *handler)
+{
+	unsigned long addr;
+	u8 *vector = (u8 *)(CONFIG_INTERRUPT_VECTOR_BASE + code);
+
+	addr = (unsigned long) handler - (unsigned long) vector;
+	vector[0] = 0xdc;		/* JMP handler */
+	vector[1] = addr;
+	vector[2] = addr >> 8;
+	vector[3] = addr >> 16;
+	vector[4] = addr >> 24;
+	vector[5] = 0xcb;
+	vector[6] = 0xcb;
+	vector[7] = 0xcb;
+}
+
+/*
+ * set an interrupt stub to jump to a handler
+ */
+void __init set_intr_stub(exception_code_t code, void *handler)
+{
+	unsigned long addr;
+	u8 *vector = (u8 *)(CONFIG_INTERRUPT_VECTOR_BASE + code);
+
+	addr = (unsigned long) handler - (unsigned long) vector;
+	vector[0] = 0xdc;		/* JMP handler */
+	vector[1] = addr;
+	vector[2] = addr >> 8;
+	vector[3] = addr >> 16;
+	vector[4] = addr >> 24;
+	vector[5] = 0xcb;
+	vector[6] = 0xcb;
+	vector[7] = 0xcb;
+
+	mn10300_dcache_flush_inv();
+	mn10300_icache_inv();
+}
+
+/*
+ * set an interrupt stub to invoke the JTAG unit and then jump to a handler
+ */
+void __init set_jtag_stub(exception_code_t code, void *handler)
+{
+	unsigned long addr;
+	u8 *vector = (u8 *)(CONFIG_INTERRUPT_VECTOR_BASE + code);
+
+	addr = (unsigned long) handler - ((unsigned long) vector + 1);
+	vector[0] = 0xff;		/* PI to jump into JTAG debugger */
+	vector[1] = 0xdc;		/* jmp handler */
+	vector[2] = addr;
+	vector[3] = addr >> 8;
+	vector[4] = addr >> 16;
+	vector[5] = addr >> 24;
+	vector[6] = 0xcb;
+	vector[7] = 0xcb;
+
+	mn10300_dcache_flush_inv();
+	flush_icache_range((unsigned long) vector, (unsigned long) vector + 8);
+}
+
+/*
+ * initialise the exception table
+ */
+void __init trap_init(void)
+{
+	set_excp_vector(EXCEP_TRAP,		trap);
+	set_excp_vector(EXCEP_ISTEP,		istep);
+	set_excp_vector(EXCEP_IBREAK,		ibreak);
+	set_excp_vector(EXCEP_OBREAK,		obreak);
+
+	set_excp_vector(EXCEP_PRIVINS,		priv_op);
+	set_excp_vector(EXCEP_UNIMPINS,		invalid_op);
+	set_excp_vector(EXCEP_UNIMPEXINS,	invalid_exop);
+	set_excp_vector(EXCEP_MEMERR,		mem_error);
+	set_excp_vector(EXCEP_MISALIGN,		misalignment);
+	set_excp_vector(EXCEP_BUSERROR,		bus_error);
+	set_excp_vector(EXCEP_ILLINSACC,	insn_acc_error);
+	set_excp_vector(EXCEP_ILLDATACC,	data_acc_error);
+	set_excp_vector(EXCEP_IOINSACC,		insn_acc_error);
+	set_excp_vector(EXCEP_PRIVINSACC,	insn_acc_error);
+	set_excp_vector(EXCEP_PRIVDATACC,	data_acc_error);
+	set_excp_vector(EXCEP_DATINSACC,	insn_acc_error);
+	set_excp_vector(EXCEP_FPU_DISABLED,	fpu_disabled);
+	set_excp_vector(EXCEP_FPU_UNIMPINS,	fpu_invalid_op);
+	set_excp_vector(EXCEP_FPU_OPERATION,	fpu_exception);
+
+	set_excp_vector(EXCEP_NMI,		nmi);
+
+	set_excp_vector(EXCEP_SYSCALL1,		unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL2,		unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL3,		unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL4,		unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL5,		unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL6,		unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL7,		unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL8,		unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL9,		unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL10,	unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL11,	unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL12,	unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL13,	unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL14,	unsupported_syscall);
+	set_excp_vector(EXCEP_SYSCALL15,	unsupported_syscall);
+}
+
+/*
+ * determine if a program counter value is a valid bug address
+ */
+int is_valid_bugaddr(unsigned long pc)
+{
+	return pc >= PAGE_OFFSET;
+}
diff -puN /dev/null arch/mn10300/kernel/vmlinux.lds.S
--- /dev/null
+++ a/arch/mn10300/kernel/vmlinux.lds.S
@@ -0,0 +1,159 @@
+/* MN10300 Main kernel linker script
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#define __VMLINUX_LDS__
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/thread_info.h>
+
+OUTPUT_FORMAT("elf32-am33lin", "elf32-am33lin", "elf32-am33lin")
+OUTPUT_ARCH(mn10300)
+ENTRY(_start)
+jiffies = jiffies_64;
+#ifndef CONFIG_MN10300_CURRENT_IN_E2
+current = __current;
+#endif
+SECTIONS
+{
+  . = CONFIG_KERNEL_TEXT_ADDRESS;
+  /* read-only */
+  _stext = .;
+  _text = .;			/* Text and read-only data */
+  .text : {
+	*(
+	.text.head
+	.text
+	)
+	TEXT_TEXT
+	SCHED_TEXT
+	LOCK_TEXT
+	KPROBES_TEXT
+	*(.fixup)
+	*(.gnu.warning)
+	} = 0xcb
+
+  _etext = .;			/* End of text section */
+
+  . = ALIGN(16);		/* Exception table */
+  __start___ex_table = .;
+  __ex_table : { *(__ex_table) }
+  __stop___ex_table = .;
+
+  BUG_TABLE
+
+  RODATA
+
+  /* writeable */
+  .data : {			/* Data */
+	DATA_DATA
+	CONSTRUCTORS
+	}
+
+  . = ALIGN(4096);
+  __nosave_begin = .;
+  .data_nosave : { *(.data.nosave) }
+  . = ALIGN(4096);
+  __nosave_end = .;
+
+  . = ALIGN(4096);
+  .data.page_aligned : { *(.data.idt) }
+
+  . = ALIGN(32);
+  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+
+  /* rarely changed data like cpu maps */
+  . = ALIGN(32);
+  .data.read_mostly : AT(ADDR(.data.read_mostly)) {
+	*(.data.read_mostly)
+	_edata = .;		/* End of data section */
+  }
+
+  . = ALIGN(THREAD_SIZE);	/* init_task */
+  .data.init_task : { *(.data.init_task) }
+
+  /* might get freed after init */
+  . = ALIGN(4096);
+  .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+  	__smp_locks = .;
+	*(.smp_locks)
+	__smp_locks_end = .;
+  }
+
+  /* will be freed after init */
+  . = ALIGN(4096);		/* Init code and data */
+  __init_begin = .;
+  .init.text : {
+	_sinittext = .;
+	*(.init.text)
+	_einittext = .;
+  }
+  .init.data : { *(.init.data) }
+  . = ALIGN(16);
+  __setup_start = .;
+  .setup.init : { KEEP(*(.init.setup)) }
+  __setup_end = .;
+
+  __initcall_start = .;
+  .initcall.init : {
+	INITCALLS
+  }
+  __initcall_end = .;
+  __con_initcall_start = .;
+  .con_initcall.init : { *(.con_initcall.init) }
+  __con_initcall_end = .;
+
+  SECURITY_INIT
+  . = ALIGN(4);
+  __alt_instructions = .;
+  .altinstructions : { *(.altinstructions) }
+  __alt_instructions_end = .;
+ .altinstr_replacement : { *(.altinstr_replacement) }
+  /* .exit.text is discard at runtime, not link time, to deal with references
+     from .altinstructions and .eh_frame */
+  .exit.text : { *(.exit.text) }
+  .exit.data : { *(.exit.data) }
+
+#ifdef CONFIG_BLK_DEV_INITRD
+  . = ALIGN(4096);
+  __initramfs_start = .;
+  .init.ramfs : { *(.init.ramfs) }
+  __initramfs_end = .;
+#endif
+
+  . = ALIGN(32);
+  __per_cpu_start = .;
+  .data.percpu  : { *(.data.percpu) }
+  __per_cpu_end = .;
+  . = ALIGN(4096);
+  __init_end = .;
+  /* freed after init ends here */
+
+  __bss_start = .;		/* BSS */
+  .bss : {
+	*(.bss.page_aligned)
+	*(.bss)
+  }
+  . = ALIGN(4);
+  __bss_stop = .;
+
+  _end = . ;
+
+  /* This is where the kernel creates the early boot page tables */
+  . = ALIGN(4096);
+  pg0 = .;
+
+  /* Sections to be discarded */
+  /DISCARD/ : {
+	*(.exitcall.exit)
+	}
+
+  STABS_DEBUG
+
+  DWARF_DEBUG
+}
diff -puN /dev/null arch/mn10300/lib/__ashldi3.S
--- /dev/null
+++ a/arch/mn10300/lib/__ashldi3.S
@@ -0,0 +1,49 @@
+/* MN10300 64-bit arithmetic left shift
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/cache.h>
+
+        .text
+        .balign	L1_CACHE_BYTES
+
+###############################################################################
+#
+# unsigned long long __ashldi3(unsigned long long value [D1:D0], unsigned by [(12,SP)])
+#
+###############################################################################
+        .globl	__ashldi3
+        .type	__ashldi3,@function
+__ashldi3:
+	mov	(12,sp),a0
+	and	+63,a0
+	beq	__ashldi3_zero
+
+	cmp	+31,a0
+	bhi	__ashldi3_32plus
+
+	# the count is in the range 1-31
+	asl	a0,d1
+
+	mov	+32,a1
+	sub	a0,a1,a1			# a1 = 32 - count
+	lsr	a1,d0,a1			# get overflow from LSW -> MSW
+
+	or_asl	a1,d1,a0,d0			# insert overflow into MSW and shift the LSW
+	rets
+
+	.balign	L1_CACHE_BYTES
+	# the count is in the range 32-63
+__ashldi3_32plus:
+	asl	a0,d0,d1
+	clr	d0
+__ashldi3_zero:
+	rets
+
+	.size	__ashldi3, .-__ashldi3
diff -puN /dev/null arch/mn10300/lib/ashrdi3.c
--- /dev/null
+++ a/arch/mn10300/lib/ashrdi3.c
@@ -0,0 +1,63 @@
+/* ashrdi3.c extracted from gcc-2.7.2/libgcc2.c which is: */
+/* Copyright (C) 1989, 1992, 1993, 1994, 1995 Free Software Foundation, Inc.
+
+This file is part of GNU CC.
+
+GNU CC is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public Licence as published by
+the Free Software Foundation; either version 2, or (at your option)
+any later version.
+
+GNU CC is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public Licence for more details.
+
+You should have received a copy of the GNU General Public Licence
+along with GNU CC; see the file COPYING.  If not, write to
+the Free Software Foundation, 59 Temple Place - Suite 330,
+Boston, MA 02111-1307, USA.  */
+
+#define BITS_PER_UNIT 8
+
+typedef 	 int SItype	__attribute__ ((mode (SI)));
+typedef unsigned int USItype	__attribute__ ((mode (SI)));
+typedef		 int DItype	__attribute__ ((mode (DI)));
+typedef int word_type __attribute__ ((mode (__word__)));
+
+struct DIstruct {SItype low, high;};
+
+typedef union
+{
+  struct DIstruct s;
+  DItype ll;
+} DIunion;
+
+DItype
+__ashrdi3 (DItype u, word_type b)
+{
+  DIunion w;
+  word_type bm;
+  DIunion uu;
+
+  if (b == 0)
+    return u;
+
+  uu.ll = u;
+
+  bm = (sizeof (SItype) * BITS_PER_UNIT) - b;
+  if (bm <= 0)
+    {
+      /* w.s.high = 1..1 or 0..0 */
+      w.s.high = uu.s.high >> (sizeof (SItype) * BITS_PER_UNIT - 1);
+      w.s.low = uu.s.high >> -bm;
+    }
+  else
+    {
+      USItype carries = (USItype)uu.s.high << bm;
+      w.s.high = uu.s.high >> b;
+      w.s.low = ((USItype)uu.s.low >> b) | carries;
+    }
+
+  return w.ll;
+}
diff -puN /dev/null arch/mn10300/lib/__ashrdi3.S
--- /dev/null
+++ a/arch/mn10300/lib/__ashrdi3.S
@@ -0,0 +1,50 @@
+/* MN10300 64-bit arithmetic right shift
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/cache.h>
+
+        .text
+        .balign	L1_CACHE_BYTES
+
+###############################################################################
+#
+# unsigned long long __ashrdi3(unsigned long long value [D1:D0], unsigned by [(12,SP)])
+#
+###############################################################################
+        .globl	__ashrdi3
+        .type	__ashrdi3,@function
+__ashrdi3:
+	mov	(12,sp),a0
+	and	+63,a0
+	beq	__ashrdi3_zero
+
+	cmp	+31,a0
+	bhi	__ashrdi3_32plus
+
+	# the count is in the range 1-31
+	lsr	a0,d0
+
+	mov	+32,a1
+	sub	a0,a1,a1			# a1 = 32 - count
+	asl	a1,d1,a1			# get underflow from MSW -> LSW
+
+	or_asr	a1,d0,a0,d1			# insert underflow into LSW and shift the MSW
+	rets
+
+	.balign	L1_CACHE_BYTES
+	# the count is in the range 32-63
+__ashrdi3_32plus:
+	asr	a0,d1,d0
+	ext	d0				# sign-extend result through MDR
+	mov	mdr,d1
+__ashrdi3_zero:
+	rets
+
+	.size	__ashrdi3, .-__ashrdi3
diff -puN /dev/null arch/mn10300/lib/bitops.c
--- /dev/null
+++ a/arch/mn10300/lib/bitops.c
@@ -0,0 +1,51 @@
+/* MN10300 Non-trivial bit operations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <asm/bitops.h>
+#include <asm/system.h>
+
+/*
+ * try flipping a bit using BSET and BCLR
+ */
+void change_bit(int nr, volatile void *addr)
+{
+	if (test_bit(nr, addr))
+		goto try_clear_bit;
+
+try_set_bit:
+	if (!test_and_set_bit(nr, addr))
+		return;
+
+try_clear_bit:
+	if (test_and_clear_bit(nr, addr))
+		return;
+
+	goto try_set_bit;
+}
+
+/*
+ * try flipping a bit using BSET and BCLR and returning the old value
+ */
+int test_and_change_bit(int nr, volatile void *addr)
+{
+	if (test_bit(nr, addr))
+		goto try_clear_bit;
+
+try_set_bit:
+	if (!test_and_set_bit(nr, addr))
+		return 0;
+
+try_clear_bit:
+	if (test_and_clear_bit(nr, addr))
+		return 1;
+
+	goto try_set_bit;
+}
diff -puN /dev/null arch/mn10300/lib/checksum.c
--- /dev/null
+++ a/arch/mn10300/lib/checksum.c
@@ -0,0 +1,109 @@
+/* MN10300 Optimised checksumming wrappers
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <asm/byteorder.h>
+#include <asm/uaccess.h>
+#include <asm/checksum.h>
+
+extern __wsum do_csum(const void *buff, int len);
+
+static inline unsigned short from32to16(__wsum sum)
+{
+	__asm__(
+		"	add	%1,%0		\n"
+		"	addc	0xffff,%0	\n"
+		: "=r" (sum)
+		: "r" (sum << 16), "0" (sum & 0xffff0000)
+		);
+	return sum >> 16;
+}
+
+__sum16 ip_fast_csum(const void *iph, unsigned int ihl)
+{
+	return ~do_csum(iph, ihl * 4);
+}
+
+EXPORT_SYMBOL(ip_fast_csum);
+
+__wsum csum_partial(const void *buff, int len, __wsum sum)
+{
+	__wsum result;
+
+        result = do_csum(buff, len);
+        result += sum;
+        if (sum > result) {
+		result ++;
+	}
+	return result;
+}
+
+EXPORT_SYMBOL(csum_partial);
+
+__sum16 ip_compute_csum(const void *buff, int len)
+{
+	return ~from32to16(do_csum(buff,len));
+}
+
+EXPORT_SYMBOL(ip_compute_csum);
+
+__wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
+{
+	copy_from_user(dst, src, len);
+	return csum_partial(dst, len, sum);
+}
+
+EXPORT_SYMBOL(csum_partial_copy);
+
+__wsum csum_partial_copy_nocheck(const void *src, void *dst,
+				 int len, __wsum sum)
+{
+	sum = csum_partial(src, len, sum);
+	memcpy(dst, src, len);
+	return sum;
+}
+
+EXPORT_SYMBOL(csum_partial_copy_nocheck);
+
+__wsum csum_partial_copy_from_user(const void *src, void *dst,
+				   int len, __wsum sum,
+				   int *err_ptr)
+{
+	int missing;
+
+	missing = copy_from_user(dst, src, len);
+	if (missing) {
+		memset(dst + len - missing, 0, missing);
+		*err_ptr = -EFAULT;
+	}
+
+	return csum_partial(dst, len, sum);
+}
+
+EXPORT_SYMBOL(csum_partial_copy_from_user);
+
+__wsum csum_and_copy_to_user(const void *src, void *dst,
+			     int len, __wsum sum,
+			     int *err_ptr)
+{
+	int missing;
+
+	missing = copy_to_user(dst, src, len);
+	if (missing) {
+		memset(dst + len - missing, 0, missing);
+		*err_ptr = -EFAULT;
+	}
+
+	return csum_partial(src, len, sum);
+}
+
+EXPORT_SYMBOL(csum_and_copy_to_user);
diff -puN /dev/null arch/mn10300/lib/delay.c
--- /dev/null
+++ a/arch/mn10300/lib/delay.c
@@ -0,0 +1,51 @@
+/* MN10300 Short delay interpolation routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <asm/div64.h>
+
+/*
+ * 
+ */
+void __delay(unsigned long loops)
+{
+	int d0;
+
+	asm volatile(
+		"	bra	1f	\n"
+		"	.align	4	\n"
+		"1:	bra	2f	\n"
+		"	.align	4	\n"
+		"2:	add	-1,%0	\n"
+		"	bne	2b	\n"
+		: "=&d" (d0)
+		: "0" (loops));
+}
+
+EXPORT_SYMBOL(__delay);
+
+/*
+ * handle a delay specified in terms of microseconds
+ */
+void __udelay(unsigned long usecs)
+{
+	signed long ioclk, stop;
+
+	stop = __muldiv64u(usecs, MN10300_TSCCLK, 1000000); /* usecs * CLK / 1E6 */
+	stop = TMTSCBC - stop;
+
+	do {
+		ioclk = TMTSCBC;
+	} while (stop < ioclk);
+}
+
+EXPORT_SYMBOL(__udelay);
diff -puN /dev/null arch/mn10300/lib/do_csum.S
--- /dev/null
+++ a/arch/mn10300/lib/do_csum.S
@@ -0,0 +1,162 @@
+/* Optimised simple memory checksum
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/cache.h>
+
+        .section .text
+        .balign	L1_CACHE_BYTES
+
+###############################################################################
+#
+# unsigned int do_csum(const unsigned char *buff, size_t len)
+#
+###############################################################################
+	.globl	do_csum
+        .type	do_csum,@function
+do_csum:
+	movm	[d2,d3],(sp)
+	mov	d0,(12,sp)
+	mov	d1,(16,sp)
+	mov	d1,d2				# count
+	mov	d0,a0				# buff
+	clr	d1				# accumulator
+
+	cmp	+0,d2
+	beq	do_csum_done			# return if zero-length buffer
+
+	# 4-byte align the buffer pointer
+	btst	+3,a0
+	beq	do_csum_now_4b_aligned
+
+	btst	+1,a0
+	beq	do_csum_addr_not_odd
+	movbu	(a0),d0
+	inc	a0
+	asl	+8,d0
+	add	d0,d1
+	addc	+0,d1
+	add	-1,d2
+do_csum_addr_not_odd:
+
+	cmp	+2,d2
+	bcs	do_csum_fewer_than_4
+	btst	+2,a0
+	beq	do_csum_now_4b_aligned
+	movhu	(a0+),d0
+	add	d0,d1
+	addc	+0,d1
+	add	-2,d2
+	cmp	+4,d2
+	bcs	do_csum_fewer_than_4
+
+do_csum_now_4b_aligned:
+	# we want to checksum as much as we can in chunks of 32 bytes
+	cmp	+31,d2
+	bls	do_csum_remainder		# 4-byte aligned remainder
+
+	add	-32,d2
+	mov	+32,d3
+
+do_csum_loop:
+	mov	(a0+),d0
+	add	d0,d1
+	mov	(a0+),e0
+	addc	e0,d1
+	mov	(a0+),e1
+	addc	e1,d1
+	mov	(a0+),e3
+	addc	e3,d1
+	mov	(a0+),d0
+	addc	d0,d1
+	mov	(a0+),e0
+	addc	e0,d1
+	mov	(a0+),e1
+	addc	e1,d1
+	mov	(a0+),e3
+	addc	e3,d1
+	addc	+0,d1
+
+	sub	d3,d2
+	bcc	do_csum_loop
+
+	add	d3,d2
+	beq	do_csum_done
+
+do_csum_remainder:
+	# cut 16-31 bytes down to 0-15
+	cmp	+16,d2
+	bcs	do_csum_fewer_than_16
+	mov	(a0+),d0
+	add	d0,d1
+	mov	(a0+),e0
+	addc	e0,d1
+	mov	(a0+),e1
+	addc	e1,d1
+	mov	(a0+),e3
+	addc	e3,d1
+	addc	+0,d1
+	add	-16,d2
+	beq	do_csum_done
+
+do_csum_fewer_than_16:
+	# copy the remaining whole words
+	cmp	+4,d2
+	bcs	do_csum_fewer_than_4
+	cmp	+8,d2
+	bcs	do_csum_one_word
+	cmp	+12,d2
+	bcs	do_csum_two_words
+	mov	(a0+),d0
+	add	d0,d1
+	addc	+0,d1
+do_csum_two_words:
+	mov	(a0+),d0
+	add	d0,d1
+	addc	+0,d1
+do_csum_one_word:
+	mov	(a0+),d0
+	add	d0,d1
+	addc	+0,d1
+
+do_csum_fewer_than_4:
+	and	+3,d2
+	beq	do_csum_done
+	xor_cmp	d0,d0,+2,d2
+	bcs	do_csum_fewer_than_2
+	movhu	(a0+),d0
+do_csum_fewer_than_2:
+	and	+1,d2
+	beq	do_csum_add_last_bit
+	movbu	(a0),d3
+	add	d3,d0
+do_csum_add_last_bit:
+	add	d0,d1
+	addc	+0,d1
+
+do_csum_done:
+	# compress the checksum down to 16 bits
+	mov	+0xffff0000,d2
+	and	d1,d2
+	asl	+16,d1
+	add	d2,d1,d0
+	addc	+0xffff,d0
+	lsr	+16,d0
+
+	# flip the halves of the word result if the buffer was oddly aligned
+	mov	(12,sp),d1
+	and	+1,d1
+	beq	do_csum_not_oddly_aligned
+	swaph	d0,d0				# exchange bits 15:8 with 7:0
+
+do_csum_not_oddly_aligned:
+	ret	[d2,d3],8
+
+do_csum_end:
+	.size	do_csum, do_csum_end-do_csum
diff -puN /dev/null arch/mn10300/lib/lshrdi3.c
--- /dev/null
+++ a/arch/mn10300/lib/lshrdi3.c
@@ -0,0 +1,62 @@
+/* lshrdi3.c extracted from gcc-2.7.2/libgcc2.c which is: */
+/* Copyright (C) 1989, 1992, 1993, 1994, 1995 Free Software Foundation, Inc.
+
+This file is part of GNU CC.
+
+GNU CC is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public Licence as published by
+the Free Software Foundation; either version 2, or (at your option)
+any later version.
+
+GNU CC is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public Licence for more details.
+
+You should have received a copy of the GNU General Public Licence
+along with GNU CC; see the file COPYING.  If not, write to
+the Free Software Foundation, 59 Temple Place - Suite 330,
+Boston, MA 02111-1307, USA.  */
+
+#define BITS_PER_UNIT 8
+
+typedef 	 int SItype	__attribute__ ((mode (SI)));
+typedef unsigned int USItype	__attribute__ ((mode (SI)));
+typedef		 int DItype	__attribute__ ((mode (DI)));
+typedef int word_type __attribute__ ((mode (__word__)));
+
+struct DIstruct {SItype low, high;};
+
+typedef union
+{
+  struct DIstruct s;
+  DItype ll;
+} DIunion;
+
+DItype
+__lshrdi3 (DItype u, word_type b)
+{
+  DIunion w;
+  word_type bm;
+  DIunion uu;
+
+  if (b == 0)
+    return u;
+
+  uu.ll = u;
+
+  bm = (sizeof (SItype) * BITS_PER_UNIT) - b;
+  if (bm <= 0)
+    {
+      w.s.high = 0;
+      w.s.low = (USItype)uu.s.high >> -bm;
+    }
+  else
+    {
+      USItype carries = (USItype)uu.s.high << bm;
+      w.s.high = (USItype)uu.s.high >> b;
+      w.s.low = ((USItype)uu.s.low >> b) | carries;
+    }
+
+  return w.ll;
+}
diff -puN /dev/null arch/mn10300/lib/__lshrdi3.S
--- /dev/null
+++ a/arch/mn10300/lib/__lshrdi3.S
@@ -0,0 +1,50 @@
+/* MN10300 64-bit logical right shift
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <asm/cache.h>
+
+        .text
+        .balign	L1_CACHE_BYTES
+
+###############################################################################
+#
+# unsigned long long __lshrdi3(unsigned long long value [D1:D0], unsigned by [(12,SP)])
+#
+###############################################################################
+        .globl	__lshrdi3
+        .type	__lshrdi3,@function
+__lshrdi3:
+	mov	(12,sp),a0
+	and	+63,a0
+	beq	__lshrdi3_zero
+
+	cmp	+31,a0
+	bhi	__lshrdi3_32plus
+
+	# the count is in the range 1-31
+	lsr	a0,d0
+
+	mov	+32,a1
+	sub	a0,a1,a1			# a1 = 32 - count
+	asl	a1,d1,a1			# get underflow from MSW -> LSW
+
+	or_lsr	a1,d0,a0,d1			# insert underflow into LSW and shift the MSW
+	rets
+
+	.balign	L1_CACHE_BYTES
+	# the count is in the range 32-63
+__lshrdi3_32plus:
+	lsr	a0,d1,d0
+	clr	d1
+__lshrdi3_zero:
+	rets
+
+	.size	__lshrdi3, .-__lshrdi3
diff -puN /dev/null arch/mn10300/lib/Makefile
--- /dev/null
+++ a/arch/mn10300/lib/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the MN10300-specific library files..
+#
+
+lib-y = delay.o usercopy.o checksum.o bitops.o memcpy.o memmove.o memset.o
+lib-y += do_csum.o
+lib-y += __ashldi3.o __ashrdi3.o __lshrdi3.o negdi2.o
diff -puN /dev/null arch/mn10300/lib/memcpy.S
--- /dev/null
+++ a/arch/mn10300/lib/memcpy.S
@@ -0,0 +1,133 @@
+/* MN10300 Optimised simple memory to memory copy
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/cache.h>
+
+        .section .text
+        .balign	L1_CACHE_BYTES
+
+###############################################################################
+#
+# void *memcpy(void *dst, const void *src, size_t n)
+#
+###############################################################################
+	.globl	memcpy
+        .type	memcpy,@function
+memcpy:
+	movm	[d2,d3],(sp)
+	mov	d0,(12,sp)
+	mov	d1,(16,sp)
+	mov	(20,sp),d2			# count
+	mov	d0,a0				# dst
+	mov	d1,a1				# src
+	mov	d0,e3				# the return value
+
+	cmp	+0,d2
+	beq	memcpy_done			# return if zero-length copy
+
+	# see if the three parameters are all four-byte aligned
+	or	d0,d1,d3
+	or	d2,d3
+	and	+3,d3
+	bne	memcpy_1			# jump if not
+
+	# we want to transfer as much as we can in chunks of 32 bytes
+	cmp	+31,d2
+	bls	memcpy_4_remainder		# 4-byte aligned remainder
+
+	movm	[exreg1],(sp)
+	add	-32,d2
+	mov	+32,d3
+
+memcpy_4_loop:
+	mov	(a1+),d0
+	mov	(a1+),d1
+	mov	(a1+),e0
+	mov	(a1+),e1
+	mov	(a1+),e4
+	mov	(a1+),e5
+	mov	(a1+),e6
+	mov	(a1+),e7
+	mov	d0,(a0+)
+	mov	d1,(a0+)
+	mov	e0,(a0+)
+	mov	e1,(a0+)
+	mov	e4,(a0+)
+	mov	e5,(a0+)
+	mov	e6,(a0+)
+	mov	e7,(a0+)
+
+	sub	d3,d2
+	bcc	memcpy_4_loop
+
+	movm	(sp),[exreg1]
+	add	d3,d2
+	beq	memcpy_4_no_remainder
+
+memcpy_4_remainder:
+	# cut 4-7 words down to 0-3
+	cmp	+16,d2
+	bcs	memcpy_4_three_or_fewer_words
+	mov	(a1+),d0
+	mov	(a1+),d1
+	mov	(a1+),e0
+	mov	(a1+),e1
+	mov	d0,(a0+)
+	mov	d1,(a0+)
+	mov	e0,(a0+)
+	mov	e1,(a0+)
+	add	-16,d2
+	beq	memcpy_4_no_remainder
+
+	# copy the remaining 1, 2 or 3 words
+memcpy_4_three_or_fewer_words:
+	cmp	+8,d2
+	bcs	memcpy_4_one_word
+	beq	memcpy_4_two_words
+	mov	(a1+),d0
+	mov	d0,(a0+)
+memcpy_4_two_words:
+	mov	(a1+),d0
+	mov	d0,(a0+)
+memcpy_4_one_word:
+	mov	(a1+),d0
+	mov	d0,(a0+)
+
+memcpy_4_no_remainder:
+	sub	e3,a0,d2			# check we copied the correct amount
+	mov	(20,sp),d1			// TODO: REMOVE CHECK
+	cmp	d2,d1
+	beq	memcpy_done
+	break
+	break
+	break
+
+memcpy_done:
+	mov	e3,a0
+	ret	[d2,d3],8
+
+	# handle misaligned copying
+memcpy_1:
+	add	-1,d2
+	mov	+1,d3
+	setlb					# setlb requires the next insns
+						# to occupy exactly 4 bytes
+
+	sub	d3,d2
+	movbu	(a1),d0
+	movbu	d0,(a0)
+	add_add	d3,a1,d3,a0
+	lcc
+
+	mov	e3,a0
+	ret	[d2,d3],8
+
+memcpy_end:
+	.size	memcpy, memcpy_end-memcpy
diff -puN /dev/null arch/mn10300/lib/memmove.S
--- /dev/null
+++ a/arch/mn10300/lib/memmove.S
@@ -0,0 +1,157 @@
+/* MN10300 Optimised simple memory to memory copy, with support for overlapping
+ * regions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/cache.h>
+
+        .section .text
+        .balign	L1_CACHE_BYTES
+
+###############################################################################
+#
+# void *memmove(void *dst, const void *src, size_t n)
+#
+###############################################################################
+	.globl	memmove
+        .type	memmove,@function
+memmove:
+	# fall back to memcpy if dst < src to work bottom up
+	cmp	d1,d0
+	bcs	memmove_memcpy
+
+	# work top down
+	movm	[d2,d3],(sp)
+	mov	d0,(12,sp)
+	mov	d1,(16,sp)
+	mov	(20,sp),d2			# count
+	add	d0,d2,a0			# dst end
+	add	d1,d2,a1			# src end
+	mov	d0,e3				# the return value
+
+	cmp	+0,d2
+	beq	memmove_done			# return if zero-length copy
+
+	# see if the three parameters are all four-byte aligned
+	or	d0,d1,d3
+	or	d2,d3
+	and	+3,d3
+	bne	memmove_1			# jump if not
+
+	# we want to transfer as much as we can in chunks of 32 bytes
+	add	-4,a1
+	cmp	+31,d2
+	bls	memmove_4_remainder		# 4-byte aligned remainder
+
+	add	-32,d2
+	mov	+32,d3
+
+memmove_4_loop:
+	mov	(a1),d0
+	sub_sub	+4,a1,+4,a0
+	mov	d0,(a0)
+	mov	(a1),d1
+	sub_sub	+4,a1,+4,a0
+	mov	d1,(a0)
+
+	mov	(a1),d0
+	sub_sub	+4,a1,+4,a0
+	mov	d0,(a0)
+	mov	(a1),d1
+	sub_sub	+4,a1,+4,a0
+	mov	d1,(a0)
+
+	mov	(a1),d0
+	sub_sub	+4,a1,+4,a0
+	mov	d0,(a0)
+	mov	(a1),d1
+	sub_sub	+4,a1,+4,a0
+	mov	d1,(a0)
+
+	mov	(a1),d0
+	sub_sub	+4,a1,+4,a0
+	mov	d0,(a0)
+	mov	(a1),d1
+	sub_sub	+4,a1,+4,a0
+	mov	d1,(a0)
+
+	sub	d3,d2
+	bcc	memmove_4_loop
+
+	add	d3,d2
+	beq	memmove_4_no_remainder
+
+memmove_4_remainder:
+	# cut 4-7 words down to 0-3
+	cmp	+16,d2
+	bcs	memmove_4_three_or_fewer_words
+	mov	(a1),d0
+	sub_sub	+4,a1,+4,a0
+	mov	d0,(a0)
+	mov	(a1),d1
+	sub_sub	+4,a1,+4,a0
+	mov	d1,(a0)
+	mov	(a1),e0
+	sub_sub	+4,a1,+4,a0
+	mov	e0,(a0)
+	mov	(a1),e1
+	sub_sub	+4,a1,+4,a0
+	mov	e1,(a0)
+	add	-16,d2
+	beq	memmove_4_no_remainder
+
+	# copy the remaining 1, 2 or 3 words
+memmove_4_three_or_fewer_words:
+	cmp	+8,d2
+	bcs	memmove_4_one_word
+	beq	memmove_4_two_words
+	mov	(a1),d0
+	sub_sub	+4,a1,+4,a0
+	mov	d0,(a0)
+memmove_4_two_words:
+	mov	(a1),d0
+	sub_sub	+4,a1,+4,a0
+	mov	d0,(a0)
+memmove_4_one_word:
+	mov	(a1),d0
+	sub_sub	+4,a1,+4,a0
+	mov	d0,(a0)
+
+memmove_4_no_remainder:
+	sub	e3,a0,d2			# check we copied the correct amount
+	beq	memmove_done			// TODO: REMOVE CHECK
+	break
+	break
+	break
+
+memmove_done:
+	mov	e3,a0
+	ret	[d2,d3],8
+
+	# handle misaligned copying
+memmove_1:
+	add	-1,d2
+	mov	+1,d3
+	setlb					# setlb requires the next insns
+						# to occupy exactly 4 bytes
+
+	sub	d3,d2
+	movbu	(a1),d0
+	movbu	d0,(a0)
+	add_add	d3,a1,d3,a0
+	lcc
+
+	mov	e3,a0
+	ret	[d2,d3],8
+
+memmove_memcpy:
+	jmp	memcpy
+
+memmove_end:
+	.size	memmove, memmove_end-memmove
diff -puN /dev/null arch/mn10300/lib/memset.S
--- /dev/null
+++ a/arch/mn10300/lib/memset.S
@@ -0,0 +1,119 @@
+/* Optimised simple memory fill
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/cache.h>
+
+        .section .text
+        .balign	L1_CACHE_BYTES
+
+###############################################################################
+#
+# void *memset(void *dst, int c, size_t n)
+#
+###############################################################################
+	.globl	memset
+        .type	memset,@function
+memset:
+	movm	[d2,d3],(sp)
+	mov	d0,(12,sp)
+	mov	d1,(16,sp)
+	mov	(20,sp),d2			# count
+	mov	d0,a0				# dst
+	mov	d0,e3				# the return value
+
+	cmp	+0,d2
+	beq	memset_done			# return if zero-length fill
+
+	# see if the region parameters are four-byte aligned
+	or	d0,d2,d3
+	and	+3,d3
+	bne	memset_1			# jump if not
+
+	extbu	d1
+	mov_asl	d1,d3,8,d1
+	or_asl	d1,d3,8,d1
+	or_asl	d1,d3,8,d1
+	or	d3,d1
+	
+	# we want to transfer as much as we can in chunks of 32 bytes
+	cmp	+31,d2
+	bls	memset_4_remainder		# 4-byte aligned remainder
+
+	add	-32,d2
+	mov	+32,d3
+
+memset_4_loop:
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+
+	sub	d3,d2
+	bcc	memset_4_loop
+
+	add	d3,d2
+	beq	memset_4_no_remainder
+
+memset_4_remainder:
+	# cut 4-7 words down to 0-3
+	cmp	+16,d2
+	bcs	memset_4_three_or_fewer_words
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+	mov	d1,(a0+)
+	add	-16,d2
+	beq	memset_4_no_remainder
+
+	# copy the remaining 1, 2 or 3 words
+memset_4_three_or_fewer_words:
+	cmp	+8,d2
+	bcs	memset_4_one_word
+	beq	memset_4_two_words
+	mov	d1,(a0+)
+memset_4_two_words:
+	mov	d1,(a0+)
+memset_4_one_word:
+	mov	d1,(a0+)
+
+memset_4_no_remainder:
+	sub	e3,a0,d2			# check we set the correct amount
+	mov	(20,sp),d1			// TODO: REMOVE CHECK
+	cmp	d2,d1
+	beq	memset_done
+	break
+	break
+	break
+	
+memset_done:
+	mov	e3,a0
+	ret	[d2,d3],8
+
+	# handle misaligned copying
+memset_1:
+	add	-1,d2
+	mov	+1,d3
+	setlb					# setlb requires the next insns
+						# to occupy exactly 4 bytes
+
+	sub	d3,d2
+	movbu	d1,(a0)
+	inc	a0
+	lcc
+
+	mov	e3,a0
+	ret	[d2,d3],8
+
+memset_end:
+	.size	memset, memset_end-memset
diff -puN /dev/null arch/mn10300/lib/negdi2.c
--- /dev/null
+++ a/arch/mn10300/lib/negdi2.c
@@ -0,0 +1,58 @@
+/* More subroutines needed by GCC output code on some machines.  */
+/* Compile this one with gcc.  */
+/* Copyright (C) 1989, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
+   2000, 2001  Free Software Foundation, Inc.
+
+This file is part of GNU CC.
+
+GNU CC is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public Licence as published by
+the Free Software Foundation; either version 2, or (at your option)
+any later version.
+
+In addition to the permissions in the GNU General Public Licence, the
+Free Software Foundation gives you unlimited permission to link the
+compiled version of this file into combinations with other programs,
+and to distribute those combinations without any restriction coming
+from the use of this file.  (The General Public Licence restrictions
+do apply in other respects; for example, they cover modification of
+the file, and distribution when not linked into a combine
+executable.)
+
+GNU CC is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public Licence for more details.
+
+You should have received a copy of the GNU General Public Licence
+along with GNU CC; see the file COPYING.  If not, write to
+the Free Software Foundation, 59 Temple Place - Suite 330,
+Boston, MA 02111-1307, USA.  */
+
+/* It is incorrect to include config.h here, because this file is being
+   compiled for the target, and hence definitions concerning only the host
+   do not apply.  */
+
+#include <linux/types.h>
+
+typedef union DWunion {
+	s64 ll;
+	struct {
+		s32 low;
+		s32 high;
+	} s;
+} DWunion;
+
+s64
+__negdi2 (s64 u)
+{
+  DWunion w;
+  DWunion uu;
+
+  uu.ll = u;
+
+  w.s.low = -uu.s.low;
+  w.s.high = -uu.s.high - ((u32) w.s.low > 0);
+
+  return w.ll;
+}
diff -puN /dev/null arch/mn10300/lib/usercopy.c
--- /dev/null
+++ a/arch/mn10300/lib/usercopy.c
@@ -0,0 +1,166 @@
+/* MN10300 Userspace accessor functions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/uaccess.h>
+
+unsigned long
+__generic_copy_to_user(void *to, const void *from, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		__copy_user(to,from,n);
+	return n;
+}
+
+unsigned long
+__generic_copy_from_user(void *to, const void *from, unsigned long n)
+{
+	if (access_ok(VERIFY_READ, from, n))
+		__copy_user_zeroing(to,from,n);
+	return n;
+}
+
+/*
+ * Copy a null terminated string from userspace.
+ */
+#define __do_strncpy_from_user(dst,src,count,res)		\
+do {								\
+	int w;							\
+	asm volatile(						\
+		"	mov	%1,%0\n"			\
+		"	cmp	0,%1\n"				\
+		"	beq	2f\n"				\
+		"0:\n"						\
+		"	movbu	(%5),%2\n"			\
+		"1:\n"						\
+		"	movbu	%2,(%6)\n"			\
+		"	inc	%5\n"				\
+		"	inc	%6\n"				\
+		"	cmp	0,%2\n"				\
+		"	beq	2f\n"				\
+		"	add	-1,%1\n"			\
+		"	bne	0b\n"				\
+		"2:\n"						\
+		"	sub	%1,%0\n"			\
+		"3:\n"						\
+		"	.section .fixup,\"ax\"\n"		\
+		"4:\n"						\
+		"	mov	%3,%0\n"			\
+		"	jmp	3b\n"				\
+		"	.previous\n"				\
+		"	.section __ex_table,\"a\"\n"		\
+		"	.balign 4\n"				\
+		"	.long 0b,4b\n"				\
+		"	.long 1b,4b\n"				\
+		"	.previous"				\
+		:"=&r"(res), "=r"(count), "=&r"(w)		\
+		:"i"(-EFAULT), "1"(count), "a"(src), "a"(dst)	\
+		:"memory");					\
+} while(0)
+
+long
+__strncpy_from_user(char *dst, const char *src, long count)
+{
+	long res;
+	__do_strncpy_from_user(dst, src, count, res);
+	return res;
+}
+
+long
+strncpy_from_user(char *dst, const char *src, long count)
+{
+	long res = -EFAULT;
+	if (access_ok(VERIFY_READ, src, 1))
+		__do_strncpy_from_user(dst, src, count, res);
+	return res;
+}
+
+
+/*
+ * Clear a userspace memory
+ */
+#define __do_clear_user(addr, size)		\
+do {						\
+	int w;					\
+  	asm volatile(				\
+		"	cmp 0,%0\n"		\
+		"	beq 1f\n"		\
+		"	clr %1\n"		\
+		"0:	movbu %1,(%3,%2)\n"	\
+		"	inc %3\n"		\
+		"	cmp %0,%3\n"		\
+		"	bne 0b\n"		\
+		"1:\n"				\
+		"	sub %3,%0\n"		\
+		"2:\n"				\
+		".section .fixup,\"ax\"\n"	\
+		"3:	jmp 2b\n"		\
+                ".previous\n"			\
+                ".section __ex_table,\"a\"\n"	\
+                "       .balign 4\n"		\
+                "       .long 0b,3b\n"		\
+                ".previous\n"			\
+		: "+r"(size), "=&r"(w)		\
+		: "a"(addr), "d"(0)		\
+		: "memory");			\
+} while (0)
+
+unsigned long
+__clear_user(void *to, unsigned long n)
+{
+	__do_clear_user(to, n);
+	return n;
+}
+
+unsigned long
+clear_user(void *to, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		__do_clear_user(to, n);
+	return n;
+}
+
+/*
+ * Return the size of a string (including the ending 0)
+ *
+ * Return 0 on exception, a value greater than N if too long
+ */
+long strnlen_user(const char *s, long n)
+{
+	unsigned long res,w;
+
+        if (!__addr_ok(s))
+		return 0;
+
+	if (n<0 || n+(u_long)s > current_thread_info()->addr_limit.seg)
+		n = current_thread_info()->addr_limit.seg - (u_long)s;
+
+	asm volatile(
+		"0:	cmp %4,%0\n"
+		"	beq 2f\n"
+		"1:	movbu (%0,%3),%1\n"
+		"	inc %0\n"
+		"	cmp 0,%1\n"
+		"	beq 3f\n"
+		"	bra 0b\n"
+		"2:	clr %0\n"
+		"3:\n"
+		".section .fixup,\"ax\"\n"
+		"4:	jmp 2b\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.balign 4\n"
+		"	.long 1b,4b\n"
+		".previous\n"
+		:"=d"(res), "=&r"(w)
+                :"0"(0), "a"(s), "r"(n)
+		:"memory");
+	return res;
+}
diff -puN /dev/null arch/mn10300/Makefile
--- /dev/null
+++ a/arch/mn10300/Makefile
@@ -0,0 +1,135 @@
+###############################################################################
+#
+# MN10300 Kernel makefile system specifications
+#
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Modified by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+
+KBUILD_DEFCONFIG := asb2303_defconfig
+
+CCSPECS	:= $(shell $(CC) -v 2>&1 | grep "^Reading specs from " | head -1 | cut -c20-)
+CCDIR	:= $(strip $(patsubst %/specs,%,$(CCSPECS)))
+KBUILD_CPPFLAGS += -nostdinc -I$(CCDIR)/include
+
+LDFLAGS		:=
+OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
+#LDFLAGS_vmlinux := -Map linkmap.txt
+CHECKFLAGS	+=
+
+PROCESSOR	:= unset
+UNIT		:= unset
+
+KBUILD_CFLAGS	+= -mam33 -mmem-funcs -DCPU=AM33
+KBUILD_AFLAGS	+= -mam33 -DCPU=AM33
+
+ifeq ($(CONFIG_MN10300_CURRENT_IN_E2),y)
+KBUILD_CFLAGS	+= -ffixed-e2 -fcall-saved-e5
+endif
+
+ifeq ($(CONFIG_MN10300_PROC_MN103E010),y)
+PROCESSOR	:= mn103e010
+endif
+
+ifeq ($(CONFIG_MN10300_UNIT_ASB2303),y)
+UNIT		:= asb2303
+endif
+ifeq ($(CONFIG_MN10300_UNIT_ASB2305),y)
+UNIT		:= asb2305
+endif
+
+
+head-y		:= arch/mn10300/kernel/head.o arch/mn10300/kernel/init_task.o
+
+core-y		+= arch/mn10300/kernel/ arch/mn10300/mm/
+
+ifneq ($(PROCESSOR),unset)
+core-y		+= arch/mn10300/proc-$(PROCESSOR)/
+endif
+ifneq ($(UNIT),unset)
+core-y		+= arch/mn10300/unit-$(UNIT)/
+endif
+libs-y		+= arch/mn10300/lib/
+
+drivers-$(CONFIG_OPROFILE)	+= arch/mn10300/oprofile/
+
+boot := arch/mn10300/boot
+
+.PHONY: zImage
+
+KBUILD_IMAGE := $(boot)/zImage
+CLEAN_FILES += $(boot)/zImage
+CLEAN_FILES += $(boot)/compressed/vmlinux
+CLEAN_FILES += $(boot)/compressed/vmlinux.bin
+CLEAN_FILES += $(boot)/compressed/vmlinux.bin.gz
+
+zImage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+all: zImage
+
+bootstrap:
+	$(Q)$(MAKEBOOT) bootstrap
+
+archclean:
+	$(Q)$(MAKE) $(clean)=arch/mn10300/proc-mn103e010
+	$(Q)$(MAKE) $(clean)=arch/mn10300/unit-asb2303
+	$(Q)$(MAKE) $(clean)=arch/mn10300/unit-asb2305
+
+define archhelp
+  echo  '* zImage        - Compressed kernel image (arch/$(ARCH)/boot/zImage)'
+endef
+
+# If you make sure the .S files get compiled with debug info,
+# uncomment the following to disable optimisations
+# that are unhelpful whilst debugging.
+ifdef CONFIG_DEBUG_INFO
+#KBUILD_CFLAGS	+= -O1
+KBUILD_AFLAGS	+= -Wa,--gdwarf2
+endif
+
+###################################################################################################
+#
+# juggle some symlinks in the MN10300 asm include dir
+#
+#	Update machine proc and unit symlinks if something which affects
+#	them changed.  We use .proc / .unit to indicate when they were
+#	updated last, otherwise make uses the target directory mtime.
+#
+###################################################################################################
+
+# processor specific definitions
+include/asm-mn10300/.proc: $(wildcard include/config/proc/*.h) include/config/auto.conf
+	@echo '  SYMLINK include/asm-mn10300/proc -> include/asm-mn10300/proc-$(PROCESSOR)'
+ifneq ($(KBUILD_SRC),)
+	$(Q)mkdir -p include/asm-mn10300
+	$(Q)ln -fsn $(srctree)/include/asm-mn10300/proc-$(PROCESSOR) include/asm-mn10300/proc
+else
+	$(Q)ln -fsn proc-$(PROCESSOR) include/asm-mn10300/proc
+endif
+	@touch $@
+
+CLEAN_FILES += include/asm-mn10300/proc include/asm-mn10300/.proc
+
+prepare: include/asm-mn10300/.proc
+
+# unit specific definitions
+include/asm-mn10300/.unit: $(wildcard include/config/unit/*.h) include/config/auto.conf
+	@echo '  SYMLINK include/asm-mn10300/unit -> include/asm-mn10300/unit-$(UNIT)'
+ifneq ($(KBUILD_SRC),)
+	$(Q)mkdir -p include/asm-mn10300
+	$(Q)ln -fsn $(srctree)/include/asm-mn10300/unit-$(UNIT) include/asm-mn10300/unit
+else
+	$(Q)ln -fsn unit-$(UNIT) include/asm-mn10300/unit
+endif
+	@touch $@
+
+CLEAN_FILES += include/asm-mn10300/unit include/asm-mn10300/.unit
+
+prepare: include/asm-mn10300/.unit
diff -puN /dev/null arch/mn10300/mm/cache.c
--- /dev/null
+++ a/arch/mn10300/mm/cache.c
@@ -0,0 +1,123 @@
+/* MN10300 Cache flushing routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/threads.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/cacheflush.h>
+#include <asm/io.h>
+#include <asm/uaccess.h>
+
+EXPORT_SYMBOL(mn10300_icache_inv);
+EXPORT_SYMBOL(mn10300_dcache_inv);
+EXPORT_SYMBOL(mn10300_dcache_inv_range);
+EXPORT_SYMBOL(mn10300_dcache_inv_range2);
+EXPORT_SYMBOL(mn10300_dcache_inv_page);
+
+#ifdef CONFIG_MN10300_CACHE_WBACK
+EXPORT_SYMBOL(mn10300_dcache_flush);
+EXPORT_SYMBOL(mn10300_dcache_flush_inv);
+EXPORT_SYMBOL(mn10300_dcache_flush_inv_range);
+EXPORT_SYMBOL(mn10300_dcache_flush_inv_range2);
+EXPORT_SYMBOL(mn10300_dcache_flush_inv_page);
+EXPORT_SYMBOL(mn10300_dcache_flush_range);
+EXPORT_SYMBOL(mn10300_dcache_flush_range2);
+EXPORT_SYMBOL(mn10300_dcache_flush_page);
+#endif
+
+/*
+ * write a page back from the dcache and invalidate the icache so that we can
+ * run code from it that we've just written into it
+ */
+void flush_icache_page(struct vm_area_struct *vma, struct page *page)
+{
+	mn10300_dcache_flush_page(page_to_phys(page));
+	mn10300_icache_inv();
+}
+
+EXPORT_SYMBOL(flush_icache_page);
+
+/*
+ * write some code we've just written back from the dcache and invalidate the
+ * icache so that we can run that code
+ */
+void flush_icache_range(unsigned long start, unsigned long end)
+{
+#ifdef CONFIG_MN10300_CACHE_WBACK
+	unsigned long addr, size, off;
+	struct page *page;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ppte, pte;
+
+	for (; start < end; start += size) {
+		/* work out how much of the page to flush */
+		off = start & (PAGE_SIZE - 1);
+
+		size = end - start;
+		if (size > PAGE_SIZE - off)
+			size = PAGE_SIZE - off;
+
+		/* get the physical address the page is mapped to from the page
+		 * tables */
+		pgd = pgd_offset(current->mm, start);
+		if (!pgd || !pgd_val(*pgd))
+			continue;
+
+		pud = pud_offset(pgd, start);
+		if (!pud || !pud_val(*pud))
+			continue;
+
+		pmd = pmd_offset(pud, start);
+		if (!pmd || !pmd_val(*pmd))
+			continue;
+
+		ppte = pte_offset_map(pmd, start);
+		if (!ppte)
+			continue;
+		pte = *ppte;
+		pte_unmap(ppte);
+
+		if (pte_none(pte))
+			continue;
+
+		page = pte_page(pte);
+		if (!page)
+			continue;
+
+		addr = page_to_phys(page);
+
+		/* flush the dcache and invalidate the icache coverage on that
+		 * region */
+		mn10300_dcache_flush_range2(addr + off, size);
+	}
+#endif
+
+	mn10300_icache_inv();
+}
+
+EXPORT_SYMBOL(flush_icache_range);
+
+/*
+ * allow userspace to flush the instruction cache
+ */
+asmlinkage long sys_cacheflush(unsigned long start, unsigned long end)
+{
+	if (end < start)
+		return -EINVAL;
+
+	flush_icache_range(start, end);
+	return 0;
+}
diff -puN /dev/null arch/mn10300/mm/cache-flush-mn10300.S
--- /dev/null
+++ a/arch/mn10300/mm/cache-flush-mn10300.S
@@ -0,0 +1,182 @@
+/* MN10300 CPU core caching routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/page.h>
+#include <asm/cache.h>
+
+	.am33_2
+	.globl mn10300_dcache_flush
+	.globl mn10300_dcache_flush_page
+	.globl mn10300_dcache_flush_range
+	.globl mn10300_dcache_flush_range2
+	.globl mn10300_dcache_flush_inv
+	.globl mn10300_dcache_flush_inv_page
+	.globl mn10300_dcache_flush_inv_range
+	.globl mn10300_dcache_flush_inv_range2
+
+###################################################################################################
+#
+# void mn10300_dcache_flush(void)
+# Flush the entire data cache back to RAM
+#
+###################################################################################################
+	ALIGN
+mn10300_dcache_flush:
+	movhu	(CHCTR),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_dcache_flush_end
+
+	# read the addresses tagged in the cache's tag RAM and attempt to flush
+	# those addresses specifically
+	# - we rely on the hardware to filter out invalid tag entry addresses
+	mov	DCACHE_TAG(0,0),a0		# dcache tag RAM access address
+	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
+	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1	# total number of entries
+
+mn10300_dcache_flush_loop:
+	mov	(a0),d0
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0
+	or	L1_CACHE_TAG_VALID,d0		# retain valid entries in the cache
+	mov	d0,(a1)				# conditional purge
+
+mn10300_dcache_flush_skip:
+	add	L1_CACHE_BYTES,a0
+	add	L1_CACHE_BYTES,a1
+	add	-1,d1
+	bne	mn10300_dcache_flush_loop
+
+mn10300_dcache_flush_end:
+	ret	[],0
+
+###################################################################################################
+#
+# void mn10300_dcache_flush_page(unsigned start)
+# void mn10300_dcache_flush_range(unsigned start, unsigned end)
+# void mn10300_dcache_flush_range2(unsigned start, unsigned size)
+# Flush a range of addresses on a page in the dcache
+#
+###################################################################################################
+	ALIGN
+mn10300_dcache_flush_page:
+	mov	PAGE_SIZE,d1
+mn10300_dcache_flush_range2:
+	add	d0,d1
+mn10300_dcache_flush_range:
+	movm	[d2,d3],(sp)
+
+	movhu	(CHCTR),d2
+	btst	CHCTR_DCEN,d2
+	beq	mn10300_dcache_flush_range_end
+
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start addr down
+	mov	d0,a1
+
+	add	L1_CACHE_BYTES,d1			# round end addr up
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
+
+	# write a request to flush all instances of an address from the cache
+	mov	DCACHE_PURGE(0,0),a0
+	mov	a1,d0
+	and	L1_CACHE_TAG_ENTRY,d0
+	add	d0,a0				# starting dcache purge control reg address
+
+	sub	a1,d1
+	lsr	L1_CACHE_SHIFT,d1		# total number of entries to examine
+
+	or	L1_CACHE_TAG_VALID,a1		# retain valid entries in the cache
+
+mn10300_dcache_flush_range_loop:
+	mov	a1,(L1_CACHE_WAYDISP*0,a0)	# conditionally purge this line all ways
+
+	add	L1_CACHE_BYTES,a0
+	add	L1_CACHE_BYTES,a1
+	and	~L1_CACHE_WAYDISP,a0		# make sure way stay on way 0
+	add	-1,d1
+	bne	mn10300_dcache_flush_range_loop
+
+mn10300_dcache_flush_range_end:
+	ret	[d2,d3],8
+
+###################################################################################################
+#
+# void mn10300_dcache_flush_inv(void)
+# Flush the entire data cache and invalidate all entries
+#
+###################################################################################################
+	ALIGN
+mn10300_dcache_flush_inv:
+	movhu	(CHCTR),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_dcache_flush_inv_end
+
+	# hit each line in the dcache with an unconditional purge
+	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
+	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1	# total number of entries
+
+mn10300_dcache_flush_inv_loop:
+	mov	(a1),d0				# unconditional purge
+
+	add	L1_CACHE_BYTES,a1
+	add	-1,d1
+	bne	mn10300_dcache_flush_inv_loop
+
+mn10300_dcache_flush_inv_end:
+	ret	[],0
+
+###################################################################################################
+#
+# void mn10300_dcache_flush_inv_page(unsigned start)
+# void mn10300_dcache_flush_inv_range(unsigned start, unsigned end)
+# void mn10300_dcache_flush_inv_range2(unsigned start, unsigned size)
+# Flush and invalidate a range of addresses on a page in the dcache
+#
+###################################################################################################
+	ALIGN
+mn10300_dcache_flush_inv_page:
+	mov	PAGE_SIZE,d1
+mn10300_dcache_flush_inv_range2:
+	add	d0,d1
+mn10300_dcache_flush_inv_range:
+	movm	[d2,d3],(sp)
+	movhu	(CHCTR),d2
+	btst	CHCTR_DCEN,d2
+	beq	mn10300_dcache_flush_inv_range_end
+
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start addr down
+	mov	d0,a1
+
+	add	L1_CACHE_BYTES,d1			# round end addr up
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
+
+	# write a request to flush and invalidate all instances of an address
+	# from the cache
+	mov	DCACHE_PURGE(0,0),a0
+	mov	a1,d0
+	and	L1_CACHE_TAG_ENTRY,d0
+	add	d0,a0				# starting dcache purge control reg address
+
+	sub	a1,d1
+	lsr	L1_CACHE_SHIFT,d1		# total number of entries to examine
+
+mn10300_dcache_flush_inv_range_loop:
+	mov	a1,(L1_CACHE_WAYDISP*0,a0)	# conditionally purge this line in all ways
+
+	add	L1_CACHE_BYTES,a0
+	add	L1_CACHE_BYTES,a1
+	and	~L1_CACHE_WAYDISP,a0		# make sure way stay on way 0
+	add	-1,d1
+	bne	mn10300_dcache_flush_inv_range_loop
+
+mn10300_dcache_flush_inv_range_end:
+	ret	[d2,d3],8
diff -puN /dev/null arch/mn10300/mm/cache-mn10300.S
--- /dev/null
+++ a/arch/mn10300/mm/cache-mn10300.S
@@ -0,0 +1,280 @@
+/* MN10300 CPU core caching routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/page.h>
+#include <asm/cache.h>
+
+#define mn10300_dcache_inv_range_intr_interval \
+	+((1 << MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL) - 1)
+
+#if mn10300_dcache_inv_range_intr_interval > 0xff
+#error MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL must be 8 or less
+#endif
+
+	.am33_2
+
+	.globl mn10300_icache_inv
+	.globl mn10300_dcache_inv
+	.globl mn10300_dcache_inv_range
+	.globl mn10300_dcache_inv_range2
+	.globl mn10300_dcache_inv_page
+
+###################################################################################################
+#
+# void mn10300_icache_inv(void)
+# Invalidate the entire icache
+#
+###################################################################################################
+	ALIGN
+mn10300_icache_inv:
+	mov	CHCTR,a0
+
+	movhu	(a0),d0
+	btst	CHCTR_ICEN,d0
+	beq	mn10300_icache_inv_end
+
+	mov	epsw,d1
+	and	~EPSW_IE,epsw
+	nop
+	nop
+
+	# disable the icache
+	and	~CHCTR_ICEN,d0
+	movhu	d0,(a0)
+
+	# and wait for it to calm down
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_ICBUSY,d0
+	lne
+
+	# invalidate
+	or	CHCTR_ICINV,d0
+	movhu	d0,(a0)
+
+	# wait for the cache to finish
+	mov	CHCTR,a0
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_ICBUSY,d0
+	lne
+
+	# and reenable it
+	and	~CHCTR_ICINV,d0
+	or	CHCTR_ICEN,d0
+	movhu	d0,(a0)
+	movhu	(a0),d0
+
+	mov	d1,epsw
+
+mn10300_icache_inv_end:
+	ret	[],0
+
+###################################################################################################
+#
+# void mn10300_dcache_inv(void)
+# Invalidate the entire dcache
+#
+###################################################################################################
+	ALIGN
+mn10300_dcache_inv:
+	mov	CHCTR,a0
+
+	movhu	(a0),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_dcache_inv_end
+
+	mov	epsw,d1
+	and	~EPSW_IE,epsw
+	nop
+	nop
+
+	# disable the dcache
+	and	~CHCTR_DCEN,d0
+	movhu	d0,(a0)
+
+	# and wait for it to calm down
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_DCBUSY,d0
+	lne
+
+	# invalidate
+	or	CHCTR_DCINV,d0
+	movhu	d0,(a0)
+
+	# wait for the cache to finish
+	mov	CHCTR,a0
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_DCBUSY,d0
+	lne
+
+	# and reenable it
+	and	~CHCTR_DCINV,d0
+	or	CHCTR_DCEN,d0
+	movhu	d0,(a0)
+	movhu	(a0),d0
+
+	mov	d1,epsw
+
+mn10300_dcache_inv_end:
+	ret	[],0
+
+###################################################################################################
+#
+# void mn10300_dcache_inv_range(unsigned start, unsigned end)
+# void mn10300_dcache_inv_range2(unsigned start, unsigned size)
+# void mn10300_dcache_inv_page(unsigned start)
+# Invalidate a range of addresses on a page in the dcache
+#
+###################################################################################################
+	ALIGN
+mn10300_dcache_inv_page:
+	mov	PAGE_SIZE,d1
+mn10300_dcache_inv_range2:
+	add	d0,d1
+mn10300_dcache_inv_range:
+	movm	[d2,d3,a2],(sp)
+	mov	CHCTR,a2
+
+	movhu	(a2),d2
+	btst	CHCTR_DCEN,d2
+	beq	mn10300_dcache_inv_range_end
+
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start addr down
+	mov	d0,a1
+
+	add	L1_CACHE_BYTES,d1			# round end addr up
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
+
+	clr	d2				# we're going to clear tag ram entries
+
+	# read the tags from the tag RAM, and if they indicate a valid dirty
+	# cache line then invalidate that line
+	mov	DCACHE_TAG(0,0),a0
+	mov	a1,d0
+	and	L1_CACHE_TAG_ENTRY,d0
+	add	d0,a0				# starting dcache tag RAM access address
+
+	sub	a1,d1
+	lsr	L1_CACHE_SHIFT,d1		# total number of entries to examine
+
+	and	~(L1_CACHE_DISPARITY-1),a1	# determine comparator base
+
+mn10300_dcache_inv_range_outer_loop:
+	# disable interrupts
+	mov	epsw,d3
+	and	~EPSW_IE,epsw
+	nop					# note that reading CHCTR and AND'ing D0
+						# occupy two delay slots after disabling
+						# interrupts
+
+	# disable the dcache
+	movhu	(a2),d0
+	and	~CHCTR_DCEN,d0
+	movhu	d0,(a2)
+
+	# and wait for it to calm down
+	setlb
+	movhu	(a2),d0
+	btst	CHCTR_DCBUSY,d0
+	lne
+
+mn10300_dcache_inv_range_loop:
+
+	# process the way 0 slot
+	mov	(L1_CACHE_WAYDISP*0,a0),d0	# read the tag in the way 0 slot
+	btst	L1_CACHE_TAG_VALID,d0
+	beq	mn10300_dcache_inv_range_skip_0	# jump if this cacheline is not valid
+
+	xor	a1,d0
+	lsr	12,d0
+	bne	mn10300_dcache_inv_range_skip_0	# jump if not this cacheline
+
+	mov	d2,(a0)				# kill the tag
+
+mn10300_dcache_inv_range_skip_0:
+
+	# process the way 1 slot
+	mov	(L1_CACHE_WAYDISP*1,a0),d0	# read the tag in the way 1 slot
+	btst	L1_CACHE_TAG_VALID,d0
+	beq	mn10300_dcache_inv_range_skip_1	# jump if this cacheline is not valid
+
+	xor	a1,d0
+	lsr	12,d0
+	bne	mn10300_dcache_inv_range_skip_1	# jump if not this cacheline
+
+	mov	d2,(a0)				# kill the tag
+
+mn10300_dcache_inv_range_skip_1:
+
+	# process the way 2 slot
+	mov	(L1_CACHE_WAYDISP*2,a0),d0	# read the tag in the way 2 slot
+	btst	L1_CACHE_TAG_VALID,d0
+	beq	mn10300_dcache_inv_range_skip_2	# jump if this cacheline is not valid
+
+	xor	a1,d0
+	lsr	12,d0
+	bne	mn10300_dcache_inv_range_skip_2	# jump if not this cacheline
+
+	mov	d2,(a0)				# kill the tag
+
+mn10300_dcache_inv_range_skip_2:
+
+	# process the way 3 slot
+	mov	(L1_CACHE_WAYDISP*3,a0),d0	# read the tag in the way 3 slot
+	btst	L1_CACHE_TAG_VALID,d0
+	beq	mn10300_dcache_inv_range_skip_3	# jump if this cacheline is not valid
+
+	xor	a1,d0
+	lsr	12,d0
+	bne	mn10300_dcache_inv_range_skip_3	# jump if not this cacheline
+
+	mov	d2,(a0)				# kill the tag
+
+mn10300_dcache_inv_range_skip_3:
+
+	# approx every N steps we re-enable the cache and see if there are any
+	# interrupts to be processed
+	# we also break out if we've reached the end of the loop
+	# (the bottom nibble of the count is zero in both cases)
+	add	L1_CACHE_BYTES,a0
+	add	L1_CACHE_BYTES,a1
+	add	-1,d1
+	btst	mn10300_dcache_inv_range_intr_interval,d1
+	bne	mn10300_dcache_inv_range_loop
+
+	# wait for the cache to finish what it's doing
+	setlb
+	movhu	(a2),d0
+	btst	CHCTR_DCBUSY,d0
+	lne
+
+	# and reenable it
+	or	CHCTR_DCEN,d0
+	movhu	d0,(a2)
+	movhu	(a2),d0
+
+	# re-enable interrupts
+	# - we don't bother with delay NOPs as we'll have enough instructions
+	#   before we disable interrupts again to give the interrupts a chance
+	#   to happen
+	mov	d3,epsw
+
+	# go around again if the counter hasn't yet reached zero
+	add	0,d1
+	bne	mn10300_dcache_inv_range_outer_loop
+
+mn10300_dcache_inv_range_end:
+	ret	[d2,d3,a2],12
diff -puN /dev/null arch/mn10300/mm/dma-alloc.c
--- /dev/null
+++ a/arch/mn10300/mm/dma-alloc.c
@@ -0,0 +1,56 @@
+/* MN10300 Dynamic DMA mapping support
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * Derived from: arch/i386/kernel/pci-dma.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/pci.h>
+#include <asm/io.h>
+
+void *dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle, int gfp)
+{
+	unsigned long addr;
+	void *ret;
+
+	/* ignore region specifiers */
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
+
+	if (dev == NULL || dev->coherent_dma_mask < 0xffffffff)
+		gfp |= GFP_DMA;
+
+	addr = __get_free_pages(gfp, get_order(size));
+	if (!addr)
+		return NULL;
+
+	/* map the coherent memory through the uncached memory window */
+	ret = (void *) (addr | 0x20000000);
+
+	/* fill the memory with obvious rubbish */
+	memset((void *) addr, 0xfb, size);
+
+	/* write back and evict all cache lines covering this region */
+	mn10300_dcache_flush_inv_range2(virt_to_phys((void *) addr), PAGE_SIZE);
+
+	*dma_handle = virt_to_bus((void *) addr);
+	return ret;
+}
+
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+void dma_free_coherent(struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle)
+{
+	unsigned long addr = (unsigned long) vaddr & ~0x20000000;
+
+	free_pages(addr, get_order(size));
+}
+
+EXPORT_SYMBOL(dma_free_coherent);
diff -puN /dev/null arch/mn10300/mm/extable.c
--- /dev/null
+++ a/arch/mn10300/mm/extable.c
@@ -0,0 +1,26 @@
+/* MN10300 In-kernel exception handling
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <asm/uaccess.h>
+
+int fixup_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+
+	fixup = search_exception_tables(regs->pc);
+	if (fixup) {
+		regs->pc = fixup->fixup;
+		return 1;
+	}
+
+	return 0;
+}
diff -puN /dev/null arch/mn10300/mm/fault.c
--- /dev/null
+++ a/arch/mn10300/mm/fault.c
@@ -0,0 +1,396 @@
+/* MN10300 MMU Fault handler
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/vt_kern.h>		/* For unblank_screen() */
+
+#include <asm/system.h>
+#include <asm/uaccess.h>
+#include <asm/pgalloc.h>
+#include <asm/hardirq.h>
+#include <asm/gdb-stub.h>
+#include <asm/cpu-regs.h>
+
+extern int console_loglevel;
+
+/*
+ * Unlock any spinlocks which will prevent us from getting the
+ * message out
+ */
+void bust_spinlocks(int yes)
+{
+	if (yes) {
+		oops_in_progress = 1;
+#ifdef CONFIG_SMP
+		global_irq_lock = 0;	/* Many serial drivers do __global_cli() */
+#endif
+	} else {
+		int loglevel_save = console_loglevel;
+#ifdef CONFIG_VT
+		unblank_screen();
+#endif
+		oops_in_progress = 0;
+		/*
+		 * OK, the message is on the console.  Now we call printk()
+		 * without oops_in_progress set so that printk will give klogd
+		 * a poke.  Hold onto your hats...
+		 */
+		console_loglevel = 15;		/* NMI oopser may have shut the console up */
+		printk(" ");
+		console_loglevel = loglevel_save;
+	}
+}
+
+void do_BUG(const char *file, int line)
+{
+	bust_spinlocks(1);
+	printk("------------[ cut here ]------------\n");
+	printk("kernel BUG at %s:%d!\n", file, line);
+}
+
+#if 0
+static void print_pagetable_entries (pgd_t *pgdir, unsigned long address)
+{
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = pgdir + __pgd_offset(address);
+	printk("pgd entry %p: %016Lx\n", pgd, (long long)pgd_val(*pgd));
+
+	if (!pgd_present(*pgd)) {
+		printk("... pgd not present!\n");
+		return;
+	}
+	pmd = pmd_offset(pgd, address);
+	printk("pmd entry %p: %016Lx\n", pmd, (long long)pmd_val(*pmd));
+
+	if (!pmd_present(*pmd)) {
+		printk("... pmd not present!\n");
+		return;
+	}
+	pte = pte_offset(pmd, address);
+	printk("pte entry %p: %016Lx\n", pte, (long long)pte_val(*pte));
+
+	if (!pte_present(*pte))
+		printk("... pte not present!\n");
+}
+#endif
+
+asmlinkage void monitor_signal(struct pt_regs *);
+
+/*
+ * This routine handles page faults.  It determines the address,
+ * and the problem, and then passes it off to one of the appropriate
+ * routines.
+ *
+ * fault_code:
+ * - LSW: either MMUFCR_IFC or MMUFCR_DFC as appropriate
+ * - MSW: 0 if data access, 1 if instruction access
+ * - bit 0: TLB miss flag
+ * - bit 1: initial write
+ * - bit 2: page invalid
+ * - bit 3: protection violation
+ * - bit 4: accessor (0=user 1=kernel)
+ * - bit 5: 0=read 1=write
+ * - bit 6-8: page protection spec
+ * - bit 9: illegal address
+ * - bit 16: 0=data 1=ins
+ *
+ */
+asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long fault_code,
+			      unsigned long address)
+{
+	struct vm_area_struct *vma;
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	unsigned long page;
+	siginfo_t info;
+	int write, fault;
+
+#ifdef CONFIG_GDBSTUB
+	/* handle GDB stub causing a fault */
+	if (gdbstub_busy) {
+		gdbstub_exception(regs, TBR & TBR_INT_CODE);
+		return;
+	}
+#endif
+
+#if 0
+	printk("--- do_page_fault(%p,%s:%04lx,%08lx)\n",
+	       regs,
+	       fault_code&0x10000 ? "ins" : "data",
+	       fault_code&0xffff,address);
+#endif
+
+	tsk = current;
+
+	/*
+	 * We fault-in kernel-space virtual memory on-demand. The
+	 * 'reference' page table is init_mm.pgd.
+	 *
+	 * NOTE! We MUST NOT take any locks for this case. We may
+	 * be in an interrupt or a critical region, and should
+	 * only copy the information from the master page table,
+	 * nothing more.
+	 *
+	 * This verifies that the fault happens in kernel space
+	 * and that the fault was a page not present (invalid) error
+	 */
+	if (address >= VMALLOC_START && address < VMALLOC_END &&
+	    (fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_SR &&
+	    (fault_code & MMUFCR_xFC_PGINVAL) == MMUFCR_xFC_PGINVAL
+	    )
+		goto vmalloc_fault;
+
+	mm = tsk->mm;
+	info.si_code = SEGV_MAPERR;
+
+	/*
+	 * If we're in an interrupt or have no user
+	 * context, we must not take the fault..
+	 */
+	if (in_interrupt() || !mm)
+		goto no_context;
+
+	down_read(&mm->mmap_sem);
+
+	vma = find_vma(mm, address);
+	if (!vma)
+		goto bad_area;
+	if (vma->vm_start <= address)
+		goto good_area;
+	if (!(vma->vm_flags & VM_GROWSDOWN))
+		goto bad_area;
+
+        if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_USR) {
+                /*
+		 * accessing the stack below %esp is always a bug.
+		 * The "+ 32" is there due to some instructions (like
+		 * pusha) doing post-decrement on the stack and that
+		 * doesn't show up until later..
+		 */
+		if ((address & PAGE_MASK) + 2*PAGE_SIZE < regs->sp) {
+#if 0
+                	printk("[%d] ### Access below stack @%lx (sp=%lx)\n",
+			       current->pid,address,regs->sp);
+			printk("vma [%08x - %08x]\n", vma->vm_start, vma->vm_end);
+                 	show_registers(regs);
+                      	printk("[%d] ### Code: [%08lx] %02x %02x %02x %02x %02x %02x %02x %02x\n",
+                               current->pid,
+                               regs->pc,
+                               ((u8*)regs->pc)[0],
+                               ((u8*)regs->pc)[1],
+                               ((u8*)regs->pc)[2],
+                               ((u8*)regs->pc)[3],
+                               ((u8*)regs->pc)[4],
+                               ((u8*)regs->pc)[5],
+                               ((u8*)regs->pc)[6],
+                               ((u8*)regs->pc)[7]
+                               );
+#endif
+                        goto bad_area;
+        	}
+	}
+
+	if (expand_stack(vma, address))
+		goto bad_area;
+
+/*
+ * Ok, we have a good vm_area for this memory access, so
+ * we can handle it..
+ */
+good_area:
+	info.si_code = SEGV_ACCERR;
+	write = 0;
+	switch (fault_code & (MMUFCR_xFC_PGINVAL|MMUFCR_xFC_TYPE)) {
+	default:	/* 3: write, present */
+	case MMUFCR_xFC_TYPE_WRITE:
+#ifdef TEST_VERIFY_AREA
+		if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_SR)
+			printk("WP fault at %08lx\n", regs->pc);
+#endif
+		/* fall through */
+	case MMUFCR_xFC_PGINVAL | MMUFCR_xFC_TYPE_WRITE: /* write to absent page */
+		if (!(vma->vm_flags & VM_WRITE))
+			goto bad_area;
+		write++;
+		break;
+
+	case MMUFCR_xFC_TYPE_READ: /* read from protected page */
+		goto bad_area;
+
+	case MMUFCR_xFC_PGINVAL | MMUFCR_xFC_TYPE_READ: /* read from absent page present */
+		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
+			goto bad_area;
+		break;
+	}
+
+	/*
+	 * If for any reason at all we couldn't handle the fault,
+	 * make sure we exit gracefully rather than endlessly redo
+	 * the fault.
+	 */
+	fault = handle_mm_fault(mm, vma, address, write);
+	if (unlikely(fault & VM_FAULT_ERROR)) {
+		if (fault & VM_FAULT_OOM)
+			goto out_of_memory;
+		else if (fault & VM_FAULT_SIGBUS)
+			goto do_sigbus;
+		BUG();
+	}
+	if (fault & VM_FAULT_MAJOR)
+		current->maj_flt++;
+	else
+		current->min_flt++;
+
+	up_read(&mm->mmap_sem);
+	return;
+
+/*
+ * Something tried to access memory that isn't in our memory map..
+ * Fix it, but check if it's kernel or user first..
+ */
+bad_area:
+	up_read(&mm->mmap_sem);
+	monitor_signal(regs);
+
+	/* User mode accesses just cause a SIGSEGV */
+	if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_USR) {
+		info.si_signo = SIGSEGV;
+		info.si_errno = 0;
+		/* info.si_code has been set above */
+		info.si_addr = (void *)address;
+		force_sig_info(SIGSEGV, &info, tsk);
+		return;
+	}
+
+no_context:
+	monitor_signal(regs);
+	/* Are we prepared to handle this kernel fault?  */
+	if (fixup_exception(regs))
+		return;
+
+/*
+ * Oops. The kernel tried to access some bad page. We'll have to
+ * terminate things with extreme prejudice.
+ */
+
+	bust_spinlocks(1);
+
+	if (address < PAGE_SIZE)
+		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
+	else
+		printk(KERN_ALERT "Unable to handle kernel paging request");
+	printk(" at virtual address %08lx\n",address);
+	printk(" printing pc:\n");
+	printk("%08lx\n", regs->pc);
+
+#ifdef CONFIG_GDBSTUB
+	gdbstub_intercept(regs,fault_code&0x00010000 ? EXCEP_IAERROR : EXCEP_DAERROR);
+#endif
+
+	page = PTBR;
+	page = ((unsigned long *) __va(page))[address >> 22];
+	printk(KERN_ALERT "*pde = %08lx\n", page);
+	if (page & 1) {
+		page &= PAGE_MASK;
+		address &= 0x003ff000;
+		page = ((unsigned long *) __va(page))[address >> PAGE_SHIFT];
+		printk(KERN_ALERT "*pte = %08lx\n", page);
+	}
+
+	die("Oops", regs, fault_code);
+	do_exit(SIGKILL);
+
+/*
+ * We ran out of memory, or some other thing happened to us that made
+ * us unable to handle the page fault gracefully.
+ */
+out_of_memory:
+	up_read(&mm->mmap_sem);
+	monitor_signal(regs);
+	printk("VM: killing process %s\n", tsk->comm);
+	if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_USR)
+		do_exit(SIGKILL);
+	goto no_context;
+
+do_sigbus:
+	up_read(&mm->mmap_sem);
+	monitor_signal(regs);
+
+	/*
+	 * Send a sigbus, regardless of whether we were in kernel
+	 * or user mode.
+	 */
+	info.si_signo = SIGBUS;
+	info.si_errno = 0;
+	info.si_code = BUS_ADRERR;
+	info.si_addr = (void *)address;
+	force_sig_info(SIGBUS, &info, tsk);
+
+	/* Kernel mode? Handle exceptions or die */
+	if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_SR)
+		goto no_context;
+	return;
+
+vmalloc_fault:
+	{
+		/*
+		 * Synchronize this task's top level page-table
+		 * with the 'reference' page table.
+		 *
+		 * Do _not_ use "tsk" here. We might be inside
+		 * an interrupt in the middle of a task switch..
+		 */
+		int index = pgd_index(address);
+		pgd_t *pgd, *pgd_k;
+		pud_t *pud, *pud_k;
+		pmd_t *pmd, *pmd_k;
+		pte_t *pte_k;
+
+		pgd_k = init_mm.pgd + index;
+
+		if (!pgd_present(*pgd_k))
+			goto no_context;
+
+		pud_k = pud_offset(pgd_k, address);
+		if (!pud_present(*pud_k))
+			goto no_context;
+
+		pmd_k = pmd_offset(pud_k, address);
+		if (!pmd_present(*pmd_k))
+			goto no_context;
+
+		pgd = (pgd_t *) PTBR + index;
+		pud = pud_offset(pgd, address);
+		pmd = pmd_offset(pud, address);
+		set_pmd(pmd, *pmd_k);
+
+		pte_k = pte_offset_kernel(pmd_k, address);
+		if (!pte_present(*pte_k))
+			goto no_context;
+		return;
+	}
+}
diff -puN /dev/null arch/mn10300/mm/init.c
--- /dev/null
+++ a/arch/mn10300/mm/init.c
@@ -0,0 +1,157 @@
+/* MN10300 Memory management initialisation
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/initrd.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/bootmem.h>
+
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/dma.h>
+#include <asm/tlb.h>
+#include <asm/sections.h>
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+unsigned long highstart_pfn, highend_pfn;
+
+/*
+ * set up paging
+ */
+void __init paging_init(void)
+{
+	unsigned long zones_size[MAX_NR_ZONES] = {0,};
+	pte_t *ppte;
+	int loop;
+
+	/* main kernel space -> RAM mapping is handled as 1:1 transparent by MMU */
+	memset(swapper_pg_dir, 0, sizeof(swapper_pg_dir));
+	memset(kernel_vmalloc_ptes, 0, sizeof(kernel_vmalloc_ptes));
+
+	/* load the VMALLOC area PTE table addresses into the kernel PGD */
+	ppte = kernel_vmalloc_ptes;
+	for (loop = VMALLOC_START / (PAGE_SIZE * PTRS_PER_PTE);
+	     loop < VMALLOC_END / (PAGE_SIZE * PTRS_PER_PTE);
+	     loop++
+	     ) {
+		set_pgd(swapper_pg_dir + loop, __pgd(__pa(ppte) | _PAGE_TABLE));
+		ppte += PAGE_SIZE / sizeof(pte_t);
+	}
+
+	/* declare the sizes of the RAM zones (only use the normal zone) */
+	zones_size[ZONE_NORMAL] =
+		(contig_page_data.bdata->node_low_pfn) -
+		(contig_page_data.bdata->node_boot_start >> PAGE_SHIFT);
+
+	/* pass the memory from the bootmem allocator to the main allocator */
+	free_area_init(zones_size);
+
+	__flush_tlb_all();
+}
+
+/*
+ * transfer all the memory from the bootmem allocator to the runtime allocator
+ */
+void __init mem_init(void)
+{
+	int codesize, reservedpages, datasize, initsize;
+	int tmp;
+
+	if (!mem_map)
+		BUG();
+
+#define START_PFN	(contig_page_data.bdata->node_boot_start >> PAGE_SHIFT)
+#define MAX_LOW_PFN	(contig_page_data.bdata->node_low_pfn)
+
+	max_mapnr = num_physpages = MAX_LOW_PFN - START_PFN;
+	high_memory = (void *) __va(MAX_LOW_PFN * PAGE_SIZE);
+
+	/* clear the zero-page */
+	memset(empty_zero_page, 0, PAGE_SIZE);
+
+	/* this will put all low memory onto the freelists */
+	totalram_pages += free_all_bootmem();
+
+	reservedpages = 0;
+	for (tmp = 0; tmp < num_physpages; tmp++)
+		if (PageReserved(&mem_map[tmp]))
+			reservedpages++;
+
+	codesize =  (unsigned long) &_etext - (unsigned long) &_stext;
+	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
+	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
+
+	printk("Memory: %luk/%luk available"
+	       " (%dk kernel code, %dk reserved, %dk data, %dk init, %ldk highmem)\n",
+	       (unsigned long) nr_free_pages() << (PAGE_SHIFT - 10),
+	       max_mapnr << (PAGE_SHIFT - 10),
+	       codesize >> 10,
+	       reservedpages << (PAGE_SHIFT - 10),
+	       datasize >> 10,
+	       initsize >> 10,
+	       (unsigned long) (totalhigh_pages << (PAGE_SHIFT - 10))
+	       );
+}
+
+/*
+ * 
+ */
+void free_init_pages(char *what, unsigned long begin, unsigned long end)
+{
+	unsigned long addr;
+
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(addr));
+		init_page_count(virt_to_page(addr));
+		memset((void *) addr, 0xcc, PAGE_SIZE);
+		free_page(addr);
+		totalram_pages++;
+	}
+	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+}
+
+/*
+ * recycle memory containing stuff only required for initialisation
+ */
+void free_initmem(void)
+{
+	free_init_pages("unused kernel memory",
+			(unsigned long) &__init_begin,
+			(unsigned long) &__init_end);
+}
+
+/*
+ * dispose of the memory on which the initial ramdisk resided
+ */
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	free_init_pages("initrd memory", start, end);
+}
+#endif
diff -puN /dev/null arch/mn10300/mm/Makefile
--- /dev/null
+++ a/arch/mn10300/mm/Makefile
@@ -0,0 +1,14 @@
+#
+# Makefile for the MN10300-specific memory management code
+#
+
+obj-y := \
+	init.o fault.o pgtable.o extable.o tlb-mn10300.o mmu-context.o \
+	misalignment.o dma-alloc.o
+
+ifneq ($(CONFIG_MN10300_CACHE_DISABLED),y)
+obj-y	+= cache.o cache-mn10300.o
+ifeq ($(CONFIG_MN10300_CACHE_WBACK),y)
+obj-y	+= cache-flush-mn10300.o
+endif
+endif
diff -puN /dev/null arch/mn10300/mm/misalignment.c
--- /dev/null
+++ a/arch/mn10300/mm/misalignment.c
@@ -0,0 +1,661 @@
+/* MN10300 Misalignment fixup handler
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/timer.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+#include <asm/io.h>
+#include <asm/atomic.h>
+#include <asm/smp.h>
+#include <asm/pgalloc.h>
+#include <asm/cpu-regs.h>
+#include <asm/busctl-regs.h>
+#include <asm/fpu.h>
+#include <asm/gdb-stub.h>
+#include <asm/asm-offsets.h>
+
+#if 0
+#define kdebug(FMT,...) printk(KERN_DEBUG FMT ,##__VA_ARGS__)
+#else
+#define kdebug(FMT,...) do {} while(0)
+#endif
+
+static int misalignment_addr(unsigned long *registers, unsigned params,
+			     unsigned opcode, unsigned disp,
+			     void **_address, unsigned long **_postinc);
+
+static int misalignment_reg(unsigned long *registers, unsigned params,
+			    unsigned opcode, unsigned disp,
+			    unsigned long **_register);
+
+static inline unsigned int_log2(unsigned x)
+{
+	unsigned y;
+	asm("bsch %1,%0" : "=r"(y) : "r"(x), "0"(0));
+	return y;
+}
+#define log2(x) int_log2(x)
+
+static const unsigned Dreg_index[] = {
+	REG_D0 >> 2, REG_D1 >> 2, REG_D2 >> 2, REG_D3 >> 2
+};
+
+static const unsigned Areg_index[] = {
+	REG_A0 >> 2, REG_A1 >> 2, REG_A2 >> 2, REG_A3 >> 2
+};
+
+static const unsigned Rreg_index[] = {
+	REG_E0 >> 2, REG_E1 >> 2, REG_E2 >> 2, REG_E3 >> 2,
+	REG_E4 >> 2, REG_E5 >> 2, REG_E6 >> 2, REG_E7 >> 2,
+	REG_A0 >> 2, REG_A1 >> 2, REG_A2 >> 2, REG_A3 >> 2,
+	REG_D0 >> 2, REG_D1 >> 2, REG_D2 >> 2, REG_D3 >> 2
+};
+
+typedef enum {
+	FMT_S0,
+	FMT_S1,
+	FMT_S2,
+	FMT_S4,
+	FMT_D0,
+	FMT_D1,
+	FMT_D2,
+	FMT_D4,
+	FMT_D6,
+	FMT_D7,
+	FMT_D8,
+	FMT_D9,
+} format_id_t;
+
+struct {
+	u_int8_t opsz, dispsz;
+} format_tbl[16] = {
+	[FMT_S0]	= { 8,	0	},
+	[FMT_S1]	= { 8,	8	},
+	[FMT_S2]	= { 8,	16	},
+	[FMT_S4]	= { 8,	32	},
+	[FMT_D0]	= { 16,	0	},
+	[FMT_D1]	= { 16,	8	},
+	[FMT_D2]	= { 16,	16	},
+	[FMT_D4]	= { 16,	32	},
+	[FMT_D6]	= { 24,	0	},
+	[FMT_D7]	= { 24,	8	},
+	[FMT_D8]	= { 24,	24	},
+	[FMT_D9]	= { 24,	32	},
+};
+
+typedef enum {
+	DM0,		/* data reg in opcode in bits 0-1 */
+	DM1,		/* data reg in opcode in bits 2-3 */
+	DM2,		/* data reg in opcode in bits 4-5 */
+	AM0,		/* addr reg in opcode in bits 0-1 */
+	AM1,		/* addr reg in opcode in bits 2-3 */
+	AM2,		/* addr reg in opcode in bits 4-5 */
+	RM0,		/* reg in opcode in bits 0-3 */
+	RM1,		/* reg in opcode in bits 2-5 */
+	RM2,		/* reg in opcode in bits 4-7 */
+	RM4,		/* reg in opcode in bits 8-11 */
+	RM6,		/* reg in opcode in bits 12-15 */
+
+	RD0,		/* reg in displacement in bits 0-3 */
+	RD2,		/* reg in displacement in bits 4-7 */
+
+	SP,		/* stack pointer */
+
+	SD8,		/* 8-bit signed displacement */
+	SD16,		/* 16-bit signed displacement */
+	SD24,		/* 24-bit signed displacement */
+	SIMM4_2,	/* 4-bit signed displacement in opcode bits 4-7 */
+	SIMM8,		/* 8-bit signed immediate */
+	IMM24,		/* 24-bit unsigned immediate */
+	IMM32,		/* 32-bit unsigned immediate */
+	IMM32_HIGH8,	/* 32-bit unsigned immediate, high 8-bits in opcode */
+
+	DN0	= DM0,
+	DN1	= DM1,
+	DN2	= DM2,
+	AN0	= AM0,
+	AN1	= AM1,
+	AN2	= AM2,
+	RN0	= RM0,
+	RN1	= RM1,
+	RN2	= RM2,
+	RN4	= RM4,
+	RN6	= RM6,
+	DI	= DM1,
+	RI	= RM2,
+
+} value_id_t;
+
+struct mn10300_opcode {
+	const char	*name;
+	u_int32_t	opcode;
+	u_int32_t	opmask;
+	unsigned	exclusion;
+
+	format_id_t	format;
+
+	unsigned	cpu_mask;
+#define AM33	330
+
+	unsigned	params[2];
+#define MEM(ADDR)		(0x80000000 | (ADDR))
+#define MEM2(ADDR1,ADDR2)	(0x80000000 | (ADDR1) << 8 | (ADDR2))
+#define MEMINC(ADDR)		(0x81000000 | (ADDR))
+#define MEMINC2(ADDR,INC)	(0x81000000 | (ADDR) << 8 | (INC))
+};
+
+/* LIBOPCODES EXCERPT
+   Assemble Matsushita MN10300 instructions.
+   Copyright 1996, 1997, 1998, 1999, 2000 Free Software Foundation, Inc.
+
+   This program is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public Licence as published by
+   the Free Software Foundation; either version 2 of the Licence, or
+   (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public Licence for more details.
+
+   You should have received a copy of the GNU General Public Licence
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+*/
+static const struct mn10300_opcode mn10300_opcodes[] = {
+{ "mov",	0x60,	     0xf0,	  0,    FMT_S0, 0,	{DM1, MEM(AN0)}},
+{ "mov",	0x70,	     0xf0,	  0,    FMT_S0, 0,	{MEM(AM0), DN1}},
+{ "mov",	0xf000,	     0xfff0,	  0,    FMT_D0, 0,	{MEM(AM0), AN1}},
+{ "mov",	0xf010,	     0xfff0,	  0,    FMT_D0, 0,	{AM1, MEM(AN0)}},
+{ "mov",	0xf300,	     0xffc0,	  0,    FMT_D0, 0,	{MEM2(DI, AM0), DN2}},
+{ "mov",	0xf340,	     0xffc0,	  0,    FMT_D0, 0,	{DM2, MEM2(DI, AN0)}},
+{ "mov",	0xf380,	     0xffc0,	  0,    FMT_D0, 0,	{MEM2(DI, AM0), AN2}},
+{ "mov",	0xf3c0,	     0xffc0,	  0,    FMT_D0, 0,	{AM2, MEM2(DI, AN0)}},
+{ "mov",	0xf80000,    0xfff000,    0,    FMT_D1, 0,	{MEM2(SD8, AM0), DN1}},
+{ "mov",	0xf81000,    0xfff000,    0,    FMT_D1, 0,	{DM1, MEM2(SD8, AN0)}},
+{ "mov",	0xf82000,    0xfff000,    0,    FMT_D1, 0,	{MEM2(SD8,AM0), AN1}},
+{ "mov",	0xf83000,    0xfff000,    0,    FMT_D1, 0,	{AM1, MEM2(SD8, AN0)}},
+{ "mov",	0xf8f000,    0xfffc00,    0,    FMT_D1, AM33,	{MEM2(SD8, AM0), SP}},
+{ "mov",	0xf8f400,    0xfffc00,    0,    FMT_D1, AM33,	{SP, MEM2(SD8, AN0)}},
+{ "mov",	0xf90a00,    0xffff00,    0,    FMT_D6, AM33,	{MEM(RM0), RN2}},
+{ "mov",	0xf91a00,    0xffff00,    0,    FMT_D6, AM33,	{RM2, MEM(RN0)}},
+{ "mov",	0xf96a00,    0xffff00,    0x12, FMT_D6, AM33,	{MEMINC(RM0), RN2}},
+{ "mov",	0xf97a00,    0xffff00,    0,	FMT_D6, AM33,	{RM2, MEMINC(RN0)}},
+{ "mov",	0xfa000000,  0xfff00000,  0,    FMT_D2, 0,	{MEM2(SD16, AM0), DN1}},
+{ "mov",	0xfa100000,  0xfff00000,  0,    FMT_D2, 0,	{DM1, MEM2(SD16, AN0)}},
+{ "mov",	0xfa200000,  0xfff00000,  0,    FMT_D2, 0,	{MEM2(SD16, AM0), AN1}},
+{ "mov",	0xfa300000,  0xfff00000,  0,    FMT_D2, 0,	{AM1, MEM2(SD16, AN0)}},
+{ "mov",	0xfb0a0000,  0xffff0000,  0,    FMT_D7, AM33,	{MEM2(SD8, RM0), RN2}},
+{ "mov",	0xfb1a0000,  0xffff0000,  0,    FMT_D7, AM33,	{RM2, MEM2(SD8, RN0)}},
+{ "mov",	0xfb6a0000,  0xffff0000,  0x22, FMT_D7, AM33,	{MEMINC2 (RM0, SIMM8), RN2}},
+{ "mov",	0xfb7a0000,  0xffff0000,  0,	FMT_D7, AM33,	{RM2, MEMINC2 (RN0, SIMM8)}},
+{ "mov",	0xfb8e0000,  0xffff000f,  0,    FMT_D7, AM33,	{MEM2(RI, RM0), RD2}},
+{ "mov",	0xfb9e0000,  0xffff000f,  0,    FMT_D7, AM33,	{RD2, MEM2(RI, RN0)}},
+{ "mov",	0xfc000000,  0xfff00000,  0,    FMT_D4, 0,	{MEM2(IMM32,AM0), DN1}},
+{ "mov",	0xfc100000,  0xfff00000,  0,    FMT_D4, 0,	{DM1, MEM2(IMM32,AN0)}},
+{ "mov",	0xfc200000,  0xfff00000,  0,    FMT_D4, 0,	{MEM2(IMM32,AM0), AN1}},
+{ "mov",	0xfc300000,  0xfff00000,  0,    FMT_D4, 0,	{AM1, MEM2(IMM32,AN0)}},
+{ "mov",	0xfd0a0000,  0xffff0000,  0,    FMT_D8, AM33,	{MEM2(SD24, RM0), RN2}},
+{ "mov",	0xfd1a0000,  0xffff0000,  0,    FMT_D8, AM33,	{RM2, MEM2(SD24, RN0)}},
+{ "mov",	0xfd6a0000,  0xffff0000,  0x22, FMT_D8, AM33,	{MEMINC2 (RM0, IMM24), RN2}},
+{ "mov",	0xfd7a0000,  0xffff0000,  0,	FMT_D8, AM33,	{RM2, MEMINC2 (RN0, IMM24)}},
+{ "mov",	0xfe0a0000,  0xffff0000,  0,    FMT_D9, AM33,	{MEM2(IMM32_HIGH8,RM0), RN2}},
+{ "mov",	0xfe1a0000,  0xffff0000,  0,    FMT_D9, AM33,	{RM2, MEM2(IMM32_HIGH8, RN0)}},
+{ "mov",	0xfe6a0000,  0xffff0000,  0x22, FMT_D9, AM33,	{MEMINC2 (RM0, IMM32_HIGH8), RN2}},
+{ "mov",	0xfe7a0000,  0xffff0000,  0,	FMT_D9, AM33,	{RN2, MEMINC2 (RM0, IMM32_HIGH8)}},
+
+{ "movhu",	0xf060,	     0xfff0,	  0,    FMT_D0, 0,	{MEM(AM0), DN1}},
+{ "movhu",	0xf070,	     0xfff0,	  0,    FMT_D0, 0,	{DM1, MEM(AN0)}},
+{ "movhu",	0xf480,	     0xffc0,	  0,    FMT_D0, 0,	{MEM2(DI, AM0), DN2}},
+{ "movhu",	0xf4c0,	     0xffc0,	  0,    FMT_D0, 0,	{DM2, MEM2(DI, AN0)}},
+{ "movhu",	0xf86000,    0xfff000,    0,    FMT_D1, 0,	{MEM2(SD8, AM0), DN1}},
+{ "movhu",	0xf87000,    0xfff000,    0,    FMT_D1, 0,	{DM1, MEM2(SD8, AN0)}},
+{ "movhu",	0xf94a00,    0xffff00,    0,    FMT_D6, AM33,	{MEM(RM0), RN2}},
+{ "movhu",	0xf95a00,    0xffff00,    0,    FMT_D6, AM33,	{RM2, MEM(RN0)}},
+{ "movhu",	0xf9ea00,    0xffff00,    0x12, FMT_D6, AM33,	{MEMINC(RM0), RN2}},
+{ "movhu",	0xf9fa00,    0xffff00,    0,	FMT_D6, AM33,	{RM2, MEMINC(RN0)}},
+{ "movhu",	0xfa600000,  0xfff00000,  0,    FMT_D2, 0,	{MEM2(SD16, AM0), DN1}},
+{ "movhu",	0xfa700000,  0xfff00000,  0,    FMT_D2, 0,	{DM1, MEM2(SD16, AN0)}},
+{ "movhu",	0xfb4a0000,  0xffff0000,  0,    FMT_D7, AM33,	{MEM2(SD8, RM0), RN2}},
+{ "movhu",	0xfb5a0000,  0xffff0000,  0,    FMT_D7, AM33,	{RM2, MEM2(SD8, RN0)}},
+{ "movhu",	0xfbce0000,  0xffff000f,  0,    FMT_D7, AM33,	{MEM2(RI, RM0), RD2}},
+{ "movhu",	0xfbde0000,  0xffff000f,  0,    FMT_D7, AM33,	{RD2, MEM2(RI, RN0)}},
+{ "movhu",	0xfbea0000,  0xffff0000,  0x22, FMT_D7, AM33,	{MEMINC2 (RM0, SIMM8), RN2}},
+{ "movhu",	0xfbfa0000,  0xffff0000,  0,	FMT_D7, AM33,	{RM2, MEMINC2 (RN0, SIMM8)}},
+{ "movhu",	0xfc600000,  0xfff00000,  0,    FMT_D4, 0,	{MEM2(IMM32,AM0), DN1}},
+{ "movhu",	0xfc700000,  0xfff00000,  0,    FMT_D4, 0,	{DM1, MEM2(IMM32,AN0)}},
+{ "movhu",	0xfd4a0000,  0xffff0000,  0,    FMT_D8, AM33,	{MEM2(SD24, RM0), RN2}},
+{ "movhu",	0xfd5a0000,  0xffff0000,  0,    FMT_D8, AM33,	{RM2, MEM2(SD24, RN0)}},
+{ "movhu",	0xfdea0000,  0xffff0000,  0x22, FMT_D8, AM33,	{MEMINC2 (RM0, IMM24), RN2}},
+{ "movhu",	0xfdfa0000,  0xffff0000,  0,	FMT_D8, AM33,	{RM2, MEMINC2 (RN0, IMM24)}},
+{ "movhu",	0xfe4a0000,  0xffff0000,  0,    FMT_D9, AM33,	{MEM2(IMM32_HIGH8,RM0), RN2}},
+{ "movhu",	0xfe5a0000,  0xffff0000,  0,    FMT_D9, AM33,	{RM2, MEM2(IMM32_HIGH8, RN0)}},
+{ "movhu",	0xfeea0000,  0xffff0000,  0x22, FMT_D9, AM33,	{MEMINC2 (RM0, IMM32_HIGH8), RN2}},
+{ "movhu",	0xfefa0000,  0xffff0000,  0,	FMT_D9, AM33,	{RN2, MEMINC2 (RM0, IMM32_HIGH8)}},
+{ 0, 0, 0, 0, 0, 0, {0}},
+};
+
+/*
+ * fix up misalignment problems where possible
+ */
+asmlinkage void misalignment(struct pt_regs *regs, exception_code_t code)
+{
+	const struct exception_table_entry *fixup;
+	const struct mn10300_opcode *pop;
+	unsigned long *registers = (unsigned long *) regs;
+	unsigned long data, *store, *postinc;
+	mm_segment_t seg;
+	siginfo_t info;
+	uint32_t opcode, disp, noc, xo, xm;
+	uint8_t *pc, byte;
+	void *address;
+	unsigned tmp, npop;
+
+	kdebug("MISALIGN at %lx\n", regs->pc);
+
+	if (in_interrupt())
+		die("Misalignment trap in interrupt context", regs, code);
+
+	if (regs->epsw & EPSW_IE)
+		asm volatile("or %0,epsw" : : "i"(EPSW_IE));
+
+	seg = get_fs();
+	set_fs(KERNEL_DS);
+
+	fixup = search_exception_tables(regs->pc);
+
+	/* first thing to do is to match the opcode */
+	pc = (u_int8_t *) regs->pc;
+
+	if (__get_user(byte, pc) != 0)
+		goto fetch_error;
+	opcode = byte;
+	noc = 8;
+
+	for (pop = mn10300_opcodes; pop->name; pop++) {
+		npop = log2(pop->opcode | pop->opmask);
+		if (npop <= 0 || npop > 31)
+			continue;
+		npop = (npop + 8) & ~7;
+
+	got_more_bits:
+		if (npop == noc) {
+			if ((opcode & pop->opmask) == pop->opcode)
+				goto found_opcode;
+		}
+		else if (npop > noc) {
+			xo = pop->opcode >> (npop - noc);
+			xm = pop->opmask >> (npop - noc);
+
+			if ((opcode & xm) != xo)
+				continue;
+
+			/* we've got a partial match (an exact match on the
+			 * first N bytes), so we need to get some more data */
+			pc++;
+			if (__get_user(byte, pc) != 0)
+				goto fetch_error;
+			opcode = opcode << 8 | byte;
+			noc += 8;
+			goto got_more_bits;
+		}
+		else {
+			/* there's already been a partial match as long as the
+			 * complete match we're now considering, so this one
+			 * should't match */
+			continue;
+		}
+	}
+
+	/* didn't manage to find a fixup */
+	if (!user_mode(regs))
+		printk(KERN_CRIT "MISALIGN: %lx: unsupported instruction %x\n",
+		       regs->pc, opcode);
+
+failed:
+	set_fs(seg);
+	if (die_if_no_fixup("misalignment error", regs, code))
+		return;
+
+	info.si_signo	= SIGBUS;
+	info.si_errno	= 0;
+	info.si_code	= BUS_ADRALN;
+	info.si_addr	= (void *) regs->pc;
+	force_sig_info(SIGBUS, &info, current);
+	return;
+
+	/* error reading opcodes */
+fetch_error:
+	if (!user_mode(regs))
+		printk(KERN_CRIT "MISALIGN: %p: fault whilst reading instruction data\n",
+		       pc);
+	goto failed;
+
+bad_addr_mode:
+	if (!user_mode(regs))
+		printk(KERN_CRIT "MISALIGN: %lx: unsupported addressing mode %x\n",
+		       regs->pc, opcode);
+	goto failed;
+
+bad_reg_mode:
+	if (!user_mode(regs))
+		printk(KERN_CRIT "MISALIGN: %lx: unsupported register mode %x\n",
+		       regs->pc, opcode);
+	goto failed;
+
+unsupported_instruction:
+	if (!user_mode(regs))
+		printk(KERN_CRIT "MISALIGN: %lx: unsupported instruction %x (%s)\n",
+		       regs->pc, opcode, pop->name);
+	goto failed;
+
+transfer_failed:
+	set_fs(seg);
+	if (fixup) {
+		regs->pc = fixup->fixup;
+		return;
+	}
+	if (die_if_no_fixup("misalignment fixup", regs, code))
+		return;
+
+	info.si_signo	= SIGSEGV;
+	info.si_errno	= 0;
+	info.si_code	= 0;
+	info.si_addr	= (void *) regs->pc;
+	force_sig_info(SIGSEGV, &info, current);
+	return;
+
+	/* we matched the opcode */
+found_opcode:
+	kdebug("MISALIGN: %lx: %x==%x { %x, %x }\n",
+	       regs->pc, opcode, pop->opcode, pop->params[0], pop->params[1]);
+
+	tmp = format_tbl[pop->format].opsz;
+	if (tmp > noc)
+		BUG(); /* match was less complete than it ought to have been */
+
+	if (tmp < noc) {
+		tmp = noc - tmp;
+		opcode >>= tmp;
+		pc -= tmp >> 3;
+	}
+
+	/* grab the extra displacement (note it's LSB first) */
+	disp = 0;
+	tmp = format_tbl[pop->format].dispsz >> 3;
+	while (tmp > 0) {
+		tmp--;
+		disp <<= 8;
+
+		pc++;
+		if (__get_user(byte, pc) != 0)
+			goto fetch_error;
+		disp |= byte;
+	}
+
+	set_fs(KERNEL_XDS);
+	if (fixup || regs->epsw & EPSW_nSL)
+		set_fs(seg);
+
+	tmp = (pop->params[0] ^ pop->params[1]) & 0x80000000;
+	if (!tmp) {
+		if (!user_mode(regs))
+			printk(KERN_CRIT "MISALIGN: %lx: insn not move to/from memory %x\n",
+			       regs->pc, opcode);
+		goto failed;
+	}
+
+	if (pop->params[0] & 0x80000000) {
+		/* move memory to register */
+		if (!misalignment_addr(registers, pop->params[0], opcode, disp,
+				       &address, &postinc))
+			goto bad_addr_mode;
+
+		if (!misalignment_reg(registers, pop->params[1], opcode, disp,
+				      &store))
+			goto bad_reg_mode;
+
+		if (strcmp(pop->name, "mov") == 0) {
+			kdebug("FIXUP: mov (%p),DARn\n", address);
+			if (copy_from_user(&data, (void *) address, 4) != 0)
+				goto transfer_failed;
+			if (pop->params[0] & 0x1000000)
+				*postinc += 4;
+		}
+		else if (strcmp(pop->name, "movhu") == 0) {
+			kdebug("FIXUP: movhu (%p),DARn\n", address);
+			data = 0;
+			if (copy_from_user(&data, (void *) address, 2) != 0)
+				goto transfer_failed;
+			if (pop->params[0] & 0x1000000)
+				*postinc += 2;
+		}
+		else {
+			goto unsupported_instruction;
+		}
+
+		*store = data;
+	}
+	else {
+		/* move register to memory */
+		if (!misalignment_reg(registers, pop->params[0], opcode, disp,
+				      &store))
+			goto bad_reg_mode;
+
+		if (!misalignment_addr(registers, pop->params[1], opcode, disp,
+				       &address, &postinc))
+			goto bad_addr_mode;
+
+		data = *store;
+
+		if (strcmp(pop->name, "mov") == 0) {
+			kdebug("FIXUP: mov %lx,(%p)\n", data, address);
+			if (copy_to_user((void *) address, &data, 4) != 0)
+				goto transfer_failed;
+			if (pop->params[1] & 0x1000000)
+				*postinc += 4;
+		}
+		else if (strcmp(pop->name, "movhu") == 0) {
+			kdebug("FIXUP: movhu %hx,(%p)\n", (uint16_t) data, address);
+			if (copy_to_user((void *) address, &data, 2) != 0)
+				goto transfer_failed;
+			if (pop->params[1] & 0x1000000)
+				*postinc += 2;
+		}
+		else {
+			goto unsupported_instruction;
+		}
+	}
+
+	tmp = format_tbl[pop->format].opsz + format_tbl[pop->format].dispsz;
+	regs->pc += tmp >> 3;
+
+	set_fs(seg);
+	return;
+}
+
+/*
+ * determine the address that was being accessed
+ */
+static int misalignment_addr(unsigned long *registers, unsigned params,
+			     unsigned opcode, unsigned disp,
+			     void **_address, unsigned long **_postinc)
+{
+	unsigned long *postinc = NULL, address = 0, tmp;
+
+	params &= 0x7fffffff;
+
+	do {
+		switch (params & 0xff) {
+		case DM0:
+			postinc = &registers[Dreg_index[opcode & 0x03]];
+			address += *postinc;
+			break;
+		case DM1:
+			postinc = &registers[Dreg_index[opcode >> 2 & 0x0c]];
+			address += *postinc;
+			break;
+		case DM2:
+			postinc = &registers[Dreg_index[opcode >> 4 & 0x30]];
+			address += *postinc;
+			break;
+		case AM0:
+			postinc = &registers[Areg_index[opcode & 0x03]];
+			address += *postinc;
+			break;
+		case AM1:
+			postinc = &registers[Areg_index[opcode >> 2 & 0x0c]];
+			address += *postinc;
+			break;
+		case AM2:
+			postinc = &registers[Areg_index[opcode >> 4 & 0x30]];
+			address += *postinc;
+			break;
+		case RM0:
+			postinc = &registers[Rreg_index[opcode & 0x0f]];
+			address += *postinc;
+			break;
+		case RM1:
+			postinc = &registers[Rreg_index[opcode >> 2 & 0x0f]];
+			address += *postinc;
+			break;
+		case RM2:
+			postinc = &registers[Rreg_index[opcode >> 4 & 0x0f]];
+			address += *postinc;
+			break;
+		case RM4:
+			postinc = &registers[Rreg_index[opcode >> 8 & 0x0f]];
+			address += *postinc;
+			break;
+		case RM6:
+			postinc = &registers[Rreg_index[opcode >> 12 & 0x0f]];
+			address += *postinc;
+			break;
+		case RD0:
+			postinc = &registers[Rreg_index[disp & 0x0f]];
+			address += *postinc;
+			break;
+		case RD2:
+			postinc = &registers[Rreg_index[disp >> 4 & 0x0f]];
+			address += *postinc;
+			break;
+
+		case SD8:
+		case SIMM8:
+			address += (int32_t) (int8_t) (disp & 0xff);
+			break;
+		case SD16:
+			address += (int32_t) (int16_t) (disp & 0xffff);
+			break;
+		case SD24:
+			tmp = disp << 8;
+			asm("asr 8,%0" : "=r"(tmp) : "0"(tmp));
+			address += tmp;
+			break;
+		case SIMM4_2:
+			tmp = opcode >> 4 & 0x0f;
+			tmp <<= 28;
+			asm("asr 28,%0" : "=r"(tmp) : "0"(tmp));
+			address += tmp;
+			break;
+		case IMM24:
+			address += disp & 0x00ffffff;
+			break;
+		case IMM32:
+		case IMM32_HIGH8:
+			address += disp;
+			break;
+		default:
+			return 0;
+		}
+	} while ((params >>= 8));
+
+	*_address = (void *) address;
+	*_postinc = postinc;
+	return 1;
+}
+
+/*
+ * determine the register that is acting as source/dest
+ */
+static int misalignment_reg(unsigned long *registers, unsigned params,
+			    unsigned opcode, unsigned disp,
+			    unsigned long **_register)
+{
+	params &= 0x7fffffff;
+
+	if (params & 0xffffff00)
+		return 0;
+
+	switch (params & 0xff) {
+	case DM0:
+		*_register = &registers[Dreg_index[opcode & 0x03]];
+		break;
+	case DM1:
+		*_register = &registers[Dreg_index[opcode >> 2 & 0x03]];
+		break;
+	case DM2:
+		*_register = &registers[Dreg_index[opcode >> 4 & 0x03]];
+		break;
+	case AM0:
+		*_register = &registers[Areg_index[opcode & 0x03]];
+		break;
+	case AM1:
+		*_register = &registers[Areg_index[opcode >> 2 & 0x03]];
+		break;
+	case AM2:
+		*_register = &registers[Areg_index[opcode >> 4 & 0x03]];
+		break;
+	case RM0:
+		*_register = &registers[Rreg_index[opcode & 0x0f]];
+		break;
+	case RM1:
+		*_register = &registers[Rreg_index[opcode >> 2 & 0x0f]];
+		break;
+	case RM2:
+		*_register = &registers[Rreg_index[opcode >> 4 & 0x0f]];
+		break;
+	case RM4:
+		*_register = &registers[Rreg_index[opcode >> 8 & 0x0f]];
+		break;
+	case RM6:
+		*_register = &registers[Rreg_index[opcode >> 12 & 0x0f]];
+		break;
+	case RD0:
+		*_register = &registers[Rreg_index[disp & 0x0f]];
+		break;
+	case RD2:
+		*_register = &registers[Rreg_index[disp >> 4 & 0x0f]];
+		break;
+	case SP:
+		*_register = &registers[REG_SP >> 2];
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
diff -puN /dev/null arch/mn10300/mm/mmu-context.c
--- /dev/null
+++ a/arch/mn10300/mm/mmu-context.c
@@ -0,0 +1,80 @@
+/* MN10300 MMU context allocation and management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <asm/mmu_context.h>
+#include <asm/tlbflush.h>
+
+/*
+ * list of the MMU contexts last allocated on each CPU
+ */
+unsigned long mmu_context_cache[NR_CPUS] = {
+	[0 ... NR_CPUS - 1] = MMU_CONTEXT_FIRST_VERSION * 2 - 1,
+};
+
+/*
+ * flush the specified TLB entry
+ */
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
+{
+	unsigned long pteu, cnx, flags;
+
+	addr &= PAGE_MASK;
+
+	/* make sure the context doesn't migrate and defend against
+	 * interference from vmalloc'd regions */
+	local_irq_save(flags);
+
+	cnx = mm_context(vma->vm_mm);
+
+	if (cnx != MMU_NO_CONTEXT) {
+		pteu = addr | (cnx & 0x000000ffUL);
+		IPTEU = pteu;
+		DPTEU = pteu;
+		if (IPTEL & xPTEL_V)
+			IPTEL = 0;
+		if (DPTEL & xPTEL_V)
+			DPTEL = 0;
+	}
+
+	local_irq_restore(flags);
+}
+
+/*
+ * preemptively set a TLB entry
+ */
+void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
+{
+	unsigned long pteu, ptel, cnx, flags;
+
+	addr &= PAGE_MASK;
+	ptel = pte_val(pte) & ~(xPTEL_UNUSED1 | xPTEL_UNUSED2);
+
+	/* make sure the context doesn't migrate and defend against
+	 * interference from vmalloc'd regions */
+	local_irq_save(flags);
+
+	cnx = mm_context(vma->vm_mm);
+
+	if (cnx != MMU_NO_CONTEXT) {
+		pteu = addr | (cnx & 0x000000ffUL);
+		if (!(pte_val(pte) & _PAGE_NX)) {
+			IPTEU = pteu;
+			if (IPTEL & xPTEL_V)
+				IPTEL = ptel;
+		}
+		DPTEU = pteu;
+		if (DPTEL & xPTEL_V)
+			DPTEL = ptel;
+	}
+
+	local_irq_restore(flags);
+}
diff -puN /dev/null arch/mn10300/mm/pgtable.c
--- /dev/null
+++ a/arch/mn10300/mm/pgtable.c
@@ -0,0 +1,197 @@
+/* MN10300 Page table management
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/highmem.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/spinlock.h>
+#include <linux/quicklist.h>
+
+#include <asm/system.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/tlb.h>
+#include <asm/tlbflush.h>
+
+void show_mem(void)
+{
+	unsigned long i;
+	int free = 0, total = 0, reserved = 0, shared = 0;
+
+	int cached = 0;
+	printk(KERN_INFO "Mem-info:\n");
+	show_free_areas();
+	i = max_mapnr;
+	while (i-- > 0) {
+		total++;
+		if (PageReserved(mem_map + i))
+			reserved++;
+		else if (PageSwapCache(mem_map + i))
+			cached++;
+		else if (!page_count(mem_map + i))
+			free++;
+		else
+			shared += page_count(mem_map + i) - 1;
+	}
+	printk(KERN_INFO "%d pages of RAM\n", total);
+	printk(KERN_INFO "%d free pages\n", free);
+	printk(KERN_INFO "%d reserved pages\n", reserved);
+	printk(KERN_INFO "%d pages shared\n", shared);
+	printk(KERN_INFO "%d pages swap cached\n", cached);
+}
+
+/*
+ * Associate a large virtual page frame with a given physical page frame
+ * and protection flags for that frame. pfn is for the base of the page,
+ * vaddr is what the page gets mapped to - both must be properly aligned.
+ * The pmd must already be instantiated. Assumes PAE mode.
+ */
+void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	if (vaddr & (PMD_SIZE-1)) {		/* vaddr is misaligned */
+		printk ("set_pmd_pfn: vaddr misaligned\n");
+		return; /* BUG(); */
+	}
+	if (pfn & (PTRS_PER_PTE-1)) {		/* pfn is misaligned */
+		printk ("set_pmd_pfn: pfn misaligned\n");
+		return; /* BUG(); */
+	}
+	pgd = swapper_pg_dir + pgd_index(vaddr);
+	if (pgd_none(*pgd)) {
+		printk ("set_pmd_pfn: pgd_none\n");
+		return; /* BUG(); */
+	}
+	pud = pud_offset(pgd, vaddr);
+	pmd = pmd_offset(pud, vaddr);
+	set_pmd(pmd, pfn_pmd(pfn, flags));
+	/*
+	 * It's enough to flush this one mapping.
+	 * (PGE mappings get flushed as well)
+	 */
+	__flush_tlb_one(vaddr);
+}
+
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	if (pte)
+		clear_page(pte);
+	return pte;
+}
+
+struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	struct page *pte;
+
+#ifdef CONFIG_HIGHPTE
+	pte = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT, 0);
+#else
+	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
+#endif
+	if (pte)
+		clear_highpage(pte);
+	return pte;
+}
+
+/*
+ * List of all pgd's needed for non-PAE so it can invalidate entries
+ * in both cached and uncached pgd's; not needed for PAE since the
+ * kernel pmd is shared. If PAE were not to share the pmd a similar
+ * tactic would be needed. This is essentially codepath-based locking
+ * against pageattr.c; it is the unique case in which a valid change
+ * of kernel pagetables can't be lazily synchronized by vmalloc faults.
+ * vmalloc faults work because attached pagetables are never freed.
+ * If the locking proves to be non-performant, a ticketing scheme with
+ * checks at dup_mmap(), exec(), and other mmlist addition points
+ * could be used. The locking scheme was chosen on the basis of
+ * manfred's recommendations and having no core impact whatsoever.
+ * -- wli
+ */
+DEFINE_SPINLOCK(pgd_lock);
+struct page *pgd_list;
+
+static inline void pgd_list_add(pgd_t *pgd)
+{
+	struct page *page = virt_to_page(pgd);
+	page->index = (unsigned long) pgd_list;
+	if (pgd_list)
+		set_page_private(pgd_list, (unsigned long) &page->index);
+	pgd_list = page;
+	set_page_private(page, (unsigned long) &pgd_list);
+}
+
+static inline void pgd_list_del(pgd_t *pgd)
+{
+	struct page *next, **pprev, *page = virt_to_page(pgd);
+	next = (struct page *) page->index;
+	pprev = (struct page **) page_private(page);
+	*pprev = next;
+	if (next)
+		set_page_private(next, (unsigned long) pprev);
+}
+
+void pgd_ctor(void *pgd)
+{
+	unsigned long flags;
+
+	if (PTRS_PER_PMD == 1)
+		spin_lock_irqsave(&pgd_lock, flags);
+
+	memcpy((pgd_t *)pgd + USER_PTRS_PER_PGD,
+			swapper_pg_dir + USER_PTRS_PER_PGD,
+			(PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+
+	if (PTRS_PER_PMD > 1)
+		return;
+
+	pgd_list_add(pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
+	memset(pgd, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
+}
+
+/* never called when PTRS_PER_PMD > 1 */
+void pgd_dtor(void *pgd)
+{
+	unsigned long flags; /* can be called from interrupt context */
+
+	spin_lock_irqsave(&pgd_lock, flags);
+	pgd_list_del(pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
+pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	return quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
+}
+
+void pgd_free(pgd_t *pgd)
+{
+ 	quicklist_free(0, pgd_dtor, pgd);
+}
+
+void __init pgtable_cache_init(void)
+{
+}
+
+void check_pgt_cache(void)
+{
+	quicklist_trim(0, pgd_dtor, 25, 16);
+}
diff -puN /dev/null arch/mn10300/mm/tlb-mn10300.S
--- /dev/null
+++ a/arch/mn10300/mm/tlb-mn10300.S
@@ -0,0 +1,199 @@
+###############################################################################
+#
+# TLB loading functions
+#
+# Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+# Modified by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+###############################################################################
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/intctl-regs.h>
+#include <asm/frame.inc>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+###################################################################################################
+#
+# Instruction TLB Miss handler entry point
+#
+###################################################################################################
+	.type	itlb_miss,@function
+ENTRY(itlb_miss)
+	and	~EPSW_NMID,epsw
+#ifdef CONFIG_GDBSTUB
+	movm	[d2,d3,a2],(sp)
+#else
+	or	EPSW_nAR,epsw	# switch D0-D3 & A0-A3 to the alternate register bank
+	nop
+	nop
+	nop
+#endif
+
+	mov	(IPTEU),d3
+	mov	(PTBR),a2
+	mov	d3,d2
+	and	0xffc00000,d2
+	lsr	20,d2
+	mov	(a2,d2),a2		# PTD *ptd = PGD[addr 31..22]
+	btst	_PAGE_VALID,a2
+	beq	itlb_miss_fault		# jump if doesn't point anywhere
+
+	and	~(PAGE_SIZE-1),a2
+	mov	d3,d2
+	and	0x003ff000,d2
+	lsr	10,d2
+	add	d2,a2
+	mov	(a2),d2			# get pte from PTD[addr 21..12]
+	btst	_PAGE_VALID,d2
+	beq	itlb_miss_fault		# jump if doesn't point to a page (might be a swap id)
+	bset	_PAGE_ACCESSED,(0,a2)
+	and	~(xPTEL_UNUSED1|xPTEL_UNUSED2),d2
+itlb_miss_set:
+	mov	d2,(IPTEL)		# change the TLB
+#ifdef CONFIG_GDBSTUB
+	movm	(sp),[d2,d3,a2]
+#endif
+	rti
+
+itlb_miss_fault:
+	mov	_PAGE_VALID,d2		# force address error handler to be invoked
+	bra	itlb_miss_set
+
+	.size	itlb_miss, . - itlb_miss
+
+###################################################################################################
+#
+# Data TLB Miss handler entry point
+#
+###################################################################################################
+	.type	dtlb_miss,@function
+ENTRY(dtlb_miss)
+	and	~EPSW_NMID,epsw
+#ifdef CONFIG_GDBSTUB
+	movm	[d2,d3,a2],(sp)
+#else
+	or	EPSW_nAR,epsw	# switch D0-D3 & A0-A3 to the alternate register bank
+	nop
+	nop
+	nop
+#endif
+
+	mov	(DPTEU),d3
+	mov	(PTBR),a2
+	mov	d3,d2
+	and	0xffc00000,d2
+	lsr	20,d2
+	mov	(a2,d2),a2		# PTD *ptd = PGD[addr 31..22]
+	btst	_PAGE_VALID,a2
+	beq	dtlb_miss_fault		# jump if doesn't point anywhere
+
+	and	~(PAGE_SIZE-1),a2
+	mov	d3,d2
+	and	0x003ff000,d2
+	lsr	10,d2
+	add	d2,a2
+	mov	(a2),d2			# get pte from PTD[addr 21..12]
+	btst	_PAGE_VALID,d2
+	beq	dtlb_miss_fault		# jump if doesn't point to a page (might be a swap id)
+	bset	_PAGE_ACCESSED,(0,a2)
+	and	~(xPTEL_UNUSED1|xPTEL_UNUSED2),d2
+dtlb_miss_set:
+	mov	d2,(DPTEL)		# change the TLB
+#ifdef CONFIG_GDBSTUB
+	movm	(sp),[d2,d3,a2]
+#endif
+	rti
+
+dtlb_miss_fault:
+	mov	_PAGE_VALID,d2		# force address error handler to be invoked
+	bra	dtlb_miss_set
+	.size	dtlb_miss, . - dtlb_miss
+
+###################################################################################################
+#
+# Instruction TLB Address Error handler entry point
+#
+###################################################################################################
+	.type	itlb_aerror,@function
+ENTRY(itlb_aerror)
+	and	~EPSW_NMID,epsw
+	add	-4,sp
+	SAVE_ALL
+	add	-4,sp				# need to pass three params
+
+	# calculate the fault code
+	movhu	(MMUFCR_IFC),d1
+	or	0x00010000,d1			# it's an instruction fetch
+
+	# determine the page address
+	mov	(IPTEU),a2
+	mov	a2,d0
+	and	PAGE_MASK,d0
+	mov	d0,(12,sp)
+
+	clr	d0
+	mov	d0,(IPTEL)
+
+	and	~EPSW_NMID,epsw
+	or	EPSW_IE,epsw
+	mov	fp,d0
+	call	do_page_fault[],0		# do_page_fault(regs,code,addr
+
+	jmp	ret_from_exception
+	.size	itlb_aerror, . - itlb_aerror
+
+###################################################################################################
+#
+# Data TLB Address Error handler entry point
+#
+###################################################################################################
+	.type	dtlb_aerror,@function
+ENTRY(dtlb_aerror)
+	and	~EPSW_NMID,epsw
+	add	-4,sp
+	mov	d1,(sp)
+
+	movhu	(MMUFCR_DFC),d1			# is it the initial valid write to this page?
+	and	MMUFCR_xFC_INITWR,d1
+ 	beq	dtlb_pagefault			# jump if not
+
+	mov	(DPTEL),d1			# set the dirty bit (don't replace with BSET!)
+	or	_PAGE_DIRTY,d1
+	mov	d1,(DPTEL)
+	mov	(sp),d1
+	add	4,sp
+ 	rti
+
+	ALIGN
+dtlb_pagefault:
+	mov	(sp),d1
+	SAVE_ALL
+	add	-4,sp				# need to pass three params
+
+	# calculate the fault code
+	movhu	(MMUFCR_DFC),d1
+
+	# determine the page address
+	mov	(DPTEU),a2
+	mov	a2,d0
+	and	PAGE_MASK,d0
+	mov	d0,(12,sp)
+
+	clr	d0
+	mov	d0,(DPTEL)
+
+	and	~EPSW_NMID,epsw
+	or	EPSW_IE,epsw
+	mov	fp,d0
+	call	do_page_fault[],0		# do_page_fault(regs,code,addr
+
+	jmp	ret_from_exception
+	.size	dtlb_aerror, . - dtlb_aerror
diff -puN /dev/null arch/mn10300/oprofile/Kconfig
--- /dev/null
+++ a/arch/mn10300/oprofile/Kconfig
@@ -0,0 +1,23 @@
+
+menu "Profiling support"
+	depends on EXPERIMENTAL
+
+config PROFILING
+	bool "Profiling support (EXPERIMENTAL)"
+	help
+	  Say Y here to enable the extended profiling support mechanisms used
+	  by profilers such as OProfile.
+
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+endmenu
+
diff -puN /dev/null arch/mn10300/oprofile/Makefile
--- /dev/null
+++ a/arch/mn10300/oprofile/Makefile
@@ -0,0 +1,13 @@
+#
+# Makefile for the MN10300-specific profiling code
+#
+obj-$(CONFIG_OPROFILE) += oprofile.o
+
+DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
+		oprof.o cpu_buffer.o buffer_sync.o \
+		event_buffer.o oprofile_files.o \
+		oprofilefs.o oprofile_stats.o \
+		timer_int.o )
+
+oprofile-y				:= $(DRIVER_OBJS) op_model_null.o
+
diff -puN /dev/null arch/mn10300/oprofile/op_model_null.c
--- /dev/null
+++ a/arch/mn10300/oprofile/op_model_null.c
@@ -0,0 +1,22 @@
+/* Null profiling driver
+ *
+ * Copyright (C) 2003  Paul Mundt
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * Licence.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#include <linux/kernel.h>
+#include <linux/oprofile.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+
+int __init oprofile_arch_init(struct oprofile_operations *ops)
+{
+	return -ENODEV;
+}
+
+void oprofile_arch_exit(void)
+{
+}
+
diff -puN /dev/null arch/mn10300/proc-mn103e010/Makefile
--- /dev/null
+++ a/arch/mn10300/proc-mn103e010/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the MN103E010 processor chip specific code
+#
+obj-y   := proc-init.o
+
diff -puN /dev/null arch/mn10300/proc-mn103e010/proc-init.c
--- /dev/null
+++ a/arch/mn10300/proc-mn103e010/proc-init.c
@@ -0,0 +1,75 @@
+/* MN103E010 Processor initialisation
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <asm/rtc.h>
+
+/*
+ * initialise the on-silicon processor peripherals
+ */
+asmlinkage void __init processor_init(void)
+{
+	int loop;
+
+	/* set up the exception table first */
+	for (loop = 0x000; loop < 0x400; loop += 8)
+		__set_intr_stub(loop, __common_exception);
+
+	__set_intr_stub(EXCEP_ITLBMISS,		itlb_miss);
+	__set_intr_stub(EXCEP_DTLBMISS,		dtlb_miss);
+	__set_intr_stub(EXCEP_IAERROR,		itlb_aerror);
+	__set_intr_stub(EXCEP_DAERROR,		dtlb_aerror);
+	__set_intr_stub(EXCEP_BUSERROR,		raw_bus_error);
+	__set_intr_stub(EXCEP_DOUBLE_FAULT,	double_fault);
+	__set_intr_stub(EXCEP_SYSCALL0,		system_call);
+
+	__set_intr_stub(EXCEP_NMI,		nmi_handler);
+	__set_intr_stub(EXCEP_WDT,		nmi_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL0,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL1,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL2,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL3,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL4,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL5,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL6,	irq_handler);
+
+	IVAR0 = EXCEP_IRQ_LEVEL0;
+	IVAR1 = EXCEP_IRQ_LEVEL1;
+	IVAR2 = EXCEP_IRQ_LEVEL2;
+	IVAR3 = EXCEP_IRQ_LEVEL3;
+	IVAR4 = EXCEP_IRQ_LEVEL4;
+	IVAR5 = EXCEP_IRQ_LEVEL5;
+	IVAR6 = EXCEP_IRQ_LEVEL6;
+
+	mn10300_dcache_flush_inv();
+	mn10300_icache_inv();
+
+	/* disable all interrupts and set to priority 6 (lowest) */
+	for (loop = 0; loop < NR_IRQS; loop++)
+		GxICR(loop) = GxICR_LEVEL_6 | GxICR_DETECT;
+
+	/* clear the timers */
+	TM0MD	= 0;
+	TM1MD	= 0;
+	TM2MD	= 0;
+	TM3MD	= 0;
+	TM4MD	= 0;
+	TM5MD	= 0;
+	TM6MD	= 0;
+	TM6MDA	= 0;
+	TM6MDB	= 0;
+	TM7MD	= 0;
+	TM8MD	= 0;
+	TM9MD	= 0;
+	TM10MD	= 0;
+	TM11MD	= 0;
+
+	calibrate_clock();
+}
diff -puN /dev/null arch/mn10300/unit-asb2303/leds.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2303/leds.c
@@ -0,0 +1,52 @@
+/* ASB2303 peripheral 7-segment LEDs x1 support
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/init.h>
+
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/intctl-regs.h>
+#include <asm/rtc-regs.h>
+#include <asm/unit/leds.h>
+
+#if 0
+static const u8 asb2303_led_hex_tbl[16] = {
+	0x80, 0xf2, 0x48, 0x60, 0x32, 0x24, 0x04, 0xf0,
+	0x00, 0x20, 0x10, 0x06, 0x8c, 0x42, 0x0c, 0x1c
+};
+#endif
+
+static const u8 asb2303_led_chase_tbl[6] = {
+	~0x02,	/* top		- segA */
+	~0x04,	/* right top	- segB */
+	~0x08,	/* right bottom	- segC */
+	~0x10,	/* bottom	- segD */
+	~0x20,	/* left bottom	- segE */
+	~0x40,	/* left top	- segF */
+};
+
+static unsigned asb2303_led_chase;
+
+void peripheral_leds_display_exception(exception_code_t code)
+{
+	ASB2303_GPIO0DEF = 0x5555;	/* configure as an output port */
+	ASB2303_7SEGLEDS = 0x6d;	/* triple horizontal bar */
+}
+
+void peripheral_leds_led_chase(void)
+{
+	ASB2303_GPIO0DEF = 0x5555;	/* configure as an output port */
+	ASB2303_7SEGLEDS = asb2303_led_chase_tbl[asb2303_led_chase];
+	asb2303_led_chase++;
+	if (asb2303_led_chase >= 6)
+		asb2303_led_chase = 0;
+}
diff -puN /dev/null arch/mn10300/unit-asb2303/Makefile
--- /dev/null
+++ a/arch/mn10300/unit-asb2303/Makefile
@@ -0,0 +1,6 @@
+###############################################################################
+#
+# Makefile for the ASB2303 board
+#
+###############################################################################
+obj-y   := unit-init.o smc91111.o leds.o
diff -puN /dev/null arch/mn10300/unit-asb2303/smc91111.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2303/smc91111.c
@@ -0,0 +1,52 @@
+/* ASB2303 initialisation
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <asm/io.h>
+#include <asm/timex.h>
+#include <asm/processor.h>
+#include <asm/intctl-regs.h>
+#include <asm/unit/smc91111.h>
+
+static struct resource smc91c111_resources[] = {
+	[0] = {
+		.start		= SMC91111_BASE,
+		.end		= SMC91111_BASE_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start		= SMC91111_IRQ,
+		.end		= SMC91111_IRQ,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device smc91c111_device = {
+	.name		= "smc91x",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(smc91c111_resources),
+	.resource	= smc91c111_resources,
+};
+
+/*
+ * add platform devices
+ */
+static int __init unit_device_init(void)
+{
+	platform_device_register(&smc91c111_device);
+	return 0;
+}
+
+device_initcall(unit_device_init);
diff -puN /dev/null arch/mn10300/unit-asb2303/unit-init.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2303/unit-init.c
@@ -0,0 +1,60 @@
+/* ASB2303 initialisation
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/init.h>
+#include <linux/device.h>
+
+#include <asm/io.h>
+#include <asm/setup.h>
+#include <asm/processor.h>
+#include <asm/irq.h>
+#include <asm/intctl-regs.h>
+
+/*
+ * initialise some of the unit hardware before gdbstub is set up
+ */
+asmlinkage void __init unit_init(void)
+{
+	/* set up the external interrupts */
+	SET_XIRQ_TRIGGER(0, XIRQ_TRIGGER_HILEVEL);
+	SET_XIRQ_TRIGGER(2, XIRQ_TRIGGER_LOWLEVEL);
+	SET_XIRQ_TRIGGER(3, XIRQ_TRIGGER_HILEVEL);
+	SET_XIRQ_TRIGGER(4, XIRQ_TRIGGER_LOWLEVEL);
+	SET_XIRQ_TRIGGER(5, XIRQ_TRIGGER_LOWLEVEL);
+}
+
+/*
+ * initialise the rest of the unit hardware after gdbstub is ready
+ */
+void __init unit_setup(void)
+{
+}
+
+/*
+ * initialise the external interrupts used by a unit of this type
+ */
+void __init unit_init_IRQ(void)
+{
+	unsigned int extnum;
+
+	for (extnum = 0; extnum < NR_XIRQS; extnum++) {
+		switch (GET_XIRQ_TRIGGER(extnum)) {
+		case XIRQ_TRIGGER_HILEVEL:
+		case XIRQ_TRIGGER_LOWLEVEL:
+			set_irq_handler(XIRQ2IRQ(extnum), handle_level_irq);
+			break;
+		default:
+			break;
+		}
+	}
+}
diff -puN /dev/null arch/mn10300/unit-asb2305/leds.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2305/leds.c
@@ -0,0 +1,124 @@
+/* ASB2305 Peripheral 7-segment LEDs x4 support
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/init.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/cpu/intctl-regs.h>
+#include <asm/cpu/rtc-regs.h>
+#include <asm/unit/leds.h>
+
+static const u8 asb2305_led_hex_tbl[16] = {
+	0x80, 0xf2, 0x48, 0x60, 0x32, 0x24, 0x04, 0xf0,
+	0x00, 0x20, 0x10, 0x06, 0x8c, 0x42, 0x0c, 0x1c
+};
+
+static const u32 asb2305_led_chase_tbl[6] = {
+	~0x02020202,	/* top		- segA */
+	~0x04040404,	/* right top	- segB */
+	~0x08080808,	/* right bottom	- segC */
+	~0x10101010,	/* bottom	- segD */
+	~0x20202020,	/* left bottom	- segE */
+	~0x40404040,	/* left top	- segF */
+};
+
+static unsigned asb2305_led_chase;
+
+void peripheral_leds7x4_display_dec(unsigned int val, unsigned int points)
+{
+	u32 leds;
+
+	leds = asb2305_led_hex_tbl[(val/1000) % 10];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[(val/100) % 10];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[(val/10) % 10];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[val % 10];
+	leds |= points^0x01010101;
+
+	ASB2305_7SEGLEDS = leds;
+}
+
+void peripheral_leds7x4_display_hex(unsigned int val, unsigned int points)
+{
+	u32 leds;
+
+	leds = asb2305_led_hex_tbl[(val/1000) % 10];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[(val/100) % 10];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[(val/10) % 10];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[val % 10];
+	leds |= points^0x01010101;
+
+	ASB2305_7SEGLEDS = leds;
+}
+
+void peripheral_leds_display_exception(exception_code_t code)
+{
+	u32 leds;
+
+	leds = asb2305_led_hex_tbl[(code/0x100) % 0x10];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[(code/0x10) % 0x10];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[code % 0x10];
+	leds |= 0x6d010101;
+
+	ASB2305_7SEGLEDS = leds;
+}
+
+void peripheral_leds7x4_display_minssecs(unsigned int time, unsigned int points)
+{
+	u32 leds;
+
+	leds = asb2305_led_hex_tbl[(time/600) % 6];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[(time/60) % 10];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[(time/10) % 6];
+	leds <<= 8;
+	leds |= asb2305_led_hex_tbl[time % 10];
+	leds |= points^0x01010101;
+
+	ASB2305_7SEGLEDS = leds;
+}
+
+void peripheral_leds7x4_display_rtc(void)
+{
+	unsigned int clock;
+	u8 mins, secs;
+
+	mins = RTMCR;
+	secs = RTSCR;
+
+	clock = ((mins & 0xf0) >> 4);
+	clock *= 10;
+	clock += (mins & 0x0f);
+	clock *= 6;
+
+	clock += ((secs & 0xf0) >> 4);
+	clock *= 10;
+	clock += (secs & 0x0f);
+
+	peripheral_leds7x4_display_minssecs(clock,0);
+}
+
+void peripheral_leds_led_chase(void)
+{
+	ASB2305_7SEGLEDS = asb2305_led_chase_tbl[asb2305_led_chase];
+	asb2305_led_chase++;
+	if (asb2305_led_chase>=6)
+		asb2305_led_chase = 0;
+}
diff -puN /dev/null arch/mn10300/unit-asb2305/Makefile
--- /dev/null
+++ a/arch/mn10300/unit-asb2305/Makefile
@@ -0,0 +1,8 @@
+###############################################################################
+#
+# Makefile for the ASB2305 board
+#
+###############################################################################
+obj-y   := unit-init.o leds.o
+
+obj-$(CONFIG_PCI) += pci.o pci-asb2305.o pci-irq.o pci-iomap.o
diff -puN /dev/null arch/mn10300/unit-asb2305/pci-asb2305.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -0,0 +1,282 @@
+/* ASB2305 PCI resource stuff
+ *
+ * Copyright (C) 2001 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from arch/i386/pci-i386.c
+ *   - Copyright 1997--2000 Martin Mares <mj@suse.cz>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/errno.h>
+#include "pci-asb2305.h"
+
+/*
+ * We need to avoid collisions with `mirrored' VGA ports
+ * and other strange ISA hardware, so we always want the
+ * addresses to be allocated in the 0x000-0x0ff region
+ * modulo 0x400.
+ *
+ * Why? Because some silly external IO cards only decode
+ * the low 10 bits of the IO address. The 0x00-0xff region
+ * is reserved for motherboard devices that decode all 16
+ * bits, so it's ok to allocate at, say, 0x2800-0x28ff,
+ * but we want to try to avoid allocating at 0x2900-0x2bff
+ * which might have be mirrored at 0x0100-0x03ff..
+ */
+void pcibios_align_resource(void *data, struct resource *res,
+			    resource_size_t size, resource_size_t align)
+{
+#if 0
+	struct pci_dev *dev = data;
+
+	printk("### PCIBIOS_ALIGN_RESOURCE(%s,,{%08lx-%08lx,%08lx},%lx)\n",
+	       pci_name(dev),
+	       res->start,
+	       res->end,
+	       res->flags,
+	       size
+	       );
+#endif
+
+	if (res->flags & IORESOURCE_IO) {
+		unsigned long start = res->start;
+
+		if (start & 0x300) {
+			start = (start + 0x3ff) & ~0x3ff;
+			res->start = start;
+		}
+	}
+}
+
+
+/*
+ *  Handle resources of PCI devices.  If the world were perfect, we could
+ *  just allocate all the resource regions and do nothing more.  It isn't.
+ *  On the other hand, we cannot just re-allocate all devices, as it would
+ *  require us to know lots of host bridge internals.  So we attempt to
+ *  keep as much of the original configuration as possible, but tweak it
+ *  when it's found to be wrong.
+ *
+ *  Known BIOS problems we have to work around:
+ *	- I/O or memory regions not configured
+ *	- regions configured, but not enabled in the command register
+ *	- bogus I/O addresses above 64K used
+ *	- expansion ROMs left enabled (this may sound harmless, but given
+ *	  the fact the PCI specs explicitly allow address decoders to be
+ *	  shared between expansion ROMs and other resource regions, it's
+ *	  at least dangerous)
+ *
+ *  Our solution:
+ *	(1) Allocate resources for all buses behind PCI-to-PCI bridges.
+ *	    This gives us fixed barriers on where we can allocate.
+ *	(2) Allocate resources for all enabled devices.  If there is
+ *	    a collision, just mark the resource as unallocated. Also
+ *	    disable expansion ROMs during this step.
+ *	(3) Try to allocate resources for disabled devices.  If the
+ *	    resources were assigned correctly, everything goes well,
+ *	    if they weren't, they won't disturb allocation of other
+ *	    resources.
+ *	(4) Assign new addresses to resources which were either
+ *	    not configured at all or misconfigured.  If explicitly
+ *	    requested by the user, configure expansion ROM address
+ *	    as well.
+ */
+static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
+{
+	struct pci_bus *bus;
+	struct pci_dev *dev;
+	int idx;
+	struct resource *r, *pr;
+
+	/* Depth-First Search on bus tree */
+	list_for_each_entry(bus, bus_list, node) {
+		if ((dev = bus->self)) {
+			for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
+				r = &dev->resource[idx];
+				if (!r->flags)
+					continue;
+				pr = pci_find_parent_resource(dev, r);
+				if (!r->start || !pr || request_resource(pr, r) < 0) {
+					printk(KERN_ERR "PCI: Cannot allocate resource region %d of bridge %s\n", idx, pci_name(dev));
+					/* Something is wrong with the region.
+					   Invalidate the resource to prevent child
+					   resource allocations in this range. */
+					r->flags = 0;
+				}
+			}
+		}
+		pcibios_allocate_bus_resources(&bus->children);
+	}
+}
+
+static void __init pcibios_allocate_resources(int pass)
+{
+	struct pci_dev *dev = NULL;
+	int idx, disabled;
+	u16 command;
+	struct resource *r, *pr;
+
+	for_each_pci_dev(dev) {
+		pci_read_config_word(dev, PCI_COMMAND, &command);
+		for(idx = 0; idx < 6; idx++) {
+			r = &dev->resource[idx];
+			if (r->parent)		/* Already allocated */
+				continue;
+			if (!r->start)		/* Address not assigned at all */
+				continue;
+			if (r->flags & IORESOURCE_IO)
+				disabled = !(command & PCI_COMMAND_IO);
+			else
+				disabled = !(command & PCI_COMMAND_MEMORY);
+			if (pass == disabled) {
+				DBG("PCI[%s]: Resource %08lx-%08lx (f=%lx, d=%d, p=%d)\n",
+				    pci_name(dev),r->start, r->end, r->flags, disabled, pass);
+				pr = pci_find_parent_resource(dev, r);
+				if (!pr || request_resource(pr, r) < 0) {
+					printk(KERN_ERR "PCI: Cannot allocate resource region %d of device %s\n", idx, pci_name(dev));
+					/* We'll assign a new address later */
+					r->end -= r->start;
+					r->start = 0;
+				}
+			}
+		}
+		if (!pass) {
+			r = &dev->resource[PCI_ROM_RESOURCE];
+			if (r->flags & IORESOURCE_ROM_ENABLE) {
+				/* Turn the ROM off, leave the resource region, but keep it unregistered. */
+				u32 reg;
+				DBG("PCI: Switching off ROM of %s\n", pci_name(dev));
+				r->flags &= ~IORESOURCE_ROM_ENABLE;
+				pci_read_config_dword(dev, dev->rom_base_reg, &reg);
+				pci_write_config_dword(dev, dev->rom_base_reg, reg & ~PCI_ROM_ADDRESS_ENABLE);
+			}
+		}
+	}
+}
+
+static int __init pcibios_assign_resources(void)
+{
+	struct pci_dev *dev = NULL;
+	struct resource *r, *pr;
+
+	if (!(pci_probe & PCI_ASSIGN_ROMS)) {
+		/* Try to use BIOS settings for ROMs, otherwise let
+		   pci_assign_unassigned_resources() allocate the new
+		   addresses. */
+		for_each_pci_dev(dev) {
+			r = &dev->resource[PCI_ROM_RESOURCE];
+			if (!r->flags || !r->start)
+				continue;
+			pr = pci_find_parent_resource(dev, r);
+			if (!pr || request_resource(pr, r) < 0) {
+				r->end -= r->start;
+				r->start = 0;
+			}
+		}
+	}
+
+	pci_assign_unassigned_resources();
+
+	return 0;
+}
+
+fs_initcall(pcibios_assign_resources);
+
+void __init pcibios_resource_survey(void)
+{
+	DBG("PCI: Allocating resources\n");
+	pcibios_allocate_bus_resources(&pci_root_buses);
+	pcibios_allocate_resources(0);
+	pcibios_allocate_resources(1);
+}
+
+int pcibios_enable_resources(struct pci_dev *dev, int mask)
+{
+	u16 cmd, old_cmd;
+	int idx;
+	struct resource *r;
+
+	pci_read_config_word(dev, PCI_COMMAND, &cmd);
+	old_cmd = cmd;
+
+	for (idx = 0; idx < 6; idx++) {
+		/* Only set up the requested stuff */
+		if (!(mask & (1 << idx)))
+			continue;
+
+		r = &dev->resource[idx];
+
+		if (!r->start && r->end) {
+			printk(KERN_ERR
+			       "PCI: Device %s not available because of resource collisions\n",
+			       pci_name(dev));
+			return -EINVAL;
+		}
+
+		if (r->flags & IORESOURCE_IO)
+			cmd |= PCI_COMMAND_IO;
+		if (r->flags & IORESOURCE_MEM)
+			cmd |= PCI_COMMAND_MEMORY;
+	}
+
+	if (dev->resource[PCI_ROM_RESOURCE].start)
+		cmd |= PCI_COMMAND_MEMORY;
+
+	if (cmd != old_cmd)
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+
+	return 0;
+}
+
+/*
+ *  If we set up a device for bus mastering, we need to check the latency
+ *  timer as certain crappy BIOSes forget to set it properly.
+ */
+unsigned int pcibios_max_latency = 255;
+
+void pcibios_set_master(struct pci_dev *dev)
+{
+	u8 lat;
+
+	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
+
+	if (lat < 16)
+		lat = (64 <= pcibios_max_latency) ? 64 : pcibios_max_latency;
+	else if (lat > pcibios_max_latency)
+		lat = pcibios_max_latency;
+	else
+		return;
+
+	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
+}
+
+int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
+			enum pci_mmap_state mmap_state, int write_combine)
+{
+	unsigned long prot;
+
+	/* Leave vm_pgoff as-is, the PCI space address is the physical
+	 * address on this platform.
+	 */
+	vma->vm_flags |= VM_LOCKED | VM_IO;
+
+	prot = pgprot_val(vma->vm_page_prot);
+	prot &= ~_PAGE_CACHE;
+	vma->vm_page_prot = __pgprot(prot);
+
+	/* Write-combine setting is ignored */
+	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       vma->vm_end - vma->vm_start,
+			       vma->vm_page_prot))
+		return -EAGAIN;
+
+	return 0;
+}
diff -puN /dev/null arch/mn10300/unit-asb2305/pci-asb2305.h
--- /dev/null
+++ a/arch/mn10300/unit-asb2305/pci-asb2305.h
@@ -0,0 +1,81 @@
+/* ASB2305 Arch-specific PCI declarations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * Derived from: arch/i386/kernel/pci-i386.h: (c) 1999 Martin Mares <mj@ucw.cz>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _PCI_ASB2305_H
+#define _PCI_ASB2305_H
+
+#undef DEBUG
+
+#ifdef DEBUG
+#define DBG(x...) printk(x)
+#else
+#define DBG(x...)
+#endif
+
+#define PCI_PROBE_BIOS 1
+#define PCI_PROBE_CONF1 2
+#define PCI_PROBE_CONF2 4
+#define PCI_NO_SORT 0x100
+#define PCI_BIOS_SORT 0x200
+#define PCI_NO_CHECKS 0x400
+#define PCI_ASSIGN_ROMS 0x1000
+#define PCI_BIOS_IRQ_SCAN 0x2000
+
+extern unsigned int pci_probe;
+
+/* pci-asb2305.c */
+
+extern unsigned int pcibios_max_latency;
+
+extern void pcibios_resource_survey(void);
+extern int pcibios_enable_resources(struct pci_dev *dev, int mask);
+
+/* pci.c */
+
+extern int pcibios_last_bus;
+extern struct pci_bus *pci_root_bus;
+extern struct pci_ops *pci_root_ops;
+
+extern struct irq_routing_table *pcibios_get_irq_routing_table(void);
+extern int pcibios_set_irq_routing(struct pci_dev *dev, int pin, int irq);
+
+/* pci-irq.c */
+
+struct irq_info {
+	u8 bus, devfn;			/* Bus, device and function */
+	struct {
+		u8 link;		/* IRQ line ID, chipset dependent, 0=not routed */
+		u16 bitmap;		/* Available IRQs */
+	} __attribute__((packed)) irq[4];
+	u8 slot;			/* Slot number, 0=onboard */
+	u8 rfu;
+} __attribute__((packed));
+
+struct irq_routing_table {
+	u32 signature;			/* PIRQ_SIGNATURE should be here */
+	u16 version;			/* PIRQ_VERSION */
+	u16 size;			/* Table size in bytes */
+	u8 rtr_bus, rtr_devfn;		/* Where the interrupt router lies */
+	u16 exclusive_irqs;		/* IRQs devoted exclusively to PCI usage */
+	u16 rtr_vendor, rtr_device;	/* Vendor and device ID of interrupt router */
+	u32 miniport_data;		/* Crap */
+	u8 rfu[11];
+	u8 checksum;			/* Modulo 256 checksum must give zero */
+	struct irq_info slots[0];
+} __attribute__((packed));
+
+extern unsigned int pcibios_irq_mask;
+
+extern void pcibios_irq_init(void);
+extern void pcibios_fixup_irqs(void);
+extern void pcibios_enable_irq(struct pci_dev *dev);
+
+#endif /* PCI_ASB2305_H */
diff -puN /dev/null arch/mn10300/unit-asb2305/pci.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2305/pci.c
@@ -0,0 +1,541 @@
+/* ASB2305 PCI support
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * Derived from arch/i386/kernel/pci-pc.c (c) 1999--2000 Martin Mares <mj@suse.cz>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <asm/io.h>
+#include "pci-asb2305.h"
+
+unsigned int pci_probe = 1;
+
+int pcibios_last_bus = -1;
+struct pci_bus *pci_root_bus;
+struct pci_ops *pci_root_ops;
+
+/*
+ * Functions for accessing PCI configuration space
+ */
+
+#define CONFIG_CMD(bus, devfn, where) \
+	(0x80000000 | (bus->number << 16) | (devfn << 8) | (where & ~3))
+
+#define MEM_PAGING_REG	(*(volatile __u32 *)0xBFFFFFF4)
+#define CONFIG_ADDRESS	(*(volatile __u32 *)0xBFFFFFF8)
+#define CONFIG_DATAL(X)	(*(volatile __u32 *)0xBFFFFFFC)
+#define CONFIG_DATAW(X)	(*(volatile __u16 *)(0xBFFFFFFC + ((X) & 2)))
+#define CONFIG_DATAB(X)	(*(volatile __u8  *)(0xBFFFFFFC + ((X) & 3)))
+
+#define BRIDGEREGB(X) (*(volatile __u8  *)(0xBE040000 + (X)))
+#define BRIDGEREGW(X) (*(volatile __u16 *)(0xBE040000 + (X)))
+#define BRIDGEREGL(X) (*(volatile __u32 *)(0xBE040000 + (X)))
+
+static inline int __query(const struct pci_bus *bus, unsigned int devfn)
+{
+//	return bus->number == 0 && (devfn == PCI_DEVFN(0, 0));
+//	return bus->number == 1;
+//	return bus->number == 0 &&
+//		(devfn==PCI_DEVFN(2, 0) || devfn == PCI_DEVFN(3, 0));
+	return 1;
+}
+
+/*
+ * translate Linuxcentric addresses to PCI bus addresses
+ */
+void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
+			     struct resource *res)
+{
+	if (res->flags & IORESOURCE_IO) {
+		region->start = (res->start & 0x00ffffff);
+		region->end   = (res->end   & 0x00ffffff);
+	}
+
+	if (res->flags & IORESOURCE_MEM) {
+		region->start = (res->start & 0x03ffffff) | MEM_PAGING_REG;
+		region->end   = (res->end   & 0x03ffffff) | MEM_PAGING_REG;
+	}
+
+	//printk("RES->BUS: %lx-%lx => %lx-%lx\n",
+	//       res->start, res->end, region->start, region->end);
+}
+
+EXPORT_SYMBOL(pcibios_resource_to_bus);
+
+/*
+ * translate PCI bus addresses to Linuxcentric addresses
+ */
+void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+			     struct pci_bus_region *region)
+{
+	if (res->flags & IORESOURCE_IO) {
+		res->start = (region->start & 0x00ffffff) | 0xbe000000;
+		res->end   = (region->end   & 0x00ffffff) | 0xbe000000;
+	}
+
+	if (res->flags & IORESOURCE_MEM) {
+		res->start = (region->start & 0x03ffffff) | 0xb8000000;
+		res->end   = (region->end   & 0x03ffffff) | 0xb8000000;
+	}
+
+	//printk("BUS->RES: %lx-%lx => %lx-%lx\n",
+	//       region->start, region->end, res->start, res->end);
+}
+
+EXPORT_SYMBOL(pcibios_bus_to_resource);
+
+/*
+ *
+ */
+static int pci_ampci_read_config_byte(struct pci_bus *bus, unsigned int devfn,
+				      int where, u32 *_value)
+{
+	u32 rawval, value;
+
+	if (bus->number == 0 && devfn == PCI_DEVFN(0, 0)) {
+		value = BRIDGEREGB(where);
+		__pcbdebug("=> %02hx", &BRIDGEREGL(where), value);
+	}
+	else {
+		CONFIG_ADDRESS = CONFIG_CMD(bus, devfn, where);
+		rawval = CONFIG_ADDRESS;
+		value = CONFIG_DATAB(where);
+		if (__query(bus, devfn))
+			__pcidebug("=> %02hx", bus, devfn, where, value);
+	}
+
+	*_value = value;
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int pci_ampci_read_config_word(struct pci_bus *bus, unsigned int devfn,
+				      int where, u32 *_value)
+{
+	u32 rawval, value;
+
+	if (bus->number == 0 && devfn == PCI_DEVFN(0, 0)) {
+		value = BRIDGEREGW(where);
+		__pcbdebug("=> %04hx", &BRIDGEREGL(where), value);
+	}
+	else {
+		CONFIG_ADDRESS = CONFIG_CMD(bus, devfn, where);
+		rawval = CONFIG_ADDRESS;
+		value = CONFIG_DATAW(where);
+		if (__query(bus, devfn))
+			__pcidebug("=> %04hx", bus, devfn, where, value);
+	}
+
+	*_value = value;
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int pci_ampci_read_config_dword(struct pci_bus *bus, unsigned int devfn,
+				       int where, u32 *_value)
+{
+	u32 rawval, value;
+
+	if (bus->number == 0 && devfn == PCI_DEVFN(0, 0)) {
+		value = BRIDGEREGL(where);
+		__pcbdebug("=> %08x", &BRIDGEREGL(where), value);
+	}
+	else {
+		CONFIG_ADDRESS = CONFIG_CMD(bus, devfn, where);
+		rawval = CONFIG_ADDRESS;
+		value = CONFIG_DATAL(where);
+		if (__query(bus, devfn))
+			__pcidebug("=> %08x", bus, devfn, where, value);
+	}
+
+	*_value = value;
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int pci_ampci_write_config_byte(struct pci_bus *bus, unsigned int devfn,
+				       int where, u8 value)
+{
+	u32 rawval;
+
+	if (bus->number == 0 && devfn == PCI_DEVFN(0, 0)) {
+		__pcbdebug("<= %02x", &BRIDGEREGB(where), value);
+		BRIDGEREGB(where) = value;
+	}
+	else {
+		if (bus->number == 0 &&
+		    (devfn == PCI_DEVFN(2, 0) && devfn == PCI_DEVFN(3, 0))
+		    )
+			__pcidebug("<= %02x", bus, devfn, where, value);
+		CONFIG_ADDRESS = CONFIG_CMD(bus, devfn, where);
+		rawval = CONFIG_ADDRESS;
+		CONFIG_DATAB(where) = value;
+	}
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int pci_ampci_write_config_word(struct pci_bus *bus, unsigned int devfn,
+				       int where, u16 value)
+{
+	u32 rawval;
+
+	if (bus->number == 0 && devfn == PCI_DEVFN(0, 0)) {
+		__pcbdebug("<= %04hx", &BRIDGEREGW(where), value);
+		BRIDGEREGW(where) = value;
+	}
+	else {
+		if (__query(bus, devfn))
+			__pcidebug("<= %04hx", bus, devfn, where, value);
+		CONFIG_ADDRESS = CONFIG_CMD(bus, devfn, where);
+		rawval = CONFIG_ADDRESS;
+		CONFIG_DATAW(where) = value;
+	}
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int pci_ampci_write_config_dword(struct pci_bus *bus, unsigned int devfn,
+					int where, u32 value)
+{
+	u32 rawval;
+
+	if (bus->number == 0 && devfn == PCI_DEVFN(0, 0)) {
+		__pcbdebug("<= %08x", &BRIDGEREGL(where), value);
+		BRIDGEREGL(where) = value;
+	}
+	else {
+		if (__query(bus, devfn))
+			__pcidebug("<= %08x", bus, devfn, where, value);
+		CONFIG_ADDRESS = CONFIG_CMD(bus, devfn, where);
+		rawval = CONFIG_ADDRESS;
+		CONFIG_DATAL(where) = value;
+	}
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int pci_ampci_read_config(struct pci_bus *bus, unsigned int devfn,
+				 int where, int size, u32 *val)
+{
+	switch (size) {
+	case 1:
+		return pci_ampci_read_config_byte(bus, devfn, where, val);
+	case 2:
+		return pci_ampci_read_config_word(bus, devfn, where, val);
+	case 4:
+		return pci_ampci_read_config_dword(bus, devfn, where, val);
+	default:
+		BUG();
+		return -EOPNOTSUPP;
+	}
+}
+
+static int pci_ampci_write_config(struct pci_bus *bus, unsigned int devfn,
+				  int where, int size, u32 val)
+{
+	switch (size) {
+	case 1:
+		return pci_ampci_write_config_byte(bus, devfn, where, val);
+	case 2:
+		return pci_ampci_write_config_word(bus, devfn, where, val);
+	case 4:
+		return pci_ampci_write_config_dword(bus, devfn, where, val);
+	default:
+		BUG();
+		return -EOPNOTSUPP;
+	}
+}
+
+static struct pci_ops pci_direct_ampci = {
+	pci_ampci_read_config,
+	pci_ampci_write_config,
+};
+
+/*
+ * Before we decide to use direct hardware access mechanisms, we try to do some
+ * trivial checks to ensure it at least _seems_ to be working -- we just test
+ * whether bus 00 contains a host bridge (this is similar to checking
+ * techniques used in XFree86, but ours should be more reliable since we
+ * attempt to make use of direct access hints provided by the PCI BIOS).
+ *
+ * This should be close to trivial, but it isn't, because there are buggy
+ * chipsets (yes, you guessed it, by Intel and Compaq) that have no class ID.
+ */
+static int __init pci_sanity_check(struct pci_ops *o)
+{
+	struct pci_bus bus;		/* Fake bus and device */
+	u32 x;
+
+	bus.number = 0;
+
+	if ((!o->read(&bus, 0, PCI_CLASS_DEVICE, 2, &x) &&
+	     (x == PCI_CLASS_BRIDGE_HOST || x == PCI_CLASS_DISPLAY_VGA)) ||
+	    (!o->read(&bus, 0, PCI_VENDOR_ID, 2, &x) &&
+	     (x == PCI_VENDOR_ID_INTEL || x == PCI_VENDOR_ID_COMPAQ)))
+		return 1;
+
+	printk("PCI: Sanity check failed\n");
+	return 0;
+}
+
+static int __init pci_check_direct(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	/*
+	 * Check if access works.
+	 */
+	if (pci_sanity_check(&pci_direct_ampci)) {
+		local_irq_restore(flags);
+		printk("PCI: Using configuration ampci\n");
+		request_mem_region(0xBE040000, 256, "AMPCI bridge");
+		request_mem_region(0xBFFFFFF4, 12, "PCI ampci");
+		return 0;
+	}
+
+	local_irq_restore(flags);
+	return -ENODEV;
+}
+
+static int __devinit is_valid_resource(struct pci_dev *dev, int idx)
+{
+	unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
+	struct resource *devr = &dev->resource[idx];
+
+	if (dev->bus) {
+		for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
+			struct resource *busr = dev->bus->resource[i];
+
+			if (!busr || (busr->flags ^ devr->flags) & type_mask)
+				continue;
+
+			if (devr->start &&
+			    devr->start >= busr->start &&
+			    devr->end <= busr->end)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
+{
+	struct pci_bus_region region;
+	int i;
+	int limit;
+
+	if (dev->bus->number != 0)
+		return;
+
+	limit = (dev->hdr_type == PCI_HEADER_TYPE_NORMAL) ?
+		PCI_BRIDGE_RESOURCES : PCI_NUM_RESOURCES;
+
+	for (i = 0; i < limit; i++) {
+		if (!dev->resource[i].flags)
+			continue;
+
+		region.start = dev->resource[i].start;
+		region.end = dev->resource[i].end;
+		pcibios_bus_to_resource(dev, &dev->resource[i], &region);
+		if (is_valid_resource(dev, i))
+			pci_claim_resource(dev, i);
+	}
+}
+
+/*
+ *  Called after each bus is probed, but before its children
+ *  are examined.
+ */
+void __devinit pcibios_fixup_bus(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	if (bus->self) {
+		pci_read_bridge_bases(bus);
+		pcibios_fixup_device_resources(bus->self);
+	}
+
+	list_for_each_entry(dev, &bus->devices, bus_list)
+		pcibios_fixup_device_resources(dev);
+}
+
+/*
+ * Initialization. Try all known PCI access methods. Note that we support
+ * using both PCI BIOS and direct access: in such cases, we use I/O ports
+ * to access config space, but we still keep BIOS order of cards to be
+ * compatible with 2.0.X. This should go away some day.
+ */
+static int __init pcibios_init(void)
+{
+	ioport_resource.start	= 0xA0000000;
+	ioport_resource.end	= 0xDFFFFFFF;
+	iomem_resource.start	= 0xA0000000;
+	iomem_resource.end	= 0xDFFFFFFF;
+
+	if (!pci_probe)
+		return 0;
+
+	if (pci_check_direct() < 0) {
+		printk("PCI: No PCI bus detected\n");
+		return 0;
+	}
+
+	printk("PCI: Probing PCI hardware [mempage %08x]\n", MEM_PAGING_REG);
+
+	{
+#if 0
+		static struct pci_bus am33_root_bus = {
+			children:	LIST_HEAD_INIT(am33_root_bus.children),
+			devices:	LIST_HEAD_INIT(am33_root_bus.devices),
+			number:		0,
+			secondary:	0,
+			resource:	{ &ioport_resource, &iomem_resource },
+		};
+
+		am33_root_bus.ops = pci_root_ops;
+		list_add_tail(&am33_root_bus.node, &pci_root_buses);
+
+		am33_root_bus.subordinate = pci_do_scan_bus(0);
+
+		pci_root_bus = &am33_root_bus;
+#else
+		pci_root_bus = pci_scan_bus(0, &pci_direct_ampci, NULL);
+#endif
+	}
+
+	pcibios_irq_init();
+	pcibios_fixup_irqs();
+//	pcibios_resource_survey();
+	return 0;
+}
+
+arch_initcall(pcibios_init);
+
+char *__init pcibios_setup(char *str)
+{
+	if (!strcmp(str, "off")) {
+		pci_probe = 0;
+		return NULL;
+
+	} else if (!strncmp(str, "lastbus=", 8)) {
+		pcibios_last_bus = simple_strtol(str+8, NULL, 0);
+		return NULL;
+	}
+
+	return str;
+}
+
+int pcibios_enable_device(struct pci_dev *dev, int mask)
+{
+	int err;
+
+	err = pcibios_enable_resources(dev, mask);
+	if (err == 0)
+		pcibios_enable_irq(dev);
+	return err;
+}
+
+/*
+ * disable the ethernet chipset
+ */
+static void __init unit_disable_pcnet(struct pci_bus *bus, struct pci_ops *o)
+{
+	u32 x;
+
+	bus->number = 0;
+
+	o->read (bus, PCI_DEVFN(2, 0), PCI_COMMAND,		2, &x);
+	x |= PCI_COMMAND_MASTER |
+		PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
+		PCI_COMMAND_SERR | PCI_COMMAND_PARITY;
+	o->write(bus, PCI_DEVFN(2, 0), PCI_COMMAND,		2, x);
+	o->read (bus, PCI_DEVFN(2, 0), PCI_COMMAND,		2, &x);
+	o->write(bus, PCI_DEVFN(2, 0), PCI_BASE_ADDRESS_0,	4, 0x00030001);
+	o->read (bus, PCI_DEVFN(2, 0), PCI_BASE_ADDRESS_0,	4, &x);
+
+#define RDP (*(volatile u32 *) 0xBE030010)
+#define RAP (*(volatile u32 *) 0xBE030014)
+#define __set_RAP(X) do { RAP = (X); x = RAP; } while(0)
+#define __set_RDP(X) do { RDP = (X); x = RDP; } while(0)
+#define __get_RDP() ({ RDP & 0xffff; })
+
+	__set_RAP(0);
+	__set_RDP(0x0004);	/* CSR0 = STOP */
+
+	__set_RAP(88);		/* check CSR88 indicates an Am79C973 */
+	BUG_ON(__get_RDP() != 0x5003);
+
+	for (x = 0; x < 100; x++)
+		asm volatile("nop");
+
+	__set_RDP(0x0004);	/* CSR0 = STOP */
+}
+
+/*
+ * initialise the unit hardware
+ */
+asmlinkage void __init unit_pci_init(void)
+{
+	struct pci_bus bus;		/* Fake bus and device */
+	struct pci_ops *o = &pci_direct_ampci;
+	u32 x;
+
+	set_intr_level(XIRQ1, GxICR_LEVEL_3);
+
+	memset(&bus, 0, sizeof(bus));
+
+	MEM_PAGING_REG = 0xE8000000;
+
+	/* we need to set up the bridge _now_ or we won't be able to access the
+	 * PCI config registers
+	 */
+	BRIDGEREGW(PCI_COMMAND) |=
+		PCI_COMMAND_SERR | PCI_COMMAND_PARITY |
+		PCI_COMMAND_MEMORY | PCI_COMMAND_IO | PCI_COMMAND_MASTER;
+	BRIDGEREGW(PCI_STATUS)		= 0xF800;
+	BRIDGEREGB(PCI_LATENCY_TIMER)	= 0x10;
+	BRIDGEREGL(PCI_BASE_ADDRESS_0)	= 0x80000000;
+	BRIDGEREGB(PCI_INTERRUPT_LINE)	= 1;
+	BRIDGEREGL(0x48)		= 0x98000000;	/* AMPCI base addr */
+	BRIDGEREGB(0x41)		= 0x00;		/* secondary bus number */
+	BRIDGEREGB(0x42)		= 0x01;		/* subordinate bus number */
+	BRIDGEREGB(0x44)		= 0x01;
+	BRIDGEREGL(0x50)		= 0x00000001;
+	BRIDGEREGL(0x58)		= 0x00001002;
+	BRIDGEREGL(0x5C)		= 0x00000011;
+
+	/* we also need to set up the PCI-PCI bridge */
+	bus.number = 0;
+
+	/* IO: 0x00000000-0x00020000 */
+	o->read (&bus, PCI_DEVFN(3, 0), PCI_COMMAND,		2, &x);
+	x |= PCI_COMMAND_MASTER |
+		PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
+		PCI_COMMAND_SERR | PCI_COMMAND_PARITY;
+	o->write(&bus, PCI_DEVFN(3, 0), PCI_COMMAND,		2, x);
+
+	o->read (&bus, PCI_DEVFN(3, 0), PCI_IO_BASE,		1, &x);
+	o->read (&bus, PCI_DEVFN(3, 0), PCI_IO_BASE_UPPER16,	4, &x);
+	o->read (&bus, PCI_DEVFN(3, 0), PCI_MEMORY_BASE,	4, &x);
+	o->read (&bus, PCI_DEVFN(3, 0), PCI_PREF_MEMORY_BASE,	4, &x);
+
+	o->write(&bus, PCI_DEVFN(3, 0), PCI_IO_BASE,		1, 0x01);
+	o->read (&bus, PCI_DEVFN(3, 0), PCI_IO_BASE,		1, &x);
+	o->write(&bus, PCI_DEVFN(3, 0), PCI_IO_BASE_UPPER16,	4, 0x00020000);
+	o->read (&bus, PCI_DEVFN(3, 0), PCI_IO_BASE_UPPER16,	4, &x);
+	o->write(&bus, PCI_DEVFN(3, 0), PCI_MEMORY_BASE,	4, 0xEBB0EA00);
+	o->read (&bus, PCI_DEVFN(3, 0), PCI_MEMORY_BASE,	4, &x);
+	o->write(&bus, PCI_DEVFN(3, 0), PCI_PREF_MEMORY_BASE,	4, 0xE9F0E800);
+	o->read (&bus, PCI_DEVFN(3, 0), PCI_PREF_MEMORY_BASE,	4, &x);
+
+	unit_disable_pcnet(&bus, o);
+}
diff -puN /dev/null arch/mn10300/unit-asb2305/pci-iomap.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2305/pci-iomap.c
@@ -0,0 +1,32 @@
+/* ASB2305 PCI I/O mapping handler
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/pci.h>
+#include <linux/module.h>
+
+/*
+ * Create a virtual mapping cookie for a PCI BAR (memory or IO)
+ */
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+{
+	unsigned long start = pci_resource_start(dev, bar);
+	unsigned long len = pci_resource_len(dev, bar);
+	unsigned long flags = pci_resource_flags(dev, bar);
+
+	if (!len || !start)
+		return NULL;
+
+	if ((flags & IORESOURCE_IO) || (flags & IORESOURCE_MEM))
+		return (void __iomem *) start;
+
+	return NULL;
+}
+
+EXPORT_SYMBOL(pci_iomap);
diff -puN /dev/null arch/mn10300/unit-asb2305/pci-irq.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2305/pci-irq.c
@@ -0,0 +1,50 @@
+/* PCI IRQ routing on the MN103E010 based ASB2305
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ *
+ * This is simple: All PCI interrupts route through the CPU's XIRQ1 pin [IRQ 35]
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <asm/io.h>
+#include <asm/smp.h>
+#include "pci-asb2305.h"
+
+void __init pcibios_irq_init(void)
+{
+}
+
+void __init pcibios_fixup_irqs(void)
+{
+	struct pci_dev *dev = NULL;
+	u8 line, pin;
+
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+		if (pin) {
+			dev->irq = XIRQ1;
+			pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
+		}
+		pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &line);
+	}
+}
+
+void __init pcibios_penalize_isa_irq(int irq)
+{
+}
+
+void pcibios_enable_irq(struct pci_dev *dev)
+{
+	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
+}
diff -puN /dev/null arch/mn10300/unit-asb2305/unit-init.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2305/unit-init.c
@@ -0,0 +1,61 @@
+/* ASB2305 Initialisation
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <asm/io.h>
+#include <asm/setup.h>
+#include <asm/processor.h>
+#include <asm/cpu/intctl-regs.h>
+#include <asm/cpu/rtc-regs.h>
+#include <asm/cpu/serial-regs.h>
+#include <asm/unit/serial.h>
+
+/*
+ * initialise some of the unit hardware before gdbstub is set up
+ */
+asmlinkage void __init unit_init(void)
+{
+#ifndef CONFIG_GDBSTUB_ON_TTYSx
+	/* set the 16550 interrupt line to level 3 if not being used for GDB */
+	set_intr_level(XIRQ0, GxICR_LEVEL_3);
+#endif
+}
+
+/*
+ * initialise the rest of the unit hardware after gdbstub is ready
+ */
+void __init unit_setup(void)
+{
+#ifdef CONFIG_PCI
+	unit_pci_init();
+#endif
+}
+
+/*
+ * initialise the external interrupts used by a unit of this type
+ */
+void __init unit_init_IRQ(void)
+{
+	unsigned int extnum;
+
+	for (extnum = 0; extnum < NR_XIRQS; extnum++) {
+		switch (GET_XIRQ_TRIGGER(extnum)) {
+		case XIRQ_TRIGGER_HILEVEL:
+		case XIRQ_TRIGGER_LOWLEVEL:
+			set_irq_handler(XIRQ2IRQ(extnum), handle_level_irq);
+			break;
+		default:
+			break;
+		}
+	}
+}
diff -puN /dev/null Documentation/mn10300/ABI.txt
--- /dev/null
+++ a/Documentation/mn10300/ABI.txt
@@ -0,0 +1,149 @@
+			   =========================
+			   MN10300 FUNCTION CALL ABI
+			   =========================
+
+=======
+GENERAL
+=======
+
+The MN10300/AM33 kernel runs in little-endian mode; big-endian mode is not
+supported.
+
+The stack grows downwards, and should always be 32-bit aligned. There are
+separate stack pointer registers for userspace and the kernel.
+
+
+================
+ARGUMENT PASSING
+================
+
+The first two arguments (assuming up to 32-bits per argument) to a function are
+passed in the D0 and D1 registers respectively; all other arguments are passed
+on the stack.
+
+If 64-bit arguments are being passed, then they are never split between
+registers and the stack. If the first argument is a 64-bit value, it will be
+passed in D0:D1. If the first argument is not a 64-bit value, but the second
+is, the second will be passed entirely on the stack and D1 will be unused.
+
+Arguments smaller than 32-bits are not coelesced within a register or a stack
+word. For example, two byte-sized arguments will always be passed in separate
+registers or word-sized stack slots.
+
+
+=================
+CALLING FUNCTIONS
+=================
+
+The caller must allocate twelve bytes on the stack for the callee's use before
+it inserts a CALL instruction. The CALL instruction will write into the TOS
+word, but won't actually modify the stack pointer; similarly, the RET
+instruction reads from the TOS word of the stack, but doesn't move the stack
+pointer beyond it.
+
+
+	Stack:
+	|		|
+	|		|
+	|---------------| SP+20
+	| 4th Arg	|
+	|---------------| SP+16
+	| 3rd Arg	|
+	|---------------| SP+12
+	| D1 Save Slot	|
+	|---------------| SP+8
+	| D0 Save Slot	|
+	|---------------| SP+4
+	| Return Addr	|
+	|---------------| SP
+	|		|
+	|		|
+
+
+The caller must leave space on the stack (hence an allocation of twelve bytes)
+in which the callee may store the first two arguments.
+
+
+============
+RETURN VALUE
+============
+
+The return value is passed in D0 for an integer (or D0:D1 for a 64-bit value),
+or A0 for a pointer.
+
+If the return value is a value larger than 64-bits, or is a structure or an
+array, then a hidden first argument will be passed to the callee by the caller:
+this will point to a piece of memory large enough to hold the result of the
+function. In this case, the callee will return the value in that piece of
+memory, and no value will be returned in D0 or A0.
+
+
+===================
+REGISTER CLOBBERING
+===================
+
+The values in certain registers may be clobbered by the callee, and other
+values must be saved:
+
+	Clobber:	D0-D1, A0-A1, E0-E3
+	Save:		D2-D3, A2-A3, E4-E7, SP
+
+All other non-supervisor-only registers are clobberable (such as MDR, MCRL,
+MCRH).
+
+
+=================
+SPECIAL REGISTERS
+=================
+
+Certain ordinary registers may carry special usage for the compiler:
+
+	A3:	Frame pointer
+	E2:	TLS pointer
+
+
+==========
+KERNEL ABI
+==========
+
+The kernel may use a slightly different ABI internally.
+
+ (*) E2
+
+     If CONFIG_MN10300_CURRENT_IN_E2 is defined, then the current task pointer
+     will be kept in the E2 register, and that register will be marked
+     unavailable for the compiler to use as a scratch register.
+
+     Normally the kernel uses something like:
+
+	MOV	SP,An
+	AND	0xFFFFE000,An
+	MOV	(An),Rm		// Rm holds current
+	MOV	(yyy,Rm)	// Access current->yyy
+
+     To find the address of current; but since this option permits current to
+     be carried globally in an register, it can use:
+
+	MOV	(yyy,E2)	// Access current->yyy
+
+     instead.
+
+
+===============
+SYSTEM CALL ABI
+===============
+
+System calls are called with the following convention:
+
+	REGISTER	ENTRY			EXIT
+	===============	=======================	=======================
+	D0		Syscall number		Return value
+	A0		1st syscall argument	Saved
+	D1		2nd syscall argument	Saved
+	A3		3rd syscall argument	Saved
+	A2		4th syscall argument	Saved
+	D3		5th syscall argument	Saved
+	D2		6th syscall argument	Saved
+
+All other registers are saved.  The layout is a consequence of the way the MOVM
+instruction stores registers onto the stack.
diff -puN /dev/null Documentation/mn10300/compartmentalisation.txt
--- /dev/null
+++ a/Documentation/mn10300/compartmentalisation.txt
@@ -0,0 +1,60 @@
+		   =========================================
+		   PART-SPECIFIC SOURCE COMPARTMENTALISATION
+		   =========================================
+
+The sources for various parts are compartmentalised at two different levels:
+
+ (1) Processor level
+
+     The "processor level" is a CPU core plus the other on-silicon
+     peripherals.
+
+     Processor-specific header files are divided among directories in a similar
+     way to the CPU level:
+
+	(*) include/asm-mn10300/proc-mn103e010/
+
+	    Support for the AM33v2 CPU core.
+
+     The appropriate processor is selected by a CONFIG_MN10300_PROC_YYYY option
+     from the "Processor support" choice menu in the arch/mn10300/Kconfig file.
+
+
+ (2) Unit level
+
+     The "unit level" is a processor plus all the external peripherals
+     controlled by that processor.
+
+     Unit-specific header files are divided among directories in a similar way
+     to the CPU level; not only that, but specific sources may also be
+     segregated into separate directories under the arch directory:
+
+	(*) include/asm-mn10300/unit-asb2303/
+	(*) arch/mn10300/unit-asb2303/
+
+	    Support for the ASB2303 board with an ASB2308 daughter board.
+
+	(*) include/asm-mn10300/unit-asb2305/
+	(*) arch/mn10300/unit-asb2305/
+
+	    Support for the ASB2305 board.
+
+     The appropriate processor is selected by a CONFIG_MN10300_UNIT_ZZZZ option
+     from the "Unit type" choice menu in the arch/mn10300/Kconfig file.
+
+
+============
+COMPILE TIME
+============
+
+When the kernel is compiled, symbolic links will be made in the asm header file
+directory for this arch:
+
+	include/asm-mn10300/proc => include/asm-mn10300/proc-YYYY/
+	include/asm-mn10300/unit => include/asm-mn10300/unit-ZZZZ/
+
+So that the header files contained in those directories can be accessed without
+lots of #ifdef-age.
+
+The appropriate arch/mn10300/unit-ZZZZ directory will also be entered by the
+compilation process; all other unit-specific directories will be ignored.
diff -puN drivers/input/joystick/analog.c~mn10300-add-the-mn10300-am33-architecture-to-the-kernel drivers/input/joystick/analog.c
--- a/drivers/input/joystick/analog.c~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/drivers/input/joystick/analog.c
@@ -165,6 +165,10 @@ static unsigned int get_time_pit(void)
 #define GET_TIME(x)	do { x = get_cycles(); } while (0)
 #define DELTA(x,y)	((y)-(x))
 #define TIME_NAME	"PCC"
+#elif defined(CONFIG_MN10300)
+#define GET_TIME(x)	do { x = get_cycles(); } while (0)
+#define DELTA(x,y)	((x)-(y))
+#define TIME_NAME	"TSC"
 #else
 #define FAKE_TIME
 static unsigned long analog_faketime = 0;
diff -puN drivers/net/Kconfig~mn10300-add-the-mn10300-am33-architecture-to-the-kernel drivers/net/Kconfig
--- a/drivers/net/Kconfig~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/drivers/net/Kconfig
@@ -888,7 +888,8 @@ config SMC91X
 	tristate "SMC 91C9x/91C1xxx support"
 	select CRC32
 	select MII
-	depends on ARM || REDWOOD_5 || REDWOOD_6 || M32R || SUPERH || SOC_AU1X00 || BFIN
+	depends on ARM || REDWOOD_5 || REDWOOD_6 || M32R || SUPERH || \
+		SOC_AU1X00 || BFIN || MN10300
 	help
 	  This is a driver for SMC's 91x series of Ethernet chipsets,
 	  including the SMC91C94 and the SMC91C111. Say Y if you want it
diff -puN drivers/net/smc91x.h~mn10300-add-the-mn10300-am33-architecture-to-the-kernel drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/drivers/net/smc91x.h
@@ -474,8 +474,20 @@ static inline void LPD7_SMC_outsw (unsig
 
 #define SMC_IRQ_FLAGS		(0)
 
+#elif defined(CONFIG_MN10300)
+
+/*
+ * MN10300/AM33 configuration
+ */
+
+#include <asm/unit/smc91111.h>
+
 #else
 
+/*
+ * Default configuration
+ */
+
 #define SMC_CAN_USE_8BIT	1
 #define SMC_CAN_USE_16BIT	1
 #define SMC_CAN_USE_32BIT	1
diff -puN drivers/parport/Kconfig~mn10300-add-the-mn10300-am33-architecture-to-the-kernel drivers/parport/Kconfig
--- a/drivers/parport/Kconfig~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/drivers/parport/Kconfig
@@ -35,7 +35,8 @@ if PARPORT
 
 config PARPORT_PC
 	tristate "PC-style hardware"
-	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && (!M68K || ISA)
+	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && \
+		(!M68K || ISA) && !MN10300
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
diff -puN drivers/pci/Makefile~mn10300-add-the-mn10300-am33-architecture-to-the-kernel drivers/pci/Makefile
--- a/drivers/pci/Makefile~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/drivers/pci/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_PPC32) += setup-irq.o
 obj-$(CONFIG_PPC64) += setup-bus.o
 obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
 obj-$(CONFIG_X86_VISWS) += setup-irq.o
+obj-$(CONFIG_MN10300) += setup-bus.o
 
 #
 # ACPI Related PCI FW Functions
diff -puN drivers/video/console/Kconfig~mn10300-add-the-mn10300-am33-architecture-to-the-kernel drivers/video/console/Kconfig
--- a/drivers/video/console/Kconfig~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/drivers/video/console/Kconfig
@@ -6,7 +6,7 @@ menu "Console display driver support"
 
 config VGA_CONSOLE
 	bool "VGA text console" if EMBEDDED || !X86
-	depends on !ARCH_ACORN && !ARCH_EBSA110 && !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !ARCH_VERSATILE && !SUPERH && !BFIN
+	depends on !ARCH_ACORN && !ARCH_EBSA110 && !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !ARCH_VERSATILE && !SUPERH && !BFIN && !MN10300
 	default y
 	help
 	  Saying Y here will allow you to use Linux in text mode through a
diff -puN /dev/null include/asm-mn10300/atomic.h
--- /dev/null
+++ a/include/asm-mn10300/atomic.h
@@ -0,0 +1,172 @@
+/* MN10300 Atomic counter operations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_ATOMIC_H
+#define _ASM_ATOMIC_H
+
+#ifdef CONFIG_SMP
+#error not SMP safe
+#endif
+
+/*
+ * Atomic operations that C can't guarantee us.  Useful for
+ * resource counting etc..
+ */
+
+/*
+ * Make sure gcc doesn't try to be clever and move things around
+ * on us. We need to use _exactly_ the address the user gave us,
+ * not some alias that contains the same information.
+ */
+#ifdef CONFIG_SMP
+typedef struct {
+	volatile int counter;
+} atomic_t;
+#else
+typedef struct {
+	int counter;
+} atomic_t;
+#endif
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+#ifdef __KERNEL__
+
+/**
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ * 
+ * Atomically reads the value of @v.  Note that the guaranteed
+ * useful range of an atomic_t is only 24 bits.
+ */ 
+#define atomic_read(v)	((v)->counter)
+
+/**
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ * 
+ * Atomically sets the value of @v to @i.  Note that the guaranteed
+ * useful range of an atomic_t is only 24 bits.
+ */ 
+#define atomic_set(v,i)	(((v)->counter) = (i))
+
+#include <asm/system.h>
+
+/**
+ * atomic_add_return - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ * 
+ * Atomically adds @i to @v and returns the result
+ * Note that the guaranteed useful range of an atomic_t is only 24 bits.
+ */
+static inline int atomic_add_return(int i, atomic_t * v)
+{
+	unsigned long flags;
+	int temp;
+
+	local_irq_save(flags);
+	temp = v->counter;
+	temp += i;
+	v->counter = temp;
+	local_irq_restore(flags);
+
+	return temp;
+}
+
+/**
+ * atomic_sub_return - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ * 
+ * Atomically subtracts @i from @v and returns the result
+ * Note that the guaranteed useful range of an atomic_t is only 24 bits.
+ */
+static inline int atomic_sub_return(int i, atomic_t * v)
+{
+	unsigned long flags;
+	int temp;
+
+	local_irq_save(flags);
+	temp = v->counter;
+	temp -= i;
+	v->counter = temp;
+	local_irq_restore(flags);
+
+	return temp;
+}
+
+static inline int atomic_add_negative(int i, atomic_t *v)
+{
+	return atomic_add_return(i, v) < 0;
+}
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	atomic_add_return(i, v);
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	atomic_sub_return(i, v);
+}
+
+static inline void atomic_inc(atomic_t *v)
+{
+	atomic_add_return(1, v);
+}
+
+static inline void atomic_dec(atomic_t *v)
+{
+	atomic_sub_return(1, v);
+}
+
+#define atomic_dec_return(v)		atomic_sub_return(1, (v))
+#define atomic_inc_return(v)		atomic_add_return(1, (v))
+
+#define atomic_sub_and_test(i,v)	(atomic_sub_return((i), (v)) == 0)
+#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
+#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
+
+#define atomic_add_unless(v, a, u)				\
+({								\
+	int c, old;						\
+	c = atomic_read(v);					\
+	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
+		c = old;					\
+	c != (u);						\
+})
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+{
+	unsigned long flags;
+
+	mask = ~mask;
+	local_irq_save(flags);
+	*addr &= mask;
+	local_irq_restore(flags);
+}
+
+#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
+#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
+
+/* Atomic operations are already serializing on MN10300??? */
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+#include <asm-generic/atomic.h>
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_ATOMIC_H */
diff -puN /dev/null include/asm-mn10300/auxvec.h
--- /dev/null
+++ a/include/asm-mn10300/auxvec.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_AUXVEC_H
+#define _ASM_AUXVEC_H
+
+#endif
diff -puN /dev/null include/asm-mn10300/bitops.h
--- /dev/null
+++ a/include/asm-mn10300/bitops.h
@@ -0,0 +1,234 @@
+/* MN10300 bit operations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ *
+ * These have to be done with inline assembly: that way the bit-setting
+ * is guaranteed to be atomic. All bit operations return 0 if the bit
+ * was cleared before the operation and != 0 if it was not.
+ *
+ * bit 0 is the LSB of addr; bit 32 is the LSB of (addr+1).
+ */
+#ifndef __ASM_BITOPS_H
+#define __ASM_BITOPS_H
+
+#include <asm/cpu-regs.h>
+
+/*
+ * Some hacks to defeat gcc over-optimizations..
+ */
+struct __dummy { unsigned long a[100]; };
+#define ADDR (*(volatile struct __dummy *) addr)
+#define CONST_ADDR (*(volatile const struct __dummy *) addr)
+
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+
+/*
+ * set bit
+ */
+#define __set_bit(nr,addr)					\
+({								\
+        volatile unsigned char *_a = (unsigned char *)(addr);	\
+	const unsigned shift = (nr) & 7;			\
+	_a += (nr) >> 3;					\
+								\
+	asm volatile("bset %2,(%1) # set_bit reg"		\
+		     : "=m"(*_a)				\
+		     : "a"(_a), "d"(1 << shift),  "m"(*_a)	\
+		     : "memory", "cc");				\
+})
+
+#define set_bit(nr,addr) __set_bit((nr),(addr))
+
+/*
+ * clear bit
+ */
+#define ___clear_bit(nr,addr)					\
+({								\
+        volatile unsigned char *_a = (unsigned char *)(addr);	\
+	const unsigned shift = (nr) & 7;			\
+	_a += (nr) >> 3;					\
+								\
+	asm volatile("bclr %2,(%1) # clear_bit reg"		\
+		     : "=m"(*_a)				\
+		     : "a"(_a), "d"(1 << shift), "m"(*_a)	\
+		     : "memory", "cc");				\
+})
+
+#define clear_bit(nr,addr) ___clear_bit((nr),(addr))
+
+
+static inline void __clear_bit(int nr, volatile void * addr)
+{
+        unsigned int *a = (unsigned int *)addr;
+        int mask;
+
+        a += nr >> 5;
+        mask = 1 << (nr & 0x1f);
+        *a &= ~mask;
+}
+
+/*
+ * test bit
+ */
+static inline int test_bit(int nr, const volatile void * addr)
+{
+        return 1UL & (((const unsigned int *) addr)[nr >> 5] >> (nr & 31));
+}
+
+/*
+ * change bit
+ */
+static inline void __change_bit(int nr, volatile void * addr)
+{
+	int	mask;
+	unsigned int *a = (unsigned int *) addr;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 0x1f);
+	*a ^= mask;
+}
+
+extern void change_bit(int nr, volatile void * addr);
+
+/*
+ * test and set bit
+ */
+#define __test_and_set_bit(nr,addr)				\
+({								\
+        volatile unsigned char *_a = (unsigned char *)(addr);	\
+	const unsigned shift = (nr) & 7;			\
+	unsigned epsw;						\
+	_a += (nr) >> 3;					\
+								\
+	asm volatile("bset %3,(%2) # test_set_bit reg\n"	\
+		     "mov epsw,%1"				\
+		     : "=m"(*_a), "=d"(epsw)			\
+		     : "a"(_a), "d"(1 << shift), "m"(*_a)	\
+		     : "memory", "cc");				\
+								\
+	!(epsw & EPSW_FLAG_Z);					\
+})
+
+#define test_and_set_bit(nr,addr) __test_and_set_bit((nr),(addr))
+
+/*
+ * test and clear bit
+ */
+#define __test_and_clear_bit(nr,addr)				\
+({								\
+        volatile unsigned char *_a = (unsigned char *)(addr);	\
+	const unsigned shift = (nr) & 7;			\
+	unsigned epsw;						\
+	_a += (nr) >> 3;					\
+								\
+	asm volatile("bclr %3,(%2) # test_clear_bit reg\n"	\
+		     "mov epsw,%1"				\
+		     : "=m"(*_a), "=d"(epsw)			\
+		     : "a"(_a), "d"(1 << shift), "m"(*_a)	\
+		     : "memory", "cc");				\
+								\
+	!(epsw & EPSW_FLAG_Z);					\
+})
+
+#define test_and_clear_bit(nr,addr) __test_and_clear_bit((nr),(addr))
+
+/*
+ * test and change bit
+ */
+static inline int __test_and_change_bit(int nr, volatile void * addr)
+{
+	int	mask, retval;
+	unsigned int *a = (unsigned int *)addr;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 0x1f);
+	retval = (mask & *a) != 0;
+	*a ^= mask;
+
+	return retval;
+}
+
+extern int test_and_change_bit(int nr, volatile void * addr);
+
+#include <asm-generic/bitops/lock.h>
+
+#ifdef __KERNEL__
+
+/**
+ * __ffs - find first bit set
+ * @x: the word to search
+ *
+ * - return 31..0 to indicate bit 31..0 most least significant bit set
+ * - if no bits are set in x, the result is undefined
+ */
+static inline __attribute__((const))
+unsigned long __ffs(unsigned long x)
+{
+	int bit;
+	asm("bsch %2,%0" : "=r"(bit) : "0"(0), "r"(x & -x));
+	return bit;
+}
+
+/*
+ * special slimline version of fls() for calculating ilog2_u32()
+ * - note: no protection against n == 0
+ */
+static inline __attribute__((const))
+int __ilog2_u32(u32 n)
+{
+	int bit;
+	asm("bsch %2,%0" : "=r"(bit) : "0"(0), "r"(n));
+	return bit;
+}
+
+/**
+ * fls - find last bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as ffs:
+ * - return 32..1 to indicate bit 31..0 most significant bit set
+ * - return 0 to indicate no bits set
+ */
+static inline __attribute__((const))
+int fls(int x)
+{
+	return (x != 0) ? __ilog2_u32(x) + 1 : 0;
+}
+
+/**
+ * ffs - find first bit set
+ * @x: the word to search
+ *
+ * - return 32..1 to indicate bit 31..0 most least significant bit set
+ * - return 0 to indicate no bits set
+ */
+static inline __attribute__((const))
+int ffs(int x)
+{
+	/* Note: (x & -x) gives us a mask that is the least significant
+	 * (rightmost) 1-bit of the value in x.
+	 */
+	return fls(x & -x);
+}
+
+#include <asm-generic/bitops/ffz.h>
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/find.h>
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/hweight.h>
+
+#define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
+#define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
+
+#include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/minix-le.h>
+
+#endif /* __KERNEL__ */
+#endif /* __ASM_BITOPS_H */
diff -puN /dev/null include/asm-mn10300/bug.h
--- /dev/null
+++ a/include/asm-mn10300/bug.h
@@ -0,0 +1,35 @@
+/* MN10300 Kernel bug reporting
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_BUG_H
+#define _ASM_BUG_H
+
+/*
+ * Tell the user there is some problem.
+ */
+#define _debug_bug_trap()					\
+do {								\
+	asm volatile(						\
+		"	syscall 15			\n"	\
+		"0:					\n"	\
+		"	.section __bug_table,\"a\"	\n"	\
+		"	.long 0b,%0,%1			\n"	\
+		"	.previous			\n"	\
+		:						\
+		: "i"(__FILE__), "i"(__LINE__)			\
+		);						\
+} while(0)
+
+#define BUG() _debug_bug_trap()
+
+#define HAVE_ARCH_BUG
+#include <asm-generic/bug.h>
+
+#endif /* _ASM_BUG_H */
diff -puN /dev/null include/asm-mn10300/bugs.h
--- /dev/null
+++ a/include/asm-mn10300/bugs.h
@@ -0,0 +1,20 @@
+/* MN10300 Checks for architecture-dependent bugs
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_BUGS_H
+#define _ASM_BUGS_H
+
+#include <asm/processor.h>
+
+static inline void __init check_bugs(void)
+{
+}
+
+#endif /* _ASM_BUGS_H */
diff -puN /dev/null include/asm-mn10300/busctl-regs.h
--- /dev/null
+++ a/include/asm-mn10300/busctl-regs.h
@@ -0,0 +1,151 @@
+/* AM33v2 on-board bus controller registers
+ *
+ * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_BUSCTL_REGS_H
+#define _ASM_BUSCTL_REGS_H
+
+#include <asm/cpu-regs.h>
+
+#ifdef __KERNEL__
+
+/* bus controller registers */
+#define BCCR			__SYSREG(0xc0002000,u32)	/* bus controller control reg */
+#define BCCR_B0AD		0x00000003	/* block 0 (80000000-83ffffff) bus allocation */
+#define BCCR_B1AD		0x0000000c	/* block 1 (84000000-87ffffff) bus allocation */
+#define BCCR_B2AD		0x00000030	/* block 2 (88000000-8bffffff) bus allocation */
+#define BCCR_B3AD		0x000000c0	/* block 3 (8c000000-8fffffff) bus allocation */
+#define BCCR_B4AD		0x00000300	/* block 4 (90000000-93ffffff) bus allocation */
+#define BCCR_B5AD		0x00000c00	/* block 5 (94000000-97ffffff) bus allocation */
+#define BCCR_B6AD		0x00003000	/* block 6 (98000000-9bffffff) bus allocation */
+#define BCCR_B7AD		0x0000c000	/* block 7 (9c000000-9fffffff) bus allocation */
+#define BCCR_BxAD_EXBUS		0x0		/* - direct to system bus controller */
+#define BCCR_BxAD_OPEXBUS	0x1		/* - direct to memory bus controller */
+#define BCCR_BxAD_OCMBUS	0x2		/* - direct to on chip memory */
+#define BCCR_API		0x00070000	/* bus arbitration priority */
+#define BCCR_API_DMACICD	0x00000000	/* - DMA > CI > CD */
+#define BCCR_API_DMACDCI	0x00010000	/* - DMA > CD > CI */
+#define BCCR_API_CICDDMA	0x00020000	/* - CI > CD > DMA */
+#define BCCR_API_CDCIDMA	0x00030000	/* - CD > CI > DMA */
+#define BCCR_API_ROUNDROBIN	0x00040000	/* - round robin */
+#define BCCR_BEPRI_DMACICD	0x00c00000	/* bus error address priority */
+#define BCCR_BEPRI_DMACDCI	0x00000000	/* - DMA > CI > CD */
+#define BCCR_BEPRI_CICDDMA	0x00400000	/* - DMA > CD > CI */
+#define BCCR_BEPRI_CDCIDMA	0x00800000	/* - CI > CD > DMA */
+#define BCCR_BEPRI		0x00c00000	/* - CD > CI > DMA */
+#define BCCR_TMON		0x03000000	/* timeout value settings */
+#define BCCR_TMON_16IOCLK	0x00000000	/* - 16 IOCLK cycles */
+#define BCCR_TMON_256IOCLK	0x01000000	/* - 256 IOCLK cycles */
+#define BCCR_TMON_4096IOCLK	0x02000000	/* - 4096 IOCLK cycles */
+#define BCCR_TMON_65536IOCLK	0x03000000	/* - 65536 IOCLK cycles */
+#define BCCR_TMOE		0x10000000	/* timeout detection enable */
+
+#define BCBERR			__SYSREG(0xc0002010,u32)	/* bus error source reg */
+#define BCBERR_BESB		0x0000001f	/* erroneous access destination space */
+#define BCBERR_BESB_MON		0x00000001	/* - monitor space */
+#define BCBERR_BESB_IO		0x00000002	/* - IO bus */
+#define BCBERR_BESB_EX		0x00000004	/* - EX bus */
+#define BCBERR_BESB_OPEX	0x00000008	/* - OpEX bus */
+#define BCBERR_BESB_OCM		0x00000010	/* - on chip memory */
+#define BCBERR_BERW		0x00000100	/* type of access */
+#define BCBERR_BERW_WRITE	0x00000000	/* - write */
+#define BCBERR_BERW_READ	0x00000100	/* - read */
+#define BCBERR_BESD		0x00000200	/* error detector */
+#define BCBERR_BESD_BCU		0x00000000	/* - BCU detected error */
+#define BCBERR_BESD_SLAVE_BUS	0x00000200	/* - slave bus detected error */
+#define BCBERR_BEBST		0x00000400	/* type of access */
+#define BCBERR_BEBST_SINGLE	0x00000000	/* - single */
+#define BCBERR_BEBST_BURST	0x00000400	/* - burst */
+#define BCBERR_BEME		0x00000800	/* multiple bus error flag */
+#define BCBERR_BEMR		0x00007000	/* master bus that caused the error */
+#define BCBERR_BEMR_NOERROR	0x00000000	/* - no error */
+#define BCBERR_BEMR_CI		0x00001000	/* - CPU instruction fetch bus caused error */
+#define BCBERR_BEMR_CD		0x00002000	/* - CPU data bus caused error */
+#define BCBERR_BEMR_DMA		0x00004000	/* - DMA bus caused error */
+
+#define BCBEAR			__SYSREGC(0xc0002020,u32)	/* bus error address reg */
+
+/* system bus controller registers */
+#define SBBASE(X)		__SYSREG(0xd8c00100+(X)*0x10,u32)	/* SBC base addr regs */
+#define SBBASE_BE		0x00000001	/* bank enable */
+#define SBBASE_BAM		0x0000fffe	/* bank address mask [31:17] */
+#define SBBASE_BBA		0xfffe0000	/* bank base address [31:17] */
+
+#define SBCNTRL0(X)		__SYSREG(0xd8c00200+(X)*0x10,u32)	/* SBC bank ctrl0 regs */
+#define SBCNTRL0_WEH		0x00000f00	/* write enable hold */
+#define SBCNTRL0_REH		0x0000f000	/* read enable hold */
+#define SBCNTRL0_RWH		0x000f0000	/* SRW signal hold */
+#define SBCNTRL0_CSH		0x00f00000	/* chip select hold */
+#define SBCNTRL0_DAH		0x0f000000	/* data hold */
+#define SBCNTRL0_ADH		0xf0000000	/* address hold */
+
+#define SBCNTRL1(X)		__SYSREG(0xd8c00204+(X)*0x10,u32)	/* SBC bank ctrl1 regs */
+#define SBCNTRL1_WED		0x00000f00	/* write enable delay */
+#define SBCNTRL1_RED		0x0000f000	/* read enable delay */
+#define SBCNTRL1_RWD		0x000f0000	/* SRW signal delay */
+#define SBCNTRL1_ASW		0x00f00000	/* address strobe width */
+#define SBCNTRL1_CSD		0x0f000000	/* chip select delay */
+#define SBCNTRL1_ASD		0xf0000000	/* address strobe delay */
+
+#define SBCNTRL2(X)		__SYSREG(0xd8c00208+(X)*0x10,u32)	/* SBC bank ctrl2 regs */
+#define SBCNTRL2_WC		0x000000ff	/* wait count */
+#define SBCNTRL2_BWC		0x00000f00	/* burst wait count */
+#define SBCNTRL2_WM		0x01000000	/* wait mode setting */
+#define SBCNTRL2_WM_FIXEDWAIT	0x00000000	/* - fixed wait access */
+#define SBCNTRL2_WM_HANDSHAKE	0x01000000	/* - handshake access */
+#define SBCNTRL2_BM		0x02000000	/* bus synchronisation mode */
+#define SBCNTRL2_BM_SYNC	0x00000000	/* - synchronous mode */
+#define SBCNTRL2_BM_ASYNC	0x02000000	/* - asynchronous mode */
+#define SBCNTRL2_BW		0x04000000	/* bus width */
+#define SBCNTRL2_BW_32		0x00000000	/* - 32 bits */
+#define SBCNTRL2_BW_16		0x04000000	/* - 16 bits */
+#define SBCNTRL2_RWINV		0x08000000	/* R/W signal invert polarity */
+#define SBCNTRL2_RWINV_NORM	0x00000000	/* - normal (read high) */
+#define SBCNTRL2_RWINV_INV	0x08000000	/* - inverted (read low) */
+#define SBCNTRL2_BT		0x70000000	/* bus type setting */
+#define SBCNTRL2_BT_SRAM	0x00000000	/* - SRAM interface */
+#define SBCNTRL2_BT_ADMUX	0x00000000	/* - addr/data multiplexed interface */
+#define SBCNTRL2_BT_BROM	0x00000000	/* - burst ROM interface */
+#define SBCNTRL2_BTSE		0x80000000	/* burst enable */
+
+/* memory bus controller */
+#define SDBASE(X)		__SYSREG(0xda000008+(X)*0x4,u32)	/* MBC base addr regs */
+#define SDBASE_CE		0x00000001	/* chip enable */
+#define SDBASE_CBAM		0x0000fff0	/* chip base address mask [31:20] */
+#define SDBASE_CBAM_SHIFT	16
+#define SDBASE_CBA		0xfff00000	/* chip base address [31:20] */
+
+#define SDRAMBUS		__SYSREG(0xda000000,u32)	/* bus mode control reg */
+#define SDRAMBUS_REFEN		0x00000004	/* refresh enable */
+#define SDRAMBUS_TRC		0x00000018	/* refresh command delay time */
+#define SDRAMBUS_BSTPT		0x00000020	/* burst stop command enable */
+#define SDRAMBUS_PONSEQ		0x00000040	/* power on sequence */
+#define SDRAMBUS_SELFREQ	0x00000080	/* self-refresh mode request */
+#define SDRAMBUS_SELFON		0x00000100	/* self-refresh mode on */
+#define SDRAMBUS_SIZE		0x00030000	/* SDRAM size */
+#define SDRAMBUS_SIZE_64Mbit	0x00010000	/* 64Mbit SDRAM (x16) */
+#define SDRAMBUS_SIZE_128Mbit	0x00020000	/* 128Mbit SDRAM (x16) */
+#define SDRAMBUS_SIZE_256Mbit	0x00030000	/* 256Mbit SDRAM (x16) */
+#define SDRAMBUS_TRASWAIT	0x000c0000	/* row address precharge command cycle number */
+#define SDRAMBUS_REFNUM		0x00300000	/* refresh command number */
+#define SDRAMBUS_BSTWAIT	0x00c00000	/* burst stop command cycle */
+#define SDRAMBUS_SETWAIT	0x03000000	/* mode register setting command cycle */
+#define SDRAMBUS_PREWAIT	0x0c000000	/* precharge command cycle */
+#define SDRAMBUS_RASLATE	0x30000000	/* RAS latency */
+#define SDRAMBUS_CASLATE	0xc0000000	/* CAS latency */
+
+#define SDREFCNT		__SYSREG(0xda000004,u32)	/* refresh period reg */
+#define SDREFCNT_PERI		0x00000fff	/* refresh period */
+
+#define SDSHDW			__SYSREG(0xda000010,u32)	/* test reg */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_BUSCTL_REGS_H */
diff -puN /dev/null include/asm-mn10300/byteorder.h
--- /dev/null
+++ a/include/asm-mn10300/byteorder.h
@@ -0,0 +1,46 @@
+/* MN10300 Byte-order primitive construction
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_BYTEORDER_H
+#define _ASM_BYTEORDER_H
+
+#include <asm/types.h>
+
+#ifdef __GNUC__
+
+static inline __attribute__((const))
+__u32 ___arch__swab32(__u32 x)
+{
+	__u32 ret;
+	asm("swap %1,%0" : "=r" (ret) : "r" (x));
+	return ret;
+}
+
+static inline __attribute__((const))
+__u16 ___arch__swab16(__u16 x)
+{
+	__u16 ret;
+	asm("swaph %1,%0" : "=r" (ret) : "r" (x));
+	return ret;
+}
+
+#define __arch__swab32(x) ___arch__swab32(x)
+#define __arch__swab16(x) ___arch__swab16(x)
+
+#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __BYTEORDER_HAS_U64__
+#  define __SWAB_64_THRU_32__
+#endif
+
+#endif /* __GNUC__ */
+
+#include <linux/byteorder/little_endian.h>
+
+#endif /* _ASM_BYTEORDER_H */
diff -puN /dev/null include/asm-mn10300/cacheflush.h
--- /dev/null
+++ a/include/asm-mn10300/cacheflush.h
@@ -0,0 +1,113 @@
+/* MN10300 Cache flushing
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_CACHEFLUSH_H
+#define _ASM_CACHEFLUSH_H
+
+#ifndef __ASSEMBLY__
+
+/* Keep includes the same across arches.  */
+#include <linux/mm.h>
+
+/*
+ * virtually-indexed cache managment (our cache is physically indexed)
+ */
+#define flush_cache_all()			do {} while(0)
+#define flush_cache_mm(mm)			do {} while(0)
+#define flush_cache_dup_mm(mm)			do {} while(0)
+#define flush_cache_range(mm, start, end)	do {} while(0)
+#define flush_cache_page(vma, vmaddr, pfn)	do {} while(0)
+#define flush_cache_vmap(start, end)		do {} while(0)
+#define flush_cache_vunmap(start, end)		do {} while(0)
+#define flush_dcache_page(page)			do {} while(0)
+#define flush_dcache_mmap_lock(mapping)		do {} while(0)
+#define flush_dcache_mmap_unlock(mapping)	do {} while(0)
+
+/*
+ * physically-indexed cache managment
+ */
+#ifndef CONFIG_MN10300_CACHE_DISABLED
+
+extern void flush_icache_range(unsigned long start, unsigned long end);
+extern void flush_icache_page(struct vm_area_struct *vma, struct page *pg);
+
+#else
+
+#define flush_icache_range(start, end)		do {} while(0)
+#define flush_icache_page(vma, pg)		do {} while(0)
+
+#endif
+
+#define flush_icache_user_range(vma, pg, adr, len) \
+	flush_icache_range(adr, adr + len)
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
+	do {					\
+		memcpy(dst, src, len);		\
+		flush_icache_page(vma, page);	\
+	} while (0)
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+
+/*
+ * primitive routines
+ */
+#ifndef CONFIG_MN10300_CACHE_DISABLED
+extern void mn10300_icache_inv(void);
+extern void mn10300_dcache_inv(void);
+extern void mn10300_dcache_inv_page(unsigned start);
+extern void mn10300_dcache_inv_range(unsigned start, unsigned end);
+extern void mn10300_dcache_inv_range2(unsigned start, unsigned size);
+#ifdef CONFIG_MN10300_CACHE_WBACK
+extern void mn10300_dcache_flush(void);
+extern void mn10300_dcache_flush_page(unsigned start);
+extern void mn10300_dcache_flush_range(unsigned start, unsigned end);
+extern void mn10300_dcache_flush_range2(unsigned start, unsigned size);
+extern void mn10300_dcache_flush_inv(void);
+extern void mn10300_dcache_flush_inv_page(unsigned start);
+extern void mn10300_dcache_flush_inv_range(unsigned start, unsigned end);
+extern void mn10300_dcache_flush_inv_range2(unsigned start, unsigned size);
+#else
+#define mn10300_dcache_flush()				do {} while(0)
+#define mn10300_dcache_flush_page(start)		do {} while(0)
+#define mn10300_dcache_flush_range(start, end)		do {} while(0)
+#define mn10300_dcache_flush_range2(start, size)	do {} while(0)
+#define mn10300_dcache_flush_inv()			mn10300_dcache_inv()
+#define mn10300_dcache_flush_inv_page(start)		mn10300_dcache_inv_page(start)
+#define mn10300_dcache_flush_inv_range(start, end)	mn10300_dcache_inv_range(start, end)
+#define mn10300_dcache_flush_inv_range2(start, size)	mn10300_dcache_inv_range2(start, size)
+#endif /* CONFIG_MN10300_CACHE_WBACK */
+#else
+#define mn10300_icache_inv()				do {} while(0)
+#define mn10300_dcache_inv()				do {} while(0)
+#define mn10300_dcache_inv_page(start)			do {} while(0)
+#define mn10300_dcache_inv_range(start, end)		do {} while(0)
+#define mn10300_dcache_inv_range2(start, size)		do {} while(0)
+#define mn10300_dcache_flush()				do {} while(0)
+#define mn10300_dcache_flush_inv_page(start)		do {} while(0)
+#define mn10300_dcache_flush_inv()			do {} while(0)
+#define mn10300_dcache_flush_inv_range(start, end)	do {} while(0)
+#define mn10300_dcache_flush_inv_range2(start, size)	do {} while(0)
+#define mn10300_dcache_flush_page(start)		do {} while(0)
+#define mn10300_dcache_flush_range(start, end)		do {} while(0)
+#define mn10300_dcache_flush_range2(start, size)	do {} while(0)
+#endif /* CONFIG_MN10300_CACHE_DISABLED */
+
+/*
+ * internal debugging function
+ */
+#ifdef CONFIG_DEBUG_PAGEALLOC
+extern void kernel_map_pages(struct page *page, int numpages, int enable);
+#endif
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_CACHEFLUSH_H */
diff -puN /dev/null include/asm-mn10300/cache.h
--- /dev/null
+++ a/include/asm-mn10300/cache.h
@@ -0,0 +1,53 @@
+/* MN10300 cache management registers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_CACHE_H
+#define _ASM_CACHE_H
+
+#include <asm/cpu-regs.h>
+#include <asm/proc/cache.h>
+
+#ifndef __ASSEMBLY__
+#define L1_CACHE_DISPARITY	(L1_CACHE_NENTRIES * L1_CACHE_BYTES)
+#else
+#define L1_CACHE_DISPARITY	L1_CACHE_NENTRIES * L1_CACHE_BYTES
+#endif
+
+/* data cache purge registers
+ * - read from the register to unconditionally purge that cache line
+ * - write address & 0xffffff00 to conditionally purge that cache line
+ *   - clear LSB to request invalidation as well
+ */
+#define DCACHE_PURGE(WAY, ENTRY) \
+	__SYSREG(0xc8400000 + (WAY) * L1_CACHE_WAYDISP + (ENTRY) * L1_CACHE_BYTES, u32)
+
+#define DCACHE_PURGE_WAY0(ENTRY) \
+	__SYSREG(0xc8400000 + 0 * L1_CACHE_WAYDISP + (ENTRY) * L1_CACHE_BYTES, u32)
+#define DCACHE_PURGE_WAY1(ENTRY) \
+	__SYSREG(0xc8400000 + 1 * L1_CACHE_WAYDISP + (ENTRY) * L1_CACHE_BYTES, u32)
+#define DCACHE_PURGE_WAY2(ENTRY) \
+	__SYSREG(0xc8400000 + 2 * L1_CACHE_WAYDISP + (ENTRY) * L1_CACHE_BYTES, u32)
+#define DCACHE_PURGE_WAY3(ENTRY) \
+	__SYSREG(0xc8400000 + 3 * L1_CACHE_WAYDISP + (ENTRY) * L1_CACHE_BYTES, u32)
+
+/* instruction cache access registers */
+#define ICACHE_DATA(WAY, ENTRY, OFF) \
+	__SYSREG(0xc8000000 + (WAY) * L1_CACHE_WAYDISP + (ENTRY) * 0x10 + (OFF) * 4, u32)
+#define ICACHE_TAG(WAY, ENTRY)	 \
+	__SYSREG(0xc8100000 + (WAY) * L1_CACHE_WAYDISP + (ENTRY) * 0x10, u32)
+
+/* instruction cache access registers */
+#define DCACHE_DATA(WAY, ENTRY, OFF) \
+	__SYSREG(0xc8200000 + (WAY) * L1_CACHE_WAYDISP + (ENTRY) * 0x10 + (OFF) * 4, u32)
+#define DCACHE_TAG(WAY, ENTRY)	 \
+	__SYSREG(0xc8300000 + (WAY) * L1_CACHE_WAYDISP + (ENTRY) * 0x10, u32)
+
+#endif /* _ASM_CACHE_H */
diff -puN /dev/null include/asm-mn10300/checksum.h
--- /dev/null
+++ a/include/asm-mn10300/checksum.h
@@ -0,0 +1,86 @@
+/* MN10300 Optimised checksumming code
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_CHECKSUM_H
+#define _ASM_CHECKSUM_H
+
+extern __wsum csum_partial(const void *buff, int len, __wsum sum);
+extern __wsum csum_partial_copy_nocheck(const void *src, void *dst,
+					int len, __wsum sum);
+extern __wsum csum_partial_copy_from_user(const void *src, void *dst,
+					  int len, __wsum sum,
+					  int *err_ptr);
+extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
+extern __wsum csum_partial(const void *buff, int len, __wsum sum);
+extern __sum16 ip_compute_csum(const void *buff, int len);
+
+#define csum_partial_copy_fromuser csum_partial_copy
+extern __wsum csum_partial_copy(const void *src, void *dst, int len,
+				__wsum sum);
+
+static inline __sum16 csum_fold(__wsum sum)
+{
+	asm(
+		"	add	%1,%0		\n"
+		"	addc	0xffff,%0	\n"
+		: "=r" (sum)
+		: "r" (sum << 16), "0" (sum & 0xffff0000)
+		: "cc"
+	    );
+	return (~sum) >> 16;
+}
+
+static inline __wsum csum_tcpudp_nofold(unsigned long saddr,
+					unsigned long daddr,
+					unsigned short len,
+					unsigned short proto,
+					__wsum sum)
+{
+	__wsum tmp;
+
+	tmp = (__wsum) ntohs(len) << 16;
+	tmp += (__wsum) proto << 8;
+
+	asm(
+		"	add	%1,%0		\n"
+		"	addc	%2,%0		\n"
+		"	addc	%3,%0		\n"
+		"	addc	0,%0		\n"
+		: "=r" (sum)
+		: "r" (daddr), "r"(saddr), "r"(tmp), "0"(sum)
+		: "cc"
+	    );
+	return sum;
+}
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline __sum16 csum_tcpudp_magic(unsigned long saddr,
+					unsigned long daddr,
+					unsigned short len,
+					unsigned short proto,
+					__wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+#undef _HAVE_ARCH_IPV6_CSUM
+
+/*
+ *	Copy and checksum to user
+ */
+#define HAVE_CSUM_COPY_USER
+extern __wsum csum_and_copy_to_user(const void *src, void *dst, int len,
+				    __wsum sum, int *err_ptr);
+
+
+#endif /* _ASM_CHECKSUM_H */
diff -puN /dev/null include/asm-mn10300/cpu-regs.h
--- /dev/null
+++ a/include/asm-mn10300/cpu-regs.h
@@ -0,0 +1,290 @@
+/* MN10300 Core system registers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_CPU_REGS_H
+#define _ASM_CPU_REGS_H
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#endif
+
+#ifdef CONFIG_MN10300_CPU_AM33V2
+/* we tell the compiler to pretend to be AM33 so that it doesn't try and use
+ * the FP regs, but tell the assembler that we're actually allowed AM33v2
+ * instructions */
+#ifndef __ASSEMBLY__
+asm(" .am33_2\n");
+#else
+.am33_2
+#endif
+#endif
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+#define __SYSREG(ADDR,TYPE) (*(volatile TYPE *)(ADDR))
+#define __SYSREGC(ADDR,TYPE) (*(const volatile TYPE *)(ADDR))
+#else
+#define __SYSREG(ADDR,TYPE) ADDR
+#define __SYSREGC(ADDR,TYPE) ADDR
+#endif
+
+/* CPU registers */
+#define EPSW_FLAG_Z		0x00000001	/* zero flag */
+#define EPSW_FLAG_N		0x00000002	/* negative flag */
+#define EPSW_FLAG_C		0x00000004	/* carry flag */
+#define EPSW_FLAG_V		0x00000008	/* overflow flag */
+#define EPSW_IM			0x00000700	/* interrupt mode */
+#define EPSW_IM_0		0x00000000	/* interrupt mode 0 */
+#define EPSW_IM_1		0x00000100	/* interrupt mode 1 */
+#define EPSW_IM_2		0x00000200	/* interrupt mode 2 */
+#define EPSW_IM_3		0x00000300	/* interrupt mode 3 */
+#define EPSW_IM_4		0x00000400	/* interrupt mode 4 */
+#define EPSW_IM_5		0x00000500	/* interrupt mode 5 */
+#define EPSW_IM_6		0x00000600	/* interrupt mode 6 */
+#define EPSW_IM_7		0x00000700	/* interrupt mode 7 */
+#define EPSW_IE			0x00000800	/* interrupt enable */
+#define EPSW_S			0x00003000	/* software auxilliary bits */
+#define EPSW_T			0x00008000	/* trace enable */
+#define EPSW_nSL		0x00010000	/* not supervisor level */
+#define EPSW_NMID		0x00020000	/* nonmaskable interrupt disable */
+#define EPSW_nAR		0x00040000	/* register bank control */
+#define EPSW_ML			0x00080000	/* monitor level */
+#define EPSW_FE			0x00100000	/* FPU enable */
+
+/* FPU registers */
+#define FPCR_EF_I		0x00000001	/* inexact result FPU exception flag */
+#define FPCR_EF_U		0x00000002	/* underflow FPU exception flag */
+#define FPCR_EF_O		0x00000004	/* overflow FPU exception flag */
+#define FPCR_EF_Z		0x00000008	/* zero divide FPU exception flag */
+#define FPCR_EF_V		0x00000010	/* invalid operand FPU exception flag */
+#define FPCR_EE_I		0x00000020	/* inexact result FPU exception enable */
+#define FPCR_EE_U		0x00000040	/* underflow FPU exception enable */
+#define FPCR_EE_O		0x00000080	/* overflow FPU exception enable */
+#define FPCR_EE_Z		0x00000100	/* zero divide FPU exception enable */
+#define FPCR_EE_V		0x00000200	/* invalid operand FPU exception enable */
+#define FPCR_EC_I		0x00000400	/* inexact result FPU exception cause */
+#define FPCR_EC_U		0x00000800	/* underflow FPU exception cause */
+#define FPCR_EC_O		0x00001000	/* overflow FPU exception cause */
+#define FPCR_EC_Z		0x00002000	/* zero divide FPU exception cause */
+#define FPCR_EC_V		0x00004000	/* invalid operand FPU exception cause */
+#define FPCR_RM			0x00030000	/* rounding mode */
+#define FPCR_RM_NEAREST		0x00000000	/* - round to nearest value */
+#define FPCR_FCC_U		0x00040000	/* FPU unordered condition code */
+#define FPCR_FCC_E		0x00080000	/* FPU equal condition code */
+#define FPCR_FCC_G		0x00100000	/* FPU greater than condition code */
+#define FPCR_FCC_L		0x00200000	/* FPU less than condition code */
+#define FPCR_INIT		0x00000000	/* no exceptions, rounding to nearest */
+
+/* CPU control registers */
+#define CPUP			__SYSREG(0xc0000020,u16)	/* CPU pipeline register */
+#define CPUP_DWBD		0x0020		/* write buffer disable flag */
+#define CPUP_IPFD		0x0040		/* instruction prefetch disable flag */
+#define CPUP_EXM		0x0080		/* exception operation mode */
+#define CPUP_EXM_AM33V1		0x0000		/* - AM33 v1 exception mode */
+#define CPUP_EXM_AM33V2		0x0080		/* - AM33 v2 exception mode */
+
+#define CPUM			__SYSREG(0xc0000040,u16)	/* CPU mode register */
+#define CPUM_SLEEP		0x0004		/* set to enter sleep state */
+#define CPUM_HALT		0x0008		/* set to enter halt state */
+#define CPUM_STOP		0x0010		/* set to enter stop state */
+
+#define CPUREV			__SYSREGC(0xc0000050,u32)	/* CPU revision register */
+#define CPUREV_TYPE		0x0000000f	/* CPU type */
+#define CPUREV_TYPE_S		0
+#define CPUREV_TYPE_AM33V1	0x00000000	/* - AM33 V1 core, AM33/1.00 arch */
+#define CPUREV_TYPE_AM33V2	0x00000001	/* - AM33 V2 core, AM33/2.00 arch */
+#define CPUREV_TYPE_AM34V1	0x00000002	/* - AM34 V1 core, AM33/2.00 arch */
+#define CPUREV_REVISION		0x000000f0	/* CPU revision */
+#define CPUREV_REVISION_S	4
+#define CPUREV_ICWAY		0x00000f00	/* number of instruction cache ways */
+#define CPUREV_ICWAY_S		8
+#define CPUREV_ICSIZE		0x0000f000	/* instruction cache way size */
+#define CPUREV_ICSIZE_S		12
+#define CPUREV_DCWAY		0x000f0000	/* number of data cache ways */
+#define CPUREV_DCWAY_S		16
+#define CPUREV_DCSIZE		0x00f00000	/* data cache way size */
+#define CPUREV_DCSIZE_S		20
+#define CPUREV_FPUTYPE		0x0f000000	/* FPU core type */
+#define CPUREV_FPUTYPE_NONE	0x00000000	/* - no FPU core implemented */
+#define CPUREV_OCDCTG		0xf0000000	/* on-chip debug function category */
+
+#define DCR			__SYSREG(0xc0000030,u16)	/* Debug control register */
+
+/* interrupt/exception control registers */
+#define IVAR0			__SYSREG(0xc0000000,u16)	/* interrupt vector 0 */
+#define IVAR1			__SYSREG(0xc0000004,u16)	/* interrupt vector 1 */
+#define IVAR2			__SYSREG(0xc0000008,u16)	/* interrupt vector 2 */
+#define IVAR3			__SYSREG(0xc000000c,u16)	/* interrupt vector 3 */
+#define IVAR4			__SYSREG(0xc0000010,u16)	/* interrupt vector 4 */
+#define IVAR5			__SYSREG(0xc0000014,u16)	/* interrupt vector 5 */
+#define IVAR6			__SYSREG(0xc0000018,u16)	/* interrupt vector 6 */
+
+#define TBR			__SYSREG(0xc0000024,u32)	/* Trap table base */
+#define TBR_TB			0xff000000	/* table base address bits 31-24 */
+#define TBR_INT_CODE		0x00ffffff	/* interrupt code */
+
+#define DEAR			__SYSREG(0xc0000038,u32)	/* Data access exception address */
+
+#define sISR			__SYSREG(0xc0000044,u32)	/* Supervisor interrupt status */
+#define	sISR_IRQICE		0x00000001	/* ICE interrupt */
+#define	sISR_ISTEP		0x00000002	/* single step interrupt */
+#define	sISR_MISSA		0x00000004	/* memory access address misalignment fault */
+#define	sISR_UNIMP		0x00000008	/* unimplemented instruction execution fault */
+#define	sISR_PIEXE		0x00000010	/* program interrupt */
+#define	sISR_MEMERR		0x00000020	/* illegal memory access fault */
+#define	sISR_IBREAK		0x00000040	/* instraction break interrupt */
+#define	sISR_DBSRL		0x00000080	/* debug serial interrupt */
+#define	sISR_PERIDB		0x00000100	/* peripheral debug interrupt */
+#define	sISR_EXUNIMP		0x00000200	/* unimplemented ex-instruction execution fault */
+#define	sISR_OBREAK		0x00000400	/* operand break interrupt */
+#define	sISR_PRIV		0x00000800	/* privileged instruction execution fault */
+#define	sISR_BUSERR		0x00001000	/* bus error fault */
+#define	sISR_DBLFT		0x00002000	/* double fault */
+#define	sISR_DBG		0x00008000	/* debug reserved interrupt */
+#define sISR_ITMISS		0x00010000	/* instruction TLB miss */
+#define sISR_DTMISS		0x00020000	/* data TLB miss */
+#define sISR_ITEX		0x00040000	/* instruction TLB access exception */
+#define sISR_DTEX		0x00080000	/* data TLB access exception */
+#define sISR_ILGIA		0x00100000	/* illegal instruction access exception */
+#define sISR_ILGDA		0x00200000	/* illegal data access exception */
+#define sISR_IOIA		0x00400000	/* internal I/O space instruction access excep */
+#define sISR_PRIVA		0x00800000	/* privileged space instruction access excep */
+#define sISR_PRIDA		0x01000000	/* privileged space data access excep */
+#define sISR_DISA		0x02000000	/* data space instruction access excep */
+#define sISR_SYSC		0x04000000	/* system call instruction excep */
+#define sISR_FPUD		0x08000000	/* FPU disabled excep */
+#define sISR_FPUUI		0x10000000	/* FPU unimplemented instruction excep */
+#define sISR_FPUOP		0x20000000	/* FPU operation excep */
+#define sISR_NE			0x80000000	/* multiple synchronous exceptions excep */
+
+/* cache control registers */
+#define CHCTR			__SYSREG(0xc0000070,u16)	/* cache control */
+#define CHCTR_ICEN		0x0001		/* instruction cache enable */
+#define CHCTR_DCEN		0x0002		/* data cache enable */
+#define CHCTR_ICBUSY		0x0004		/* instruction cache busy */
+#define CHCTR_DCBUSY		0x0008		/* data cache busy */
+#define CHCTR_ICINV		0x0010		/* instruction cache invalidate */
+#define CHCTR_DCINV		0x0020		/* data cache invalidate */
+#define CHCTR_DCWTMD		0x0040		/* data cache writing mode */
+#define CHCTR_DCWTMD_WRBACK	0x0000		/* - write back mode */
+#define CHCTR_DCWTMD_WRTHROUGH	0x0040		/* - write through mode */
+#define CHCTR_DCALMD		0x0080		/* data cache allocation mode */
+#define CHCTR_ICWMD		0x0f00		/* instruction cache way mode */
+#define CHCTR_DCWMD		0xf000		/* data cache way mode */
+
+/* MMU control registers */
+#define MMUCTR			__SYSREG(0xc0000090,u32)	/* MMU control register */
+#define MMUCTR_IRP		0x0000003f	/* instruction TLB replace pointer */
+#define MMUCTR_ITE		0x00000040	/* instruction TLB enable */
+#define MMUCTR_IIV		0x00000080	/* instruction TLB invalidate */
+#define MMUCTR_ITL		0x00000700	/* instruction TLB lock pointer */
+#define MMUCTR_ITL_NOLOCK	0x00000000	/* - no lock */
+#define MMUCTR_ITL_LOCK0	0x00000100	/* - entry 0 locked */
+#define MMUCTR_ITL_LOCK0_1	0x00000200	/* - entry 0-1 locked */
+#define MMUCTR_ITL_LOCK0_3	0x00000300	/* - entry 0-3 locked */
+#define MMUCTR_ITL_LOCK0_7	0x00000400	/* - entry 0-7 locked */
+#define MMUCTR_ITL_LOCK0_15	0x00000500	/* - entry 0-15 locked */
+#define MMUCTR_CE		0x00008000	/* cacheable bit enable */
+#define MMUCTR_DRP		0x003f0000	/* data TLB replace pointer */
+#define MMUCTR_DTE		0x00400000	/* data TLB enable */
+#define MMUCTR_DIV		0x00800000	/* data TLB invalidate */
+#define MMUCTR_DTL		0x07000000	/* data TLB lock pointer */
+#define MMUCTR_DTL_NOLOCK	0x00000000	/* - no lock */
+#define MMUCTR_DTL_LOCK0	0x01000000	/* - entry 0 locked */
+#define MMUCTR_DTL_LOCK0_1	0x02000000	/* - entry 0-1 locked */
+#define MMUCTR_DTL_LOCK0_3	0x03000000	/* - entry 0-3 locked */
+#define MMUCTR_DTL_LOCK0_7	0x04000000	/* - entry 0-7 locked */
+#define MMUCTR_DTL_LOCK0_15	0x05000000	/* - entry 0-15 locked */
+
+#define PIDR			__SYSREG(0xc0000094,u16)	/* PID register */
+#define PIDR_PID		0x00ff		/* process identifier */
+
+#define PTBR			__SYSREG(0xc0000098, unsigned long) /* Page table base register */
+
+#define IPTEL			__SYSREG(0xc00000a0,u32)	/* instruction TLB entry */
+#define DPTEL			__SYSREG(0xc00000b0,u32)	/* data TLB entry */
+#define xPTEL_V			0x00000001	/* TLB entry valid */
+#define xPTEL_UNUSED1		0x00000002	/* unused bit */
+#define xPTEL_UNUSED2		0x00000004	/* unused bit */
+#define xPTEL_C			0x00000008	/* cached if set */
+#define xPTEL_PV		0x00000010	/* page valid */
+#define xPTEL_D			0x00000020	/* dirty */
+#define xPTEL_PR		0x000001c0	/* page protection */
+#define xPTEL_PR_ROK		0x00000000	/* - R/O kernel */
+#define xPTEL_PR_RWK		0x00000100	/* - R/W kernel */
+#define xPTEL_PR_ROK_ROU	0x00000080	/* - R/O kernel and R/O user */
+#define xPTEL_PR_RWK_ROU	0x00000180	/* - R/W kernel and R/O user */
+#define xPTEL_PR_RWK_RWU	0x000001c0	/* - R/W kernel and R/W user */
+#define xPTEL_G			0x00000200	/* global (use PID if 0) */
+#define xPTEL_PS		0x00000c00	/* page size */
+#define xPTEL_PS_4Kb		0x00000000	/* - 4Kb page */
+#define xPTEL_PS_128Kb		0x00000400	/* - 128Kb page */
+#define xPTEL_PS_1Kb		0x00000800	/* - 1Kb page */
+#define xPTEL_PS_4Mb		0x00000c00	/* - 4Mb page */
+#define xPTEL_PPN		0xfffff006	/* physical page number */
+
+#define xPTEL_V_BIT		0	/* bit numbers corresponding to above masks */
+#define xPTEL_UNUSED1_BIT	1
+#define xPTEL_UNUSED2_BIT	2
+#define xPTEL_C_BIT		3
+#define xPTEL_PV_BIT		4
+#define xPTEL_D_BIT		5
+#define xPTEL_G_BIT		9
+
+#define IPTEU			__SYSREG(0xc00000a4,u32)	/* instruction TLB virtual addr */
+#define DPTEU			__SYSREG(0xc00000b4,u32)	/* data TLB virtual addr */
+#define xPTEU_VPN		0xfffffc00	/* virtual page number */
+#define xPTEU_PID		0x000000ff	/* process identifier to which applicable */
+
+#define IPTEL2			__SYSREG(0xc00000a8,u32)	/* instruction TLB entry */
+#define DPTEL2			__SYSREG(0xc00000b8,u32)	/* data TLB entry */
+#define xPTEL2_V		0x00000001	/* TLB entry valid */
+#define xPTEL2_C		0x00000002	/* cacheable */
+#define xPTEL2_PV		0x00000004	/* page valid */
+#define xPTEL2_D		0x00000008	/* dirty */
+#define xPTEL2_PR		0x00000070	/* page protection */
+#define xPTEL2_PR_ROK		0x00000000	/* - R/O kernel */
+#define xPTEL2_PR_RWK		0x00000040	/* - R/W kernel */
+#define xPTEL2_PR_ROK_ROU	0x00000020	/* - R/O kernel and R/O user */
+#define xPTEL2_PR_RWK_ROU	0x00000060	/* - R/W kernel and R/O user */
+#define xPTEL2_PR_RWK_RWU	0x00000070	/* - R/W kernel and R/W user */
+#define xPTEL2_G		0x00000080	/* global (use PID if 0) */
+#define xPTEL2_PS		0x00000300	/* page size */
+#define xPTEL2_PS_4Kb		0x00000000	/* - 4Kb page */
+#define xPTEL2_PS_128Kb		0x00000100	/* - 128Kb page */
+#define xPTEL2_PS_1Kb		0x00000200	/* - 1Kb page */
+#define xPTEL2_PS_4Mb		0x00000300	/* - 4Mb page */
+#define xPTEL2_PPN		0xfffffc00	/* physical page number */
+
+#define MMUFCR			__SYSREGC(0xc000009c,u32)	/* MMU exception cause */
+#define MMUFCR_IFC		__SYSREGC(0xc000009c,u16)	/* MMU instruction excep cause */
+#define MMUFCR_DFC		__SYSREGC(0xc000009e,u16)	/* MMU data exception cause */
+#define MMUFCR_xFC_TLBMISS	0x0001		/* TLB miss flag */
+#define MMUFCR_xFC_INITWR	0x0002		/* initial write excep flag */
+#define MMUFCR_xFC_PGINVAL	0x0004		/* page invalid excep flag */
+#define MMUFCR_xFC_PROTVIOL	0x0008		/* protection violation excep flag */
+#define MMUFCR_xFC_ACCESS	0x0010		/* access level flag */
+#define MMUFCR_xFC_ACCESS_USR	0x0000		/* - user mode */
+#define MMUFCR_xFC_ACCESS_SR	0x0010		/* - supervisor mode */
+#define MMUFCR_xFC_TYPE		0x0020		/* access type flag */
+#define MMUFCR_xFC_TYPE_READ	0x0000		/* - read */
+#define MMUFCR_xFC_TYPE_WRITE	0x0020		/* - write */
+#define MMUFCR_xFC_PR		0x01c0		/* page protection flag */
+#define MMUFCR_xFC_PR_ROK	0x0000		/* - R/O kernel */
+#define MMUFCR_xFC_PR_RWK	0x0100		/* - R/W kernel */
+#define MMUFCR_xFC_PR_ROK_ROU	0x0080		/* - R/O kernel and R/O user */
+#define MMUFCR_xFC_PR_RWK_ROU	0x0180		/* - R/W kernel and R/O user */
+#define MMUFCR_xFC_PR_RWK_RWU	0x01c0		/* - R/W kernel and R/W user */
+#define MMUFCR_xFC_ILLADDR	0x0200		/* illegal address excep flag */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_CPU_REGS_H */
diff -puN /dev/null include/asm-mn10300/cputime.h
--- /dev/null
+++ a/include/asm-mn10300/cputime.h
@@ -0,0 +1 @@
+#include <asm-generic/cputime.h>
diff -puN /dev/null include/asm-mn10300/current.h
--- /dev/null
+++ a/include/asm-mn10300/current.h
@@ -0,0 +1,37 @@
+/* MN10300 Current task structure accessor
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_CURRENT_H
+#define _ASM_CURRENT_H
+
+#include <linux/thread_info.h>
+
+/*
+ * dedicate E2 to keeping the current task pointer
+ */
+#ifdef CONFIG_MN10300_CURRENT_IN_E2
+
+register struct task_struct *const current asm("e2") __attribute__((used));
+
+#define get_current() current
+
+extern struct task_struct *__current;
+
+#else
+static inline __attribute__((const))
+struct task_struct *get_current(void)
+{
+	return current_thread_info()->task;
+}
+ 
+#define current get_current()
+#endif
+
+#endif /* _ASM_CURRENT_H */
diff -puN /dev/null include/asm-mn10300/delay.h
--- /dev/null
+++ a/include/asm-mn10300/delay.h
@@ -0,0 +1,19 @@
+/* MN10300 Uninterruptible delay routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_DELAY_H
+#define _ASM_DELAY_H
+ 
+extern void __udelay(unsigned long usecs);
+extern void __delay(unsigned long loops);
+
+#define udelay(n) __udelay(n)
+
+#endif /* _ASM_DELAY_H */
diff -puN /dev/null include/asm-mn10300/device.h
--- /dev/null
+++ a/include/asm-mn10300/device.h
@@ -0,0 +1 @@
+#include <asm-generic/device.h>
diff -puN /dev/null include/asm-mn10300/div64.h
--- /dev/null
+++ a/include/asm-mn10300/div64.h
@@ -0,0 +1,98 @@
+/* MN10300 64-bit division
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_DIV64
+#define _ASM_DIV64
+
+#include <linux/types.h>
+
+extern void ____unhandled_size_in_do_div___(void);
+
+/*
+ * divide n by base, leaving the result in n and returning the remainder
+ * - we can do this quite efficiently on the MN10300 by cascading the divides
+ *   through the MDR register
+ */
+#define do_div(n, base)							\
+({									\
+	unsigned __rem = 0;						\
+	if (sizeof(n) <= 4) {						\
+		asm("mov	%1,mdr	\n"				\
+		    "divu	%2,%0	\n"				\
+		    "mov	mdr,%1	\n"				\
+		    : "+r"(n), "=d"(__rem)				\
+		    : "r"(base), "1"(__rem)				\
+		    : "cc"						\
+		    );							\
+	} else if (sizeof(n) <= 8) {					\
+		union {							\
+			unsigned long long l;				\
+			u32 w[2];					\
+		} __quot;						\
+		__quot.l = n;						\
+		asm("mov	%0,mdr	\n"	/* MDR = 0 */		\
+		    "divu	%3,%1	\n"				\
+		    /* __quot.MSL = __div.MSL / base, MDR = MDR:__div.MSL % base */ \
+		    "divu	%3,%2	\n"				\
+		    /* __quot.LSL = MDR:__div.LSL / base, MDR = MDR:__div.LSL % base */	\
+		    "mov	mdr,%0	\n"				\
+		    : "=d"(__rem), "=r"(__quot.w[1]), "=r"(__quot.w[0])	\
+		    : "r"(base), "0"(__rem), "1"(__quot.w[1]), "2"(__quot.w[0])	\
+		    : "cc"						\
+		    );							\
+		n = __quot.l;						\
+	} else {							\
+		____unhandled_size_in_do_div___();			\
+	}								\
+	__rem;								\
+})
+
+/*
+ * do an unsigned 32-bit multiply and divide with intermediate 64-bit product
+ * so as not to lose accuracy
+ * - we use the MDR register to hold the MSW of the product
+ */
+static inline __attribute__((const))
+unsigned __muldiv64u(unsigned val, unsigned mult, unsigned div)
+{
+	unsigned result;
+
+	asm("mulu	%2,%0	\n"	/* MDR:val = val*mult */
+	    "divu	%3,%0	\n"	/* val = MDR:val/div; MDR = MDR:val%div */
+	    : "=r"(result)
+	    : "0"(val), "ir"(mult), "r"(div)
+	    );
+
+	return result;
+}
+
+/*
+ * do a signed 32-bit multiply and divide with intermediate 64-bit product so
+ * as not to lose accuracy
+ * - we use the MDR register to hold the MSW of the product
+ */
+static inline __attribute__((const))
+signed __muldiv64s(signed val, signed mult, signed div)
+{
+	signed result;
+
+	asm("mul	%2,%0	\n"	/* MDR:val = val*mult */
+	    "div	%3,%0	\n"	/* val = MDR:val/div; MDR = MDR:val%div */
+	    : "=r"(result)
+	    : "0"(val), "ir"(mult), "r"(div)
+	    );
+
+	return result;
+}
+
+extern __attribute__((const))
+uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+
+#endif /* _ASM_DIV64 */
diff -puN /dev/null include/asm-mn10300/dmactl-regs.h
--- /dev/null
+++ a/include/asm-mn10300/dmactl-regs.h
@@ -0,0 +1,102 @@
+/* MN10300 on-board DMA controller registers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_DMACTL_REGS_H
+#define _ASM_DMACTL_REGS_H
+
+#include <asm/cpu-regs.h>
+
+#ifdef __KERNEL__
+
+/* DMA registers */
+#define	DMxCTR(N)		__SYSREG(0xd2000000+(N*0x100),u32)	/* control reg */
+#define	DMxCTR_BG		0x0000001f	/* transfer request source */
+#define	DMxCTR_BG_SOFT		0x00000000	/* - software source */
+#define	DMxCTR_BG_SC0TX		0x00000002	/* - serial port 0 transmission */
+#define	DMxCTR_BG_SC0RX		0x00000003	/* - serial port 0 reception */
+#define	DMxCTR_BG_SC1TX		0x00000004	/* - serial port 1 transmission */
+#define	DMxCTR_BG_SC1RX		0x00000005	/* - serial port 1 reception */
+#define	DMxCTR_BG_SC2TX		0x00000006	/* - serial port 2 transmission */
+#define	DMxCTR_BG_SC2RX		0x00000007	/* - serial port 2 reception */
+#define	DMxCTR_BG_TM0UFLOW	0x00000008	/* - timer 0 underflow */
+#define	DMxCTR_BG_TM1UFLOW	0x00000009	/* - timer 1 underflow */
+#define	DMxCTR_BG_TM2UFLOW	0x0000000a	/* - timer 2 underflow */
+#define	DMxCTR_BG_TM3UFLOW	0x0000000b	/* - timer 3 underflow */
+#define	DMxCTR_BG_TM6ACMPCAP	0x0000000c	/* - timer 6A compare/capture */
+#define	DMxCTR_BG_AFE		0x0000000d	/* - analogue front-end interrupt source */
+#define	DMxCTR_BG_ADC		0x0000000e	/* - A/D conversion end interrupt source */
+#define	DMxCTR_BG_IRDA		0x0000000f	/* - IrDA interrupt source */
+#define	DMxCTR_BG_RTC		0x00000010	/* - RTC interrupt source */
+#define	DMxCTR_BG_XIRQ0		0x00000011	/* - XIRQ0 pin interrupt source */
+#define	DMxCTR_BG_XIRQ1		0x00000012	/* - XIRQ1 pin interrupt source */
+#define	DMxCTR_BG_XDMR0		0x00000013	/* - external request 0 source (XDMR0 pin) */
+#define	DMxCTR_BG_XDMR1		0x00000014	/* - external request 1 source (XDMR1 pin) */
+#define	DMxCTR_SAM		0x000000e0	/* DMA transfer src addr mode */
+#define	DMxCTR_SAM_INCR		0x00000000	/* - increment */
+#define	DMxCTR_SAM_DECR		0x00000020	/* - decrement */
+#define	DMxCTR_SAM_FIXED	0x00000040	/* - fixed */
+#define	DMxCTR_DAM		0x00000000	/* DMA transfer dest addr mode */
+#define	DMxCTR_DAM_INCR		0x00000000	/* - increment */
+#define	DMxCTR_DAM_DECR		0x00000100	/* - decrement */
+#define	DMxCTR_DAM_FIXED	0x00000200	/* - fixed */
+#define	DMxCTR_TM		0x00001800	/* DMA transfer mode */
+#define	DMxCTR_TM_BATCH		0x00000000	/* - batch transfer */
+#define	DMxCTR_TM_INTERM	0x00001000	/* - intermittent transfer */
+#define	DMxCTR_UT		0x00006000	/* DMA transfer unit */
+#define	DMxCTR_UT_1		0x00000000	/* - 1 byte */
+#define	DMxCTR_UT_2		0x00002000	/* - 2 byte */
+#define	DMxCTR_UT_4		0x00004000	/* - 4 byte */
+#define	DMxCTR_UT_16		0x00006000	/* - 16 byte */
+#define	DMxCTR_TEN		0x00010000	/* DMA channel transfer enable */
+#define	DMxCTR_RQM		0x00060000	/* external request input source mode */
+#define	DMxCTR_RQM_FALLEDGE	0x00000000	/* - falling edge */
+#define	DMxCTR_RQM_RISEEDGE	0x00020000	/* - rising edge */
+#define	DMxCTR_RQM_LOLEVEL	0x00040000	/* - low level */
+#define	DMxCTR_RQM_HILEVEL	0x00060000	/* - high level */
+#define	DMxCTR_RQF		0x01000000	/* DMA transfer request flag */
+#define	DMxCTR_XEND		0x80000000	/* DMA transfer end flag */
+
+#define	DMxSRC(N)		__SYSREG(0xd2000004+(N*0x100),u32)	/* control reg */
+
+#define	DMxDST(N)		__SYSREG(0xd2000008+(N*0x100),u32)	/* source addr reg */
+
+#define	DMxSIZ(N)		__SYSREG(0xd200000c+(N*0x100),u32)	/* dest addr reg */
+#define DMxSIZ_CT		0x000fffff	/* number of bytes to transfer */
+
+#define	DMxCYC(N)		__SYSREG(0xd2000010+(N*0x100),u32)	/* intermittent size reg */
+#define DMxCYC_CYC		0x000000ff	/* number of interrmittent transfers -1 */
+
+#define DM0IRQ			16		/* DMA channel 0 complete IRQ */
+#define DM1IRQ			17		/* DMA channel 1 complete IRQ */
+#define DM2IRQ			18		/* DMA channel 2 complete IRQ */
+#define DM3IRQ			19		/* DMA channel 3 complete IRQ */
+
+#define	DM0ICR			GxICR(DM0IRQ)	/* DMA channel 0 complete intr ctrl reg */
+#define	DM1ICR			GxICR(DM0IR1)	/* DMA channel 1 complete intr ctrl reg */
+#define	DM2ICR			GxICR(DM0IR2)	/* DMA channel 2 complete intr ctrl reg */
+#define	DM3ICR			GxICR(DM0IR3)	/* DMA channel 3 complete intr ctrl reg */
+
+#ifndef __ASSEMBLY__
+
+struct mn10300_dmactl_regs {
+	u32		ctr;
+	const void	*src;
+	void		*dst;
+	u32		siz;
+	u32		cyc;
+} __attribute__((aligned(0x100)));
+
+extern volatile struct mn10300_dmactl_regs mn10300_dmactl_regs[4];
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_DMACTL_REGS_H */
diff -puN /dev/null include/asm-mn10300/dma.h
--- /dev/null
+++ a/include/asm-mn10300/dma.h
@@ -0,0 +1,118 @@
+/* MN10300 ISA DMA handlers and definitions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_DMA_H
+#define _ASM_DMA_H
+
+#include <asm/system.h>
+#include <linux/spinlock.h>
+#include <asm/io.h>
+#include <linux/delay.h>
+
+#undef MAX_DMA_CHANNELS		/* switch off linux/kernel/dma.c */
+#define MAX_DMA_ADDRESS		0xbfffffff
+
+extern spinlock_t dma_spin_lock;
+
+static inline unsigned long claim_dma_lock(void)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&dma_spin_lock, flags);
+	return flags;
+}
+
+static inline void release_dma_lock(unsigned long flags)
+{
+	spin_unlock_irqrestore(&dma_spin_lock, flags);
+}
+
+/* enable/disable a specific DMA channel */
+static inline void enable_dma(unsigned int dmanr)
+{
+}
+
+static inline void disable_dma(unsigned int dmanr)
+{
+}
+
+/* Clear the 'DMA Pointer Flip Flop'.
+ * Write 0 for LSB/MSB, 1 for MSB/LSB access.
+ * Use this once to initialize the FF to a known state.
+ * After that, keep track of it. :-)
+ * --- In order to do that, the DMA routines below should ---
+ * --- only be used while holding the DMA lock ! ---
+ */
+static inline void clear_dma_ff(unsigned int dmanr)
+{
+}
+
+/* set mode (above) for a specific DMA channel */
+static inline void set_dma_mode(unsigned int dmanr, char mode)
+{
+}
+
+/* Set only the page register bits of the transfer address.
+ * This is used for successive transfers when we know the contents of
+ * the lower 16 bits of the DMA current address register, but a 64k boundary
+ * may have been crossed.
+ */
+static inline void set_dma_page(unsigned int dmanr, char pagenr)
+{
+}
+
+
+/* Set transfer address & page bits for specific DMA channel.
+ * Assumes dma flipflop is clear.
+ */
+static inline void set_dma_addr(unsigned int dmanr, unsigned int a)
+{
+}
+
+
+/* Set transfer size (max 64k for DMA1..3, 128k for DMA5..7) for
+ * a specific DMA channel.
+ * You must ensure the parameters are valid.
+ * NOTE: from a manual: "the number of transfers is one more
+ * than the initial word count"! This is taken into account.
+ * Assumes dma flip-flop is clear.
+ * NOTE 2: "count" represents _bytes_ and must be even for channels 5-7.
+ */
+static inline void set_dma_count(unsigned int dmanr, unsigned int count)
+{
+}
+
+
+/* Get DMA residue count. After a DMA transfer, this
+ * should return zero. Reading this while a DMA transfer is
+ * still in progress will return unpredictable results.
+ * If called before the channel has been used, it may return 1.
+ * Otherwise, it returns the number of _bytes_ left to transfer.
+ *
+ * Assumes DMA flip-flop is clear.
+ */
+static inline int get_dma_residue(unsigned int dmanr)
+{
+	return 0;
+}
+
+
+/* These are in kernel/dma.c: */
+extern int request_dma(unsigned int dmanr, const char *device_id);
+extern void free_dma(unsigned int dmanr);
+
+/* From PCI */
+
+#ifdef CONFIG_PCI
+extern int isa_dma_bridge_buggy;
+#else
+#define isa_dma_bridge_buggy 	(0)
+#endif
+
+#endif /* _ASM_DMA_H */
diff -puN /dev/null include/asm-mn10300/dma-mapping.h
--- /dev/null
+++ a/include/asm-mn10300/dma-mapping.h
@@ -0,0 +1,234 @@
+/* DMA mapping routines for the MN10300 arch
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_DMA_MAPPING_H
+#define _ASM_DMA_MAPPING_H
+
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+
+#include <asm/cache.h>
+#include <asm/io.h>
+
+extern void *dma_alloc_coherent(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, int flag);
+
+extern void dma_free_coherent(struct device *dev, size_t size,
+			      void *vaddr, dma_addr_t dma_handle);
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent((d), (s), (h), (f))
+#define dma_free_noncoherent(d, s, v, h)  dma_free_coherent((d), (s), (v), (h))
+
+/*
+ * Map a single buffer of the indicated size for DMA in streaming mode.  The
+ * 32-bit bus address to use is returned.
+ *
+ * Once the device is given the dma address, the device owns this memory until
+ * either pci_unmap_single or pci_dma_sync_single is performed.
+ */
+static inline
+dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
+			  enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+	mn10300_dcache_flush_inv();
+	return virt_to_bus(ptr);
+}
+
+/*
+ * Unmap a single streaming mode DMA translation.  The dma_addr and size must
+ * match what was provided for in a previous pci_map_single call.  All other
+ * usages are undefined.
+ *
+ * After this call, reads by the cpu to the buffer are guarenteed to see
+ * whatever the device wrote there.
+ */
+static inline
+void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		      enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+}
+
+/*
+ * Map a set of buffers described by scatterlist in streaming mode for DMA.
+ * This is the scather-gather version of the above pci_map_single interface.
+ * Here the scatter gather list elements are each tagged with the appropriate
+ * dma address and length.  They are obtained via sg_dma_{address,length}(SG).
+ *
+ * NOTE: An implementation may be able to use a smaller number of DMA
+ *       address/length pairs than there are SG table elements.  (for example
+ *       via virtual mapping capabilities) The routine returns the number of
+ *       addr/length pairs actually used, at most nents.
+ *
+ * Device ownership issues as mentioned above for pci_map_single are the same
+ * here.
+ */
+static inline
+int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
+	       enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i;
+
+	BUG_ON(!valid_dma_direction(direction));
+	WARN_ON(nents == 0 || sglist[0].length == 0);
+
+	for_each_sg(sglist, sg, nents, i) {
+		BUG_ON(!sg_page(sg));
+
+		sg->dma_address = sg_phys(sg);
+	}
+
+	mn10300_dcache_flush_inv();
+	return nents;
+}
+
+/*
+ * Unmap a set of streaming mode DMA translations.
+ * Again, cpu read rules concerning calls here are the same as for
+ * pci_unmap_single() above.
+ */
+static inline
+void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+		  enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+
+/*
+ * pci_{map,unmap}_single_page maps a kernel page to a dma_addr_t. identical
+ * to pci_map_single, but takes a struct page instead of a virtual address
+ */
+static inline
+dma_addr_t dma_map_page(struct device *dev, struct page *page,
+			unsigned long offset, size_t size,
+			enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+	return page_to_bus(page) + offset;
+}
+
+static inline
+void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+		    enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+}
+
+/*
+ * Make physical memory consistent for a single streaming mode DMA translation
+ * after a transfer.
+ *
+ * If you perform a pci_map_single() but wish to interrogate the buffer using
+ * the cpu, yet do not wish to teardown the PCI dma mapping, you must call this
+ * function before doing so.  At the next point you give the PCI dma address
+ * back to the card, the device again owns the buffer.
+ */
+static inline
+void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			     size_t size, enum dma_data_direction direction)
+{
+}
+
+static inline
+void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+				size_t size, enum dma_data_direction direction)
+{
+	mn10300_dcache_flush_inv();
+}
+
+static inline
+void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction direction)
+{
+}
+
+static inline void
+dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
+{
+	mn10300_dcache_flush_inv();
+}
+
+
+/*
+ * Make physical memory consistent for a set of streaming mode DMA translations
+ * after a transfer.
+ *
+ * The same as pci_dma_sync_single but for a scatter-gather list, same rules
+ * and usage.
+ */
+static inline
+void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+			 int nelems, enum dma_data_direction direction)
+{
+}
+
+static inline
+void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+			    int nelems, enum dma_data_direction direction)
+{
+	mn10300_dcache_flush_inv();
+}
+
+static inline
+int dma_mapping_error(dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+/*
+ * Return whether the given PCI device DMA address mask can be supported
+ * properly.  For example, if your device can only drive the low 24-bits during
+ * PCI bus mastering, then you would pass 0x00ffffff as the mask to this
+ * function.
+ */
+static inline
+int dma_supported(struct device *dev, u64 mask)
+{
+        /*
+         * we fall back to GFP_DMA when the mask isn't all 1s, so we can't
+         * guarantee allocations that must be within a tighter range than
+         * GFP_DMA
+         */
+        if (mask < 0x00ffffff)
+                return 0;
+	return 1;
+}
+
+static inline
+int dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+	return 0;
+}
+
+static inline
+int dma_get_cache_alignment(void)
+{
+	return 1 << L1_CACHE_SHIFT;
+}
+
+#define dma_is_consistent(d)	(1)
+
+static inline
+void dma_cache_sync(void *vaddr, size_t size,
+		    enum dma_data_direction direction)
+{
+	mn10300_dcache_flush_inv();
+}
+
+#endif
diff -puN /dev/null include/asm-mn10300/elf.h
--- /dev/null
+++ a/include/asm-mn10300/elf.h
@@ -0,0 +1,147 @@
+/* MN10300 ELF constant and register definitions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_ELF_H
+#define _ASM_ELF_H
+
+#include <linux/utsname.h>
+#include <asm/ptrace.h>
+#include <asm/user.h>
+
+/*
+ * AM33 relocations
+ */
+#define R_MN10300_NONE		0	/* No reloc.  */
+#define R_MN10300_32		1	/* Direct 32 bit.  */
+#define R_MN10300_16		2	/* Direct 16 bit.  */
+#define R_MN10300_8		3	/* Direct 8 bit.  */
+#define R_MN10300_PCREL32	4	/* PC-relative 32-bit.  */
+#define R_MN10300_PCREL16	5	/* PC-relative 16-bit signed.  */
+#define R_MN10300_PCREL8	6	/* PC-relative 8-bit signed.  */
+#define R_MN10300_24		9	/* Direct 24 bit.  */
+#define R_MN10300_RELATIVE	23	/* Adjust by program base.  */
+
+/*
+ * ELF register definitions..
+ */
+typedef unsigned long elf_greg_t;
+
+#define ELF_NGREG (sizeof (struct pt_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+#define ELF_NFPREG 32
+typedef float elf_fpreg_t;
+
+typedef struct {
+	elf_fpreg_t	fpregs[ELF_NFPREG];
+	u_int32_t	fpcr;
+} elf_fpregset_t;
+
+extern int dump_fpu(struct pt_regs *, elf_fpregset_t *);
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture
+ */
+#define elf_check_arch(x) \
+	(((x)->e_machine == EM_CYGNUS_MN10300) ||	\
+	 ((x)->e_machine == EM_MN10300))
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS	ELFCLASS32
+#define ELF_DATA	ELFDATA2LSB
+#define ELF_ARCH	EM_MN10300
+
+/*
+ * ELF process initialiser
+ */
+#define ELF_PLAT_INIT(_r, load_addr)					\
+do {									\
+	struct pt_regs *_ur = current->thread.uregs;			\
+	_ur->a3   = 0;	_ur->a2   = 0;	_ur->d3   = 0;	_ur->d2   = 0;	\
+	_ur->mcvf = 0;	_ur->mcrl = 0;	_ur->mcrh = 0;	_ur->mdrq = 0;	\
+	_ur->e1   = 0;	_ur->e0   = 0;	_ur->e7   = 0;	_ur->e6   = 0;	\
+	_ur->e5   = 0;	_ur->e4   = 0;	_ur->e3   = 0;	_ur->e2   = 0;	\
+	_ur->lar  = 0;	_ur->lir  = 0;	_ur->mdr  = 0;			\
+	_ur->a1   = 0;	_ur->a0   = 0;	_ur->d1   = 0;	_ur->d0   = 0;	\
+} while (0)
+
+#define USE_ELF_CORE_DUMP
+#define ELF_EXEC_PAGESIZE	4096
+
+/*
+ * This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+ * use of this is to invoke "./ld.so someprog" to test out a new version of
+ * the loader.  We need to make sure that it is out of the way of the program
+ * that it will "exec", and that there is sufficient room for the brk.
+ * - must clear the VMALLOC area
+ */
+#define ELF_ET_DYN_BASE         0x04000000
+
+/*
+ * regs is struct pt_regs, pr_reg is elf_gregset_t (which is
+ * now struct user_regs, they are different)
+ * - ELF_CORE_COPY_REGS has been guessed, and may be wrong
+ */
+#define ELF_CORE_COPY_REGS(pr_reg, regs)	\
+do {						\
+	pr_reg[0]	= regs->a3;		\
+	pr_reg[1]	= regs->a2;		\
+	pr_reg[2]	= regs->d3;		\
+	pr_reg[3]	= regs->d2;		\
+	pr_reg[4]	= regs->mcvf;		\
+	pr_reg[5]	= regs->mcrl;		\
+	pr_reg[6]	= regs->mcrh;		\
+	pr_reg[7]	= regs->mdrq;		\
+	pr_reg[8]	= regs->e1;		\
+	pr_reg[9]	= regs->e0;		\
+	pr_reg[10]	= regs->e7;		\
+	pr_reg[11]	= regs->e6;		\
+	pr_reg[12]	= regs->e5;		\
+	pr_reg[13]	= regs->e4;		\
+	pr_reg[14]	= regs->e3;		\
+	pr_reg[15]	= regs->e2;		\
+	pr_reg[16]	= regs->sp;		\
+	pr_reg[17]	= regs->lar;		\
+	pr_reg[18]	= regs->lir;		\
+	pr_reg[19]	= regs->mdr;		\
+	pr_reg[20]	= regs->a1;		\
+	pr_reg[21]	= regs->a0;		\
+	pr_reg[22]	= regs->d1;		\
+	pr_reg[23]	= regs->d0;		\
+	pr_reg[24]	= regs->orig_d0;	\
+	pr_reg[25]	= regs->epsw;		\
+	pr_reg[26]	= regs->pc;		\
+} while(0);
+
+/*
+ * This yields a mask that user programs can use to figure out what
+ * instruction set this CPU supports.  This could be done in user space,
+ * but it's not easy, and we've already done it here.
+ */
+#define ELF_HWCAP	(0)
+
+/*
+ * This yields a string that ld.so will use to load implementation
+ * specific libraries for optimization.  This is more specific in
+ * intent than poking at uname or /proc/cpuinfo.
+ *
+ * For the moment, we have only optimizations for the Intel generations,
+ * but that could change...
+ */
+#define ELF_PLATFORM  (NULL)
+
+#ifdef __KERNEL__
+#define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX)
+#endif
+
+#endif /* _ASM_ELF_H */
diff -puN /dev/null include/asm-mn10300/emergency-restart.h
--- /dev/null
+++ a/include/asm-mn10300/emergency-restart.h
@@ -0,0 +1 @@
+#include <asm-generic/emergency-restart.h>
diff -puN /dev/null include/asm-mn10300/errno.h
--- /dev/null
+++ a/include/asm-mn10300/errno.h
@@ -0,0 +1 @@
+#include <asm-generic/errno.h>
diff -puN /dev/null include/asm-mn10300/exceptions.h
--- /dev/null
+++ a/include/asm-mn10300/exceptions.h
@@ -0,0 +1,118 @@
+/* MN10300 Microcontroller core exceptions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_EXCEPTIONS_H
+#define _ASM_EXCEPTIONS_H
+
+#include <linux/linkage.h>
+
+/*
+ * define the breakpoint instruction opcode to use
+ * - note that the JTAG unit steals 0xFF, so we want to avoid that if we can (can use 0xF7)
+ */
+#define GDBSTUB_BKPT		0xFF
+
+#ifndef __ASSEMBLY__
+
+/*
+ * enumeration of exception codes (as extracted from TBR MSW)
+ */
+typedef enum {
+	EXCEP_RESET		= 0x000000,	/* reset */
+
+	/* MMU exceptions */
+	EXCEP_ITLBMISS		= 0x000100,	/* instruction TLB miss */
+	EXCEP_DTLBMISS		= 0x000108,	/* data TLB miss */
+	EXCEP_IAERROR		= 0x000110,	/* instruction address */
+	EXCEP_DAERROR		= 0x000118,	/* data address */
+
+	/* system exceptions */
+	EXCEP_TRAP		= 0x000128,	/* program interrupt (PI instruction) */
+	EXCEP_ISTEP		= 0x000130,	/* single step */
+	EXCEP_IBREAK		= 0x000150,	/* instruction breakpoint */
+	EXCEP_OBREAK		= 0x000158,	/* operand breakpoint */
+	EXCEP_PRIVINS		= 0x000160,	/* privileged instruction execution */
+	EXCEP_UNIMPINS		= 0x000168,	/* unimplemented instruction execution */
+	EXCEP_UNIMPEXINS	= 0x000170,	/* unimplemented extended instruction execution */
+	EXCEP_MEMERR		= 0x000178,	/* illegal memory access */
+	EXCEP_MISALIGN		= 0x000180,	/* misalignment */
+	EXCEP_BUSERROR		= 0x000188,	/* bus error */
+	EXCEP_ILLINSACC		= 0x000190,	/* illegal instruction access */
+	EXCEP_ILLDATACC		= 0x000198,	/* illegal data access */
+	EXCEP_IOINSACC		= 0x0001a0,	/* I/O space instruction access */
+	EXCEP_PRIVINSACC	= 0x0001a8,	/* privileged space instruction access */
+	EXCEP_PRIVDATACC	= 0x0001b0,	/* privileged space data access */
+	EXCEP_DATINSACC		= 0x0001b8,	/* data space instruction access */
+	EXCEP_DOUBLE_FAULT	= 0x000200,	/* double fault */
+
+	/* FPU exceptions */
+	EXCEP_FPU_DISABLED	= 0x0001c0,	/* FPU disabled */
+	EXCEP_FPU_UNIMPINS	= 0x0001c8,	/* FPU unimplemented operation */
+	EXCEP_FPU_OPERATION	= 0x0001d0,	/* FPU operation */
+
+	/* interrupts */
+	EXCEP_WDT		= 0x000240,	/* watchdog timer overflow */
+	EXCEP_NMI		= 0x000248,	/* non-maskable interrupt */
+	EXCEP_IRQ_LEVEL0	= 0x000280,	/* level 0 maskable interrupt */
+	EXCEP_IRQ_LEVEL1	= 0x000288,	/* level 1 maskable interrupt */
+	EXCEP_IRQ_LEVEL2	= 0x000290,	/* level 2 maskable interrupt */
+	EXCEP_IRQ_LEVEL3	= 0x000298,	/* level 3 maskable interrupt */
+	EXCEP_IRQ_LEVEL4	= 0x0002a0,	/* level 4 maskable interrupt */
+	EXCEP_IRQ_LEVEL5	= 0x0002a8,	/* level 5 maskable interrupt */
+	EXCEP_IRQ_LEVEL6	= 0x0002b0,	/* level 6 maskable interrupt */
+
+	/* system calls */
+	EXCEP_SYSCALL0		= 0x000300,	/* system call 0 */
+	EXCEP_SYSCALL1		= 0x000308,	/* system call 1 */
+	EXCEP_SYSCALL2		= 0x000310,	/* system call 2 */
+	EXCEP_SYSCALL3		= 0x000318,	/* system call 3 */
+	EXCEP_SYSCALL4		= 0x000320,	/* system call 4 */
+	EXCEP_SYSCALL5		= 0x000328,	/* system call 5 */
+	EXCEP_SYSCALL6		= 0x000330,	/* system call 6 */
+	EXCEP_SYSCALL7		= 0x000338,	/* system call 7 */
+	EXCEP_SYSCALL8		= 0x000340,	/* system call 8 */
+	EXCEP_SYSCALL9		= 0x000348,	/* system call 9 */
+	EXCEP_SYSCALL10		= 0x000350,	/* system call 10 */
+	EXCEP_SYSCALL11		= 0x000358,	/* system call 11 */
+	EXCEP_SYSCALL12		= 0x000360,	/* system call 12 */
+	EXCEP_SYSCALL13		= 0x000368,	/* system call 13 */
+	EXCEP_SYSCALL14		= 0x000370,	/* system call 14 */
+	EXCEP_SYSCALL15		= 0x000378,	/* system call 15 */
+} exception_code_t;
+
+extern void __set_intr_stub(exception_code_t code, void *handler);
+extern void set_intr_stub(exception_code_t code, void *handler);
+extern void set_jtag_stub(exception_code_t code, void *handler);
+
+struct pt_regs;
+
+extern asmlinkage void __common_exception(void);
+extern asmlinkage void itlb_miss(void);
+extern asmlinkage void dtlb_miss(void);
+extern asmlinkage void itlb_aerror(void);
+extern asmlinkage void dtlb_aerror(void);
+extern asmlinkage void raw_bus_error(void);
+extern asmlinkage void double_fault(void);
+extern asmlinkage int  system_call(struct pt_regs *);
+extern asmlinkage void fpu_exception(struct pt_regs *, exception_code_t);
+extern asmlinkage void nmi(struct pt_regs *, exception_code_t);
+extern asmlinkage void uninitialised_exception(struct pt_regs *, exception_code_t);
+extern asmlinkage void irq_handler(void);
+extern asmlinkage void profile_handler(void);
+extern asmlinkage void nmi_handler(void);
+extern asmlinkage void misalignment(struct pt_regs *regs, exception_code_t code);
+
+extern void die(const char *str, struct pt_regs *regs, exception_code_t code) ATTRIB_NORET;
+
+extern int die_if_no_fixup(const char *str, struct pt_regs *regs, exception_code_t code);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_EXCEPTIONS_H */
diff -puN /dev/null include/asm-mn10300/fb.h
--- /dev/null
+++ a/include/asm-mn10300/fb.h
@@ -0,0 +1,23 @@
+/* MN10300 Frame buffer stuff
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_FB_H
+#define _ASM_FB_H
+
+#include <linux/fb.h>
+
+#define fb_pgprotect(...) do {} while (0)
+
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
+#endif /* _ASM_FB_H */
diff -puN /dev/null include/asm-mn10300/fcntl.h
--- /dev/null
+++ a/include/asm-mn10300/fcntl.h
@@ -0,0 +1 @@
+#include <asm-generic/fcntl.h>
diff -puN /dev/null include/asm-mn10300/fpu.h
--- /dev/null
+++ a/include/asm-mn10300/fpu.h
@@ -0,0 +1,85 @@
+/* MN10300 FPU definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * Derived from include/asm-i386/i387.h: Copyright (C) 1994 Linus Torvalds
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_FPU_H
+#define _ASM_FPU_H
+
+#include <asm/processor.h>
+#include <asm/sigcontext.h>
+#include <asm/user.h>
+
+#ifdef __KERNEL__
+
+/* the task that owns the FPU state */
+extern struct task_struct *volatile fpu_state_owner;
+
+#define set_using_fpu(tsk)				\
+do {							\
+	(tsk)->thread.fpu_flags |= THREAD_USING_FPU;	\
+} while(0)
+
+#define clear_using_fpu(tsk)				\
+do {							\
+	(tsk)->thread.fpu_flags &= ~THREAD_USING_FPU;	\
+} while(0)
+
+#define is_using_fpu(tsk) ((tsk)->thread.fpu_flags & THREAD_USING_FPU)
+
+#define unlazy_fpu(tsk)					\
+do {							\
+	preempt_disable();				\
+	if (fpu_state_owner == (tsk))			\
+		fpu_save(&tsk->thread.fpu_state);	\
+	preempt_enable();				\
+} while(0)
+
+#define exit_fpu()				\
+do {						\
+	struct task_struct *__tsk = current;	\
+	preempt_disable();			\
+	if (fpu_state_owner == __tsk)		\
+		fpu_state_owner = NULL;		\
+	preempt_enable();			\
+} while(0)
+
+#define flush_fpu()					\
+do {							\
+	struct task_struct *__tsk = current;		\
+	preempt_disable();				\
+	if (fpu_state_owner == __tsk) {			\
+		fpu_state_owner = NULL;			\
+		__tsk->thread.uregs->epsw &= ~EPSW_FE;	\
+	}						\
+	preempt_enable();				\
+	clear_using_fpu(__tsk);				\
+} while(0)
+
+extern asmlinkage void fpu_init_state(void);
+extern asmlinkage void fpu_kill_state(struct task_struct *);
+extern asmlinkage void fpu_disabled(struct pt_regs *, exception_code_t);
+extern asmlinkage void fpu_exception(struct pt_regs *, exception_code_t);
+
+#ifdef CONFIG_FPU
+extern asmlinkage void fpu_save(struct fpu_state_struct *);
+extern asmlinkage void fpu_restore(struct fpu_state_struct *);
+#else
+#define fpu_save(a)
+#define fpu_restore(a)
+#endif /* CONFIG_FPU  */
+
+/*
+ * signal frame handlers
+ */
+extern int fpu_setup_sigcontext(struct fpucontext *buf);
+extern int fpu_restore_sigcontext(struct fpucontext *buf);
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_FPU_H */
diff -puN /dev/null include/asm-mn10300/frame.inc
--- /dev/null
+++ a/include/asm-mn10300/frame.inc
@@ -0,0 +1,91 @@
+/* MN10300 Microcontroller core system register definitions -*- asm -*-
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_FRAME_INC
+#define _ASM_FRAME_INC
+
+#ifndef __ASSEMBLY__
+#error not for use in C files
+#endif
+
+#ifndef __ASM_OFFSETS_H__
+#include <asm/asm-offsets.h>
+#endif
+
+#define pi break
+
+#define fp a3
+
+###############################################################################
+#
+# build a stack frame from the registers
+# - the caller has subtracted 4 from SP before coming here
+#
+###############################################################################
+.macro SAVE_ALL
+	add	-4,sp				# next exception frame ptr save area
+	movm	[other],(sp)
+	mov	usp,a1
+	mov	a1,(sp)				# USP in MOVM[other] dummy slot
+	movm	[d2,d3,a2,a3,exreg0,exreg1,exother],(sp)
+	mov	sp,fp				# FRAME pointer in A3
+	add	-12,sp				# allow for calls to be made
+	mov	(__frame),a1
+	mov	a1,(REG_NEXT,fp)
+	mov	fp,(__frame)
+
+	and	~EPSW_FE,epsw			# disable the FPU inside the kernel
+
+	# we may be holding current in E2
+#ifdef CONFIG_MN10300_CURRENT_IN_E2
+	mov	(__current),e2
+#endif
+.endm
+
+###############################################################################
+#
+# restore the registers from a stack frame
+#
+###############################################################################
+.macro RESTORE_ALL
+	# peel back the stack to the calling frame
+	# - this permits execve() to discard extra frames due to kernel syscalls
+	mov	(__frame),fp
+	mov	fp,sp
+	mov	(REG_NEXT,fp),d0                # userspace has regs->next == 0
+	mov	d0,(__frame)
+
+#ifndef CONFIG_MN10300_USING_JTAG
+	mov	(REG_EPSW,fp),d0
+	btst	EPSW_T,d0
+	beq	99f
+
+	or	EPSW_NMID,epsw
+	movhu	(DCR),d1
+	or	0x0001, d1
+	movhu	d1,(DCR)
+
+99:
+#endif
+	movm	(sp),[d2,d3,a2,a3,exreg0,exreg1,exother]
+
+	# must restore usp even if returning to kernel space,
+	# when CONFIG_PREEMPT is enabled.
+	mov	(sp),a1				# USP in MOVM[other] dummy slot
+	mov	a1,usp
+
+	movm	(sp),[other]
+	add	8,sp
+	rti
+
+.endm
+
+
+#endif /* _ASM_FRAME_INC */
diff -puN /dev/null include/asm-mn10300/futex.h
--- /dev/null
+++ a/include/asm-mn10300/futex.h
@@ -0,0 +1 @@
+#include <asm-generic/futex.h>
diff -puN /dev/null include/asm-mn10300/gdb-stub.h
--- /dev/null
+++ a/include/asm-mn10300/gdb-stub.h
@@ -0,0 +1,183 @@
+/* MN10300 Kernel GDB stub definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from asm-mips/gdb-stub.h (c) 1995 Andreas Busse
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_GDB_STUB_H
+#define _ASM_GDB_STUB_H
+
+#include <asm/exceptions.h>
+
+/*
+ * register ID numbers in GDB remote protocol
+ */
+
+#define GDB_REGID_PC		9
+#define GDB_REGID_FP		7
+#define GDB_REGID_SP		8
+
+/*
+ * virtual stack layout for the GDB exception handler
+ */
+#define NUMREGS			64
+
+#define GDB_FR_D0		(0 * 4)
+#define GDB_FR_D1		(1 * 4)
+#define GDB_FR_D2		(2 * 4)
+#define GDB_FR_D3		(3 * 4)
+#define GDB_FR_A0		(4 * 4)
+#define GDB_FR_A1		(5 * 4)
+#define GDB_FR_A2		(6 * 4)
+#define GDB_FR_A3		(7 * 4)
+
+#define GDB_FR_SP		(8 * 4)
+#define GDB_FR_PC		(9 * 4)
+#define GDB_FR_MDR		(10 * 4)
+#define GDB_FR_EPSW		(11 * 4)
+#define GDB_FR_LIR		(12 * 4)
+#define GDB_FR_LAR		(13 * 4)
+#define GDB_FR_MDRQ		(14 * 4)
+
+#define GDB_FR_E0		(15 * 4)
+#define GDB_FR_E1		(16 * 4)
+#define GDB_FR_E2		(17 * 4)
+#define GDB_FR_E3		(18 * 4)
+#define GDB_FR_E4		(19 * 4)
+#define GDB_FR_E5		(20 * 4)
+#define GDB_FR_E6		(21 * 4)
+#define GDB_FR_E7		(22 * 4)
+
+#define GDB_FR_SSP		(23 * 4)
+#define GDB_FR_MSP		(24 * 4)
+#define GDB_FR_USP		(25 * 4)
+#define GDB_FR_MCRH		(26 * 4)
+#define GDB_FR_MCRL		(27 * 4)
+#define GDB_FR_MCVF		(28 * 4)
+
+#define GDB_FR_FPCR		(29 * 4)
+#define GDB_FR_DUMMY0		(30 * 4)
+#define GDB_FR_DUMMY1		(31 * 4)
+
+#define GDB_FR_FS0		(32 * 4)
+
+#define GDB_FR_SIZE		(NUMREGS * 4)
+
+#ifndef __ASSEMBLY__
+
+/*
+ * This is the same as above, but for the high-level
+ * part of the GDB stub.
+ */
+
+struct gdb_regs {
+	/* saved main processor registers */
+	u32	d0, d1, d2, d3, a0, a1, a2, a3;
+	u32	sp, pc, mdr, epsw, lir, lar, mdrq;
+	u32	e0, e1, e2, e3, e4, e5, e6, e7;
+	u32	ssp, msp, usp, mcrh, mcrl, mcvf;
+
+	/* saved floating point registers */
+	u32	fpcr, _dummy0, _dummy1;
+	u32	fs0,  fs1,  fs2,  fs3,  fs4,  fs5,  fs6,  fs7;
+	u32	fs8,  fs9,  fs10, fs11, fs12, fs13, fs14, fs15;
+	u32	fs16, fs17, fs18, fs19, fs20, fs21, fs22, fs23;
+	u32	fs24, fs25, fs26, fs27, fs28, fs29, fs30, fs31;
+};
+
+/*
+ * Prototypes
+ */
+extern void show_registers_only(struct pt_regs *regs);
+
+extern asmlinkage void gdbstub_init(void);
+extern asmlinkage void gdbstub_exit(int status);
+extern asmlinkage void gdbstub_io_init(void);
+extern asmlinkage void gdbstub_io_set_baud(unsigned baud);
+extern asmlinkage int  gdbstub_io_rx_char(unsigned char *_ch, int nonblock);
+extern asmlinkage void gdbstub_io_tx_char(unsigned char ch);
+extern asmlinkage void gdbstub_io_tx_flush(void);
+
+extern asmlinkage void gdbstub_io_rx_handler(void);
+extern asmlinkage void gdbstub_rx_irq(struct pt_regs *, exception_code_t);
+extern asmlinkage int  gdbstub_intercept(struct pt_regs *, exception_code_t);
+extern asmlinkage void gdbstub_exception(struct pt_regs *, exception_code_t);
+extern asmlinkage void __gdbstub_bug_trap(void);
+extern asmlinkage void __gdbstub_pause(void);
+extern asmlinkage void start_kernel(void);
+
+#ifndef CONFIG_MN10300_CACHE_DISABLED
+extern asmlinkage void gdbstub_purge_cache(void);
+#else
+#define gdbstub_purge_cache()	do {} while(0)
+#endif
+
+/* Used to prevent crashes in memory access */
+extern asmlinkage int  gdbstub_read_byte(const u8 *, u8 *);
+extern asmlinkage int  gdbstub_read_word(const u8 *, u8 *);
+extern asmlinkage int  gdbstub_read_dword(const u8 *, u8 *);
+extern asmlinkage int  gdbstub_write_byte(u32, u8 *);
+extern asmlinkage int  gdbstub_write_word(u32, u8 *);
+extern asmlinkage int  gdbstub_write_dword(u32, u8 *);
+
+extern asmlinkage void gdbstub_read_byte_guard(void);
+extern asmlinkage void gdbstub_read_byte_cont(void);
+extern asmlinkage void gdbstub_read_word_guard(void);
+extern asmlinkage void gdbstub_read_word_cont(void);
+extern asmlinkage void gdbstub_read_dword_guard(void);
+extern asmlinkage void gdbstub_read_dword_cont(void);
+extern asmlinkage void gdbstub_write_byte_guard(void);
+extern asmlinkage void gdbstub_write_byte_cont(void);
+extern asmlinkage void gdbstub_write_word_guard(void);
+extern asmlinkage void gdbstub_write_word_cont(void);
+extern asmlinkage void gdbstub_write_dword_guard(void);
+extern asmlinkage void gdbstub_write_dword_cont(void);
+
+extern volatile u8	gdbstub_rx_buffer[PAGE_SIZE];
+extern volatile u32	gdbstub_rx_inp;
+extern volatile u32	gdbstub_rx_outp;
+extern volatile u8	gdbstub_rx_overflow;
+extern volatile u8	gdbstub_busy;
+extern u8		gdbstub_rx_unget;
+
+#ifdef CONFIG_GDBSTUB_DEBUGGING
+extern void gdbstub_printk(const char *fmt, ...)
+	__attribute__((format(printf, 1, 2)));
+#else
+static inline __attribute__((format(printf, 1, 2)))
+void gdbstub_printk(const char *fmt, ...)
+{
+}
+#endif
+
+#ifdef CONFIG_GDBSTUB_DEBUG_ENTRY
+#define gdbstub_entry(FMT,...) gdbstub_printk(FMT, ##__VA_ARGS__)
+#else
+#define gdbstub_entry(FMT,...) ({ 0; })
+#endif
+
+#ifdef CONFIG_GDBSTUB_DEBUG_PROTOCOL
+#define gdbstub_proto(FMT,...) gdbstub_printk(FMT, ##__VA_ARGS__)
+#else
+#define gdbstub_proto(FMT,...) ({ 0; })
+#endif
+
+#ifdef CONFIG_GDBSTUB_DEBUG_IO
+#define gdbstub_io(FMT,...) gdbstub_printk(FMT, ##__VA_ARGS__)
+#else
+#define gdbstub_io(FMT,...) ({ 0; })
+#endif
+
+#ifdef CONFIG_GDBSTUB_DEBUG_BREAKPOINT
+#define gdbstub_bkpt(FMT,...) gdbstub_printk(FMT, ##__VA_ARGS__)
+#else
+#define gdbstub_bkpt(FMT,...) ({ 0; })
+#endif
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_GDB_STUB_H */
diff -puN /dev/null include/asm-mn10300/.gitignore
--- /dev/null
+++ a/include/asm-mn10300/.gitignore
@@ -0,0 +1,2 @@
+proc
+unit
diff -puN /dev/null include/asm-mn10300/hardirq.h
--- /dev/null
+++ a/include/asm-mn10300/hardirq.h
@@ -0,0 +1,47 @@
+/* MN10300 Hardware IRQ statistics and management
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_HARDIRQ_H
+#define _ASM_HARDIRQ_H
+
+#include <linux/threads.h>
+#include <linux/irq.h>
+#include <asm/exceptions.h>
+
+/* assembly code in softirq.h is sensitive to the offsets of these fields */
+typedef struct {
+	unsigned int	__softirq_pending;
+	unsigned long	idle_timestamp;
+	unsigned int	__nmi_count;	/* arch dependent */
+	unsigned int	__irq_count;	/* arch dependent */
+} ____cacheline_aligned irq_cpustat_t;
+
+#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+
+extern void ack_bad_irq(int irq);
+
+/*
+ * manipulate stubs in the MN10300 CPU Trap/Interrupt Vector table
+ * - these should jump to __common_exception in entry.S unless there's a good
+ *   reason to do otherwise (see trap_preinit() in traps.c)
+ */
+typedef void (*intr_stub_fnx)(struct pt_regs *regs, exception_code_t intcode);
+
+/*
+ * manipulate pointers in the Exception table (see entry.S)
+ * - these are indexed by decoding the lower 24 bits of the TBR register
+ * - note that the MN103E010 doesn't always trap through the correct vector,
+ *   but does always set the TBR correctly
+ */
+extern asmlinkage void set_excp_vector(exception_code_t code,
+				       intr_stub_fnx handler);
+
+#endif /* _ASM_HARDIRQ_H */
diff -puN /dev/null include/asm-mn10300/highmem.h
--- /dev/null
+++ a/include/asm-mn10300/highmem.h
@@ -0,0 +1,114 @@
+/* MN10300 Virtual kernel memory mappings for high memory
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from include/asm-i386/highmem.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_HIGHMEM_H
+#define _ASM_HIGHMEM_H
+
+#ifdef __KERNEL__
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/kmap_types.h>
+#include <asm/pgtable.h>
+
+/* undef for production */
+#undef HIGHMEM_DEBUG
+
+/* declarations for highmem.c */
+extern unsigned long highstart_pfn, highend_pfn;
+
+extern pte_t *kmap_pte;
+extern pgprot_t kmap_prot;
+extern pte_t *pkmap_page_table;
+
+extern void __init kmap_init(void);
+
+/*
+ * Right now we initialize only a single pte table. It can be extended
+ * easily, subsequent pte tables have to be allocated in one physical
+ * chunk of RAM.
+ */
+#define PKMAP_BASE	0xfe000000UL
+#define LAST_PKMAP	1024
+#define LAST_PKMAP_MASK (LAST_PKMAP - 1)
+#define PKMAP_NR(virt)  ((virt - PKMAP_BASE) >> PAGE_SHIFT)
+#define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
+
+extern unsigned long __fastcall kmap_high(struct page *page);
+extern void __fastcall kunmap_high(struct page *page);
+
+static inline unsigned long kmap(struct page *page)
+{
+	if (in_interrupt())
+		BUG();
+	if (page < highmem_start_page)
+		return page_address(page);
+	return kmap_high(page);
+}
+
+static inline void kunmap(struct page *page)
+{
+	if (in_interrupt())
+		BUG();
+	if (page < highmem_start_page)
+		return;
+	kunmap_high(page);
+}
+
+/*
+ * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
+ * gives a more generic (and caching) interface. But kmap_atomic can
+ * be used in IRQ contexts, so in some (very limited) cases we need
+ * it.
+ */
+static inline unsigned long kmap_atomic(struct page *page, enum km_type type)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+
+	if (page < highmem_start_page)
+		return page_address(page);
+
+	idx = type + KM_TYPE_NR * smp_processor_id();
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+#if HIGHMEM_DEBUG
+	if (!pte_none(*(kmap_pte - idx)))
+		BUG();
+#endif
+	set_pte(kmap_pte - idx, mk_pte(page, kmap_prot));
+	__flush_tlb_one(vaddr);
+
+	return vaddr;
+}
+
+static inline void kunmap_atomic(unsigned long vaddr, enum km_type type)
+{
+#if HIGHMEM_DEBUG
+	enum fixed_addresses idx = type + KM_TYPE_NR * smp_processor_id();
+
+	if (vaddr < FIXADDR_START) // FIXME
+		return;
+
+	if (vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx))
+		BUG();
+
+	/*
+	 * force other mappings to Oops if they'll try to access
+	 * this pte without first remap it
+	 */
+	pte_clear(kmap_pte - idx);
+	__flush_tlb_one(vaddr);
+#endif
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_HIGHMEM_H */
diff -puN /dev/null include/asm-mn10300/hw_irq.h
--- /dev/null
+++ a/include/asm-mn10300/hw_irq.h
@@ -0,0 +1,14 @@
+/* MN10300 Hardware interrupt definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_HW_IRQ_H
+#define _ASM_HW_IRQ_H
+
+#endif /* _ASM_HW_IRQ_H */
diff -puN /dev/null include/asm-mn10300/ide.h
--- /dev/null
+++ a/include/asm-mn10300/ide.h
@@ -0,0 +1,39 @@
+/* MN10300 Arch-specific IDE code
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from include/asm-i386/ide.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_IDE_H
+#define _ASM_IDE_H
+
+#ifdef __KERNEL__
+
+#include <asm/intctl-regs.h>
+
+#undef SUPPORT_SLOW_DATA_PORTS
+#define SUPPORT_SLOW_DATA_PORTS 0
+
+#undef SUPPORT_VLB_SYNC
+#define SUPPORT_VLB_SYNC 0
+
+#ifndef MAX_HWIFS
+#define MAX_HWIFS 8
+#endif
+
+/*
+ * some bits needed for parts of the IDE subsystem to compile
+ */
+#define __ide_mm_insw(port, addr, n)	insw((unsigned long) (port), (addr), (n))
+#define __ide_mm_insl(port, addr, n)	insl((unsigned long) (port), (addr), (n))
+#define __ide_mm_outsw(port, addr, n)	outsw((unsigned long) (port), (addr), (n))
+#define __ide_mm_outsl(port, addr, n)	outsl((unsigned long) (port), (addr), (n))
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_IDE_H */
diff -puN /dev/null include/asm-mn10300/intctl-regs.h
--- /dev/null
+++ a/include/asm-mn10300/intctl-regs.h
@@ -0,0 +1,73 @@
+/* MN10300 On-board interrupt controller registers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_INTCTL_REGS_H
+#define _ASM_INTCTL_REGS_H
+
+#include <asm/cpu-regs.h>
+
+#ifdef __KERNEL__
+
+/* interrupt controller registers */
+#define GxICR(X)		__SYSREG(0xd4000000+(X)*4,u16)	/* group interrupt ctrl regs */
+
+#define IAGR			__SYSREG(0xd4000100,u16)	/* intr acceptance group reg */
+#define IAGR_GN			0x00fc		/* group number register
+						 * (documentation _has_ to be wrong)
+						 */
+
+#define EXTMD			__SYSREG(0xd4000200,u16)	/* external pin intr spec reg */
+#define GET_XIRQ_TRIGGER(X) ((EXTMD>>((X)*2)) & 3)
+
+#define SET_XIRQ_TRIGGER(X,Y)			\
+do {						\
+	u16 x = EXTMD;				\
+	x &= ~(3<<((X)*2));			\
+	x |= ((Y)&3) << ((X)*2);		\
+	EXTMD = x;				\
+} while(0)
+
+#define XIRQ_TRIGGER_LOWLEVEL	0
+#define XIRQ_TRIGGER_HILEVEL	1
+#define XIRQ_TRIGGER_NEGEDGE	2
+#define XIRQ_TRIGGER_POSEDGE	3
+
+/* non-maskable interrupt control */
+#define NMIIRQ			0
+#define NMICR			GxICR(NMIIRQ)	/* NMI control register */
+#define NMICR_NMIF		0x0001		/* NMI pin interrupt flag */
+#define NMICR_WDIF		0x0002		/* watchdog timer overflow flag */
+#define NMICR_ABUSERR		0x0008		/* async bus error flag */
+
+/* maskable interrupt control */
+#define GxICR_DETECT		0x0001		/* interrupt detect flag */
+#define GxICR_REQUEST		0x0010		/* interrupt request flag */
+#define GxICR_ENABLE		0x0100		/* interrupt enable flag */
+#define GxICR_LEVEL		0x7000		/* interrupt priority level */
+#define GxICR_LEVEL_0		0x0000		/* - level 0 */
+#define GxICR_LEVEL_1		0x1000		/* - level 1 */
+#define GxICR_LEVEL_2		0x2000		/* - level 2 */
+#define GxICR_LEVEL_3		0x3000		/* - level 3 */
+#define GxICR_LEVEL_4		0x4000		/* - level 4 */
+#define GxICR_LEVEL_5		0x5000		/* - level 5 */
+#define GxICR_LEVEL_6		0x6000		/* - level 6 */
+#define GxICR_LEVEL_SHIFT	12
+
+#ifndef __ASSEMBLY__
+extern void set_intr_level(int irq, u16 level);
+extern void set_intr_postackable(int irq);
+#endif
+
+/* external interrupts */
+#define XIRQxICR(X)		GxICR((X))	/* external interrupt control regs */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_INTCTL_REGS_H */
diff -puN /dev/null include/asm-mn10300/ioctl.h
--- /dev/null
+++ a/include/asm-mn10300/ioctl.h
@@ -0,0 +1 @@
+#include <asm-generic/ioctl.h>
diff -puN /dev/null include/asm-mn10300/ioctls.h
--- /dev/null
+++ a/include/asm-mn10300/ioctls.h
@@ -0,0 +1,87 @@
+#ifndef _ASM_IOCTLS_H
+#define _ASM_IOCTLS_H
+
+#include <asm/ioctl.h>
+
+/* 0x54 is just a magic number to make these relatively unique ('T') */
+
+#define TCGETS		0x5401
+#define TCSETS		0x5402
+#define TCSETSW		0x5403
+#define TCSETSF		0x5404
+#define TCGETA		0x5405
+#define TCSETA		0x5406
+#define TCSETAW		0x5407
+#define TCSETAF		0x5408
+#define TCSBRK		0x5409
+#define TCXONC		0x540A
+#define TCFLSH		0x540B
+#define TIOCEXCL	0x540C
+#define TIOCNXCL	0x540D
+#define TIOCSCTTY	0x540E
+#define TIOCGPGRP	0x540F
+#define TIOCSPGRP	0x5410
+#define TIOCOUTQ	0x5411
+#define TIOCSTI		0x5412
+#define TIOCGWINSZ	0x5413
+#define TIOCSWINSZ	0x5414
+#define TIOCMGET	0x5415
+#define TIOCMBIS	0x5416
+#define TIOCMBIC	0x5417
+#define TIOCMSET	0x5418
+#define TIOCGSOFTCAR	0x5419
+#define TIOCSSOFTCAR	0x541A
+#define FIONREAD	0x541B
+#define TIOCINQ		FIONREAD
+#define TIOCLINUX	0x541C
+#define TIOCCONS	0x541D
+#define TIOCGSERIAL	0x541E
+#define TIOCSSERIAL	0x541F
+#define TIOCPKT		0x5420
+#define FIONBIO		0x5421
+#define TIOCNOTTY	0x5422
+#define TIOCSETD	0x5423
+#define TIOCGETD	0x5424
+#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
+/* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
+#define TIOCSBRK	0x5427  /* BSD compatibility */
+#define TIOCCBRK	0x5428  /* BSD compatibility */
+#define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
+#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
+#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+
+#define FIONCLEX	0x5450
+#define FIOCLEX		0x5451
+#define FIOASYNC	0x5452
+#define TIOCSERCONFIG	0x5453
+#define TIOCSERGWILD	0x5454
+#define TIOCSERSWILD	0x5455
+#define TIOCGLCKTRMIOS	0x5456
+#define TIOCSLCKTRMIOS	0x5457
+#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
+#define TIOCSERGETLSR   0x5459 /* Get line status register */
+#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
+#define TIOCSERSETMULTI 0x545B /* Set multiport config */
+
+#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
+#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
+#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
+#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
+#define FIOQSIZE	0x5460
+
+/* Used for packet mode */
+#define TIOCPKT_DATA		 0
+#define TIOCPKT_FLUSHREAD	 1
+#define TIOCPKT_FLUSHWRITE	 2
+#define TIOCPKT_STOP		 4
+#define TIOCPKT_START		 8
+#define TIOCPKT_NOSTOP		16
+#define TIOCPKT_DOSTOP		32
+
+#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
+
+#endif /* _ASM_IOCTLS_H */
diff -puN /dev/null include/asm-mn10300/io.h
--- /dev/null
+++ a/include/asm-mn10300/io.h
@@ -0,0 +1,292 @@
+/* MN10300 I/O port emulation and memory-mapped I/O
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_IO_H
+#define _ASM_IO_H
+
+#include <asm/page.h> /* I/O is all done through memory accesses */
+#include <asm/cpu-regs.h>
+#include <asm/cacheflush.h>
+
+#define mmiowb() do {} while(0)
+
+/*****************************************************************************/
+/*
+ * readX/writeX() are used to access memory mapped devices. On some
+ * architectures the memory mapped IO stuff needs to be accessed
+ * differently. On the x86 architecture, we just read/write the
+ * memory location directly.
+ */
+static inline u8 readb(const volatile void __iomem *addr)
+{
+	return *(const volatile u8 *) addr;
+}
+
+static inline u16 readw(const volatile void __iomem *addr)
+{
+	return *(const volatile u16 *) addr;
+}
+
+static inline u32 readl(const volatile void __iomem *addr)
+{
+	return *(const volatile u32 *) addr;
+}
+
+#define __raw_readb readb
+#define __raw_readw readw
+#define __raw_readl readl
+
+#define readb_relaxed readb
+#define readw_relaxed readw
+#define readl_relaxed readl
+
+static inline void writeb(u8 b, volatile void __iomem *addr)
+{
+	*(volatile u8 *) addr = b;
+}
+
+static inline void writew(u16 b, volatile void __iomem *addr)
+{
+	*(volatile u16 *) addr = b;
+}
+
+static inline void writel(u32 b, volatile void __iomem *addr)
+{
+	*(volatile u32 *) addr = b;
+}
+
+#define __raw_writeb writeb
+#define __raw_writew writew
+#define __raw_writel writel
+
+/*****************************************************************************/
+/*
+ * traditional input/output functions
+ */
+static inline u8 inb_local(unsigned long addr)
+{
+	return readb((volatile void __iomem *) addr);
+}
+
+static inline void outb_local(u8 b, unsigned long addr)
+{
+	return writeb(b, (volatile void __iomem *) addr);
+}
+
+static inline u8 inb(unsigned long addr)
+{
+	return readb((volatile void __iomem *) addr);
+}
+
+static inline u16 inw(unsigned long addr)
+{
+	return readw((volatile void __iomem *) addr);
+}
+
+static inline u32 inl(unsigned long addr)
+{
+	return readl((volatile void __iomem *) addr);
+}
+
+static inline void outb(u8 b, unsigned long addr)
+{
+	return writeb(b, (volatile void __iomem *) addr);
+}
+
+static inline void outw(u16 b, unsigned long addr)
+{
+	return writew(b, (volatile void __iomem *) addr);
+}
+
+static inline void outl(u32 b, unsigned long addr)
+{
+	return writel(b, (volatile void __iomem *) addr);
+}
+
+#define inb_p(addr)	inb(addr)
+#define inw_p(addr)	inw(addr)
+#define inl_p(addr)	inl(addr)
+#define outb_p(x,addr)	outb((x),(addr))
+#define outw_p(x,addr)	outw((x),(addr))
+#define outl_p(x,addr)	outl((x),(addr))
+
+static inline void insb(unsigned long addr, void *buffer, int count)
+{
+	if (count) {
+		u8 *buf = buffer;
+		do {
+			u8 x = inb(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+
+static inline void insw(unsigned long addr, void *buffer, int count)
+{
+	if (count) {
+		u16 *buf = buffer;
+		do {
+			u16 x = inw(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+
+static inline void insl(unsigned long addr, void *buffer, int count)
+{
+	if (count) {
+		u32 *buf = buffer;
+		do {
+			u32 x = inl(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+
+static inline void outsb(unsigned long addr, const void *buffer, int count)
+{
+	if (count) {
+		const u8 *buf = buffer;
+		do {
+			outb(*buf++, addr);
+		} while (--count);
+	}
+}
+
+static inline void outsw(unsigned long addr, const void *buffer, int count)
+{
+	if (count) {
+		const u16 *buf = buffer;
+		do {
+			outw(*buf++, addr);
+		} while (--count);
+	}
+}
+
+extern void __outsl(unsigned long addr, const void *buffer, int count);
+static inline void outsl(unsigned long addr, const void *buffer, int count)
+{
+	if ((unsigned long) buffer & 0x3)
+		return __outsl(addr, buffer, count);
+
+	if (count) {
+		const u32 *buf = buffer;
+		do {
+			outl(*buf++, addr);
+		} while (--count);
+	}
+}
+
+#define ioread8(addr)		readb(addr)
+#define ioread16(addr)		readw(addr)
+#define ioread32(addr)		readl(addr)
+
+#define iowrite8(v, addr)	writeb((v), (addr))
+#define iowrite16(v, addr)	writew((v), (addr))
+#define iowrite32(v, addr)	writel((v), (addr))
+
+#define ioread8_rep(p, dst, count)	insb((unsigned long) (p), (dst), (count))
+#define ioread16_rep(p, dst, count)	insw((unsigned long) (p), (dst), (count))
+#define ioread32_rep(p, dst, count)	insl((unsigned long) (p), (dst), (count))
+
+#define iowrite8_rep(p, src, count)	outsb((unsigned long) (p), (src), (count))
+#define iowrite16_rep(p, src, count)	outsw((unsigned long) (p), (src), (count))
+#define iowrite32_rep(p, src, count)	outsl((unsigned long) (p), (src), (count))
+
+
+#define IO_SPACE_LIMIT 0xffffffff
+
+#ifdef __KERNEL__
+
+#include <linux/vmalloc.h>
+#define __io_virt(x) ((void *) (x))
+
+/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
+struct pci_dev;
+extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
+{
+}
+
+/*
+ * Change virtual addresses to physical addresses and vv.
+ * These are pretty trivial
+ */
+static inline unsigned long virt_to_phys(volatile void *address)
+{
+	return __pa(address);
+}
+
+static inline void * phys_to_virt(unsigned long address)
+{
+	return __va(address);
+}
+
+/*
+ * Change "struct page" to physical address.
+ */
+static inline void *__ioremap(unsigned long offset, unsigned long size, unsigned long flags)
+{
+	return (void *) offset;
+}
+
+static inline void *ioremap(unsigned long offset, unsigned long size)
+{
+	return (void *) offset;
+}
+
+/*
+ * This one maps high address device memory and turns off caching for that area.
+ * it's useful if some control registers are in such an area and write combining
+ * or read caching is not desirable:
+ */
+static inline void *ioremap_nocache (unsigned long offset, unsigned long size)
+{
+        return (void *) (offset | 0x20000000);
+}
+
+static inline void iounmap(void *addr)
+{
+}
+
+static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
+{
+	return (void __iomem *) port;
+}
+
+static inline void ioport_unmap(void __iomem *p)
+{
+}
+
+#define xlate_dev_kmem_ptr(p)	((void *) (p))
+#define xlate_dev_mem_ptr(p)	((void *) (p))
+
+/*
+ * PCI bus iomem addresses must be in the region 0x80000000-0x9fffffff
+ */
+static inline unsigned long virt_to_bus(volatile void *address)
+{
+	return ((unsigned long) address) & ~0x20000000;
+}
+
+static inline void *bus_to_virt(unsigned long address)
+{
+	return (void *) address;
+}
+
+#define page_to_bus page_to_phys
+
+#define memset_io(a,b,c)	memset(__io_virt(a), (b), (c))
+#define memcpy_fromio(a,b,c)	memcpy((a), __io_virt(b), (c))
+#define memcpy_toio(a,b,c)	memcpy(__io_virt(a), (b), (c))
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_IO_H */
diff -puN /dev/null include/asm-mn10300/ipcbuf.h
--- /dev/null
+++ a/include/asm-mn10300/ipcbuf.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_IPCBUF_H_
+#define _ASM_IPCBUF_H
+
+/*
+ * The ipc64_perm structure for MN10300 architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 32-bit mode_t and seq
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct ipc64_perm
+{
+	__kernel_key_t		key;
+	__kernel_uid32_t	uid;
+	__kernel_gid32_t	gid;
+	__kernel_uid32_t	cuid;
+	__kernel_gid32_t	cgid;
+	__kernel_mode_t		mode;
+	unsigned short		__pad1;
+	unsigned short		seq;
+	unsigned short		__pad2;
+	unsigned long		__unused1;
+	unsigned long		__unused2;
+};
+
+#endif /* _ASM_IPCBUF_H */
diff -puN /dev/null include/asm-mn10300/ipc.h
--- /dev/null
+++ a/include/asm-mn10300/ipc.h
@@ -0,0 +1 @@
+#include <asm-generic/ipc.h>
diff -puN /dev/null include/asm-mn10300/irq.h
--- /dev/null
+++ a/include/asm-mn10300/irq.h
@@ -0,0 +1,32 @@
+/* MN10300 Hardware interrupt definitions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ * - Derived from include/asm-i386/irq.h:
+ *   - (C) 1992, 1993 Linus Torvalds, (C) 1997 Ingo Molnar
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_IRQ_H
+#define _ASM_IRQ_H
+
+#include <asm/intctl-regs.h>
+#include <asm/reset-regs.h>
+#include <asm/proc/irq.h>
+
+/* this number is used when no interrupt has been assigned */
+#define NO_IRQ		INT_MAX
+
+/* hardware irq numbers */
+#define NR_IRQS		GxICR_NUM_IRQS
+
+/* external hardware irq numbers */
+#define NR_XIRQS	GxICR_NUM_XIRQS
+
+#define irq_canonicalize(IRQ) (IRQ)
+
+#endif /* _ASM_IRQ_H */
diff -puN /dev/null include/asm-mn10300/irq_regs.h
--- /dev/null
+++ a/include/asm-mn10300/irq_regs.h
@@ -0,0 +1,24 @@
+/* MN10300 IRQ registers pointer definition
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_IRQ_REGS_H
+#define _ASM_IRQ_REGS_H
+
+/*
+ * Per-cpu current frame pointer - the location of the last exception frame on
+ * the stack
+ */
+#define ARCH_HAS_OWN_IRQ_REGS
+
+#ifndef __ASSEMBLY__
+#define get_irq_regs() (__frame)
+#endif
+
+#endif /* _ASM_IRQ_REGS_H */
diff -puN /dev/null include/asm-mn10300/Kbuild
--- /dev/null
+++ a/include/asm-mn10300/Kbuild
@@ -0,0 +1,5 @@
+include include/asm-generic/Kbuild.asm
+
+unifdef-y += termios.h
+unifdef-y += ptrace.h
+unifdef-y += page.h
diff -puN /dev/null include/asm-mn10300/kdebug.h
--- /dev/null
+++ a/include/asm-mn10300/kdebug.h
@@ -0,0 +1,22 @@
+/* MN10300 In-kernel death knells
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_KDEBUG_H
+#define _ASM_KDEBUG_H
+
+/* Grossly misnamed. */
+enum die_val {
+	DIE_OOPS = 1,
+	DIE_BREAKPOINT,
+	DIE_GPF,
+};
+
+#endif /* _ASM_KDEBUG_H */
diff -puN /dev/null include/asm-mn10300/kmap_types.h
--- /dev/null
+++ a/include/asm-mn10300/kmap_types.h
@@ -0,0 +1,31 @@
+/* MN10300 kmap_atomic() slot IDs
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_KMAP_TYPES_H
+#define _ASM_KMAP_TYPES_H
+
+enum km_type {
+	KM_BOUNCE_READ,
+	KM_SKB_SUNRPC_DATA,
+	KM_SKB_DATA_SOFTIRQ,
+	KM_USER0,
+	KM_USER1,
+	KM_BIO_SRC_IRQ,
+	KM_BIO_DST_IRQ,
+	KM_PTE0,
+	KM_PTE1,
+	KM_IRQ0,
+	KM_IRQ1,
+	KM_SOFTIRQ0,
+	KM_SOFTIRQ1,
+	KM_TYPE_NR
+};
+
+#endif /* _ASM_KMAP_TYPES_H */
diff -puN /dev/null include/asm-mn10300/kprobes.h
--- /dev/null
+++ a/include/asm-mn10300/kprobes.h
@@ -0,0 +1,48 @@
+/* MN10300 Kernel Probes support
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by Mark Salter (msalter@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public Licence as published by
+ * the Free Software Foundation; either version 2 of the Licence, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public Licence for more details.
+ *
+ * You should have received a copy of the GNU General Public Licence
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+#ifndef _ASM_KPROBES_H
+#define _ASM_KPROBES_H
+
+#include <linux/types.h>
+#include <linux/ptrace.h>
+
+struct kprobe;
+
+typedef unsigned char kprobe_opcode_t;
+#define BREAKPOINT_INSTRUCTION	0xff
+#define MAX_INSN_SIZE 8
+#define MAX_STACK_SIZE 128
+
+/* Architecture specific copy of original instruction */
+struct arch_specific_insn {
+	/*  copy of original instruction 
+	 */
+	kprobe_opcode_t insn[MAX_INSN_SIZE];
+};
+
+extern int kprobe_exceptions_notify(struct notifier_block *self,
+				    unsigned long val, void *data);
+
+#define flush_insn_slot(p)  do {} while (0)
+
+extern void __kprobes arch_remove_kprobe(struct kprobe *p);
+
+#endif /* _ASM_KPROBES_H */
diff -puN /dev/null include/asm-mn10300/linkage.h
--- /dev/null
+++ a/include/asm-mn10300/linkage.h
@@ -0,0 +1,22 @@
+/* MN10300 Linkage and calling-convention overrides
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_LINKAGE_H
+#define _ASM_LINKAGE_H
+
+/* don't override anything */
+#define asmlinkage
+#define FASTCALL(x) x
+#define fastcall
+
+#define __ALIGN		.align 4,0xcb
+#define __ALIGN_STR	".align 4,0xcb"
+
+#endif
diff -puN /dev/null include/asm-mn10300/local.h
--- /dev/null
+++ a/include/asm-mn10300/local.h
@@ -0,0 +1 @@
+#include <asm-generic/local.h>
diff -puN /dev/null include/asm-mn10300/mc146818rtc.h
--- /dev/null
+++ a/include/asm-mn10300/mc146818rtc.h
@@ -0,0 +1 @@
+#include <asm/rtc-regs.h>
diff -puN /dev/null include/asm-mn10300/mman.h
--- /dev/null
+++ a/include/asm-mn10300/mman.h
@@ -0,0 +1,28 @@
+/* MN10300 Constants for mmap and co.
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * - Derived from asm-x86/mman.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_MMAN_H
+#define _ASM_MMAN_H
+
+#include <asm-generic/mman.h>
+
+#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
+#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
+#define MAP_LOCKED	0x2000		/* pages are locked */
+#define MAP_NORESERVE	0x4000		/* don't check for reservations */
+#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
+#define MAP_NONBLOCK	0x10000		/* do not block on IO */
+
+#define MCL_CURRENT	1		/* lock all current mappings */
+#define MCL_FUTURE	2		/* lock all future mappings */
+
+#endif /* _ASM_MMAN_H */
diff -puN /dev/null include/asm-mn10300/mmu_context.h
--- /dev/null
+++ a/include/asm-mn10300/mmu_context.h
@@ -0,0 +1,138 @@
+/* MN10300 MMU context management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ * - Derived from include/asm-m32r/mmu_context.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ *
+ *
+ * This implements an algorithm to provide TLB PID mappings to provide
+ * selective access to the TLB for processes, thus reducing the number of TLB
+ * flushes required.
+ *
+ * Note, however, that the M32R algorithm is technically broken as it does not
+ * handle version wrap-around, and could, theoretically, have a problem with a
+ * very long lived program that sleeps long enough for the version number to
+ * wrap all the way around so that its TLB mappings appear valid once again.
+ */
+#ifndef _ASM_MMU_CONTEXT_H
+#define _ASM_MMU_CONTEXT_H
+
+#include <asm/atomic.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
+
+#define MMU_CONTEXT_TLBPID_MASK		0x000000ffUL
+#define MMU_CONTEXT_VERSION_MASK	0xffffff00UL
+#define MMU_CONTEXT_FIRST_VERSION	0x00000100UL
+#define MMU_NO_CONTEXT			0x00000000UL
+
+extern unsigned long mmu_context_cache[NR_CPUS];
+#define mm_context(mm)	(mm->context.tlbpid[smp_processor_id()])
+
+#define enter_lazy_tlb(mm, tsk)	do {} while (0)
+
+#ifdef CONFIG_SMP
+#define cpu_ran_vm(cpu, task) \
+	cpu_set((cpu), (task)->cpu_vm_mask)
+#define cpu_maybe_ran_vm(cpu, task) \
+	cpu_test_and_set((cpu), (task)->cpu_vm_mask)
+#else
+#define cpu_ran_vm(cpu, task)		do {} while(0)
+#define cpu_maybe_ran_vm(cpu, task)	true
+#endif /* CONFIG_SMP */
+
+/*
+ * allocate an MMU context
+ */
+static inline unsigned long allocate_mmu_context(struct mm_struct *mm)
+{
+	unsigned long *pmc = &mmu_context_cache[smp_processor_id()];
+	unsigned long mc = ++(*pmc);
+
+	if (!(mc & MMU_CONTEXT_TLBPID_MASK)) {
+		/* we exhausted the TLB PIDs of this version on this CPU, so we
+		 * flush this CPU's TLB in its entirety and start new cycle */
+		flush_tlb_all();
+
+		/* fix the TLB version if needed (we avoid version #0 so as to
+		 * distingush MMU_NO_CONTEXT) */
+		if (!mc)
+			*pmc = mc = MMU_CONTEXT_FIRST_VERSION;
+	}
+	mm_context(mm) = mc;
+	return mc;
+}
+
+/*
+ * get an MMU context if one is needed
+ */
+static inline unsigned long get_mmu_context(struct mm_struct *mm)
+{
+	unsigned long mc = MMU_NO_CONTEXT, cache;
+
+	if (mm) {
+		cache = mmu_context_cache[smp_processor_id()];
+		mc = mm_context(mm);
+
+		/* if we have an old version of the context, replace it */
+		if ((mc ^ cache) & MMU_CONTEXT_VERSION_MASK)
+			mc = allocate_mmu_context(mm);
+	}
+	return mc;
+}
+
+/*
+ * initialise the context related info for a new mm_struct instance
+ */
+static inline int init_new_context(struct task_struct *tsk,
+				   struct mm_struct *mm)
+{
+	int num_cpus = NR_CPUS, i;
+
+	for (i = 0; i < num_cpus; i++)
+		mm->context.tlbpid[i] = MMU_NO_CONTEXT;
+	return 0;
+}
+
+/*
+ * destroy context related info for an mm_struct that is about to be put to
+ * rest
+ */
+#define destroy_context(mm)	do { } while (0)
+
+/*
+ * after we have set current->mm to a new value, this activates the context for
+ * the new mm so we see the new mappings.
+ */
+static inline void activate_context(struct mm_struct *mm, int cpu)
+{
+	PIDR = get_mmu_context(mm) & MMU_CONTEXT_TLBPID_MASK;
+}
+
+/*
+ * change between virtual memory sets
+ */
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+			     struct task_struct *tsk)
+{
+	int cpu = smp_processor_id();
+
+	if (prev != next) {
+		cpu_ran_vm(cpu, next);
+		activate_context(next, cpu);
+		PTBR = (unsigned long) next->pgd;
+	} else if (!cpu_maybe_ran_vm(cpu, next)) {
+		activate_context(next, cpu);
+	}
+}
+
+#define deactivate_mm(tsk, mm)	do {} while (0)
+#define activate_mm(prev, next)	switch_mm((prev), (next), NULL)
+
+#endif /* _ASM_MMU_CONTEXT_H */
diff -puN /dev/null include/asm-mn10300/mmu.h
--- /dev/null
+++ a/include/asm-mn10300/mmu.h
@@ -0,0 +1,18 @@
+/* MN10300 Memory management context
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from include/asm-frv/mmu.h
+ */
+
+#ifndef _ASM_MMU_H
+#define _ASM_MMU_H
+
+/*
+ * MMU context
+ */
+typedef struct {
+	unsigned long	tlbpid[NR_CPUS];	/* TLB PID for this process on each CPU */
+} mm_context_t;
+
+#endif /* _ASM_MMU_H */
diff -puN /dev/null include/asm-mn10300/module.h
--- /dev/null
+++ a/include/asm-mn10300/module.h
@@ -0,0 +1,27 @@
+/* MN10300 Arch-specific module definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by Mark Salter (msalter@redhat.com)
+ * Derived from include/asm-i386/module.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_MODULE_H
+#define _ASM_MODULE_H
+
+struct mod_arch_specific {
+};
+
+#define Elf_Shdr	Elf32_Shdr
+#define Elf_Sym		Elf32_Sym
+#define Elf_Ehdr	Elf32_Ehdr
+
+/*
+ * Include the MN10300 architecture version.
+ */
+#define MODULE_ARCH_VERMAGIC __stringify(PROCESSOR_MODEL_NAME) " "
+
+#endif /* _ASM_MODULE_H */
diff -puN /dev/null include/asm-mn10300/msgbuf.h
--- /dev/null
+++ a/include/asm-mn10300/msgbuf.h
@@ -0,0 +1,31 @@
+#ifndef _ASM_MSGBUF_H
+#define _ASM_MSGBUF_H
+
+/*
+ * The msqid64_ds structure for MN10300 architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct msqid64_ds {
+	struct ipc64_perm	msg_perm;
+	__kernel_time_t		msg_stime;	/* last msgsnd time */
+	unsigned long		__unused1;
+	__kernel_time_t		msg_rtime;	/* last msgrcv time */
+	unsigned long		__unused2;
+	__kernel_time_t		msg_ctime;	/* last change time */
+	unsigned long		__unused3;
+	unsigned long		msg_cbytes;	/* current number of bytes on queue */
+	unsigned long		msg_qnum;	/* number of messages in queue */
+	unsigned long		msg_qbytes;	/* max number of bytes on queue */
+	__kernel_pid_t		msg_lspid;	/* pid of last msgsnd */
+	__kernel_pid_t		msg_lrpid;	/* last receive pid */
+	unsigned long		__unused4;
+	unsigned long		__unused5;
+};
+
+#endif /* _ASM_MSGBUF_H */
diff -puN /dev/null include/asm-mn10300/mutex.h
--- /dev/null
+++ a/include/asm-mn10300/mutex.h
@@ -0,0 +1,16 @@
+/* MN10300 Mutex fastpath
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ *
+ *
+ * TODO: implement optimized primitives instead, or leave the generic
+ * implementation in place, or pick the atomic_xchg() based generic
+ * implementation. (see asm-generic/mutex-xchg.h for details)
+ */
+#include <asm-generic/mutex-null.h>
diff -puN /dev/null include/asm-mn10300/namei.h
--- /dev/null
+++ a/include/asm-mn10300/namei.h
@@ -0,0 +1,22 @@
+/* Emulation stuff
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_NAMEI_H
+#define _ASM_NAMEI_H
+
+/* This dummy routine maybe changed to something useful
+ * for /usr/gnemul/ emulation stuff.
+ * Look at asm-sparc/namei.h for details.
+ */
+
+#define __emul_prefix() NULL
+
+#endif /* _ASM_NAMEI_H */
diff -puN /dev/null include/asm-mn10300/nmi.h
--- /dev/null
+++ a/include/asm-mn10300/nmi.h
@@ -0,0 +1,14 @@
+/* MN10300 NMI handling
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_NMI_H
+#define _ASM_NMI_H
+
+#endif /* _ASM_NMI_H */
diff -puN /dev/null include/asm-mn10300/page.h
--- /dev/null
+++ a/include/asm-mn10300/page.h
@@ -0,0 +1,129 @@
+/* MN10300 Page table definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PAGE_H
+#define _ASM_PAGE_H
+
+/* PAGE_SHIFT determines the page size */
+#define PAGE_SHIFT	12
+
+#ifndef __ASSEMBLY__
+#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+#else
+#define PAGE_SIZE	+(1 << PAGE_SHIFT)	/* unary plus marks an immediate val not an addr */
+#define PAGE_MASK	+(~(PAGE_SIZE-1))
+#endif
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
+#define copy_page(to, from)	memcpy((void *)(to), (void *)(from), PAGE_SIZE)
+
+#define clear_user_page(addr, vaddr, page)	clear_page(addr)
+#define copy_user_page(vto, vfrom, vaddr, to)	copy_page(vto, vfrom)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { unsigned long pte; } pte_t;
+typedef struct { unsigned long pgd; } pgd_t;
+typedef struct { unsigned long pgprot; } pgprot_t;
+
+#define PTE_MASK	PAGE_MASK
+#define HPAGE_SHIFT	22
+
+#ifdef CONFIG_HUGETLB_PAGE
+#define HPAGE_SIZE		((1UL) << HPAGE_SHIFT)
+#define HPAGE_MASK		(~(HPAGE_SIZE - 1))
+#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
+#endif
+
+#define pte_val(x)	((x).pte)
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) } )
+#define __pgd(x)	((pgd_t) { (x) } )
+#define __pgprot(x)	((pgprot_t) { (x) } )
+
+#include <asm-generic/pgtable-nopmd.h>
+
+#endif /* !__ASSEMBLY__ */
+
+/* to align the pointer to the (next) page boundary */
+#define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
+
+/*
+ * This handles the memory map.. We could make this a config
+ * option, but too many people screw it up, and too few need
+ * it.
+ *
+ * A __PAGE_OFFSET of 0xC0000000 means that the kernel has
+ * a virtual address space of one gigabyte, which limits the
+ * amount of physical memory you can use to about 950MB.
+ */
+
+#ifndef __ASSEMBLY__
+
+/* Pure 2^n version of get_order */
+static inline int get_order(unsigned long size) __attribute__((const));
+static inline int get_order(unsigned long size)
+{
+	int order;
+
+	size = (size - 1) >> (PAGE_SHIFT - 1);
+	order = -1;
+	do {
+		size >>= 1;
+		order++;
+	} while (size);
+	return order;
+}
+
+#endif /* __ASSEMBLY__ */
+
+#include <asm/page_offset.h>
+
+#define __PAGE_OFFSET		(PAGE_OFFSET_RAW)
+#define PAGE_OFFSET		((unsigned long) __PAGE_OFFSET)
+
+/*
+ * main RAM and kernel working space are coincident at 0x90000000, but to make
+ * life more interesting, there's also an uncached virtual shadow at 0xb0000000
+ * - these mappings are fixed in the MMU
+ */
+#define __pfn_disp		(CONFIG_KERNEL_RAM_BASE_ADDRESS >> PAGE_SHIFT)
+
+#define __pa(x)			((unsigned long)(x))
+#define __va(x)			((void *)(unsigned long)(x))
+#define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
+#define pfn_to_page(pfn)	(mem_map + ((pfn) - __pfn_disp))
+#define page_to_pfn(page)	((unsigned long)((page) - mem_map) + __pfn_disp)
+
+#define pfn_valid(pfn)					\
+({							\
+	unsigned long __pfn = (pfn) - __pfn_disp;	\
+	__pfn < max_mapnr;				\
+})
+
+#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+#define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
+
+#define VM_DATA_DEFAULT_FLAGS \
+	(VM_READ | VM_WRITE | \
+	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_PAGE_H */
diff -puN /dev/null include/asm-mn10300/page_offset.h
--- /dev/null
+++ a/include/asm-mn10300/page_offset.h
@@ -0,0 +1,11 @@
+/* MN10300 Kernel base address
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+#ifndef _ASM_PAGE_OFFSET_H
+#define _ASM_PAGE_OFFSET_H
+
+#define PAGE_OFFSET_RAW CONFIG_KERNEL_RAM_BASE_ADDRESS
+
+#endif
diff -puN /dev/null include/asm-mn10300/param.h
--- /dev/null
+++ a/include/asm-mn10300/param.h
@@ -0,0 +1,33 @@
+/* MN10300 Kernel parameters
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PARAM_H
+#define _ASM_PARAM_H
+
+#ifdef __KERNEL__
+#define HZ		1000		/* Internal kernel timer frequency */
+#define USER_HZ		100		/* .. some user interfaces are in "ticks" */
+#define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
+#endif
+
+#ifndef HZ
+#define HZ		100
+#endif
+
+#define EXEC_PAGESIZE	4096
+
+#ifndef NOGROUP
+#define NOGROUP		(-1)
+#endif
+
+#define MAXHOSTNAMELEN	64	/* max length of hostname */
+#define COMMAND_LINE_SIZE 256
+
+#endif /* _ASM_PARAM_H */
diff -puN /dev/null include/asm-mn10300/pci.h
--- /dev/null
+++ a/include/asm-mn10300/pci.h
@@ -0,0 +1,131 @@
+/* MN10300 PCI definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PCI_H
+#define _ASM_PCI_H
+
+#ifdef __KERNEL__
+#include <linux/mm.h>		/* for struct page */
+
+#if 0
+#define __pcbdebug(FMT,ADDR,...) \
+	printk("PCIBRIDGE[%08x]: "FMT"\n",(u32)(ADDR),##__VA_ARGS__)
+
+#define __pcidebug(FMT,BUS,DEVFN,WHERE,...)		\
+do {							\
+	printk("PCI[%02x:%02x.%x + %02x]: "FMT"\n",	\
+	       (BUS)->number,				\
+	       PCI_SLOT(DEVFN),				\
+	       PCI_FUNC(DEVFN),				\
+	       (u32)(WHERE),##__VA_ARGS__);		\
+} while(0)
+
+#else
+#define __pcbdebug(FMT,ADDR,...)		do {} while(0)
+#define __pcidebug(FMT,BUS,DEVFN,WHERE,...)	do {} while(0)
+#endif
+
+/* Can be used to override the logic in pci_scan_bus for skipping
+ * already-configured bus numbers - to be used for buggy BIOSes or
+ * architectures with incomplete PCI setup by the loader */
+
+#ifdef CONFIG_PCI
+#define pcibios_assign_all_busses()	1
+extern void unit_pci_init(void);
+#else
+#define pcibios_assign_all_busses()	0
+#endif
+
+extern unsigned long pci_mem_start;
+#define PCIBIOS_MIN_IO		0xBE000004
+#define PCIBIOS_MIN_MEM		0xB8000000
+
+void pcibios_set_master(struct pci_dev *dev);
+void pcibios_penalize_isa_irq(int irq);
+
+/* Dynamic DMA mapping stuff.
+ * i386 has everything mapped statically.
+ */
+
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <asm/scatterlist.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <asm/io.h>
+
+struct pci_dev;
+
+/* The PCI address space does equal the physical memory
+ * address space.  The networking and block device layers use
+ * this boolean for bounce buffer decisions.
+ */
+#define PCI_DMA_BUS_IS_PHYS	(1)
+
+
+/* This is always fine. */
+#define pci_dac_dma_supported(pci_dev, mask)	(0)
+
+/*
+ * These macros should be used after a pci_map_sg call has been done
+ * to get bus addresses of each of the SG entries and their lengths.
+ * You should only work with the number of sg entries pci_map_sg
+ * returns.
+ */
+#define sg_dma_address(sg)	((sg)->dma_address)
+#define sg_dma_len(sg)		((sg)->length)
+
+/* Return the index of the PCI controller for device. */
+static inline int pci_controller_num(struct pci_dev *dev)
+{
+	return 0;
+}
+
+#define HAVE_PCI_MMAP
+extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
+			       enum pci_mmap_state mmap_state, int write_combine);
+
+#endif /* __KERNEL__ */
+
+/* implement the pci_ DMA API in terms of the generic device dma_ one */
+#include <asm-generic/pci-dma-compat.h>
+
+/**
+ * pcibios_resource_to_bus - convert resource to PCI bus address
+ * @dev: device which owns this resource
+ * @region: converted bus-centric region (start,end)
+ * @res: resource to convert
+ *
+ * Convert a resource to a PCI device bus address or bus window.
+ */
+extern void pcibios_resource_to_bus(struct pci_dev *dev,
+				    struct pci_bus_region *region,
+				    struct resource *res);
+
+extern void pcibios_bus_to_resource(struct pci_dev *dev,
+				    struct resource *res,
+				    struct pci_bus_region *region);
+
+static inline struct resource *
+pcibios_select_root(struct pci_dev *pdev, struct resource *res)
+{
+	struct resource *root = NULL;
+
+	if (res->flags & IORESOURCE_IO)
+		root = &ioport_resource;
+	if (res->flags & IORESOURCE_MEM)
+		root = &iomem_resource;
+
+	return root;
+}
+
+#define pcibios_scan_all_fns(a, b)	0
+
+#endif /* _ASM_PCI_H */
diff -puN /dev/null include/asm-mn10300/percpu.h
--- /dev/null
+++ a/include/asm-mn10300/percpu.h
@@ -0,0 +1 @@
+#include <asm-generic/percpu.h>
diff -puN /dev/null include/asm-mn10300/pgalloc.h
--- /dev/null
+++ a/include/asm-mn10300/pgalloc.h
@@ -0,0 +1,54 @@
+/* MN10300 Page and page table/directory allocation
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PGALLOC_H
+#define _ASM_PGALLOC_H
+
+#include <asm/processor.h>
+#include <asm/page.h>
+#include <linux/threads.h>
+#include <linux/mm.h>		/* for struct page */
+
+struct mm_struct;
+struct page;
+
+/* attach a page table to a PMD entry */
+#define pmd_populate_kernel(mm, pmd, pte) \
+	set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE))
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, struct page *pte)
+{
+	set_pmd(pmd, __pmd((page_to_pfn(pte) << PAGE_SHIFT) | _PAGE_TABLE));
+}
+
+/*
+ * Allocate and free page tables.
+ */
+
+extern pgd_t *pgd_alloc(struct mm_struct *);
+extern void pgd_free(pgd_t *pgd);
+
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
+extern struct page *pte_alloc_one(struct mm_struct *, unsigned long);
+
+static inline void pte_free_kernel(pte_t *pte)
+{
+	free_page((unsigned long) pte);
+}
+
+static inline void pte_free(struct page *pte)
+{
+	__free_page(pte);
+}
+
+
+#define __pte_free_tlb(tlb, pte) tlb_remove_page((tlb), (pte))
+
+#endif /* _ASM_PGALLOC_H */
diff -puN /dev/null include/asm-mn10300/pgtable.h
--- /dev/null
+++ a/include/asm-mn10300/pgtable.h
@@ -0,0 +1,471 @@
+/* MN10300 Page table manipulators and constants
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ *
+ *
+ * The Linux memory management assumes a three-level page table setup. On
+ * the i386, we use that, but "fold" the mid level into the top-level page
+ * table, so that we physically have the same two-level page table as the
+ * i386 mmu expects.
+ *
+ * This file contains the functions and defines necessary to modify and use
+ * the i386 page table tree for the purposes of the MN10300 TLB handler
+ * functions.
+ */
+#ifndef _ASM_PGTABLE_H
+#define _ASM_PGTABLE_H
+
+#include <asm/cpu-regs.h>
+
+#ifndef __ASSEMBLY__
+#include <asm/processor.h>
+#include <asm/cache.h>
+#include <linux/threads.h>
+
+#include <asm/bitops.h>
+
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
+extern unsigned long empty_zero_page[1024];
+extern spinlock_t pgd_lock;
+extern struct page *pgd_list;
+
+extern void pmd_ctor(void *, struct kmem_cache *, unsigned long);
+extern void pgtable_cache_init(void);
+extern void paging_init(void);
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * The Linux mn10300 paging architecture only implements both the traditional
+ * 2-level page tables
+ */
+#define PGDIR_SHIFT	22
+#define PTRS_PER_PGD	1024
+#define PTRS_PER_PUD	1		/* we don't really have any PUD physically */
+#define PTRS_PER_PMD	1		/* we don't really have any PMD physically */
+#define PTRS_PER_PTE	1024
+
+#define PGD_SIZE	PAGE_SIZE
+#define PMD_SIZE	(1UL << PMD_SHIFT)
+#define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
+#define PGDIR_MASK	(~(PGDIR_SIZE - 1))
+
+#define USER_PTRS_PER_PGD	(TASK_SIZE / PGDIR_SIZE)
+#define FIRST_USER_ADDRESS	0
+
+#define USER_PGD_PTRS		(PAGE_OFFSET >> PGDIR_SHIFT)
+#define KERNEL_PGD_PTRS		(PTRS_PER_PGD - USER_PGD_PTRS)
+
+#define TWOLEVEL_PGDIR_SHIFT	22
+#define BOOT_USER_PGD_PTRS	(__PAGE_OFFSET >> TWOLEVEL_PGDIR_SHIFT)
+#define BOOT_KERNEL_PGD_PTRS	(1024 - BOOT_USER_PGD_PTRS)
+
+#ifndef __ASSEMBLY__
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
+#endif
+
+/*
+ * Unfortunately, due to the way the MMU works on the MN10300, the vmalloc VM
+ * area has to be in the lower half of the virtual address range (the upper
+ * half is not translated through the TLB).
+ *
+ * So in this case, the vmalloc area goes at the bottom of the address map
+ * (leaving a hole at the very bottom to catch addressing errors), and
+ * userspace starts immediately above.
+ *
+ * The vmalloc() routines also leaves a hole of 4kB between each vmalloced
+ * area to catch addressing errors.
+ */
+#define VMALLOC_OFFSET	(8 * 1024 * 1024)
+#define VMALLOC_START	(0x70000000)
+#define VMALLOC_END	(0x7C000000)
+
+#ifndef __ASSEMBLY__
+extern pte_t kernel_vmalloc_ptes[(VMALLOC_END - VMALLOC_START) / PAGE_SIZE];
+#endif
+
+/* IPTEL/DPTEL bit assignments */
+#define _PAGE_BIT_VALID		xPTEL_V_BIT
+#define _PAGE_BIT_ACCESSED	xPTEL_UNUSED1_BIT	/* mustn't be loaded into IPTEL/DPTEL */
+#define _PAGE_BIT_NX		xPTEL_UNUSED2_BIT	/* mustn't be loaded into IPTEL/DPTEL */
+#define _PAGE_BIT_CACHE		xPTEL_C_BIT
+#define _PAGE_BIT_PRESENT	xPTEL_PV_BIT
+#define _PAGE_BIT_DIRTY		xPTEL_D_BIT
+#define _PAGE_BIT_GLOBAL	xPTEL_G_BIT
+
+#define _PAGE_VALID		xPTEL_V
+#define _PAGE_ACCESSED		xPTEL_UNUSED1
+#define _PAGE_NX		xPTEL_UNUSED2		/* no-execute bit */
+#define _PAGE_CACHE		xPTEL_C
+#define _PAGE_PRESENT		xPTEL_PV
+#define _PAGE_DIRTY		xPTEL_D
+#define _PAGE_PROT		xPTEL_PR
+#define _PAGE_PROT_RKNU		xPTEL_PR_ROK
+#define _PAGE_PROT_WKNU		xPTEL_PR_RWK
+#define _PAGE_PROT_RKRU		xPTEL_PR_ROK_ROU
+#define _PAGE_PROT_WKRU		xPTEL_PR_RWK_ROU
+#define _PAGE_PROT_WKWU		xPTEL_PR_RWK_RWU
+#define _PAGE_GLOBAL		xPTEL_G
+#define _PAGE_PSE		xPTEL_PS_4Mb		/* 4MB page */
+
+#define _PAGE_FILE		xPTEL_UNUSED1_BIT	/* set:pagecache unset:swap */
+
+#define __PAGE_PROT_UWAUX	0x040
+#define __PAGE_PROT_USER	0x080
+#define __PAGE_PROT_WRITE	0x100
+
+#define _PAGE_PRESENTV		(_PAGE_PRESENT|_PAGE_VALID)
+#define _PAGE_PROTNONE		0x000	/* If not present */
+
+#ifndef __ASSEMBLY__
+
+#define VMALLOC_VMADDR(x) ((unsigned long)(x))
+
+#define _PAGE_TABLE	(_PAGE_PRESENTV | _PAGE_PROT_WKNU | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
+
+#define __PAGE_NONE	(_PAGE_PRESENTV | _PAGE_PROT_RKNU | _PAGE_ACCESSED | _PAGE_CACHE)
+#define __PAGE_SHARED	(_PAGE_PRESENTV | _PAGE_PROT_WKWU | _PAGE_ACCESSED | _PAGE_CACHE)
+#define __PAGE_COPY	(_PAGE_PRESENTV | _PAGE_PROT_RKRU | _PAGE_ACCESSED | _PAGE_CACHE)
+#define __PAGE_READONLY	(_PAGE_PRESENTV | _PAGE_PROT_RKRU | _PAGE_ACCESSED | _PAGE_CACHE)
+
+#define PAGE_NONE		__pgprot(__PAGE_NONE     | _PAGE_NX)
+#define PAGE_SHARED_NOEXEC	__pgprot(__PAGE_SHARED   | _PAGE_NX)
+#define PAGE_COPY_NOEXEC	__pgprot(__PAGE_COPY     | _PAGE_NX)
+#define PAGE_READONLY_NOEXEC	__pgprot(__PAGE_READONLY | _PAGE_NX)
+#define PAGE_SHARED_EXEC	__pgprot(__PAGE_SHARED)
+#define PAGE_COPY_EXEC		__pgprot(__PAGE_COPY)
+#define PAGE_READONLY_EXEC	__pgprot(__PAGE_READONLY)
+#define PAGE_COPY		PAGE_COPY_NOEXEC
+#define PAGE_READONLY		PAGE_READONLY_NOEXEC
+#define PAGE_SHARED		PAGE_SHARED_EXEC
+
+#define __PAGE_KERNEL_BASE (_PAGE_PRESENTV | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
+
+#define __PAGE_KERNEL		(__PAGE_KERNEL_BASE | _PAGE_PROT_WKNU | _PAGE_CACHE | _PAGE_NX)
+#define __PAGE_KERNEL_NOCACHE	(__PAGE_KERNEL_BASE | _PAGE_PROT_WKNU | _PAGE_NX)
+#define __PAGE_KERNEL_EXEC	(__PAGE_KERNEL & ~_PAGE_NX)
+#define __PAGE_KERNEL_RO	(__PAGE_KERNEL_BASE | _PAGE_PROT_RKNU | _PAGE_CACHE | _PAGE_NX)
+#define __PAGE_KERNEL_LARGE	(__PAGE_KERNEL | _PAGE_PSE)
+#define __PAGE_KERNEL_LARGE_EXEC (__PAGE_KERNEL_EXEC | _PAGE_PSE)
+
+#define PAGE_KERNEL		__pgprot(__PAGE_KERNEL)
+#define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO)
+#define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
+#define PAGE_KERNEL_NOCACHE	__pgprot(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE)
+#define PAGE_KERNEL_LARGE_EXEC	__pgprot(__PAGE_KERNEL_LARGE_EXEC)
+
+/*
+ * Whilst the MN10300 can do page protection for execute (given separate data and insn TLBs), we
+ * are not supporting it at the moment. Write permission, however, always implies read permission
+ * (but not execute permission).
+ */
+#define __P000	PAGE_NONE
+#define __P001	PAGE_READONLY_NOEXEC
+#define __P010	PAGE_COPY_NOEXEC
+#define __P011	PAGE_COPY_NOEXEC
+#define __P100	PAGE_READONLY_EXEC
+#define __P101	PAGE_READONLY_EXEC
+#define __P110	PAGE_COPY_EXEC
+#define __P111	PAGE_COPY_EXEC
+
+#define __S000	PAGE_NONE
+#define __S001	PAGE_READONLY_NOEXEC
+#define __S010	PAGE_SHARED_NOEXEC
+#define __S011	PAGE_SHARED_NOEXEC
+#define __S100	PAGE_READONLY_EXEC
+#define __S101	PAGE_READONLY_EXEC
+#define __S110	PAGE_SHARED_EXEC
+#define __S111	PAGE_SHARED_EXEC
+
+/*
+ * Define this to warn about kernel memory accesses that are
+ * done without a 'verify_area(VERIFY_WRITE,..)'
+ */
+#undef TEST_VERIFY_AREA
+
+#define pte_present(x)	(pte_val(x) & _PAGE_VALID)
+#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
+
+#define pmd_none(x)	(!pmd_val(x))
+#define pmd_present(x)	(!pmd_none(x))
+#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
+#define	pmd_bad(x)	0
+
+
+#define pages_to_mb(x) ((x) >> (20 - PAGE_SHIFT))
+
+#ifndef __ASSEMBLY__
+
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+static inline int pte_user(pte_t pte)		{ return pte_val(pte) & __PAGE_PROT_USER; }
+static inline int pte_read(pte_t pte)		{ return pte_val(pte) & __PAGE_PROT_USER; }
+static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
+static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
+static inline int pte_write(pte_t pte)		{ return pte_val(pte) & __PAGE_PROT_WRITE; }
+
+/*
+ * The following only works if pte_present() is not true.
+ */
+static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
+
+static inline pte_t pte_rdprotect(pte_t pte)
+{
+	pte_val(pte) &= ~(__PAGE_PROT_USER|__PAGE_PROT_UWAUX); return pte;
+}
+static inline pte_t pte_exprotect(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_NX; return pte;
+}
+
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+	pte_val(pte) &= ~(__PAGE_PROT_WRITE|__PAGE_PROT_UWAUX); return pte;
+}
+
+static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
+static inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
+static inline pte_t pte_mkexec(pte_t pte)	{ pte_val(pte) &= ~_PAGE_NX; return pte; }
+
+static inline pte_t pte_mkread(pte_t pte)
+{
+	pte_val(pte) |= __PAGE_PROT_USER;
+	if (pte_write(pte))
+		pte_val(pte) |= __PAGE_PROT_UWAUX;
+	return pte;
+}
+static inline pte_t pte_mkwrite(pte_t pte)
+{
+	pte_val(pte) |= __PAGE_PROT_WRITE;
+	if (pte_val(pte) & __PAGE_PROT_USER)
+		pte_val(pte) |= __PAGE_PROT_UWAUX;
+	return pte;
+}
+
+#define pte_ERROR(e) \
+	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
+#define pgd_ERROR(e) \
+	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
+
+/*
+ * The "pgd_xxx()" functions here are trivial for a folded two-level
+ * setup: the pgd is never bad, and a pmd always exists (as it's folded
+ * into the pgd entry)
+ */
+#define pgd_clear(xp)				do { } while (0)
+
+/*
+ * Certain architectures need to do special things when PTEs
+ * within a page table are directly modified.  Thus, the following
+ * hook is made available.
+ */
+#define set_pte(pteptr, pteval)		(*(pteptr) = pteval)
+#define set_pte_at(mm,addr,ptep,pteval) set_pte((ptep), (pteval))
+#define set_pte_atomic(pteptr, pteval)	set_pte((pteptr), (pteval))
+/*
+ * (pmds are folded into pgds so this doesn't get actually called,
+ * but the define is needed for a generic inline function.)
+ */
+#define set_pmd(pmdptr, pmdval) (*(pmdptr) = pmdval)
+
+#define ptep_get_and_clear(mm, addr, ptep)	__pte(xchg(&(ptep)->pte, 0))
+#define pte_same(a, b)		(pte_val(a) == pte_val(b))
+#define pte_page(x)		pfn_to_page(pte_pfn(x))
+#define pte_none(x)		(!pte_val(x))
+#define pte_pfn(x)		((unsigned long) (pte_val(x) >> PAGE_SHIFT))
+#define __pfn_addr(pfn)		((pfn) << PAGE_SHIFT)
+#define pfn_pte(pfn, prot)	__pte(__pfn_addr(pfn) | pgprot_val(prot))
+#define pfn_pmd(pfn, prot)	__pmd(__pfn_addr(pfn) | pgprot_val(prot))
+
+/*
+ * All present user pages are user-executable:
+ */
+static inline int pte_exec(pte_t pte)
+{
+	return pte_user(pte);
+}
+
+/*
+ * All present pages are kernel-executable:
+ */
+static inline int pte_exec_kernel(pte_t pte)
+{
+	return 1;
+}
+
+/*
+ * Bits 0 and 1 are taken, split up the 29 bits of offset
+ * into this range:
+ */
+#define PTE_FILE_MAX_BITS	29
+
+#define pte_to_pgoff(pte)	(pte_val(pte) >> 2)
+#define pgoff_to_pte(off)	__pte((off) << 2 | _PAGE_FILE)
+
+/* Encode and de-code a swap entry */
+#define __swp_type(x)			(((x).val >> 2) & 0x3f)
+#define __swp_offset(x)			((x).val >> 8)
+#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 2) | ((offset) << 8) })
+#define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
+#define __swp_entry_to_pte(x)		__pte((x).val)
+
+static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+{
+	if (!pte_dirty(*ptep))
+		return 0;
+	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte);
+}
+
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+{
+	if (!pte_young(*ptep))
+		return 0;
+	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte);
+}
+
+static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_val(*ptep) &= ~(__PAGE_PROT_WRITE|__PAGE_PROT_UWAUX);
+}
+
+static inline void ptep_mkdirty(pte_t *ptep)
+{
+	set_bit(_PAGE_BIT_DIRTY, &ptep->pte);
+}
+
+/*
+ * Macro to mark a page protection value as "uncacheable".  On processors which do not support
+ * it, this is a no-op.
+ */
+#define pgprot_noncached(prot)	__pgprot(pgprot_val(prot) | _PAGE_CACHE)
+
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+
+#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
+#define mk_pte_huge(entry)	((entry).pte |= _PAGE_PRESENT | _PAGE_PSE | _PAGE_VALID)
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+	pte_val(pte) &= _PAGE_CHG_MASK;
+	pte_val(pte) |= pgprot_val(newprot);
+	return pte;
+}
+
+#define page_pte(page)	page_pte_prot((page), __pgprot(0))
+
+#define pmd_page_kernel(pmd) \
+	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
+
+#define pmd_page(pmd)	pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)
+
+#define pmd_large(pmd) \
+	((pmd_val(pmd) & (_PAGE_PSE | _PAGE_PRESENT)) == (_PAGE_PSE | _PAGE_PRESENT))
+
+/*
+ * the pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
+ *
+ * this macro returns the index of the entry in the pgd page which would
+ * control the given virtual address
+ */
+#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+
+/*
+ * pgd_offset() returns a (pgd_t *)
+ * pgd_index() is used get the offset into the pgd page's array of pgd_t's;
+ */
+#define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
+
+/*
+ * a shortcut which implies the use of the kernel's pgd, instead
+ * of a process's
+ */
+#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
+
+/*
+ * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
+ *
+ * this macro returns the index of the entry in the pmd page which would
+ * control the given virtual address
+ */
+#define pmd_index(address) \
+	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
+
+/*
+ * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
+ *
+ * this macro returns the index of the entry in the pte page which would
+ * control the given virtual address
+ */
+#define pte_index(address) \
+	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+
+#define pte_offset_kernel(dir, address) \
+	((pte_t *) pmd_page_kernel(*(dir)) +  pte_index(address))
+
+/*
+ * Make a given kernel text page executable/non-executable.
+ * Returns the previous executability setting of that page (which
+ * is used to restore the previous state). Used by the SMP bootup code.
+ * NOTE: this is an __init function for security reasons.
+ */
+static inline int set_kernel_exec(unsigned long vaddr, int enable) { return 0;}
+
+#define pte_offset_map(dir, address) \
+	((pte_t *) page_address(pmd_page(*(dir))) + pte_index(address))
+#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
+#define pte_unmap(pte)		do {} while (0)
+#define pte_unmap_nested(pte)	do {} while (0)
+
+/*
+ * The MN10300 has external MMU info in the form of a TLB: this is adapted from
+ * the kernel page tables containing the necessary information by tlb-mn10300.S
+ */
+extern void update_mmu_cache(struct vm_area_struct *vma,
+			     unsigned long address, pte_t pte);
+
+#endif /* !__ASSEMBLY__ */
+
+#define kern_addr_valid(addr)	(1)
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot) \
+	remap_pfn_range((vma), (vaddr), (pfn), (size), (prot))
+
+#define MK_IOSPACE_PFN(space, pfn)	(pfn)
+#define GET_IOSPACE(pfn)		0
+#define GET_PFN(pfn)			(pfn)
+
+#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
+#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
+#define __HAVE_ARCH_PTEP_SET_WRPROTECT
+#define __HAVE_ARCH_PTEP_MKDIRTY
+#define __HAVE_ARCH_PTE_SAME
+#include <asm-generic/pgtable.h>
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_PGTABLE_H */
diff -puN /dev/null include/asm-mn10300/pio-regs.h
--- /dev/null
+++ a/include/asm-mn10300/pio-regs.h
@@ -0,0 +1,233 @@
+/* MN10300 On-board I/O port module registers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PIO_REGS_H
+#define _ASM_PIO_REGS_H
+
+#include <asm/cpu-regs.h>
+#include <asm/intctl-regs.h>
+
+#ifdef __KERNEL__
+
+/* I/O port 0 */
+#define	P0MD			__SYSREG(0xdb000000,u16)	/* mode reg */
+#define P0MD_0			0x0003	/* mask */
+#define P0MD_0_IN		0x0000	/* input mode */
+#define P0MD_0_OUT		0x0001	/* output mode */
+#define P0MD_0_TM0IO		0x0002	/* timer 0 I/O mode */
+#define P0MD_0_EYECLK		0x0003	/* test signal output (clock) */
+#define P0MD_1			0x000c
+#define P0MD_1_IN		0x0000
+#define P0MD_1_OUT		0x0004
+#define P0MD_1_TM1IO		0x0008	/* timer 1 I/O mode */
+#define P0MD_1_EYED		0x000c	/* test signal output (data) */
+#define P0MD_2			0x0030
+#define P0MD_2_IN		0x0000
+#define P0MD_2_OUT		0x0010
+#define P0MD_2_TM2IO		0x0020	/* timer 2 I/O mode */
+#define P0MD_3			0x00c0
+#define P0MD_3_IN		0x0000
+#define P0MD_3_OUT		0x0040
+#define P0MD_3_TM3IO		0x0080	/* timer 3 I/O mode */
+#define P0MD_4			0x0300
+#define P0MD_4_IN		0x0000
+#define P0MD_4_OUT		0x0100
+#define P0MD_4_TM4IO		0x0200	/* timer 4 I/O mode */
+#define P0MD_4_XCTS		0x0300	/* XCTS input for serial port 2 */
+#define P0MD_5			0x0c00
+#define P0MD_5_IN		0x0000
+#define P0MD_5_OUT		0x0400
+#define P0MD_5_TM5IO		0x0800	/* timer 5 I/O mode */
+#define P0MD_6			0x3000
+#define P0MD_6_IN		0x0000
+#define P0MD_6_OUT		0x1000
+#define P0MD_6_TM6IOA		0x2000	/* timer 6 I/O mode A */
+#define P0MD_7			0xc000
+#define P0MD_7_IN		0x0000
+#define P0MD_7_OUT		0x4000
+#define P0MD_7_TM6IOB		0x8000	/* timer 6 I/O mode B */
+
+#define	P0IN			__SYSREG(0xdb000004,u8)		/* in reg */
+#define	P0OUT			__SYSREG(0xdb000008,u8)		/* out reg */
+
+#define	P0TMIO			__SYSREG(0xdb00000c,u8)		/* TM pin I/O control reg */
+#define P0TMIO_TM0_IN		0x00
+#define P0TMIO_TM0_OUT		0x01
+#define P0TMIO_TM1_IN		0x00
+#define P0TMIO_TM1_OUT		0x02
+#define P0TMIO_TM2_IN		0x00
+#define P0TMIO_TM2_OUT		0x04
+#define P0TMIO_TM3_IN		0x00
+#define P0TMIO_TM3_OUT		0x08
+#define P0TMIO_TM4_IN		0x00
+#define P0TMIO_TM4_OUT		0x10
+#define P0TMIO_TM5_IN		0x00
+#define P0TMIO_TM5_OUT		0x20
+#define P0TMIO_TM6A_IN		0x00
+#define P0TMIO_TM6A_OUT		0x40
+#define P0TMIO_TM6B_IN		0x00
+#define P0TMIO_TM6B_OUT		0x80
+
+/* I/O port 1 */
+#define	P1MD			__SYSREG(0xdb000100,u16)	/* mode reg */
+#define P1MD_0			0x0003	/* mask */
+#define P1MD_0_IN		0x0000	/* input mode */
+#define P1MD_0_OUT		0x0001	/* output mode */
+#define P1MD_0_TM7IO		0x0002	/* timer 7 I/O mode */
+#define P1MD_0_ADTRG		0x0003	/* A/D converter trigger mode */
+#define P1MD_1			0x000c
+#define P1MD_1_IN		0x0000
+#define P1MD_1_OUT		0x0004
+#define P1MD_1_TM8IO		0x0008	/* timer 8 I/O mode */
+#define P1MD_1_XDMR0		0x000c	/* DMA request input 0 mode */
+#define P1MD_2			0x0030
+#define P1MD_2_IN		0x0000
+#define P1MD_2_OUT		0x0010
+#define P1MD_2_TM9IO		0x0020	/* timer 9 I/O mode */
+#define P1MD_2_XDMR1		0x0030	/* DMA request input 1 mode */
+#define P1MD_3			0x00c0
+#define P1MD_3_IN		0x0000
+#define P1MD_3_OUT		0x0040
+#define P1MD_3_TM10IO		0x0080	/* timer 10 I/O mode */
+#define P1MD_3_FRQS0		0x00c0	/* CPU clock multiplier setting input 0 mode */
+#define P1MD_4			0x0300
+#define P1MD_4_IN		0x0000
+#define P1MD_4_OUT		0x0100
+#define P1MD_4_TM11IO		0x0200	/* timer 11 I/O mode */
+#define P1MD_4_FRQS1		0x0300	/* CPU clock multiplier setting input 1 mode */
+
+#define	P1IN			__SYSREG(0xdb000104,u8)		/* in reg */
+#define	P1OUT			__SYSREG(0xdb000108,u8)		/* out reg */
+#define	P1TMIO			__SYSREG(0xdb00010c,u8)		/* TM pin I/O control reg */
+#define P1TMIO_TM11_IN		0x00
+#define P1TMIO_TM11_OUT		0x01
+#define P1TMIO_TM10_IN		0x00
+#define P1TMIO_TM10_OUT		0x02
+#define P1TMIO_TM9_IN		0x00
+#define P1TMIO_TM9_OUT		0x04
+#define P1TMIO_TM8_IN		0x00
+#define P1TMIO_TM8_OUT		0x08
+#define P1TMIO_TM7_IN		0x00
+#define P1TMIO_TM7_OUT		0x10
+
+/* I/O port 2 */
+#define	P2MD			__SYSREG(0xdb000200,u16)	/* mode reg */
+#define P2MD_0			0x0003	/* mask */
+#define P2MD_0_IN		0x0000	/* input mode */
+#define P2MD_0_OUT		0x0001	/* output mode */
+#define P2MD_0_BOOTBW		0x0003	/* boot bus width selector mode */
+#define P2MD_1			0x000c
+#define P2MD_1_IN		0x0000
+#define P2MD_1_OUT		0x0004
+#define P2MD_1_BOOTSEL		0x000c	/* boot device selector mode */
+#define P2MD_2			0x0030
+#define P2MD_2_IN		0x0000
+#define P2MD_2_OUT		0x0010
+#define P2MD_3			0x00c0
+#define P2MD_3_IN		0x0000
+#define P2MD_3_OUT		0x0040
+#define P2MD_3_CKIO		0x00c0	/* mode */
+#define P2MD_4			0x0300
+#define P2MD_4_IN		0x0000
+#define P2MD_4_OUT		0x0100
+#define P2MD_4_CMOD		0x0300	/* mode */
+
+#define	P2IN			__SYSREG(0xdb000204,u8)		/* in reg */
+#define	P2OUT			__SYSREG(0xdb000208,u8)		/* out reg */
+#define	P2TMIO			__SYSREG(0xdb00020c,u8)		/* TM pin I/O control reg */
+
+/* I/O port 3 */
+#define	P3MD			__SYSREG(0xdb000300,u16)	/* mode reg */
+#define P3MD_0			0x0003	/* mask */
+#define P3MD_0_IN		0x0000	/* input mode */
+#define P3MD_0_OUT		0x0001	/* output mode */
+#define P3MD_0_AFRXD		0x0002	/* AFR interface mode */
+#define P3MD_1			0x000c
+#define P3MD_1_IN		0x0000
+#define P3MD_1_OUT		0x0004
+#define P3MD_1_AFTXD		0x0008	/* AFR interface mode */
+#define P3MD_2			0x0030
+#define P3MD_2_IN		0x0000
+#define P3MD_2_OUT		0x0010
+#define P3MD_2_AFSCLK		0x0020	/* AFR interface mode */
+#define P3MD_3			0x00c0
+#define P3MD_3_IN		0x0000
+#define P3MD_3_OUT		0x0040
+#define P3MD_3_AFFS		0x0080	/* AFR interface mode */
+#define P3MD_4			0x0300
+#define P3MD_4_IN		0x0000
+#define P3MD_4_OUT		0x0100
+#define P3MD_4_AFEHC		0x0200	/* AFR interface mode */
+
+#define	P3IN			__SYSREG(0xdb000304,u8)		/* in reg */
+#define	P3OUT			__SYSREG(0xdb000308,u8)		/* out reg */
+
+/* I/O port 4 */
+#define	P4MD			__SYSREG(0xdb000400,u16)	/* mode reg */
+#define P4MD_0			0x0003	/* mask */
+#define P4MD_0_IN		0x0000	/* input mode */
+#define P4MD_0_OUT		0x0001	/* output mode */
+#define P4MD_0_SCL0		0x0002	/* I2C/serial mode */
+#define P4MD_1			0x000c
+#define P4MD_1_IN		0x0000
+#define P4MD_1_OUT		0x0004
+#define P4MD_1_SDA0		0x0008
+#define P4MD_2			0x0030
+#define P4MD_2_IN		0x0000
+#define P4MD_2_OUT		0x0010
+#define P4MD_2_SCL1		0x0020
+#define P4MD_3			0x00c0
+#define P4MD_3_IN		0x0000
+#define P4MD_3_OUT		0x0040
+#define P4MD_3_SDA1		0x0080
+#define P4MD_4			0x0300
+#define P4MD_4_IN		0x0000
+#define P4MD_4_OUT		0x0100
+#define P4MD_4_SBO0		0x0200
+#define P4MD_5			0x0c00
+#define P4MD_5_IN		0x0000
+#define P4MD_5_OUT		0x0400
+#define P4MD_5_SBO1		0x0800
+#define P4MD_6			0x3000
+#define P4MD_6_IN		0x0000
+#define P4MD_6_OUT		0x1000
+#define P4MD_6_SBT0		0x2000
+#define P4MD_7			0xc000
+#define P4MD_7_IN		0x0000
+#define P4MD_7_OUT		0x4000
+#define P4MD_7_SBT1		0x8000
+
+#define	P4IN			__SYSREG(0xdb000404,u8)		/* in reg */
+#define	P4OUT			__SYSREG(0xdb000408,u8)		/* out reg */
+
+/* I/O port 5 */
+#define	P5MD			__SYSREG(0xdb000500,u16)	/* mode reg */
+#define P5MD_0			0x0003	/* mask */
+#define P5MD_0_IN		0x0000	/* input mode */
+#define P5MD_0_OUT		0x0001	/* output mode */
+#define P5MD_0_IRTXD		0x0002	/* IrDA mode */
+#define P5MD_0_SOUT		0x0004	/* serial mode */
+#define P5MD_1			0x000c
+#define P5MD_1_IN		0x0000
+#define P5MD_1_OUT		0x0004
+#define P5MD_1_IRRXDS		0x0008	/* IrDA mode */
+#define P5MD_1_SIN		0x000c	/* serial mode */
+#define P5MD_2			0x0030
+#define P5MD_2_IN		0x0000
+#define P5MD_2_OUT		0x0010
+#define P5MD_2_IRRXDF		0x0020	/* IrDA mode */
+
+#define	P5IN			__SYSREG(0xdb000504,u8)		/* in reg */
+#define	P5OUT			__SYSREG(0xdb000508,u8)		/* out reg */
+
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_PIO_REGS_H */
diff -puN /dev/null include/asm-mn10300/poll.h
--- /dev/null
+++ a/include/asm-mn10300/poll.h
@@ -0,0 +1 @@
+#include <asm-generic/poll.h>
diff -puN /dev/null include/asm-mn10300/posix_types.h
--- /dev/null
+++ a/include/asm-mn10300/posix_types.h
@@ -0,0 +1,132 @@
+/* MN10300 POSIX types
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_POSIX_TYPES_H
+#define _ASM_POSIX_TYPES_H
+
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc.  Also, we cannot
+ * assume GCC is being used.
+ */
+
+typedef unsigned long	__kernel_ino_t;
+typedef unsigned short	__kernel_mode_t;
+typedef unsigned short	__kernel_nlink_t;
+typedef long		__kernel_off_t;
+typedef int		__kernel_pid_t;
+typedef unsigned short	__kernel_ipc_pid_t;
+typedef unsigned short	__kernel_uid_t;
+typedef unsigned short	__kernel_gid_t;
+typedef unsigned long	__kernel_size_t;
+typedef long		__kernel_ssize_t;
+typedef int		__kernel_ptrdiff_t;
+typedef long		__kernel_time_t;
+typedef long		__kernel_suseconds_t;
+typedef long		__kernel_clock_t;
+typedef int		__kernel_timer_t;
+typedef int		__kernel_clockid_t;
+typedef int		__kernel_daddr_t;
+typedef char *		__kernel_caddr_t;
+typedef unsigned short	__kernel_uid16_t;
+typedef unsigned short	__kernel_gid16_t;
+typedef unsigned int	__kernel_uid32_t;
+typedef unsigned int	__kernel_gid32_t;
+
+typedef unsigned short	__kernel_old_uid_t;
+typedef unsigned short	__kernel_old_gid_t;
+typedef unsigned short	__kernel_old_dev_t;
+
+#ifdef __GNUC__
+typedef long long	__kernel_loff_t;
+#endif
+
+typedef struct {
+#if defined(__KERNEL__) || defined(__USE_ALL)
+	int	val[2];
+#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
+	int	__val[2];
+#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
+} __kernel_fsid_t;
+
+#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+
+#undef	__FD_SET
+static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
+{
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
+}
+
+#undef	__FD_CLR
+static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
+{
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
+}
+
+
+#undef	__FD_ISSET
+static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
+{
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
+}
+
+/*
+ * This will unroll the loop for the normal constant case (8 ints,
+ * for a 256-bit fd_set)
+ */
+#undef	__FD_ZERO
+static inline void __FD_ZERO(__kernel_fd_set *__p)
+{
+	unsigned long *__tmp = __p->fds_bits;
+	int __i;
+
+	if (__builtin_constant_p(__FDSET_LONGS)) {
+		switch (__FDSET_LONGS) {
+		case 16:
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			__tmp[ 4] = 0; __tmp[ 5] = 0;
+			__tmp[ 6] = 0; __tmp[ 7] = 0;
+			__tmp[ 8] = 0; __tmp[ 9] = 0;
+			__tmp[10] = 0; __tmp[11] = 0;
+			__tmp[12] = 0; __tmp[13] = 0;
+			__tmp[14] = 0; __tmp[15] = 0;
+			return;
+
+		case 8:
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			__tmp[ 4] = 0; __tmp[ 5] = 0;
+			__tmp[ 6] = 0; __tmp[ 7] = 0;
+			return;
+
+		case 4:
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			return;
+		}
+	}
+	__i = __FDSET_LONGS;
+	while (__i) {
+		__i--;
+		*__tmp = 0;
+		__tmp++;
+	}
+}
+
+#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+
+#endif /* _ASM_POSIX_TYPES_H */
diff -puN /dev/null include/asm-mn10300/processor.h
--- /dev/null
+++ a/include/asm-mn10300/processor.h
@@ -0,0 +1,180 @@
+/* MN10300 Processor specifics
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PROCESSOR_H
+#define _ASM_PROCESSOR_H
+
+#include <asm/page.h>
+#include <asm/ptrace.h>
+#include <asm/cpu-regs.h>
+#include <linux/threads.h>
+
+/* Forward declaration, a strange C thing */
+struct task_struct;
+struct mm_struct;
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ void *__pc; __asm__("mov pc,%0":"=a" (__pc)); __pc; })
+
+extern void show_registers(struct pt_regs *regs);
+
+/*
+ *  CPU type and hardware bug flags. Kept separately for each CPU.
+ *  Members of this structure are referenced in head.S, so think twice
+ *  before touching them. [mj]
+ */
+
+struct mn10300_cpuinfo {
+	int		type;
+	unsigned long	loops_per_sec;
+	char		hard_math;
+	unsigned long	*pgd_quick;
+	unsigned long	*pte_quick;
+	unsigned long	pgtable_cache_sz;
+};
+
+extern struct mn10300_cpuinfo boot_cpu_data;
+
+#define cpu_data &boot_cpu_data
+#define current_cpu_data boot_cpu_data
+
+extern void identify_cpu(struct mn10300_cpuinfo *);
+extern void print_cpu_info(struct mn10300_cpuinfo *);
+extern void dodgy_tsc(void);
+#define cpu_relax() do { } while(0)
+
+/*
+ * User space process size: 1.75GB (default).
+ */
+#define TASK_SIZE		0x70000000
+
+/*
+ * Where to put the userspace stack by default
+ */
+#define STACK_TOP		0x70000000
+#define STACK_TOP_MAX		STACK_TOP
+
+/* This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define TASK_UNMAPPED_BASE	0x30000000
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+struct fpu_state_struct {
+	unsigned long	fs[32];		/* fpu registers */
+	unsigned long	fpcr;		/* fpu control register */
+};
+
+struct thread_struct {
+	struct pt_regs		*uregs;		/* userspace register frame */
+	unsigned long		pc;		/* kernel PC */
+	unsigned long		sp;		/* kernel SP */
+	unsigned long		a3;		/* kernel FP */
+	unsigned long		wchan;
+	unsigned long		usp;
+	struct pt_regs		*__frame;
+	unsigned long		fpu_flags;
+#define THREAD_USING_FPU	0x00000001	/* T if this task is using the FPU */
+  	struct fpu_state_struct	fpu_state;
+};
+
+#define INIT_THREAD				\
+{						\
+	.uregs		= init_uregs,		\
+	.pc		= 0,			\
+	.sp		= 0,			\
+	.a3		= 0,			\
+	.wchan		= 0,			\
+	.__frame	= NULL,			\
+}
+
+#define INIT_MMAP \
+{ &init_mm, 0, 0, NULL, PAGE_SHARED, VM_READ | VM_WRITE | VM_EXEC, 1, NULL, NULL }
+
+/*
+ * do necessary setup to start up a newly executed thread
+ * - need to discard the frame stacked by the kernel thread invoking the execve
+ *   syscall (see RESTORE_ALL macro)
+ */
+#define start_thread(regs, new_pc, new_sp) do {		\
+	set_fs(USER_DS);				\
+	__frame = current->thread.uregs;		\
+	__frame->epsw = EPSW_nSL | EPSW_IE | EPSW_IM;	\
+	__frame->pc = new_pc;				\
+	__frame->sp = new_sp;				\
+} while (0)
+
+/* Free all resources held by a thread. */
+extern void release_thread(struct task_struct *);
+
+/* Prepare to copy thread state - unlazy all lazy status */
+extern void prepare_to_copy(struct task_struct *tsk);
+
+/*
+ * create a kernel thread without removing it from tasklists
+ */
+extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
+
+/*
+ * Return saved PC of a blocked thread.
+ */
+extern unsigned long thread_saved_pc(struct task_struct *tsk);
+
+unsigned long get_wchan(struct task_struct *p);
+
+#define task_pt_regs(task)						\
+({									\
+       struct pt_regs *__regs__;					\
+       __regs__ = (struct pt_regs *) (KSTK_TOP(task_stack_page(task)) - 8); \
+       __regs__ - 1;							\
+})
+
+#define KSTK_EIP(task) (task_pt_regs(task)->pc)
+#define KSTK_ESP(task) (task_pt_regs(task)->sp)
+
+#define KSTK_TOP(info)				\
+({						\
+	(unsigned long)(info) + THREAD_SIZE;	\
+})
+
+#define ARCH_HAS_PREFETCH
+#define ARCH_HAS_PREFETCHW
+
+static inline void prefetch(const void *x)
+{
+#ifndef CONFIG_MN10300_CACHE_DISABLED
+#ifdef CONFIG_MN10300_PROC_MN103E010
+	asm volatile ("nop; nop; dcpf (%0)" : : "r"(x));
+#else
+	asm volatile ("dcpf (%0)" : : "r"(x));
+#endif
+#endif
+}
+
+static inline void prefetchw(const void *x)
+{
+#ifndef CONFIG_MN10300_CACHE_DISABLED
+#ifdef CONFIG_MN10300_PROC_MN103E010
+	asm volatile ("nop; nop; dcpf (%0)" : : "r"(x));
+#else
+	asm volatile ("dcpf (%0)" : : "r"(x));
+#endif
+#endif
+}
+
+#endif /* _ASM_PROCESSOR_H */
diff -puN /dev/null include/asm-mn10300/proc-mn103e010/cache.h
--- /dev/null
+++ a/include/asm-mn10300/proc-mn103e010/cache.h
@@ -0,0 +1,33 @@
+/* MN103E010 Cache specification
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PROC_CACHE_H
+#define _ASM_PROC_CACHE_H
+
+/* L1 cache */
+
+#define L1_CACHE_NWAYS		4	/* number of ways in caches */
+#define L1_CACHE_NENTRIES	256	/* number of entries in each way */
+#define L1_CACHE_BYTES		16	/* bytes per entry */
+#define L1_CACHE_SHIFT		4	/* shift for bytes per entry */
+#define L1_CACHE_WAYDISP	0x1000	/* displacement of one way from the next */
+
+#define L1_CACHE_TAG_VALID	0x00000001	/* cache tag valid bit */
+#define L1_CACHE_TAG_DIRTY	0x00000008	/* data cache tag dirty bit */
+#define L1_CACHE_TAG_ENTRY	0x00000ff0	/* cache tag entry address mask */
+#define L1_CACHE_TAG_ADDRESS	0xfffff000	/* cache tag line address mask */
+
+/*
+ * specification of the interval between interrupt checking intervals whilst
+ * managing the cache with the interrupts disabled
+ */
+#define MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL	4
+
+#endif /* _ASM_PROC_CACHE_H */
diff -puN /dev/null include/asm-mn10300/proc-mn103e010/clock.h
--- /dev/null
+++ a/include/asm-mn10300/proc-mn103e010/clock.h
@@ -0,0 +1,18 @@
+/* MN103E010-specific clocks
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PROC_CLOCK_H
+#define _ASM_PROC_CLOCK_H
+
+#include <asm/unit/clock.h>
+
+#define MN10300_WDCLK		MN10300_IOCLK
+
+#endif /* _ASM_PROC_CLOCK_H */
diff -puN /dev/null include/asm-mn10300/proc-mn103e010/irq.h
--- /dev/null
+++ a/include/asm-mn10300/proc-mn103e010/irq.h
@@ -0,0 +1,34 @@
+/* MN103E010 On-board interrupt controller numbers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PROC_IRQ_H
+#define _ASM_PROC_IRQ_H
+
+#ifdef __KERNEL__
+
+#define GxICR_NUM_IRQS		42
+
+#define GxICR_NUM_XIRQS		8
+
+#define XIRQ0		34
+#define XIRQ1		35
+#define XIRQ2		36
+#define XIRQ3		37
+#define XIRQ4		38
+#define XIRQ5		39
+#define XIRQ6		40
+#define XIRQ7		41
+
+#define XIRQ2IRQ(num)	(XIRQ0 + num)
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_PROC_IRQ_H */
diff -puN /dev/null include/asm-mn10300/proc-mn103e010/proc.h
--- /dev/null
+++ a/include/asm-mn10300/proc-mn103e010/proc.h
@@ -0,0 +1,18 @@
+/* MN103E010 Processor description
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PROC_PROC_H
+#define _ASM_PROC_PROC_H
+
+#define PROCESSOR_VENDOR_NAME	"Matsushita"
+#define PROCESSOR_MODEL_NAME	"mn103e010"
+
+#endif /* _ASM_PROC_PROC_H */
diff -puN /dev/null include/asm-mn10300/ptrace.h
--- /dev/null
+++ a/include/asm-mn10300/ptrace.h
@@ -0,0 +1,99 @@
+/* MN10300 Exception frame layout and ptrace constants
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PTRACE_H
+#define _ASM_PTRACE_H
+
+#define PT_A3		0
+#define PT_A2		1
+#define PT_D3		2
+#define	PT_D2		3
+#define PT_MCVF		4
+#define	PT_MCRL		5
+#define PT_MCRH		6
+#define	PT_MDRQ		7
+#define	PT_E1		8
+#define	PT_E0		9
+#define	PT_E7		10
+#define	PT_E6		11
+#define	PT_E5		12
+#define	PT_E4		13
+#define	PT_E3		14
+#define	PT_E2		15
+#define	PT_SP		16
+#define	PT_LAR		17
+#define	PT_LIR		18
+#define	PT_MDR		19
+#define	PT_A1		20
+#define	PT_A0		21
+#define	PT_D1		22
+#define	PT_D0		23
+#define PT_ORIG_D0	24
+#define	PT_EPSW		25
+#define	PT_PC		26
+#define NR_PTREGS	27
+
+#ifndef __ASSEMBLY__
+/*
+ * This defines the way registers are stored in the event of an exception
+ * - the strange order is due to the MOVM instruction
+ */
+struct pt_regs {
+	unsigned long		a3;		/* syscall arg 3 */
+	unsigned long		a2;		/* syscall arg 4 */
+	unsigned long		d3;		/* syscall arg 5 */
+	unsigned long		d2;		/* syscall arg 6 */
+	unsigned long		mcvf;
+	unsigned long		mcrl;
+	unsigned long		mcrh;
+	unsigned long		mdrq;
+	unsigned long		e1;
+	unsigned long		e0;
+	unsigned long		e7;
+	unsigned long		e6;
+	unsigned long		e5;
+	unsigned long		e4;
+	unsigned long		e3;
+	unsigned long		e2;
+	unsigned long		sp;
+	unsigned long		lar;
+	unsigned long		lir;
+	unsigned long		mdr;
+	unsigned long		a1;
+	unsigned long		a0;		/* syscall arg 1 */
+	unsigned long		d1;		/* syscall arg 2 */
+	unsigned long		d0;		/* syscall ret */
+	struct pt_regs		*next;		/* next frame pointer */
+	unsigned long		orig_d0;	/* syscall number */
+	unsigned long		epsw;
+	unsigned long		pc;
+};
+#endif
+
+extern struct pt_regs *__frame; /* current frame pointer */
+
+/* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
+#define PTRACE_GETREGS            12
+#define PTRACE_SETREGS            13
+#define PTRACE_GETFPREGS          14
+#define PTRACE_SETFPREGS          15
+
+/* options set using PTRACE_SETOPTIONS */
+#define PTRACE_O_TRACESYSGOOD     0x00000001
+
+#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+#define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
+#define instruction_pointer(regs)	((regs)->pc)
+extern void show_regs(struct pt_regs *);
+#endif
+
+#define profile_pc(regs) ((regs)->pc)
+
+#endif /* _ASM_PTRACE_H */
diff -puN /dev/null include/asm-mn10300/reset-regs.h
--- /dev/null
+++ a/include/asm-mn10300/reset-regs.h
@@ -0,0 +1,63 @@
+/* MN10300 Reset controller and watchdog timer definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_RESET_REGS_H
+#define _ASM_RESET_REGS_H
+
+#include <asm/cpu-regs.h>
+#include <asm/exceptions.h>
+
+#ifdef __KERNEL__
+
+#ifdef CONFIG_MN10300_WD_TIMER
+#define ARCH_HAS_NMI_WATCHDOG		/* See include/linux/nmi.h */
+#endif
+
+/*
+ * watchdog timer registers
+ */
+#define WDBC			__SYSREGC(0xc0001000,u8)	/* watchdog binary counter reg */
+
+#define WDCTR			__SYSREG(0xc0001002,u8)	/* watchdog timer control reg */
+#define WDCTR_WDCK		0x07	/* clock source selection */
+#define WDCTR_WDCK_256th	0x00	/* - OSCI/256 */
+#define WDCTR_WDCK_1024th	0x01	/* - OSCI/1024 */
+#define WDCTR_WDCK_2048th	0x02	/* - OSCI/2048 */
+#define WDCTR_WDCK_16384th	0x03	/* - OSCI/16384 */
+#define WDCTR_WDCK_65536th	0x04	/* - OSCI/65536 */
+#define WDCTR_WDRST		0x40	/* binary counter reset */
+#define WDCTR_WDCNE		0x80	/* watchdog timer enable */
+
+#define RSTCTR			__SYSREG(0xc0001004,u8)	/* reset control reg */
+#define RSTCTR_CHIPRST		0x01	/* chip reset */
+#define RSTCTR_DBFRST		0x02	/* double fault reset flag */
+#define RSTCTR_WDTRST		0x04	/* watchdog timer reset flag */
+#define RSTCTR_WDREN		0x08	/* watchdog timer reset enable */
+
+#ifndef __ASSEMBLY__
+
+static inline void mn10300_proc_hard_reset(void)
+{
+	RSTCTR &= ~RSTCTR_CHIPRST;
+        RSTCTR |= RSTCTR_CHIPRST;
+}
+
+extern unsigned int watchdog_alert_counter;
+
+extern void watchdog_go(void);
+extern asmlinkage void watchdog_handler(void);
+extern asmlinkage void watchdog_interrupt(struct pt_regs *regs, exception_code_t code);
+
+#endif
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_RESET_REGS_H */
diff -puN /dev/null include/asm-mn10300/resource.h
--- /dev/null
+++ a/include/asm-mn10300/resource.h
@@ -0,0 +1 @@
+#include <asm-generic/resource.h>
diff -puN /dev/null include/asm-mn10300/rtc.h
--- /dev/null
+++ a/include/asm-mn10300/rtc.h
@@ -0,0 +1,41 @@
+/* MN10300 Real time clock definitions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_RTC_H
+#define _ASM_RTC_H
+
+#ifdef CONFIG_MN10300_RTC
+
+#include <linux/init.h>
+
+extern void check_rtc_time(void);
+extern void __init calibrate_clock(void);
+extern unsigned long __init get_initial_rtc_time(void);
+
+#else /* !CONFIG_MN10300_RTC */
+
+static inline void check_rtc_time(void)
+{
+}
+
+static inline void calibrate_clock(void)
+{
+}
+
+static inline unsigned long get_initial_rtc_time(void)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_MN10300_RTC */
+
+#include <asm-generic/rtc.h>
+
+#endif /* _ASM_RTC_H */
diff -puN /dev/null include/asm-mn10300/rtc-regs.h
--- /dev/null
+++ a/include/asm-mn10300/rtc-regs.h
@@ -0,0 +1,85 @@
+/* MN10300 on-chip Real-Time Clock registers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_RTC_REGS_H
+#define _ASM_RTC_REGS_H
+
+#include <asm/intctl-regs.h>
+
+#ifdef __KERNEL__
+
+#define RTSCR			__SYSREG(0xd8600000,u8)	/* RTC seconds count reg */
+#define RTSAR			__SYSREG(0xd8600001,u8)	/* RTC seconds alarm reg */
+#define RTMCR			__SYSREG(0xd8600002,u8)	/* RTC minutes count reg */
+#define RTMAR			__SYSREG(0xd8600003,u8)	/* RTC minutes alarm reg */
+#define RTHCR			__SYSREG(0xd8600004,u8)	/* RTC hours count reg */
+#define RTHAR			__SYSREG(0xd8600005,u8)	/* RTC hours alarm reg */
+#define RTDWCR			__SYSREG(0xd8600006,u8)	/* RTC day of the week count reg */
+#define RTDMCR			__SYSREG(0xd8600007,u8)	/* RTC days count reg */
+#define RTMTCR			__SYSREG(0xd8600008,u8)	/* RTC months count reg */
+#define RTYCR			__SYSREG(0xd8600009,u8)	/* RTC years count reg */
+
+#define RTCRA			__SYSREG(0xd860000a,u8)	/* RTC control reg A */
+#define RTCRA_RS		0x0f	/* periodic timer interrupt cycle setting */
+#define RTCRA_RS_NONE		0x00	/* - off */
+#define RTCRA_RS_3_90625ms	0x01	/* - 3.90625ms	(1/256s) */
+#define RTCRA_RS_7_8125ms	0x02	/* - 7.8125ms	(1/128s) */
+#define RTCRA_RS_122_070us	0x03	/* - 122.070us	(1/8192s) */
+#define RTCRA_RS_244_141us	0x04	/* - 244.141us	(1/4096s) */
+#define RTCRA_RS_488_281us	0x05	/* - 488.281us	(1/2048s) */
+#define RTCRA_RS_976_5625us	0x06	/* - 976.5625us	(1/1024s) */
+#define RTCRA_RS_1_953125ms	0x07	/* - 1.953125ms	(1/512s) */
+#define RTCRA_RS_3_90624ms	0x08	/* - 3.90624ms	(1/256s) */
+#define RTCRA_RS_7_8125ms_b	0x09	/* - 7.8125ms	(1/128s) */
+#define RTCRA_RS_15_625ms	0x0a	/* - 15.625ms	(1/64s) */
+#define RTCRA_RS_31_25ms	0x0b	/* - 31.25ms	(1/32s) */
+#define RTCRA_RS_62_5ms		0x0c	/* - 62.5ms	(1/16s) */
+#define RTCRA_RS_125ms		0x0d	/* - 125ms	(1/8s) */
+#define RTCRA_RS_250ms		0x0e	/* - 250ms	(1/4s) */
+#define RTCRA_RS_500ms		0x0f	/* - 500ms	(1/2s) */
+#define RTCRA_DVR		0x40	/* divider reset */
+#define RTCRA_UIP		0x80	/* clock update flag */
+
+#define RTCRB			__SYSREG(0xd860000b,u8)	/* RTC control reg B */
+#define RTCRB_DSE		0x01	/* daylight savings time enable */
+#define RTCRB_TM		0x02	/* time format */
+#define RTCRB_TM_12HR		0x00	/* - 12 hour format */
+#define RTCRB_TM_24HR		0x02	/* - 24 hour format */
+#define RTCRB_DM		0x04	/* numeric value format */
+#define RTCRB_DM_BCD		0x00	/* - BCD */
+#define RTCRB_DM_BINARY		0x04	/* - binary */
+#define RTCRB_UIE		0x10	/* update interrupt disable */
+#define RTCRB_AIE		0x20	/* alarm interrupt disable */
+#define RTCRB_PIE		0x40	/* periodic interrupt disable */
+#define RTCRB_SET		0x80	/* clock update enable */
+
+#define RTSRC			__SYSREG(0xd860000c,u8)	/* RTC status reg C */
+#define RTSRC_UF		0x10	/* update end interrupt flag */
+#define RTSRC_AF		0x20	/* alarm interrupt flag */
+#define RTSRC_PF		0x40	/* periodic interrupt flag */
+#define RTSRC_IRQF		0x80	/* interrupt flag */
+
+#define RTIRQ			32
+#define RTICR			GxICR(RTIRQ)
+
+/*
+ * MC146818 RTC compatibility defs for the MN10300 on-chip RTC
+ */
+#define RTC_PORT(x)		0xd8600000
+#define RTC_ALWAYS_BCD		1	/* RTC operates in binary mode */
+
+#define CMOS_READ(addr)		__SYSREG(0xd8600000+(addr),u8)
+#define CMOS_WRITE(val,addr)	do { __SYSREG(0xd8600000+(addr),u8) = val; } while(0)
+
+#define RTC_IRQ			RTIRQ
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_RTC_REGS_H */
diff -puN /dev/null include/asm-mn10300/scatterlist.h
--- /dev/null
+++ a/include/asm-mn10300/scatterlist.h
@@ -0,0 +1,46 @@
+/* MN10300 Scatterlist definitions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SCATTERLIST_H
+#define _ASM_SCATTERLIST_H
+
+#include <asm/types.h>
+
+/*
+ * Drivers must set either ->address or (preferred) page and ->offset
+ * to indicate where data must be transferred to/from.
+ *
+ * Using page is recommended since it handles highmem data as well as
+ * low mem. ->address is restricted to data which has a virtual mapping, and
+ * it will go away in the future. Updating to page can be automated very
+ * easily -- something like
+ *
+ * sg->address = some_ptr;
+ *
+ * can be rewritten as
+ *
+ * sg_set_page(virt_to_page(some_ptr));
+ * sg->offset = (unsigned long) some_ptr & ~PAGE_MASK;
+ *
+ * and that's it. There's no excuse for not highmem enabling YOUR driver. /jens
+ */
+struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
+	unsigned long	page_link;
+	unsigned int	offset;		/* for highmem, page offset */
+	dma_addr_t	dma_address;
+	unsigned int	length;
+};
+
+#define ISA_DMA_THRESHOLD (0x00ffffff)
+
+#endif /* _ASM_SCATTERLIST_H */
diff -puN /dev/null include/asm-mn10300/sections.h
--- /dev/null
+++ a/include/asm-mn10300/sections.h
@@ -0,0 +1 @@
+#include <asm-generic/sections.h>
diff -puN /dev/null include/asm-mn10300/semaphore.h
--- /dev/null
+++ a/include/asm-mn10300/semaphore.h
@@ -0,0 +1,168 @@
+/* MN10300 Semaphores
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SEMAPHORE_H
+#define _ASM_SEMAPHORE_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/linkage.h>
+#include <linux/wait.h>
+#include <linux/spinlock.h>
+#include <linux/rwsem.h>
+
+#define SEMAPHORE_DEBUG		0
+
+/*
+ * the semaphore definition
+ * - if count is >0 then there are tokens available on the semaphore for down to collect
+ * - if count is <=0 then there are no spare tokens, and anyone that wants one must wait
+ * - if wait_list is not empty, then there are processes waiting for the semaphore
+ */
+struct semaphore {
+	atomic_t		count;		/* it's not really atomic, it's
+						 * just that certain modules
+						 * expect to be able to access
+						 * it directly */
+	spinlock_t		wait_lock;
+	struct list_head	wait_list;
+#if SEMAPHORE_DEBUG
+	unsigned		__magic;
+#endif
+};
+
+#if SEMAPHORE_DEBUG
+# define __SEM_DEBUG_INIT(name) , (long)&(name).__magic
+#else
+# define __SEM_DEBUG_INIT(name)
+#endif
+
+
+#define __SEMAPHORE_INITIALIZER(name, count)	\
+{						\
+	ATOMIC_INIT(count),			\
+	SPIN_LOCK_UNLOCKED,			\
+	LIST_HEAD_INIT((name).wait_list)	\
+	__SEM_DEBUG_INIT(name)			\
+}
+
+#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
+
+#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name, 1)
+#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name, 0)
+
+static inline void sema_init (struct semaphore *sem, int val)
+{
+	*sem = (struct semaphore) __SEMAPHORE_INITIALIZER(*sem, val);
+}
+
+static inline void init_MUTEX (struct semaphore *sem)
+{
+	sema_init(sem, 1);
+}
+
+static inline void init_MUTEX_LOCKED (struct semaphore *sem)
+{
+	sema_init(sem, 0);
+}
+
+extern void __down(struct semaphore *sem, unsigned long flags);
+extern int  __down_interruptible(struct semaphore *sem, unsigned long flags);
+extern void __up(struct semaphore *sem);
+
+static inline void down(struct semaphore *sem)
+{
+	unsigned long flags;
+	int count;
+
+#if SEMAPHORE_DEBUG
+	CHECK_MAGIC(sem->__magic);
+#endif
+
+	spin_lock_irqsave(&sem->wait_lock, flags);
+	count = atomic_read(&sem->count);
+	if (likely(count > 0)) {
+		atomic_set(&sem->count, count - 1);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
+	}
+	else {
+		__down(sem, flags);
+	}
+}
+
+static inline int down_interruptible(struct semaphore *sem)
+{
+	unsigned long flags;
+	int count, ret = 0;
+
+#if SEMAPHORE_DEBUG
+	CHECK_MAGIC(sem->__magic);
+#endif
+
+	spin_lock_irqsave(&sem->wait_lock, flags);
+	count = atomic_read(&sem->count);
+	if (likely(count > 0)) {
+		atomic_set(&sem->count, count - 1);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
+	}
+	else {
+		ret = __down_interruptible(sem, flags);
+	}
+	return ret;
+}
+
+/*
+ * non-blockingly attempt to down() a semaphore.
+ * - returns zero if we acquired it
+ */
+static inline int down_trylock(struct semaphore *sem)
+{
+	unsigned long flags;
+	int count, success = 0;
+
+#if SEMAPHORE_DEBUG
+	CHECK_MAGIC(sem->__magic);
+#endif
+
+	spin_lock_irqsave(&sem->wait_lock, flags);
+	count = atomic_read(&sem->count);
+	if (likely(count > 0)) {
+		atomic_set(&sem->count, count - 1);
+		success = 1;
+	}
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	return !success;
+}
+
+static inline void up(struct semaphore *sem)
+{
+	unsigned long flags;
+
+#if SEMAPHORE_DEBUG
+	CHECK_MAGIC(sem->__magic);
+#endif
+
+	spin_lock_irqsave(&sem->wait_lock, flags);
+	if (!list_empty(&sem->wait_list))
+		__up(sem);
+	else
+		atomic_set(&sem->count, atomic_read(&sem->count) + 1);
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
+}
+
+static inline int sem_getcount(struct semaphore *sem)
+{
+	return atomic_read(&sem->count);
+}
+
+#endif /* __ASSEMBLY__ */
+
+#endif
diff -puN /dev/null include/asm-mn10300/sembuf.h
--- /dev/null
+++ a/include/asm-mn10300/sembuf.h
@@ -0,0 +1,25 @@
+#ifndef _ASM_SEMBUF_H
+#define _ASM_SEMBUF_H
+
+/*
+ * The semid64_ds structure for MN10300 architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct semid64_ds {
+	struct ipc64_perm sem_perm;		/* permissions .. see ipc.h */
+	__kernel_time_t	sem_otime;		/* last semop time */
+	unsigned long	__unused1;
+	__kernel_time_t	sem_ctime;		/* last change time */
+	unsigned long	__unused2;
+	unsigned long	sem_nsems;		/* no. of semaphores in array */
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+#endif /* _ASM_SEMBUF_H */
diff -puN /dev/null include/asm-mn10300/serial.h
--- /dev/null
+++ a/include/asm-mn10300/serial.h
@@ -0,0 +1,36 @@
+/* Standard UART definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+/*
+ * The ASB2305 has an 18.432 MHz clock the UART
+ */
+#define BASE_BAUD ( 18432000 / 16 )
+
+/* Standard COM flags (except for COM4, because of the 8514 problem) */
+#ifdef CONFIG_SERIAL_DETECT_IRQ
+#define STD_COM_FLAGS	(ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
+#define STD_COM4_FLAGS	(ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
+#else
+#define STD_COM_FLAGS	(ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
+#define STD_COM4_FLAGS	ASYNC_BOOT_AUTOCONF
+#endif
+
+#ifdef CONFIG_SERIAL_MANY_PORTS
+#define FOURPORT_FLAGS	ASYNC_FOURPORT
+#define ACCENT_FLAGS	0
+#define BOCA_FLAGS	0
+#define HUB6_FLAGS	0
+#define RS_TABLE_SIZE	64
+#else
+#define RS_TABLE_SIZE
+#endif
+
+#include <asm/unit/serial.h>
diff -puN /dev/null include/asm-mn10300/serial-regs.h
--- /dev/null
+++ a/include/asm-mn10300/serial-regs.h
@@ -0,0 +1,160 @@
+/* MN10300 on-board serial port module registers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SERIAL_REGS_H
+#define _ASM_SERIAL_REGS_H
+
+#include <asm/cpu-regs.h>
+#include <asm/intctl-regs.h>
+
+#ifdef __KERNEL__
+
+/* serial port 0 */
+#define	SC0CTR			__SYSREG(0xd4002000,u16)	/* control reg */
+#define	SC01CTR_CK		0x0007	/* clock source select */
+#define	SC0CTR_CK_TM8UFLOW_8	0x0000	/* - 1/8 timer 8 underflow (serial port 0 only) */
+#define	SC1CTR_CK_TM9UFLOW_8	0x0000	/* - 1/8 timer 9 underflow (serial port 1 only) */
+#define	SC01CTR_CK_IOCLK_8	0x0001	/* - 1/8 IOCLK */
+#define	SC01CTR_CK_IOCLK_32	0x0002	/* - 1/32 IOCLK */
+#define	SC0CTR_CK_TM2UFLOW_2	0x0003	/* - 1/2 timer 2 underflow (serial port 0 only) */
+#define	SC1CTR_CK_TM3UFLOW_2	0x0003	/* - 1/2 timer 3 underflow (serial port 1 only) */
+#define	SC0CTR_CK_TM0UFLOW_8	0x0004	/* - 1/8 timer 1 underflow (serial port 0 only) */
+#define	SC1CTR_CK_TM1UFLOW_8	0x0004	/* - 1/8 timer 2 underflow (serial port 1 only) */
+#define	SC0CTR_CK_TM2UFLOW_8	0x0005	/* - 1/8 timer 2 underflow (serial port 0 only) */
+#define	SC1CTR_CK_TM3UFLOW_8	0x0005	/* - 1/8 timer 3 underflow (serial port 1 only) */
+#define	SC01CTR_CK_EXTERN_8	0x0006	/* - 1/8 external closk */
+#define	SC01CTR_CK_EXTERN	0x0007	/* - external closk */
+#define	SC01CTR_STB		0x0008	/* stop bit select */
+#define	SC01CTR_STB_1BIT	0x0000	/* - 1 stop bit */
+#define	SC01CTR_STB_2BIT	0x0008	/* - 2 stop bits */
+#define	SC01CTR_PB		0x0070	/* parity bit select */
+#define	SC01CTR_PB_NONE		0x0000	/* - no parity */
+#define	SC01CTR_PB_FIXED0	0x0040	/* - fixed at 0 */
+#define	SC01CTR_PB_FIXED1	0x0050	/* - fixed at 1 */
+#define	SC01CTR_PB_EVEN		0x0060	/* - even parity */
+#define	SC01CTR_PB_ODD		0x0070	/* - odd parity */
+#define	SC01CTR_CLN		0x0080	/* character length */
+#define	SC01CTR_CLN_7BIT	0x0000	/* - 7 bit chars */
+#define	SC01CTR_CLN_8BIT	0x0080	/* - 8 bit chars */
+#define	SC01CTR_TOE		0x0100	/* T input output enable */
+#define	SC01CTR_OD		0x0200	/* bit order select */
+#define	SC01CTR_OD_LSBFIRST	0x0000	/* - LSB first */
+#define	SC01CTR_OD_MSBFIRST	0x0200	/* - MSB first */
+#define	SC01CTR_MD		0x0c00	/* mode select */
+#define SC01CTR_MD_STST_SYNC	0x0000	/* - start-stop synchronous */
+#define SC01CTR_MD_CLOCK_SYNC1	0x0400	/* - clock synchronous 1 */
+#define SC01CTR_MD_I2C		0x0800	/* - I2C mode */
+#define SC01CTR_MD_CLOCK_SYNC2	0x0c00	/* - clock synchronous 2 */
+#define	SC01CTR_IIC		0x1000	/* I2C mode select */
+#define	SC01CTR_BKE		0x2000	/* break transmit enable */
+#define	SC01CTR_RXE		0x4000	/* receive enable */
+#define	SC01CTR_TXE		0x8000	/* transmit enable */
+
+#define	SC0ICR			__SYSREG(0xd4002004,u8)		/* interrupt control reg */
+#define SC01ICR_DMD		0x80	/* output data mode */
+#define SC01ICR_TD		0x20	/* transmit DMA trigger cause */
+#define SC01ICR_TI		0x10	/* transmit interrupt cause */
+#define SC01ICR_RES		0x04	/* receive error select */
+#define SC01ICR_RI		0x01	/* receive interrupt cause */
+
+#define	SC0TXB			__SYSREG(0xd4002008,u8)		/* transmit buffer reg */
+#define	SC0RXB			__SYSREG(0xd4002009,u8)		/* receive buffer reg */
+
+#define	SC0STR			__SYSREG(0xd400200c,u16)	/* status reg */
+#define SC01STR_OEF		0x0001	/* overrun error found */
+#define SC01STR_PEF		0x0002	/* parity error found */
+#define SC01STR_FEF		0x0004	/* framing error found */
+#define SC01STR_RBF		0x0010	/* receive buffer status */
+#define SC01STR_TBF		0x0020	/* transmit buffer status */
+#define SC01STR_RXF		0x0040	/* receive status */
+#define SC01STR_TXF		0x0080	/* transmit status */
+#define SC01STR_STF		0x0100	/* I2C start sequence found */
+#define SC01STR_SPF		0x0200	/* I2C stop sequence found */
+
+#define SC0RXIRQ		20	/* timer 0 Receive IRQ */
+#define SC0TXIRQ		21	/* timer 0 Transmit IRQ */
+
+#define	SC0RXICR		GxICR(SC0RXIRQ)	/* serial 0 receive intr ctrl reg */
+#define	SC0TXICR		GxICR(SC0TXIRQ)	/* serial 0 transmit intr ctrl reg */
+
+/* serial port 1 */
+#define	SC1CTR			__SYSREG(0xd4002010,u16)	/* serial port 1 control */
+#define	SC1ICR			__SYSREG(0xd4002014,u8)		/* interrupt control reg */
+#define	SC1TXB			__SYSREG(0xd4002018,u8)		/* transmit buffer reg */
+#define	SC1RXB			__SYSREG(0xd4002019,u8)		/* receive buffer reg */
+#define	SC1STR			__SYSREG(0xd400201c,u16)	/* status reg */
+
+#define SC1RXIRQ		22	/* timer 1 Receive IRQ */
+#define SC1TXIRQ		23	/* timer 1 Transmit IRQ */
+
+#define	SC1RXICR		GxICR(SC1RXIRQ)	/* serial 1 receive intr ctrl reg */
+#define	SC1TXICR		GxICR(SC1TXIRQ)	/* serial 1 transmit intr ctrl reg */
+
+/* serial port 2 */
+#define	SC2CTR			__SYSREG(0xd4002020,u16)	/* control reg */
+#define	SC2CTR_CK		0x0003	/* clock source select */
+#define	SC2CTR_CK_TM10UFLOW	0x0000	/* - timer 10 underflow */
+#define	SC2CTR_CK_TM2UFLOW	0x0001	/* - timer 2 underflow */
+#define	SC2CTR_CK_EXTERN	0x0002	/* - external closk */
+#define	SC2CTR_CK_TM3UFLOW	0x0003	/* - timer 3 underflow */
+#define	SC2CTR_STB		0x0008	/* stop bit select */
+#define	SC2CTR_STB_1BIT		0x0000	/* - 1 stop bit */
+#define	SC2CTR_STB_2BIT		0x0008	/* - 2 stop bits */
+#define	SC2CTR_PB		0x0070	/* parity bit select */
+#define	SC2CTR_PB_NONE		0x0000	/* - no parity */
+#define	SC2CTR_PB_FIXED0	0x0040	/* - fixed at 0 */
+#define	SC2CTR_PB_FIXED1	0x0050	/* - fixed at 1 */
+#define	SC2CTR_PB_EVEN		0x0060	/* - even parity */
+#define	SC2CTR_PB_ODD		0x0070	/* - odd parity */
+#define	SC2CTR_CLN		0x0080	/* character length */
+#define	SC2CTR_CLN_7BIT		0x0000	/* - 7 bit chars */
+#define	SC2CTR_CLN_8BIT		0x0080	/* - 8 bit chars */
+#define	SC2CTR_TWE		0x0100	/* transmit wait enable (enable XCTS control) */
+#define	SC2CTR_OD		0x0200	/* bit order select */
+#define	SC2CTR_OD_LSBFIRST	0x0000	/* - LSB first */
+#define	SC2CTR_OD_MSBFIRST	0x0200	/* - MSB first */
+#define	SC2CTR_TWS		0x1000	/* transmit wait select */
+#define	SC2CTR_TWS_XCTS_HIGH	0x0000	/* - interrupt TX when XCTS high */
+#define	SC2CTR_TWS_XCTS_LOW	0x1000	/* - interrupt TX when XCTS low */
+#define	SC2CTR_BKE		0x2000	/* break transmit enable */
+#define	SC2CTR_RXE		0x4000	/* receive enable */
+#define	SC2CTR_TXE		0x8000	/* transmit enable */
+
+#define	SC2ICR			__SYSREG(0xd4002024,u8)		/* interrupt control reg */
+#define SC2ICR_TD		0x20	/* transmit DMA trigger cause */
+#define SC2ICR_TI		0x10	/* transmit interrupt cause */
+#define SC2ICR_RES		0x04	/* receive error select */
+#define SC2ICR_RI		0x01	/* receive interrupt cause */
+
+#define	SC2TXB			__SYSREG(0xd4002018,u8)		/* transmit buffer reg */
+#define	SC2RXB			__SYSREG(0xd4002019,u8)		/* receive buffer reg */
+#define	SC2STR			__SYSREG(0xd400201c,u8)		/* status reg */
+#define SC2STR_OEF		0x0001	/* overrun error found */
+#define SC2STR_PEF		0x0002	/* parity error found */
+#define SC2STR_FEF		0x0004	/* framing error found */
+#define SC2STR_CTS		0x0008	/* XCTS input pin status (0 means high) */
+#define SC2STR_RBF		0x0010	/* receive buffer status */
+#define SC2STR_TBF		0x0020	/* transmit buffer status */
+#define SC2STR_RXF		0x0040	/* receive status */
+#define SC2STR_TXF		0x0080	/* transmit status */
+
+#define	SC2TIM			__SYSREG(0xd400202d,u8)		/* status reg */
+
+#define SC2RXIRQ		24	/* serial 2 Receive IRQ */
+#define SC2TXIRQ		25	/* serial 2 Transmit IRQ */
+
+#define	SC2RXICR		GxICR(SC2RXIRQ)	/* serial 2 receive intr ctrl reg */
+#define	SC2TXICR		GxICR(SC2TXIRQ)	/* serial 2 transmit intr ctrl reg */
+
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_SERIAL_REGS_H */
diff -puN /dev/null include/asm-mn10300/setup.h
--- /dev/null
+++ a/include/asm-mn10300/setup.h
@@ -0,0 +1,17 @@
+/* MN10300 Setup declarations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SETUP_H
+#define _ASM_SETUP_H
+
+extern void __init unit_setup(void);
+extern void __init unit_init_IRQ(void);
+
+#endif /* _ASM_SETUP_H */
diff -puN /dev/null include/asm-mn10300/shmbuf.h
--- /dev/null
+++ a/include/asm-mn10300/shmbuf.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_SHMBUF_H
+#define _ASM_SHMBUF_H
+
+/*
+ * The shmid64_ds structure for MN10300 architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct shmid64_ds {
+	struct ipc64_perm	shm_perm;	/* operation perms */
+	size_t			shm_segsz;	/* size of segment (bytes) */
+	__kernel_time_t		shm_atime;	/* last attach time */
+	unsigned long		__unused1;
+	__kernel_time_t		shm_dtime;	/* last detach time */
+	unsigned long		__unused2;
+	__kernel_time_t		shm_ctime;	/* last change time */
+	unsigned long		__unused3;
+	__kernel_pid_t		shm_cpid;	/* pid of creator */
+	__kernel_pid_t		shm_lpid;	/* pid of last operator */
+	unsigned long		shm_nattch;	/* no. of current attaches */
+	unsigned long		__unused4;
+	unsigned long		__unused5;
+};
+
+struct shminfo64 {
+	unsigned long	shmmax;
+	unsigned long	shmmin;
+	unsigned long	shmmni;
+	unsigned long	shmseg;
+	unsigned long	shmall;
+	unsigned long	__unused1;
+	unsigned long	__unused2;
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+#endif /* _ASM_SHMBUF_H */
diff -puN /dev/null include/asm-mn10300/shmparam.h
--- /dev/null
+++ a/include/asm-mn10300/shmparam.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SHMPARAM_H
+#define _ASM_SHMPARAM_H
+
+#define	SHMLBA PAGE_SIZE		 /* attach addr a multiple of this */
+
+#endif /* _ASM_SHMPARAM_H */
diff -puN /dev/null include/asm-mn10300/sigcontext.h
--- /dev/null
+++ a/include/asm-mn10300/sigcontext.h
@@ -0,0 +1,52 @@
+/* MN10300 Userspace signal context
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SIGCONTEXT_H
+#define _ASM_SIGCONTEXT_H
+
+struct fpucontext {
+	/* Regular FPU environment */
+	unsigned long	fs[32];		/* fpu registers */
+	unsigned long	fpcr;		/* fpu control register */
+};
+
+struct sigcontext {
+	unsigned long	d0;
+	unsigned long	d1;
+	unsigned long	d2;
+	unsigned long	d3;
+	unsigned long	a0;
+	unsigned long	a1;
+	unsigned long	a2;
+	unsigned long	a3;
+	unsigned long	e0;
+	unsigned long	e1;
+	unsigned long	e2;
+	unsigned long	e3;
+	unsigned long	e4;
+	unsigned long	e5;
+	unsigned long	e6;
+	unsigned long	e7;
+	unsigned long	lar;
+	unsigned long	lir;
+	unsigned long	mdr;
+	unsigned long	mcvf;
+	unsigned long	mcrl;
+	unsigned long	mcrh;
+	unsigned long	mdrq;
+	unsigned long	sp;
+	unsigned long	epsw;
+	unsigned long	pc;
+	struct fpucontext *fpucontext;
+	unsigned long	oldmask;
+};
+
+
+#endif /* _ASM_SIGCONTEXT_H */
diff -puN /dev/null include/asm-mn10300/siginfo.h
--- /dev/null
+++ a/include/asm-mn10300/siginfo.h
@@ -0,0 +1 @@
+#include <asm-generic/siginfo.h>
diff -puN /dev/null include/asm-mn10300/signal.h
--- /dev/null
+++ a/include/asm-mn10300/signal.h
@@ -0,0 +1,171 @@
+/* MN10300 Signal definitions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SIGNAL_H
+#define _ASM_SIGNAL_H
+
+#include <linux/types.h>
+
+/* Avoid too many header ordering problems.  */
+struct siginfo;
+
+#ifdef __KERNEL__
+/* Most things should be clean enough to redefine this at will, if care
+   is taken to make libc match.  */
+
+#define _NSIG		64
+#define _NSIG_BPW	32
+#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
+
+typedef unsigned long old_sigset_t;		/* at least 32 bits */
+
+typedef struct {
+	unsigned long sig[_NSIG_WORDS];
+} sigset_t;
+
+#else
+/* Here we must cater to libcs that poke about in kernel headers.  */
+
+#define NSIG		32
+typedef unsigned long sigset_t;
+
+#endif /* __KERNEL__ */
+
+#define SIGHUP		 1
+#define SIGINT		 2
+#define SIGQUIT		 3
+#define SIGILL		 4
+#define SIGTRAP		 5
+#define SIGABRT		 6
+#define SIGIOT		 6
+#define SIGBUS		 7
+#define SIGFPE		 8
+#define SIGKILL		 9
+#define SIGUSR1		10
+#define SIGSEGV		11
+#define SIGUSR2		12
+#define SIGPIPE		13
+#define SIGALRM		14
+#define SIGTERM		15
+#define SIGSTKFLT	16
+#define SIGCHLD		17
+#define SIGCONT		18
+#define SIGSTOP		19
+#define SIGTSTP		20
+#define SIGTTIN		21
+#define SIGTTOU		22
+#define SIGURG		23
+#define SIGXCPU		24
+#define SIGXFSZ		25
+#define SIGVTALRM	26
+#define SIGPROF		27
+#define SIGWINCH	28
+#define SIGIO		29
+#define SIGPOLL		SIGIO
+/*
+#define SIGLOST		29
+*/
+#define SIGPWR		30
+#define SIGSYS		31
+#define	SIGUNUSED	31
+
+/* These should not be considered constants from userland.  */
+#define SIGRTMIN	32
+#define SIGRTMAX	(_NSIG-1)
+
+/*
+ * SA_FLAGS values:
+ *
+ * SA_ONSTACK indicates that a registered stack_t will be used.
+ * SA_RESTART flag to get restarting signals (which were the default long ago)
+ * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
+ * SA_RESETHAND clears the handler when the signal is delivered.
+ * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
+ * SA_NODEFER prevents the current signal from being masked in the handler.
+ *
+ * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
+ * Unix names RESETHAND and NODEFER respectively.
+ */
+#define SA_NOCLDSTOP	0x00000001U
+#define SA_NOCLDWAIT	0x00000002U
+#define SA_SIGINFO	0x00000004U
+#define SA_ONSTACK	0x08000000U
+#define SA_RESTART	0x10000000U
+#define SA_NODEFER	0x40000000U
+#define SA_RESETHAND	0x80000000U
+
+#define SA_NOMASK	SA_NODEFER
+#define SA_ONESHOT	SA_RESETHAND
+
+#define SA_RESTORER	0x04000000
+
+/*
+ * sigaltstack controls
+ */
+#define SS_ONSTACK	1
+#define SS_DISABLE	2
+
+#define MINSIGSTKSZ	2048
+#define SIGSTKSZ	8192
+
+#include <asm-generic/signal.h>
+
+#ifdef __KERNEL__
+struct old_sigaction {
+	__sighandler_t sa_handler;
+	old_sigset_t sa_mask;
+	unsigned long sa_flags;
+	__sigrestore_t sa_restorer;
+};
+
+struct sigaction {
+	__sighandler_t sa_handler;
+	unsigned long sa_flags;
+	__sigrestore_t sa_restorer;
+	sigset_t sa_mask;		/* mask last for extensibility */
+};
+
+struct k_sigaction {
+	struct sigaction sa;
+};
+#else
+/* Here we must cater to libcs that poke about in kernel headers.  */
+
+struct sigaction {
+	union {
+	  __sighandler_t _sa_handler;
+	  void (*_sa_sigaction)(int, struct siginfo *, void *);
+	} _u;
+	sigset_t sa_mask;
+	unsigned long sa_flags;
+	void (*sa_restorer)(void);
+};
+
+#define sa_handler	_u._sa_handler
+#define sa_sigaction	_u._sa_sigaction
+
+#endif /* __KERNEL__ */
+
+typedef struct sigaltstack {
+	void __user *ss_sp;
+	int ss_flags;
+	size_t ss_size;
+} stack_t;
+
+#ifdef __KERNEL__
+#include <asm/sigcontext.h>
+
+
+struct pt_regs;
+#define ptrace_signal_deliver(regs, cookie) do { } while (0)
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_SIGNAL_H */
diff -puN /dev/null include/asm-mn10300/smp.h
--- /dev/null
+++ a/include/asm-mn10300/smp.h
@@ -0,0 +1,18 @@
+/* MN10300 SMP support
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SMP_H
+#define _ASM_SMP_H
+
+#ifdef CONFIG_SMP
+#error SMP not yet supported for MN10300
+#endif
+
+#endif
diff -puN /dev/null include/asm-mn10300/socket.h
--- /dev/null
+++ a/include/asm-mn10300/socket.h
@@ -0,0 +1,55 @@
+#ifndef _ASM_SOCKET_H
+#define _ASM_SOCKET_H
+
+#include <asm/sockios.h>
+
+/* For setsockopt(2) */
+#define SOL_SOCKET	1
+
+#define SO_DEBUG	1
+#define SO_REUSEADDR	2
+#define SO_TYPE		3
+#define SO_ERROR	4
+#define SO_DONTROUTE	5
+#define SO_BROADCAST	6
+#define SO_SNDBUF	7
+#define SO_RCVBUF	8
+#define SO_SNDBUFFORCE	32
+#define SO_RCVBUFFORCE	33
+#define SO_KEEPALIVE	9
+#define SO_OOBINLINE	10
+#define SO_NO_CHECK	11
+#define SO_PRIORITY	12
+#define SO_LINGER	13
+#define SO_BSDCOMPAT	14
+/* To add :#define SO_REUSEPORT 15 */
+#define SO_PASSCRED	16
+#define SO_PEERCRED	17
+#define SO_RCVLOWAT	18
+#define SO_SNDLOWAT	19
+#define SO_RCVTIMEO	20
+#define SO_SNDTIMEO	21
+
+/* Security levels - as per NRL IPv6 - don't actually do anything */
+#define SO_SECURITY_AUTHENTICATION		22
+#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
+#define SO_SECURITY_ENCRYPTION_NETWORK		24
+
+#define SO_BINDTODEVICE	25
+
+/* Socket filtering */
+#define SO_ATTACH_FILTER        26
+#define SO_DETACH_FILTER        27
+
+#define SO_PEERNAME		28
+#define SO_TIMESTAMP		29
+#define SCM_TIMESTAMP		SO_TIMESTAMP
+
+#define SO_ACCEPTCONN		30
+
+#define SO_PEERSEC		31
+#define SO_PASSSEC		34
+#define SO_TIMESTAMPNS		35
+#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
+
+#endif /* _ASM_SOCKET_H */
diff -puN /dev/null include/asm-mn10300/sockios.h
--- /dev/null
+++ a/include/asm-mn10300/sockios.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_SOCKIOS_H
+#define _ASM_SOCKIOS_H
+
+/* Socket-level I/O control calls. */
+#define FIOSETOWN 	0x8901
+#define SIOCSPGRP	0x8902
+#define FIOGETOWN	0x8903
+#define SIOCGPGRP	0x8904
+#define SIOCATMARK	0x8905
+#define SIOCGSTAMP	0x8906		/* Get stamp */
+#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
+
+#endif /* _ASM_SOCKIOS_H */
diff -puN /dev/null include/asm-mn10300/spinlock.h
--- /dev/null
+++ a/include/asm-mn10300/spinlock.h
@@ -0,0 +1,16 @@
+/* MN10300 spinlock support
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SPINLOCK_H
+#define _ASM_SPINLOCK_H
+
+#error SMP spinlocks not implemented for MN10300
+
+#endif /* _ASM_SPINLOCK_H */
diff -puN /dev/null include/asm-mn10300/statfs.h
--- /dev/null
+++ a/include/asm-mn10300/statfs.h
@@ -0,0 +1 @@
+#include <asm-generic/statfs.h>
diff -puN /dev/null include/asm-mn10300/stat.h
--- /dev/null
+++ a/include/asm-mn10300/stat.h
@@ -0,0 +1,78 @@
+#ifndef _ASM_STAT_H
+#define _ASM_STAT_H
+
+struct __old_kernel_stat {
+	unsigned short st_dev;
+	unsigned short st_ino;
+	unsigned short st_mode;
+	unsigned short st_nlink;
+	unsigned short st_uid;
+	unsigned short st_gid;
+	unsigned short st_rdev;
+	unsigned long  st_size;
+	unsigned long  st_atime;
+	unsigned long  st_mtime;
+	unsigned long  st_ctime;
+};
+
+struct stat {
+	unsigned long  st_dev;
+	unsigned long  st_ino;
+	unsigned short st_mode;
+	unsigned short st_nlink;
+	unsigned short st_uid;
+	unsigned short st_gid;
+	unsigned long  st_rdev;
+	unsigned long  st_size;
+	unsigned long  st_blksize;
+	unsigned long  st_blocks;
+	unsigned long  st_atime;
+	unsigned long  st_atime_nsec;
+	unsigned long  st_mtime;
+	unsigned long  st_mtime_nsec;
+	unsigned long  st_ctime;
+	unsigned long  st_ctime_nsec;
+	unsigned long  __unused4;
+	unsigned long  __unused5;
+};
+
+/* This matches struct stat64 in glibc2.1, hence the absolutely
+ * insane amounts of padding around dev_t's.
+ */
+struct stat64 {
+	unsigned long long	st_dev;
+	unsigned char	__pad0[4];
+
+#define STAT64_HAS_BROKEN_ST_INO	1
+	unsigned long	__st_ino;
+
+	unsigned int	st_mode;
+	unsigned int	st_nlink;
+
+	unsigned long	st_uid;
+	unsigned long	st_gid;
+
+	unsigned long long	st_rdev;
+	unsigned char	__pad3[4];
+
+	long long	st_size;
+	unsigned long	st_blksize;
+
+	unsigned long	st_blocks;	/* Number 512-byte blocks allocated. */
+	unsigned long	__pad4;		/* future possible st_blocks high bits */
+
+	unsigned long	st_atime;
+	unsigned long	st_atime_nsec;
+
+	unsigned long	st_mtime;
+	unsigned int	st_mtime_nsec;
+
+	unsigned long	st_ctime;
+	unsigned long	st_ctime_nsec;
+
+	unsigned long long	st_ino;
+};
+
+#define STAT_HAVE_NSEC 1
+
+#endif /* _ASM_STAT_H */
diff -puN /dev/null include/asm-mn10300/string.h
--- /dev/null
+++ a/include/asm-mn10300/string.h
@@ -0,0 +1,32 @@
+/* MN10300 Optimised string functions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Modified by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_STRING_H
+#define _ASM_STRING_H
+
+#define __HAVE_ARCH_MEMSET
+#define __HAVE_ARCH_MEMCPY
+#define __HAVE_ARCH_MEMMOVE
+
+extern void *memset(void *dest, int ch, size_t count);
+extern void *memcpy(void *dest, const void *src, size_t count);
+extern void *memmove(void *dest, const void *src, size_t count);
+
+
+extern void __struct_cpy_bug (void);
+#define struct_cpy(x,y)                         \
+({                                              \
+        if (sizeof(*(x)) != sizeof(*(y)))       \
+                __struct_cpy_bug;               \
+        memcpy(x, y, sizeof(*(x)));             \
+})
+
+#endif /* _ASM_STRING_H */
diff -puN /dev/null include/asm-mn10300/system.h
--- /dev/null
+++ a/include/asm-mn10300/system.h
@@ -0,0 +1,231 @@
+/* MN10300 System definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SYSTEM_H
+#define _ASM_SYSTEM_H
+
+#include <asm/cpu-regs.h>
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#include <linux/kernel.h>
+
+struct task_struct;
+struct thread_struct;
+
+extern asmlinkage
+struct task_struct *__switch_to(struct thread_struct *prev, struct thread_struct *next,
+				struct task_struct *prev_task);
+
+/* context switching is now performed out-of-line in switch_to.S */
+#define switch_to(prev,next,last)					\
+do {									\
+	current->thread.wchan = (u_long) __builtin_return_address(0);	\
+	(last) = __switch_to(&(prev)->thread, &(next)->thread, (prev));	\
+	mb();								\
+	current->thread.wchan = 0;					\
+} while (0)
+
+#define arch_align_stack(x) (x)
+
+#define nop() asm volatile ("nop")
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * Force strict CPU ordering.
+ * And yes, this is required on UP too when we're talking
+ * to devices.
+ *
+ * For now, "wmb()" doesn't actually do anything, as all
+ * Intel CPU's follow what Intel calls a *Processor Order*,
+ * in which all writes are seen in the program order even
+ * outside the CPU.
+ *
+ * I expect future Intel CPU's to have a weaker ordering,
+ * but I'd also expect them to finally get their act together
+ * and add some real memory barriers if so.
+ *
+ * Some non intel clones support out of order store. wmb() ceases to be a
+ * nop for these.
+ */
+
+#define mb()	asm volatile ("": : :"memory")
+#define rmb()	mb()
+#define wmb()	asm volatile ("": : :"memory")
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#endif
+
+#define set_mb(var, value)  do { var = value;  mb(); } while (0)
+#define set_wmb(var, value) do { var = value; wmb(); } while (0)
+
+#define read_barrier_depends()	do { } while(0)
+#define smp_read_barrier_depends()	do { } while(0)
+
+/*****************************************************************************/
+/*
+ * interrupt control
+ * - "disabled": run in IM1/2
+ *   - level 0 - GDB stub
+ *   - level 1 - virtual serial DMA (if present)
+ *   - level 5 - normal interrupt priority
+ *   - level 6 - timer interrupt
+ * - "enabled":  run in IM7
+ */
+#ifdef CONFIG_MN10300_TTYSM
+#define MN10300_CLI_LEVEL	EPSW_IM_2
+#else
+#define MN10300_CLI_LEVEL	EPSW_IM_1
+#endif
+
+#define local_save_flags(x)			\
+do {						\
+	typecheck(unsigned long, x);		\
+	asm volatile(				\
+		"	mov epsw,%0	\n"	\
+		: "=d"(x)			\
+		);				\
+} while(0)
+
+#define local_irq_disable()						\
+do {									\
+	asm volatile(							\
+		"	and %0,epsw	\n"				\
+		"	or %1,epsw	\n"				\
+		"	nop		\n"				\
+		"	nop		\n"				\
+		"	nop		\n"				\
+		:							\
+		: "i"(~EPSW_IM), "i"(EPSW_IE | MN10300_CLI_LEVEL)	\
+		);							\
+} while(0)
+
+#define local_irq_save(x)			\
+do {						\
+	local_save_flags(x);			\
+	local_irq_disable();			\
+} while(0)
+
+/*
+ * we make sure local_irq_enable() doesn't cause priority inversion
+ */
+#ifndef __ASSEMBLY__
+
+extern unsigned long __mn10300_irq_enabled_epsw;
+
+#endif
+
+#define local_irq_enable()						\
+do {									\
+	unsigned long tmp;						\
+									\
+	asm volatile(							\
+		"	mov	epsw,%0		\n"			\
+		"	and	%1,%0		\n"			\
+		"	or	%2,%0		\n"			\
+		"	mov	%0,epsw		\n"			\
+		: "=&d"(tmp)						\
+		: "i"(~EPSW_IM), "r"(__mn10300_irq_enabled_epsw)	\
+		);							\
+} while(0)
+
+#define local_irq_restore(x)			\
+do {						\
+	typecheck(unsigned long, x);		\
+	asm volatile(				\
+		"	mov %0,epsw	\n"	\
+		"	nop		\n"	\
+		"	nop		\n"	\
+		"	nop		\n"	\
+		:				\
+		: "d"(x)			\
+		: "memory", "cc"		\
+		);				\
+} while(0)
+
+#define irqs_disabled()				\
+({						\
+	unsigned long flags;			\
+	local_save_flags(flags);		\
+	(flags & EPSW_IM) <= MN10300_CLI_LEVEL;	\
+})
+
+/* hook to save power by halting the CPU
+ * - called from the idle loop
+ * - must reenable interrupts (which takes three instruction cycles to complete)
+ */
+#define safe_halt()							\
+do {									\
+	asm volatile("	or	%0,epsw	\n"				\
+		     "	nop		\n"				\
+		     "	nop		\n"				\
+		     "	bset	%2,(%1)	\n"				\
+		     :							\
+		     : "i"(EPSW_IE|EPSW_IM), "n"(&CPUM), "i"(CPUM_SLEEP)\
+		     : "cc"						\
+		     );							\
+} while(0)
+
+#define STI	or EPSW_IE|EPSW_IM,epsw
+#define CLI	and ~EPSW_IM,epsw; or EPSW_IE|MN10300_CLI_LEVEL,epsw; nop; nop; nop
+
+/*****************************************************************************/
+/*
+ * MN10300 doesn't actually have an exchange instruction
+ */
+#ifndef __ASSEMBLY__
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((struct __xchg_dummy *)(x))
+
+static inline unsigned long __xchg(volatile unsigned long *m, unsigned long val)
+{
+        unsigned long retval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+        retval = *m;
+        *m = val;
+        local_irq_restore(flags);
+        return retval;
+}
+
+#define xchg(ptr, v) ((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr), (unsigned long)(v)))
+
+static inline unsigned long __cmpxchg(volatile unsigned long *m,
+				      unsigned long old, unsigned long new)
+{
+        unsigned long retval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+        retval = *m;
+	if (retval == old)
+		*m = new;
+        local_irq_restore(flags);
+        return retval;
+}
+
+#define cmpxchg(ptr, o, n) \
+((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), (unsigned long)(o), (unsigned long)(n)))
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_SYSTEM_H */
diff -puN /dev/null include/asm-mn10300/termbits.h
--- /dev/null
+++ a/include/asm-mn10300/termbits.h
@@ -0,0 +1,200 @@
+#ifndef _ASM_TERMBITS_H
+#define _ASM_TERMBITS_H
+
+#include <linux/posix_types.h>
+
+typedef unsigned char	cc_t;
+typedef unsigned int	speed_t;
+typedef unsigned int	tcflag_t;
+
+#define NCCS 19
+struct termios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+};
+
+struct termios2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
+/* c_cc characters */
+#define VINTR 0
+#define VQUIT 1
+#define VERASE 2
+#define VKILL 3
+#define VEOF 4
+#define VTIME 5
+#define VMIN 6
+#define VSWTC 7
+#define VSTART 8
+#define VSTOP 9
+#define VSUSP 10
+#define VEOL 11
+#define VREPRINT 12
+#define VDISCARD 13
+#define VWERASE 14
+#define VLNEXT 15
+#define VEOL2 16
+
+
+/* c_iflag bits */
+#define IGNBRK	0000001
+#define BRKINT	0000002
+#define IGNPAR	0000004
+#define PARMRK	0000010
+#define INPCK	0000020
+#define ISTRIP	0000040
+#define INLCR	0000100
+#define IGNCR	0000200
+#define ICRNL	0000400
+#define IUCLC	0001000
+#define IXON	0002000
+#define IXANY	0004000
+#define IXOFF	0010000
+#define IMAXBEL	0020000
+#define IUTF8	0040000
+
+/* c_oflag bits */
+#define OPOST	0000001
+#define OLCUC	0000002
+#define ONLCR	0000004
+#define OCRNL	0000010
+#define ONOCR	0000020
+#define ONLRET	0000040
+#define OFILL	0000100
+#define OFDEL	0000200
+#define NLDLY	0000400
+#define   NL0	0000000
+#define   NL1	0000400
+#define CRDLY	0003000
+#define   CR0	0000000
+#define   CR1	0001000
+#define   CR2	0002000
+#define   CR3	0003000
+#define TABDLY	0014000
+#define   TAB0	0000000
+#define   TAB1	0004000
+#define   TAB2	0010000
+#define   TAB3	0014000
+#define   XTABS	0014000
+#define BSDLY	0020000
+#define   BS0	0000000
+#define   BS1	0020000
+#define VTDLY	0040000
+#define   VT0	0000000
+#define   VT1	0040000
+#define FFDLY	0100000
+#define   FF0	0000000
+#define   FF1	0100000
+
+/* c_cflag bit meaning */
+#define CBAUD	0010017
+#define  B0	0000000		/* hang up */
+#define  B50	0000001
+#define  B75	0000002
+#define  B110	0000003
+#define  B134	0000004
+#define  B150	0000005
+#define  B200	0000006
+#define  B300	0000007
+#define  B600	0000010
+#define  B1200	0000011
+#define  B1800	0000012
+#define  B2400	0000013
+#define  B4800	0000014
+#define  B9600	0000015
+#define  B19200	0000016
+#define  B38400	0000017
+#define EXTA B19200
+#define EXTB B38400
+#define CSIZE	0000060
+#define   CS5	0000000
+#define   CS6	0000020
+#define   CS7	0000040
+#define   CS8	0000060
+#define CSTOPB	0000100
+#define CREAD	0000200
+#define PARENB	0000400
+#define PARODD	0001000
+#define HUPCL	0002000
+#define CLOCAL	0004000
+#define CBAUDEX 0010000
+#define   BOTHER  0010000
+#define    B57600 0010001
+#define   B115200 0010002
+#define   B230400 0010003
+#define   B460800 0010004
+#define   B500000 0010005
+#define   B576000 0010006
+#define   B921600 0010007
+#define  B1000000 0010010
+#define  B1152000 0010011
+#define  B1500000 0010012
+#define  B2000000 0010013
+#define  B2500000 0010014
+#define  B3000000 0010015
+#define  B3500000 0010016
+#define  B4000000 0010017
+#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CTVB	  004000000000		/* VisioBraille Terminal flow control */
+#define CMSPAR	  010000000000		/* mark or space (stick) parity */
+#define CRTSCTS	  020000000000		/* flow control */
+
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
+/* c_lflag bits */
+#define ISIG	0000001
+#define ICANON	0000002
+#define XCASE	0000004
+#define ECHO	0000010
+#define ECHOE	0000020
+#define ECHOK	0000040
+#define ECHONL	0000100
+#define NOFLSH	0000200
+#define TOSTOP	0000400
+#define ECHOCTL	0001000
+#define ECHOPRT	0002000
+#define ECHOKE	0004000
+#define FLUSHO	0010000
+#define PENDIN	0040000
+#define IEXTEN	0100000
+
+/* tcflow() and TCXONC use these */
+#define	TCOOFF		0
+#define	TCOON		1
+#define	TCIOFF		2
+#define	TCION		3
+
+/* tcflush() and TCFLSH use these */
+#define	TCIFLUSH	0
+#define	TCOFLUSH	1
+#define	TCIOFLUSH	2
+
+/* tcsetattr uses these */
+#define	TCSANOW		0
+#define	TCSADRAIN	1
+#define	TCSAFLUSH	2
+
+#endif /* _ASM_TERMBITS_H */
diff -puN /dev/null include/asm-mn10300/termios.h
--- /dev/null
+++ a/include/asm-mn10300/termios.h
@@ -0,0 +1,88 @@
+#ifndef _ASM_TERMIOS_H
+#define _ASM_TERMIOS_H
+
+#include <asm/termbits.h>
+#include <asm/ioctls.h>
+
+struct winsize {
+	unsigned short ws_row;
+	unsigned short ws_col;
+	unsigned short ws_xpixel;
+	unsigned short ws_ypixel;
+};
+
+#define NCC 8
+struct termio {
+	unsigned short c_iflag;		/* input mode flags */
+	unsigned short c_oflag;		/* output mode flags */
+	unsigned short c_cflag;		/* control mode flags */
+	unsigned short c_lflag;		/* local mode flags */
+	unsigned char c_line;		/* line discipline */
+	unsigned char c_cc[NCC];	/* control characters */
+};
+
+#ifdef __KERNEL__
+/*	intr=^C		quit=^|		erase=del	kill=^U
+	eof=^D		vtime=\0	vmin=\1		sxtc=\0
+	start=^Q	stop=^S		susp=^Z		eol=\0
+	reprint=^R	discard=^U	werase=^W	lnext=^V
+	eol2=\0
+*/
+#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
+#endif
+
+/* modem lines */
+#define TIOCM_LE	0x001
+#define TIOCM_DTR	0x002
+#define TIOCM_RTS	0x004
+#define TIOCM_ST	0x008
+#define TIOCM_SR	0x010
+#define TIOCM_CTS	0x020
+#define TIOCM_CAR	0x040
+#define TIOCM_RNG	0x080
+#define TIOCM_DSR	0x100
+#define TIOCM_CD	TIOCM_CAR
+#define TIOCM_RI	TIOCM_RNG
+#define TIOCM_OUT1	0x2000
+#define TIOCM_OUT2	0x4000
+#define TIOCM_LOOP	0x8000
+
+#define TIOCM_MODEM_BITS       TIOCM_OUT2      /* IRDA support */
+
+/*
+ * Translate a "termio" structure into a "termios". Ugh.
+ */
+#define SET_LOW_TERMIOS_BITS(termios, termio, x) { \
+	unsigned short __tmp; \
+	get_user(__tmp,&(termio)->x); \
+	*(unsigned short *) &(termios)->x = __tmp; \
+}
+
+#define user_termio_to_kernel_termios(termios, termio) \
+({ \
+	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag); \
+	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag); \
+	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag); \
+	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag); \
+	copy_from_user((termios)->c_cc, (termio)->c_cc, NCC); \
+})
+
+/*
+ * Translate a "termios" structure into a "termio". Ugh.
+ */
+#define kernel_termios_to_user_termio(termio, termios) \
+({ \
+	put_user((termios)->c_iflag, &(termio)->c_iflag); \
+	put_user((termios)->c_oflag, &(termio)->c_oflag); \
+	put_user((termios)->c_cflag, &(termio)->c_cflag); \
+	put_user((termios)->c_lflag, &(termio)->c_lflag); \
+	put_user((termios)->c_line,  &(termio)->c_line); \
+	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
+})
+
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
+
+#endif	/* _ASM_TERMIOS_H */
diff -puN /dev/null include/asm-mn10300/thread_info.h
--- /dev/null
+++ a/include/asm-mn10300/thread_info.h
@@ -0,0 +1,166 @@
+/* MN10300 Low-level thread information
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_THREAD_INFO_H
+#define _ASM_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#include <asm/page.h>
+
+#ifndef __ASSEMBLY__
+#include <asm/processor.h>
+#endif
+
+#define PREEMPT_ACTIVE		0x10000000
+
+#ifdef CONFIG_4KSTACKS
+#define THREAD_SIZE		(4096)
+#else
+#define THREAD_SIZE		(8192)
+#endif
+
+#define STACK_WARN		(THREAD_SIZE / 8)
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly constants must also be changed
+ */
+#ifndef __ASSEMBLY__
+
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	unsigned long		flags;		/* low level flags */
+	__u32			cpu;		/* current CPU */
+	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
+
+	mm_segment_t		addr_limit;	/* thread address space:
+					 	   0-0xBFFFFFFF for user-thead
+						   0-0xFFFFFFFF for kernel-thread
+						*/
+	struct restart_block    restart_block;
+
+	__u8			supervisor_stack[0];
+};
+
+#else /* !__ASSEMBLY__ */
+
+#ifndef __ASM_OFFSETS_H__
+#include <asm/asm-offsets.h>
+#endif
+
+#endif
+
+/*
+ * macros/functions for gaining access to the thread information structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
+#ifndef __ASSEMBLY__
+
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= 1,			\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block = {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+#define init_uregs \
+	((struct pt_regs *) \
+		((unsigned long) init_stack + THREAD_SIZE - sizeof(struct pt_regs)))
+
+extern struct thread_info *__current_ti;
+
+/* how to get the thread information struct from C */
+static inline struct thread_info *current_thread_info(void) __attribute__((const));
+static inline struct thread_info *current_thread_info(void)
+{
+	struct thread_info *ti;
+	asm("mov sp,%0\n"
+	    "and %1,%0\n"
+	    : "=d" (ti)
+	    : "i" (~(THREAD_SIZE - 1))
+	    : "cc");
+	return ti;
+}
+
+/* how to get the current stack pointer from C */
+static inline unsigned long current_stack_pointer(void)
+{
+	unsigned long sp;
+	asm("mov sp,%0; ":"=r" (sp));
+	return sp;
+}
+
+/* thread information allocation */
+#ifdef CONFIG_DEBUG_STACK_USAGE
+#define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
+#else
+#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#endif
+
+#define free_thread_info(ti)	kfree((ti))
+#define get_thread_info(ti)	get_task_struct((ti)->task)
+#define put_thread_info(ti)	put_task_struct((ti)->task)
+
+#else /* !__ASSEMBLY__ */
+
+#ifndef __VMLINUX_LDS__
+/* how to get the thread information struct from ASM */
+	.macro GET_THREAD_INFO reg
+	mov	sp,\reg
+	and	-THREAD_SIZE,\reg
+	.endm
+#endif
+#endif
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files may need to access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
+#define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_MEMDIE		17	/* OOM killer killed process */
+#define TIF_FREEZE		18	/* freezing for suspend */
+
+#define _TIF_SYSCALL_TRACE	+(1<<TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	+(1<<TIF_NOTIFY_RESUME)
+#define _TIF_SIGPENDING		+(1<<TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	+(1<<TIF_NEED_RESCHED)
+#define _TIF_SINGLESTEP		+(1<<TIF_SINGLESTEP)
+#define _TIF_RESTORE_SIGMASK	+(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_POLLING_NRFLAG	+(1<<TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		+(1 << TIF_FREEZE)
+
+#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
+#define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_THREAD_INFO_H */
diff -puN /dev/null include/asm-mn10300/timer-regs.h
--- /dev/null
+++ a/include/asm-mn10300/timer-regs.h
@@ -0,0 +1,293 @@
+/* AM33v2 on-board timer module registers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_TIMER_REGS_H
+#define _ASM_TIMER_REGS_H
+
+#include <asm/cpu-regs.h>
+#include <asm/intctl-regs.h>
+
+#ifdef __KERNEL__
+
+/* timer prescalar control */
+#define	TMPSCNT			__SYSREG(0xd4003071,u8)	/* timer prescaler control */
+#define	TMPSCNT_ENABLE		0x80	/* timer prescaler enable */
+#define	TMPSCNT_DISABLE		0x00	/* timer prescaler disable */
+
+/* 8 bit timers */
+#define	TM0MD			__SYSREG(0xd4003000,u8)	/* timer 0 mode register */
+#define	TM0MD_SRC		0x07	/* timer source */
+#define	TM0MD_SRC_IOCLK		0x00	/* - IOCLK */
+#define	TM0MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM0MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM0MD_SRC_TM2IO		0x03	/* - TM2IO pin input */
+#define	TM0MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM0MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM0MD_SRC_TM0IO		0x07	/* - TM0IO pin input */
+#define	TM0MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM0MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM1MD			__SYSREG(0xd4003001,u8)	/* timer 1 mode register */
+#define	TM1MD_SRC		0x07	/* timer source */
+#define	TM1MD_SRC_IOCLK		0x00	/* - IOCLK */
+#define	TM1MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM1MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM1MD_SRC_TM0CASCADE	0x03	/* - cascade with timer 0 */
+#define	TM1MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM1MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM1MD_SRC_TM1IO		0x07	/* - TM1IO pin input */
+#define	TM1MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM1MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM2MD			__SYSREG(0xd4003002,u8)	/* timer 2 mode register */
+#define	TM2MD_SRC		0x07	/* timer source */
+#define	TM2MD_SRC_IOCLK		0x00	/* - IOCLK */
+#define	TM2MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM2MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM2MD_SRC_TM1CASCADE	0x03	/* - cascade with timer 1 */
+#define	TM2MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM2MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM2MD_SRC_TM2IO		0x07	/* - TM2IO pin input */
+#define	TM2MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM2MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM3MD			__SYSREG(0xd4003003,u8)	/* timer 3 mode register */
+#define	TM3MD_SRC		0x07	/* timer source */
+#define	TM3MD_SRC_IOCLK		0x00	/* - IOCLK */
+#define	TM3MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM3MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM3MD_SRC_TM1CASCADE	0x03	/* - cascade with timer 2 */
+#define	TM3MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM3MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM3MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM3MD_SRC_TM3IO		0x07	/* - TM3IO pin input */
+#define	TM3MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM3MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM01MD			__SYSREG(0xd4003000,u16)	/* timer 0:1 mode register */
+
+#define	TM0BR			__SYSREG(0xd4003010,u8)		/* timer 0 base register */
+#define	TM1BR			__SYSREG(0xd4003011,u8)		/* timer 1 base register */
+#define	TM2BR			__SYSREG(0xd4003012,u8)		/* timer 2 base register */
+#define	TM3BR			__SYSREG(0xd4003013,u8)		/* timer 3 base register */
+#define	TM01BR			__SYSREG(0xd4003010,u16)	/* timer 0:1 base register */
+
+#define	TM0BC			__SYSREGC(0xd4003020,u8)	/* timer 0 binary counter */
+#define	TM1BC			__SYSREGC(0xd4003021,u8)	/* timer 1 binary counter */
+#define	TM2BC			__SYSREGC(0xd4003022,u8)	/* timer 2 binary counter */
+#define	TM3BC			__SYSREGC(0xd4003023,u8)	/* timer 3 binary counter */
+#define	TM01BC			__SYSREGC(0xd4003020,u16)	/* timer 0:1 binary counter */
+
+#define TM0IRQ			2	/* timer 0 IRQ */
+#define TM1IRQ			3	/* timer 1 IRQ */
+#define TM2IRQ			4	/* timer 2 IRQ */
+#define TM3IRQ			5	/* timer 3 IRQ */
+
+#define	TM0ICR			GxICR(TM0IRQ)	/* timer 0 uflow intr ctrl reg */
+#define	TM1ICR			GxICR(TM1IRQ)	/* timer 1 uflow intr ctrl reg */
+#define	TM2ICR			GxICR(TM2IRQ)	/* timer 2 uflow intr ctrl reg */
+#define	TM3ICR			GxICR(TM3IRQ)	/* timer 3 uflow intr ctrl reg */
+
+/* 16-bit timers 4,5 & 7-11 */
+#define	TM4MD			__SYSREG(0xd4003080,u8)	/* timer 4 mode register */
+#define	TM4MD_SRC		0x07	/* timer source */
+#define	TM4MD_SRC_IOCLK		0x00	/* - IOCLK */
+#define	TM4MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM4MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM4MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM4MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM4MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM4MD_SRC_TM4IO		0x07	/* - TM4IO pin input */
+#define	TM4MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM4MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM5MD			__SYSREG(0xd4003082,u8)	/* timer 5 mode register */
+#define	TM5MD_SRC		0x07	/* timer source */
+#define	TM5MD_SRC_IOCLK		0x00	/* - IOCLK */
+#define	TM5MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM5MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM5MD_SRC_TM4CASCADE	0x03	/* - cascade with timer 4 */
+#define	TM5MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM5MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM5MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM5MD_SRC_TM5IO		0x07	/* - TM5IO pin input */
+#define	TM5MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM5MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM7MD			__SYSREG(0xd4003086,u8)	/* timer 7 mode register */
+#define	TM7MD_SRC		0x07	/* timer source */
+#define	TM7MD_SRC_IOCLK		0x00	/* - IOCLK */
+#define	TM7MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM7MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM7MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM7MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM7MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM7MD_SRC_TM7IO		0x07	/* - TM7IO pin input */
+#define	TM7MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM7MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM8MD			__SYSREG(0xd4003088,u8)	/* timer 8 mode register */
+#define	TM8MD_SRC		0x07	/* timer source */
+#define	TM8MD_SRC_IOCLK		0x00	/* - IOCLK */
+#define	TM8MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM8MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM8MD_SRC_TM7CASCADE	0x03	/* - cascade with timer 7 */
+#define	TM8MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM8MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM8MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM8MD_SRC_TM8IO		0x07	/* - TM8IO pin input */
+#define	TM8MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM8MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM9MD			__SYSREG(0xd400308a,u8)	/* timer 9 mode register */
+#define	TM9MD_SRC		0x07	/* timer source */
+#define	TM9MD_SRC_IOCLK		0x00	/* - IOCLK */
+#define	TM9MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM9MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM9MD_SRC_TM8CASCADE	0x03	/* - cascade with timer 8 */
+#define	TM9MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM9MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM9MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM9MD_SRC_TM9IO		0x07	/* - TM9IO pin input */
+#define	TM9MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM9MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM10MD			__SYSREG(0xd400308c,u8)	/* timer 10 mode register */
+#define	TM10MD_SRC		0x07	/* timer source */
+#define	TM10MD_SRC_IOCLK	0x00	/* - IOCLK */
+#define	TM10MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM10MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM10MD_SRC_TM9CASCADE	0x03	/* - cascade with timer 9 */
+#define	TM10MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM10MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM10MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM10MD_SRC_TM10IO	0x07	/* - TM10IO pin input */
+#define	TM10MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM10MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM11MD			__SYSREG(0xd400308e,u8)	/* timer 11 mode register */
+#define	TM11MD_SRC		0x07	/* timer source */
+#define	TM11MD_SRC_IOCLK	0x00	/* - IOCLK */
+#define	TM11MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM11MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM11MD_SRC_TM7CASCADE	0x03	/* - cascade with timer 7 */
+#define	TM11MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM11MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM11MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM11MD_SRC_TM11IO	0x07	/* - TM11IO pin input */
+#define	TM11MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM11MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM4BR			__SYSREG(0xd4003090,u16)	/* timer 4 base register */
+#define	TM5BR			__SYSREG(0xd4003092,u16)	/* timer 5 base register */
+#define	TM7BR			__SYSREG(0xd4003096,u16)	/* timer 7 base register */
+#define	TM8BR			__SYSREG(0xd4003098,u16)	/* timer 8 base register */
+#define	TM9BR			__SYSREG(0xd400309a,u16)	/* timer 9 base register */
+#define	TM10BR			__SYSREG(0xd400309c,u16)	/* timer 10 base register */
+#define	TM11BR			__SYSREG(0xd400309e,u16)	/* timer 11 base register */
+#define	TM45BR			__SYSREG(0xd4003090,u32)	/* timer 4:5 base register */
+
+#define	TM4BC			__SYSREG(0xd40030a0,u16)	/* timer 4 binary counter */
+#define	TM5BC			__SYSREG(0xd40030a2,u16)	/* timer 5 binary counter */
+#define	TM45BC			__SYSREG(0xd40030a0,u32)	/* timer 4:5 binary counter */
+
+#define	TM7BC			__SYSREG(0xd40030a6,u16)	/* timer 7 binary counter */
+#define	TM8BC			__SYSREG(0xd40030a8,u16)	/* timer 8 binary counter */
+#define	TM9BC			__SYSREG(0xd40030aa,u16)	/* timer 9 binary counter */
+#define	TM10BC			__SYSREG(0xd40030ac,u16)	/* timer 10 binary counter */
+#define	TM11BC			__SYSREG(0xd40030ae,u16)	/* timer 11 binary counter */
+
+#define TM4IRQ			6	/* timer 4 IRQ */
+#define TM5IRQ			7	/* timer 5 IRQ */
+#define TM7IRQ			11	/* timer 7 IRQ */
+#define TM8IRQ			12	/* timer 8 IRQ */
+#define TM9IRQ			13	/* timer 9 IRQ */
+#define TM10IRQ			14	/* timer 10 IRQ */
+#define TM11IRQ			15	/* timer 11 IRQ */
+
+#define	TM4ICR			GxICR(TM4IRQ)	/* timer 4 uflow intr ctrl reg */
+#define	TM5ICR			GxICR(TM5IRQ)	/* timer 5 uflow intr ctrl reg */
+#define	TM7ICR			GxICR(TM7IRQ)	/* timer 7 uflow intr ctrl reg */
+#define	TM8ICR			GxICR(TM8IRQ)	/* timer 8 uflow intr ctrl reg */
+#define	TM9ICR			GxICR(TM9IRQ)	/* timer 9 uflow intr ctrl reg */
+#define	TM10ICR			GxICR(TM10IRQ)	/* timer 10 uflow intr ctrl reg */
+#define	TM11ICR			GxICR(TM11IRQ)	/* timer 11 uflow intr ctrl reg */
+
+/* 16-bit timer 6 */
+#define	TM6MD			__SYSREG(0xd4003084,u16)	/* timer6 mode register */
+#define	TM6MD_SRC		0x0007	/* timer source */
+#define	TM6MD_SRC_IOCLK		0x0000	/* - IOCLK */
+#define	TM6MD_SRC_IOCLK_8	0x0001	/* - 1/8 IOCLK */
+#define	TM6MD_SRC_IOCLK_32	0x0002	/* - 1/32 IOCLK */
+#define	TM6MD_SRC_TM0UFLOW	0x0004	/* - timer 0 underflow */
+#define	TM6MD_SRC_TM1UFLOW	0x0005	/* - timer 1 underflow */
+#define	TM6MD_SRC_TM6IOB_BOTH	0x0006	/* - TM6IOB pin input (both edges) */
+#define	TM6MD_SRC_TM6IOB_SINGLE	0x0007	/* - TM6IOB pin input (single edge) */
+#define	TM6MD_CLR_ENABLE	0x0010	/* clear count enable */
+#define	TM6MD_ONESHOT_ENABLE	0x0040	/* oneshot count */
+#define	TM6MD_TRIG_ENABLE	0x0080	/* TM6IOB pin trigger enable */
+#define TM6MD_PWM		0x3800	/* PWM output mode */
+#define TM6MD_PWM_DIS		0x0000	/* - disabled */
+#define	TM6MD_PWM_10BIT		0x1000	/* - 10 bits mode */
+#define	TM6MD_PWM_11BIT		0x1800	/* - 11 bits mode */
+#define	TM6MD_PWM_12BIT		0x3000	/* - 12 bits mode */
+#define	TM6MD_PWM_14BIT		0x3800	/* - 14 bits mode */
+#define	TM6MD_INIT_COUNTER	0x4000	/* initialize TMnBC to zero */
+#define	TM6MD_COUNT_ENABLE	0x8000	/* timer count enable */
+
+#define	TM6MDA			__SYSREG(0xd40030b4,u8)	/* timer6 cmp/cap A mode reg */
+#define TM6MDA_OUT		0x07	/* output select */
+#define	TM6MDA_OUT_SETA_RESETB	0x00	/* - set at match A, reset at match B */
+#define	TM6MDA_OUT_SETA_RESETOV	0x01	/* - set at match A, reset at overflow */
+#define	TM6MDA_OUT_SETA		0x02	/* - set at match A */
+#define	TM6MDA_OUT_RESETA	0x03	/* - reset at match A */
+#define	TM6MDA_OUT_TOGGLE	0x04	/* - toggle on match A */
+#define TM6MDA_MODE		0xc0	/* compare A register mode */
+#define	TM6MDA_MODE_CMP_SINGLE	0x00	/* - compare, single buffer mode */
+#define	TM6MDA_MODE_CMP_DOUBLE	0x40	/* - compare, double buffer mode */
+#define	TM6MDA_MODE_CAP_S_EDGE	0x80	/* - capture, single edge mode */
+#define	TM6MDA_MODE_CAP_D_EDGE	0xc0	/* - capture, double edge mode */
+#define TM6MDA_EDGE		0x20	/* compare A edge select */
+#define	TM6MDA_EDGE_FALLING	0x00	/* capture on falling edge */
+#define	TM6MDA_EDGE_RISING	0x20	/* capture on rising edge */
+#define	TM6MDA_CAPTURE_ENABLE	0x10	/* capture enable */
+
+#define	TM6MDB			__SYSREG(0xd40030b5,u8)	/* timer6 cmp/cap B mode reg */
+#define TM6MDB_OUT		0x07	/* output select */
+#define	TM6MDB_OUT_SETB_RESETA	0x00	/* - set at match B, reset at match A */
+#define	TM6MDB_OUT_SETB_RESETOV	0x01	/* - set at match B */
+#define	TM6MDB_OUT_RESETB	0x03	/* - reset at match B */
+#define	TM6MDB_OUT_TOGGLE	0x04	/* - toggle on match B */
+#define TM6MDB_MODE		0xc0	/* compare B register mode */
+#define	TM6MDB_MODE_CMP_SINGLE	0x00	/* - compare, single buffer mode */
+#define	TM6MDB_MODE_CMP_DOUBLE	0x40	/* - compare, double buffer mode */
+#define	TM6MDB_MODE_CAP_S_EDGE	0x80	/* - capture, single edge mode */
+#define	TM6MDB_MODE_CAP_D_EDGE	0xc0	/* - capture, double edge mode */
+#define TM6MDB_EDGE		0x20	/* compare B edge select */
+#define	TM6MDB_EDGE_FALLING	0x00	/* capture on falling edge */
+#define	TM6MDB_EDGE_RISING	0x20	/* capture on rising edge */
+#define	TM6MDB_CAPTURE_ENABLE	0x10	/* capture enable */
+
+#define	TM6CA			__SYSREG(0xd40030c4,u16)	/* timer6 cmp/capture reg A */
+#define	TM6CB			__SYSREG(0xd40030d4,u16)	/* timer6 cmp/capture reg B */
+#define	TM6BC			__SYSREG(0xd40030a4,u16)	/* timer6 binary counter */
+
+#define TM6IRQ			6	/* timer 6 IRQ */
+#define TM6AIRQ			9	/* timer 6A IRQ */
+#define TM6BIRQ			10	/* timer 6B IRQ */
+
+#define	TM6ICR			GxICR(TM6IRQ)	/* timer 6 uflow intr ctrl reg */
+#define	TM6AICR			GxICR(TM6AIRQ)	/* timer 6A intr control reg */
+#define	TM6BICR			GxICR(TM6BIRQ)	/* timer 6B intr control reg */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_TIMER_REGS_H */
diff -puN /dev/null include/asm-mn10300/timex.h
--- /dev/null
+++ a/include/asm-mn10300/timex.h
@@ -0,0 +1,33 @@
+/* MN10300 Architecture time management specifications
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_TIMEX_H
+#define _ASM_TIMEX_H
+
+#include <asm/hardirq.h>
+#include <asm/unit/timex.h>
+
+#define TICK_SIZE (tick_nsec / 1000)
+
+#define CLOCK_TICK_RATE 1193180 /* Underlying HZ - this should probably be set
+				 * to something appropriate, but what? */
+
+extern cycles_t cacheflush_time;
+
+#ifdef __KERNEL__
+
+static inline cycles_t get_cycles(void)
+{
+	return read_timestamp_counter();
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_TIMEX_H */
diff -puN /dev/null include/asm-mn10300/tlbflush.h
--- /dev/null
+++ a/include/asm-mn10300/tlbflush.h
@@ -0,0 +1,80 @@
+/* MN10300 TLB flushing functions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_TLBFLUSH_H
+#define _ASM_TLBFLUSH_H
+
+#include <asm/processor.h>
+
+#define __flush_tlb()						\
+do {								\
+	int w;							\
+	__asm__ __volatile__					\
+		("	mov %1,%0		\n"		\
+		 "	or %2,%0		\n"		\
+		 "	mov %0,%1		\n"		\
+		 : "=d"(w)					\
+		 : "m"(MMUCTR), "i"(MMUCTR_IIV|MMUCTR_DIV)	\
+		 : "memory"					\
+		 );						\
+} while (0)
+
+#define __flush_tlb_all() __flush_tlb()
+#define __flush_tlb_one(addr) __flush_tlb()
+
+
+/*
+ * TLB flushing:
+ *
+ *  - flush_tlb() flushes the current mm struct TLBs
+ *  - flush_tlb_all() flushes all processes TLBs
+ *  - flush_tlb_mm(mm) flushes the specified mm context TLB's
+ *  - flush_tlb_page(vma, vmaddr) flushes one page
+ *  - flush_tlb_range(mm, start, end) flushes a range of pages
+ *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
+ */
+#define flush_tlb_all()				\
+do {						\
+	preempt_disable();			\
+	__flush_tlb_all();			\
+	preempt_enable();			\
+} while(0)
+
+#define flush_tlb_mm(mm)			\
+do {						\
+	preempt_disable();			\
+	__flush_tlb_all();			\
+	preempt_enable();			\
+} while(0)
+
+#define flush_tlb_range(vma, start, end)			\
+do {								\
+	unsigned long __s __attribute__((unused)) = (start);	\
+	unsigned long __e __attribute__((unused)) = (end);	\
+	preempt_disable();					\
+	__flush_tlb_all();					\
+	preempt_enable();					\
+} while(0)
+
+
+#define __flush_tlb_global()			flush_tlb_all()
+#define flush_tlb()				flush_tlb_all()
+#define flush_tlb_kernel_range(start, end)			\
+do {								\
+	unsigned long __s __attribute__((unused)) = (start);	\
+	unsigned long __e __attribute__((unused)) = (end);	\
+	flush_tlb_all();					\
+} while (0)
+
+extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr);
+
+#define flush_tlb_pgtables(mm, start, end)	do {} while(0)
+
+#endif /* _ASM_TLBFLUSH_H */
diff -puN /dev/null include/asm-mn10300/tlb.h
--- /dev/null
+++ a/include/asm-mn10300/tlb.h
@@ -0,0 +1,34 @@
+/* MN10300 TLB definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_TLB_H
+#define _ASM_TLB_H
+
+#include <asm/tlbflush.h>
+
+extern void check_pgt_cache(void);
+
+/*
+ * we don't need any special per-pte or per-vma handling...
+ */
+#define tlb_start_vma(tlb, vma)				do { } while (0)
+#define tlb_end_vma(tlb, vma)				do { } while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address)	do { } while (0)
+
+/*
+ * .. because we flush the whole mm when it fills up
+ */
+#define tlb_flush(tlb)	flush_tlb_mm((tlb)->mm)
+
+/* for now, just use the generic stuff */
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_TLB_H */
diff -puN /dev/null include/asm-mn10300/topology.h
--- /dev/null
+++ a/include/asm-mn10300/topology.h
@@ -0,0 +1 @@
+#include <asm-generic/topology.h>
diff -puN /dev/null include/asm-mn10300/types.h
--- /dev/null
+++ a/include/asm-mn10300/types.h
@@ -0,0 +1,67 @@
+/* MN10300 Basic type definitions
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_TYPES_H
+#define _ASM_TYPES_H
+
+#ifndef __ASSEMBLY__
+
+typedef unsigned short umode_t;
+
+/*
+ * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
+ * header files exported to user space
+ */
+
+typedef __signed__ char __s8;
+typedef unsigned char __u8;
+
+typedef __signed__ short __s16;
+typedef unsigned short __u16;
+
+typedef __signed__ int __s32;
+typedef unsigned int __u32;
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
+typedef __signed__ long long __s64;
+typedef unsigned long long __u64;
+#endif
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * These aren't exported outside the kernel to avoid name space clashes
+ */
+#ifdef __KERNEL__
+
+#define BITS_PER_LONG 32
+
+#ifndef __ASSEMBLY__
+
+typedef signed char s8;
+typedef unsigned char u8;
+
+typedef signed short s16;
+typedef unsigned short u16;
+
+typedef signed int s32;
+typedef unsigned int u32;
+
+typedef signed long long s64;
+typedef unsigned long long u64;
+
+/* Dma addresses are 32-bits wide.  */
+typedef u32 dma_addr_t;
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_TYPES_H */
diff -puN /dev/null include/asm-mn10300/uaccess.h
--- /dev/null
+++ a/include/asm-mn10300/uaccess.h
@@ -0,0 +1,483 @@
+/* MN10300 userspace access functions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UACCESS_H
+#define _ASM_UACCESS_H
+
+/*
+ * User space memory access functions
+ */
+#include <linux/sched.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/errno.h>
+
+#define VERIFY_READ 0
+#define VERIFY_WRITE 1
+
+/*
+ * The fs value determines whether argument validity checking should be
+ * performed or not.  If get_fs() == USER_DS, checking is performed, with
+ * get_fs() == KERNEL_DS, checking is bypassed.
+ *
+ * For historical reasons, these macros are grossly misnamed.
+ */
+
+#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
+
+#define KERNEL_XDS	MAKE_MM_SEG(0xBFFFFFFF)
+#define KERNEL_DS	MAKE_MM_SEG(0x9FFFFFFF)
+#define USER_DS		MAKE_MM_SEG(TASK_SIZE)
+
+#define get_ds()	(KERNEL_DS)
+#define get_fs()	(current_thread_info()->addr_limit)
+#define set_fs(x)	(current_thread_info()->addr_limit = (x))
+#define __kernel_ds_p() (current_thread_info()->addr_limit.seg == 0x9FFFFFFF)
+
+#define segment_eq(a, b) ((a).seg == (b).seg)
+
+#define __addr_ok(addr) \
+	((unsigned long)(addr) < (current_thread_info()->addr_limit.seg))
+
+/*
+ * check that a range of addresses falls within the current address limit
+ */
+static inline int ___range_ok(unsigned long addr, unsigned int size)
+{
+	int flag = 1, tmp;
+
+	asm (
+		"	add	%3,%1		\n"	/* set C-flag if addr+size>4Gb */
+		"	bcs	0f		\n"
+		"	cmp	%4,%1		\n"	/* jump if addr+size>limit (error) */
+		"	bhi	0f		\n"
+		"	clr	%0		\n"	/* mark okay */
+		"0:				\n"
+		: "=r"(flag), "=&r"(tmp)
+		: "1"(addr), "ir"(size),
+		  "r"(current_thread_info()->addr_limit.seg), "0"(flag)
+		: "cc"
+	     );
+
+	return flag;
+}
+
+#define __range_ok(addr, size) ___range_ok((unsigned long)(addr), (u32)(size))
+
+#define access_ok(type, addr, size) (__range_ok((addr), (size)) == 0)
+#define __access_ok(addr, size)     (__range_ok((addr), (size)) == 0)
+
+static inline int verify_area(int type, const void *addr, unsigned long size)
+{
+	return access_ok(type,addr,size) ? 0 : -EFAULT;
+}
+
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+
+struct exception_table_entry
+{
+	unsigned long insn, fixup;
+};
+
+/* Returns 0 if exception not found and fixup otherwise.  */
+extern int fixup_exception(struct pt_regs *regs);
+
+#define put_user(x, ptr) __put_user_check((x), (ptr), sizeof(*(ptr)))
+#define get_user(x, ptr) __get_user_check((x), (ptr), sizeof(*(ptr)))
+
+/*
+ * The "__xxx" versions do not do address space checking, useful when
+ * doing multiple accesses to the same area (the user has to do the
+ * checks by hand with "access_ok()")
+ */
+#define __put_user(x, ptr) __put_user_nocheck((x), (ptr), sizeof(*(ptr)))
+#define __get_user(x, ptr) __get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
+/*
+ * The "xxx_ret" versions return constant specified in third argument, if
+ * something bad happens. These macros can be optimized for the
+ * case of just returning from the function xxx_ret is used.
+ */
+
+#define put_user_ret(x, ptr, ret) \
+	({ if (put_user((x),(ptr)))	return (ret); })
+#define get_user_ret(x, ptr, ret) \
+	({ if (get_user((x),(ptr)))	return (ret); })
+#define __put_user_ret(x, ptr, ret) \
+	({ if (__put_user((x),(ptr)))	return (ret); })
+#define __get_user_ret(x, ptr, ret) \
+	({ if (__get_user((x),(ptr)))	return (ret); })
+
+struct __large_struct { unsigned long buf[100]; };
+#define __m(x) (*(struct __large_struct *)(x))
+
+#define __get_user_nocheck(x, ptr, size)	\
+({						\
+	__typeof(*(ptr)) __gu_val;		\
+	unsigned long __gu_addr;		\
+	int __gu_err;				\
+	__gu_addr = (unsigned long) (ptr);	\
+	switch (size) {				\
+	case 1:  __get_user_asm("bu"); break;	\
+	case 2:  __get_user_asm("hu"); break;	\
+	case 4:  __get_user_asm(""  ); break;	\
+	default: __get_user_unknown(); break;	\
+	}					\
+	x = (__typeof__(*(ptr))) __gu_val;	\
+	__gu_err;				\
+})
+
+#define __get_user_check(x, ptr, size)			\
+({							\
+	__typeof__(*(ptr)) __gu_val;			\
+	unsigned long __gu_addr;			\
+	int __gu_err;					\
+	__gu_addr = (unsigned long) (ptr);		\
+	if (likely(__access_ok(__gu_addr,size))) {	\
+		switch (size) {				\
+		case 1:  __get_user_asm("bu"); break;	\
+		case 2:  __get_user_asm("hu"); break;	\
+		case 4:  __get_user_asm(""  ); break;	\
+		default: __get_user_unknown(); break;	\
+		}					\
+	}						\
+	else {						\
+		__gu_err = -EFAULT;			\
+		__gu_val = 0;				\
+	}						\
+	x = (__typeof__(*(ptr))) __gu_val;		\
+	__gu_err;					\
+})
+
+#define __get_user_asm(INSN)					\
+({								\
+	asm volatile(					\
+		"1:\n"						\
+		"	mov"INSN"	%2,%1\n"		\
+		"	mov		0,%0\n"			\
+		"2:\n"						\
+		"	.section	.fixup,\"ax\"\n"	\
+		"3:\n\t"					\
+		"	mov		%3,%0\n"		\
+		"	jmp		2b\n"			\
+		"	.previous\n"				\
+		"	.section	__ex_table,\"a\"\n"	\
+		"	.balign		4\n"			\
+		"	.long		1b, 3b\n"		\
+		"	.previous"				\
+		: "=&r" (__gu_err), "=&r" (__gu_val)		\
+		: "m" (__m(__gu_addr)), "i" (-EFAULT));		\
+})
+
+extern int __get_user_unknown(void);
+
+#define __put_user_nocheck(x, ptr, size)			\
+({								\
+	union {							\
+		__typeof__(*(ptr)) val;				\
+		u32 bits[2];					\
+	} __pu_val;						\
+	unsigned long __pu_addr;				\
+	int __pu_err;						\
+	__pu_val.val = (x);					\
+	__pu_addr = (unsigned long) (ptr);			\
+	switch (size) {						\
+	case 1:  __put_user_asm("bu"); break;			\
+	case 2:  __put_user_asm("hu"); break;			\
+	case 4:  __put_user_asm(""  ); break;			\
+	case 8:  __put_user_asm8();    break;			\
+	default: __pu_err = __put_user_unknown(); break;	\
+	}							\
+	__pu_err;						\
+})
+
+#define __put_user_check(x, ptr, size)					\
+({									\
+	union {								\
+		__typeof__(*(ptr)) val;					\
+		u32 bits[2];						\
+	} __pu_val;							\
+	unsigned long __pu_addr;					\
+	int __pu_err;							\
+	__pu_val.val = (x);						\
+	__pu_addr = (unsigned long) (ptr);				\
+	if (likely(__access_ok(__pu_addr, size))) {			\
+		switch (size) {						\
+		case 1:  __put_user_asm("bu"); break;			\
+		case 2:  __put_user_asm("hu"); break;			\
+		case 4:  __put_user_asm(""  ); break;			\
+		case 8:  __put_user_asm8();    break;			\
+		default: __pu_err = __put_user_unknown(); break;	\
+		}							\
+	}								\
+	else {								\
+		__pu_err = -EFAULT;					\
+	}								\
+	__pu_err;							\
+})
+
+#define __put_user_asm(INSN)					\
+({								\
+	asm volatile(						\
+		"1:\n"						\
+		"	mov"INSN"	%1,%2\n"		\
+		"	mov		0,%0\n"			\
+		"2:\n"						\
+		"	.section	.fixup,\"ax\"\n"	\
+		"3:\n"						\
+		"	mov		%3,%0\n"		\
+		"	jmp		2b\n"			\
+		"	.previous\n"				\
+		"	.section	__ex_table,\"a\"\n"	\
+		"	.balign		4\n"			\
+		"	.long		1b, 3b\n"		\
+		"	.previous"				\
+		: "=&r" (__pu_err)				\
+		: "r" (__pu_val.val), "m" (__m(__pu_addr)),	\
+		  "i" (-EFAULT)					\
+		);						\
+})
+
+#define __put_user_asm8()						\
+({									\
+	asm volatile(							\
+		"1:	mov		%1,%3		\n"		\
+		"2:	mov		%2,%4		\n"		\
+		"	mov		0,%0		\n"		\
+		"3:					\n"		\
+		"	.section	.fixup,\"ax\"	\n"		\
+		"4:					\n"		\
+		"	mov		%5,%0		\n"		\
+		"	jmp		2b		\n"		\
+		"	.previous			\n"		\
+		"	.section	__ex_table,\"a\"\n"		\
+		"	.balign		4		\n"		\
+		"	.long		1b, 4b		\n"		\
+		"	.long		2b, 4b		\n"		\
+		"	.previous			\n"		\
+		: "=&r" (__pu_err)					\
+		: "r" (__pu_val.bits[0]), "r" (__pu_val.bits[1]),	\
+		  "m" (__m(__pu_addr)), "m" (__m(__pu_addr+4)),		\
+		  "i" (-EFAULT)						\
+		);							\
+})
+
+extern int __put_user_unknown(void);
+
+
+/*
+ * Copy To/From Userspace
+ */
+/* Generic arbitrary sized copy.  */
+#define __copy_user(to,from,size)					\
+do {									\
+	if (size) {							\
+		void *__to = to;					\
+		const void *__from = from;				\
+		int w;							\
+		asm volatile(						\
+			"0:     movbu	(%0),%3;\n"			\
+			"1:     movbu	%3,(%1);\n"			\
+			"	inc	%0;\n"				\
+			"	inc	%1;\n"				\
+			"       add	-1,%2;\n"			\
+			"       bne	0b;\n"				\
+			"2:\n"						\
+			"	.section .fixup,\"ax\"\n"		\
+			"3:	jmp	2b\n"				\
+			"	.previous\n"				\
+			"	.section __ex_table,\"a\"\n"		\
+			"       .balign	4\n"				\
+			"       .long	0b,3b\n"			\
+			"       .long	1b,3b\n"			\
+			"	.previous\n"				\
+			: "=a"(__from), "=a"(__to),"=r"(size), "=&r"(w)	\
+			: "0"(__from), "1"(__to), "2"(size)		\
+			: "memory");					\
+	}								\
+} while (0)
+
+#define __copy_user_zeroing(to,from,size)				\
+do {									\
+	if (size) {							\
+		void *__to = to;					\
+		const void *__from = from;				\
+		int w;							\
+		asm volatile(						\
+			"0:     movbu	(%0),%3;\n"			\
+			"1:     movbu	%3,(%1);\n"			\
+			"	inc	%0;\n"				\
+			"	inc	%1;\n"				\
+			"       add	-1,%2;\n"			\
+			"       bne	0b;\n"				\
+			"2:\n"						\
+			"	.section .fixup,\"ax\"\n"		\
+			"3:\n"						\
+			"	mov	%2,%0\n"			\
+			"	clr	%3\n"				\
+			"4:     movbu	%3,(%1);\n"			\
+			"	inc	%1;\n"				\
+			"       add	-1,%2;\n"			\
+			"       bne	4b;\n"				\
+			"	mov	%0,%2\n"			\
+			"	jmp	2b\n"				\
+			"	.previous\n"				\
+			"	.section __ex_table,\"a\"\n"		\
+			"       .balign	4\n"				\
+			"       .long	0b,3b\n"			\
+			"       .long	1b,3b\n"			\
+			"	.previous\n"				\
+			: "=a"(__from), "=a"(__to),"=r"(size), "=&r"(w)	\
+			: "0"(__from), "1"(__to), "2"(size)		\
+			: "memory");					\
+	}								\
+} while (0)
+
+/* We let the __ versions of copy_from/to_user inline, because they're often
+ * used in fast paths and have only a small space overhead.
+ */
+static inline
+unsigned long __generic_copy_from_user_nocheck(void *to, const void *from, unsigned long n)
+{
+	__copy_user_zeroing(to, from, n);
+	return n;
+}
+
+static inline
+unsigned long __generic_copy_to_user_nocheck(void *to, const void *from, unsigned long n)
+{
+	__copy_user(to, from, n);
+	return n;
+}
+
+
+#if 0
+#error don't use - these macros don't increment to & from pointers
+/* Optimize just a little bit when we know the size of the move. */
+#define __constant_copy_user(to, from, size)	\
+do {						\
+        asm volatile(				\
+                "       mov %0,a0;\n"		\
+                "0:     movbu (%1),d3;\n"	\
+                "1:     movbu d3,(%2);\n"	\
+                "       add -1,a0;\n"		\
+                "       bne 0b;\n"		\
+		"2:;"				\
+		".section .fixup,\"ax\"\n"	\
+		"3:	jmp 2b\n"		\
+                ".previous\n"			\
+                ".section __ex_table,\"a\"\n"	\
+                "       .balign 4\n"		\
+                "       .long 0b,3b\n"		\
+                "       .long 1b,3b\n"		\
+                ".previous"			\
+		:				\
+		: "d"(size), "d"(to), "d"(from)	\
+		: "d3","a0");			\
+} while (0)
+
+/* Optimize just a little bit when we know the size of the move. */
+#define __constant_copy_user_zeroing(to, from, size)	\
+do {							\
+        asm volatile(					\
+                "       mov %0,a0;\n"			\
+                "0:     movbu (%1),d3;\n"		\
+                "1:     movbu d3,(%2);\n"		\
+                "       add -1,a0;\n"			\
+                "       bne 0b;\n"			\
+		"2:;"					\
+		".section .fixup,\"ax\"\n"		\
+		"3:	jmp 2b\n"			\
+                ".previous\n"				\
+                ".section __ex_table,\"a\"\n"		\
+                "       .balign 4\n"			\
+                "       .long 0b,3b\n"			\
+                "       .long 1b,3b\n"			\
+                ".previous"				\
+		:					\
+		: "d"(size), "d"(to), "d"(from)		\
+		: "d3","a0");				\
+} while (0)
+
+static inline
+unsigned long __constant_copy_to_user(void *to, const void *from, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		__constant_copy_user(to, from, n);
+	return n;
+}
+
+static inline
+unsigned long __constant_copy_from_user(void *to, const void *from, unsigned long n)
+{
+	if (access_ok(VERIFY_READ, from, n))
+		__constant_copy_user_zeroing(to, from, n);
+	return n;
+}
+
+static inline
+unsigned long __constant_copy_to_user_nocheck(void *to, const void *from, unsigned long n)
+{
+	__constant_copy_user(to, from, n);
+	return n;
+}
+
+static inline
+unsigned long __constant_copy_from_user_nocheck(void *to, const void *from, unsigned long n)
+{
+	__constant_copy_user_zeroing(to, from, n);
+	return n;
+}
+#endif
+
+extern unsigned long __generic_copy_to_user(void __user *, const void *, unsigned long);
+extern unsigned long __generic_copy_from_user(void *, const void __user *, unsigned long);
+
+#define __copy_to_user_inatomic(to, from, n) \
+	__generic_copy_to_user_nocheck((to),(from),(n))
+#define __copy_from_user_inatomic(to, from, n) \
+	__generic_copy_from_user_nocheck((to),(from),(n))
+
+#define __copy_to_user(to, from, n)			\
+({							\
+	might_sleep();					\
+	__copy_to_user_inatomic((to),(from),(n));	\
+})
+
+#define __copy_from_user(to, from, n)			\
+({							\
+	might_sleep();					\
+	__copy_from_user_inatomic((to),(from),(n));	\
+})
+
+
+#define copy_to_user(to, from, n)   __generic_copy_to_user((to), (from), (n))
+#define copy_from_user(to, from, n) __generic_copy_from_user((to), (from), (n))
+
+extern long strncpy_from_user(char *dst, const char __user *src, long count);
+extern long __strncpy_from_user(char *dst, const char __user *src, long count);
+extern long strnlen_user(const char __user *str, long n);
+#define strlen_user(str) strnlen_user(str, ~0UL >> 1)
+extern unsigned long clear_user(void __user *mem, unsigned long len);
+extern unsigned long __clear_user(void __user *mem, unsigned long len);
+
+#endif /* _ASM_UACCESS_H */
diff -puN /dev/null include/asm-mn10300/ucontext.h
--- /dev/null
+++ a/include/asm-mn10300/ucontext.h
@@ -0,0 +1,22 @@
+/* MN10300 User context
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UCONTEXT_H
+#define _ASM_UCONTEXT_H
+
+struct ucontext {
+	unsigned long	  uc_flags;
+	struct ucontext  *uc_link;
+	stack_t		  uc_stack;
+	struct sigcontext uc_mcontext;
+	sigset_t	  uc_sigmask;	/* mask last for extensibility */
+};
+
+#endif /* _ASM_UCONTEXT_H */
diff -puN /dev/null include/asm-mn10300/unaligned.h
--- /dev/null
+++ a/include/asm-mn10300/unaligned.h
@@ -0,0 +1,132 @@
+/* MN10300 Unaligned memory access handling
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNALIGNED_H
+#define _ASM_UNALIGNED_H
+
+#include <asm/types.h>
+
+#if 0
+extern int __bug_unaligned_x(void *ptr);
+
+/*
+ * What is the most efficient way of loading/storing an unaligned value?
+ *
+ * That is the subject of this file.  Efficiency here is defined as
+ * minimum code size with minimum register usage for the common cases.
+ * It is currently not believed that long longs are common, so we
+ * trade efficiency for the chars, shorts and longs against the long
+ * longs.
+ *
+ * Current stats with gcc 2.7.2.2 for these functions:
+ *
+ *	ptrsize	get:	code	regs	put:	code	regs
+ *	1		1	1		1	2
+ *	2		3	2		3	2
+ *	4		7	3		7	3
+ *	8		20	6		16	6
+ *
+ * gcc 2.95.1 seems to code differently:
+ *
+ *	ptrsize	get:	code	regs	put:	code	regs
+ *	1		1	1		1	2
+ *	2		3	2		3	2
+ *	4		7	4		7	4
+ *	8		19	8		15	6
+ *
+ * which may or may not be more efficient (depending upon whether
+ * you can afford the extra registers).  Hopefully the gcc 2.95
+ * is inteligent enough to decide if it is better to use the
+ * extra register, but evidence so far seems to suggest otherwise.
+ *
+ * Unfortunately, gcc is not able to optimise the high word
+ * out of long long >> 32, or the low word from long long << 32
+ */
+
+#define __get_unaligned_2(__p)					\
+	(__p[0] | __p[1] << 8)
+
+#define __get_unaligned_4(__p)					\
+	(__p[0] | __p[1] << 8 | __p[2] << 16 | __p[3] << 24)
+
+#define get_unaligned(ptr)					\
+	({							\
+		__typeof__(*(ptr)) __v;				\
+		__u8 *__p = (__u8 *)(ptr);			\
+		switch (sizeof(*(ptr))) {			\
+		case 1:	__v = *(ptr);			break;	\
+		case 2: __v = __get_unaligned_2(__p);	break;	\
+		case 4: __v = __get_unaligned_4(__p);	break;	\
+		case 8: {					\
+				unsigned int __v1, __v2;	\
+				__v2 = __get_unaligned_4((__p+4)); \
+				__v1 = __get_unaligned_4(__p);	\
+				__v = ((unsigned long long)__v2 << 32 | __v1);	\
+			}					\
+			break;					\
+		default: __v = __bug_unaligned_x(__p);	break;	\
+		}						\
+		__v;						\
+	})
+
+
+static inline void __put_unaligned_2(__u32 __v, register __u8 *__p)
+{
+	*__p++ = __v;
+	*__p++ = __v >> 8;
+}
+
+static inline void __put_unaligned_4(__u32 __v, register __u8 *__p)
+{
+	__put_unaligned_2(__v >> 16, __p + 2);
+	__put_unaligned_2(__v, __p);
+}
+
+static inline void __put_unaligned_8(const unsigned long long __v, register __u8 *__p)
+{
+	/*
+	 * tradeoff: 8 bytes of stack for all unaligned puts (2
+	 * instructions), or an extra register in the long long
+	 * case - go for the extra register.
+	 */
+	__put_unaligned_4(__v >> 32, __p+4);
+	__put_unaligned_4(__v, __p);
+}
+
+/*
+ * Try to store an unaligned value as efficiently as possible.
+ */
+#define put_unaligned(val,ptr)					\
+	({							\
+		switch (sizeof(*(ptr))) {			\
+		case 1:						\
+			*(ptr) = (val);				\
+			break;					\
+		case 2: __put_unaligned_2((val),(__u8 *)(ptr));	\
+			break;					\
+		case 4:	__put_unaligned_4((val),(__u8 *)(ptr));	\
+			break;					\
+		case 8:	__put_unaligned_8((val),(__u8 *)(ptr)); \
+			break;					\
+		default: __bug_unaligned_x(ptr);		\
+			break;					\
+		}						\
+		(void) 0;					\
+	})
+
+
+#else
+
+#define get_unaligned(ptr) (*(ptr))
+#define put_unaligned(val,ptr) ({ *(ptr) = (val); (void) 0; })
+
+#endif
+
+#endif
diff -puN /dev/null include/asm-mn10300/unistd.h
--- /dev/null
+++ a/include/asm-mn10300/unistd.h
@@ -0,0 +1,382 @@
+/* MN10300 System call number list
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNISTD_H
+#define _ASM_UNISTD_H
+
+#define __NR_restart_syscall      0
+#define __NR_exit		  1
+#define __NR_fork		  2
+#define __NR_read		  3
+#define __NR_write		  4
+#define __NR_open		  5
+#define __NR_close		  6
+#define __NR_waitpid		  7
+#define __NR_creat		  8
+#define __NR_link		  9
+#define __NR_unlink		 10
+#define __NR_execve		 11
+#define __NR_chdir		 12
+#define __NR_time		 13
+#define __NR_mknod		 14
+#define __NR_chmod		 15
+#define __NR_lchown		 16
+#define __NR_break		 17
+#define __NR_oldstat		 18
+#define __NR_lseek		 19
+#define __NR_getpid		 20
+#define __NR_mount		 21
+#define __NR_umount		 22
+#define __NR_setuid		 23
+#define __NR_getuid		 24
+#define __NR_stime		 25
+#define __NR_ptrace		 26
+#define __NR_alarm		 27
+#define __NR_oldfstat		 28
+#define __NR_pause		 29
+#define __NR_utime		 30
+#define __NR_stty		 31
+#define __NR_gtty		 32
+#define __NR_access		 33
+#define __NR_nice		 34
+#define __NR_ftime		 35
+#define __NR_sync		 36
+#define __NR_kill		 37
+#define __NR_rename		 38
+#define __NR_mkdir		 39
+#define __NR_rmdir		 40
+#define __NR_dup		 41
+#define __NR_pipe		 42
+#define __NR_times		 43
+#define __NR_prof		 44
+#define __NR_brk		 45
+#define __NR_setgid		 46
+#define __NR_getgid		 47
+#define __NR_signal		 48
+#define __NR_geteuid		 49
+#define __NR_getegid		 50
+#define __NR_acct		 51
+#define __NR_umount2		 52
+#define __NR_lock		 53
+#define __NR_ioctl		 54
+#define __NR_fcntl		 55
+#define __NR_mpx		 56
+#define __NR_setpgid		 57
+#define __NR_ulimit		 58
+#define __NR_oldolduname	 59
+#define __NR_umask		 60
+#define __NR_chroot		 61
+#define __NR_ustat		 62
+#define __NR_dup2		 63
+#define __NR_getppid		 64
+#define __NR_getpgrp		 65
+#define __NR_setsid		 66
+#define __NR_sigaction		 67
+#define __NR_sgetmask		 68
+#define __NR_ssetmask		 69
+#define __NR_setreuid		 70
+#define __NR_setregid		 71
+#define __NR_sigsuspend		 72
+#define __NR_sigpending		 73
+#define __NR_sethostname	 74
+#define __NR_setrlimit		 75
+#define __NR_getrlimit		 76	/* Back compatible 2Gig limited rlimit */
+#define __NR_getrusage		 77
+#define __NR_gettimeofday	 78
+#define __NR_settimeofday	 79
+#define __NR_getgroups		 80
+#define __NR_setgroups		 81
+#define __NR_select		 82
+#define __NR_symlink		 83
+#define __NR_oldlstat		 84
+#define __NR_readlink		 85
+#define __NR_uselib		 86
+#define __NR_swapon		 87
+#define __NR_reboot		 88
+#define __NR_readdir		 89
+#define __NR_mmap		 90
+#define __NR_munmap		 91
+#define __NR_truncate		 92
+#define __NR_ftruncate		 93
+#define __NR_fchmod		 94
+#define __NR_fchown		 95
+#define __NR_getpriority	 96
+#define __NR_setpriority	 97
+#define __NR_profil		 98
+#define __NR_statfs		 99
+#define __NR_fstatfs		100
+#define __NR_ioperm		101
+#define __NR_socketcall		102
+#define __NR_syslog		103
+#define __NR_setitimer		104
+#define __NR_getitimer		105
+#define __NR_stat		106
+#define __NR_lstat		107
+#define __NR_fstat		108
+#define __NR_olduname		109
+#define __NR_iopl		110
+#define __NR_vhangup		111
+#define __NR_idle		112
+#define __NR_vm86old		113
+#define __NR_wait4		114
+#define __NR_swapoff		115
+#define __NR_sysinfo		116
+#define __NR_ipc		117
+#define __NR_fsync		118
+#define __NR_sigreturn		119
+#define __NR_clone		120
+#define __NR_setdomainname	121
+#define __NR_uname		122
+#define __NR_modify_ldt		123
+#define __NR_adjtimex		124
+#define __NR_mprotect		125
+#define __NR_sigprocmask	126
+#define __NR_create_module	127
+#define __NR_init_module	128
+#define __NR_delete_module	129
+#define __NR_get_kernel_syms	130
+#define __NR_quotactl		131
+#define __NR_getpgid		132
+#define __NR_fchdir		133
+#define __NR_bdflush		134
+#define __NR_sysfs		135
+#define __NR_personality	136
+#define __NR_afs_syscall	137 /* Syscall for Andrew File System */
+#define __NR_setfsuid		138
+#define __NR_setfsgid		139
+#define __NR__llseek		140
+#define __NR_getdents		141
+#define __NR__newselect		142
+#define __NR_flock		143
+#define __NR_msync		144
+#define __NR_readv		145
+#define __NR_writev		146
+#define __NR_getsid		147
+#define __NR_fdatasync		148
+#define __NR__sysctl		149
+#define __NR_mlock		150
+#define __NR_munlock		151
+#define __NR_mlockall		152
+#define __NR_munlockall		153
+#define __NR_sched_setparam		154
+#define __NR_sched_getparam		155
+#define __NR_sched_setscheduler		156
+#define __NR_sched_getscheduler		157
+#define __NR_sched_yield		158
+#define __NR_sched_get_priority_max	159
+#define __NR_sched_get_priority_min	160
+#define __NR_sched_rr_get_interval	161
+#define __NR_nanosleep		162
+#define __NR_mremap		163
+#define __NR_setresuid		164
+#define __NR_getresuid		165
+#define __NR_vm86		166
+#define __NR_query_module	167
+#define __NR_poll		168
+#define __NR_nfsservctl		169
+#define __NR_setresgid		170
+#define __NR_getresgid		171
+#define __NR_prctl              172
+#define __NR_rt_sigreturn	173
+#define __NR_rt_sigaction	174
+#define __NR_rt_sigprocmask	175
+#define __NR_rt_sigpending	176
+#define __NR_rt_sigtimedwait	177
+#define __NR_rt_sigqueueinfo	178
+#define __NR_rt_sigsuspend	179
+#define __NR_pread64		180
+#define __NR_pwrite64		181
+#define __NR_chown		182
+#define __NR_getcwd		183
+#define __NR_capget		184
+#define __NR_capset		185
+#define __NR_sigaltstack	186
+#define __NR_sendfile		187
+#define __NR_getpmsg		188	/* some people actually want streams */
+#define __NR_putpmsg		189	/* some people actually want streams */
+#define __NR_vfork		190
+#define __NR_ugetrlimit		191	/* SuS compliant getrlimit */
+#define __NR_mmap2		192
+#define __NR_truncate64		193
+#define __NR_ftruncate64	194
+#define __NR_stat64		195
+#define __NR_lstat64		196
+#define __NR_fstat64		197
+#define __NR_lchown32		198
+#define __NR_getuid32		199
+#define __NR_getgid32		200
+#define __NR_geteuid32		201
+#define __NR_getegid32		202
+#define __NR_setreuid32		203
+#define __NR_setregid32		204
+#define __NR_getgroups32	205
+#define __NR_setgroups32	206
+#define __NR_fchown32		207
+#define __NR_setresuid32	208
+#define __NR_getresuid32	209
+#define __NR_setresgid32	210
+#define __NR_getresgid32	211
+#define __NR_chown32		212
+#define __NR_setuid32		213
+#define __NR_setgid32		214
+#define __NR_setfsuid32		215
+#define __NR_setfsgid32		216
+#define __NR_pivot_root		217
+#define __NR_mincore		218
+#define __NR_madvise		219
+#define __NR_madvise1		219	/* delete when C lib stub is removed */
+#define __NR_getdents64		220
+#define __NR_fcntl64		221
+/* 223 is unused */
+#define __NR_gettid		224
+#define __NR_readahead		225
+#define __NR_setxattr		226
+#define __NR_lsetxattr		227
+#define __NR_fsetxattr		228
+#define __NR_getxattr		229
+#define __NR_lgetxattr		230
+#define __NR_fgetxattr		231
+#define __NR_listxattr		232
+#define __NR_llistxattr		233
+#define __NR_flistxattr		234
+#define __NR_removexattr	235
+#define __NR_lremovexattr	236
+#define __NR_fremovexattr	237
+#define __NR_tkill		238
+#define __NR_sendfile64		239
+#define __NR_futex		240
+#define __NR_sched_setaffinity	241
+#define __NR_sched_getaffinity	242
+#define __NR_set_thread_area	243
+#define __NR_get_thread_area	244
+#define __NR_io_setup		245
+#define __NR_io_destroy		246
+#define __NR_io_getevents	247
+#define __NR_io_submit		248
+#define __NR_io_cancel		249
+#define __NR_fadvise64		250
+
+#define __NR_exit_group		252
+#define __NR_lookup_dcookie	253
+#define __NR_epoll_create	254
+#define __NR_epoll_ctl		255
+#define __NR_epoll_wait		256
+#define __NR_remap_file_pages	257
+#define __NR_set_tid_address	258
+#define __NR_timer_create	259
+#define __NR_timer_settime	(__NR_timer_create+1)
+#define __NR_timer_gettime	(__NR_timer_create+2)
+#define __NR_timer_getoverrun	(__NR_timer_create+3)
+#define __NR_timer_delete	(__NR_timer_create+4)
+#define __NR_clock_settime	(__NR_timer_create+5)
+#define __NR_clock_gettime	(__NR_timer_create+6)
+#define __NR_clock_getres	(__NR_timer_create+7)
+#define __NR_clock_nanosleep	(__NR_timer_create+8)
+#define __NR_statfs64		268
+#define __NR_fstatfs64		269
+#define __NR_tgkill		270
+#define __NR_utimes		271
+#define __NR_fadvise64_64	272
+#define __NR_vserver		273
+#define __NR_mbind		274
+#define __NR_get_mempolicy	275
+#define __NR_set_mempolicy	276
+#define __NR_mq_open 		277
+#define __NR_mq_unlink		(__NR_mq_open+1)
+#define __NR_mq_timedsend	(__NR_mq_open+2)
+#define __NR_mq_timedreceive	(__NR_mq_open+3)
+#define __NR_mq_notify		(__NR_mq_open+4)
+#define __NR_mq_getsetattr	(__NR_mq_open+5)
+#define __NR_kexec_load		283
+#define __NR_waitid		284
+#define __NR_add_key		286
+#define __NR_request_key	287
+#define __NR_keyctl		288
+#define __NR_cacheflush		289
+#define __NR_ioprio_set		290
+#define __NR_ioprio_get		291
+#define __NR_inotify_init	292
+#define __NR_inotify_add_watch	293
+#define __NR_inotify_rm_watch	294
+#define __NR_migrate_pages	295
+#define __NR_openat		296
+#define __NR_mkdirat		297
+#define __NR_mknodat		298
+#define __NR_fchownat		299
+#define __NR_futimesat		300
+#define __NR_fstatat64		301
+#define __NR_unlinkat		302
+#define __NR_renameat		303
+#define __NR_linkat		304
+#define __NR_symlinkat		305
+#define __NR_readlinkat		306
+#define __NR_fchmodat		307
+#define __NR_faccessat		308
+#define __NR_pselect6		309
+#define __NR_ppoll		310
+#define __NR_unshare		311
+#define __NR_set_robust_list	312
+#define __NR_get_robust_list	313
+#define __NR_splice		314
+#define __NR_sync_file_range	315
+#define __NR_tee		316
+#define __NR_vmsplice		317
+#define __NR_move_pages		318
+#define __NR_getcpu		319
+#define __NR_epoll_pwait	320
+#define __NR_utimensat		321
+#define __NR_signalfd		322
+#define __NR_timerfd		323
+#define __NR_eventfd		324
+#define __NR_fallocate		325
+
+#ifdef __KERNEL__
+
+#define NR_syscalls 326
+
+/*
+ * specify the deprecated syscalls we want to support on this arch
+ */
+#define __ARCH_WANT_IPC_PARSE_VERSION
+#define __ARCH_WANT_OLD_READDIR
+#define __ARCH_WANT_OLD_STAT
+#define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYS_ALARM
+#define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_PAUSE
+#define __ARCH_WANT_SYS_SGETMASK
+#define __ARCH_WANT_SYS_SIGNAL
+#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_WAITPID
+#define __ARCH_WANT_SYS_SOCKETCALL
+#define __ARCH_WANT_SYS_FADVISE64
+#define __ARCH_WANT_SYS_GETPGRP
+#define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_SYS_NICE
+#define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLDUMOUNT
+#define __ARCH_WANT_SYS_SIGPENDING
+#define __ARCH_WANT_SYS_SIGPROCMASK
+#define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
+
+/*
+ * "Conditional" syscalls
+ *
+ * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
+ * but it doesn't work on all toolchains, so we just do it by hand
+ */
+#ifndef cond_syscall
+#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall");
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_UNISTD_H */
diff -puN /dev/null include/asm-mn10300/unit-asb2303/clock.h
--- /dev/null
+++ a/include/asm-mn10300/unit-asb2303/clock.h
@@ -0,0 +1,45 @@
+/* ASB2303-specific clocks
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_CLOCK_H
+#define _ASM_UNIT_CLOCK_H
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_MN10300_RTC
+
+extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
+extern unsigned long mn10300_iobclk;
+extern unsigned long mn10300_tsc_per_HZ;
+
+#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
+/* If this processors has a another clock, uncomment the below. */
+//#define MN10300_IOBCLK	((unsigned long)mn10300_iobclk)
+
+#else /* !CONFIG_MN10300_RTC */
+
+#define MN10300_IOCLK		33333333UL
+//#define MN10300_IOBCLK	66666666UL
+
+#endif /* !CONFIG_MN10300_RTC */
+
+#define MN10300_JCCLK		MN10300_IOCLK
+#define MN10300_TSCCLK		MN10300_IOCLK
+
+#ifdef CONFIG_MN10300_RTC
+#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
+#else /* !CONFIG_MN10300_RTC */
+#define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
+#endif /* !CONFIG_MN10300_RTC */
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_CLOCK_H */
diff -puN /dev/null include/asm-mn10300/unit-asb2303/leds.h
--- /dev/null
+++ a/include/asm-mn10300/unit-asb2303/leds.h
@@ -0,0 +1,43 @@
+/* ASB2303-specific LEDs
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_LEDS_H
+#define _ASM_UNIT_LEDS_H
+
+#include <asm/pio-regs.h>
+#include <asm/cpu-regs.h>
+#include <asm/exceptions.h>
+
+#define ASB2303_GPIO0DEF	__SYSREG(0xDB000000,u32)
+#define ASB2303_7SEGLEDS	__SYSREG(0xDB000008,u32)
+
+/*
+ * use the 7-segment LEDs to indicate states
+ */
+
+/* flip the 7-segment LEDs between "G" and "-" */
+#define mn10300_set_gdbleds(ONOFF)			\
+do {							\
+	ASB2303_7SEGLEDS = (ONOFF) ? 0x85 : 0x7f;	\
+} while(0)
+
+/* indicate double-fault by displaying "d" on the LEDs */
+#define mn10300_set_dbfleds			\
+	mov	0x43,d0			;	\
+	movbu	d0,(ASB2303_7SEGLEDS)
+
+#ifndef __ASSEMBLY__
+extern void peripheral_leds_display_exception(exception_code_t code);
+extern void peripheral_leds_led_chase(void);
+extern void debug_to_serial(const char *p, int n);
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_LEDS_H */
diff -puN /dev/null include/asm-mn10300/unit-asb2303/serial.h
--- /dev/null
+++ a/include/asm-mn10300/unit-asb2303/serial.h
@@ -0,0 +1,124 @@
+/* ASB2303-specific 8250 serial ports
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_SERIAL_H
+#define _ASM_UNIT_SERIAL_H
+
+#include <asm/cpu-regs.h>
+#include <asm/proc/irq.h>
+#include <linux/serial_reg.h>
+
+#define SERIAL_PORT0_BASE_ADDRESS	0xA6FB0000
+#define SERIAL_PORT1_BASE_ADDRESS	0xA6FC0000
+
+#define SERIAL_IRQ	XIRQ0	/* Dual serial (PC16552)	(Hi) */
+
+/*
+ * dispose of the /dev/ttyS0 and /dev/ttyS1 serial ports
+ */
+#ifndef CONFIG_GDBSTUB_ON_TTYSx
+
+#define SERIAL_PORT_DFNS						\
+	{								\
+	baud_base:		BASE_BAUD,				\
+	irq:			SERIAL_IRQ,				\
+	flags:			STD_COM_FLAGS,				\
+	iomem_base:		(u8 *) SERIAL_PORT0_BASE_ADDRESS,	\
+	iomem_reg_shift:	2,					\
+	io_type:		SERIAL_IO_MEM,				\
+	},								\
+	{								\
+	baud_base:		BASE_BAUD,				\
+	irq:			SERIAL_IRQ,				\
+	flags:			STD_COM_FLAGS,				\
+	iomem_base:		(u8 *) SERIAL_PORT1_BASE_ADDRESS,	\
+	iomem_reg_shift:	2,					\
+	io_type:		SERIAL_IO_MEM,				\
+	},
+
+#ifndef __ASSEMBLY__
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#else /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#define SERIAL_PORT_DFNS /* both stolen by gdb-stub because they share an IRQ */
+
+#if defined(CONFIG_GDBSTUB_ON_TTYS0)
+#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 4, u8)
+#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
+#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 4, u8)
+#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 4, u8)
+#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 4, u8)
+#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 4, u8)
+#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 4, u8)
+#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 4, u8)
+#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
+#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
+#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
+#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 4, u8)
+#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
+
+#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
+#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_RX  * 4, u8)
+#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_TX  * 4, u8)
+#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_DLL * 4, u8)
+#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_DLM * 4, u8)
+#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_IER * 4, u8)
+#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_IIR * 4, u8)
+#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_FCR * 4, u8)
+#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_LCR * 4, u8)
+#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_MCR * 4, u8)
+#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_LSR * 4, u8)
+#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_MSR * 4, u8)
+#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_SCR * 4, u8)
+#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
+#endif
+
+#ifndef __ASSEMBLY__
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+	char ch;
+
+#define LSR_WAIT_FOR(STATE)	do { while (!(GDBPORT_SERIAL_LSR & UART_LSR_##STATE)) {;} } while(0)
+#define FLOWCTL_QUERY(LINE)	({ GDBPORT_SERIAL_MSR & UART_MSR_##LINE; })
+#define FLOWCTL_WAIT_FOR(LINE)	do { while (!(GDBPORT_SERIAL_MSR & UART_MSR_##LINE)) {;} } while(0)
+#define FLOWCTL_CLEAR(LINE)	do { GDBPORT_SERIAL_MCR &= ~UART_MCR_##LINE; } while (0)
+#define FLOWCTL_SET(LINE)	do { GDBPORT_SERIAL_MCR |= UART_MCR_##LINE; } while (0)
+
+	FLOWCTL_SET(DTR);
+
+	for (; n > 0; n--) {
+		LSR_WAIT_FOR(THRE);
+		FLOWCTL_WAIT_FOR(CTS);
+
+		ch = *p++;
+		if (ch == 0x0a) {
+			GDBPORT_SERIAL_TX = 0x0d;
+			LSR_WAIT_FOR(THRE);
+			FLOWCTL_WAIT_FOR(CTS);
+		}
+		GDBPORT_SERIAL_TX = ch;
+	}
+
+	FLOWCTL_CLEAR(DTR);
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#endif /* _ASM_UNIT_SERIAL_H */
diff -puN /dev/null include/asm-mn10300/unit-asb2303/smc91111.h
--- /dev/null
+++ a/include/asm-mn10300/unit-asb2303/smc91111.h
@@ -0,0 +1,50 @@
+/* Support for the SMC91C111 NIC on an ASB2303
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNIT_SMC91111_H
+#define _ASM_UNIT_SMC91111_H
+
+#include <asm/intctl-regs.h>
+
+#define SMC91111_BASE		0xAA000300UL
+#define SMC91111_BASE_END	0xAA000400UL
+#define SMC91111_IRQ		XIRQ3
+
+#define SMC_CAN_USE_8BIT	0
+#define SMC_CAN_USE_16BIT	1
+#define SMC_CAN_USE_32BIT	0
+#define SMC_NOWAIT		1
+#define SMC_IRQ_FLAGS		(0)
+
+#if SMC_CAN_USE_8BIT
+#define SMC_inb(a, r)		inb((unsigned long) ((a) + (r)))
+#define SMC_outb(v, a, r)	outb(v, (unsigned long) ((a) + (r)))
+#endif
+
+#if SMC_CAN_USE_16BIT
+#define SMC_inw(a, r)		inw((unsigned long) ((a) + (r)))
+#define SMC_outw(v, a, r)	outw(v, (unsigned long) ((a) + (r)))
+#define SMC_insw(a, r, p, l)	insw((unsigned long) ((a) + (r)), (p), (l))
+#define SMC_outsw(a, r, p, l)	outsw((unsigned long) ((a) + (r)), (p), (l))
+#endif
+
+#if SMC_CAN_USE_32BIT
+#define SMC_inl(a, r)		inl((unsigned long) ((a) + (r)))
+#define SMC_outl(v, a, r)	outl(v, (unsigned long) ((a) + (r)))
+#define SMC_insl(a, r, p, l)	insl((unsigned long) ((a) + (r)), (p), (l))
+#define SMC_outsl(a, r, p, l)	outsl((unsigned long) ((a) + (r)), (p), (l))
+#endif
+
+#define RPC_LSA_DEFAULT		RPC_LED_100_10
+#define RPC_LSB_DEFAULT		RPC_LED_TX_RX
+
+#define set_irq_type(irq, type)
+
+#endif /*  _ASM_UNIT_SMC91111_H */
diff -puN /dev/null include/asm-mn10300/unit-asb2303/timex.h
--- /dev/null
+++ a/include/asm-mn10300/unit-asb2303/timex.h
@@ -0,0 +1,135 @@
+/* ASB2303-specific timer specifcations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNIT_TIMEX_H
+#define _ASM_UNIT_TIMEX_H
+
+#ifndef __ASSEMBLY__
+#include <linux/irq.h>
+#endif /* __ASSEMBLY__ */
+
+#include <asm/timer-regs.h>
+#include <asm/unit/clock.h>
+
+/*
+ * jiffies counter specifications
+ */
+
+#define	TMJCBR_MAX		0xffff
+#define	TMJCBC			TM01BC
+
+#define	TMJCMD			TM01MD
+#define	TMJCBR			TM01BR
+#define	TMJCIRQ			TM1IRQ
+#define	TMJCICR			TM1ICR
+#define	TMJCICR_LEVEL		GxICR_LEVEL_5
+
+#ifndef __ASSEMBLY__
+
+static inline void startup_jiffies_counter(void)
+{
+	unsigned rate;
+	u16 md, t16;
+
+	/* use as little prescaling as possible to avoid losing accuracy */
+	md = TM0MD_SRC_IOCLK;
+	rate = MN10300_JCCLK / HZ;
+
+	if (rate > TMJCBR_MAX) {
+		md = TM0MD_SRC_IOCLK_8;
+		rate = MN10300_JCCLK / 8 / HZ;
+
+		if (rate > TMJCBR_MAX) {
+			md = TM0MD_SRC_IOCLK_32;
+			rate = MN10300_JCCLK / 32 / HZ;
+
+			if (rate > TMJCBR_MAX)
+				BUG();
+		}
+	}
+
+	TMJCBR = rate - 1;
+	t16 = TMJCBR;
+
+	TMJCMD =
+		md |
+		TM1MD_SRC_TM0CASCADE << 8 |
+		TM0MD_INIT_COUNTER |
+		TM1MD_INIT_COUNTER << 8;
+
+	TMJCMD =
+		md |
+		TM1MD_SRC_TM0CASCADE << 8 |
+		TM0MD_COUNT_ENABLE |
+		TM1MD_COUNT_ENABLE << 8;
+
+	t16 = TMJCMD;
+
+	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
+	t16 = TMJCICR;
+}
+
+static inline void shutdown_jiffies_counter(void)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+
+/*
+ * timestamp counter specifications
+ */
+
+#define	TMTSCBR_MAX		0xffffffff
+#define	TMTSCBC			TM45BC
+
+#ifndef __ASSEMBLY__
+
+static inline void startup_timestamp_counter(void)
+{
+	/* set up timer 4 & 5 cascaded as a 32-bit counter to count real time
+	 * - count down from 4Gig-1 to 0 and wrap at IOCLK rate
+	 */
+	TM45BR = TMTSCBR_MAX;
+
+	TM4MD = TM4MD_SRC_IOCLK;
+	TM4MD |= TM4MD_INIT_COUNTER;
+	TM4MD &= ~TM4MD_INIT_COUNTER;
+	TM4ICR = 0;
+
+	TM5MD = TM5MD_SRC_TM4CASCADE;
+	TM5MD |= TM5MD_INIT_COUNTER;
+	TM5MD &= ~TM5MD_INIT_COUNTER;
+	TM5ICR = 0;
+
+	TM5MD |= TM5MD_COUNT_ENABLE;
+	TM4MD |= TM4MD_COUNT_ENABLE;
+}
+
+static inline void shutdown_timestamp_counter(void)
+{
+	TM4MD = 0;
+	TM5MD = 0;
+}
+
+/*
+ * we use a cascaded pair of 16-bit down-counting timers to count I/O
+ * clock cycles for the purposes of time keeping
+ */
+typedef unsigned long cycles_t;
+
+static inline cycles_t read_timestamp_counter(void)
+{
+	return (cycles_t)TMTSCBC;
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_TIMEX_H */
diff -puN /dev/null include/asm-mn10300/unit-asb2305/clock.h
--- /dev/null
+++ a/include/asm-mn10300/unit-asb2305/clock.h
@@ -0,0 +1,45 @@
+/* ASB2305-specific clocks
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_CLOCK_H
+#define _ASM_UNIT_CLOCK_H
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_MN10300_RTC
+
+extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
+extern unsigned long mn10300_iobclk;
+extern unsigned long mn10300_tsc_per_HZ;
+
+#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
+/* If this processors has a another clock, uncomment the below. */
+//#define MN10300_IOBCLK	((unsigned long)mn10300_iobclk)
+
+#else /* !CONFIG_MN10300_RTC */
+
+#define MN10300_IOCLK		33333333UL
+//#define MN10300_IOBCLK	66666666UL
+
+#endif /* !CONFIG_MN10300_RTC */
+
+#define MN10300_JCCLK		MN10300_IOCLK
+#define MN10300_TSCCLK		MN10300_IOCLK
+
+#ifdef CONFIG_MN10300_RTC
+#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
+#else /* !CONFIG_MN10300_RTC */
+#define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
+#endif /* !CONFIG_MN10300_RTC */
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_CLOCK_H */
diff -puN /dev/null include/asm-mn10300/unit-asb2305/leds.h
--- /dev/null
+++ a/include/asm-mn10300/unit-asb2305/leds.h
@@ -0,0 +1,51 @@
+/* ASB2305-specific LEDs
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_LEDS_H
+#define _ASM_UNIT_LEDS_H
+
+#include <asm/pio-regs.h>
+#include <asm/cpu-regs.h>
+#include <asm/exceptions.h>
+
+#define ASB2305_7SEGLEDS	__SYSREG(0xA6F90000, u32)
+
+/* perform a hard reset by driving PIO06 low */
+#define mn10300_unit_hard_reset()		\
+do {						\
+	P0OUT &= 0xbf;				\
+	P0MD = (P0MD & P0MD_6) | P0MD_6_OUT;	\
+} while(0)
+
+/*
+ * use the 7-segment LEDs to indicate states
+ */
+/* indicate double-fault by displaying "db-f" on the LEDs */
+#define mn10300_set_dbfleds			\
+	mov	0x43077f1d,d0		;	\
+	mov	d0,(ASB2305_7SEGLEDS)
+
+/* flip the 7-segment LEDs between "Gdb-" and "----" */
+#define mn10300_set_gdbleds(ONOFF)				\
+do {								\
+	ASB2305_7SEGLEDS = (ONOFF) ? 0x8543077f : 0x7f7f7f7f;	\
+} while(0)
+
+#ifndef __ASSEMBLY__
+extern void peripheral_leds_display_exception(exception_code_t code);
+extern void peripheral_leds_led_chase(void);
+extern void peripheral_leds7x4_display_dec(unsigned int val, unsigned int points);
+extern void peripheral_leds7x4_display_hex(unsigned int val, unsigned int points);
+extern void peripheral_leds7x4_display_minssecs(unsigned int time, unsigned int points);
+extern void peripheral_leds7x4_display_rtc(void);
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_LEDS_H */
diff -puN /dev/null include/asm-mn10300/unit-asb2305/serial.h
--- /dev/null
+++ a/include/asm-mn10300/unit-asb2305/serial.h
@@ -0,0 +1,108 @@
+/* ASB2305-specific 8250 serial ports
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNIT_SERIAL_H
+#define _ASM_UNIT_SERIAL_H
+
+#include <asm/cpu/cpu-regs.h>
+#include <asm/proc/irq.h>
+#include <linux/serial_reg.h>
+
+#define SERIAL_PORT0_BASE_ADDRESS	0xA6FB0000
+#define ASB2305_DEBUG_MCR	__SYSREG(0xA6FB0000 + UART_MCR * 2, u8)
+
+#define SERIAL_IRQ	XIRQ0	/* Dual serial (PC16552)	(Hi) */
+
+/*
+ * dispose of the /dev/ttyS0 serial port
+ */
+#ifndef CONFIG_GDBSTUB_ON_TTYSx
+
+#define SERIAL_PORT_DFNS						\
+	{								\
+	baud_base:		BASE_BAUD,				\
+	irq:			SERIAL_IRQ,				\
+	flags:			STD_COM_FLAGS,				\
+	iomem_base:		(u8 *) SERIAL_PORT0_BASE_ADDRESS,	\
+	iomem_reg_shift:	2,					\
+	io_type:		SERIAL_IO_MEM,				\
+	},
+
+#ifndef __ASSEMBLY__
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#else /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#define SERIAL_PORT_DFNS /* stolen by gdb-stub */
+
+#if defined(CONFIG_GDBSTUB_ON_TTYS0)
+#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 4, u8)
+#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
+#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 4, u8)
+#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 4, u8)
+#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 4, u8)
+#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 4, u8)
+#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 4, u8)
+#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 4, u8)
+#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
+#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
+#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
+#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 4, u8)
+#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
+
+#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
+#error The ASB2305 doesnt have a /dev/ttyS1
+#endif
+
+#ifndef __ASSEMBLY__
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+	char ch;
+
+#define TTYS0_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
+#define TTYS0_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
+#define TTYS0_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
+#define TTYS0_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
+
+#define LSR_WAIT_FOR(STATE)	do { while (!(TTYS0_LSR & UART_LSR_##STATE)) {;} } while(0)
+#define FLOWCTL_QUERY(LINE)	({ TTYS0_MSR & UART_MSR_##LINE; })
+#define FLOWCTL_WAIT_FOR(LINE)	do { while (!(TTYS0_MSR & UART_MSR_##LINE)) {;} } while(0)
+#define FLOWCTL_CLEAR(LINE)	do { TTYS0_MCR &= ~UART_MCR_##LINE; } while (0)
+#define FLOWCTL_SET(LINE)	do { TTYS0_MCR |= UART_MCR_##LINE; } while (0)
+
+	FLOWCTL_SET(DTR);
+
+	for (; n > 0; n--) {
+		LSR_WAIT_FOR(THRE);
+		FLOWCTL_WAIT_FOR(CTS);
+
+		ch = *p++;
+		if (ch == 0x0a) {
+			TTYS0_TX = 0x0d;
+			LSR_WAIT_FOR(THRE);
+			FLOWCTL_WAIT_FOR(CTS);
+		}
+		TTYS0_TX = ch;
+	}
+
+	FLOWCTL_CLEAR(DTR);
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#endif /* _ASM_UNIT_SERIAL_H */
diff -puN /dev/null include/asm-mn10300/unit-asb2305/timex.h
--- /dev/null
+++ a/include/asm-mn10300/unit-asb2305/timex.h
@@ -0,0 +1,135 @@
+/* ASB2305 timer specifcations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNIT_TIMEX_H
+#define _ASM_UNIT_TIMEX_H
+
+#ifndef __ASSEMBLY__
+#include <linux/irq.h>
+#endif /* __ASSEMBLY__ */
+
+#include <asm/cpu/timer-regs.h>
+#include <asm/unit/clock.h>
+
+/*
+ * jiffies counter specifications
+ */
+
+#define	TMJCBR_MAX		0xffff
+#define	TMJCBC			TM01BC
+
+#define	TMJCMD			TM01MD
+#define	TMJCBR			TM01BR
+#define	TMJCIRQ			TM1IRQ
+#define	TMJCICR			TM1ICR
+#define	TMJCICR_LEVEL		GxICR_LEVEL_5
+
+#ifndef __ASSEMBLY__
+
+static inline void startup_jiffies_counter(void)
+{
+	unsigned rate;
+	u16 md, t16;
+
+	/* use as little prescaling as possible to avoid losing accuracy */
+	md = TM0MD_SRC_IOCLK;
+	rate = MN10300_JCCLK / HZ;
+
+	if (rate > TMJCBR_MAX) {
+		md = TM0MD_SRC_IOCLK_8;
+		rate = MN10300_JCCLK / 8 / HZ;
+
+		if (rate > TMJCBR_MAX) {
+			md = TM0MD_SRC_IOCLK_32;
+			rate = MN10300_JCCLK / 32 / HZ;
+
+			if (rate > TMJCBR_MAX)
+				BUG();
+		}
+	}
+
+	TMJCBR = rate - 1;
+	t16 = TMJCBR;
+
+	TMJCMD =
+		md |
+		TM1MD_SRC_TM0CASCADE << 8 |
+		TM0MD_INIT_COUNTER |
+		TM1MD_INIT_COUNTER << 8;
+
+	TMJCMD =
+		md |
+		TM1MD_SRC_TM0CASCADE << 8 |
+		TM0MD_COUNT_ENABLE |
+		TM1MD_COUNT_ENABLE << 8;
+
+	t16 = TMJCMD;
+
+	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
+	t16 = TMJCICR;
+}
+
+static inline void shutdown_jiffies_counter(void)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+
+/*
+ * timestamp counter specifications
+ */
+
+#define	TMTSCBR_MAX		0xffffffff
+#define	TMTSCBC			TM45BC
+
+#ifndef __ASSEMBLY__
+
+static inline void startup_timestamp_counter(void)
+{
+	/* set up timer 4 & 5 cascaded as a 32-bit counter to count real time
+	 * - count down from 4Gig-1 to 0 and wrap at IOCLK rate
+	 */
+	TM45BR = TMTSCBR_MAX;
+
+	TM4MD = TM4MD_SRC_IOCLK;
+	TM4MD |= TM4MD_INIT_COUNTER;
+	TM4MD &= ~TM4MD_INIT_COUNTER;
+	TM4ICR = 0;
+
+	TM5MD = TM5MD_SRC_TM4CASCADE;
+	TM5MD |= TM5MD_INIT_COUNTER;
+	TM5MD &= ~TM5MD_INIT_COUNTER;
+	TM5ICR = 0;
+
+	TM5MD |= TM5MD_COUNT_ENABLE;
+	TM4MD |= TM4MD_COUNT_ENABLE;
+}
+
+static inline void shutdown_timestamp_counter(void)
+{
+	TM4MD = 0;
+	TM5MD = 0;
+}
+
+/*
+ * we use a cascaded pair of 16-bit down-counting timers to count I/O
+ * clock cycles for the purposes of time keeping
+ */
+typedef unsigned long cycles_t;
+
+static inline cycles_t read_timestamp_counter(void)
+{
+	return (cycles_t) TMTSCBC;
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_TIMEX_H */
diff -puN /dev/null include/asm-mn10300/user.h
--- /dev/null
+++ a/include/asm-mn10300/user.h
@@ -0,0 +1,53 @@
+/* MN10300 User process data
+ *
+ * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_USER_H
+#define _ASM_USER_H
+
+#include <asm/page.h>
+#include <linux/ptrace.h>
+
+#ifndef __ASSEMBLY__
+/*
+ * When the kernel dumps core, it starts by dumping the user struct - this will
+ * be used by gdb to figure out where the data and stack segments are within
+ * the file, and what virtual addresses to use.
+ */
+struct user {
+	/* We start with the registers, to mimic the way that "memory" is
+	 * returned from the ptrace(3,...) function.
+	 */
+	struct pt_regs regs;		/* Where the registers are actually stored */
+
+	/* The rest of this junk is to help gdb figure out what goes where */
+	unsigned long int u_tsize;	/* Text segment size (pages). */
+	unsigned long int u_dsize;	/* Data segment size (pages). */
+	unsigned long int u_ssize;	/* Stack segment size (pages). */
+	unsigned long start_code;	/* Starting virtual address of text. */
+	unsigned long start_stack;	/* Starting virtual address of stack area.
+					   This is actually the bottom of the stack,
+					   the top of the stack is always found in the
+					   esp register.  */
+	long int signal;		/* Signal that caused the core dump. */
+	int reserved;			/* No longer used */
+	struct user_pt_regs *u_ar0;	/* Used by gdb to help find the values for */
+
+	/* the registers */
+	unsigned long magic;		/* To uniquely identify a core file */
+	char u_comm[32];		/* User command that was responsible */
+};
+#endif
+
+#define NBPG PAGE_SIZE
+#define UPAGES 1
+#define HOST_TEXT_START_ADDR +(u.start_code)
+#define HOST_STACK_END_ADDR +(u.start_stack + u.u_ssize * NBPG)
+
+#endif /* _ASM_USER_H */
diff -puN /dev/null include/asm-mn10300/vga.h
--- /dev/null
+++ a/include/asm-mn10300/vga.h
@@ -0,0 +1,17 @@
+/* MN10300 VGA register definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_VGA_H
+#define _ASM_VGA_H
+
+
+
+#endif /* _ASM_VGA_H */
diff -puN /dev/null include/asm-mn10300/xor.h
--- /dev/null
+++ a/include/asm-mn10300/xor.h
@@ -0,0 +1 @@
+#include <asm-generic/xor.h>
diff -puN include/linux/elf-em.h~mn10300-add-the-mn10300-am33-architecture-to-the-kernel include/linux/elf-em.h
--- a/include/linux/elf-em.h~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/include/linux/elf-em.h
@@ -31,6 +31,7 @@
 #define EM_V850		87	/* NEC v850 */
 #define EM_M32R		88	/* Renesas M32R */
 #define EM_H8_300	46	/* Renesas H8/300,300H,H8S */
+#define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
 #define EM_BLACKFIN     106     /* ADI Blackfin Processor */
 #define EM_FRV		0x5441	/* Fujitsu FR-V */
 #define EM_AVR32	0x18ad	/* Atmel AVR32 */
@@ -47,6 +48,8 @@
 #define EM_CYGNUS_M32R	0x9041
 /* This is the old interim value for S/390 architecture */
 #define EM_S390_OLD	0xA390
+/* Also Panasonic/MEI MN10300, AM33 */
+#define EM_CYGNUS_MN10300 0xbeef
 
 
 #endif /* _LINUX_ELF_EM_H */
diff -puN include/linux/kprobes.h~mn10300-add-the-mn10300-am33-architecture-to-the-kernel include/linux/kprobes.h
--- a/include/linux/kprobes.h~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/include/linux/kprobes.h
@@ -171,6 +171,7 @@ struct kretprobe_blackpoint {
 	void *addr;
 };
 extern struct kretprobe_blackpoint kretprobe_blacklist[];
+extern const int kretprobe_blacklist_size;
 
 static inline void kretprobe_assert(struct kretprobe_instance *ri,
 	unsigned long orig_ret_address, unsigned long trampoline_address)
diff -puN lib/Kconfig.debug~mn10300-add-the-mn10300-am33-architecture-to-the-kernel lib/Kconfig.debug
--- a/lib/Kconfig.debug~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/lib/Kconfig.debug
@@ -359,7 +359,7 @@ config DEBUG_HIGHMEM
 config DEBUG_BUGVERBOSE
 	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EMBEDDED
 	depends on BUG
-	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || FRV || SUPERH || GENERIC_BUG || BFIN
+	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || FRV || SUPERH || GENERIC_BUG || BFIN || MN10300
 	default !EMBEDDED
 	help
 	  Say Y here to make BUG() panics output the file name and line number
@@ -409,7 +409,7 @@ config DEBUG_SG
 
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
-	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH || BFIN)
+	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH || BFIN || MN10300)
 	default y if DEBUG_INFO && UML
 	help
 	  If you say Y here the resulting kernel image will be slightly larger
diff -puN MAINTAINERS~mn10300-add-the-mn10300-am33-architecture-to-the-kernel MAINTAINERS
--- a/MAINTAINERS~mn10300-add-the-mn10300-am33-architecture-to-the-kernel
+++ a/MAINTAINERS
@@ -2545,6 +2545,15 @@ L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-mm.org
 S:	Maintained
 
+MEI MN10300/AM33 PORT
+P:	David Howells
+M:	dhowells@redhat.com
+P:	Koichi Yasutake
+M:	yasutake.koichi@jp.panasonic.com
+L:	linux-am33-list@redhat.com
+W:	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
+S:	Maintained
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
usb-net2280-cant-have-a-function-called-checkpatch-fixes.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-ia64-fix.patch
mutex-subsystem-synchro-test-module.patch
