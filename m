From: akpm@linux-foundation.org
Subject: [merged] mm-remove-ancient-ambiguous-comment.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:24:41 -0700
Message-ID: <20170711192441.2FBK0h9JS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47962 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933703AbdGKTYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, nborisov@suse.com


The patch titled
     Subject: include/linux/mmzone.h: remove ancient/ambiguous comment
has been removed from the -mm tree.  Its filename was
     mm-remove-ancient-ambiguous-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nikolay Borisov <nborisov@suse.com>
Subject: include/linux/mmzone.h: remove ancient/ambiguous comment

Currently pg_data_t is just a struct which describes a NUMA node memory
layout.  Let's keep the comment simple and remove ambiguity.

Link: http://lkml.kernel.org/r/1498220534-22717-1-git-send-email-nborisov@suse.com
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-ancient-ambiguous-comment include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-ancient-ambiguous-comment
+++ a/include/linux/mmzone.h
@@ -603,12 +603,9 @@ extern struct page *mem_map;
 #endif
 
 /*
- * The pg_data_t structure is used in machines with CONFIG_DISCONTIGMEM
- * (mostly NUMA machines?) to denote a higher-level memory zone than the
- * zone denotes.
- *
  * On NUMA machines, each NUMA node would have a pg_data_t to describe
- * it's memory layout.
+ * it's memory layout. On UMA machines there is a single pglist_data which
+ * describes the whole memory.
  *
  * Memory statistics and page replacement data structures are maintained on a
  * per-zone basis.
_

Patches currently in -mm which might be from nborisov@suse.com are

writeback-rework-wb__stat-family-of-functions.patch

