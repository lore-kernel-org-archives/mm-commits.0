Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F32287510
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498726; cv=none; b=orBEeRtvPpm8nWrn12JGsTpBfjBRlvNocVZvfg+tMKyFb12RAZdQZR+VskcZ1HW7yIna2QcYvR0HXcL5CQRvthQ3cu1HJGg73Elik2l53PB1Qt20hye7udOAxPnzkNUobbV526/xxYet6EZhBJuckzJKlI6FrtxNlv+sMY1CJTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498726; c=relaxed/simple;
	bh=OFiQPzsnBVuYBBIGjQzcPjudpZMRwfq4iPLDC+UMyKY=;
	h=Date:To:From:Subject:Message-Id; b=alhZ0UjyVvlCViRG6JpHiZyKy4HrA1Zaa3iWJb4bdkv3f7FvD2l2AckOk/4QS30oe1ViY/0bBkX3I3zczjxuloMUBaGHtKCxtMPpMfdWCAYsRblyYshA5nl6Cnt6nekT/ErPwJMMXY/GPCzD9j3M7h17e8RH+yxZG1r1BjfE7Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rBpT3gGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rBpT3gGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FB1C19424;
	Sat, 18 Apr 2026 07:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498726;
	bh=OFiQPzsnBVuYBBIGjQzcPjudpZMRwfq4iPLDC+UMyKY=;
	h=Date:To:From:Subject:From;
	b=rBpT3gGikdw761bS5DPbZUk3aP72XqrkGYl7wY9VDbIHI9FnQYm/uv0MxOlrBeBTl
	 C79OWguBS7mmfh+uWFsWLtswJ54pYub4tYoI4rkgwEyGU4sfeTzIDN2/fU43QDhoQE
	 ylPetj/Jn+AINoPlyMo6Hm1/RAx3nBxtveDSV2z0=
Date: Sat, 18 Apr 2026 00:52:01 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-kexec-metadata-track-previous-kernel-chain.patch removed from -mm tree
Message-Id: <20260418075205.61FB1C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: kexec-metadata: track previous kernel chain
has been removed from the -mm tree.  Its filename was
     kho-kexec-metadata-track-previous-kernel-chain.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: kho: kexec-metadata: track previous kernel chain
Date: Mon, 16 Mar 2026 04:54:35 -0700

Use Kexec Handover (KHO) to pass the previous kernel's version string and
the number of kexec reboots since the last cold boot to the next kernel,
and print it at boot time.

Example output:
    [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)

Motivation
==========

Bugs that only reproduce when kexecing from specific kernel versions are
difficult to diagnose.  These issues occur when a buggy kernel kexecs into
a new kernel, with the bug manifesting only in the second kernel.

