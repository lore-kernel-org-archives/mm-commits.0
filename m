Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DB23815D6
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 21:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303199; cv=none; b=Mir+Owhz0gV106FngxHo8gwjlfMU6+2MXPw54jYbaHtIUnXXvwnNsBf1MHCjPcr2HIbiihH4VANPpRIPqoccWyrr7J89bPQE4SdWAWIVfbrVyRg3IrR/X7/9/2j0OuBEUiijXFuJ8zyvLjTpUzbJR/pbV+MOxSVyhopompwUa9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303199; c=relaxed/simple;
	bh=vOaamtjSH5GwaFN3hsmJ+3n0jdgUxVspIiPWbTWU6Bw=;
	h=Date:To:From:Subject:Message-Id; b=L5YnWiAJ79v+N4IdNCpulAKlJ0kb+J32KDCF/ZOXfgNHrQhkpyvFVwy4fZOwAvwH0QBp+VkMj+zI7mg/XuxQkQWlQfY2BN1E+0XErz55e9USRqdVuIh3wfuJBva6e6uhGtAevFq8jO987wCZ6IswBUeMcJm4iHvJjORIvfGsBUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z+WTAIzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z+WTAIzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A079BC4CEF7;
	Mon, 23 Mar 2026 21:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774303198;
	bh=vOaamtjSH5GwaFN3hsmJ+3n0jdgUxVspIiPWbTWU6Bw=;
	h=Date:To:From:Subject:From;
	b=Z+WTAIzZk/+dbFvzWQzsXBV+Yid0BLfgcsHk7mtGdoEOFMpH6cqZAzo6VcR44qLzf
	 /Rd4saFNmYg3DYgEznippWh+5QjOFx5VxzLWQntiXFh1baV8kCprPA9HjRde4SSvhG
	 Uhntvo6DCptuEeyztOG9o57ilj0nMsppFH9Eg+gI=
Date: Mon, 23 Mar 2026 14:59:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-kexec-metadata-track-previous-kernel-chain.patch added to mm-nonmm-unstable branch
Message-Id: <20260323215958.A079BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: kexec-metadata: track previous kernel chain
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-kexec-metadata-track-previous-kernel-chain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-kexec-metadata-track-previous-kernel-chain.patch

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

Link: https://lkml.kernel.org/r/20260316-kho-v9-5-ed6dcd951988@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
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
@@ -1430,6 +1524,10 @@ static __init int kho_init(void)
 		return 0;
 	}
 
+	err = kho_kexec_metadata_init(fdt);
+	if (err)
+		goto err_free_fdt;
+
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
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

