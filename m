From: akpm@osdl.org
Subject: + aio-make-aio_ring_info-nr_pages-an-unsigned-int.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:34:23 -0800
Message-ID: <200701022134.l02LYN6j030479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34332 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbXABVf3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:35:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenneth.w.chen@intel.com, bcrl@kvack.org, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: make aio_ring_info->nr_pages an unsigned int
has been added to the -mm tree.  Its filename is
     aio-make-aio_ring_info-nr_pages-an-unsigned-int.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aio: make aio_ring_info->nr_pages an unsigned int
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

The number of io_event in AIO event queue allowed currently is no more
than 2^32-1, because the syscall defines:

	asmlinkage long sys_io_setup(unsigned nr_events, aio_context_t __user *ctxp)

We internally allocate a ring buffer for nr_events and keeps tracks of
page descriptors for each of these ring buffer pages.  Since page size
is significantly larger than AIO event size (4096 versus 32), I don't
think it is ever possible to overflow nr_pages in 32-bit quantity.

This patch changes nr_pages to unsigned int. on 64-bit arch, changing
it to unsigned int also allows better packing of aio_ring_info structure.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/aio.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/aio.h~aio-make-aio_ring_info-nr_pages-an-unsigned-int include/linux/aio.h
--- a/include/linux/aio.h~aio-make-aio_ring_info-nr_pages-an-unsigned-int
+++ a/include/linux/aio.h
@@ -165,7 +165,7 @@ struct aio_ring_info {
 
 	struct page		**ring_pages;
 	spinlock_t		ring_lock;
-	long			nr_pages;
+	unsigned		nr_pages;
 
 	unsigned		nr, tail;
 
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

ia64-alignment-bug-in-ldscript.patch
aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
aio-add-per-task-aio-wait-event-condition.patch
aio-streamline-read-events-after-woken-up.patch
aio-remove-spurious-ring-head-index-modulo-info-nr.patch
aio-make-aio_ring_info-nr_pages-an-unsigned-int.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