Recent examples include the following commits:

 * commit eb2266312507 ("x86/boot: Fix page table access in
   5-level to 4-level paging transition")
 * commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory
   for event log to avoid corruption")
 * commit 64b45dd46e15 ("x86/efi: skip memattr table on kexec
   boot")

As kexec-based reboots become more common, these version-dependent bugs
are appearing more frequently.  At scale, correlating crashes to the
previous kernel version is challenging, especially when issues only occur
in specific transition scenarios.

Implementation
==============

The kexec metadata is stored as a plain C struct (struct
kho_kexec_metadata) rather than FDT format, for simplicity and direct
field access.  It is registered via kho_add_subtree() as a separate
subtree, keeping it independent from the core KHO ABI.  This design
choice:

 - Keeps the core KHO ABI minimal and stable
 - Allows the metadata format to evolve independently
 - Avoids requiring version bumps for all KHO consumers (LUO, etc.)
   when the metadata format changes

The struct kho_kexec_metadata contains two fields:
 - previous_release: The kernel version that initiated the kexec
 - kexec_count: Number of kexec boots since last cold boot

On cold boot, kexec_count starts at 0 and increments with each kexec.  The
count helps identify issues that only manifest after multiple consecutive
kexec reboots.

[leitao@debian.org: call kho_kexec_metadata_init() for both boot paths]
  Link: https://lore.kernel.org/all/20260309-kho-v8-5-c3abcf4ac750@debian.org/ [1]
  Link: https://lore.kernel.org/20260409-kho_fix_merge_issue-v1-1-710c84ceaa85@debian.org
Link: https://lore.kernel.org/20260316-kho-v9-5-ed6dcd951988@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kho/abi/kexec_metadata.h |   46 ++++++++++
 kernel/liveupdate/kexec_handover.c     |   98 +++++++++++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/include/linux/kho/abi/kexec_metadata.h a/include/linux/kho/abi/kexec_metadata.h
new file mode 100644
--- /dev/null
+++ a/include/linux/kho/abi/kexec_metadata.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+/**
+ * DOC: Kexec Metadata ABI
+ *
+ * The "kexec-metadata" subtree stores optional metadata about the kexec chain.
+ * It is registered via kho_add_subtree(), keeping it independent from the core
+ * KHO ABI. This allows the metadata format to evolve without affecting other
+ * KHO consumers.
+ *
+ * The metadata is stored as a plain C struct rather than FDT format for
+ * simplicity and direct field access.
+ *
+ * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
+ * Copyright (c) 2026 Breno Leitao <leitao@debian.org>
+ */
+
+#ifndef _LINUX_KHO_ABI_KEXEC_METADATA_H
+#define _LINUX_KHO_ABI_KEXEC_METADATA_H
+
+#include <linux/types.h>
+#include <linux/utsname.h>
+
+#define KHO_KEXEC_METADATA_VERSION 1
+
+/**
+ * struct kho_kexec_metadata - Kexec metadata passed between kernels
+ * @version: ABI version of this struct (must be first field)
+ * @previous_release: Kernel version string that initiated the kexec
+ * @kexec_count: Number of kexec boots since last cold boot
+ *
+ * This structure is preserved across kexec and allows the new kernel to
+ * identify which kernel it was booted from and how many kexec reboots
+ * have occurred.
+ *
+ * __NEW_UTS_LEN is part of uABI, so it safe to use it in here.
+ */
+struct kho_kexec_metadata {
+	u32 version;
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
+} __packed;
+
+#define KHO_METADATA_NODE_NAME "kexec-metadata"
+
+#endif /* _LINUX_KHO_ABI_KEXEC_METADATA_H */
--- a/kernel/liveupdate/kexec_handover.c~kho-kexec-metadata-track-previous-kernel-chain
+++ a/kernel/liveupdate/kexec_handover.c
@@ -18,7 +18,9 @@
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho_radix_tree.h>
+#include <linux/utsname.h>
 #include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/abi/kexec_metadata.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
@@ -1268,6 +1270,8 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
 	struct kho_debugfs dbg;
 };
 
@@ -1392,6 +1396,96 @@ static __init int kho_out_fdt_setup(void
 	return err;
 }
 
+static void __init kho_in_kexec_metadata(void)
+{
+	struct kho_kexec_metadata *metadata;
+	phys_addr_t metadata_phys;
+	size_t blob_size;
+	int err;
+
+	err = kho_retrieve_subtree(KHO_METADATA_NODE_NAME, &metadata_phys,
+				   &blob_size);
+	if (err)
+		/* This is fine, previous kernel didn't export metadata */
+		return;
+
+	/* Check that, at least, "version" is present */
+	if (blob_size < sizeof(u32)) {
+		pr_warn("kexec-metadata blob too small (%zu bytes)\n",
+			blob_size);
+		return;
+	}
+
+	metadata = phys_to_virt(metadata_phys);
+
+	if (metadata->version != KHO_KEXEC_METADATA_VERSION) {
+		pr_warn("kexec-metadata version %u not supported (expected %u)\n",
+			metadata->version, KHO_KEXEC_METADATA_VERSION);
+		return;
+	}
+
+	if (blob_size < sizeof(*metadata)) {
+		pr_warn("kexec-metadata blob too small for v%u (%zu < %zu)\n",
+			metadata->version, blob_size, sizeof(*metadata));
+		return;
+	}
+
+	/*
+	 * Copy data to the kernel structure that will persist during
+	 * kernel lifetime.
+	 */
+	kho_in.kexec_count = metadata->kexec_count;
+	strscpy(kho_in.previous_release, metadata->previous_release,
+		sizeof(kho_in.previous_release));
+
+	pr_info("exec from: %s (count %u)\n",
+		kho_in.previous_release, kho_in.kexec_count);
+}
+
+/*
+ * Create kexec metadata to pass kernel version and boot count to the
+ * next kernel. This keeps the core KHO ABI minimal and allows the
+ * metadata format to evolve independently.
+ */
+static __init int kho_out_kexec_metadata(void)
+{
+	struct kho_kexec_metadata *metadata;
+	int err;
+
+	metadata = kho_alloc_preserve(sizeof(*metadata));
+	if (IS_ERR(metadata))
+		return PTR_ERR(metadata);
+
+	metadata->version = KHO_KEXEC_METADATA_VERSION;
+	strscpy(metadata->previous_release, init_uts_ns.name.release,
+		sizeof(metadata->previous_release));
+	/* kho_in.kexec_count is set to 0 on cold boot */
+	metadata->kexec_count = kho_in.kexec_count + 1;
+
+	err = kho_add_subtree(KHO_METADATA_NODE_NAME, metadata,
+			      sizeof(*metadata));
+	if (err)
+		kho_unpreserve_free(metadata);
+
+	return err;
+}
+
+static int __init kho_kexec_metadata_init(const void *fdt)
+{
+	int err;
+
+	if (fdt)
+		kho_in_kexec_metadata();
+
+	/* Populate kexec metadata for the possible next kexec */
+	err = kho_out_kexec_metadata();
+	if (err)
+		pr_warn("failed to initialize kexec-metadata subtree: %d\n",
+			err);
+
+	return err;
+}
+
 static __init int kho_init(void)
 {
 	struct kho_radix_tree *tree = &kho_out.radix_tree;
@@ -1425,6 +1519,10 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	err = kho_kexec_metadata_init(fdt);
+	if (err)
+		goto err_free_fdt;
+
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;
_

Patches currently in -mm which might be from leitao@debian.org are

mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

