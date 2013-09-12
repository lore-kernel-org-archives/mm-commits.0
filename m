From: akpm@linux-foundation.org
Subject: [merged] mm-hotplug-verify-hotplug-memory-range.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:43:55 -0700
Message-ID: <5232197b.L03wCpBO+XSoYHvy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3ILTn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, toshi.kani@hp.com

Subject: [merged] mm-hotplug-verify-hotplug-memory-range.patch removed from -mm tree
To: toshi.kani@hp.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:55 -0700


The patch titled
     Subject: mm/hotplug: verify hotplug memory range
has been removed from the -mm tree.  Its filename was
     mm-hotplug-verify-hotplug-memory-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm/hotplug: verify hotplug memory range

add_memory() and remove_memory() can only handle a memory range aligned
with section.  There are problems when an unaligned range is added and
then deleted as follows:

 - add_memory() with an unaligned range succeeds, but __add_pages()
   called from add_memory() adds a whole section of pages even though
   a given memory range is less than the section size.
 - remove_memory() to the added unaligned range hits BUG_ON() in
   __remove_pages().

This patch changes add_memory() and remove_memory() to check if a given
memory range is aligned with section at the beginning.  As the result,
add_memory() fails with -EINVAL when a given range is unaligned, and does
not add such memory range.  This prevents remove_memory() to be called
with an unaligned range as well.  Note that remove_memory() has to use
BUG_ON() since this function cannot fail.

[akpm@linux-foundation.org: avoid printk warnings]
Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN mm/memory_hotplug.c~mm-hotplug-verify-hotplug-memory-range mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-verify-hotplug-memory-range
+++ a/mm/memory_hotplug.c
@@ -1070,6 +1070,23 @@ out:
 	return ret;
 }
 
+static int check_hotplug_memory_range(u64 start, u64 size)
+{
+	u64 start_pfn = start >> PAGE_SHIFT;
+	u64 nr_pages = size >> PAGE_SHIFT;
+
+	/* Memory range must be aligned with section */
+	if ((start_pfn & ~PAGE_SECTION_MASK) ||
+	    (nr_pages % PAGES_PER_SECTION) || (!nr_pages)) {
+		pr_err("Section-unaligned hotplug range: start 0x%llx, size 0x%llx\n",
+				(unsigned long long)start,
+				(unsigned long long)size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 int __ref add_memory(int nid, u64 start, u64 size)
 {
@@ -1079,6 +1096,10 @@ int __ref add_memory(int nid, u64 start,
 	struct resource *res;
 	int ret;
 
+	ret = check_hotplug_memory_range(start, size);
+	if (ret)
+		return ret;
+
 	lock_memory_hotplug();
 
 	res = register_memory_resource(start, size);
@@ -1786,6 +1807,8 @@ void __ref remove_memory(int nid, u64 st
 {
 	int ret;
 
+	BUG_ON(check_hotplug_memory_range(start, size));
+
 	lock_memory_hotplug();
 
 	/*
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch

