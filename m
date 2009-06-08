From: akpm@linux-foundation.org
Subject: + firmware_map-fix-hang-with-x86-32bit.patch added to -mm tree
Date: Mon, 08 Jun 2009 15:53:18 -0700
Message-ID: <200906082253.n58MrJZF016335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbZFHWyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 18:54:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, hpa@zytor.com, mingo@elte.hu, pchen@nvidia.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     firmware_map: fix hang with x86/32bit
has been added to the -mm tree.  Its filename is
     firmware_map-fix-hang-with-x86-32bit.patch

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

Reported-and-tested-by: Peer Chen <pchen@nvidia.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c    |   12 +++++-------
 include/linux/firmware-map.h |   12 ++++--------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff -puN drivers/firmware/memmap.c~firmware_map-fix-hang-with-x86-32bit drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware_map-fix-hang-with-x86-32bit
+++ a/drivers/firmware/memmap.c
@@ -31,8 +31,8 @@
  * information is necessary as for the resource tree.
  */
 struct firmware_map_entry {
-	resource_size_t		start;	/* start of the memory range */
-	resource_size_t		end;	/* end of the memory range (incl.) */
+	u64			start;	/* start of the memory range */
+	u64			end;	/* end of the memory range (incl.) */
 	const char		*type;	/* type of the memory range */
 	struct list_head	list;	/* entry for the linked list */
 	struct kobject		kobj;   /* kobject for each entry */
@@ -101,7 +101,7 @@ static LIST_HEAD(map_entries);
  * Common implementation of firmware_map_add() and firmware_map_add_early()
  * which expects a pre-allocated struct firmware_map_entry.
  **/
-static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
+static int firmware_map_add_entry(u64 start, u64 end,
 				  const char *type,
 				  struct firmware_map_entry *entry)
 {
@@ -132,8 +132,7 @@ static int firmware_map_add_entry(resour
  *
  * Returns 0 on success, or -ENOMEM if no memory could be allocated.
  **/
-int firmware_map_add(resource_size_t start, resource_size_t end,
-		     const char *type)
+int firmware_map_add(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
@@ -157,8 +156,7 @@ int firmware_map_add(resource_size_t sta
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

linux-next.patch
firmware_map-fix-hang-with-x86-32bit.patch
firmware_map-fix-hang-with-x86-32bit-fix.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch

