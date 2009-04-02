From: akpm@linux-foundation.org
Subject: [merged] serial-fixup-proc-tty-driver-serial-after-proc_fops-conversion.patch removed from -mm tree
Date: Thu, 02 Apr 2009 11:28:54 -0700
Message-ID: <200904021828.n32ISsH8024475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765311AbZDBSas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 14:30:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     serial: fixup /proc/tty/driver/serial after proc_fops conversion
has been removed from the -mm tree.  Its filename was
     serial-fixup-proc-tty-driver-serial-after-proc_fops-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: fixup /proc/tty/driver/serial after proc_fops conversion
From: Alexey Dobriyan <adobriyan@gmail.com>

"struct tty_driver *" lies in m->private not in v which is
SEQ_TOKEN_START which is 1 which is enough to trigger NULL dereference
next line:

	BUG: unable to handle kernel NULL pointer dereference at 000000ad
	IP: [<c040d689>] uart_proc_show+0xe/0x2b0

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~serial-fixup-proc-tty-driver-serial-after-proc_fops-conversion drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-fixup-proc-tty-driver-serial-after-proc_fops-conversion
+++ a/drivers/serial/serial_core.c
@@ -1765,7 +1765,7 @@ static void uart_line_info(struct seq_fi
 
 static int uart_proc_show(struct seq_file *m, void *v)
 {
-	struct tty_driver *ttydrv = v;
+	struct tty_driver *ttydrv = m->private;
 	struct uart_driver *drv = ttydrv->driver_state;
 	int i;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
simplify-copy_thread.patch
simplify-copy_thread-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

