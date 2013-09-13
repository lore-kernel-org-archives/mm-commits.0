From: akpm@linux-foundation.org
Subject: [merged]
 staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 14:16:33 -0700
Message-ID: <523380b1.JkFuDX5tZPZw2jfu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3IMVQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tao.peng@emc.com, mhocko@suse.cz, dchinner@redhat.com, andreas.dilger@intel.com, bergwolf@gmail.com

Subject: [merged] staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch removed from -mm tree
To: bergwolf@gmail.com,andreas.dilger@intel.com,dchinner@redhat.com,mhocko@suse.cz,tao.peng@emc.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:16:33 -0700


The patch titled
     Subject: staging/lustre/ldlm: convert to shrinkers to count/scan API
has been removed from the -mm tree.  Its filename was
     staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peng Tao <bergwolf@gmail.com>
Subject: staging/lustre/ldlm: convert to shrinkers to count/scan API

convert ldlm shrinker to new count/scan API.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c |  148 ++++++++-------
 1 file changed, 79 insertions(+), 69 deletions(-)

diff -puN drivers/staging/lustre/lustre/ldlm/ldlm_pool.c~staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c~staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api
+++ a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -521,7 +521,7 @@ static int ldlm_cli_pool_shrink(struct l
 				int nr, unsigned int gfp_mask)
 {
 	struct ldlm_namespace *ns;
-	int canceled = 0, unused;
+	int unused;
 
 	ns = ldlm_pl2ns(pl);
 
@@ -540,14 +540,10 @@ static int ldlm_cli_pool_shrink(struct l
 	unused = ns->ns_nr_unused;
 	spin_unlock(&ns->ns_lock);
 
-	if (nr) {
-		canceled = ldlm_cancel_lru(ns, nr, LCF_ASYNC,
-					   LDLM_CANCEL_SHRINK);
-	}
-	/*
-	 * Return the number of potentially reclaimable locks.
-	 */
-	return ((unused - canceled) / 100) * sysctl_vfs_cache_pressure;
+	if (nr == 0)
+		return (unused / 100) * sysctl_vfs_cache_pressure;
+	else
+		return ldlm_cancel_lru(ns, nr, LCF_ASYNC, LDLM_CANCEL_SHRINK);
 }
 
 struct ldlm_pool_ops ldlm_srv_pool_ops = {
@@ -601,9 +597,10 @@ int ldlm_pool_recalc(struct ldlm_pool *p
 	return recalc_interval_sec;
 }
 
-/**
+/*
  * Pool shrink wrapper. Will call either client or server pool recalc callback
- * depending what pool \a pl is used.
+ * depending what pool pl is used. When nr == 0, just return the number of
+ * freeable locks. Otherwise, return the number of canceled locks.
  */
 int ldlm_pool_shrink(struct ldlm_pool *pl, int nr,
 		     unsigned int gfp_mask)
@@ -1017,29 +1014,24 @@ static int ldlm_pool_granted(struct ldlm
 }
 
 static struct ptlrpc_thread *ldlm_pools_thread;
-static struct shrinker *ldlm_pools_srv_shrinker;
-static struct shrinker *ldlm_pools_cli_shrinker;
 static struct completion ldlm_pools_comp;
 
 /*
- * Cancel \a nr locks from all namespaces (if possible). Returns number of
- * cached locks after shrink is finished. All namespaces are asked to
- * cancel approximately equal amount of locks to keep balancing.
+ * count locks from all namespaces (if possible). Returns number of
+ * cached locks.
  */
-static int ldlm_pools_shrink(ldlm_side_t client, int nr,
-			     unsigned int gfp_mask)
+static unsigned long ldlm_pools_count(ldlm_side_t client, unsigned int gfp_mask)
 {
-	int total = 0, cached = 0, nr_ns;
+	int total = 0, nr_ns;
 	struct ldlm_namespace *ns;
 	struct ldlm_namespace *ns_old = NULL; /* loop detection */
 	void *cookie;
 
-	if (client == LDLM_NAMESPACE_CLIENT && nr != 0 &&
-	    !(gfp_mask & __GFP_FS))
-		return -1;
+	if (client == LDLM_NAMESPACE_CLIENT && !(gfp_mask & __GFP_FS))
+		return 0;
 
-	CDEBUG(D_DLMTRACE, "Request to shrink %d %s locks from all pools\n",
-	       nr, client == LDLM_NAMESPACE_CLIENT ? "client" : "server");
+	CDEBUG(D_DLMTRACE, "Request to count %s locks from all pools\n",
+	       client == LDLM_NAMESPACE_CLIENT ? "client" : "server");
 
 	cookie = cl_env_reenter();
 
@@ -1047,8 +1039,7 @@ static int ldlm_pools_shrink(ldlm_side_t
 	 * Find out how many resources we may release.
 	 */
 	for (nr_ns = ldlm_namespace_nr_read(client);
-	     nr_ns > 0; nr_ns--)
-	{
+	     nr_ns > 0; nr_ns--) {
 		mutex_lock(ldlm_namespace_lock(client));
 		if (list_empty(ldlm_namespace_list(client))) {
 			mutex_unlock(ldlm_namespace_lock(client));
@@ -1078,17 +1069,27 @@ static int ldlm_pools_shrink(ldlm_side_t
 		ldlm_namespace_put(ns);
 	}
 
-	if (nr == 0 || total == 0) {
-		cl_env_reexit(cookie);
-		return total;
-	}
+	cl_env_reexit(cookie);
+	return total;
+}
+
+static unsigned long ldlm_pools_scan(ldlm_side_t client, int nr, unsigned int gfp_mask)
+{
+	unsigned long freed = 0;
+	int tmp, nr_ns;
+	struct ldlm_namespace *ns;
+	void *cookie;
+
+	if (client == LDLM_NAMESPACE_CLIENT && !(gfp_mask & __GFP_FS))
+		return -1;
+
+	cookie = cl_env_reenter();
 
 	/*
-	 * Shrink at least ldlm_namespace_nr(client) namespaces.
+	 * Shrink at least ldlm_namespace_nr_read(client) namespaces.
 	 */
-	for (nr_ns = ldlm_namespace_nr_read(client) - nr_ns;
-	     nr_ns > 0; nr_ns--)
-	{
+	for (tmp = nr_ns = ldlm_namespace_nr_read(client);
+	     tmp > 0; tmp--) {
 		int cancel, nr_locks;
 
 		/*
@@ -1097,12 +1098,6 @@ static int ldlm_pools_shrink(ldlm_side_t
 		mutex_lock(ldlm_namespace_lock(client));
 		if (list_empty(ldlm_namespace_list(client))) {
 			mutex_unlock(ldlm_namespace_lock(client));
-			/*
-			 * If list is empty, we can't return any @cached > 0,
-			 * that probably would cause needless shrinker
-			 * call.
-			 */
-			cached = 0;
 			break;
 		}
 		ns = ldlm_namespace_first_locked(client);
@@ -1111,29 +1106,42 @@ static int ldlm_pools_shrink(ldlm_side_t
 		mutex_unlock(ldlm_namespace_lock(client));
 
 		nr_locks = ldlm_pool_granted(&ns->ns_pool);
-		cancel = 1 + nr_locks * nr / total;
-		ldlm_pool_shrink(&ns->ns_pool, cancel, gfp_mask);
-		cached += ldlm_pool_granted(&ns->ns_pool);
+		/*
+		 * We use to shrink propotionally but with new shrinker API,
+		 * we lost the total number of freeable locks.
+		 */
+		cancel = 1 + min_t(int, nr_locks, nr / nr_ns);
+		freed += ldlm_pool_shrink(&ns->ns_pool, cancel, gfp_mask);
 		ldlm_namespace_put(ns);
 	}
 	cl_env_reexit(cookie);
-	/* we only decrease the SLV in server pools shrinker, return -1 to
-	 * kernel to avoid needless loop. LU-1128 */
-	return (client == LDLM_NAMESPACE_SERVER) ? -1 : cached;
+	/*
+	 * we only decrease the SLV in server pools shrinker, return
+	 * SHRINK_STOP to kernel to avoid needless loop. LU-1128
+	 */
+	return (client == LDLM_NAMESPACE_SERVER) ? SHRINK_STOP : freed;
+}
+
+static unsigned long ldlm_pools_srv_count(struct shrinker *s, struct shrink_control *sc)
+{
+	return ldlm_pools_count(LDLM_NAMESPACE_SERVER, sc->gfp_mask);
 }
 
-static int ldlm_pools_srv_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
+static unsigned long ldlm_pools_srv_scan(struct shrinker *s, struct shrink_control *sc)
 {
-	return ldlm_pools_shrink(LDLM_NAMESPACE_SERVER,
-				 shrink_param(sc, nr_to_scan),
-				 shrink_param(sc, gfp_mask));
+	return ldlm_pools_scan(LDLM_NAMESPACE_SERVER, sc->nr_to_scan,
+			       sc->gfp_mask);
 }
 
-static int ldlm_pools_cli_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
+static unsigned long ldlm_pools_cli_count(struct shrinker *s, struct shrink_control *sc)
 {
-	return ldlm_pools_shrink(LDLM_NAMESPACE_CLIENT,
-				 shrink_param(sc, nr_to_scan),
-				 shrink_param(sc, gfp_mask));
+	return ldlm_pools_count(LDLM_NAMESPACE_CLIENT, sc->gfp_mask);
+}
+
+static unsigned long ldlm_pools_cli_scan(struct shrinker *s, struct shrink_control *sc)
+{
+	return ldlm_pools_scan(LDLM_NAMESPACE_CLIENT, sc->nr_to_scan,
+			       sc->gfp_mask);
 }
 
 int ldlm_pools_recalc(ldlm_side_t client)
@@ -1216,7 +1224,7 @@ int ldlm_pools_recalc(ldlm_side_t client
 	}
 
 	/*
-	 * Recalc at least ldlm_namespace_nr(client) namespaces.
+	 * Recalc at least ldlm_namespace_nr_read(client) namespaces.
 	 */
 	for (nr = ldlm_namespace_nr_read(client); nr > 0; nr--) {
 		int     skip;
@@ -1383,18 +1391,26 @@ static void ldlm_pools_thread_stop(void)
 	ldlm_pools_thread = NULL;
 }
 
+static struct shrinker ldlm_pools_srv_shrinker = {
+	.count_objects	= ldlm_pools_srv_count,
+	.scan_objects	= ldlm_pools_srv_scan,
+	.seeks		= DEFAULT_SEEKS,
+};
+
+static struct shrinker ldlm_pools_cli_shrinker = {
+	.count_objects	= ldlm_pools_cli_count,
+	.scan_objects	= ldlm_pools_cli_scan,
+	.seeks		= DEFAULT_SEEKS,
+};
+
 int ldlm_pools_init(void)
 {
 	int rc;
 
 	rc = ldlm_pools_thread_start();
 	if (rc == 0) {
-		ldlm_pools_srv_shrinker =
-			set_shrinker(DEFAULT_SEEKS,
-					 ldlm_pools_srv_shrink);
-		ldlm_pools_cli_shrinker =
-			set_shrinker(DEFAULT_SEEKS,
-					 ldlm_pools_cli_shrink);
+		register_shrinker(&ldlm_pools_srv_shrinker);
+		register_shrinker(&ldlm_pools_cli_shrinker);
 	}
 	return rc;
 }
@@ -1402,14 +1418,8 @@ EXPORT_SYMBOL(ldlm_pools_init);
 
 void ldlm_pools_fini(void)
 {
-	if (ldlm_pools_srv_shrinker != NULL) {
-		remove_shrinker(ldlm_pools_srv_shrinker);
-		ldlm_pools_srv_shrinker = NULL;
-	}
-	if (ldlm_pools_cli_shrinker != NULL) {
-		remove_shrinker(ldlm_pools_cli_shrinker);
-		ldlm_pools_cli_shrinker = NULL;
-	}
+	unregister_shrinker(&ldlm_pools_srv_shrinker);
+	unregister_shrinker(&ldlm_pools_cli_shrinker);
 	ldlm_pools_thread_stop();
 }
 EXPORT_SYMBOL(ldlm_pools_fini);
_

Patches currently in -mm which might be from bergwolf@gmail.com are

origin.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

