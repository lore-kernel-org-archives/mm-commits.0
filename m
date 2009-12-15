From: akpm@linux-foundation.org
Subject: [folded] vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:03:29 -0800
Message-ID: <200912150103.nBF13U8H002087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758388AbZLOBD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:03:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, lwoodman@redhat.com, mangoo@wpkg.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix
has been removed from the -mm tree.  Its filename was
     vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix.patch

This patch was dropped because it was folded into vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> In AIM7 runs, recent kernels start swapping out anonymous pages
> well before they should.  This is due to shrink_list falling
> through to shrink_inactive_list if !inactive_anon_is_low(zone, sc),
> when all we really wanted to do is pre-age some anonymous pages to
> give them extra time to be referenced while on the inactive list.
>
> The obvious fix is to make sure that shrink_list does not fall
> through to scanning/reclaiming inactive pages when we called it
> to scan one of the active lists.
>
> This change should be safe because the loop in shrink_zone ensures
> that we will still shrink the anon and file inactive lists whenever
> we should.

Good catch!

>
> Reported-by: Larry Woodman <lwoodman@redhat.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 777af57..ec4dfda 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1469,13 +1469,15 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>  {
>  	int file = is_file_lru(lru);
>
> -	if (lru == LRU_ACTIVE_FILE && inactive_file_is_low(zone, sc)) {
> -		shrink_active_list(nr_to_scan, zone, sc, priority, file);
> +	if (lru == LRU_ACTIVE_FILE) {
> +		if (inactive_file_is_low(zone, sc))
> +		      shrink_active_list(nr_to_scan, zone, sc, priority, file);
>  		return 0;
>  	}
>
> -	if (lru == LRU_ACTIVE_ANON && inactive_anon_is_low(zone, sc)) {
> -		shrink_active_list(nr_to_scan, zone, sc, priority, file);
> +	if (lru == LRU_ACTIVE_ANON) {
> +		if (inactive_file_is_low(zone, sc))

This inactive_file_is_low() should be inactive_anon_is_low().
cut-n-paste programming often makes similar mistake. probaby we need make
more cleanup to this function.

How about this? (this is incremental patch from you)

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Reviewed-off-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN mm/vmscan.c~vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix
+++ a/mm/vmscan.c
@@ -1463,22 +1463,26 @@ static int inactive_file_is_low(struct z
 	return low;
 }
 
+static int inactive_list_is_low(struct zone *zone, struct scan_control *sc,
+				int file)
+{
+	if (file)
+		return inactive_file_is_low(zone, sc);
+	else
+		return inactive_anon_is_low(zone, sc);
+}
+
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	struct zone *zone, struct scan_control *sc, int priority)
 {
 	int file = is_file_lru(lru);
 
-	if (lru == LRU_ACTIVE_FILE) {
-		if (inactive_file_is_low(zone, sc))
+	if (is_active_lru(lru)) {
+		if (inactive_list_is_low(zone, sc, file))
 		    shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
 
-	if (lru == LRU_ACTIVE_ANON) {
-		if (inactive_file_is_low(zone, sc))
-		    shrink_active_list(nr_to_scan, zone, sc, priority, file);
-		return 0;
-	}
 	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
rmap-simplify-try_to_unmap_file.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-simplify-try_to_unmap_one.patch
vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan.patch
vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix.patch
vmscan-simplify-code.patch
mlock-replace-stale-comments-in-munlock_vma_page.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc.patch
maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers.patch
lib-introduce-strim.patch
lib-introduce-strim-checkpatch-fixes.patch

