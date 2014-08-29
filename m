From: akpm@linux-foundation.org
Subject: + x86-optimize-resource-lookups-for-ioremap.patch added to -mm
 tree
Date: Fri, 29 Aug 2014 13:18:49 -0700
Message-ID: <5400e029.gTEh7apYg4rL9Hn+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaH2USu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 16:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, athorlton@sgi.com, cpw@sgi.com, dyoung@redhat.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, msalter@redhat.com, peterz@infradead.org, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: optimize resource lookups for ioremap
has been added to the -mm tree.  Its filename is
     x86-optimize-resource-lookups-for-ioremap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-optimize-resource-lookups-for-ioremap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-optimize-resource-lookups-for-ioremap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Travis <travis@sgi.com>
Subject: x86: optimize resource lookups for ioremap

We have a large university system in the UK that is experiencing very long
delays modprobing the driver for a specific I/O device.  The delay is from
8-10 minutes per device and there are 31 devices in the system.  This 4 to
5 hour delay in starting up those I/O devices is very much a burden on the
customer.

There are two causes for requiring a restart/reload of the drivers.  First
is periodic preventive maintenance (PM) and the second is if any of the
devices experience a fatal error.  Both of these trigger this excessively
long delay in bringing the system back up to full capability.

The problem was tracked down to a very slow IOREMAP operation and the
excessively long ioresource lookup to insure that the user is not
attempting to ioremap RAM.  These patches provide a speed up to that
function.


This patch (of 2):

Since the ioremap operation is verifying that the specified address range
is NOT RAM, it will search the entire ioresource list if the condition is
true.  To make matters worse, it does this one 4k page at a time.  For a
128M BAR region this is 32 passes to determine the entire region does not
contain any RAM addresses.

This patch provides another resource lookup function, region_is_ram, that
searches for the entire region specified, verifying that it is completely
contained within the resource region.  If it is found, then it is checked
to be RAM or not, within a single pass.

The return result reflects if it was found or not (-1), and whether it is
RAM (1) or not (0).  This allows the caller to fallback to the previous
page by page search if it was not found.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Alex Thorlton <athorlton@sgi.com>
Reviewed-by: Cliff Wickman <cpw@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 kernel/resource.c  |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff -puN include/linux/mm.h~x86-optimize-resource-lookups-for-ioremap include/linux/mm.h
--- a/include/linux/mm.h~x86-optimize-resource-lookups-for-ioremap
+++ a/include/linux/mm.h
@@ -347,6 +347,7 @@ static inline int put_page_unless_one(st
 }
 
 extern int page_is_ram(unsigned long pfn);
+extern int region_is_ram(resource_size_t phys_addr, unsigned long size);
 
 /* Support for virtually mapped pages */
 struct page *vmalloc_to_page(const void *addr);
diff -puN kernel/resource.c~x86-optimize-resource-lookups-for-ioremap kernel/resource.c
--- a/kernel/resource.c~x86-optimize-resource-lookups-for-ioremap
+++ a/kernel/resource.c
@@ -491,6 +491,42 @@ int __weak page_is_ram(unsigned long pfn
 }
 EXPORT_SYMBOL_GPL(page_is_ram);
 
+/*
+ * Search for a resouce entry that fully contains the specified region.
+ * If found, return 1 if it is RAM, 0 if not.
+ * If not found, or region is not fully contained, return -1
+ *
+ * Used by the ioremap functions to insure user not remapping RAM and is as
+ * vast speed up over walking through the resource table page by page.
+ */
+int region_is_ram(resource_size_t start, unsigned long size)
+{
+	struct resource *p;
+	resource_size_t end = start + size - 1;
+	int flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	const char *name = "System RAM";
+	int ret = -1;
+
+	read_lock(&resource_lock);
+	for (p = iomem_resource.child; p ; p = p->sibling) {
+		if (end < p->start)
+			continue;
+
+		if (p->start <= start && end <= p->end) {
+			/* resource fully contains region */
+			if ((p->flags != flags) || strcmp(p->name, name))
+				ret = 0;
+			else
+				ret = 1;
+			break;
+		}
+		if (p->end < start)
+			break;	/* not found */
+	}
+	read_unlock(&resource_lock);
+	return ret;
+}
+
 void __weak arch_remove_reservations(struct resource *avail)
 {
 }
_

Patches currently in -mm which might be from travis@sgi.com are

x86-optimize-resource-lookups-for-ioremap.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
linux-next.patch

