From: akpm@linux-foundation.org
Subject: +
 driver-firmware-memmap-dont-create-memmap-sysfs-of-same-firmware_map_entry.patch added to -mm tree
Date: Wed, 01 Oct 2014 13:44:03 -0700
Message-ID: <542c6793.VMDZvWUPD1A1H2qB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaJAUoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 16:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, gregkh@linuxfoundation.org, santosh.shilimkar@ti.com, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: driver/firmware/memmap: don't create memmap sysfs of same firmware_map_entry
has been added to the -mm tree.  Its filename is
     driver-firmware-memmap-dont-create-memmap-sysfs-of-same-firmware_map_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/driver-firmware-memmap-dont-create-memmap-sysfs-of-same-firmware_map_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/driver-firmware-memmap-dont-create-memmap-sysfs-of-same-firmware_map_entry.patch

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
Subject: driver/firmware/memmap: don't create memmap sysfs of same firmware_map_entry

By the following commits, we prevented from allocating firmware_map_entry
of same memory range:
  f0093ede: drivers/firmware/memmap.c: don't allocate firmware_map_entry
            of same memory range
  49c8b24d: drivers/firmware/memmap.c: pass the correct argument to
            firmware_map_find_entry_bootmem()

But it's not enough. When PNP0C80 device is added by acpi_scan_init(),
memmap sysfses of same firmware_map_entry are created twice as follows:

  # cat /sys/firmware/memmap/*/start
  0x40000000000
  0x60000000000
  0x4a837000
  0x4a83a000
  0x4a8b5000
  ...
  0x40000000000
  0x60000000000
  ...

The flows of the issues are as follows:

  1. e820_reserve_resources() allocates firmware_map_entrys of all
     memory ranges defined in e820. And, these firmware_map_entrys
     are linked with map_entries list.

     map_entries -> entry 1 -> ... -> entry N

  2. When PNP0C80 device is limited by mem= boot option, acpi_scan_init()
     added the memory device. In this case, firmware_map_add_hotplug()
     allocates firmware_map_entry and creates memmap sysfs.

     map_entries -> entry 1 -> ... -> entry N -> entry N+1
                                                 |
                                                 memmap 1

  3. firmware_memmap_init() creates memmap sysfses of firmware_map_entrys
     linked with map_entries.

     map_entries -> entry 1 -> ... -> entry N -> entry N+1
                     |                 |             |
                     memmap 2          memmap N+1    memmap 1
                                                     memmap N+2

So while hot removing the PNP0C80 device, kernel panic occurs as follows:

     BUG: unable to handle kernel paging request at 00000001003e000b
      IP: sysfs_open_file+0x46/0x2b0
      PGD 203a89fe067 PUD 0
      Oops: 0000 [#1] SMP
      ...
      Call Trace:
        do_dentry_open+0x1ef/0x2a0
        finish_open+0x31/0x40
        do_last+0x57c/0x1220
        path_openat+0xc2/0x4c0
        do_filp_open+0x4b/0xb0
        do_sys_open+0xf3/0x1f0
        SyS_open+0x1e/0x20
        system_call_fastpath+0x16/0x1b

The patch adds a check of confirming whether memmap sysfs of
firmware_map_entry has been created, and does not create memmap
sysfs of same firmware_map_entry.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/firmware/memmap.c~driver-firmware-memmap-dont-create-memmap-sysfs-of-same-firmware_map_entry drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~driver-firmware-memmap-dont-create-memmap-sysfs-of-same-firmware_map_entry
+++ a/drivers/firmware/memmap.c
@@ -184,6 +184,9 @@ static int add_sysfs_fw_map_entry(struct
 	static int map_entries_nr;
 	static struct kset *mmap_kset;
 
+	if (entry->kobj.state_in_sysfs)
+		return -EEXIST;
+
 	if (!mmap_kset) {
 		mmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
 		if (!mmap_kset)
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

memory-hotplug-add-sysfs-zones_online_to-attribute.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch
driver-firmware-memmap-dont-create-memmap-sysfs-of-same-firmware_map_entry.patch
linux-next.patch

