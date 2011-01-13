From: akpm@linux-foundation.org
Subject: [merged] vmware-balloon-stop-locking-pages-when-hypervisor-tells-us-enough.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:56 -0800
Message-ID: <201101132012.p0DKCbZe030313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933710Ab1AMUNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@vmware.com, mm-commits@vger.kernel.org


The patch titled
     VMware balloon: stop locking pages when hypervisor tells us enough
has been removed from the -mm tree.  Its filename was
     vmware-balloon-stop-locking-pages-when-hypervisor-tells-us-enough.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VMware balloon: stop locking pages when hypervisor tells us enough
From: Dmitry Torokhov <dtor@vmware.com>

When hypervisor decides to decrease target balloon size while the balloon
driver tries to lock pages hypervisor may respond with
VMW_BALLOON_PPN_NOTNEEDED.  Use this data and immediately stop reserving
pages and wait for the next update cycle to fetch new target instead of
continuing trying to lock pages until size of refused list grows above
VMW_BALLOON_MAX_REFUSED (16) pages.

As a result the driver stops bothering the hypervisor with its attempts to
lock more pages that are not needed anymore.  Most likely next order from
hypervisor will be to reduce ballon size anyway.

It is a small optimization.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmw_balloon.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/misc/vmw_balloon.c~vmware-balloon-stop-locking-pages-when-hypervisor-tells-us-enough drivers/misc/vmw_balloon.c
--- a/drivers/misc/vmw_balloon.c~vmware-balloon-stop-locking-pages-when-hypervisor-tells-us-enough
+++ a/drivers/misc/vmw_balloon.c
@@ -45,7 +45,7 @@
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
-MODULE_VERSION("1.2.1.1-k");
+MODULE_VERSION("1.2.1.2-k");
 MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
@@ -315,7 +315,8 @@ static bool vmballoon_send_get_target(st
  * fear that guest will need it. Host may reject some pages, we need to
  * check the return value and maybe submit a different page.
  */
-static bool vmballoon_send_lock_page(struct vmballoon *b, unsigned long pfn)
+static bool vmballoon_send_lock_page(struct vmballoon *b, unsigned long pfn,
+				     unsigned int *hv_status)
 {
 	unsigned long status, dummy;
 	u32 pfn32;
@@ -326,7 +327,7 @@ static bool vmballoon_send_lock_page(str
 
 	STATS_INC(b->stats.lock);
 
-	status = VMWARE_BALLOON_CMD(LOCK, pfn, dummy);
+	*hv_status = status = VMWARE_BALLOON_CMD(LOCK, pfn, dummy);
 	if (vmballoon_check_status(b, status))
 		return true;
 
@@ -410,6 +411,7 @@ static int vmballoon_reserve_page(struct
 {
 	struct page *page;
 	gfp_t flags;
+	unsigned int hv_status;
 	bool locked = false;
 
 	do {
@@ -429,11 +431,12 @@ static int vmballoon_reserve_page(struct
 		}
 
 		/* inform monitor */
-		locked = vmballoon_send_lock_page(b, page_to_pfn(page));
+		locked = vmballoon_send_lock_page(b, page_to_pfn(page), &hv_status);
 		if (!locked) {
 			STATS_INC(b->stats.refused_alloc);
 
-			if (b->reset_required) {
+			if (hv_status == VMW_BALLOON_ERROR_RESET ||
+			    hv_status == VMW_BALLOON_ERROR_PPN_NOTNEEDED) {
 				__free_page(page);
 				return -EIO;
 			}
_

Patches currently in -mm which might be from dtor@vmware.com are

origin.patch

