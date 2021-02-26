Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6425FC433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A79964F31
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhBZBSG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhBZBRm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5252E64F0D;
        Fri, 26 Feb 2021 01:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302246;
        bh=CGtOD+IzPy66+TZrfR/zSeXT1JYb6TVBFEP21I+GqkY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=saqMZHOkM6w2wtERPtnegk8b3cjdqf6uaQfkZCC2CMP9jJsApnKe3aoIdWZQRdE39
         9t4VlJ6p+VR3oExXsSeosscIKio1RBV5AcWXOK+QSXjC3bhdK04H/u6Znoy+6aSLt7
         6Q1yI688ge5MOQDczuVtNn8Ym7P+O2JFIV0RFSuM=
Date:   Thu, 25 Feb 2021 17:17:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, dave.hansen@intel.com,
        david@redhat.com, geert+renesas@glider.be,
        gerald.schaefer@linux.ibm.com, gregkh@linuxfoundation.org,
        idryomov@gmail.com, linux-mm@kvack.org, mchehab+huawei@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rafael@kernel.org, torvalds@linux-foundation.org, trix@redhat.com,
        vaibhav@linux.ibm.com
Subject:  [patch 033/118] drivers/base/memory: don't store
 phys_device in memory blocks
Message-ID: <20210226011724.3Im85NzHx%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory: don't store phys_device in memory blocks

No need to store the value for each and every memory block, as we can
easily query the value at runtime.  Reshuffle the members to optimize the
memory layout.  Also, let's clarify what the interface once was used for
and why it's legacy nowadays.

"phys_device" was used on s390x in older versions of lsmem[2]/chmem[3],
back when they were still part of s390x-tools.  They were later replaced
by the variants in linux-utils.  For example, RHEL6 and RHEL7 contain
lsmem/chmem from s390-utils.  RHEL8 switched to versions from util-linux
on s390x [4].

"phys_device" was added with sysfs support for memory hotplug in commit
3947be1969a9 ("[PATCH] memory hotplug: sysfs and add/remove functions") in
2005.  It always returned 0.

