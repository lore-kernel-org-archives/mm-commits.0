Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026563815E1
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 21:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303192; cv=none; b=Jo9xRwx6lk1GVqKgamvz+fI3gwpIHIqgPUu/qWrmV97Lw041GuFOtCvYhgeuvk+KuPS7g9OQDxPN198wTGzRTH7pjXRxrBi8JfVghq82wkVCpN8vl3c+pfnkBA32/tldz2NgHinslX1EIZi2QJqnJ+1QImFfTpU0Ikk9/Wmenz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303192; c=relaxed/simple;
	bh=6Co3+1/j225gtIog+0SXSQpmUADEHmcZrz8ZJ5GGLG0=;
	h=Date:To:From:Subject:Message-Id; b=uVrijzmqR0n4tIRek4yxZZMBYrMgsodwOKxzSzEGUs6Aj4RHKQ3wl63XrWHNLXrn6nH06JKFcCzu+ZqcgBdEwpkGmvreJqX0TTD01g12XrDUTnr9YtZWUpRIZp5RvqeoDHHEIuzeXgI3YQEl9f+jki0PCsiFkmRf2CL+9TtDn5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sd0lgUKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sd0lgUKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D406C4CEF7;
	Mon, 23 Mar 2026 21:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774303191;
	bh=6Co3+1/j225gtIog+0SXSQpmUADEHmcZrz8ZJ5GGLG0=;
	h=Date:To:From:Subject:From;
	b=Sd0lgUKGevU4aqK8XL3u1FU0hJgFO8q71OzS9L8E751A+9qwYKWfmXPDr4HkiLl9g
	 7NnjXsZVG2G5qvVI3AJjj9YyelWprCK/sREhs+fsYlUKyyPVJZ9Th58ilpvUMk6Fzd
	 qAfYjpmEuUIW03FYi4AXn1Me4Y/IU7XpccIAUeKs=
Date: Mon, 23 Mar 2026 14:59:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-persist-blob-size-in-kho-fdt.patch added to mm-nonmm-unstable branch
Message-Id: <20260323215951.6D406C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: persist blob size in KHO FDT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-persist-blob-size-in-kho-fdt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-persist-blob-size-in-kho-fdt.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lkml.kernel.org/r/20260316-kho-v9-3-ed6dcd951988@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
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

mm-khugepaged-export-set_recommended_min_free_kbytes.patch
mm-huge_memory-refactor-anon_enabled_store-with-set_anon_enabled_mode.patch
mm-huge_memory-refactor-enabled_store-with-set_global_enabled_mode.patch
mm-ratelimit-min_free_kbytes-adjustment-messages.patch
mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-document-kexec-metadata-tracking-feature.patch

