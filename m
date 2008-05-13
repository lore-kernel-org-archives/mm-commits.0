From: akpm@linux-foundation.org
Subject: - make-vmstat-cpu-unplug-safe.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:10 -0700
Message-ID: <200805132133.m4DLXAfH000791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761273AbYEMVdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, clameter@sgi.com, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     make vmstat cpu-unplug safe
has been removed from the -mm tree.  Its filename was
     make-vmstat-cpu-unplug-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make vmstat cpu-unplug safe
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

When accessing cpu_online_map, we should prevent dynamic changing
of cpu_online_map by get_online_cpus().

Unfortunately, all_vm_events() doesn't do that.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmstat.c~make-vmstat-cpu-unplug-safe mm/vmstat.c
--- a/mm/vmstat.c~make-vmstat-cpu-unplug-safe
+++ a/mm/vmstat.c
@@ -41,7 +41,9 @@ static void sum_vm_events(unsigned long 
 */
 void all_vm_events(unsigned long *ret)
 {
+	get_online_cpus();
 	sum_vm_events(ret, &cpu_online_map);
+	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(all_vm_events);
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

