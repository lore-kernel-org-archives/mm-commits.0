From: akpm@linux-foundation.org
Subject: + isdn-sc-remove-unused-request_irq-and-unnecessary-header-file.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:40:17 -0700
Message-ID: <200710182140.l9ILeH1n032437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbXJRVkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, kkeil@suse.de


The patch titled
     isdn/sc: remove unused REQUEST_IRQ and unnecessary header file
has been added to the -mm tree.  Its filename is
     isdn-sc-remove-unused-request_irq-and-unnecessary-header-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isdn/sc: remove unused REQUEST_IRQ and unnecessary header file
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>

REQUEST_IRQ is never used, so delete it. In the process get rid of the
macro FREE_IRQ which makes the code unnecessarily difficult to read.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/sc/debug.h    |   19 -------------------
 drivers/isdn/sc/includes.h |    1 -
 drivers/isdn/sc/init.c     |    2 +-
 3 files changed, 1 insertion(+), 21 deletions(-)

diff -puN drivers/isdn/sc/debug.h~isdn-sc-remove-unused-request_irq-and-unnecessary-header-file /dev/null
--- a/drivers/isdn/sc/debug.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* $Id: debug.h,v 1.2.8.1 2001/09/23 22:24:59 kai Exp $
- *
- * Copyright (C) 1996  SpellCaster Telecommunications Inc.
- *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- *
- * For more information, please contact gpl-info@spellcast.com or write:
- *
- *     SpellCaster Telecommunications Inc.
- *     5621 Finch Avenue East, Unit #3
- *     Scarborough, Ontario  Canada
- *     M1B 2T9
- *     +1 (416) 297-8565
- *     +1 (416) 297-6433 Facsimile
- */
-
-#define REQUEST_IRQ(a,b,c,d,e) request_irq(a,b,c,d,e)
-#define FREE_IRQ(a,b) free_irq(a,b)
diff -puN drivers/isdn/sc/includes.h~isdn-sc-remove-unused-request_irq-and-unnecessary-header-file drivers/isdn/sc/includes.h
--- a/drivers/isdn/sc/includes.h~isdn-sc-remove-unused-request_irq-and-unnecessary-header-file
+++ a/drivers/isdn/sc/includes.h
@@ -14,4 +14,3 @@
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/isdnif.h>
-#include "debug.h"
diff -puN drivers/isdn/sc/init.c~isdn-sc-remove-unused-request_irq-and-unnecessary-header-file drivers/isdn/sc/init.c
--- a/drivers/isdn/sc/init.c~isdn-sc-remove-unused-request_irq-and-unnecessary-header-file
+++ a/drivers/isdn/sc/init.c
@@ -404,7 +404,7 @@ static void __exit sc_exit(void)
 		/*
 		 * Release the IRQ
 		 */
-		FREE_IRQ(sc_adapter[i]->interrupt, NULL);
+		free_irq(sc_adapter[i]->interrupt, NULL);
 
 		/*
 		 * Reset for a clean start
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch
kmap-leak-fix-for-x86_32-kdump.patch
make-smart-battery-system-depend-on-acpi_sbs.patch
isdn-sc-remove-unused-request_irq-and-unnecessary-header-file.patch
