From: akpm@linux-foundation.org
Subject: [merged] kernel-relayc-use-kvfree-in-relay_free_page_array.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:41 -0700
Message-ID: <559adb5d.v6kRQECrmLCaaXbW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbbGFTrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: use kvfree() in relay_free_page_array()
has been removed from the -mm tree.  Its filename was
     kernel-relayc-use-kvfree-in-relay_free_page_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: kernel/relay.c: use kvfree() in relay_free_page_array()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/relay.c~kernel-relayc-use-kvfree-in-relay_free_page_array kernel/relay.c
--- a/kernel/relay.c~kernel-relayc-use-kvfree-in-relay_free_page_array
+++ a/kernel/relay.c
@@ -81,10 +81,7 @@ static struct page **relay_alloc_page_ar
  */
 static void relay_free_page_array(struct page **array)
 {
-	if (is_vmalloc_addr(array))
-		vfree(array);
-	else
-		kfree(array);
+	kvfree(array);
 }
 
 /**
_

Patches currently in -mm which might be from penberg@kernel.org are

slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch

