Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD07199956
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733350402; cv=none; b=TTlVmZmdiNs47+zZC1bswsGd0A6Ub/oEhKWtu9CG2trhYFW4BxFbr7b3ZTr/uuTUiVNfHrvih7M39EsFerCDfuK+upnL66vWN3n7GJ3e558Mf1/xNtCDJLWOBLtMK0RXYdIuRdaSzoRkCmumcLnbIYf+ARIDuYvWYlsFsO4skkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733350402; c=relaxed/simple;
	bh=Lk+dEM69isq7kWLDZsBQQDiiDIRf9McWvDDjQEsunek=;
	h=Date:To:From:Subject:Message-Id; b=lkAuSHv2sMmHC5/fnWsNwLHjaUYP4CNknj32j8FiHnlsrW/pHSD+hsZSkAKXq1g1koxj09xGF1MGWnHxHOYwPvIVUnwo0Ry/ly8VGVClGfdJywnR35DDceJOtZQcivgqB9rJxX88fe3a6UB5Izd8ydagPbDqbB252BhSzCj67h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qcscZu8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qcscZu8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EB9C4CECD;
	Wed,  4 Dec 2024 22:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733350401;
	bh=Lk+dEM69isq7kWLDZsBQQDiiDIRf9McWvDDjQEsunek=;
	h=Date:To:From:Subject:From;
	b=qcscZu8nSZ1ioEc4tv0KuJNXX8jVtJE6bR0HO0v45xjZr8a9TOKqtgMbRJl2gXm7B
	 SMaeYqND5h5Xv97Ksq5gseZPS3wyCGuNCeR84gs4Yc/t+IQFT76LOJjegTN7c86aW+
	 R1gJckcFR9eCizW/W9P3EWCq0y8m3fVZ4jmXVH5Y=
Date: Wed, 04 Dec 2024 14:13:20 -0800
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vgoyal@redhat.com,thuth@redhat.com,svens@linux.ibm.com,mst@redhat.com,jasowang@redhat.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,farman@linux.ibm.com,eperezma@redhat.com,dyoung@redhat.com,cohuck@redhat.com,borntraeger@linux.ibm.com,bhe@redhat.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch added to mm-unstable branch
Message-Id: <20241204221321.C9EB9C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/kdump: virtio-mem kdump support (CONFIG_PROC_VMCORE_DEVICE_RAM)
has been added to the -mm mm-unstable branch.  Its filename is
     s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: s390/kdump: virtio-mem kdump support (CONFIG_PROC_VMCORE_DEVICE_RAM)
Date: Wed, 4 Dec 2024 13:54:43 +0100

Let's add support for including virtio-mem device RAM in the crash dump,
setting NEED_PROC_VMCORE_DEVICE_RAM, and implementing
elfcorehdr_fill_device_ram_ptload_elf64().

To avoid code duplication, factor out the code to fill a PT_LOAD entry.

Link: https://lkml.kernel.org/r/20241204125444.1734652-13-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Farman <farman@linux.ibm.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig             |    1 
 arch/s390/kernel/crash_dump.c |   39 +++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 8 deletions(-)

--- a/arch/s390/Kconfig~s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram
+++ a/arch/s390/Kconfig
@@ -240,6 +240,7 @@ config S390
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE	if PCI
 	select NEED_PER_CPU_EMBED_FIRST_CHUNK
+	select NEED_PROC_VMCORE_DEVICE_RAM if PROC_VMCORE
 	select NEED_SG_DMA_LENGTH	if PCI
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND3
--- a/arch/s390/kernel/crash_dump.c~s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram
+++ a/arch/s390/kernel/crash_dump.c
@@ -508,6 +508,19 @@ static int get_mem_chunk_cnt(void)
 	return cnt;
 }
 
+static void fill_ptload(Elf64_Phdr *phdr, unsigned long paddr,
+		unsigned long vaddr, unsigned long size)
+{
+	phdr->p_type = PT_LOAD;
+	phdr->p_vaddr = vaddr;
+	phdr->p_offset = paddr;
+	phdr->p_paddr = paddr;
+	phdr->p_filesz = size;
+	phdr->p_memsz = size;
+	phdr->p_flags = PF_R | PF_W | PF_X;
+	phdr->p_align = PAGE_SIZE;
+}
+
 /*
  * Initialize ELF loads (new kernel)
  */
@@ -520,14 +533,8 @@ static void loads_init(Elf64_Phdr *phdr,
 	if (os_info_has_vm)
 		old_identity_base = os_info_old_value(OS_INFO_IDENTITY_BASE);
 	for_each_physmem_range(idx, &oldmem_type, &start, &end) {
-		phdr->p_type = PT_LOAD;
-		phdr->p_vaddr = old_identity_base + start;
-		phdr->p_offset = start;
-		phdr->p_paddr = start;
-		phdr->p_filesz = end - start;
-		phdr->p_memsz = end - start;
-		phdr->p_flags = PF_R | PF_W | PF_X;
-		phdr->p_align = PAGE_SIZE;
+		fill_ptload(phdr, start, old_identity_base + start,
+			    end - start);
 		phdr++;
 	}
 }
@@ -537,6 +544,22 @@ static bool os_info_has_vm(void)
 	return os_info_old_value(OS_INFO_KASLR_OFFSET);
 }
 
+#ifdef CONFIG_PROC_VMCORE_DEVICE_RAM
+/*
+ * Fill PT_LOAD for a physical memory range owned by a device and detected by
+ * its device driver.
+ */
+void elfcorehdr_fill_device_ram_ptload_elf64(Elf64_Phdr *phdr,
+		unsigned long long paddr, unsigned long long size)
+{
+	unsigned long old_identity_base = 0;
+
+	if (os_info_has_vm())
+		old_identity_base = os_info_old_value(OS_INFO_IDENTITY_BASE);
+	fill_ptload(phdr, paddr, old_identity_base + paddr, size);
+}
+#endif
+
 /*
  * Prepare PT_LOAD type program header for kernel image region
  */
_

Patches currently in -mm which might be from david@redhat.com are

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
virtio-mem-remember-usable-region-size.patch
virtio-mem-support-config_proc_vmcore_device_ram.patch
s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch

