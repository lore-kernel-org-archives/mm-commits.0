From: akpm@linux-foundation.org
Subject: [merged] isicom-isicom-kref-leak-fix.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:39 -0700
Message-ID: <200903301906.n2UJ6dYx019119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757875AbZC3TJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:09:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     isicom: isicom kref leak fix
has been removed from the -mm tree.  Its filename was
     isicom-isicom-kref-leak-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isicom: isicom kref leak fix
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The isicom driver leaks a kref on the shutdown path. Drop the additional
kref we took

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/isicom.c~isicom-isicom-kref-leak-fix drivers/char/isicom.c
--- a/drivers/char/isicom.c~isicom-isicom-kref-leak-fix
+++ a/drivers/char/isicom.c
@@ -925,6 +925,7 @@ static void isicom_shutdown_port(struct 
 		if (!card->count)
 			isicom_shutdown_board(card);
 	}
+	tty_kref_put(tty);
 }
 
 static void isicom_flush_buffer(struct tty_struct *tty)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
linux-next.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
mflash-initial-support.patch
mflash-initial-support-v2.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
tty-pty-lookup-retval-fixup.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
isicom-isicom-kref-leak-fix-fix.patch
blackfin-serial-driver-add-a-debug-function-to-serial-driver.patch
blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven.patch
blackfin-serial-driver-fix-bug-serial-port-transfer-big-file-from-host-to-target-would-have-more-lines.patch
blackfin-serial-driver-irq-funcs-take-an-unsigned-long-for-flags.patch
blackfin-serial-driver-update-kgdb-uart-config-name.patch
blackfin-serial-driver-fix-building-when-debug-is-enabled-but-serial-console-is-disabled.patch
blackfin-serial-driver-depend-on-kgdb_serial_console-being-set-to-n.patch
blackfin-serial-driver-use-the-dlab-macro-to-hide-variant-differences.patch
blackfin-serial-driver-fix-bug-enable-hardware-based-cts-and-rts-for-bf548.patch
blackfin-serial-driver-update-path-to-gpio-header.patch
max3100-spi-uart-driver.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
serial-clean-up-rs485-on-cris-architecture.patch
jsm-cleanup.patch
serial-8250c-irq-handling-race-and-spurious-iir-read.patch
vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch

