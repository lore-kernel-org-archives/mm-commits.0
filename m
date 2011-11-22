From: akpm@linux-foundation.org
Subject: + kdump-add-udev-events-for-memory-online-offline.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:46:57 -0800
Message-ID: <201111222346.pAMNkv2V028143@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:59314 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1KVXrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:47:01 -0500
Received: by wwe5 with SMTP id 5so29095wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:47:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holzheu@linux.vnet.ibm.com, ebiederm@xmission.com, greg@kroah.com, haveblue@us.ibm.com, heiko.carstens@de.ibm.com, kay.sievers@vrfy.org, schwidefsky@de.ibm.com, vgoyal@redhat.com


The patch titled
     Subject: kdump: add udev events for memory online/offline
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

 drivers/base/memory.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline drivers/base/memory.c
--- a/drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline
+++ a/drivers/base/memory.c
@@ -313,11 +313,22 @@ static int memory_block_change_state(str
 
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
+		kobject_uevent(&mem->sysdev.kobj, KOBJ_OFFLINE);
+		break;
+	case MEM_ONLINE:
+		kobject_uevent(&mem->sysdev.kobj, KOBJ_ONLINE);
+		break;
+	default:
+		break;
+	}
 out:
 	mutex_unlock(&mem->state_mutex);
 	return ret;
_
Subject: Subject: kdump: add udev events for memory online/offline

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

origin.patch
linux-next.patch
kdump-add-missing-ram-resource-in-crash_shrink_memory.patch
kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch
kdump-add-udev-events-for-memory-online-offline.patch

