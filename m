Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EC119F120
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733350395; cv=none; b=W3wD74fap5DWuJB564S1RH9n6Iti2ghEArWoxKHOU9/2Am84sd1PTAaSJr3A7y2MUSlmEjjGYATtkEJYxvxCtSH2MNuDaFzLsrTEY0jGPB1fySctI9x0X9Bl6UCCQXb5HUQWb0Y6jVjwcTcvYf1VyJi244jluQ6k8/3u6EEOhi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733350395; c=relaxed/simple;
	bh=0ZxGx4kiematQrdGdOgujIZ61la9vRu6MnOkKnSh0TA=;
	h=Date:To:From:Subject:Message-Id; b=ot+4r9RfxrnUrVs+DqmvZFsX8ZXC3J81vjRu4qmsG7PC68+mkhiHXdL8U5vTnIw9HHgj7zsnpr5rtmikK6/s0UNPeNXAGKUYCZDvvDZG26PhYlo7t675jQMawtcZAgWtK9OHuTreKe6id/Ad11BZd3Wqm6taJLgZcxQDQ5mHaT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNoFLCnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNoFLCnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32D0C4CECD;
	Wed,  4 Dec 2024 22:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733350395;
	bh=0ZxGx4kiematQrdGdOgujIZ61la9vRu6MnOkKnSh0TA=;
	h=Date:To:From:Subject:From;
	b=LNoFLCnP8Rk8BjpqnIedjIuebxyq9yNupZV3EeFs8Kg4DgqOwlvfDIkyIEVK1DdoH
	 dGi5wuDLyfVUjEkKWgnfZtctVw3K+zDPw3X06QlGLv/RDKWTRBR8knAXhfkktlFUBv
	 q+Ts/a+P557t1kBFYbiphLGbJVBRA61tM03QUvJU=
Date: Wed, 04 Dec 2024 14:13:15 -0800
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vgoyal@redhat.com,thuth@redhat.com,svens@linux.ibm.com,mst@redhat.com,jasowang@redhat.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,farman@linux.ibm.com,eperezma@redhat.com,dyoung@redhat.com,cohuck@redhat.com,borntraeger@linux.ibm.com,bhe@redhat.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch added to mm-unstable branch
Message-Id: <20241204221315.A32D0C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/vmcore: introduce PROC_VMCORE_DEVICE_RAM to detect device RAM ranges in 2nd kernel
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch

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
Subject: fs/proc/vmcore: introduce PROC_VMCORE_DEVICE_RAM to detect device RAM ranges in 2nd kernel
Date: Wed, 4 Dec 2024 13:54:39 +0100

s390 allocates+prepares the elfcore hdr in the dump (2nd) kernel, not in
the crashed kernel.

RAM provided by memory devices such as virtio-mem can only be detected
using the device driver; when vmcore_init() is called, these device
drivers are usually not loaded yet, or the devices did not get probed yet.
Consequently, on s390 these RAM ranges will not be included in the crash
dump, which makes the dump partially corrupt and is unfortunate.

Instead of deferring the vmcore_init() call, to an (unclear?) later point,
let's reuse the vmcore_cb infrastructure to obtain device RAM ranges as
the device drivers probe the device and get access to this information.

Then, we'll add these ranges to the vmcore, adding more PT_LOAD entries
and updating the offsets+vmcore size.

Use a separate Kconfig option to be set by an architecture to include this
code only if the arch really needs it.  Further, we'll make the config
depend on the relevant drivers (i.e., virtio_mem) once they implement
support (next).  The alternative of having a
PROVIDE_PROC_VMCORE_DEVICE_RAM config option was dropped for now for
simplicity.

The current target use case is s390, which only creates an elf64 elfcore,
so focusing on elf64 is sufficient.

Link: https://lkml.kernel.org/r/20241204125444.1734652-9-david@redhat.com
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

 fs/proc/Kconfig            |   18 ++++
 fs/proc/vmcore.c           |  156 +++++++++++++++++++++++++++++++++++
 include/linux/crash_dump.h |    9 ++
 3 files changed, 183 insertions(+)

--- a/fs/proc/Kconfig~fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel
+++ a/fs/proc/Kconfig
@@ -61,6 +61,24 @@ config PROC_VMCORE_DEVICE_DUMP
 	  as ELF notes to /proc/vmcore. You can still disable device
 	  dump using the kernel command line option 'novmcoredd'.
 
+config NEED_PROC_VMCORE_DEVICE_RAM
+	bool
+
+config PROC_VMCORE_DEVICE_RAM
+	def_bool y
+	depends on PROC_VMCORE && NEED_PROC_VMCORE_DEVICE_RAM
+	help
+	  If the elfcore hdr is allocated and prepared by the dump kernel
+	  ("2nd kernel") instead of the crashed kernel, RAM provided by memory
+	  devices such as virtio-mem will not be included in the dump
+	  image, because only the device driver can properly detect them.
+
+	  With this config enabled, these RAM ranges will be queried from the
+	  device drivers once the device gets probed, so they can be included
+	  in the crash dump.
+
+	  Relevant architectures should select NEED_PROC_VMCORE_DEVICE_RAM.
+
 config PROC_SYSCTL
 	bool "Sysctl support (/proc/sys)" if EXPERT
 	depends on PROC_FS
