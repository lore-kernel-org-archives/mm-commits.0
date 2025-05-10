Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B86B77104
	for <mm-commits@vger.kernel.org>; Sat, 10 May 2025 00:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746837435; cv=none; b=b7yQUyBBkfpQTkQUh7MsZSU1FbkaOY+5rIgXJ/cJd8mPDF6D8yMzxclvGUKMy4Bc4XnQCOv+iUb/ZtXs9jWJg4w4Tjez83XqwS8x1gDNXsQ6qj/b1ukdL4DAC0P+Y3VQP0mXbG/ZAXrHrLCpoJDzvhQV1ENToTPw9QSBkZ8tZo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746837435; c=relaxed/simple;
	bh=HwVplBW5yxpN1cJFdqieCnbqmap64Sbm7TGGbGBF6ZY=;
	h=Date:To:From:Subject:Message-Id; b=JvVPNpl+RrkYSq/knGD2v/WqKjrorYxde+00bTMn5+AOBMFjHrqAEB4u2VJA2b7W1j/Mpc3I8df3G1M1tPYRj1LwfE2H8k/ZLyhGuN3p1Omo8pBAuOEPwG4AkBkxfxw4t2tfa3pzhNWvVx7M7dueXbAz8481R+0y/HpaIBTP02I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HcTLpo8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HcTLpo8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79703C4CEEE;
	Sat, 10 May 2025 00:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746837433;
	bh=HwVplBW5yxpN1cJFdqieCnbqmap64Sbm7TGGbGBF6ZY=;
	h=Date:To:From:Subject:From;
	b=HcTLpo8GEwneqZ0SWlS/pYGiANKuWCA18bPE4qr/n7aY5Ahow0kwlpS7S21zu94dx
	 e3MWDDsdSdXDnDyBa/wpC5Q87HZ49r+P/NQ7EWC+kbaCGLQSNuM8hdKDf724MfTCd3
	 QG5wzm6hg1IbYmrpl4b1C4wjHluRf8wGUls8ANFM=
Date: Fri, 09 May 2025 17:37:12 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,jgg@nvidia.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,changyuanl@google.com,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-kho-parsing-support.patch added to mm-unstable branch
Message-Id: <20250510003713.79703C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: add KHO parsing support
has been added to the -mm mm-unstable branch.  Its filename is
     kexec-add-kho-parsing-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-kho-parsing-support.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexander Graf <graf@amazon.com>
Subject: kexec: add KHO parsing support
Date: Fri, 9 May 2025 00:46:23 -0700

When we have a KHO kexec, we get an FDT blob and scratch region to
populate the state of the system.  Provide helper functions that allow
architecture code to easily handle memory reservations based on them and
give device drivers visibility into the KHO FDT and memory reservations so
they can recover their own state.

Include a fix from Arnd Bergmann <arnd@arndb.de>
https://lore.kernel.org/lkml/20250424093302.3894961-1-arnd@kernel.org/.

Link: https://lkml.kernel.org/r/20250509074635.3187114-6-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |   14 +
 kernel/kexec_handover.c        |  233 ++++++++++++++++++++++++++++++-
 mm/memblock.c                  |    1 
 3 files changed, 247 insertions(+), 1 deletion(-)

--- a/include/linux/kexec_handover.h~kexec-add-kho-parsing-support
+++ a/include/linux/kexec_handover.h
@@ -24,11 +24,15 @@ struct kho_serialization;
 bool kho_is_enabled(void);
 
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
+int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
 int register_kho_notifier(struct notifier_block *nb);
 int unregister_kho_notifier(struct notifier_block *nb);
 
 void kho_memory_init(void);
