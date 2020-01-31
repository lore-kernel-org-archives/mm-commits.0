From: akpm@linux-foundation.org
Subject: [merged]
 mm-drop-elements-hw-and-phys_callback-from-struct-memory_block.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:19:32 -0800
Message-ID: <20200131231932.7fUGe9Lhn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXTd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, dan.j.williams@intel.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com


The patch titled
     Subject: include/linux/memory.h: drop fields 'hw' and 'phys_callback' from struct memory_block
has been removed from the -mm tree.  Its filename was
     mm-drop-elements-hw-and-phys_callback-from-struct-memory_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: include/linux/memory.h: drop fields 'hw' and 'phys_callback' from struct memory_block

memory_block structure elements 'hw' and 'phys_callback' are not getting
used.  This was originally added with commit 3947be1969a9 ("[PATCH] memory
hotplug: sysfs and add/remove functions") but never seem to have been
used.  Just drop them now.

Link: http://lkml.kernel.org/r/1576728650-13867-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/memory.h~mm-drop-elements-hw-and-phys_callback-from-struct-memory_block
+++ a/include/linux/memory.h
@@ -29,8 +29,6 @@ struct memory_block {
 	int section_count;		/* serialized by mem_sysfs_mutex */
 	int online_type;		/* for passing data to online routine */
 	int phys_device;		/* to which fru does this belong? */
-	void *hw;			/* optional pointer to fw/hw data */
-	int (*phys_callback)(struct memory_block *);
 	struct device dev;
 	int nid;			/* NID for this memory block */
 };
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are
