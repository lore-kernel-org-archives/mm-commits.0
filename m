From: akpm@linux-foundation.org
Subject: + firmware-memmap-cleanup.patch added to -mm tree
Date: Wed, 30 Jul 2008 13:40:38 -0700
Message-ID: <200807302040.m6UKecbb015887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941AbYG3UlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 16:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de


The patch titled
     firmware/memmap: cleanup
has been added to the -mm tree.  Its filename is
     firmware-memmap-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware/memmap: cleanup
From: Bernhard Walle <bwalle@suse.de>

Various cleanup the drivers/firmware/memmap (after review by AKPM):

    - fix kdoc to conform to the standard
    - move kdoc from header to implementation files
    - remove superfluous WARN_ON() after kmalloc()
    - WARN_ON(x); if (!x) -> if(!WARN_ON(x))
    - improve some comments

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c    |   61 +++++++++++++++++++++++----------
 include/linux/firmware-map.h |   26 --------------
 2 files changed, 43 insertions(+), 44 deletions(-)

diff -puN drivers/firmware/memmap.c~firmware-memmap-cleanup drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware-memmap-cleanup
+++ a/drivers/firmware/memmap.c
@@ -84,20 +84,23 @@ static struct kobj_type memmap_ktype = {
  */
 
 /*
- * Firmware memory map entries
+ * Firmware memory map entries. No locking is needed because the
+ * firmware_map_add() and firmware_map_add_early() functions are called
+ * in firmware initialisation code in one single thread of execution.
  */
 static LIST_HEAD(map_entries);
 
 /**
- * Common implementation of firmware_map_add() and firmware_map_add_early()
- * which expects a pre-allocated struct firmware_map_entry.
- *
+ * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
  * @start: Start of the memory range.
  * @end:   End of the memory range (inclusive).
  * @type:  Type of the memory range.
  * @entry: Pre-allocated (either kmalloc() or bootmem allocator), uninitialised
  *         entry.
- */
+ *
+ * Common implementation of firmware_map_add() and firmware_map_add_early()
+ * which expects a pre-allocated struct firmware_map_entry.
+ **/
 static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
 				  const char *type,
 				  struct firmware_map_entry *entry)
@@ -115,33 +118,52 @@ static int firmware_map_add_entry(resour
 	return 0;
 }
 
-/*
- * See <linux/firmware-map.h> for documentation.
- */
+/**
+ * firmware_map_add() - Adds a firmware mapping entry.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (inclusive).
+ * @type:  Type of the memory range.
+ *
+ * This function uses kmalloc() for memory
+ * allocation. Use firmware_map_add_early() if you want to use the bootmem
+ * allocator.
+ *
+ * That function must be called before late_initcall.
+ *
+ * Returns 0 on success, or -ENOMEM if no memory could be allocated.
+ **/
 int firmware_map_add(resource_size_t start, resource_size_t end,
 		     const char *type)
 {
 	struct firmware_map_entry *entry;
 
 	entry = kmalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
-	WARN_ON(!entry);
 	if (!entry)
 		return -ENOMEM;
 
 	return firmware_map_add_entry(start, end, type, entry);
 }
 
-/*
- * See <linux/firmware-map.h> for documentation.
- */
+/**
+ * firmware_map_add_early() - Adds a firmware mapping entry.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (inclusive).
+ * @type:  Type of the memory range.
+ *
+ * Adds a firmware mapping entry. This function uses the bootmem allocator
+ * for memory allocation. Use firmware_map_add() if you want to use kmalloc().
+ *
+ * That function must be called before late_initcall.
+ *
+ * Returns 0 on success, or -ENOMEM if no memory could be allocated.
+ **/
 int __init firmware_map_add_early(resource_size_t start, resource_size_t end,
 				  const char *type)
 {
 	struct firmware_map_entry *entry;
 
 	entry = alloc_bootmem_low(sizeof(struct firmware_map_entry));
-	WARN_ON(!entry);
-	if (!entry)
+	if (WARN_ON(!entry))
 		return -ENOMEM;
 
 	return firmware_map_add_entry(start, end, type, entry);
@@ -183,7 +205,10 @@ static ssize_t memmap_attr_show(struct k
 /*
  * Initialises stuff and adds the entries in the map_entries list to
  * sysfs. Important is that firmware_map_add() and firmware_map_add_early()
- * must be called before late_initcall.
+ * must be called before late_initcall. That's just because that function
+ * is called as late_initcall() function, which means that if you call
+ * firmware_map_add() or firmware_map_add_early() afterwards, the entries
+ * are not added to sysfs.
  */
 static int __init memmap_init(void)
 {
@@ -192,13 +217,13 @@ static int __init memmap_init(void)
 	struct kset *memmap_kset;
 
 	memmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
-	WARN_ON(!memmap_kset);
-	if (!memmap_kset)
+	if (WARN_ON(!memmap_kset))
 		return -ENOMEM;
 
 	list_for_each_entry(entry, &map_entries, list) {
 		entry->kobj.kset = memmap_kset;
-		kobject_add(&entry->kobj, NULL, "%d", i++);
+		if (kobject_add(&entry->kobj, NULL, "%d", i++))
+			kobject_put(&entry->kobj);
 	}
 
 	return 0;
diff -puN include/linux/firmware-map.h~firmware-memmap-cleanup include/linux/firmware-map.h
--- a/include/linux/firmware-map.h~firmware-memmap-cleanup
+++ a/include/linux/firmware-map.h
@@ -24,34 +24,8 @@
  */
 #ifdef CONFIG_FIRMWARE_MEMMAP
 
-/**
- * Adds a firmware mapping entry. This function uses kmalloc() for memory
- * allocation. Use firmware_map_add_early() if you want to use the bootmem
- * allocator.
- *
- * That function must be called before late_initcall.
- *
- * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
- * @type:  Type of the memory range.
- *
- * Returns 0 on success, or -ENOMEM if no memory could be allocated.
- */
 int firmware_map_add(resource_size_t start, resource_size_t end,
 		     const char *type);
