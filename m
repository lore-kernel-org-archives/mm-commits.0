From: akpm@linux-foundation.org
Subject: [merged] cleanup-usb_serial_port-update-struct-comments.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:52 -0700
Message-ID: <200904141950.n3EJoqJf020380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993AbZDNTx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldorileo@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb_serial_port: update struct comments
has been removed from the -mm tree.  Its filename was
     cleanup-usb_serial_port-update-struct-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb_serial_port: update struct comments
From: Leandro Dorileo <ldorileo@gmail.com>

updates some usb_serial_port members documentation.

Signed-off-by: Leandro Dorileo <ldorileo@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/usb/serial.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/usb/serial.h~cleanup-usb_serial_port-update-struct-comments include/linux/usb/serial.h
--- a/include/linux/usb/serial.h~cleanup-usb_serial_port-update-struct-comments
+++ a/include/linux/usb/serial.h
@@ -29,7 +29,7 @@
 /**
  * usb_serial_port: structure for the specific ports of a device.
  * @serial: pointer back to the struct usb_serial owner of this port.
- * @tty: pointer to the corresponding tty for this port.
+ * @port: pointer to the corresponding tty_port for this port.
  * @lock: spinlock to grab when updating portions of this structure.
  * @mutex: mutex used to synchronize serial_open() and serial_close()
  *	access for this port.
@@ -44,19 +44,22 @@
  * @interrupt_out_endpointAddress: endpoint address for the interrupt out pipe
  * 	for this port.
  * @bulk_in_buffer: pointer to the bulk in buffer for this port.
+ * @bulk_in_size: the size of the bulk_in_buffer, in bytes.
  * @read_urb: pointer to the bulk in struct urb for this port.
  * @bulk_in_endpointAddress: endpoint address for the bulk in pipe for this
  *	port.
  * @bulk_out_buffer: pointer to the bulk out buffer for this port.
  * @bulk_out_size: the size of the bulk_out_buffer, in bytes.
  * @write_urb: pointer to the bulk out struct urb for this port.
+ * @write_urb_busy: port`s writing status
  * @bulk_out_endpointAddress: endpoint address for the bulk out pipe for this
  *	port.
  * @write_wait: a wait_queue_head_t used by the port.
  * @work: work queue entry for the line discipline waking up.
- * @open_count: number of times this port has been opened.
  * @throttled: nonzero if the read urb is inactive to throttle the device
  * @throttle_req: nonzero if the tty wants to throttle us
+ * @console: attached usb serial console
+ * @dev: pointer to the serial device
  *
  * This structure is used by the usb-serial core and drivers for the specific
  * ports of a device.
_

Patches currently in -mm which might be from ldorileo@gmail.com are

origin.patch

