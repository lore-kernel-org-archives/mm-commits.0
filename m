From: akpm@linux-foundation.org
Subject: [folded] kdump-add-udev-events-for-memory-online-offline-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:57:47 -0800
Message-ID: <20120113005748.5200F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:50202 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab2AMA5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:57:50 -0500
Received: by wgbdt14 with SMTP id dt14so80379wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:57:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, greg@kroah.com, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump-add-udev-events-for-memory-online-offline-fix.txt
has been removed from the -mm tree.  Its filename was
     kdump-add-udev-events-for-memory-online-offline-fix.patch

This patch was dropped because it was folded into kdump-add-udev-events-for-memory-online-offline.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kdump-add-udev-events-for-memory-online-offline-fix.txt

memory: fix ups for class to subsystem conversion

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline-fix drivers/base/memory.c
--- a/drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline-fix
+++ a/drivers/base/memory.c
@@ -303,10 +303,10 @@ static int memory_block_change_state(str
 	mem->state = to_state;
 	switch (mem->state) {
 	case MEM_OFFLINE:
-		kobject_uevent(&mem->sysdev.kobj, KOBJ_OFFLINE);
+		kobject_uevent(&mem->dev.kobj, KOBJ_OFFLINE);
 		break;
 	case MEM_ONLINE:
-		kobject_uevent(&mem->sysdev.kobj, KOBJ_ONLINE);
+		kobject_uevent(&mem->dev.kobj, KOBJ_ONLINE);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
kdump-add-udev-events-for-memory-online-offline.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

