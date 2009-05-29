From: akpm@linux-foundation.org
Subject: [merged] serial-8250_gsc-fix-printk-format-warning.patch removed from -mm tree
Date: Fri, 29 May 2009 11:43:09 -0700
Message-ID: <200905291843.n4TIh9l1011420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213AbZE2Sn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     serial: 8250_gsc: fix printk format error
has been removed from the -mm tree.  Its filename was
     serial-8250_gsc-fix-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: 8250_gsc: fix printk format error
From: Alexander Beregalov <a.beregalov@gmail.com>

drivers/serial/8250_gsc.c:44: warning: format '%lx' expects type
'long unsigned int', but argument 2 has type 'resource_size_t'

[akpm@linux-foundation.org: fix it to handle u64's]
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_gsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250_gsc.c~serial-8250_gsc-fix-printk-format-warning drivers/serial/8250_gsc.c
--- a/drivers/serial/8250_gsc.c~serial-8250_gsc-fix-printk-format-warning
+++ a/drivers/serial/8250_gsc.c
@@ -39,9 +39,9 @@ static int __init serial_init_chip(struc
 		 */
 		if (parisc_parent(dev)->id.hw_type != HPHW_IOA)
 			printk(KERN_INFO
-				"Serial: device 0x%lx not configured.\n"
+				"Serial: device 0x%llx not configured.\n"
 				"Enable support for Wax, Lasi, Asp or Dino.\n",
-				dev->hpa.start);
+				(unsigned long long)dev->hpa.start);
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
linux-next.patch

