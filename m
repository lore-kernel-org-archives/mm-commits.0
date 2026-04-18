Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86AD3469EE
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498713; cv=none; b=Uk7kviMLDqihDYYuGPss09OA3ZC3mLfMpcvOxUAvjegJICWDm8ckbnwUYmZ4BTbVyvw3svWsQBJKwwr12KWswm38zat/95MX54A2VOqAA5Pzb2qR9ABTXPWBI4ogpHcoJ+kZXCE/DjvYId5mQ5MnNOslPepPGVreSGzGIBEm8kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498713; c=relaxed/simple;
	bh=3TztFBCVfP0hkjchjKLV1+I3nyTkw7g33JEcR4A3oSs=;
	h=Date:To:From:Subject:Message-Id; b=lyiupOIfnUo0vPHkHwB7/0w4yEICBHJKqnbB5K07sVlQI4cCeJP/BTb5j+7AIJTd1vZkMhP50dus4o9vcXItqP6u+rKKfx2JKdNHxBNxPTu4TSFp4krTCU24kd0AL+s1BotPRQ39eJVqIJuwpHYG4MvAulfl7yK5muuUN2BaJFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OpZ2JN+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OpZ2JN+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99919C19424;
	Sat, 18 Apr 2026 07:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498713;
	bh=3TztFBCVfP0hkjchjKLV1+I3nyTkw7g33JEcR4A3oSs=;
	h=Date:To:From:Subject:From;
	b=OpZ2JN+u9bYNW9vzf02sbOeiU1A+yusXL5lwbZwQFwhwZMMqaiHlcnpCKnETXfRIb
	 mEUHL1/CEFr2fadnpAbVqkg1la1AoLDvB0iP3BlexgYfxbcI/sWcnXOhA+MjcC8D3R
	 1omvwxWroww3z0mR9WHFaL0lCHrnYYq741ZVXSq4=
Date: Sat, 18 Apr 2026 00:51:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-persist-blob-size-in-kho-fdt.patch removed from -mm tree
Message-Id: <20260418075152.99919C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: persist blob size in KHO FDT
has been removed from the -mm tree.  Its filename was
     kho-persist-blob-size-in-kho-fdt.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: kho: persist blob size in KHO FDT
Date: Mon, 16 Mar 2026 04:54:33 -0700

kho_add_subtree() accepts a size parameter but only forwards it to
debugfs.  The size is not persisted in the KHO FDT, so it is lost across
kexec.  This makes it impossible for the incoming kernel to determine the
blob size without understanding the blob format.

Store the blob size as a "blob-size" property in the KHO FDT alongside the
"preserved-data" physical address.  This allows the receiving kernel to
recover the size for any blob regardless of format.

Also extend kho_retrieve_subtree() with an optional size output parameter
so callers can learn the blob size without needing to understand the blob
format.  Update all callers to pass NULL for the new parameter.

Link: https://lore.kernel.org/20260316-kho-v9-3-ed6dcd951988@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h             |    5 ++-
 include/linux/kho/abi/kexec_handover.h     |   20 +++++++++++---
 kernel/liveupdate/kexec_handover.c         |   27 +++++++++++++++----
 kernel/liveupdate/kexec_handover_debugfs.c |    3 +-
 kernel/liveupdate/luo_core.c               |    2 -
 lib/test_kho.c                             |    2 -
 mm/memblock.c                              |    2 -
 7 files changed, 46 insertions(+), 15 deletions(-)

--- a/include/linux/kexec_handover.h~kho-persist-blob-size-in-kho-fdt
+++ a/include/linux/kexec_handover.h
@@ -34,7 +34,7 @@ struct page *kho_restore_pages(phys_addr
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *blob, size_t size);
 void kho_remove_subtree(void *blob);
-int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
+int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
 
 void kho_memory_init(void);
 
@@ -104,7 +104,8 @@ static inline int kho_add_subtree(const
 
 static inline void kho_remove_subtree(void *blob) { }
 
-static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
+static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys,
+				       size_t *size)
 {
 	return -EOPNOTSUPP;
 }
--- a/include/linux/kho/abi/kexec_handover.h~kho-persist-blob-size-in-kho-fdt
+++ a/include/linux/kho/abi/kexec_handover.h
@@ -41,25 +41,28 @@
  *   restore the preserved data.::
  *
  *     / {
- *         compatible = "kho-v2";
+ *         compatible = "kho-v3";
  *
  *         preserved-memory-map = <0x...>;
  *
  *         <subnode-name-1> {
  *             preserved-data = <0x...>;
+ *             blob-size = <0x...>;
  *         };
  *
  *         <subnode-name-2> {
  *             preserved-data = <0x...>;
+ *             blob-size = <0x...>;
  *         };
  *               ... ...
  *         <subnode-name-N> {
  *             preserved-data = <0x...>;
+ *             blob-size = <0x...>;
  *         };
  *     };
  *
  *   Root KHO Node (/):
- *     - compatible: "kho-v2"
+ *     - compatible: "kho-v3"
  *
  *       Indentifies the overall KHO ABI version.
  *
@@ -78,16 +81,25 @@
  *
  *       Physical address pointing to a subnode data blob that is also
  *       being preserved.
+ *
+ *     - blob-size: u64
+ *
+ *       Size in bytes of the preserved data blob. This is needed because
+ *       blobs may use arbitrary formats (not just FDT), so the size
+ *       cannot be determined from the blob content alone.
  */
 
 /* The compatible string for the KHO FDT root node. */
