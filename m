From: akpm@linux-foundation.org
Subject: + altix-serial-fix.patch added to -mm tree
Date: Mon, 28 Jul 2008 19:44:10 -0700
Message-ID: <200807290244.m6T2iA9N010202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbYG2CoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 22:44:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, jes@sgi.com, pfg@sgi.com, tony.luck@intel.com


The patch titled
     Altix serial: fix
has been added to the -mm tree.  Its filename is
     altix-serial-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Altix serial: fix
From: roel kluin <roel.kluin@gmail.com>

In function sn_sal_switch_to_asynch(): drivers/serial/sn_console.c:713:

HZ * SN_SAL_UART_FIFO_DEPTH / SN_SAL_UART_FIFO_SPEED_CPS;

After preprocessing (see defines in patch) this becomes HZ * 16 / 9600 / 10
(associativity from left to right), not equivalent to HZ * 16 / 960.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Jes Sorensen <jes@sgi.com>
Cc: Pat Gefre <pfg@sgi.com>
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
altix-serial-fix.patch

