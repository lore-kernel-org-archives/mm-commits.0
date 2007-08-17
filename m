From: akpm@linux-foundation.org
Subject: + move-a-few-definitions-to-au1000_xxs1500c.patch added to -mm tree
Date: Fri, 17 Aug 2007 13:27:42 -0700
Message-ID: <200708172027.l7HKRg8T028011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754988AbXHQU2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 16:28:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, linux@dominikbrodowski.net, ralf@linux-mips.org


The patch titled
     move a few definitions to au1000_xxs1500.c
has been added to the -mm tree.  Its filename is
     move-a-few-definitions-to-au1000_xxs1500c.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: move a few definitions to au1000_xxs1500.c
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Only a few definitions is in xxs1500.h .
They can be move to au1000_xxs1500.c .

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/au1000_xxs1500.c |    5 +++-
 include/asm-mips/xxs1500.h      |   35 ------------------------------
 2 files changed, 4 insertions(+), 36 deletions(-)

diff -puN drivers/pcmcia/au1000_xxs1500.c~move-a-few-definitions-to-au1000_xxs1500c drivers/pcmcia/au1000_xxs1500.c
--- a/drivers/pcmcia/au1000_xxs1500.c~move-a-few-definitions-to-au1000_xxs1500c
+++ a/drivers/pcmcia/au1000_xxs1500.c
@@ -50,7 +50,10 @@
 
 #include <asm/au1000.h>
 #include <asm/au1000_pcmcia.h>
-#include <asm/xxs1500.h>
+
+#define PCMCIA_MAX_SOCK		0
+#define PCMCIA_NUM_SOCKS	PCMCIA_MAX_SOCK + 1)
+#define PCMCIA_IRQ		AU1000_GPIO_4
 
 #if 0
 #define DEBUG(x,args...)	printk(__FUNCTION__ ": " x,##args)
diff -puN include/asm-mips/xxs1500.h~move-a-few-definitions-to-au1000_xxs1500c /dev/null
--- a/include/asm-mips/xxs1500.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * MyCable XXS1500 Referrence Board
- *
- * Copyright 2003 MontaVista Software Inc.
- * Author: Pete Popov, MontaVista Software, Inc.
- *         	ppopov@mvista.com or source@mvista.com
- *
- * ########################################################################
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * ########################################################################
- *
- *
- */
-#ifndef __ASM_XXS1500_H
-#define __ASM_XXS1500_H
-
-/* PCMCIA XXS1500 specific defines */
-#define PCMCIA_MAX_SOCK 0
-#define PCMCIA_NUM_SOCKS (PCMCIA_MAX_SOCK+1)
-#define PCMCIA_IRQ AU1000_GPIO_4
-
-#endif /* __ASM_XXS1500_ */
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

git-mips.patch
git-mtd.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
