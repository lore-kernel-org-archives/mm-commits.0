From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:44:24 -0800
Message-ID: <5640f798.jqdqc/F0M18qE3UK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbKIToY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, andreas.dilger@intel.com, oleg.drokin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: remove GFP_IOFS
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: page_alloc: remove GFP_IOFS

GFP_IOFS was intended to be shorthand for clearing two flags, not a set of
allocation flags.  There is only one user of this flag combination now and
there appears to be no reason why Lustre had to be protected from reclaim
stalls.  As none of the sites appear to be atomic, this patch simply
deletes GFP_IOFS and converts Lustre to using GFP_KERNEL, GFP_NOFS or
GFP_NOIO as appropriate.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lnet/lnet/router.c           |    2 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c       |    2 +-
 drivers/staging/lustre/lnet/selftest/rpc.c          |    2 +-
 drivers/staging/lustre/lustre/libcfs/module.c       |    2 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c    |    2 +-
 drivers/staging/lustre/lustre/llite/remote_perm.c   |    2 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c     |    8 ++++----
 drivers/staging/lustre/lustre/obdecho/echo_client.c |    2 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c       |    2 +-
 include/linux/gfp.h                                 |    1 -
 10 files changed, 12 insertions(+), 13 deletions(-)

diff -puN drivers/staging/lustre/lnet/lnet/router.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix drivers/staging/lustre/lnet/lnet/router.c
--- a/drivers/staging/lustre/lnet/lnet/router.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/drivers/staging/lustre/lnet/lnet/router.c
@@ -1245,7 +1245,7 @@ lnet_new_rtrbuf(lnet_rtrbufpool_t *rbp,
 	for (i = 0; i < npages; i++) {
 		page = alloc_pages_node(
 				cfs_cpt_spread_node(lnet_cpt_table(), cpt),
-				__GFP_ZERO | GFP_IOFS, 0);
+				GFP_KERNEL | __GFP_ZERO, 0);
 		if (page == NULL) {
 			while (--i >= 0)
 				__free_page(rb->rb_kiov[i].kiov_page);
diff -puN drivers/staging/lustre/lnet/selftest/conrpc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix drivers/staging/lustre/lnet/selftest/conrpc.c
--- a/drivers/staging/lustre/lnet/selftest/conrpc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/drivers/staging/lustre/lnet/selftest/conrpc.c
@@ -860,7 +860,7 @@ lstcon_testrpc_prep(lstcon_node_t *nd, i
 			bulk->bk_iovs[i].kiov_offset = 0;
 			bulk->bk_iovs[i].kiov_len    = len;
 			bulk->bk_iovs[i].kiov_page   =
-				alloc_page(GFP_IOFS);
+				alloc_page(GFP_KERNEL);
 
 			if (bulk->bk_iovs[i].kiov_page == NULL) {
 				lstcon_rpc_put(*crpc);
diff -puN drivers/staging/lustre/lnet/selftest/rpc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix drivers/staging/lustre/lnet/selftest/rpc.c
--- a/drivers/staging/lustre/lnet/selftest/rpc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -146,7 +146,7 @@ srpc_alloc_bulk(int cpt, unsigned bulk_n
 		int nob;
 
 		pg = alloc_pages_node(cfs_cpt_spread_node(lnet_cpt_table(), cpt),
-				      GFP_IOFS, 0);
+				      GFP_KERNEL, 0);
 		if (pg == NULL) {
 			CERROR("Can't allocate page %d of %d\n", i, bulk_npg);
 			srpc_free_bulk(bk);
diff -puN drivers/staging/lustre/lustre/libcfs/module.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix drivers/staging/lustre/lustre/libcfs/module.c
--- a/drivers/staging/lustre/lustre/libcfs/module.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/drivers/staging/lustre/lustre/libcfs/module.c
@@ -319,7 +319,7 @@ static int libcfs_ioctl(struct cfs_psdev
 	struct libcfs_ioctl_data *data;
 	int err = 0;
 
-	LIBCFS_ALLOC_GFP(buf, 1024, GFP_IOFS);
+	LIBCFS_ALLOC_GFP(buf, 1024, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
diff -puN drivers/staging/lustre/lustre/libcfs/tracefile.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix drivers/staging/lustre/lustre/libcfs/tracefile.c
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -810,7 +810,7 @@ int cfs_trace_allocate_string_buffer(cha
 	if (nob > 2 * PAGE_CACHE_SIZE)	    /* string must be "sensible" */
 		return -EINVAL;
 
-	*str = kmalloc(nob, GFP_IOFS | __GFP_ZERO);
+	*str = kmalloc(nob, GFP_KERNEL | __GFP_ZERO);
 	if (*str == NULL)
 		return -ENOMEM;
 
diff -puN drivers/staging/lustre/lustre/llite/remote_perm.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix drivers/staging/lustre/lustre/llite/remote_perm.c
--- a/drivers/staging/lustre/lustre/llite/remote_perm.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/drivers/staging/lustre/lustre/llite/remote_perm.c
@@ -82,7 +82,7 @@ static struct hlist_head *alloc_rmtperm_
 	struct hlist_head *hash;
 	int i;
 
-	hash = kmem_cache_alloc(ll_rmtperm_hash_cachep, GFP_IOFS | __GFP_ZERO);
+	hash = kmem_cache_alloc(ll_rmtperm_hash_cachep, GFP_NOFS | __GFP_ZERO);
 	if (!hash)
 		return NULL;
 
diff -puN drivers/staging/lustre/lustre/mgc/mgc_request.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix drivers/staging/lustre/lustre/mgc/mgc_request.c
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -1112,7 +1112,7 @@ static int mgc_apply_recover_logs(struct
 	LASSERT(cfg->cfg_instance != NULL);
 	LASSERT(cfg->cfg_sb == cfg->cfg_instance);
 
-	inst = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
+	inst = kzalloc(PAGE_CACHE_SIZE, GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 
@@ -1308,14 +1308,14 @@ static int mgc_process_recover_log(struc
 	if (cfg->cfg_last_idx == 0) /* the first time */
 		nrpages = CONFIG_READ_NRPAGES_INIT;
 
-	pages = kcalloc(nrpages, sizeof(*pages), GFP_NOFS);
+	pages = kcalloc(nrpages, sizeof(*pages), GFP_KERNEL);
 	if (pages == NULL) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
 	for (i = 0; i < nrpages; i++) {
-		pages[i] = alloc_page(GFP_IOFS);
+		pages[i] = alloc_page(GFP_KERNEL);
 		if (pages[i] == NULL) {
 			rc = -ENOMEM;
 			goto out;
@@ -1466,7 +1466,7 @@ static int mgc_process_cfg_log(struct ob
 	if (cld->cld_cfg.cfg_sb)
 		lsi = s2lsi(cld->cld_cfg.cfg_sb);
 
-	env = kzalloc(sizeof(*env), GFP_NOFS);
+	env = kzalloc(sizeof(*env), GFP_KERNEL);
 	if (!env)
 		return -ENOMEM;
 
diff -puN drivers/staging/lustre/lustre/obdecho/echo_client.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix drivers/staging/lustre/lustre/obdecho/echo_client.c
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -1562,7 +1562,7 @@ static int echo_client_kbrw(struct echo_
 		  (oa->o_valid & OBD_MD_FLFLAGS) != 0 &&
 		  (oa->o_flags & OBD_FL_DEBUG_CHECK) != 0);
 
-	gfp_mask = ((ostid_id(&oa->o_oi) & 2) == 0) ? GFP_IOFS : GFP_HIGHUSER;
+	gfp_mask = ((ostid_id(&oa->o_oi) & 2) == 0) ? GFP_KERNEL : GFP_HIGHUSER;
 
 	LASSERT(rw == OBD_BRW_WRITE || rw == OBD_BRW_READ);
 	LASSERT(lsm != NULL);
diff -puN drivers/staging/lustre/lustre/osc/osc_cache.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix drivers/staging/lustre/lustre/osc/osc_cache.c
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -346,7 +346,7 @@ static struct osc_extent *osc_extent_all
 {
 	struct osc_extent *ext;
 
-	ext = kmem_cache_alloc(osc_extent_kmem, GFP_IOFS | __GFP_ZERO);
+	ext = kmem_cache_alloc(osc_extent_kmem, GFP_NOFS | __GFP_ZERO);
 	if (ext == NULL)
 		return NULL;
 
diff -puN include/linux/gfp.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix
+++ a/include/linux/gfp.h
@@ -134,7 +134,6 @@ struct vm_area_struct;
 #define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
 #define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
-#define GFP_IOFS	(__GFP_IO | __GFP_FS | __GFP_KSWAPD_RECLAIM)
 #define GFP_TRANSHUGE	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN) & \
 			 ~__GFP_KSWAPD_RECLAIM)
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


