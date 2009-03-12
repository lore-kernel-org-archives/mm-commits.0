From: akpm@linux-foundation.org
Subject: [merged] blackfin-serial-driver-use-barrier-instead-of-cpu_relax-for-blackfin-smp-like-patch.patch removed from -mm tree
Date: Thu, 12 Mar 2009 13:16:58 -0700
Message-ID: <200903122016.n2CKGwvx032613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbZCLUUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 16:20:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: graf.yang@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     blackfin serial driver: use barrier instead of cpu_relax for Blackfin SMP like patch
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-use-barrier-instead-of-cpu_relax-for-blackfin-smp-like-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin serial driver: use barrier instead of cpu_relax for Blackfin SMP like patch
From: Graf Yang <graf.yang@analog.com>

We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
data cache flush function which will count it to a per-cpu counter.  If
this serial function is called too early, the per-cpu data area have not
been initialized, this call will cause crash.  So we'd like to use
barrier() instead of cpu_relax().

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-use-barrier-instead-of-cpu_relax-for-blackfin-smp-like-patch drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-use-barrier-instead-of-cpu_relax-for-blackfin-smp-like-patch
+++ a/drivers/serial/bfin_5xx.c
@@ -1129,7 +1129,8 @@ static __init void early_serial_putc(str
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 
 	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
-		cpu_relax();
+		barrier();
+
 	UART_PUT_CHAR(uart, ch);
 }
 
_

Patches currently in -mm which might be from graf.yang@analog.com are

origin.patch
linux-next.patch
mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash.patch
blackfin-serial-driver-add-a-debug-function-to-serial-driver.patch

