From: akpm@linux-foundation.org
Subject: [folded] memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group-fix.patch removed from -mm tree
Date: Tue, 01 Feb 2011 15:48:22 -0800
Message-ID: <201102012348.p11NmMt1005688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab1BAXtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 18:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group-fix
has been removed from the -mm tree.  Its filename was
     memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group-fix.patch

This patch was dropped because it was folded into memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group-fix
From: Johannes Weiner <hannes@cmpxchg.org>

res_counter: document res_counter_check_margin()

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/res_counter.h~memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group-fix include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group-fix
+++ a/include/linux/res_counter.h
@@ -182,6 +182,14 @@ static inline bool res_counter_check_und
 	return ret;
 }
 
+/**
+ * res_counter_check_margin - check if the counter allows charging
+ * @cnt: the resource counter to check
+ * @bytes: the number of bytes to check the remaining space against
+ *
+ * Returns a boolean value on whether the counter can be charged
+ * @bytes or whether this would exceed the limit.
+ */
 static inline bool res_counter_check_margin(struct res_counter *cnt,
 					    unsigned long bytes)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-prevent-endless-loop-when-charging-huge-pages.patch
memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group.patch
memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group-fix-fix.patch
memcg-never-oom-when-charging-huge-pages.patch
memcg-fix-event-counting-breakage-by-recent-thp-update.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

