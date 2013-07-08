From: akpm@linux-foundation.org
Subject: [merged]
 mmzone-note-that-node_size_lock-should-be-manipulated-via-pgdat_resize_lock.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:08 -0700
Message-ID: <51db1214.cMq8uPcddSxW8xXA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3GHTZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, cody@linux.vnet.ibm.com

Subject: [merged] mmzone-note-that-node_size_lock-should-be-manipulated-via-pgdat_resize_lock.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:08 -0700


The patch titled
     Subject: mmzone: note that node_size_lock should be manipulated via pgdat_resize_lock()
has been removed from the -mm tree.  Its filename was
     mmzone-note-that-node_size_lock-should-be-manipulated-via-pgdat_resize_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mmzone: note that node_size_lock should be manipulated via pgdat_resize_lock()

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/mmzone.h~mmzone-note-that-node_size_lock-should-be-manipulated-via-pgdat_resize_lock include/linux/mmzone.h
--- a/include/linux/mmzone.h~mmzone-note-that-node_size_lock-should-be-manipulated-via-pgdat_resize_lock
+++ a/include/linux/mmzone.h
@@ -733,6 +733,9 @@ typedef struct pglist_data {
 	 * or node_spanned_pages stay constant.  Holding this will also
 	 * guarantee that any pfn_valid() stays that way.
 	 *
+	 * pgdat_resize_lock() and pgdat_resize_unlock() are provided to
+	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG.
+	 *
 	 * Nests above zone->lock and zone->span_seqlock
 	 */
 	spinlock_t node_size_lock;
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

