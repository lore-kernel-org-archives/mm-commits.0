From: akpm@linux-foundation.org
Subject: - old-buffer-overflow-in-moxa-driver.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:16 -0700
Message-ID: <200705090252.l492qGQ2009553@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031772AbXEICwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, dilinger@debian.org, mm-commits@vger.kernel.org


The patch titled
     old buffer overflow in moxa driver
has been removed from the -mm tree.  Its filename was
     old-buffer-overflow-in-moxa-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andres Salomon <dilinger@debian.org>
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

origin.patch
