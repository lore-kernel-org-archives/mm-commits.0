From: akpm@linux-foundation.org
Subject: [merged] drivers-firmware-memmapc-fix-kernel-doc-format.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:22 -0700
Message-ID: <5591af16.NEsbGejOt1c5mMub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbbF2Us0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.simek@xilinx.com, isimatu.yasuaki@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/memmap.c: fix kernel-doc format
has been removed from the -mm tree.  Its filename was
     drivers-firmware-memmapc-fix-kernel-doc-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: drivers/firmware/memmap.c: fix kernel-doc format

Fix kernel-doc format validation to be able to use kernel-doc script for
checking it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN drivers/firmware/memmap.c~drivers-firmware-memmapc-fix-kernel-doc-format drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~drivers-firmware-memmapc-fix-kernel-doc-format
+++ a/drivers/firmware/memmap.c
@@ -144,7 +144,9 @@ static struct kobj_type __refdata memmap
  *
  * Common implementation of firmware_map_add() and firmware_map_add_early()
  * which expects a pre-allocated struct firmware_map_entry.
- **/
+ *
+ * Return: 0 always
+ */
 static int firmware_map_add_entry(u64 start, u64 end,
 				  const char *type,
 				  struct firmware_map_entry *entry)
@@ -170,7 +172,7 @@ static int firmware_map_add_entry(u64 st
  * @entry: removed entry.
  *
  * The caller must hold map_entries_lock, and release it properly.
- **/
+ */
 static inline void firmware_map_remove_entry(struct firmware_map_entry *entry)
 {
 	list_del(&entry->list);
@@ -208,7 +210,7 @@ static inline void remove_sysfs_fw_map_e
 	kobject_put(&entry->kobj);
 }
 
-/*
+/**
  * firmware_map_find_entry_in_list() - Search memmap entry in a given list.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
@@ -236,7 +238,7 @@ firmware_map_find_entry_in_list(u64 star
 	return NULL;
 }
 
-/*
+/**
  * firmware_map_find_entry() - Search memmap entry in map_entries.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
@@ -254,7 +256,7 @@ firmware_map_find_entry(u64 start, u64 e
 	return firmware_map_find_entry_in_list(start, end, type, &map_entries);
 }
 
-/*
+/**
  * firmware_map_find_entry_bootmem() - Search memmap entry in map_entries_bootmem.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
@@ -283,8 +285,8 @@ firmware_map_find_entry_bootmem(u64 star
  * similar to function firmware_map_add_early(). The only difference is that
  * it will create the syfs entry dynamically.
  *
- * Returns 0 on success, or -ENOMEM if no memory could be allocated.
- **/
+ * Return: 0 on success, or -ENOMEM if no memory could be allocated.
+ */
 int __meminit firmware_map_add_hotplug(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
@@ -325,8 +327,8 @@ int __meminit firmware_map_add_hotplug(u
  *
  * That function must be called before late_initcall.
  *
- * Returns 0 on success, or -ENOMEM if no memory could be allocated.
- **/
+ * Return: 0 on success, or -ENOMEM if no memory could be allocated.
+ */
 int __init firmware_map_add_early(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
@@ -346,8 +348,8 @@ int __init firmware_map_add_early(u64 st
  *
  * removes a firmware mapping entry.
  *
- * Returns 0 on success, or -EINVAL if no entry.
- **/
+ * Return: 0 on success, or -EINVAL if no entry.
+ */
 int __meminit firmware_map_remove(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

origin.patch
linux-next.patch