s390x started returning something != 0 on some setups (if sclp.rzm is set
by HW) in 2010 via commit 57b552ba0b2f ("memory hotplug/s390: set
phys_device").

For s390x, it allowed for identifying which memory block devices belong to
the same storage increment (RZM).  Only if all memory block devices
comprising a single storage increment were offline, the memory could
actually be removed in the hypervisor.

Since commit e5d709bb5fb7 ("s390/memory hotplug: provide
memory_block_size_bytes() function") in 2013 a memory block device spans
at least one storage increment - which is why the interface isn't really
helpful/used anymore (except by old lsmem/chmem tools).

There were once RFC patches to make use of "phys_device" in ACPI context;
however, the underlying problem could be solved using different interfaces
[1].

[1] https://patchwork.kernel.org/patch/2163871/
[2] https://github.com/ibm-s390-tools/s390-tools/blob/v2.1.0/zconf/lsmem
[3] https://github.com/ibm-s390-tools/s390-tools/blob/v2.1.0/zconf/chmem
[4] https://bugzilla.redhat.com/show_bug.cgi?id=1504134

Link: https://lkml.kernel.org/r/20210201181347.13262-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-memory  |    5 +-
 Documentation/admin-guide/mm/memory-hotplug.rst |    4 +-
 drivers/base/memory.c                           |   25 +++++---------
 include/linux/memory.h                          |    3 -
 4 files changed, 15 insertions(+), 22 deletions(-)

--- a/Documentation/ABI/testing/sysfs-devices-memory~drivers-base-memory-dont-store-phys_device-in-memory-blocks
+++ a/Documentation/ABI/testing/sysfs-devices-memory
@@ -26,8 +26,9 @@ Date:		September 2008
 Contact:	Badari Pulavarty <pbadari@us.ibm.com>
 Description:
 		The file /sys/devices/system/memory/memoryX/phys_device
-		is read-only and is designed to show the name of physical
-		memory device.  Implementation is currently incomplete.
+		is read-only;  it is a legacy interface only ever used on s390x
+		to expose the covered storage increment.
+Users:		Legacy s390-tools lsmem/chmem
 
 What:		/sys/devices/system/memory/memoryX/phys_index
 Date:		September 2008
--- a/Documentation/admin-guide/mm/memory-hotplug.rst~drivers-base-memory-dont-store-phys_device-in-memory-blocks
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -160,8 +160,8 @@ Under each memory block, you can see 5 f
 
                     "online_movable", "online", "offline" command
                     which will be performed on all sections in the block.
-``phys_device``     read-only: designed to show the name of physical memory
-                    device.  This is not well implemented now.
+``phys_device``	    read-only: legacy interface only ever used on s390x to
+		    expose the covered storage increment.
 ``removable``       read-only: contains an integer value indicating
                     whether the memory block is removable or not
                     removable.  A value of 1 indicates that the memory
--- a/drivers/base/memory.c~drivers-base-memory-dont-store-phys_device-in-memory-blocks
+++ a/drivers/base/memory.c
@@ -290,20 +290,20 @@ static ssize_t state_store(struct device
 }
 
 /*
- * phys_device is a bad name for this.  What I really want
- * is a way to differentiate between memory ranges that
- * are part of physical devices that constitute
- * a complete removable unit or fru.
- * i.e. do these ranges belong to the same physical device,
- * s.t. if I offline all of these sections I can then
- * remove the physical device?
+ * Legacy interface that we cannot remove: s390x exposes the storage increment
+ * covered by a memory block, allowing for identifying which memory blocks
+ * comprise a storage increment. Since a memory block spans complete
+ * storage increments nowadays, this interface is basically unused. Other
+ * archs never exposed != 0.
  */
 static ssize_t phys_device_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct memory_block *mem = to_memory_block(dev);
+	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 
-	return sysfs_emit(buf, "%d\n", mem->phys_device);
+	return sysfs_emit(buf, "%d\n",
+			  arch_get_memory_phys_device(start_pfn));
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
@@ -488,11 +488,7 @@ static DEVICE_ATTR_WO(soft_offline_page)
 static DEVICE_ATTR_WO(hard_offline_page);
 #endif
 
-/*
- * Note that phys_device is optional.  It is here to allow for
- * differentiation between which *physical* devices each
- * section belongs to...
- */
+/* See phys_device_show(). */
 int __weak arch_get_memory_phys_device(unsigned long start_pfn)
 {
 	return 0;
@@ -574,7 +570,6 @@ int register_memory(struct memory_block
 static int init_memory_block(unsigned long block_id, unsigned long state)
 {
 	struct memory_block *mem;
-	unsigned long start_pfn;
 	int ret = 0;
 
 	mem = find_memory_block_by_id(block_id);
@@ -588,8 +583,6 @@ static int init_memory_block(unsigned lo
 
 	mem->start_section_nr = block_id * sections_per_block;
 	mem->state = state;
-	start_pfn = section_nr_to_pfn(mem->start_section_nr);
-	mem->phys_device = arch_get_memory_phys_device(start_pfn);
 	mem->nid = NUMA_NO_NODE;
 
 	ret = register_memory(mem);
--- a/include/linux/memory.h~drivers-base-memory-dont-store-phys_device-in-memory-blocks
+++ a/include/linux/memory.h
@@ -27,9 +27,8 @@ struct memory_block {
 	unsigned long start_section_nr;
 	unsigned long state;		/* serialized by the dev->lock */
 	int online_type;		/* for passing data to online routine */
-	int phys_device;		/* to which fru does this belong? */
-	struct device dev;
 	int nid;			/* NID for this memory block */
+	struct device dev;
 };
 
 int arch_get_memory_phys_device(unsigned long start_pfn);
_
