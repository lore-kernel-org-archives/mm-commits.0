From: akpm@linux-foundation.org
Subject: [folded-merged]
 tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 13:52:20 -0700
Message-ID: <56eb1904.u/5Vi90uG4If15w7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030342AbcCQUwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, koct9i@gmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: tools/vm/page-types.c: add memory cgroup dumping and filtering
has been removed from the -mm tree.  Its filename was
     tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix.patch

This patch was dropped because it was folded into tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: tools/vm/page-types.c: add memory cgroup dumping and filtering

On Sat, Feb 06, 2016 at 01:06:29PM +0300, Konstantin Khlebnikov wrote:
...
>  static int		opt_list;	/* list pages (in ranges) */
>  static int		opt_no_summary;	/* don't show summary */
>  static pid_t		opt_pid;	/* process to walk */
> -const char *		opt_file;
> +const char *		opt_file;	/* file or directory path */
> +static int64_t		opt_cgroup = -1;/* cgroup inode */

ino should be a positive number, so we could use uint64_t here. Of
course, ino=0 could be used for filtering pages not charged to any
cgroup (as it is in this patch), but I doubt this would be useful.

Also, this patch conflicts with the recent change by Naoya introducing
support of dumping swap entries - https://lkml.org/lkml/2016/2/4/50

I attached a fixlet that addresses these two issues. What do you think
about it?

Other than that the patch looks good to me,

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN tools/vm/page-types.c~tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix
+++ a/tools/vm/page-types.c
@@ -170,7 +170,7 @@ static int		opt_list;	/* list pages (in
 static int		opt_no_summary;	/* don't show summary */
 static pid_t		opt_pid;	/* process to walk */
 const char *		opt_file;	/* file or directory path */
-static int64_t		opt_cgroup = -1;/* cgroup inode */
+static uint64_t		opt_cgroup;	/* cgroup inode */
 static int		opt_list_cgroup;/* list page cgroup */
 
 #define MAX_ADDR_RANGES	1024
@@ -604,7 +604,7 @@ static void add_page(unsigned long voffs
 	if (!bit_mask_ok(flags))
 		return;
 
-	if (opt_cgroup >= 0 && cgroup != (uint64_t)opt_cgroup)
+	if (opt_cgroup && cgroup != (uint64_t)opt_cgroup)
 		return;
 
 	if (opt_hwpoison)
@@ -659,10 +659,13 @@ static void walk_swap(unsigned long voff
 	if (!bit_mask_ok(flags))
 		return;
 
+	if (opt_cgroup)
+		return;
+
 	if (opt_list == 1)
-		show_page_range(voffset, pagemap_swap_offset(pme), 1, flags);
+		show_page_range(voffset, pagemap_swap_offset(pme), 1, flags, 0);
 	else if (opt_list == 2)
-		show_page(voffset, pagemap_swap_offset(pme), flags);
+		show_page(voffset, pagemap_swap_offset(pme), flags, 0);
 
 	nr_pages[hash_slot(flags)]++;
 	total_pages++;
@@ -1240,7 +1243,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (opt_cgroup >= 0 || opt_list_cgroup)
+	if (opt_cgroup || opt_list_cgroup)
 		kpagecgroup_fd = checked_open(PROC_KPAGECGROUP, O_RDONLY);
 
 	if (opt_list && opt_pid)
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering.patch
mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch
mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch
mm-memcontrol-zap-memcg_kmem_online-helper.patch
radix-tree-account-radix_tree_node-to-memory-cgroup.patch
mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch
mm-workingset-make-shadow-node-shrinker-memcg-aware.patch
mm-memcontrol-cleanup-css_reset-callback.patch
mm-memcontrol-zap-oom_info_lock.patch

