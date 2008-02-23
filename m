From: akpm@linux-foundation.org
Subject: - register_memory-unregister_memory-fix-use-after-free-and-refcounting.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:51 -0800
Message-ID: <200802232023.m1NKNpu8013580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761676AbYBWU3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, apw@shadowen.org, gregkh@suse.de, kay.sievers@vrfy.org, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     register_memory/unregister_memory: fix use-after-free and refcounting
has been removed from the -mm tree.  Its filename was
     register_memory-unregister_memory-fix-use-after-free-and-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: register_memory/unregister_memory: fix use-after-free and refcounting
From: Badari Pulavarty <pbadari@us.ibm.com>

register_memory()/unregister_memory() never gets called with "root". 
unregister_memory() is accessing kobject_name of the object just freed up. 
Since no one uses the code, lets take the code out.  And also, make
register_memory() static.

Another bug fix - before calling unregister_memory() remove_memory_block()
gets a ref on kobject.  unregister_memory() need to drop that ref before
calling sysdev_unregister().

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN drivers/base/memory.c~register_memory-unregister_memory-fix-use-after-free-and-refcounting drivers/base/memory.c
--- a/drivers/base/memory.c~register_memory-unregister_memory-fix-use-after-free-and-refcounting
+++ a/drivers/base/memory.c
@@ -62,8 +62,8 @@ void unregister_memory_notifier(struct n
 /*
  * register_memory - Setup a sysfs device for a memory block
  */
-int register_memory(struct memory_block *memory, struct mem_section *section,
-		struct node *root)
+static
+int register_memory(struct memory_block *memory, struct mem_section *section)
 {
 	int error;
 
@@ -71,26 +71,18 @@ int register_memory(struct memory_block 
 	memory->sysdev.id = __section_nr(section);
 
 	error = sysdev_register(&memory->sysdev);
-
-	if (root && !error)
-		error = sysfs_create_link(&root->sysdev.kobj,
-					  &memory->sysdev.kobj,
-					  kobject_name(&memory->sysdev.kobj));
-
 	return error;
 }
 
 static void
-unregister_memory(struct memory_block *memory, struct mem_section *section,
-		struct node *root)
+unregister_memory(struct memory_block *memory, struct mem_section *section)
 {
 	BUG_ON(memory->sysdev.cls != &memory_sysdev_class);
 	BUG_ON(memory->sysdev.id != __section_nr(section));
 
+	/* drop the ref. we got in remove_memory_block() */
+	kobject_put(&memory->sysdev.kobj);
 	sysdev_unregister(&memory->sysdev);
-	if (root)
-		sysfs_remove_link(&root->sysdev.kobj,
-				  kobject_name(&memory->sysdev.kobj));
 }
 
 /*
@@ -345,7 +337,7 @@ static int add_memory_block(unsigned lon
 	mutex_init(&mem->state_mutex);
 	mem->phys_device = phys_device;
 
-	ret = register_memory(mem, section, NULL);
+	ret = register_memory(mem, section);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_index);
 	if (!ret)
@@ -396,7 +388,7 @@ int remove_memory_block(unsigned long no
 	mem_remove_simple_file(mem, phys_index);
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
-	unregister_memory(mem, section, NULL);
+	unregister_memory(mem, section);
 
 	return 0;
 }
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
fs-aioc-make-3-functions-static.patch
