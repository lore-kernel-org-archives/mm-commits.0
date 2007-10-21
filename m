From: akpm@linux-foundation.org
Subject: - memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:48:56 -0700
Message-ID: <200710212348.l9LNmuKY000746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbXJUXzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     make do_try_to_free_pages() static
has been removed from the -mm tree.  Its filename was
     memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch

This patch was dropped because it was folded into memory-controller-add-per-container-lru-and-reclaim-v7.patch

------------------------------------------------------
Subject: make do_try_to_free_pages() static
From: Adrian Bunk <bunk@kernel.org>

do_try_to_free_pages() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~memory-controller-add-per-container-lru-and-reclaim-v7-cleanup mm/vmscan.c
--- a/mm/vmscan.c~memory-controller-add-per-container-lru-and-reclaim-v7-cleanup
+++ a/mm/vmscan.c
@@ -1237,8 +1237,8 @@ static unsigned long shrink_zones(int pr
  * holds filesystem locks which prevent writeout this might not work, and the
  * allocation attempt will fail.
  */
-unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
-					struct scan_control *sc)
+static unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
+					  struct scan_control *sc)
 {
 	int priority;
 	int ret = 0;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-scsi-misc.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
reiser4.patch
