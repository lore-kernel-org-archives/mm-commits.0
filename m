From: akpm@linux-foundation.org
Subject: - hci_ldisc-fix-null-pointer-deref.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:53 -0800
Message-ID: <200802132015.m1DKFrPp011412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081AbYBMUYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:24:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@davidnewall.com, alan@lxorguk.ukuu.org.uk, arjan@linux.intel.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     hci_ldisc: fix null pointer deref
has been removed from the -mm tree.  Its filename was
     hci_ldisc-fix-null-pointer-deref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hci_ldisc: fix null pointer deref
From: David Newall <david@davidnewall.com>

Arjan:

  With the help of kerneloops.org I've spotted a nice little interaction
  between the TTY layer and the bluetooth code, however the tty layer is not
  something I'm all too familiar with so I rather ask than brute-force fix the
  code incorrectly.

  The raw details are at:
  http://www.kerneloops.org/search.php?search=uart_flush_buffer

  What happens is that, on closing the bluetooth tty, the tty layer goes
  into the release_dev() function, which first does a bunch of stuff, then
  sets the file->private_data to NULL, does some more stuff and then calls the
  ldisc close function.  Which in this case, is hci_uart_tty_close().

  Now, hci_uart_tty_close() calls hci_uart_close() which clears some
  internal bit, and then calls hci_uart_flush()...  which calls back to the
  tty layers' uart_flush_buffer() function.  (in drivers/bluetooth/hci_tty.c
  around line 194) Which then WARN_ON()'s because that's not allowed/supposed
  to be called this late in the shutdown of the port....

  Should the bluetooth driver even call this flush function at all??

David:

  This seems to be what happens: Hci_uart_close() flushes using
  hci_uart_flush().  Subsequently, in hci_dev_do_close(), (one step in
  hci_unregister_dev()), hci_uart_flush() is called again.  The comment in
  uart_flush_buffer(), relating to the WARN_ON(), indicates you can't flush
  after the port is closed; which sounds reasonable.  I think hci_uart_close()
  should set hdev->flush to NULL before returning.  Hci_dev_do_close() does
  check for this.  The code path is rather involved and I'm not entirely clear
  of all steps, but I think that's what should be done.

akpm:

  No idea.  trollmerge.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_ldisc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/bluetooth/hci_ldisc.c~hci_ldisc-fix-null-pointer-deref drivers/bluetooth/hci_ldisc.c
--- a/drivers/bluetooth/hci_ldisc.c~hci_ldisc-fix-null-pointer-deref
+++ a/drivers/bluetooth/hci_ldisc.c
@@ -208,6 +208,7 @@ static int hci_uart_close(struct hci_dev
 		return 0;
 
 	hci_uart_flush(hdev);
+	hdev->flush = NULL;
 	return 0;
 }
 
_

Patches currently in -mm which might be from david@davidnewall.com are

git-net.patch