-#define KHO_FDT_COMPATIBLE "kho-v2"
+#define KHO_FDT_COMPATIBLE "kho-v3"
 
 /* The FDT property for the preserved memory map. */
 #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
 
 /* The FDT property for preserved data blobs. */
-#define KHO_FDT_SUB_TREE_PROP_NAME "preserved-data"
+#define KHO_SUB_TREE_PROP_NAME "preserved-data"
+
+/* The FDT property for the size of preserved data blobs. */
+#define KHO_SUB_TREE_SIZE_PROP_NAME "blob-size"
 
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
--- a/kernel/liveupdate/kexec_handover.c~kho-persist-blob-size-in-kho-fdt
+++ a/kernel/liveupdate/kexec_handover.c
@@ -743,6 +743,7 @@ int kho_add_subtree(const char *name, vo
 {
 	phys_addr_t phys = virt_to_phys(blob);
 	void *root_fdt = kho_out.fdt;
+	u64 size_u64 = size;
 	int err = -ENOMEM;
 	int off, fdt_err;
 
@@ -759,11 +760,16 @@ int kho_add_subtree(const char *name, vo
 		goto out_pack;
 	}
 
-	err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
+	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
 			  &phys, sizeof(phys));
 	if (err < 0)
 		goto out_pack;
 
+	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
+			  &size_u64, sizeof(size_u64));
+	if (err < 0)
+		goto out_pack;
+
 	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
 					  size, false));
 
@@ -792,7 +798,7 @@ void kho_remove_subtree(void *blob)
 		const u64 *val;
 		int len;
 
-		val = fdt_getprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME, &len);
+		val = fdt_getprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME, &len);
 		if (!val || len != sizeof(phys_addr_t))
 			continue;
 
@@ -1297,13 +1303,14 @@ EXPORT_SYMBOL_GPL(is_kho_boot);
  * kho_retrieve_subtree - retrieve a preserved sub blob by its name.
  * @name: the name of the sub blob passed to kho_add_subtree().
  * @phys: if found, the physical address of the sub blob is stored in @phys.
+ * @size: if not NULL and found, the size of the sub blob is stored in @size.
  *
  * Retrieve a preserved sub blob named @name and store its physical
- * address in @phys.
+ * address in @phys and optionally its size in @size.
  *
  * Return: 0 on success, error code on failure
  */
-int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
+int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
 {
 	const void *fdt = kho_get_fdt();
 	const u64 *val;
@@ -1319,12 +1326,22 @@ int kho_retrieve_subtree(const char *nam
 	if (offset < 0)
 		return -ENOENT;
 
-	val = fdt_getprop(fdt, offset, KHO_FDT_SUB_TREE_PROP_NAME, &len);
+	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_PROP_NAME, &len);
 	if (!val || len != sizeof(*val))
 		return -EINVAL;
 
 	*phys = (phys_addr_t)*val;
 
+	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_SIZE_PROP_NAME, &len);
+	if (!val || len != sizeof(*val)) {
+		pr_warn("broken KHO subnode '%s': missing or invalid blob-size property\n",
+			name);
+		return -EINVAL;
+	}
+
+	if (size)
+		*size = (size_t)*val;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
--- a/kernel/liveupdate/kexec_handover_debugfs.c~kho-persist-blob-size-in-kho-fdt
+++ a/kernel/liveupdate/kexec_handover_debugfs.c
@@ -125,7 +125,8 @@ __init void kho_in_debugfs_init(struct k
 		const u64 *fdt_phys;
 		void *sub_fdt;
 
-		fdt_phys = fdt_getprop(fdt, child, KHO_FDT_SUB_TREE_PROP_NAME, &len);
+		fdt_phys = fdt_getprop(fdt, child,
+					KHO_SUB_TREE_PROP_NAME, &len);
 		if (!fdt_phys)
 			continue;
 		if (len != sizeof(*fdt_phys)) {
--- a/kernel/liveupdate/luo_core.c~kho-persist-blob-size-in-kho-fdt
+++ a/kernel/liveupdate/luo_core.c
@@ -88,7 +88,7 @@ static int __init luo_early_startup(void
 	}
 
 	/* Retrieve LUO subtree, and verify its format. */
-	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys);
+	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys, NULL);
 	if (err) {
 		if (err != -ENOENT) {
 			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
--- a/lib/test_kho.c~kho-persist-blob-size-in-kho-fdt
+++ a/lib/test_kho.c
@@ -319,7 +319,7 @@ static int __init kho_test_init(void)
 	if (!kho_is_enabled())
 		return 0;
 
-	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
+	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys, NULL);
 	if (!err) {
 		err = kho_test_restore(fdt_phys);
 		if (err)
--- a/mm/memblock.c~kho-persist-blob-size-in-kho-fdt
+++ a/mm/memblock.c
@@ -2555,7 +2555,7 @@ static void *__init reserve_mem_kho_retr
 	if (fdt)
 		return fdt;
 
-	err = kho_retrieve_subtree(MEMBLOCK_KHO_FDT, &fdt_phys);
+	err = kho_retrieve_subtree(MEMBLOCK_KHO_FDT, &fdt_phys, NULL);
 	if (err) {
 		if (err != -ENOENT)
 			pr_warn("failed to retrieve FDT '%s' from KHO: %d\n",
_

Patches currently in -mm which might be from leitao@debian.org are

mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

