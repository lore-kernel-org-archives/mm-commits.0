Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9897D42DFF6
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 16:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772124316; cv=none; b=pQK0Gf+8i4tzW3zoHlaZq3jpSXOc2vf5kj5u7/HMzRQtnOnG6OI8xi44hv229BtSKPju3VUxWxR/LDSmL2skXNo1XFGBsVKCotKLVLQMmeU42bIhW9ameLtmFKDKNpOB8OVtVHKEZ6bK8TZx0pYmJH7Uw+EtnY3aZdTEn7/px9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772124316; c=relaxed/simple;
	bh=tE3xI9cNH5e3/T+fl0HxoE5IcxCksirv3FCaiLoqlXc=;
	h=Date:To:From:Subject:Message-Id; b=a/KNQJXcrt2szXrN41ibot+H/K1nMBxkvkW6A4S7ksaEJ3khphW+YtQmrpBff+AoWRraixlik5ugUv21vUtr0nljT2dFXEZuQ+1kUYQHYBCtqlb9wkrkxeyYOPXj5C6Sc/lsnxPArmta6r5RoLpBhTbE+dm+ZUhPfbs2rH5eTIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mdt+QJIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mdt+QJIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CA7C116C6;
	Thu, 26 Feb 2026 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772124316;
	bh=tE3xI9cNH5e3/T+fl0HxoE5IcxCksirv3FCaiLoqlXc=;
	h=Date:To:From:Subject:From;
	b=Mdt+QJIuphPzXET8QMRnTFudB3Q8QhuihKMHfYN80yciyuhTR0LBl6OMS/x7r0GZK
	 JXk3NONfAqp+gutbxLzoVGxG3e4KTJ74gsBt2TUvOfwg3bdaUIan2UWc11tdPRJvR6
	 Db6CSpkXi191iQ33QgNzKxiB1YrmkuXuFeMHZo7U=
Date: Thu, 26 Feb 2026 08:45:15 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,gaoxu2@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-use-statically-allocated-compression-algorithm-names.patch added to mm-new branch
Message-Id: <20260226164516.21CA7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: use statically allocated compression algorithm names
has been added to the -mm mm-new branch.  Its filename is
     zram-use-statically-allocated-compression-algorithm-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-statically-allocated-compression-algorithm-names.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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
@@ -1637,43 +1637,29 @@ static void zram_debugfs_unregister(stru
 
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
 
@@ -2851,12 +2837,8 @@ static void zram_destroy_comps(struct zr
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

zram-use-statically-allocated-compression-algorithm-names.patch

