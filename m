Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F045D366557
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498703; cv=none; b=DLlGXi+mY2wh5cTY86L88+9iO4XXeP889Z16yxHQTQQ3q0L6Jk2/0ZkDLCzI+99LXuB2uXioj7MJao9/w50hFoROXu9u72z2fmXPzQ4xNZ/5yjh4Wt0lOFAEALd3HYm8nuL5qk3XFtCwrZZwvGcrvO6MV3tJTKhbvmcf6TF+Hmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498703; c=relaxed/simple;
	bh=FprsWjjjdynonrnn2iTxcJcR+GLxs1XR/SV/vs8mYR4=;
	h=Date:To:From:Subject:Message-Id; b=lVSl0YMB9MvIYkQZzopqHSVgLwsiiMkqiShYDhxKjNzCb/T25wts/YNc5ltAHBewDw1IDxJg+iY/yvETOngJrkR1BaRtSDiT5nY3UDHL4zk2y/ku84NUfzle2A2iw3Cx9VDuQpQZc4zGBsIE0ghnY8PUU6J57SYmjfTzVP/STVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IaNVXPBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IaNVXPBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6773C19424;
	Sat, 18 Apr 2026 07:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498702;
	bh=FprsWjjjdynonrnn2iTxcJcR+GLxs1XR/SV/vs8mYR4=;
	h=Date:To:From:Subject:From;
	b=IaNVXPBeP3SnK1TSRgyJhdueqBADqMtIrmP4OWv0e6TbTYgPH9ql4bxHtPXRyTL5t
	 T1hArDa0Gz/GW6rdoGgoWzfM5xXMIeDYVjss7bkzcTIgWwPruN7C/bts26hvMRzi0q
	 I8dIOH3Erh6dBqqfng/Rxo01136qhcyBJ3/ql298=
Date: Sat, 18 Apr 2026 00:51:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-add-size-parameter-to-kho_add_subtree.patch removed from -mm tree
Message-Id: <20260418075141.A6773C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: add size parameter to kho_add_subtree()
has been removed from the -mm tree.  Its filename was
     kho-add-size-parameter-to-kho_add_subtree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: kho: add size parameter to kho_add_subtree()
Date: Mon, 16 Mar 2026 04:54:31 -0700

Patch series "kho: history: track previous kernel version and kexec boot
count", v9.

Use Kexec Handover (KHO) to pass the previous kernel's version string and
the number of kexec reboots since the last cold boot to the next kernel,
and print it at boot time.

Example
=======
	[    0.000000] Linux version 6.19.0-rc3-upstream-00047-ge5d992347849
	...
	[    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107upstream-00004-g3071b0dc4498 (count 1)

Motivation
==========

Bugs that only reproduce when kexecing from specific kernel versions are
difficult to diagnose.  These issues occur when a buggy kernel kexecs into
a new kernel, with the bug manifesting only in the second kernel.

Recent examples include:

 * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
 * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
 * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

As kexec-based reboots become more common, these version-dependent bugs
are appearing more frequently.  At scale, correlating crashes to the
previous kernel version is challenging, especially when issues only occur
in specific transition scenarios.

Some bugs manifest only after multiple consecutive kexec reboots. 
Tracking the kexec count helps identify these cases (this metric is
already used by live update sub-system).

KHO provides a reliable mechanism to pass information between kernels.  By
carrying the previous kernel's release string and kexec count forward, we
can print this context at boot time to aid debugging.

The goal of this feature is to have this information being printed in
early boot, so, users can trace back kernel releases in kexec.  Systemd is
not helpful because we cannot assume that the previous kernel has systemd
or even write access to the disk (common when using Linux as bootloaders)


This patch (of 6):

kho_add_subtree() assumes the fdt argument is always an FDT and calls
fdt_totalsize() on it in the debugfs code path.  This assumption will
break if a caller passes arbitrary data instead of an FDT.

When CONFIG_KEXEC_HANDOVER_DEBUGFS is enabled, kho_debugfs_fdt_add() calls
__kho_debugfs_fdt_add(), which executes:

    f->wrapper.size = fdt_totalsize(fdt);

Fix this by adding an explicit size parameter to kho_add_subtree() so
callers specify the blob size.  This allows subtrees to contain arbitrary
data formats, not just FDTs.  Update all callers:

  - memblock.c: use fdt_totalsize(fdt)
  - luo_core.c: use fdt_totalsize(fdt_out)
  - test_kho.c: use fdt_totalsize()
  - kexec_handover.c (root fdt): use fdt_totalsize(kho_out.fdt)

Also update __kho_debugfs_fdt_add() to receive the size explicitly instead
of computing it internally via fdt_totalsize().  In kho_in_debugfs_init(),
pass fdt_totalsize() for the root FDT and sub-blobs since all current
users are FDTs.  A subsequent patch will persist the size in the KHO FDT
so the incoming side can handle non-FDT blobs correctly.

Link: https://lore.kernel.org/20260323110747.193569-1-duanchenghao@kylinos.cn
Link: https://lore.kernel.org/20260316-kho-v9-1-ed6dcd951988@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
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

 include/linux/kexec_handover.h              |    4 ++--
 kernel/liveupdate/kexec_handover.c          |    8 +++++---
 kernel/liveupdate/kexec_handover_debugfs.c  |   15 +++++++++------
 kernel/liveupdate/kexec_handover_internal.h |    5 +++--
 kernel/liveupdate/luo_core.c                |    3 ++-
 lib/test_kho.c                              |    3 ++-
 mm/memblock.c                               |    2 +-
 7 files changed, 24 insertions(+), 16 deletions(-)

--- a/include/linux/kexec_handover.h~kho-add-size-parameter-to-kho_add_subtree
+++ a/include/linux/kexec_handover.h
@@ -32,7 +32,7 @@ void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
-int kho_add_subtree(const char *name, void *fdt);
+int kho_add_subtree(const char *name, void *fdt, size_t size);
 void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -97,7 +97,7 @@ static inline void *kho_restore_vmalloc(
 	return NULL;
 }
 
-static inline int kho_add_subtree(const char *name, void *fdt)
+static inline int kho_add_subtree(const char *name, void *fdt, size_t size)
 {
 	return -EOPNOTSUPP;
 }
--- a/kernel/liveupdate/kexec_handover.c~kho-add-size-parameter-to-kho_add_subtree
+++ a/kernel/liveupdate/kexec_handover.c
@@ -727,6 +727,7 @@ err_disable_kho:
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
+ * @size: size of the blob in bytes.
  *
  * Creates a new child node named @name in KHO root FDT and records
  * the physical address of @fdt. The pages of @fdt must also be preserved
@@ -738,7 +739,7 @@ err_disable_kho:
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt, size_t size)
 {
 	phys_addr_t phys = virt_to_phys(fdt);
 	void *root_fdt = kho_out.fdt;
@@ -763,7 +764,7 @@ int kho_add_subtree(const char *name, vo
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -1431,7 +1432,8 @@ static __init int kho_init(void)
 	}
 
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt, true));
+					 kho_out.fdt,
+					 fdt_totalsize(kho_out.fdt), true));
 
 	return 0;
 
