From: akpm@linux-foundation.org
Subject: + kdump-add-udev-events-for-memory-online-offline-fix.patch added to -mm tree
Date: Thu, 05 Jan 2012 15:49:44 -0800
Message-ID: <20120105234945.321145C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43968 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab2AEXtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2012 18:49:47 -0500
Received: by eaak10 with SMTP id k10so29426eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 05 Jan 2012 15:49:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, greg@kroah.com, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, kay.sievers@vrfy.org


The patch titled
     Subject: kdump-add-udev-events-for-memory-online-offline-fix.txt
has been added to the -mm tree.  Its filename is
     kdump-add-udev-events-for-memory-online-offline-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: kdump-add-udev-events-for-memory-online-offline-fix.txt

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch
consolidate-config_debug_strict_user_copy_checks.patch
kdump-add-udev-events-for-memory-online-offline-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