+
+void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
+		  u64 scratch_len);
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -41,6 +45,11 @@ static inline int kho_add_subtree(struct
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int register_kho_notifier(struct notifier_block *nb)
 {
 	return -EOPNOTSUPP;
@@ -54,6 +63,11 @@ static inline int unregister_kho_notifie
 static inline void kho_memory_init(void)
 {
 }
+
+static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
+				phys_addr_t scratch_phys, u64 scratch_len)
+{
+}
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
--- a/kernel/kexec_handover.c~kexec-add-kho-parsing-support
+++ a/kernel/kexec_handover.c
@@ -17,6 +17,9 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+
+#include <asm/early_ioremap.h>
+
 /*
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
@@ -501,9 +504,112 @@ err_rmdir:
 	return -ENOENT;
 }
 
+struct kho_in {
+	struct dentry *dir;
+	phys_addr_t fdt_phys;
+	phys_addr_t scratch_phys;
+	struct list_head fdt_list;
+};
+
+static struct kho_in kho_in = {
+	.fdt_list = LIST_HEAD_INIT(kho_in.fdt_list),
+};
+
+static const void *kho_get_fdt(void)
+{
+	return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
+}
+
+/**
+ * kho_retrieve_subtree - retrieve a preserved sub FDT by its name.
+ * @name: the name of the sub FDT passed to kho_add_subtree().
+ * @phys: if found, the physical address of the sub FDT is stored in @phys.
+ *
+ * Retrieve a preserved sub FDT named @name and store its physical
+ * address in @phys.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
+{
+	const void *fdt = kho_get_fdt();
+	const u64 *val;
+	int offset, len;
+
+	if (!fdt)
+		return -ENOENT;
+
+	if (!phys)
+		return -EINVAL;
+
+	offset = fdt_subnode_offset(fdt, 0, name);
+	if (offset < 0)
+		return -ENOENT;
+
+	val = fdt_getprop(fdt, offset, PROP_SUB_FDT, &len);
+	if (!val || len != sizeof(*val))
+		return -EINVAL;
+
+	*phys = (phys_addr_t)*val;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
+
+/* Handling for debugfs/kho/in */
+
+static __init int kho_in_debugfs_init(const void *fdt)
+{
+	struct dentry *sub_fdt_dir;
+	int err, child;
+
+	kho_in.dir = debugfs_create_dir("in", debugfs_root);
+	if (IS_ERR(kho_in.dir))
+		return PTR_ERR(kho_in.dir);
+
+	sub_fdt_dir = debugfs_create_dir("sub_fdts", kho_in.dir);
+	if (IS_ERR(sub_fdt_dir)) {
+		err = PTR_ERR(sub_fdt_dir);
+		goto err_rmdir;
+	}
+
+	err = kho_debugfs_fdt_add(&kho_in.fdt_list, kho_in.dir, "fdt", fdt);
+	if (err)
+		goto err_rmdir;
+
+	fdt_for_each_subnode(child, fdt, 0) {
+		int len = 0;
+		const char *name = fdt_get_name(fdt, child, NULL);
+		const u64 *fdt_phys;
+
+		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
+		if (!fdt_phys)
+			continue;
+		if (len != sizeof(*fdt_phys)) {
+			pr_warn("node `%s`'s prop `fdt` has invalid length: %d\n",
+				name, len);
+			continue;
+		}
+		err = kho_debugfs_fdt_add(&kho_in.fdt_list, sub_fdt_dir, name,
+					  phys_to_virt(*fdt_phys));
+		if (err) {
+			pr_warn("failed to add fdt `%s` to debugfs: %d\n", name,
+				err);
+			continue;
+		}
+	}
+
+	return 0;
+
+err_rmdir:
+	debugfs_remove_recursive(kho_in.dir);
+	return err;
+}
+
 static __init int kho_init(void)
 {
 	int err = 0;
+	const void *fdt = kho_get_fdt();
 
 	if (!kho_enable)
 		return 0;
@@ -524,6 +630,20 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	if (fdt) {
+		err = kho_in_debugfs_init(fdt);
+		/*
+		 * Failure to create /sys/kernel/debug/kho/in does not prevent
+		 * reviving state from KHO and setting up KHO for the next
+		 * kexec.
+		 */
+		if (err)
+			pr_err("failed exposing handover FDT in debugfs: %d\n",
+			       err);
+
+		return 0;
+	}
+
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
@@ -551,7 +671,118 @@ err_free_scratch:
 }
 late_initcall(kho_init);
 
+static void __init kho_release_scratch(void)
+{
+	phys_addr_t start, end;
+	u64 i;
+
+	memmap_init_kho_scratch_pages();
+
+	/*
+	 * Mark scratch mem as CMA before we return it. That way we
+	 * ensure that no kernel allocations happen on it. That means
+	 * we can reuse it as scratch memory again later.
+	 */
+	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
+			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
+		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
+		ulong end_pfn = pageblock_align(PFN_UP(end));
+		ulong pfn;
+
+		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
+			set_pageblock_migratetype(pfn_to_page(pfn),
+						  MIGRATE_CMA);
+	}
+}
+
 void __init kho_memory_init(void)
 {
-	kho_reserve_scratch();
+	if (kho_in.scratch_phys) {
+		kho_scratch = phys_to_virt(kho_in.scratch_phys);
+		kho_release_scratch();
+	} else {
+		kho_reserve_scratch();
+	}
+}
+
+void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
+			 phys_addr_t scratch_phys, u64 scratch_len)
+{
+	void *fdt = NULL;
+	struct kho_scratch *scratch = NULL;
+	int err = 0;
+	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
+
+	/* Validate the input FDT */
+	fdt = early_memremap(fdt_phys, fdt_len);
+	if (!fdt) {
+		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
+		err = -EFAULT;
+		goto out;
+	}
+	err = fdt_check_header(fdt);
+	if (err) {
+		pr_warn("setup: handover FDT (0x%llx) is invalid: %d\n",
+			fdt_phys, err);
+		err = -EINVAL;
+		goto out;
+	}
+	err = fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
+	if (err) {
+		pr_warn("setup: handover FDT (0x%llx) is incompatible with '%s': %d\n",
+			fdt_phys, KHO_FDT_COMPATIBLE, err);
+		err = -EINVAL;
+		goto out;
+	}
+
+	scratch = early_memremap(scratch_phys, scratch_len);
+	if (!scratch) {
+		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
+			scratch_phys, scratch_len);
+		err = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * We pass a safe contiguous blocks of memory to use for early boot
+	 * purporses from the previous kernel so that we can resize the
+	 * memblock array as needed.
+	 */
+	for (int i = 0; i < scratch_cnt; i++) {
+		struct kho_scratch *area = &scratch[i];
+		u64 size = area->size;
+
+		memblock_add(area->addr, size);
+		err = memblock_mark_kho_scratch(area->addr, size);
+		if (WARN_ON(err)) {
+			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %d",
+				&area->addr, &size, err);
+			goto out;
+		}
+		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
+	}
+
+	memblock_reserve(scratch_phys, scratch_len);
+
+	/*
+	 * Now that we have a viable region of scratch memory, let's tell
+	 * the memblocks allocator to only use that for any allocations.
+	 * That way we ensure that nothing scribbles over in use data while
+	 * we initialize the page tables which we will need to ingest all
+	 * memory reservations from the previous kernel.
+	 */
+	memblock_set_kho_scratch_only();
+
+	kho_in.fdt_phys = fdt_phys;
+	kho_in.scratch_phys = scratch_phys;
+	kho_scratch_cnt = scratch_cnt;
+	pr_info("found kexec handover data. Will skip init for some devices\n");
+
+out:
+	if (fdt)
+		early_memunmap(fdt, fdt_len);
+	if (scratch)
+		early_memunmap(scratch, scratch_len);
+	if (err)
+		pr_warn("disabling KHO revival: %d\n", err);
 }
--- a/mm/memblock.c~kexec-add-kho-parsing-support
+++ a/mm/memblock.c
@@ -2387,6 +2387,7 @@ void __init memblock_free_all(void)
 	free_unused_memmap();
 	reset_all_zones_managed_pages();
 
+	memblock_clear_kho_scratch_only();
 	pages = free_low_memory_core_early();
 	totalram_pages_add(pages);
 }
_

Patches currently in -mm which might be from graf@amazon.com are

memblock-add-support-for-scratch-memory.patch
kexec-add-kexec-handover-kho-generation-helpers.patch
kexec-add-kho-parsing-support.patch
kexec-add-kho-support-to-kexec-file-loads.patch
kexec-add-config-option-for-kho.patch
arm64-add-kho-support.patch
x86-kexec-add-support-for-passing-kexec-handover-kho-data.patch
x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m.patch
x86-boot-make-sure-kaslr-does-not-step-over-kho-preserved-memory.patch
x86-kconfig-enable-kexec-handover-for-64-bits.patch
memblock-add-kho-support-for-reserve_mem.patch
documentation-add-documentation-for-kho.patch

