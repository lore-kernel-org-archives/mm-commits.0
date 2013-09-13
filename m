From: akpm@linux-foundation.org
Subject: [merged]
 staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 14:16:35 -0700
Message-ID: <523380b3.EwcCvtbC57Jir2UN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3IMVQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tao.peng@emc.com, mhocko@suse.cz, dchinner@redhat.com, andreas.dilger@intel.com, bergwolf@gmail.com

Subject: [merged] staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch removed from -mm tree
To: bergwolf@gmail.com,andreas.dilger@intel.com,dchinner@redhat.com,mhocko@suse.cz,tao.peng@emc.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:16:35 -0700


The patch titled
     Subject: staging/lustre/obdclass: convert lu_object shrinker to count/scan API
has been removed from the -mm tree.  Its filename was
     staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peng Tao <bergwolf@gmail.com>
Subject: staging/lustre/obdclass: convert lu_object shrinker to count/scan API

convert lu_object shrinker to new count/scan API.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/obdclass/lu_object.c |   98 +++++------
 1 file changed, 52 insertions(+), 46 deletions(-)

diff -puN drivers/staging/lustre/lustre/obdclass/lu_object.c~staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api drivers/staging/lustre/lustre/obdclass/lu_object.c
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c~staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api
+++ a/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -1779,7 +1779,6 @@ int lu_env_refill_by_tags(struct lu_env
 }
 EXPORT_SYMBOL(lu_env_refill_by_tags);
 
-static struct shrinker *lu_site_shrinker = NULL;
 
 typedef struct lu_site_stats{
 	unsigned	lss_populated;
@@ -1835,61 +1834,68 @@ static void lu_site_stats_get(cfs_hash_t
  * objects without taking the  lu_sites_guard lock, but this is not
  * possible in the current implementation.
  */
-static int lu_cache_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
+static unsigned long lu_cache_shrink_count(struct shrinker *sk,
+					   struct shrink_control *sc)
 {
 	lu_site_stats_t stats;
 	struct lu_site *s;
 	struct lu_site *tmp;
-	int cached = 0;
-	int remain = shrink_param(sc, nr_to_scan);
-	LIST_HEAD(splice);
-
-	if (!(shrink_param(sc, gfp_mask) & __GFP_FS)) {
-		if (remain != 0)
-			return -1;
-		else
-			/* We must not take the lu_sites_guard lock when
-			 * __GFP_FS is *not* set because of the deadlock
-			 * possibility detailed above. Additionally,
-			 * since we cannot determine the number of
-			 * objects in the cache without taking this
-			 * lock, we're in a particularly tough spot. As
-			 * a result, we'll just lie and say our cache is
-			 * empty. This _should_ be ok, as we can't
-			 * reclaim objects when __GFP_FS is *not* set
-			 * anyways.
-			 */
-			return 0;
-	}
+	unsigned long cached = 0;
 
-	CDEBUG(D_INODE, "Shrink %d objects\n", remain);
+	if (!(sc->gfp_mask & __GFP_FS))
+		return 0;
 
 	mutex_lock(&lu_sites_guard);
 	list_for_each_entry_safe(s, tmp, &lu_sites, ls_linkage) {
-		if (shrink_param(sc, nr_to_scan) != 0) {
-			remain = lu_site_purge(&lu_shrink_env, s, remain);
-			/*
-			 * Move just shrunk site to the tail of site list to
-			 * assure shrinking fairness.
-			 */
-			list_move_tail(&s->ls_linkage, &splice);
-		}
-
 		memset(&stats, 0, sizeof(stats));
 		lu_site_stats_get(s->ls_obj_hash, &stats, 0);
 		cached += stats.lss_total - stats.lss_busy;
-		if (shrink_param(sc, nr_to_scan) && remain <= 0)
-			break;
 	}
-	list_splice(&splice, lu_sites.prev);
 	mutex_unlock(&lu_sites_guard);
 
 	cached = (cached / 100) * sysctl_vfs_cache_pressure;
-	if (shrink_param(sc, nr_to_scan) == 0)
-		CDEBUG(D_INODE, "%d objects cached\n", cached);
+	CDEBUG(D_INODE, "%ld objects cached\n", cached);
 	return cached;
 }
 
+static unsigned long lu_cache_shrink_scan(struct shrinker *sk,
+					  struct shrink_control *sc)
+{
+	struct lu_site *s;
+	struct lu_site *tmp;
+	unsigned long remain = sc->nr_to_scan, freed = 0;
+	LIST_HEAD(splice);
+
+	if (!(sc->gfp_mask & __GFP_FS))
+		/* We must not take the lu_sites_guard lock when
+		 * __GFP_FS is *not* set because of the deadlock
+		 * possibility detailed above. Additionally,
+		 * since we cannot determine the number of
+		 * objects in the cache without taking this
+		 * lock, we're in a particularly tough spot. As
+		 * a result, we'll just lie and say our cache is
+		 * empty. This _should_ be ok, as we can't
+		 * reclaim objects when __GFP_FS is *not* set
+		 * anyways.
+		 */
+		return SHRINK_STOP;
+
+	mutex_lock(&lu_sites_guard);
+	list_for_each_entry_safe(s, tmp, &lu_sites, ls_linkage) {
+		freed = lu_site_purge(&lu_shrink_env, s, remain);
+		remain -= freed;
+		/*
+		 * Move just shrunk site to the tail of site list to
+		 * assure shrinking fairness.
+		 */
+		list_move_tail(&s->ls_linkage, &splice);
+	}
+	list_splice(&splice, lu_sites.prev);
+	mutex_unlock(&lu_sites_guard);
+
+	return sc->nr_to_scan - remain;
+}
+
 /*
  * Debugging stuff.
  */
@@ -1913,6 +1919,12 @@ int lu_printk_printer(const struct lu_en
 	return 0;
 }
 
+static struct shrinker lu_site_shrinker = {
+	.count_objects	= lu_cache_shrink_count,
+	.scan_objects	= lu_cache_shrink_scan,
+	.seeks 		= DEFAULT_SEEKS,
+};
+
 /**
  * Initialization of global lu_* data.
  */
@@ -1947,9 +1959,7 @@ int lu_global_init(void)
 	 * inode, one for ea. Unfortunately setting this high value results in
 	 * lu_object/inode cache consuming all the memory.
 	 */
-	lu_site_shrinker = set_shrinker(DEFAULT_SEEKS, lu_cache_shrink);
-	if (lu_site_shrinker == NULL)
-		return -ENOMEM;
+	register_shrinker(&lu_site_shrinker);
 
 	return result;
 }
@@ -1959,11 +1969,7 @@ int lu_global_init(void)
  */
 void lu_global_fini(void)
 {
-	if (lu_site_shrinker != NULL) {
-		remove_shrinker(lu_site_shrinker);
-		lu_site_shrinker = NULL;
-	}
