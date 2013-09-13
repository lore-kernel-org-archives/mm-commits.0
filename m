From: akpm@linux-foundation.org
Subject: [merged] staging-lustre-libcfs-cleanup-linux-memh.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 14:16:39 -0700
Message-ID: <523380b7.ePD0jkKso7HJ9Bcb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3IMVQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tao.peng@emc.com, mhocko@suse.cz, dchinner@redhat.com, andreas.dilger@intel.com, bergwolf@gmail.com

Subject: [merged] staging-lustre-libcfs-cleanup-linux-memh.patch removed from -mm tree
To: bergwolf@gmail.com,andreas.dilger@intel.com,dchinner@redhat.com,mhocko@suse.cz,tao.peng@emc.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:16:39 -0700


The patch titled
     Subject: staging/lustre/libcfs: cleanup linux-mem.h
has been removed from the -mm tree.  Its filename was
     staging-lustre-libcfs-cleanup-linux-memh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peng Tao <bergwolf@gmail.com>
Subject: staging/lustre/libcfs: cleanup linux-mem.h

remove shrinker related wrappers.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h |   38 ----------
 1 file changed, 38 deletions(-)

diff -puN drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h~staging-lustre-libcfs-cleanup-linux-memh drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h~staging-lustre-libcfs-cleanup-linux-memh
+++ a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
@@ -79,42 +79,4 @@
 	do { __oldfs = get_fs(); set_fs(get_ds());} while(0)
 #define MMSPACE_CLOSE	       set_fs(__oldfs)
 
-/*
- * Shrinker
- */
-
-# define SHRINKER_ARGS(sc, nr_to_scan, gfp_mask)  \
-		       struct shrinker *shrinker, \
-		       struct shrink_control *sc
-# define shrink_param(sc, var) ((sc)->var)
-
-typedef int (*shrinker_t)(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask));
-
-static inline
-struct shrinker *set_shrinker(int seek, shrinker_t func)
-{
-	struct shrinker *s;
-
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (s == NULL)
-		return (NULL);
-
-	s->shrink = func;
-	s->seeks = seek;
-
-	register_shrinker(s);
-
-	return s;
-}
-
-static inline
-void remove_shrinker(struct shrinker *shrinker)
-{
-	if (shrinker == NULL)
-		return;
-
-	unregister_shrinker(shrinker);
-	kfree(shrinker);
-}
