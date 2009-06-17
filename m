From: akpm@linux-foundation.org
Subject: [merged] firmware_map-fix-hang-with-x86-32bit.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:24 -0700
Message-ID: <200906171832.n5HIWOg4030967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758252AbZFQSdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, hpa@zytor.com, mingo@elte.hu, pchen@nvidia.com, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     firmware_map: fix hang with x86/32bit
has been removed from the -mm tree.  Its filename was
     firmware_map-fix-hang-with-x86-32bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware_map: fix hang with x86/32bit
From: Yinghai Lu <yinghai@kernel.org>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13484

Peer reported:
| The bug is introduced from kernel 2.6.27, if E820 table reserve the memory
| above 4G in 32bit OS(BIOS-e820: 00000000fff80000 - 0000000120000000
| (reserved)), system will report Int 6 error and hang up. The bug is caused by
| the following code in drivers/firmware/memmap.c, the resource_size_t is 32bit
| variable in 32bit OS, the BUG_ON() will be invoked to result in the Int 6
| error. I try the latest 32bit Ubuntu and Fedora distributions, all hit this
| bug.
|======
|static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
|                  const char *type,
|                  struct firmware_map_entry *entry)

and it only happen with CONFIG_PHYS_ADDR_T_64BIT is not set.

it turns out we need to pass u64 instead of resource_size_t for that.

[akpm@linux-foundation.org: add comment]
Reported-and-tested-by: Peer Chen <pchen@nvidia.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c    |   16 +++++++++-------
 include/linux/firmware-map.h |   12 ++++--------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff -puN drivers/firmware/memmap.c~firmware_map-fix-hang-with-x86-32bit drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware_map-fix-hang-with-x86-32bit
+++ a/drivers/firmware/memmap.c
@@ -31,8 +31,12 @@
  * information is necessary as for the resource tree.
  */
 struct firmware_map_entry {
-	resource_size_t		start;	/* start of the memory range */
-	resource_size_t		end;	/* end of the memory range (incl.) */
+	/*
+	 * start and end must be u64 rather than resource_size_t, because e820
+	 * resources can lie at addresses above 4G.
+	 */
+	u64			start;	/* start of the memory range */
+	u64			end;	/* end of the memory range (incl.) */
 	const char		*type;	/* type of the memory range */
 	struct list_head	list;	/* entry for the linked list */
 	struct kobject		kobj;   /* kobject for each entry */
@@ -101,7 +105,7 @@ static LIST_HEAD(map_entries);
  * Common implementation of firmware_map_add() and firmware_map_add_early()
  * which expects a pre-allocated struct firmware_map_entry.
  **/
-static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
+static int firmware_map_add_entry(u64 start, u64 end,
 				  const char *type,
 				  struct firmware_map_entry *entry)
 {
@@ -132,8 +136,7 @@ static int firmware_map_add_entry(resour
  *
  * Returns 0 on success, or -ENOMEM if no memory could be allocated.
  **/
-int firmware_map_add(resource_size_t start, resource_size_t end,
-		     const char *type)
+int firmware_map_add(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
@@ -157,8 +160,7 @@ int firmware_map_add(resource_size_t sta
  *
  * Returns 0 on success, or -ENOMEM if no memory could be allocated.
  **/
-int __init firmware_map_add_early(resource_size_t start, resource_size_t end,
-				  const char *type)
+int __init firmware_map_add_early(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
diff -puN include/linux/firmware-map.h~firmware_map-fix-hang-with-x86-32bit include/linux/firmware-map.h
--- a/include/linux/firmware-map.h~firmware_map-fix-hang-with-x86-32bit
+++ a/include/linux/firmware-map.h
@@ -24,21 +24,17 @@
  */
 #ifdef CONFIG_FIRMWARE_MEMMAP
 
-int firmware_map_add(resource_size_t start, resource_size_t end,
-		     const char *type);
-int firmware_map_add_early(resource_size_t start, resource_size_t end,
-			   const char *type);
+int firmware_map_add(u64 start, u64 end, const char *type);
+int firmware_map_add_early(u64 start, u64 end, const char *type);
 
 #else /* CONFIG_FIRMWARE_MEMMAP */
 
-static inline int firmware_map_add(resource_size_t start, resource_size_t end,
-				   const char *type)
+static inline int firmware_map_add(u64 start, u64 end, const char *type)
 {
 	return 0;
 }
 
-static inline int firmware_map_add_early(resource_size_t start,
-					 resource_size_t end, const char *type)
+static inline int firmware_map_add_early(u64 start, u64 end, const char *type)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch

