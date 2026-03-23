Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BAD3822A6
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 21:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303188; cv=none; b=tnmLcYDIXJNzx85M4dh0wXe/R8oVOc83QSNqDKkEplPvfxVZPVuVpu+gWQtTUFLna3c4kgkWZGlVABMGH4/0p/cwwwOxjImcZSFDVBZJODsHbDq2nfISddpHr2XGV0nTAMOfYhxdoqn9+zH/vfXQIr9YZNa/93wMa4TbygaBiME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303188; c=relaxed/simple;
	bh=QhEOoOgRyQVUFcNbF2N2IbtaMeFLreb6wlOjYykHCsY=;
	h=Date:To:From:Subject:Message-Id; b=rYfpZtazQBOAW1w92B6diO1huaKVcf/WDcBaTi9qM/Jgo09AjYA+blqKrWCmDZz5mQ4/cXM54JpF7kWFaENYscPA6HmayPDWnmVLSabdNyIkZfcogOXb84aJ7NU/mrvLBnEit7ALtqRyXq64yyAa3G4bwiOQBpbSQ2GPpnsZhb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bvQ3lCu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bvQ3lCu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56738C4CEF7;
	Mon, 23 Mar 2026 21:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774303187;
	bh=QhEOoOgRyQVUFcNbF2N2IbtaMeFLreb6wlOjYykHCsY=;
	h=Date:To:From:Subject:From;
	b=bvQ3lCu1urUAX8uk7KN7OKOwMrbDxmn3LqdJG3hqLefsVWXevqSW8LNzPmZgDDtXe
	 FoTfhvb6Qidh5SrJZHGZrCIIeMk6NOO3DOCFyho3CGNaewNkgjMxyGmUU8QmktU3ER
	 luvVk81+muDiWQEI4qSXnoimmzSulOS7970YMhrs=
Date: Mon, 23 Mar 2026 14:59:46 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch added to mm-nonmm-unstable branch
Message-Id: <20260323215947.56738C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: rename fdt parameter to blob in kho_add/remove_subtree()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch

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
Subject: kho: rename fdt parameter to blob in kho_add/remove_subtree()
Date: Mon, 16 Mar 2026 04:54:32 -0700

Since kho_add_subtree() now accepts arbitrary data blobs (not just FDTs),
rename the parameter from 'fdt' to 'blob' to better reflect its purpose. 
Apply the same rename to kho_remove_subtree() for consistency.

Also rename kho_debugfs_fdt_add() and kho_debugfs_fdt_remove() to
kho_debugfs_blob_add() and kho_debugfs_blob_remove() respectively, with
the same parameter rename from 'fdt' to 'blob'.

Link: https://lkml.kernel.org/r/20260316-kho-v9-2-ed6dcd951988@debian.org
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

 Documentation/admin-guide/mm/kho.rst        |    2 -
 include/linux/kexec_handover.h              |    8 ++--
 kernel/liveupdate/kexec_handover.c          |   33 +++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c  |   25 +++++++------
 kernel/liveupdate/kexec_handover_internal.h |   16 ++++----
 5 files changed, 43 insertions(+), 41 deletions(-)

--- a/Documentation/admin-guide/mm/kho.rst~kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree
+++ a/Documentation/admin-guide/mm/kho.rst
@@ -80,5 +80,5 @@ stabilized.
     it finished to interpret their metadata.
 
 ``/sys/kernel/debug/kho/in/sub_fdts/``
-    Similar to ``kho/out/sub_fdts/``, but contains sub FDT blobs
+    Similar to ``kho/out/sub_fdts/``, but contains sub blobs
     of KHO producers passed from the old kernel.
--- a/include/linux/kexec_handover.h~kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree
+++ a/include/linux/kexec_handover.h
@@ -32,8 +32,8 @@ void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
-int kho_add_subtree(const char *name, void *fdt, size_t size);
-void kho_remove_subtree(void *fdt);
+int kho_add_subtree(const char *name, void *blob, size_t size);
+void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
 void kho_memory_init(void);
@@ -97,12 +97,12 @@ static inline void *kho_restore_vmalloc(
 	return NULL;
 }
 
-static inline int kho_add_subtree(const char *name, void *fdt, size_t size)
+static inline int kho_add_subtree(const char *name, void *blob, size_t size)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_remove_subtree(void *fdt) { }
+static inline void kho_remove_subtree(void *blob) { }
 
 static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 {
--- a/kernel/liveupdate/kexec_handover.c~kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree
+++ a/kernel/liveupdate/kexec_handover.c
@@ -724,13 +724,13 @@ err_disable_kho:
 }
 
 /**
- * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
+ * kho_add_subtree - record the physical address of a sub blob in KHO root tree.
  * @name: name of the sub tree.
- * @fdt: the sub tree blob.
+ * @blob: the sub tree blob.
  * @size: size of the blob in bytes.
  *
  * Creates a new child node named @name in KHO root FDT and records
- * the physical address of @fdt. The pages of @fdt must also be preserved
+ * the physical address of @blob. The pages of @blob must also be preserved
  * by KHO for the new kernel to retrieve it after kexec.
  *
  * A debugfs blob entry is also created at
@@ -739,9 +739,9 @@ err_disable_kho:
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(const char *name, void *fdt, size_t size)
+int kho_add_subtree(const char *name, void *blob, size_t size)
 {
-	phys_addr_t phys = virt_to_phys(fdt);
+	phys_addr_t phys = virt_to_phys(blob);
 	void *root_fdt = kho_out.fdt;
 	int err = -ENOMEM;
 	int off, fdt_err;
@@ -764,7 +764,8 @@ int kho_add_subtree(const char *name, vo
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
+	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
+					  size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -773,9 +774,9 @@ out_pack:
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-void kho_remove_subtree(void *fdt)
+void kho_remove_subtree(void *blob)
 {
-	phys_addr_t target_phys = virt_to_phys(fdt);
+	phys_addr_t target_phys = virt_to_phys(blob);
 	void *root_fdt = kho_out.fdt;
 	int off;
 	int err;
@@ -797,7 +798,7 @@ void kho_remove_subtree(void *fdt)
 
 		if ((phys_addr_t)*val == target_phys) {
 			fdt_del_node(root_fdt, off);
-			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
+			kho_debugfs_blob_remove(&kho_out.dbg, blob);
 			break;
 		}
 	}
@@ -1293,11 +1294,11 @@ bool is_kho_boot(void)
 EXPORT_SYMBOL_GPL(is_kho_boot);
 
 /**
- * kho_retrieve_subtree - retrieve a preserved sub FDT by its name.
- * @name: the name of the sub FDT passed to kho_add_subtree().
- * @phys: if found, the physical address of the sub FDT is stored in @phys.
+ * kho_retrieve_subtree - retrieve a preserved sub blob by its name.
+ * @name: the name of the sub blob passed to kho_add_subtree().
+ * @phys: if found, the physical address of the sub blob is stored in @phys.
  *
- * Retrieve a preserved sub FDT named @name and store its physical
+ * Retrieve a preserved sub blob named @name and store its physical
  * address in @phys.
  *
  * Return: 0 on success, error code on failure
@@ -1431,9 +1432,9 @@ static __init int kho_init(void)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
 	}
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt,
-					 fdt_totalsize(kho_out.fdt), true));
+	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, "fdt",
+					  kho_out.fdt,
+					  fdt_totalsize(kho_out.fdt), true));
 
 	return 0;
 
--- a/kernel/liveupdate/kexec_handover_debugfs.c~kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree
+++ a/kernel/liveupdate/kexec_handover_debugfs.c
@@ -24,8 +24,9 @@ struct fdt_debugfs {
 	struct dentry *file;
 };
 
-static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
-				 const char *name, const void *fdt, size_t size)
+static int __kho_debugfs_blob_add(struct list_head *list, struct dentry *dir,
+				  const char *name, const void *blob,
+				  size_t size)
 {
 	struct fdt_debugfs *f;
 	struct dentry *file;
@@ -34,7 +35,7 @@ static int __kho_debugfs_fdt_add(struct
 	if (!f)
 		return -ENOMEM;
 
-	f->wrapper.data = (void *)fdt;
+	f->wrapper.data = (void *)blob;
 	f->wrapper.size = size;
 
 	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
@@ -49,8 +50,8 @@ static int __kho_debugfs_fdt_add(struct
 	return 0;
 }
 
-int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, size_t size, bool root)
+int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
+			 const void *blob, size_t size, bool root)
 {
 	struct dentry *dir;
 
@@ -59,15 +60,15 @@ int kho_debugfs_fdt_add(struct kho_debug
 	else
 		dir = dbg->sub_fdt_dir;
 
-	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt, size);
+	return __kho_debugfs_blob_add(&dbg->fdt_list, dir, name, blob, size);
 }
 
-void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
+void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob)
 {
 	struct fdt_debugfs *ff;
 
 	list_for_each_entry(ff, &dbg->fdt_list, list) {
-		if (ff->wrapper.data == fdt) {
+		if (ff->wrapper.data == blob) {
 			debugfs_remove(ff->file);
 			list_del(&ff->list);
 			kfree(ff);
@@ -113,8 +114,8 @@ __init void kho_in_debugfs_init(struct k
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
-				    fdt_totalsize(fdt));
+	err = __kho_debugfs_blob_add(&dbg->fdt_list, dir, "fdt", fdt,
+				     fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -133,8 +134,8 @@ __init void kho_in_debugfs_init(struct k
 			continue;
 		}
 		sub_fdt = phys_to_virt(*fdt_phys);
-		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
-					    sub_fdt, fdt_totalsize(sub_fdt));
+		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
+					     sub_fdt, fdt_totalsize(sub_fdt));
 		if (err) {
 			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
 				ERR_PTR(err));
--- a/kernel/liveupdate/kexec_handover_internal.h~kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree
+++ a/kernel/liveupdate/kexec_handover_internal.h
@@ -26,19 +26,19 @@ extern unsigned int kho_scratch_cnt;
 int kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
-int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, size_t size, bool root);
-void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
+int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
+			 const void *blob, size_t size, bool root);
+void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
 static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 				       const void *fdt) { }
 static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
-static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-				      const void *fdt, size_t size,
-				      bool root) { return 0; }
-static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
-					  void *fdt) { }
+static inline int kho_debugfs_blob_add(struct kho_debugfs *dbg,
+				       const char *name, const void *blob,
+				       size_t size, bool root) { return 0; }
+static inline void kho_debugfs_blob_remove(struct kho_debugfs *dbg,
+					   void *blob) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUG
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

