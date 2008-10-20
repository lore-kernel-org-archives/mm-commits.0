From: akpm@linux-foundation.org
Subject: - altix-serial-fix.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:29 -0700
Message-ID: <200810202035.m9KKZTxY011157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbYJTUqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jes@sgi.com, pfg@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Altix serial: fix
has been removed from the -mm tree.  Its filename was
     altix-serial-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Altix serial: fix
From: roel kluin <roel.kluin@gmail.com>

In function sn_sal_switch_to_asynch(): drivers/serial/sn_console.c:713:

HZ * SN_SAL_UART_FIFO_DEPTH / SN_SAL_UART_FIFO_SPEED_CPS;

After preprocessing (see defines in patch) this becomes HZ * 16 / 9600 / 10
(associativity from left to right), not equivalent to HZ * 16 / 960.

Looks-obviously-right-to: Tony Luck <tony.luck@intel.com>
Cc: Jes Sorensen <jes@sgi.com>
Acked-by: Pat Gefre <pfg@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sn_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/sn_console.c~altix-serial-fix drivers/serial/sn_console.c
--- a/drivers/serial/sn_console.c~altix-serial-fix
+++ a/drivers/serial/sn_console.c
@@ -61,7 +61,7 @@
 #define SN_SAL_BUFFER_SIZE (64 * (1 << 10))
 
 #define SN_SAL_UART_FIFO_DEPTH 16
-#define SN_SAL_UART_FIFO_SPEED_CPS 9600/10
+#define SN_SAL_UART_FIFO_SPEED_CPS (9600/10)
 
 /* sn_transmit_chars() calling args */
 #define TRANSMIT_BUFFERED	0
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch

