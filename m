Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539730;
	b=01L6F42E2AWG1ZfeA2IkkRTAGLmaA06G7v75LdeJluj6DExXcQLHz8fFsOCMPBvomns7
	 Z8Le3QyS9lV4eiTfsw9bmgKLADoSqno/wqv+t8H9FBPkhHhGDh8wKkxOdu0q0WC6/8jE1
	 XhcIsoHxKQ5yo64GHrJkwFlQ4smunNLPTMpsR5UQmeoI5qxTf+XXqxNtKzH0t2DArUkFI
	 jakASRpoQ2/X1H4Hu0fkMg+nEVk/XGkvfKMBsStN1LwlUrRXTO2UPO36kCf/sgEVKmawG
	 6gokZP3YiMBMxtuvLg/sdo5JDTRlUHyz0BpYqctKeDJwfFU/FXrkcwYkzRuZUkUGlPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539730;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+b1cecvpR5YreIrdcOjSBHf5frKcqECAmpg/AMzc+Js=;
	b=BxW2PncISS+hvCEDTvApjDjSZIS/XxBIGK1ZUYosqB0AfRYil7XmOUZaYvXD50eLA7Ox
	 AZtdlY7uhb0Ojn4VjzmN/QtMqhmiDyYM3u+RnN91Sf3B5OG2ACjTUyhVdsVzysmK0Kozo
	 Gh9il4yt2SMoQeGW45UV9dz1MM5Kss6WQe+VDpLQXTeovXn+TAtYoiWWBkwpiNgebWEcf
	 yGtseUb8AtF+guBhwTqtP+eSsxmQAmJs53JWj5Uaurshn6vpIjq0VLSYHBxwLfMVEhytD
	 4Re/ICbkNdhhrNLFnsHtLxMf5QdFPVTn6NQ8muemOasLaf+mvQa3eHhSavB1LWcAvRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Mn4u+ElU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D51D606A331
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 03:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Mn4u+ElU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89401F000C4;
	Fri, 13 Nov 2026 03:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794539729;
	bh=+b1cecvpR5YreIrdcOjSBHf5frKcqECAmpg/AMzc+Js=;
	h=Date:To:From:Subject;
	b=Mn4u+ElUR2B+uCT6t3zMYSm1hzalbj3rnk96zdW/vYb7cjwSEPmxxDT4yWcJPc0g3
	 4fY4LE0Jjke7iDsyPGILDhzeJQm/5HGL7xyF5+QVMo4WYOPHfvlYRV5nCIA7b1/kS0
	 1bsGRmhxDMqSXEGxiOBRKvW/lol34Rx57X/x8o3g=
Date: Thu, 12 Nov 2026 19:15:29 -0800
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
Subject: [to-be-updated] mm-zsmalloc-remove-config_zsmalloc_stat.patch removed from -mm tree
Message-Id: <20261113031529.D89401F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-remove-config_zsmalloc_stat.patch

This patch was dropped because an updated version will be issued

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
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
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
@@ -37,8 +37,8 @@ the proper handle-based APIs.
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
@@ -226,9 +226,7 @@ struct zs_size_stat {
 	unsigned long objs[NR_CLASS_STAT_TYPES];
 };
 
-#ifdef CONFIG_ZSMALLOC_STAT
 static struct dentry *zs_stat_root;
-#endif
 
 static size_t huge_class_size;
 
@@ -282,9 +280,7 @@ struct zs_pool {
 	/* Compact classes */
 	struct shrinker *shrinker;
 
-#ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
-#endif
 #ifdef CONFIG_COMPACTION
 	struct work_struct free_work;
 #endif
@@ -564,14 +560,10 @@ static inline unsigned long class_stat_r
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
@@ -649,10 +641,8 @@ DEFINE_SHOW_ATTRIBUTE(zs_stats_size);
 
 static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
-	if (!zs_stat_root) {
-		pr_warn("no root stat dir, not creating <%s> stat dir\n", name);
+	if (IS_ERR_OR_NULL(zs_stat_root))
 		return;
-	}
 
 	pool->stat_dentry = debugfs_create_dir(name, zs_stat_root);
 
@@ -665,25 +655,6 @@ static void zs_pool_stat_destroy(struct
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


