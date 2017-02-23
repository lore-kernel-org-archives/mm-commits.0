From: akpm@linux-foundation.org
Subject: [merged]
 slub-make-sysfs-directories-for-memcg-sub-caches-optional.patch removed
 from -mm tree
Date: Thu, 23 Feb 2017 13:12:49 -0800
Message-ID: <58af5051.Av/KYNIYHEVDy2H1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdBWVMu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: make sysfs directories for memcg sub-caches optional
has been removed from the -mm tree.  Its filename was
     slub-make-sysfs-directories-for-memcg-sub-caches-optional.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: slub: make sysfs directories for memcg sub-caches optional

SLUB creates a per-cache directory under /sys/kernel/slab which hosts a
bunch of debug files.  Usually, there aren't that many caches on a system
and this doesn't really matter; however, if memcg is in use, each cache
can have per-cgroup sub-caches.  SLUB creates the same directories for
these sub-caches under /sys/kernel/slab/$CACHE/cgroup.

Unfortunately, because there can be a lot of cgroups, active or draining,
the product of the numbers of caches, cgroups and files in each directory
can reach a very high number - hundreds of thousands is commonplace. 
Millions and beyond aren't difficult to reach either.

What's under /sys/kernel/slab is primarily for debugging and the
information and control on the a root cache already cover its sub-caches. 
While having a separate directory for each sub-cache can be helpful for
development, it doesn't make much sense to pay this amount of overhead by
default.

This patch introduces a boot parameter slub_memcg_sysfs which determines
whether to create sysfs directories for per-memcg sub-caches.  It also
adds CONFIG_SLUB_MEMCG_SYSFS_ON which determines the boot parameter's
default value and defaults to 0.

[akpm@linux-foundation.org: kset_unregister(NULL) is legal]
Link: http://lkml.kernel.org/r/20170204145203.GB26958@mtj.duckdns.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    8 ++++
 init/Kconfig                                    |   14 +++++++
 mm/slub.c                                       |   26 ++++++++++++--
 3 files changed, 46 insertions(+), 2 deletions(-)

diff -puN Documentation/admin-guide/kernel-parameters.txt~slub-make-sysfs-directories-for-memcg-sub-caches-optional Documentation/admin-guide/kernel-parameters.txt
--- a/Documentation/admin-guide/kernel-parameters.txt~slub-make-sysfs-directories-for-memcg-sub-caches-optional
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3694,6 +3694,14 @@
 			last alloc / free. For more information see
 			Documentation/vm/slub.txt.
 
+	slub_memcg_sysfs=	[MM, SLUB]
+			Determines whether to enable sysfs directories for
+			memory cgroup sub-caches. 1 to enable, 0 to disable.
+			The default is determined by CONFIG_SLUB_MEMCG_SYSFS_ON.
+			Enabling this can lead to a very high number of	debug
+			directories and files being created under
+			/sys/kernel/slub.
+
 	slub_max_order= [MM, SLUB]
 			Determines the maximum allowed order for slabs.
 			A high setting may cause OOMs due to memory
diff -puN init/Kconfig~slub-make-sysfs-directories-for-memcg-sub-caches-optional init/Kconfig
--- a/init/Kconfig~slub-make-sysfs-directories-for-memcg-sub-caches-optional
+++ a/init/Kconfig
@@ -1779,6 +1779,20 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+config SLUB_MEMCG_SYSFS_ON
+	default n
+	bool "Enable memcg SLUB sysfs support by default" if EXPERT
+	depends on SLUB && SYSFS && MEMCG
+	help
+	  SLUB creates a directory under /sys/kernel/slab for each
+	  allocation cache to host info and debug files. If memory
+	  cgroup is enabled, each cache can have per memory cgroup
+	  caches. SLUB can create the same sysfs directories for these
+	  caches under /sys/kernel/slab/CACHE/cgroup but it can lead
+	  to a very high number of debug files being created. This is
+	  controlled by slub_memcg_sysfs boot parameter and this
+	  config option determines the parameter's default value.
+
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
diff -puN mm/slub.c~slub-make-sysfs-directories-for-memcg-sub-caches-optional mm/slub.c
--- a/mm/slub.c~slub-make-sysfs-directories-for-memcg-sub-caches-optional
+++ a/mm/slub.c
@@ -4708,6 +4708,22 @@ enum slab_stat_type {
 #define SO_OBJECTS	(1 << SL_OBJECTS)
 #define SO_TOTAL	(1 << SL_TOTAL)
 
+#ifdef CONFIG_MEMCG
+static bool memcg_sysfs_enabled = IS_ENABLED(CONFIG_SLUB_MEMCG_SYSFS_ON);
+
+static int __init setup_slub_memcg_sysfs(char *str)
+{
+	int v;
+
+	if (get_option(&str, &v) > 0)
+		memcg_sysfs_enabled = v;
+
+	return 1;
+}
+
+__setup("slub_memcg_sysfs=", setup_slub_memcg_sysfs);
+#endif
+
 static ssize_t show_slab_objects(struct kmem_cache *s,
 			    char *buf, unsigned long flags)
 {
@@ -5611,8 +5627,14 @@ static int sysfs_slab_add(struct kmem_ca
 {
 	int err;
 	const char *name;
+	struct kset *kset = cache_kset(s);
 	int unmergeable = slab_unmergeable(s);
 
+	if (!kset) {
+		kobject_init(&s->kobj, &slab_ktype);
+		return 0;
+	}
+
 	if (unmergeable) {
 		/*
 		 * Slabcache can never be merged so we can use the name proper.
@@ -5629,7 +5651,7 @@ static int sysfs_slab_add(struct kmem_ca
 		name = create_unique_id(s);
 	}
 
-	s->kobj.kset = cache_kset(s);
+	s->kobj.kset = kset;
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
 	if (err)
 		goto out;
@@ -5639,7 +5661,7 @@ static int sysfs_slab_add(struct kmem_ca
 		goto out_del_kobj;
 
 #ifdef CONFIG_MEMCG
-	if (is_root_cache(s)) {
+	if (is_root_cache(s) && memcg_sysfs_enabled) {
 		s->memcg_kset = kset_create_and_add("cgroup", NULL, &s->kobj);
 		if (!s->memcg_kset) {
 			err = -ENOMEM;
_

Patches currently in -mm which might be from tj@kernel.org are


