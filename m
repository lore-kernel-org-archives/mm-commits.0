From: akpm@linux-foundation.org
Subject: + mm-honor-min_free_kbytes-set-by-user.patch added to -mm tree
Date: Mon, 08 Jul 2013 13:44:51 -0700
Message-ID: <51db24c3.TeZ8b7RBJ1Rk7vnW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3GHUow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 16:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz

Subject: + mm-honor-min_free_kbytes-set-by-user.patch added to -mm tree
To: mhocko@suse.cz,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 13:44:51 -0700


The patch titled
     Subject: mm: honor min_free_kbytes set by user
has been added to the -mm tree.  Its filename is
     mm-honor-min_free_kbytes-set-by-user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-honor-min_free_kbytes-set-by-user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-honor-min_free_kbytes-set-by-user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
list_lru-remove-special-case-function-list_lru_dispose_all.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
memcg-clean-up-memcg-nodeinfo.patch
mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
memcg-do-not-account-memory-used-for-cache-creation.patch
mm-page_alloc-fix-doc-for-numa_zonelist_order.patch
mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
revert-memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-kmem-fix-reference-count-handling-on-the-error-path.patch
memcg-use-css_get-in-sock_update_memcg.patch
memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
memcg-use-css_get-put-for-swap-memcg.patch
memcg-dont-need-to-get-a-reference-to-the-parent.patch
memcg-kill-memcg-refcnt.patch
memcg-dont-need-to-free-memcg-via-rcu-or-workqueue.patch
mm-honor-min_free_kbytes-set-by-user.patch
drop_caches-add-some-documentation-and-info-messsge.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch
staging-lustre-replace-num_physpages-with-totalram_pages.patch

