From: akpm@linux-foundation.org
Subject: + blackfin-serial-driver-use-barrier-instead-of-cpu_relax-for-blackfin-smp-like-patch.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:37:04 -0800
Message-ID: <200903062237.n26Mb5CA007000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbZCFWhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:37:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: graf.yang@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org


The patch titled
     blackfin serial driver: use barrier instead of cpu_relax for Blackfin SMP like patch
has been added to the -mm tree.  Its filename is
     blackfin-serial-driver-use-barrier-instead-of-cpu_relax-for-blackfin-smp-like-patch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash.patch
blackfin-serial-driver-add-a-debug-function-to-serial-driver.patch
blackfin-serial-driver-use-barrier-instead-of-cpu_relax-for-blackfin-smp-like-patch.patch
blackfin-serial-driver-fix-bug-up-arrow-key-works-abnormal-for-bf561-ezkit-board.patch

