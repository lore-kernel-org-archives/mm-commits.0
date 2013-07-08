From: akpm@linux-foundation.org
Subject: [merged] mm-pageblock-remove-get-set_pageblock_flags.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:54 -0700
Message-ID: <51db1242.+BkS+blC6NHQtCTH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab3GHTZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-pageblock-remove-get-set_pageblock_flags.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:54 -0700


The patch titled
     Subject: mm/pageblock: remove get/set_pageblock_flags
has been removed from the -mm tree.  Its filename was
     mm-pageblock-remove-get-set_pageblock_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/pageblock: remove get/set_pageblock_flags

get_pageblock_flags and set_pageblock_flags are not used any more, this
patch removes them.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/pageblock-flags.h~mm-pageblock-remove-get-set_pageblock_flags include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~mm-pageblock-remove-get-set_pageblock_flags
+++ a/include/linux/pageblock-flags.h
@@ -80,10 +80,4 @@ void set_pageblock_flags_group(struct pa
 							PB_migrate_skip)
 #endif /* CONFIG_COMPACTION */
 
-#define get_pageblock_flags(page) \
-			get_pageblock_flags_group(page, 0, PB_migrate_end)
-#define set_pageblock_flags(page, flags) \
-			set_pageblock_flags_group(page, flags,	\
-						  0, PB_migrate_end)
