From: akpm@osdl.org
Subject: - aio-remove-spurious-ring-head-index-modulo-info-nr.patch removed from -mm tree
Date: Tue, 02 Jan 2007 17:10:17 -0800
Message-ID: <200701030110.l031AeWl003709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbXACBOj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 20:14:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, bcrl@kvack.org, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: remove spurious ring head index modulo info->nr
has been removed from the -mm tree.  Its filename was
     aio-remove-spurious-ring-head-index-modulo-info-nr.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: aio: remove spurious ring head index modulo info->nr
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

In aio_read_evt(), the ring->head will never wrap info->nr because
we already does the wrap when updating the ring head index:

        if (head != ring->tail) {
                ...
                head = (head + 1) % info->nr;
                ring->head = head;
        }

This makes the modulo of ring->head into local variable head unnecessary.
This patch removes that bogus code.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~aio-remove-spurious-ring-head-index-modulo-info-nr fs/aio.c
--- a/fs/aio.c~aio-remove-spurious-ring-head-index-modulo-info-nr
+++ a/fs/aio.c
@@ -1036,7 +1036,7 @@ static int aio_read_evt(struct kioctx *i
 {
 	struct aio_ring_info *info = &ioctx->ring_info;
 	struct aio_ring *ring;
-	unsigned long head;
+	unsigned int head;
 	int ret = 0;
 
 	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
@@ -1049,7 +1049,7 @@ static int aio_read_evt(struct kioctx *i
 
 	spin_lock(&info->ring_lock);
 
-	head = ring->head % info->nr;
+	head = ring->head;
 	if (head != ring->tail) {
 		struct io_event *evp = aio_ring_event(info, head, KM_USER1);
 		*ent = *evp;
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

ia64-alignment-bug-in-ldscript.patch
aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
aio-remove-spurious-ring-head-index-modulo-info-nr.patch
aio-make-aio_ring_info-nr_pages-an-unsigned-int.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
