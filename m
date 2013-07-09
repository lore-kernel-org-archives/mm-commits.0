From: akpm@linux-foundation.org
Subject: [merged] mm-honor-min_free_kbytes-set-by-user.patch removed from
 -mm tree
Date: Tue, 09 Jul 2013 16:20:51 -0700
Message-ID: <51dc9ad3.K++HtOntGSMS/Czv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3GIXUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz

Subject: [merged] mm-honor-min_free_kbytes-set-by-user.patch removed from -mm tree
To: mhocko@suse.cz,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:51 -0700


The patch titled
     Subject: mm: honor min_free_kbytes set by user
has been removed from the -mm tree.  Its filename was
     mm-honor-min_free_kbytes-set-by-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: honor min_free_kbytes set by user

min_free_kbytes is updated during memory hotplug (by
init_per_zone_wmark_min) currently which is right thing to do in most
cases but this could be unexpected if admin increased the value to prevent
from allocation failures and the new min_free_kbytes would be decreased as
a result of memory hotadd.

This patch saves the user defined value and allows updating
min_free_kbytes only if it is higher than the saved one.

A warning is printed when the new value is ignored.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-honor-min_free_kbytes-set-by-user mm/page_alloc.c
--- a/mm/page_alloc.c~mm-honor-min_free_kbytes-set-by-user
+++ a/mm/page_alloc.c
@@ -204,6 +204,7 @@ static char * const zone_names[MAX_NR_ZO
 };
 
 int min_free_kbytes = 1024;
+int user_min_free_kbytes;
 
 static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
@@ -5589,14 +5590,21 @@ static void __meminit setup_per_zone_ina
 int __meminit init_per_zone_wmark_min(void)
 {
 	unsigned long lowmem_kbytes;
+	int new_min_free_kbytes;
 
 	lowmem_kbytes = nr_free_buffer_pages() * (PAGE_SIZE >> 10);
+	new_min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
 
-	min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
-	if (min_free_kbytes < 128)
-		min_free_kbytes = 128;
-	if (min_free_kbytes > 65536)
-		min_free_kbytes = 65536;
+	if (new_min_free_kbytes > user_min_free_kbytes) {
+		min_free_kbytes = new_min_free_kbytes;
+		if (min_free_kbytes < 128)
+			min_free_kbytes = 128;
+		if (min_free_kbytes > 65536)
+			min_free_kbytes = 65536;
+	} else {
+		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
+				new_min_free_kbytes, user_min_free_kbytes);
+	}
 	setup_per_zone_wmarks();
 	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
@@ -5614,8 +5622,10 @@ int min_free_kbytes_sysctl_handler(ctl_t
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
-	if (write)
+	if (write) {
+		user_min_free_kbytes = min_free_kbytes;
 		setup_per_zone_wmarks();
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
drop_caches-add-some-documentation-and-info-messsge.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch
staging-lustre-replace-num_physpages-with-totalram_pages.patch