--- a/kernel/liveupdate/kexec_handover_debugfs.c~kho-add-size-parameter-to-kho_add_subtree
+++ a/kernel/liveupdate/kexec_handover_debugfs.c
@@ -25,7 +25,7 @@ struct fdt_debugfs {
 };
 
 static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
-				 const char *name, const void *fdt)
+				 const char *name, const void *fdt, size_t size)
 {
 	struct fdt_debugfs *f;
 	struct dentry *file;
@@ -35,7 +35,7 @@ static int __kho_debugfs_fdt_add(struct
 		return -ENOMEM;
 
 	f->wrapper.data = (void *)fdt;
-	f->wrapper.size = fdt_totalsize(fdt);
+	f->wrapper.size = size;
 
 	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
 	if (IS_ERR(file)) {
@@ -50,7 +50,7 @@ static int __kho_debugfs_fdt_add(struct
 }
 
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, bool root)
+			const void *fdt, size_t size, bool root)
 {
 	struct dentry *dir;
 
@@ -59,7 +59,7 @@ int kho_debugfs_fdt_add(struct kho_debug
 	else
 		dir = dbg->sub_fdt_dir;
 
-	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
+	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt, size);
 }
 
 void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
@@ -113,7 +113,8 @@ __init void kho_in_debugfs_init(struct k
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt);
+	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
+				    fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -121,6 +122,7 @@ __init void kho_in_debugfs_init(struct k
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
 		const u64 *fdt_phys;
+		void *sub_fdt;
 
 		fdt_phys = fdt_getprop(fdt, child, KHO_FDT_SUB_TREE_PROP_NAME, &len);
 		if (!fdt_phys)
@@ -130,8 +132,9 @@ __init void kho_in_debugfs_init(struct k
 				name, len);
 			continue;
 		}
+		sub_fdt = phys_to_virt(*fdt_phys);
 		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
-					    phys_to_virt(*fdt_phys));
+					    sub_fdt, fdt_totalsize(sub_fdt));
 		if (err) {
 			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
 				ERR_PTR(err));
--- a/kernel/liveupdate/kexec_handover_internal.h~kho-add-size-parameter-to-kho_add_subtree
+++ a/kernel/liveupdate/kexec_handover_internal.h
@@ -27,7 +27,7 @@ int kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, bool root);
+			const void *fdt, size_t size, bool root);
 void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
@@ -35,7 +35,8 @@ static inline void kho_in_debugfs_init(s
 				       const void *fdt) { }
 static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
 static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-				      const void *fdt, bool root) { return 0; }
+				      const void *fdt, size_t size,
+				      bool root) { return 0; }
 static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
 					  void *fdt) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
--- a/kernel/liveupdate/luo_core.c~kho-add-size-parameter-to-kho_add_subtree
+++ a/kernel/liveupdate/luo_core.c
@@ -172,7 +172,8 @@ static int __init luo_fdt_setup(void)
 	if (err)
 		goto exit_free;
 
-	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out);
+	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out,
+			      fdt_totalsize(fdt_out));
 	if (err)
 		goto exit_free;
 	luo_global.fdt_out = fdt_out;
--- a/lib/test_kho.c~kho-add-size-parameter-to-kho_add_subtree
+++ a/lib/test_kho.c
@@ -143,7 +143,8 @@ static int kho_test_preserve(struct kho_
 	if (err)
 		goto err_unpreserve_data;
 
-	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt));
+	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt),
+			      fdt_totalsize(folio_address(state->fdt)));
 	if (err)
 		goto err_unpreserve_data;
 
--- a/mm/memblock.c~kho-add-size-parameter-to-kho_add_subtree
+++ a/mm/memblock.c
@@ -2510,7 +2510,7 @@ static int __init prepare_kho_fdt(void)
 	if (err)
 		goto err_unpreserve_fdt;
 
-	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt, fdt_totalsize(fdt));
 	if (err)
 		goto err_unpreserve_fdt;
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

