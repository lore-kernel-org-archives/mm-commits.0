From: akpm@linux-foundation.org
Subject: [merged] documentation-add-new-page_owner-document.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:08:01 -0800
Message-ID: <548d0d21.pfsj9TWxnXRLYn8e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLNEHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: add new page_owner document
has been removed from the -mm tree.  Its filename was
     documentation-add-new-page_owner-document.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Documentation: add new page_owner document

page owner is for the tracking about who allocated each page.  This
document explains what is the page owner feature and what is the merit of
it.  And, simple HOW-TO is also explained.  See the document for detailed
information.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.txt |   81 ++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff -puN /dev/null Documentation/vm/page_owner.txt
--- /dev/null
+++ a/Documentation/vm/page_owner.txt
@@ -0,0 +1,81 @@
+page owner: Tracking about who allocated each page
+-----------------------------------------------------------
+
+* Introduction
+
+page owner is for the tracking about who allocated each page.
+It can be used to debug memory leak or to find a memory hogger.
+When allocation happens, information about allocation such as call stack
+and order of pages is stored into certain storage for each page.
+When we need to know about status of all pages, we can get and analyze
+this information.
+
+Although we already have tracepoint for tracing page allocation/free,
+using it for analyzing who allocate each page is rather complex. We need
+to enlarge the trace buffer for preventing overlapping until userspace
+program launched. And, launched program continually dump out the trace
+buffer for later analysis and it would change system behviour with more
+possibility rather than just keeping it in memory, so bad for debugging.
+
+page owner can also be used for various purposes. For example, accurate
+fragmentation statistics can be obtained through gfp flag information of
+each page. It is already implemented and activated if page owner is
+enabled. Other usages are more than welcome.
+
+page owner is disabled in default. So, if you'd like to use it, you need
+to add "page_owner=on" into your boot cmdline. If the kernel is built
+with page owner and page owner is disabled in runtime due to no enabling
+boot option, runtime overhead is marginal. If disabled in runtime, it
+doesn't require memory to store owner information, so there is no runtime
+memory overhead. And, page owner inserts just two unlikely branches into
+the page allocator hotpath and if it returns false then allocation is
+done like as the kernel without page owner. These two unlikely branches
+would not affect to allocation performance. Following is the kernel's
+code size change due to this facility.
+
+- Without page owner
+   text    data     bss     dec     hex filename
+  40662    1493     644   42799    a72f mm/page_alloc.o
+
+- With page owner
+   text    data     bss     dec     hex filename
+  40892    1493     644   43029    a815 mm/page_alloc.o
+   1427      24       8    1459     5b3 mm/page_ext.o
+   2722      50       0    2772     ad4 mm/page_owner.o
+
+Although, roughly, 4 KB code is added in total, page_alloc.o increase by
+230 bytes and only half of it is in hotpath. Building the kernel with
+page owner and turning it on if needed would be great option to debug
+kernel memory problem.
+
+There is one notice that is caused by implementation detail. page owner
+stores information into the memory from struct page extension. This memory
+is initialized some time later than that page allocator starts in sparse
+memory system, so, until initialization, many pages can be allocated and
+they would have no owner information. To fix it up, these early allocated
+pages are investigated and marked as allocated in initialization phase.
+Although it doesn't mean that they have the right owner information,
+at least, we can tell whether the page is allocated or not,
+more accurately. On 2GB memory x86-64 VM box, 13343 early allocated pages
+are catched and marked, although they are mostly allocated from struct
+page extension feature. Anyway, after that, no page is left in
+un-tracking state.
+
+* Usage
+
+1) Build user-space helper
+	cd tools/vm
+	make page_owner_sort
+
+2) Enable page owner
+	Add "page_owner=on" to boot cmdline.
+
+3) Do the job what you want to debug
+
+4) Analyze information from page owner
+	cat /sys/kernel/debug/page_owner > page_owner_full.txt
+	grep -v ^PFN page_owner_full.txt > page_owner.txt
+	./page_owner_sort page_owner.txt sorted_page_owner.txt
+
+	See the result about who allocated each page
+	in the sorted_page_owner.txt.
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

