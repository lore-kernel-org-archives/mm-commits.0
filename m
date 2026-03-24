Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CE33630A1
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388627; cv=none; b=ZuDnxH02/FG2BNXixuyPoaSzrcjYja4J8nIc4CmS0LRZGoOXWc64bMiuV0ErMvOzrV7Ipe8DGAgzunnGecc5MZbJZ2rIc05LG20IScb/9hcmmDb6K5BStN/OeVlfVsO7D/nqEc+zxtREvAvH28qbFVoywoOia9XQDoxvPIXGEFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388627; c=relaxed/simple;
	bh=k7oXJQR4ZkqJtbjtkdZcDwtX3N7A9G8jYvejBCnTeBU=;
	h=Date:To:From:Subject:Message-Id; b=hgWvJbUz2kXaDQeJH6PVFDeXL2rf99PCQ/araNtIt/CUBYSMMOoAuwWOOjBtjSxbfCX972BoD1K2qCMOwUDZ0IEpTLK+orjkQSbbzv4oOWgSLfUX6Kil1cYvH3tt7+SrX+FWF2MZJCl/QPEToWSaZ1/IoLU7ebKXObeeGQN3GUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wn0k/Zq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wn0k/Zq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42464C19424;
	Tue, 24 Mar 2026 21:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388627;
	bh=k7oXJQR4ZkqJtbjtkdZcDwtX3N7A9G8jYvejBCnTeBU=;
	h=Date:To:From:Subject:From;
	b=Wn0k/Zq4VybQHiZCAC/PQrclI6JoLCgF2KtuVkT98wtnlXUclYvW9noFGRbqqf3FQ
	 LK7aS5vJeYdOCN5Z8JpEh7WIsTvYKVubf2pb/kKkCA9POLG+RH8W509lMMB8m6VSxD
	 HGfJkXsgXEZym18TghiR5e98EQBV/dPexn3FEo4Q=
Date: Tue, 24 Mar 2026 14:43:46 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,gaoxu2@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-use-statically-allocated-compression-algorithm-names.patch removed from -mm tree
Message-Id: <20260324214347.42464C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: use statically allocated compression algorithm names
has been removed from the -mm tree.  Its filename was
     zram-use-statically-allocated-compression-algorithm-names.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: gao xu <gaoxu2@honor.com>
Subject: zram: use statically allocated compression algorithm names
Date: Thu, 26 Feb 2026 12:37:22 +0000

Currently, zram dynamically allocates memory for compressor algorithm
names when they are set by the user.  This requires careful memory
management, including explicit `kfree` calls and special handling to avoid
freeing statically defined default compressor names.

This patch refactors the way zram handles compression algorithm names. 
Instead of storing dynamically allocated copies, `zram->comp_algs` will
now store pointers directly to the static name strings defined within the
`zcomp_ops` backend structures, thereby removing the need for conditional
`kfree` calls.

Link: https://lkml.kernel.org/r/5bb2e9318d124dbcb2b743dcdce6a950@honor.com
Signed-off-by: gao xu <gaoxu2@honor.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    9 +++++++--
 drivers/block/zram/zcomp.h    |    2 +-
 drivers/block/zram/zram_drv.c |   28 +++++-----------------------
 3 files changed, 13 insertions(+), 26 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-use-statically-allocated-compression-algorithm-names
+++ a/drivers/block/zram/zcomp.c
@@ -84,9 +84,14 @@ static const struct zcomp_ops *lookup_ba
 	return backends[i];
 }
 
-bool zcomp_available_algorithm(const char *comp)
+const char *zcomp_lookup_backend_name(const char *comp)
 {
-	return lookup_backend_ops(comp) != NULL;
+	const struct zcomp_ops *backend = lookup_backend_ops(comp);
+
+	if (backend)
+		return backend->name;
+
+	return NULL;
 }
 
 /* show available compressors */
--- a/drivers/block/zram/zcomp.h~zram-use-statically-allocated-compression-algorithm-names
+++ a/drivers/block/zram/zcomp.h
@@ -80,7 +80,7 @@ struct zcomp {
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node);
 int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node);
 ssize_t zcomp_available_show(const char *comp, char *buf, ssize_t at);
-bool zcomp_available_algorithm(const char *comp);
+const char *zcomp_lookup_backend_name(const char *comp);
 
 struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params);
 void zcomp_destroy(struct zcomp *comp);
--- a/drivers/block/zram/zram_drv.c~zram-use-statically-allocated-compression-algorithm-names
+++ a/drivers/block/zram/zram_drv.c
@@ -1621,43 +1621,29 @@ static void zram_debugfs_unregister(stru
 
 static void comp_algorithm_set(struct zram *zram, u32 prio, const char *alg)
 {
-	/* Do not free statically defined compression algorithms */
-	if (zram->comp_algs[prio] != default_compressor)
-		kfree(zram->comp_algs[prio]);
-
 	zram->comp_algs[prio] = alg;
 }
 
 static int __comp_algorithm_store(struct zram *zram, u32 prio, const char *buf)
 {
-	char *compressor;
+	const char *alg;
 	size_t sz;
 
 	sz = strlen(buf);
 	if (sz >= ZRAM_MAX_ALGO_NAME_SZ)
 		return -E2BIG;
 
-	compressor = kstrdup(buf, GFP_KERNEL);
-	if (!compressor)
-		return -ENOMEM;
-
-	/* ignore trailing newline */
-	if (sz > 0 && compressor[sz - 1] == '\n')
-		compressor[sz - 1] = 0x00;
-
-	if (!zcomp_available_algorithm(compressor)) {
-		kfree(compressor);
+	alg = zcomp_lookup_backend_name(buf);
+	if (!alg)
 		return -EINVAL;
-	}
 
 	guard(rwsem_write)(&zram->dev_lock);
 	if (init_done(zram)) {
-		kfree(compressor);
 		pr_info("Can't change algorithm for initialized device\n");
 		return -EBUSY;
 	}
 
-	comp_algorithm_set(zram, prio, compressor);
+	comp_algorithm_set(zram, prio, alg);
 	return 0;
 }
 
@@ -2840,12 +2826,8 @@ static void zram_destroy_comps(struct zr
 		zram->num_active_comps--;
 	}
 
-	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
-		/* Do not free statically defined compression algorithms */
-		if (zram->comp_algs[prio] != default_compressor)
-			kfree(zram->comp_algs[prio]);
+	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++)
 		zram->comp_algs[prio] = NULL;
-	}
 
 	zram_comp_params_reset(zram);
 }
_

Patches currently in -mm which might be from gaoxu2@honor.com are

zram-optimize-lz4-dictionary-compression-performance-v2.patch

