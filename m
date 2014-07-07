From: akpm@linux-foundation.org
Subject: +
 firmware-memmap-pass-the-correct-argument-to-firmware_map_find_entry_bootmem.patch added to -mm tree
Date: Mon, 07 Jul 2014 14:31:37 -0700
Message-ID: <53bb11b9.sKFGIrzY4p+yx6I8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:53676 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaGGVbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 17:31:38 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1063246pab.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 14:31:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, gregkh@linuxfoundation.org, santosh.shilimkar@ti.com, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/memmap.c: pass the correct argument to firmware_map_find_entry_bootmem()
has been added to the -mm tree.  Its filename is
     firmware-memmap-pass-the-correct-argument-to-firmware_map_find_entry_bootmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-memmap-pass-the-correct-argument-to-firmware_map_find_entry_bootmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-memmap-pass-the-correct-argument-to-firmware_map_find_entry_bootmem.patch

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

x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes.patch
mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch
mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch
firmware-memmap-pass-the-correct-argument-to-firmware_map_find_entry_bootmem.patch
dont-allocate-firmware_map_entry-of-same-memory-range.patch

