From: akpm@linux-foundation.org
Subject: [merged] kdump-add-udev-events-for-memory-online-offline.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:33 -0800
Message-ID: <20120113203634.445E820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42927 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:36 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25473eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holzheu@linux.vnet.ibm.com, ebiederm@xmission.com, greg@kroah.com, haveblue@us.ibm.com, heiko.carstens@de.ibm.com, kay.sievers@vrfy.org, schwidefsky@de.ibm.com, sfr@canb.auug.org.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: add udev events for memory online/offline
has been removed from the -mm tree.  Its filename was
     kdump-add-udev-events-for-memory-online-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: kdump: add udev events for memory online/offline

Currently no udev events for memory hotplug "online" and "offline" are
generated:

# udevadm monitor
# echo offline > /sys/devices/system/memory/memory4/state
==> No event

When kdump is loaded, kexec detects the current memory configuration and
stores it in the pre-allocated ELF core header.  Therefore, for kdump it
is necessary to reload the kdump kernel with kexec when the memory
configuration changes (e.g.  for online/offline hotplug memory).

In order to do this automatically, udev rules should be used.  This kernel
patch adds udev events for "online" and "offline".  Together with this
kernel patch, the following udev rules for online/offline have to be added
to "/etc/udev/rules.d/98-kexec.rules":

SUBSYSTEM=="memory", ACTION=="online", PROGRAM="/etc/init.d/kdump restart"
SUBSYSTEM=="memory", ACTION=="offline", PROGRAM="/etc/init.d/kdump restart"

[sfr@canb.auug.org.au: fixups for class to subsystem conversion]
Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline drivers/base/memory.c
--- a/drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline
+++ a/drivers/base/memory.c
@@ -295,11 +295,22 @@ static int memory_block_change_state(str
 
 	ret = memory_block_action(mem->start_section_nr, to_state);
 
-	if (ret)
+	if (ret) {
 		mem->state = from_state_req;
-	else
-		mem->state = to_state;
+		goto out;
+	}
 
+	mem->state = to_state;
+	switch (mem->state) {
+	case MEM_OFFLINE:
+		kobject_uevent(&mem->dev.kobj, KOBJ_OFFLINE);
+		break;
+	case MEM_ONLINE:
+		kobject_uevent(&mem->dev.kobj, KOBJ_ONLINE);
+		break;
+	default:
+		break;
+	}
 out:
 	mutex_unlock(&mem->state_mutex);
 	return ret;
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

origin.patch

