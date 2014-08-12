From: akpm@linux-foundation.org
Subject: [merged]
 resource-provide-new-functions-to-walk-through-resources.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:51 -0700
Message-ID: <53ea6e77.B1OSxRi6r3wqjvg7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:53939 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbaHLTnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:52 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so1912689oif.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: resource: provide new functions to walk through resources
has been removed from the -mm tree.  Its filename was
     resource-provide-new-functions-to-walk-through-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: resource: provide new functions to walk through resources

I have added two more functions to walk through resources.

Currently walk_system_ram_range() deals with pfn and /proc/iomem can
contain partial pages.  By dealing in pfn, callback function loses the
info that last page of a memory range is a partial page and not the full
page.  So I implemented walk_system_ram_res() which returns u64 values to
callback functions and now it properly return start and end address.

walk_system_ram_range() uses find_next_system_ram() to find the next ram
resource.  This in turn only travels through siblings of top level child
and does not travers through all the nodes of the resoruce tree.  I also
need another function where I can walk through all the resources, for
example figure out where "GART" aperture is.  Figure out where ACPI memory
is.

So I wrote another function walk_iomem_res() which walks through all
/proc/iomem resources and returns matches as asked by caller.  Caller can
specify "name" of resource, start and end and flags.

Got rid of find_next_system_ram_res() and instead implemented more generic
find_next_iomem_res() which can be used to traverse top level children
only based on an argument.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    6 ++
 kernel/resource.c      |  101 +++++++++++++++++++++++++++++++++++----
 2 files changed, 98 insertions(+), 9 deletions(-)

diff -puN include/linux/ioport.h~resource-provide-new-functions-to-walk-through-resources include/linux/ioport.h
--- a/include/linux/ioport.h~resource-provide-new-functions-to-walk-through-resources
+++ a/include/linux/ioport.h
@@ -237,6 +237,12 @@ extern int iomem_is_exclusive(u64 addr);
 extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
+extern int
+walk_system_ram_res(u64 start, u64 end, void *arg,
+		    int (*func)(u64, u64, void *));
+extern int
+walk_iomem_res(char *name, unsigned long flags, u64 start, u64 end, void *arg,
+	       int (*func)(u64, u64, void *));
 
 /* True if any part of r1 overlaps r2 */
 static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
diff -puN kernel/resource.c~resource-provide-new-functions-to-walk-through-resources kernel/resource.c
--- a/kernel/resource.c~resource-provide-new-functions-to-walk-through-resources
+++ a/kernel/resource.c
@@ -59,10 +59,12 @@ static DEFINE_RWLOCK(resource_lock);
 static struct resource *bootmem_resource_free;
 static DEFINE_SPINLOCK(bootmem_resource_lock);
 
-static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+static struct resource *next_resource(struct resource *p, bool sibling_only)
 {
-	struct resource *p = v;
-	(*pos)++;
+	/* Caller wants to traverse through siblings only */
+	if (sibling_only)
+		return p->sibling;
+
 	if (p->child)
 		return p->child;
 	while (!p->sibling && p->parent)
@@ -70,6 +72,13 @@ static void *r_next(struct seq_file *m,
 	return p->sibling;
 }
 
+static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct resource *p = v;
+	(*pos)++;
+	return (void *)next_resource(p, false);
+}
+
 #ifdef CONFIG_PROC_FS
 
 enum { MAX_IORES_LEVEL = 5 };
@@ -322,16 +331,19 @@ int release_resource(struct resource *ol
 
 EXPORT_SYMBOL(release_resource);
 
-#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
 /*
- * Finds the lowest memory reosurce exists within [res->start.res->end)
+ * Finds the lowest iomem reosurce exists with-in [res->start.res->end)
  * the caller must specify res->start, res->end, res->flags and "name".
  * If found, returns 0, res is overwritten, if not found, returns -1.
+ * This walks through whole tree and not just first level children
+ * until and unless first_level_children_only is true.
  */
-static int find_next_system_ram(struct resource *res, char *name)
+static int find_next_iomem_res(struct resource *res, char *name,
+			       bool first_level_children_only)
 {
 	resource_size_t start, end;
 	struct resource *p;
+	bool sibling_only = false;
 
 	BUG_ON(!res);
 
@@ -340,8 +352,14 @@ static int find_next_system_ram(struct r
 	BUG_ON(start >= end);
 
 	read_lock(&resource_lock);
-	for (p = iomem_resource.child; p ; p = p->sibling) {
-		/* system ram is just marked as IORESOURCE_MEM */
+
+	if (first_level_children_only) {
+		p = iomem_resource.child;
+		sibling_only = true;
+	} else
+		p = &iomem_resource;
+
+	while ((p = next_resource(p, sibling_only))) {
 		if (p->flags != res->flags)
 			continue;
 		if (name && strcmp(p->name, name))
@@ -353,6 +371,7 @@ static int find_next_system_ram(struct r
 		if ((p->end >= start) && (p->start < end))
 			break;
 	}
+
 	read_unlock(&resource_lock);
 	if (!p)
 		return -1;
@@ -365,6 +384,70 @@ static int find_next_system_ram(struct r
 }
 
 /*
+ * Walks through iomem resources and calls func() with matching resource
+ * ranges. This walks through whole tree and not just first level children.
+ * All the memory ranges which overlap start,end and also match flags and
+ * name are valid candidates.
+ *
+ * @name: name of resource
+ * @flags: resource flags
+ * @start: start addr
+ * @end: end addr
+ */
+int walk_iomem_res(char *name, unsigned long flags, u64 start, u64 end,
+		void *arg, int (*func)(u64, u64, void *))
+{
+	struct resource res;
+	u64 orig_end;
+	int ret = -1;
+
+	res.start = start;
+	res.end = end;
+	res.flags = flags;
+	orig_end = res.end;
+	while ((res.start < res.end) &&
+		(!find_next_iomem_res(&res, name, false))) {
+		ret = (*func)(res.start, res.end, arg);
+		if (ret)
+			break;
+		res.start = res.end + 1;
+		res.end = orig_end;
+	}
+	return ret;
+}
+
+/*
+ * This function calls callback against all memory range of "System RAM"
+ * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
+ * Now, this function is only for "System RAM". This function deals with
+ * full ranges and not pfn. If resources are not pfn aligned, dealing
+ * with pfn can truncate ranges.
+ */
+int walk_system_ram_res(u64 start, u64 end, void *arg,
+				int (*func)(u64, u64, void *))
+{
+	struct resource res;
+	u64 orig_end;
+	int ret = -1;
+
+	res.start = start;
+	res.end = end;
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	orig_end = res.end;
+	while ((res.start < res.end) &&
+		(!find_next_iomem_res(&res, "System RAM", true))) {
+		ret = (*func)(res.start, res.end, arg);
+		if (ret)
+			break;
+		res.start = res.end + 1;
+		res.end = orig_end;
+	}
+	return ret;
+}
+
+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
+
+/*
  * This function calls callback against all memory range of "System RAM"
  * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
  * Now, this function is only for "System RAM".
@@ -382,7 +465,7 @@ int walk_system_ram_range(unsigned long
 	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	orig_end = res.end;
 	while ((res.start < res.end) &&
-		(find_next_system_ram(&res, "System RAM") >= 0)) {
+		(find_next_iomem_res(&res, "System RAM", true) >= 0)) {
 		pfn = (res.start + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		end_pfn = (res.end + 1) >> PAGE_SHIFT;
 		if (end_pfn > pfn)
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch

