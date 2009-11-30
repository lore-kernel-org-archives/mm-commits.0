From: akpm@linux-foundation.org
Subject: + vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix.patch added to -mm tree
Date: Mon, 30 Nov 2009 13:57:05 -0800
Message-ID: <200911302157.nAULv5he032286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbZK3V50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 16:57:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, lwoodman@redhat.com, mangoo@wpkg.org, riel@redhat.com


The patch titled
     vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix
has been added to the -mm tree.  Its filename is
     vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
rmap-simplify-try_to_unmap_file.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
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
mm-simplify-try_to_unmap_one-fix.patch
vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan.patch
vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix.patch
vmscan-simplify-code.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc.patch
maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers.patch
lib-introduce-strim.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