--- a/fs/proc/vmcore.c~fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel
+++ a/fs/proc/vmcore.c
@@ -79,6 +79,8 @@ static bool vmcore_opened;
 /* Whether the vmcore is currently open. */
 static unsigned int vmcore_open;
 
+static void vmcore_process_device_ram(struct vmcore_cb *cb);
+
 void register_vmcore_cb(struct vmcore_cb *cb)
 {
 	INIT_LIST_HEAD(&cb->next);
@@ -90,6 +92,8 @@ void register_vmcore_cb(struct vmcore_cb
 	 */
 	if (vmcore_opened)
 		pr_warn_once("Unexpected vmcore callback registration\n");
+	if (!vmcore_open && cb->get_device_ram)
+		vmcore_process_device_ram(cb);
 	mutex_unlock(&vmcore_mutex);
 }
 EXPORT_SYMBOL_GPL(register_vmcore_cb);
@@ -1535,6 +1539,158 @@ out_err:
 EXPORT_SYMBOL(vmcore_add_device_dump);
 #endif /* CONFIG_PROC_VMCORE_DEVICE_DUMP */
 
+#ifdef CONFIG_PROC_VMCORE_DEVICE_RAM
+static int vmcore_realloc_elfcore_buffer_elf64(size_t new_size)
+{
+	char *elfcorebuf_new;
+
+	if (WARN_ON_ONCE(new_size < elfcorebuf_sz))
+		return -EINVAL;
+	if (get_order(elfcorebuf_sz_orig) == get_order(new_size)) {
+		elfcorebuf_sz_orig = new_size;
+		return 0;
+	}
+
+	elfcorebuf_new = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						  get_order(new_size));
+	if (!elfcorebuf_new)
+		return -ENOMEM;
+	memcpy(elfcorebuf_new, elfcorebuf, elfcorebuf_sz);
+	free_pages((unsigned long)elfcorebuf, get_order(elfcorebuf_sz_orig));
+	elfcorebuf = elfcorebuf_new;
+	elfcorebuf_sz_orig = new_size;
+	return 0;
+}
+
+static void vmcore_reset_offsets_elf64(void)
+{
+	Elf64_Phdr *phdr_start = (Elf64_Phdr *)(elfcorebuf + sizeof(Elf64_Ehdr));
+	loff_t vmcore_off = elfcorebuf_sz + elfnotes_sz;
+	Elf64_Ehdr *ehdr = (Elf64_Ehdr *)elfcorebuf;
+	Elf64_Phdr *phdr;
+	int i;
+
+	for (i = 0, phdr = phdr_start; i < ehdr->e_phnum; i++, phdr++) {
+		u64 start, end;
+
+		/*
+		 * After merge_note_headers_elf64() we should only have a single
+		 * PT_NOTE entry that starts immediately after elfcorebuf_sz.
+		 */
+		if (phdr->p_type == PT_NOTE) {
+			phdr->p_offset = elfcorebuf_sz;
+			continue;
+		}
+
+		start = rounddown(phdr->p_offset, PAGE_SIZE);
+		end = roundup(phdr->p_offset + phdr->p_memsz, PAGE_SIZE);
+		phdr->p_offset = vmcore_off + (phdr->p_offset - start);
+		vmcore_off = vmcore_off + end - start;
+	}
+	set_vmcore_list_offsets(elfcorebuf_sz, elfnotes_sz, &vmcore_list);
+}
+
+static int vmcore_add_device_ram_elf64(struct list_head *list, size_t count)
+{
+	Elf64_Phdr *phdr_start = (Elf64_Phdr *)(elfcorebuf + sizeof(Elf64_Ehdr));
+	Elf64_Ehdr *ehdr = (Elf64_Ehdr *)elfcorebuf;
+	struct vmcore_range *cur;
+	Elf64_Phdr *phdr;
+	size_t new_size;
+	int rc;
+
+	if ((Elf32_Half)(ehdr->e_phnum + count) != ehdr->e_phnum + count) {
+		pr_err("too many device ram ranges\n");
+		return -ENOSPC;
+	}
+
+	/* elfcorebuf_sz must always cover full pages. */
+	new_size = sizeof(Elf64_Ehdr) +
+		   (ehdr->e_phnum + count) * sizeof(Elf64_Phdr);
+	new_size = roundup(new_size, PAGE_SIZE);
+
+	/*
+	 * Make sure we have sufficient space to include the new PT_LOAD
+	 * entries.
+	 */
+	rc = vmcore_realloc_elfcore_buffer_elf64(new_size);
+	if (rc) {
+		pr_err("resizing elfcore failed\n");
+		return rc;
+	}
+
+	/* Modify our used elfcore buffer size to cover the new entries. */
+	elfcorebuf_sz = new_size;
+
+	/* Fill the added PT_LOAD entries. */
+	phdr = phdr_start + ehdr->e_phnum;
+	list_for_each_entry(cur, list, list) {
+		WARN_ON_ONCE(!IS_ALIGNED(cur->paddr | cur->size, PAGE_SIZE));
+		elfcorehdr_fill_device_ram_ptload_elf64(phdr, cur->paddr, cur->size);
+
+		/* p_offset will be adjusted later. */
+		phdr++;
+		ehdr->e_phnum++;
+	}
+	list_splice_tail(list, &vmcore_list);
+
+	/* We changed elfcorebuf_sz and added new entries; reset all offsets. */
+	vmcore_reset_offsets_elf64();
+
+	/* Finally, recalculate the total vmcore size. */
+	vmcore_size = get_vmcore_size(elfcorebuf_sz, elfnotes_sz,
+				      &vmcore_list);
+	proc_vmcore->size = vmcore_size;
+	return 0;
+}
+
+static void vmcore_process_device_ram(struct vmcore_cb *cb)
+{
+	unsigned char *e_ident = (unsigned char *)elfcorebuf;
+	struct vmcore_range *first, *m;
+	LIST_HEAD(list);
+	int count;
+
+	/* We only support Elf64 dumps for now. */
+	if (WARN_ON_ONCE(e_ident[EI_CLASS] != ELFCLASS64)) {
+		pr_err("device ram ranges only support Elf64\n");
+		return;
+	}
+
+	if (cb->get_device_ram(cb, &list)) {
+		pr_err("obtaining device ram ranges failed\n");
+		return;
+	}
+	count = list_count_nodes(&list);
+	if (!count)
+		return;
+
+	/*
+	 * For some reason these ranges are already know? Might happen
+	 * with unusual register->unregister->register sequences; we'll simply
+	 * sanity check using the first range.
+	 */
+	first = list_first_entry(&list, struct vmcore_range, list);
+	list_for_each_entry(m, &vmcore_list, list) {
+		unsigned long long m_end = m->paddr + m->size;
+		unsigned long long first_end = first->paddr + first->size;
+
+		if (first->paddr < m_end && m->paddr < first_end)
+			goto out_free;
+	}
+
+	/* If adding the mem nodes succeeds, they must not be freed. */
+	if (!vmcore_add_device_ram_elf64(&list, count))
+		return;
+out_free:
+	vmcore_free_ranges(&list);
+}
+#else /* !CONFIG_PROC_VMCORE_DEVICE_RAM */
+static void vmcore_process_device_ram(struct vmcore_cb *cb)
+{
+}
+#endif /* CONFIG_PROC_VMCORE_DEVICE_RAM */
+
 /* Free all dumps in vmcore device dump list */
 static void vmcore_free_device_dumps(void)
 {
--- a/include/linux/crash_dump.h~fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel
+++ a/include/linux/crash_dump.h
@@ -20,6 +20,8 @@ extern int elfcorehdr_alloc(unsigned lon
 extern void elfcorehdr_free(unsigned long long addr);
 extern ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos);
 extern ssize_t elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
+void elfcorehdr_fill_device_ram_ptload_elf64(Elf64_Phdr *phdr,
+		unsigned long long paddr, unsigned long long size);
 extern int remap_oldmem_pfn_range(struct vm_area_struct *vma,
 				  unsigned long from, unsigned long pfn,
 				  unsigned long size, pgprot_t prot);
@@ -99,6 +101,12 @@ static inline void vmcore_unusable(void)
  *              indicated in the vmcore instead. For example, a ballooned page
  *              contains no data and reading from such a page will cause high
  *              load in the hypervisor.
+ * @get_device_ram: query RAM ranges that can only be detected by device
+ *   drivers, such as the virtio-mem driver, so they can be included in
+ *   the crash dump on architectures that allocate the elfcore hdr in the dump
+ *   ("2nd") kernel. Indicated RAM ranges may contain holes to reduce the
+ *   total number of ranges; such holes can be detected using the pfn_is_ram
+ *   callback just like for other RAM.
  * @next: List head to manage registered callbacks internally; initialized by
  *        register_vmcore_cb().
  *
@@ -109,6 +117,7 @@ static inline void vmcore_unusable(void)
  */
 struct vmcore_cb {
 	bool (*pfn_is_ram)(struct vmcore_cb *cb, unsigned long pfn);
+	int (*get_device_ram)(struct vmcore_cb *cb, struct list_head *list);
 	struct list_head next;
 };
 extern void register_vmcore_cb(struct vmcore_cb *cb);
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

