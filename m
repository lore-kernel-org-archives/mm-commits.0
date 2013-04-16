From: akpm@linux-foundation.org
Subject: + firmware-memmap-fix-firmware_map_entry-leak.patch added to -mm tree
Date: Tue, 16 Apr 2013 14:09:18 -0700
Message-ID: <20130416210918.934655A4145@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:45480 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965335Ab3DPVJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 17:09:20 -0400
Received: by mail-gg0-f201.google.com with SMTP id q6so95007ggc.4
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 14:09:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, greg@kroah.com, liwanp@linux.vnet.ibm.com, tangchen@cn.fujitsu.com, toshi.kani@hp.com, wency@cn.fujitsu.com


The patch titled
     Subject: firmware, memmap: fix firmware_map_entry leak
has been added to the -mm tree.  Its filename is
     firmware-memmap-fix-firmware_map_entry-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: firmware, memmap: fix firmware_map_entry leak

When hot removing memory, a firmware_map_entry which has memory range of
the memory is released by release_firmware_map_entry().  If the entry is
allocated by bootmem, release_firmware_map_entry() adds the entry to
map_entires_bootmem list when firmware_map_find_entry() finds the entry
from map_entries list.  But firmware_map_find_entry never find the entry
sicne map_entires list does not have the entry.  So the entry just leaks.

Here are steps of leaking firmware_map_entry:
firmware_map_remove()
-> firmware_map_find_entry()
   Find released entry from map_entries list
-> firmware_map_remove_entry()
   Delete the entry from map_entries list
-> remove_sysfs_fw_map_entry()
   ...
   -> release_firmware_map_entry()
      -> firmware_map_find_entry()
         Find the entry from map_entries list but the entry has been
         deleted from map_entries list. So the entry is not added
         to map_entries_bootmem. Thus the entry leaks

release_firmware_map_entry() should not call firmware_map_find_entry()
since releaed entry has been deleted from map_entries list.  So the patch
delete firmware_map_find_entry() from releae_firmware_map_entry()

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/firmware/memmap.c~firmware-memmap-fix-firmware_map_entry-leak drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware-memmap-fix-firmware_map_entry-leak
+++ a/drivers/firmware/memmap.c
@@ -114,12 +114,9 @@ static void __meminit release_firmware_m
 		 * map_entries_bootmem here, and deleted from &map_entries in
 		 * firmware_map_remove_entry().
 		 */
-		if (firmware_map_find_entry(entry->start, entry->end,
-		    entry->type)) {
-			spin_lock(&map_entries_bootmem_lock);
-			list_add(&entry->list, &map_entries_bootmem);
-			spin_unlock(&map_entries_bootmem_lock);
-		}
+		spin_lock(&map_entries_bootmem_lock);
+		list_add(&entry->list, &map_entries_bootmem);
+		spin_unlock(&map_entries_bootmem_lock);
 
 		return;
 	}
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch
mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled.patch
firmware-memmap-fix-firmware_map_entry-leak.patch

