From: akpm@linux-foundation.org
Subject: + mtd-m25p80-fix-null-pointer-dereference-bug.patch added to -mm tree
Date: Wed, 29 Jul 2009 17:04:20 -0700
Message-ID: <200907300004.n6U04KJ5019636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557AbZG3AFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, david-b@pacbell.net, dwmw2@infradead.org


The patch titled
     mtd: m25p80: fix null pointer dereference bug
has been added to the -mm tree.  Its filename is
     mtd-m25p80-fix-null-pointer-dereference-bug.patch

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
Subject: mtd: m25p80: fix null pointer dereference bug
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This patch fixes the following oops, observed with MTD_PARTITIONS=n:

m25p80 spi32766.0: m25p80 (1024 Kbytes)
Unable to handle kernel paging request for data at address 0x00000008
Faulting instruction address: 0xc03a54b0
Oops: Kernel access of bad area, sig: 11 [#1]
Modules linked in:
NIP: c03a54b0 LR: c03a5494 CTR: c01e98b8
REGS: ef82bb60 TRAP: 0300   Not tainted  (2.6.31-rc4-00167-g4733fd3)
MSR: 00029000 <EE,ME,CE>  CR: 24022022  XER: 20000000
DEAR: 00000008, ESR: 00000000
TASK = ef82c000[1] 'swapper' THREAD: ef82a000
GPR00: 00000000 ef82bc10 ef82c000 0000002e 00001eb8 ffffffff c01e9824 00000036
GPR08: c054ed40 c0542a08 00001eb8 00004000 22022022 1001a1a0 3ff8fd00 00000000
GPR16: 00000000 00000001 00000000 00000000 ef82bddc c0530000 efbef500 ef8356d0
GPR24: 00000000 ef8356d0 00000000 efbf7a00 c0530ec4 ffffffed efbf5300 c0541f98
NIP [c03a54b0] m25p_probe+0x22c/0x354
LR [c03a5494] m25p_probe+0x210/0x354
Call Trace:
[ef82bc10] [c03a5494] m25p_probe+0x210/0x354 (unreliable)
[ef82bca0] [c024e37c] spi_drv_probe+0x2c/0x3c
[ef82bcb0] [c01f1afc] driver_probe_device+0xa4/0x178
[ef82bcd0] [c01f06e8] bus_for_each_drv+0x6c/0xa8
[ef82bd00] [c01f1a34] device_attach+0x84/0xa8
...

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-m25p80-fix-null-pointer-dereference-bug drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-m25p80-fix-null-pointer-dereference-bug
+++ a/drivers/mtd/devices/m25p80.c
@@ -736,7 +736,7 @@ static int __devinit m25p_probe(struct s
 			flash->partitioned = 1;
 			return add_mtd_partitions(&flash->mtd, parts, nr_parts);
 		}
-	} else if (data->nr_parts)
+	} else if (data && data->nr_parts)
 		dev_warn(&spi->dev, "ignoring %d default partitions on %s\n",
 				data->nr_parts, data->name);
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc.patch
linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch

