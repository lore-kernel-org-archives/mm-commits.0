Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794437017;
	b=Jvx6jFrEhm1E/VAh93ojwVhSX5gyOlUBcCdbCMeB6v7izV/J1umdMCOr03fsLxSvMviI
	 yXLWSBdnn3d7PQDQiJruwPj8+Dw0FBIBLYxlRA7mLiDvF5kkVU52TMn6aLp2zTGNch2b0
	 AZ9Gth6Vr9ksyWgPkVfC2Ot7G9RQ+WAPxypsJoGUQKiq3UuXWXYLSXdLLJK1bMLIV4U5y
	 mucC1G0yvSoSqphJEMyW6+019EfI16kmYpmyJfCwB9tLHnybUed+xBoIXopn6+izKTFY0
	 I6wzV/cVQhsRanDwpRVCCkdILgcXBUU9kM1lntdwhZFOzoOPXTqLpA2jILGBPmlL+qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794437017;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=EXUR0dM6mQ5fwbMLioj5CYmnTd/5hzfkOQTJjdvwnGk=;
	b=Is7NoWo54WAzEGKb4Q4NhzT5RLR3qYvL9aQB8tNsorghX9pmzpRy6JH8Axf2c3Zchf/d
	 YJQm8TvzxNvtUnCTi2bJ/LprG3BJvkbE2lPUsv9jYr1G2eLLB/Oe9n9/z2BlUGx1BZaGj
	 IcTsSbfYLAREJT9uOzA58amp3LaeSJCxEeaDAZWV4tDgp+MB/PrEsj4u8JWB/lZeSioOQ
	 hWXzlUgXaQn2aFKrMfebDy+fAsZPbDO3c/zQWWClfw35NX7ENK5nNy1qooLbJkyphERkN
	 q5XrbpCKw6Lx448oi0RcBvB9sVermrSA5ZdejvFJ2N6GVQ26t/3VoNteVK9GDFQ9w5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pHRfvxyC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA94606B017
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 22:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pHRfvxyC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342EA1F00ACC;
	Wed, 11 Nov 2026 22:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794437017;
	bh=EXUR0dM6mQ5fwbMLioj5CYmnTd/5hzfkOQTJjdvwnGk=;
	h=Date:To:From:Subject;
	b=pHRfvxyCQlIuvg+mioF0A6pS5GsYUgJ5SjOocyzTIvQBZH10BYHDB+XX0IJp6bRYb
	 3Extpery93Il7Nr/JEE6WEXXvZTkiChK4UrK0gXa4nGOwnmmt9E9Ad8nXyFdhvDuoj
	 emUl6oa+LCu9zlaBcarJc/O1Ln0JOJ5/XgGlDVgk=
Date: Wed, 11 Nov 2026 14:43:36 -0800
To: mm-commits@vger.kernel.org,vignesh.raman@collabora.com,vbabka@kernel.org,
	tzimmermann@suse.de,svens@linux.ibm.com,surenb@google.com,
	skhan@linuxfoundation.org,si.yanteng@linux.dev,simona@ffwll.ch,
	senozhatsky@chromium.org,rppt@kernel.org,rdunlap@infradead.org,
	nphamcs@gmail.com,mripard@kernel.org,minchan@kernel.org,mhocko@suse.com,
	maarten.lankhorst@linux.intel.com,ljs@kernel.org,liam@infradead.org,
	helen.fornazier@gmail.com,hca@linux.ibm.com,gor@linux.ibm.com,
	dzm91@hust.edu.cn,david@kernel.org,corbet@lwn.net,borntraeger@linux.ibm.com,
	alexs@kernel.org,airlied@gmail.com,agordeev@linux.ibm.com,
	xueyuan.chen21@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-remove-config_zsmalloc_stat.patch added to mm-new branch
Message-Id: <20261111224337.342EA1F00ACC@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
has been added to the -mm mm-new branch.  Its filename is
     mm-zsmalloc-remove-config_zsmalloc_stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-remove-config_zsmalloc_stat.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
Date: Wed, 11 Nov 2026 20:41:26 +0800

CONFIG_ZSMALLOC_STAT only controls the debugfs interface.  The class
counters are updated regardless of this option.

Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API stubs
when CONFIG_DEBUG_FS=n.  Skip statistics setup silently when debugfs is
unavailable.

Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
settings with CONFIG_DEBUG_FS=y.  Update the English and Chinese
documentation to match, and clarify the pool name in the debugfs path.

Link: https://lore.kernel.org/20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Helen Koike <helen.fornazier@gmail.com>
Cc: Vignesh Raman <vignesh.raman@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
---

 Documentation/mm/zsmalloc.rst                    |    4 -
 Documentation/translations/zh_CN/mm/zsmalloc.rst |    2 
 arch/s390/configs/debug_defconfig                |    2 
 arch/s390/configs/defconfig                      |    2 
 drivers/gpu/drm/ci/arm.config                    |    2 
 drivers/gpu/drm/ci/arm64.config                  |    2 
 drivers/gpu/drm/ci/x86_64.config                 |    2 
 mm/Kconfig                                       |    9 ---
 mm/zsmalloc.c                                    |   33 -------------
 9 files changed, 10 insertions(+), 48 deletions(-)

--- a/arch/s390/configs/debug_defconfig~mm-zsmalloc-remove-config_zsmalloc_stat
+++ a/arch/s390/configs/debug_defconfig
@@ -100,7 +100,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_IOSCHED_BFQ=y
 CONFIG_BINFMT_MISC=m
 CONFIG_ZSWAP=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 CONFIG_SLAB_BUCKETS=y
 CONFIG_SLUB_STATS=y
 # CONFIG_COMPAT_BRK is not set
--- a/arch/s390/configs/defconfig~mm-zsmalloc-remove-config_zsmalloc_stat
+++ a/arch/s390/configs/defconfig
@@ -94,7 +94,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_IOSCHED_BFQ=y
 CONFIG_BINFMT_MISC=m
 CONFIG_ZSWAP=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 CONFIG_SLAB_BUCKETS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MEMORY_HOTPLUG=y
--- a/Documentation/mm/zsmalloc.rst~mm-zsmalloc-remove-config_zsmalloc_stat
+++ a/Documentation/mm/zsmalloc.rst
@@ -33,8 +33,8 @@ proper handle-based APIs.
 stat
 ====
 
-With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
-``/sys/kernel/debug/zsmalloc/<user name>``. Here is a sample of stat output::
+With CONFIG_DEBUG_FS, we could see zsmalloc internal information via
+``/sys/kernel/debug/zsmalloc/<pool-name>``. Here is a sample of stat output::
 
  # cat /sys/kernel/debug/zsmalloc/zram0/classes
 
--- a/Documentation/translations/zh_CN/mm/zsmalloc.rst~mm-zsmalloc-remove-config_zsmalloc_stat
+++ a/Documentation/translations/zh_CN/mm/zsmalloc.rst
@@ -32,7 +32,7 @@ zs_unmap_object()解除映射。
 stat
 ====
 
-通过CONFIG_ZSMALLOC_STAT，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
+启用CONFIG_DEBUG_FS，我们可以通过 ``/sys/kernel/debug/zsmalloc/<pool-name>``
 看到zsmalloc内部信息。下面是一个统计输出的例子。::
 
  # cat /sys/kernel/debug/zsmalloc/zram0/classes
--- a/drivers/gpu/drm/ci/arm64.config~mm-zsmalloc-remove-config_zsmalloc_stat
+++ a/drivers/gpu/drm/ci/arm64.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
 CONFIG_BLK_DEV_INITRD=n
--- a/drivers/gpu/drm/ci/arm.config~mm-zsmalloc-remove-config_zsmalloc_stat
+++ a/drivers/gpu/drm/ci/arm.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
 CONFIG_BLK_DEV_INITRD=n
--- a/drivers/gpu/drm/ci/x86_64.config~mm-zsmalloc-remove-config_zsmalloc_stat
+++ a/drivers/gpu/drm/ci/x86_64.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 CONFIG_PWM=y
 CONFIG_PM_DEVFREQ=y
--- a/mm/Kconfig~mm-zsmalloc-remove-config_zsmalloc_stat
+++ a/mm/Kconfig
@@ -130,15 +130,6 @@ menu "Zsmalloc allocator options"
 
 comment "Zsmalloc is a common backend allocator for zswap & zram"
 
-config ZSMALLOC_STAT
-	bool "Export zsmalloc statistics"
-	select DEBUG_FS
-	help
-	  This option enables code in the zsmalloc to collect various
-	  statistics about what's happening in zsmalloc and exports that
-	  information to userspace via debugfs.
-	  If unsure, say N.
-
 config ZSMALLOC_CHAIN_SIZE
 	int "Maximum number of physical pages per-zspage"
 	default 8
--- a/mm/zsmalloc.c~mm-zsmalloc-remove-config_zsmalloc_stat
+++ a/mm/zsmalloc.c
@@ -222,9 +222,7 @@ struct zs_size_stat {
 	unsigned long objs[NR_CLASS_STAT_TYPES];
 };
 
-#ifdef CONFIG_ZSMALLOC_STAT
 static struct dentry *zs_stat_root;
-#endif
 
 static size_t huge_class_size;
 
@@ -279,9 +277,7 @@ struct zs_pool {
 	/* Compact classes */
 	struct shrinker *shrinker;
 
-#ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
-#endif
 #ifdef CONFIG_COMPACTION
 	struct work_struct free_work;
 #endif
@@ -565,14 +561,10 @@ static inline unsigned long class_stat_r
 	return class->stats.objs[type];
 }
 
-#ifdef CONFIG_ZSMALLOC_STAT
-
 static void __init zs_stat_init(void)
 {
-	if (!debugfs_initialized()) {
-		pr_warn("debugfs not available, stat dir not created\n");
+	if (!debugfs_initialized())
 		return;
-	}
 
 	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
 }
@@ -650,10 +642,8 @@ DEFINE_SHOW_ATTRIBUTE(zs_stats_size);
 
 static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
-	if (!zs_stat_root) {
-		pr_warn("no root stat dir, not creating <%s> stat dir\n", name);
+	if (IS_ERR_OR_NULL(zs_stat_root))
 		return;
-	}
 
 	pool->stat_dentry = debugfs_create_dir(name, zs_stat_root);
 
@@ -666,25 +656,6 @@ static void zs_pool_stat_destroy(struct
 	debugfs_remove_recursive(pool->stat_dentry);
 }
 
-#else /* CONFIG_ZSMALLOC_STAT */
-static void __init zs_stat_init(void)
-{
-}
-
-static void __exit zs_stat_exit(void)
-{
-}
-
-static inline void zs_pool_stat_create(struct zs_pool *pool, const char *name)
-{
-}
-
-static inline void zs_pool_stat_destroy(struct zs_pool *pool)
-{
-}
-#endif
-
-
 /*
  * For each size class, zspages are divided into different groups
  * depending on their usage ratio. This function returns fullness
_

Patches currently in -mm which might be from xueyuan.chen21@gmail.com are

mm-zsmalloc-remove-config_zsmalloc_stat.patch

