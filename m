From: akpm@google.com
Subject: [merged] drivers-tty-serial-8250c-ratelimit-lsr-safety-check-engaged-warning.patch removed from -mm tree
Date: Tue, 04 Oct 2011 12:29:57 -0700
Message-ID: <201110041929.p94JTvdJ014711@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:33017 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1JDTaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 15:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konrad.wilk@oracle.com, alan@linux.intel.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/tty/serial/8250.c: ratelimit LSR safety check engaged warning
has been removed from the -mm tree.  Its filename was
     drivers-tty-serial-8250c-ratelimit-lsr-safety-check-engaged-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: drivers/tty/serial/8250.c: ratelimit LSR safety check engaged warning

On my BIOSTAR TA890FXE the ttyS0 ends up spewing:

[904682.485933] ttyS0: LSR safety check engaged!
[904692.505895] ttyS0: LSR safety check engaged!
[904702.525972] ttyS0: LSR safety check engaged!
[904712.545967] ttyS0: LSR safety check engaged!
[904722.566125] ttyS0: LSR safety check engaged!
..

let's limit it so it won't be the only thing visible in the ring buffer.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/tty/serial/8250.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/tty/serial/8250.c~drivers-tty-serial-8250c-ratelimit-lsr-safety-check-engaged-warning drivers/tty/serial/8250.c
--- a/drivers/tty/serial/8250.c~drivers-tty-serial-8250c-ratelimit-lsr-safety-check-engaged-warning
+++ a/drivers/tty/serial/8250.c
@@ -2019,8 +2019,8 @@ static int serial8250_startup(struct uar
 	 */
 	if (!(up->port.flags & UPF_BUGGY_UART) &&
 	    (serial_inp(up, UART_LSR) == 0xff)) {
-		printk(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
-		       serial_index(&up->port));
+		printk_ratelimited(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
+				   serial_index(&up->port));
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from konrad.wilk@oracle.com are

origin.patch
linux-next.patch
x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch

