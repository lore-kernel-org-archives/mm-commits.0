From: akpm@linux-foundation.org
Subject: [merged]
 usb-serial-safe_serial-move-__inline__-before-return-type.patch removed
 from -mm tree
Date: Thu, 13 Jul 2017 13:43:38 -0700
Message-ID: <20170713204338.HfpLYfIPx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdGMUnj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@linuxfoundation.org, joe@perches.com, johan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: USB: serial: safe_serial: move __inline__ before return type
has been removed from the -mm tree.  Its filename was
     usb-serial-safe_serial-move-__inline__-before-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: USB: serial: safe_serial: move __inline__ before return type

Make the code like the rest of the kernel.
Also use inline instead of __inline__.

Link: http://lkml.kernel.org/r/a5072b74b6c293e6ec93c4900482e9d3267f15b2.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/safe_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/safe_serial.c~usb-serial-safe_serial-move-__inline__-before-return-type drivers/usb/serial/safe_serial.c
--- a/drivers/usb/serial/safe_serial.c~usb-serial-safe_serial-move-__inline__-before-return-type
+++ a/drivers/usb/serial/safe_serial.c
@@ -180,7 +180,7 @@ static const __u16 crc10_table[256] = {
  * Perform a memcpy and calculate fcs using ppp 10bit CRC algorithm. Return
  * new 10 bit FCS.
  */
-static __u16 __inline__ fcs_compute10(unsigned char *sp, int len, __u16 fcs)
+static inline __u16 fcs_compute10(unsigned char *sp, int len, __u16 fcs)
 {
 	for (; len-- > 0; fcs = CRC10_FCS(fcs, *sp++));
 	return fcs;
_

Patches currently in -mm which might be from joe@perches.com are


