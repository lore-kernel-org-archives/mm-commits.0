From: akpm@linux-foundation.org
Subject: + old-buffer-overflow-in-moxa-driver.patch added to -mm tree
Date: Wed, 02 May 2007 21:13:58 -0700
Message-ID: <200705030413.l434DwAT004520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767367AbXECEOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 00:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@hp.com, dilinger@debian.org


The patch titled
     old buffer overflow in moxa driver
has been added to the -mm tree.  Its filename is
     old-buffer-overflow-in-moxa-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: old buffer overflow in moxa driver
From: dann frazier <dannf@hp.com>

I noticed that the moxa input checking security bug described by
CVE-2005-0504 appears to remain unfixed upstream.

The issue is described here:
  http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2005-0504

Debian has been shipping the following patch from Andres Salomon.

(akpm: it's a privileged operation)

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/char/moxa.c~old-buffer-overflow-in-moxa-driver drivers/char/moxa.c
--- a/drivers/char/moxa.c~old-buffer-overflow-in-moxa-driver
+++ a/drivers/char/moxa.c
@@ -1582,7 +1582,7 @@ copy:
 
 	if(copy_from_user(&dltmp, argp, sizeof(struct dl_str)))
 		return -EFAULT;
-	if(dltmp.cardno < 0 || dltmp.cardno >= MAX_BOARDS)
+	if(dltmp.cardno < 0 || dltmp.cardno >= MAX_BOARDS || dltmp.len < 0)
 		return -EINVAL;
 
 	switch(cmd)
@@ -2529,6 +2529,8 @@ static int moxaloadbios(int cardno, unsi
 	void __iomem *baseAddr;
 	int i;
 
+	if(len < 0 || len > sizeof(moxaBuff))
+		return -EINVAL;
 	if(copy_from_user(moxaBuff, tmp, len))
 		return -EFAULT;
 	baseAddr = moxa_boards[cardno].basemem;
@@ -2576,7 +2578,7 @@ static int moxaload320b(int cardno, unsi
 	void __iomem *baseAddr;
 	int i;
 
-	if(len > sizeof(moxaBuff))
+	if(len < 0 || len > sizeof(moxaBuff))
 		return -EINVAL;
 	if(copy_from_user(moxaBuff, tmp, len))
 		return -EFAULT;
@@ -2596,6 +2598,8 @@ static int moxaloadcode(int cardno, unsi
 	void __iomem *baseAddr, *ofsAddr;
 	int retval, port, i;
 
+	if(len < 0 || len > sizeof(moxaBuff))
+		return -EINVAL;
 	if(copy_from_user(moxaBuff, tmp, len))
 		return -EFAULT;
 	baseAddr = moxa_boards[cardno].basemem;
_

Patches currently in -mm which might be from dannf@hp.com are

old-buffer-overflow-in-moxa-driver.patch
