From: akpm@linux-foundation.org
Subject: [merged]
 firmware-memmap-pass-the-correct-argument-to-firmware_map_find_entry_bootmem.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:31 -0700
Message-ID: <53e3dc0b.FPGz0DZhhe/O86Dd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:43804 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:32 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so607233qgd.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, gregkh@linuxfoundation.org, santosh.shilimkar@ti.com, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/memmap.c: pass the correct argument to firmware_map_find_entry_bootmem()
has been removed from the -mm tree.  Its filename was
     firmware-memmap-pass-the-correct-argument-to-firmware_map_find_entry_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: drivers/firmware/memmap.c: pass the correct argument to firmware_map_find_entry_bootmem()

firmware_map_add_hotplug() calls firmware_map_find_entry_bootmem() to get
free firmware_map_entry.  But end arguments is not correct.  So
firmware_map_find_entry_bootmem() cannot not find firmware_map_entry.

The patch passes the correct end argument to firmware_map_find_entry_bootmem().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/memmap.c~firmware-memmap-pass-the-correct-argument-to-firmware_map_find_entry_bootmem drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware-memmap-pass-the-correct-argument-to-firmware_map_find_entry_bootmem
+++ a/drivers/firmware/memmap.c
@@ -286,7 +286,7 @@ int __meminit firmware_map_add_hotplug(u
 {
 	struct firmware_map_entry *entry;
 
-	entry = firmware_map_find_entry_bootmem(start, end, type);
+	entry = firmware_map_find_entry_bootmem(start, end - 1, type);
 	if (!entry) {
 		entry = kzalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
 		if (!entry)
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch

