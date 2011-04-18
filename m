From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-silence-build_all_zonelists-section-mismatch.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:27 -0700
Message-ID: <201104181758.p3IHwcBX016055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225Ab1DRSAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: silence build_all_zonelists() section mismatch
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-silence-build_all_zonelists-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: silence build_all_zonelists() section mismatch
From: Paul Mundt <lethal@linux-sh.org>

The memory hotplug case involves calling to build_all_zonelists() which in
turns calls in to setup_zone_pageset().  The latter is marked __meminit
while build_all_zonelists() itself has no particular annotation. 
build_all_zonelists() is only handed a non-NULL pointer in the case of
memory hotplug through an existing __meminit path, so the
setup_zone_pageset() reference is always safe.

The options as such are either to flag build_all_zonelists() as __ref (as
per __build_all_zonelists()), or to simply discard the __meminit
annotation from setup_zone_pageset().

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-silence-build_all_zonelists-section-mismatch mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-silence-build_all_zonelists-section-mismatch
+++ a/mm/page_alloc.c
@@ -3176,7 +3176,7 @@ static __init_refok int __build_all_zone
  * Called with zonelists_mutex held always
  * unless system_state == SYSTEM_BOOTING.
  */
-void build_all_zonelists(void *data)
+void __ref build_all_zonelists(void *data)
 {
 	set_zonelist_order();
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
linux-next.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-nommu-dont-scan-the-vma-list-when-deleting.patch
mm-nommu-find-vma-using-the-sorted-vma-list.patch
mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch
mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch
mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch

