From: akpm@linux-foundation.org
Subject: + kdump-add-udev-events-for-memory-online-offline.patch added to -mm tree
Date: Fri, 28 Oct 2011 15:46:47 -0700
Message-ID: <201110282246.p9SMklxf008634@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:13411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1J1WrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holzheu@linux.vnet.ibm.com, ebiederm@xmission.com, greg@kroah.com, haveblue@us.ibm.com, heiko.carstens@de.ibm.com, kay.sievers@vrfy.org, schwidefsky@de.ibm.com, vgoyal@redhat.com


The patch titled
     Subject: kdump: Add udev events for memory online/offline
has been added to the -mm tree.  Its filename is
     kdump-add-udev-events-for-memory-online-offline.patch

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
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: kdump: Add udev events for memory online/offline

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

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline drivers/base/memory.c
--- a/drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline
+++ a/drivers/base/memory.c
@@ -332,11 +332,15 @@ store_mem_state(struct sys_device *dev,
 
 	mem = container_of(dev, struct memory_block, sysdev);
 
-	if (!strncmp(buf, "online", min((int)count, 6)))
+	if (!strncmp(buf, "online", min((int)count, 6))) {
 		ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
-	else if(!strncmp(buf, "offline", min((int)count, 7)))
+		if (ret == 0)
+			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
+	} else if (!strncmp(buf, "offline", min((int)count, 7))) {
 		ret = memory_block_change_state(mem, MEM_OFFLINE, MEM_ONLINE);
