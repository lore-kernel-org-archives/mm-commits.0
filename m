From: akpm@linux-foundation.org
Subject: - remove-unused-header-file-drivers-serial-crisv10h.patch removed from -mm tree
Date: Sun, 06 May 2007 23:51:45 -0700
Message-ID: <200705070651.l476pjJD020580@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbXEGGvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     remove unused header file: drivers/serial/crisv10.h
has been removed from the -mm tree.  Its filename was
     remove-unused-header-file-drivers-serial-crisv10h.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: remove unused header file: drivers/serial/crisv10.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/crisv10.h |  136 -------------------------------------
 1 file changed, 136 deletions(-)

diff -puN drivers/serial/crisv10.h~remove-unused-header-file-drivers-serial-crisv10h /dev/null
--- a/drivers/serial/crisv10.h
+++ /dev/null
@@ -1,136 +0,0 @@
-/*
- * serial.h: Arch-dep definitions for the Etrax100 serial driver.
- *
- * Copyright (C) 1998, 1999, 2000 Axis Communications AB
- */
-
-#ifndef _ETRAX_SERIAL_H
-#define _ETRAX_SERIAL_H
-
-#include <linux/circ_buf.h>
-#include <asm/termios.h>
-
-/* Software state per channel */
-
-#ifdef __KERNEL__
-/*
- * This is our internal structure for each serial port's state.
- *
- * Many fields are paralleled by the structure used by the serial_struct
- * structure.
- *
- * For definitions of the flags field, see tty.h
- */
-
-#define SERIAL_RECV_DESCRIPTORS 8
-
-struct etrax_recv_buffer {
-	struct etrax_recv_buffer *next;
-	unsigned short length;
-	unsigned char error;
-	unsigned char pad;
-
-	unsigned char buffer[0];
-};
-
-struct e100_serial {
-	int			baud;
-	volatile u8		*port; /* R_SERIALx_CTRL */
-	u32			irq;  /* bitnr in R_IRQ_MASK2 for dmaX_descr */
-
-	/* Output registers */
-	volatile u8		*oclrintradr; /* adr to R_DMA_CHx_CLR_INTR */
-	volatile u32		*ofirstadr;   /* adr to R_DMA_CHx_FIRST */
-	volatile u8		*ocmdadr;     /* adr to R_DMA_CHx_CMD */
-	const volatile u8	*ostatusadr;  /* adr to R_DMA_CHx_STATUS */
-
-	/* Input registers */
-	volatile u8		*iclrintradr; /* adr to R_DMA_CHx_CLR_INTR */
-	volatile u32		*ifirstadr;   /* adr to R_DMA_CHx_FIRST */
-	volatile u8		*icmdadr;     /* adr to R_DMA_CHx_CMD */
-	volatile u32		*idescradr;   /* adr to R_DMA_CHx_DESCR */
-
-	int			flags;	/* defined in tty.h */
-
-	u8			rx_ctrl; /* shadow for R_SERIALx_REC_CTRL */
-	u8			tx_ctrl; /* shadow for R_SERIALx_TR_CTRL */
-	u8			iseteop; /* bit number for R_SET_EOP for the input dma */
-	int			enabled; /* Set to 1 if the port is enabled in HW config */
-
-	u8		dma_out_enabled:1; /* Set to 1 if DMA should be used */
-	u8		dma_in_enabled:1;  /* Set to 1 if DMA should be used */
-
-	/* end of fields defined in rs_table[] in .c-file */
-	u8		uses_dma_in;  /* Set to 1 if DMA is used */
-	u8		uses_dma_out; /* Set to 1 if DMA is used */
-	u8		forced_eop;   /* a fifo eop has been forced */
-	int			baud_base;     /* For special baudrates */
-	int			custom_divisor; /* For special baudrates */
-	struct etrax_dma_descr	tr_descr;
-	struct etrax_dma_descr	rec_descr[SERIAL_RECV_DESCRIPTORS];
-	int			cur_rec_descr;
-
-	volatile int		tr_running; /* 1 if output is running */
-
-	struct tty_struct	*tty;
-	int			read_status_mask;
-	int			ignore_status_mask;
-	int			x_char;	/* xon/xoff character */
-	int			close_delay;
-	unsigned short		closing_wait;
-	unsigned short		closing_wait2;
-	unsigned long		event;
-	unsigned long		last_active;
-	int			line;
-	int			type;  /* PORT_ETRAX */
-	int			count;	    /* # of fd on device */
-	int			blocked_open; /* # of blocked opens */
-	struct circ_buf		xmit;
-	struct etrax_recv_buffer *first_recv_buffer;
-	struct etrax_recv_buffer *last_recv_buffer;
-	unsigned int		recv_cnt;
-	unsigned int		max_recv_cnt;
-
-	struct work_struct	work;
-	struct async_icount	icount;   /* error-statistics etc.*/
-	struct ktermios		normal_termios;
-	struct ktermios		callout_termios;
-#ifdef DECLARE_WAITQUEUE
-	wait_queue_head_t	open_wait;
-	wait_queue_head_t	close_wait;
-#else
-	struct wait_queue	*open_wait;
-	struct wait_queue	*close_wait;
-#endif
-
-	unsigned long		char_time_usec;       /* The time for 1 char, in usecs */
-	unsigned long		flush_time_usec;      /* How often we should flush */
-	unsigned long		last_tx_active_usec;  /* Last tx usec in the jiffies */
-	unsigned long		last_tx_active;       /* Last tx time in jiffies */
-	unsigned long		last_rx_active_usec;  /* Last rx usec in the jiffies */
-	unsigned long		last_rx_active;       /* Last rx time in jiffies */
-
-	int			break_detected_cnt;
-	int			errorcode;
-
-#ifdef CONFIG_ETRAX_RS485
-	struct rs485_control	rs485;  /* RS-485 support */
-#endif
-};
-
-/* this PORT is not in the standard serial.h. it's not actually used for
- * anything since we only have one type of async serial-port anyway in this
- * system.
- */
-
-#define PORT_ETRAX 1
-
-/*
- * Events are used to schedule things to happen at timer-interrupt
- * time, instead of at rs interrupt time.
- */
-#define RS_EVENT_WRITE_WAKEUP	0
-
-#endif /* __KERNEL__ */
-
-#endif /* !_ETRAX_SERIAL_H */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
arm26-remove-useless-config-option-generic_bust_spinlock.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
cris-remove-code-related-to-pre-22-kernel.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-r8169.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
add-spaces-on-either-side-of-case-operator.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
video-add-spaces-on-either-side-of-the-case-operator.patch
