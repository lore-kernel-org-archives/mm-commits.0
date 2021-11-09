Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B7FC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 635C461242
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhKICee (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICee (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:34:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86859611CC;
        Tue,  9 Nov 2021 02:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425109;
        bh=nazYEKM/l+y9Nnsr5lT3RAqOKtkHCFIfqj0yWDnrBVI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e3cGWrmrZyHYF39omW9roqUUHFPO7fWeUhk3nhvDXFUTj9impvP3osFPme7VJETlB
         xD89xliozC+WQPDjgFv24S9jFLjkAMlLMZdII53NFwa+CdvOs8xeQIWiU7JH6ElbXr
         VXOZXrG2otLhlgFzD0ECqOo73HnFs3lF70jwM6BM=
Date:   Mon, 08 Nov 2021 18:31:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, david@redhat.com,
        dyoung@redhat.com, hpa@zytor.com, jasowang@redhat.com,
        jgross@suse.com, linux-mm@kvack.org, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com
Subject:  [patch 08/87] proc/vmcore: convert oldmem_pfn_is_ram
 callback to more generic vmcore callbacks
Message-ID: <20211109023148.b1OlyuiXG%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: proc/vmcore: convert oldmem_pfn_is_ram callback to more generic vmcore callbacks

Let's support multiple registered callbacks, making sure that registering
vmcore callbacks cannot fail.  Make the callback return a bool instead of
an int, handling how to deal with errors internally.  Drop unused
HAVE_OLDMEM_PFN_IS_RAM.

We soon want to make use of this infrastructure from other drivers:
virtio-mem, registering one callback for each virtio-mem device, to
prevent reading unplugged virtio-mem memory.

Handle it via a generic vmcore_cb structure, prepared for future
extensions: for example, once we support virtio-mem on s390x where the
vmcore is completely constructed in the second kernel, we want to detect
and add plugged virtio-mem memory ranges to the vmcore in order for them
to get dumped properly.

Handle corner cases that are unexpected and shouldn't happen in sane
setups: registering a callback after the vmcore has already been opened
(warn only) and unregistering a callback after the vmcore has already been
opened (warn and essentially read only zeroes from that point on).

Link: https://lkml.kernel.org/r/20211005121430.30136-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/aperture_64.c |   13 +++-
 arch/x86/xen/mmu_hvm.c        |   11 ++-
 fs/proc/vmcore.c              |  101 ++++++++++++++++++++++----------
 include/linux/crash_dump.h    |   26 +++++++-
 4 files changed, 112 insertions(+), 39 deletions(-)

--- a/arch/x86/kernel/aperture_64.c~proc-vmcore-convert-oldmem_pfn_is_ram-callback-to-more-generic-vmcore-callbacks
+++ a/arch/x86/kernel/aperture_64.c
@@ -73,12 +73,23 @@ static int gart_mem_pfn_is_ram(unsigned
 		      (pfn >= aperture_pfn_start + aperture_page_count));
 }
 
+#ifdef CONFIG_PROC_VMCORE
+static bool gart_oldmem_pfn_is_ram(struct vmcore_cb *cb, unsigned long pfn)
+{
+	return !!gart_mem_pfn_is_ram(pfn);
+}
+
+static struct vmcore_cb gart_vmcore_cb = {
+	.pfn_is_ram = gart_oldmem_pfn_is_ram,
+};
+#endif
+
 static void __init exclude_from_core(u64 aper_base, u32 aper_order)
 {
 	aperture_pfn_start = aper_base >> PAGE_SHIFT;
 	aperture_page_count = (32 * 1024 * 1024) << aper_order >> PAGE_SHIFT;
 #ifdef CONFIG_PROC_VMCORE
-	WARN_ON(register_oldmem_pfn_is_ram(&gart_mem_pfn_is_ram));
+	register_vmcore_cb(&gart_vmcore_cb);
 #endif
 #ifdef CONFIG_PROC_KCORE
 	WARN_ON(register_mem_pfn_is_ram(&gart_mem_pfn_is_ram));
--- a/arch/x86/xen/mmu_hvm.c~proc-vmcore-convert-oldmem_pfn_is_ram-callback-to-more-generic-vmcore-callbacks
+++ a/arch/x86/xen/mmu_hvm.c
@@ -12,10 +12,10 @@
  * The kdump kernel has to check whether a pfn of the crashed kernel
  * was a ballooned page. vmcore is using this function to decide
  * whether to access a pfn of the crashed kernel.
- * Returns 0 if the pfn is not backed by a RAM page, the caller may
+ * Returns "false" if the pfn is not backed by a RAM page, the caller may
  * handle the pfn special in this case.
  */
-static int xen_oldmem_pfn_is_ram(unsigned long pfn)
+static bool xen_vmcore_pfn_is_ram(struct vmcore_cb *cb, unsigned long pfn)
 {
 	struct xen_hvm_get_mem_type a = {
 		.domid = DOMID_SELF,
@@ -24,10 +24,13 @@ static int xen_oldmem_pfn_is_ram(unsigne
 
 	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a)) {
 		pr_warn_once("Unexpected HVMOP_get_mem_type failure\n");
-		return -ENXIO;
+		return true;
 	}
 	return a.mem_type != HVMMEM_mmio_dm;
 }
+static struct vmcore_cb xen_vmcore_cb = {
+	.pfn_is_ram = xen_vmcore_pfn_is_ram,
+};
 #endif
 
 static void xen_hvm_exit_mmap(struct mm_struct *mm)
@@ -61,6 +64,6 @@ void __init xen_hvm_init_mmu_ops(void)
 	if (is_pagetable_dying_supported())
 		pv_ops.mmu.exit_mmap = xen_hvm_exit_mmap;
 #ifdef CONFIG_PROC_VMCORE
-	WARN_ON(register_oldmem_pfn_is_ram(&xen_oldmem_pfn_is_ram));
+	register_vmcore_cb(&xen_vmcore_cb);
 #endif
 }
--- a/fs/proc/vmcore.c~proc-vmcore-convert-oldmem_pfn_is_ram-callback-to-more-generic-vmcore-callbacks
+++ a/fs/proc/vmcore.c
@@ -62,46 +62,75 @@ core_param(novmcoredd, vmcoredd_disabled
 /* Device Dump Size */
 static size_t vmcoredd_orig_sz;
 
-/*
- * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
- * The called function has to take care of module refcounting.
- */
-static int (*oldmem_pfn_is_ram)(unsigned long pfn);
-
-int register_oldmem_pfn_is_ram(int (*fn)(unsigned long pfn))
-{
-	if (oldmem_pfn_is_ram)
-		return -EBUSY;
-	oldmem_pfn_is_ram = fn;
-	return 0;
+static DECLARE_RWSEM(vmcore_cb_rwsem);
+/* List of registered vmcore callbacks. */
+static LIST_HEAD(vmcore_cb_list);
+/* Whether we had a surprise unregistration of a callback. */
+static bool vmcore_cb_unstable;
+/* Whether the vmcore has been opened once. */
+static bool vmcore_opened;
+
+void register_vmcore_cb(struct vmcore_cb *cb)
+{
+	down_write(&vmcore_cb_rwsem);
+	INIT_LIST_HEAD(&cb->next);
+	list_add_tail(&cb->next, &vmcore_cb_list);
+	/*
+	 * Registering a vmcore callback after the vmcore was opened is
+	 * very unusual (e.g., manual driver loading).
+	 */
+	if (vmcore_opened)
+		pr_warn_once("Unexpected vmcore callback registration\n");
+	up_write(&vmcore_cb_rwsem);
 }
-EXPORT_SYMBOL_GPL(register_oldmem_pfn_is_ram);
+EXPORT_SYMBOL_GPL(register_vmcore_cb);
 
-void unregister_oldmem_pfn_is_ram(void)
+void unregister_vmcore_cb(struct vmcore_cb *cb)
 {
-	oldmem_pfn_is_ram = NULL;
-	wmb();
+	down_write(&vmcore_cb_rwsem);
+	list_del(&cb->next);
+	/*
+	 * Unregistering a vmcore callback after the vmcore was opened is
+	 * very unusual (e.g., forced driver removal), but we cannot stop
+	 * unregistering.
+	 */
+	if (vmcore_opened) {
+		pr_warn_once("Unexpected vmcore callback unregistration\n");
+		vmcore_cb_unstable = true;
+	}
+	up_write(&vmcore_cb_rwsem);
 }
-EXPORT_SYMBOL_GPL(unregister_oldmem_pfn_is_ram);
+EXPORT_SYMBOL_GPL(unregister_vmcore_cb);
 
 static bool pfn_is_ram(unsigned long pfn)
 {
-	int (*fn)(unsigned long pfn);
-	/* pfn is ram unless fn() checks pagetype */
+	struct vmcore_cb *cb;
 	bool ret = true;
 
-	/*
-	 * Ask hypervisor if the pfn is really ram.
-	 * A ballooned page contains no data and reading from such a page
-	 * will cause high load in the hypervisor.
-	 */
-	fn = oldmem_pfn_is_ram;
-	if (fn)
-		ret = !!fn(pfn);
+	lockdep_assert_held_read(&vmcore_cb_rwsem);
+	if (unlikely(vmcore_cb_unstable))
+		return false;
+
+	list_for_each_entry(cb, &vmcore_cb_list, next) {
+		if (unlikely(!cb->pfn_is_ram))
+			continue;
+		ret = cb->pfn_is_ram(cb, pfn);
+		if (!ret)
+			break;
+	}
 
 	return ret;
 }
 
+static int open_vmcore(struct inode *inode, struct file *file)
+{
+	down_read(&vmcore_cb_rwsem);
+	vmcore_opened = true;
+	up_read(&vmcore_cb_rwsem);
+
+	return 0;
+}
+
 /* Reads a page from the oldmem device from given offset. */
 ssize_t read_from_oldmem(char *buf, size_t count,
 			 u64 *ppos, int userbuf,
@@ -117,6 +146,7 @@ ssize_t read_from_oldmem(char *buf, size
 	offset = (unsigned long)(*ppos % PAGE_SIZE);
 	pfn = (unsigned long)(*ppos / PAGE_SIZE);
 
+	down_read(&vmcore_cb_rwsem);
 	do {
 		if (count > (PAGE_SIZE - offset))
 			nr_bytes = PAGE_SIZE - offset;
@@ -136,8 +166,10 @@ ssize_t read_from_oldmem(char *buf, size
 				tmp = copy_oldmem_page(pfn, buf, nr_bytes,
 						       offset, userbuf);
 
-			if (tmp < 0)
+			if (tmp < 0) {
+				up_read(&vmcore_cb_rwsem);
 				return tmp;
+			}
 		}
 		*ppos += nr_bytes;
 		count -= nr_bytes;
@@ -147,6 +179,7 @@ ssize_t read_from_oldmem(char *buf, size
 		offset = 0;
 	} while (count);
 
+	up_read(&vmcore_cb_rwsem);
 	return read;
 }
 
@@ -537,14 +570,19 @@ static int vmcore_remap_oldmem_pfn(struc
 			    unsigned long from, unsigned long pfn,
 			    unsigned long size, pgprot_t prot)
 {
+	int ret;
+
 	/*
 	 * Check if oldmem_pfn_is_ram was registered to avoid
 	 * looping over all pages without a reason.
 	 */
-	if (oldmem_pfn_is_ram)
-		return remap_oldmem_pfn_checked(vma, from, pfn, size, prot);
+	down_read(&vmcore_cb_rwsem);
+	if (!list_empty(&vmcore_cb_list) || vmcore_cb_unstable)
+		ret = remap_oldmem_pfn_checked(vma, from, pfn, size, prot);
 	else
-		return remap_oldmem_pfn_range(vma, from, pfn, size, prot);
+		ret = remap_oldmem_pfn_range(vma, from, pfn, size, prot);
+	up_read(&vmcore_cb_rwsem);
+	return ret;
 }
 
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
@@ -668,6 +706,7 @@ static int mmap_vmcore(struct file *file
 #endif
 
 static const struct proc_ops vmcore_proc_ops = {
+	.proc_open	= open_vmcore,
 	.proc_read	= read_vmcore,
 	.proc_lseek	= default_llseek,
 	.proc_mmap	= mmap_vmcore,
--- a/include/linux/crash_dump.h~proc-vmcore-convert-oldmem_pfn_is_ram-callback-to-more-generic-vmcore-callbacks
+++ a/include/linux/crash_dump.h
@@ -91,9 +91,29 @@ static inline void vmcore_unusable(void)
 		elfcorehdr_addr = ELFCORE_ADDR_ERR;
 }
 
-#define HAVE_OLDMEM_PFN_IS_RAM 1
-extern int register_oldmem_pfn_is_ram(int (*fn)(unsigned long pfn));
-extern void unregister_oldmem_pfn_is_ram(void);
+/**
+ * struct vmcore_cb - driver callbacks for /proc/vmcore handling
+ * @pfn_is_ram: check whether a PFN really is RAM and should be accessed when
+ *              reading the vmcore. Will return "true" if it is RAM or if the
+ *              callback cannot tell. If any callback returns "false", it's not
+ *              RAM and the page must not be accessed; zeroes should be
+ *              indicated in the vmcore instead. For example, a ballooned page
+ *              contains no data and reading from such a page will cause high
+ *              load in the hypervisor.
+ * @next: List head to manage registered callbacks internally; initialized by
+ *        register_vmcore_cb().
+ *
+ * vmcore callbacks allow drivers managing physical memory ranges to
+ * coordinate with vmcore handling code, for example, to prevent accessing
+ * physical memory ranges that should not be accessed when reading the vmcore,
+ * although included in the vmcore header as memory ranges to dump.
+ */
+struct vmcore_cb {
+	bool (*pfn_is_ram)(struct vmcore_cb *cb, unsigned long pfn);
+	struct list_head next;
+};
+extern void register_vmcore_cb(struct vmcore_cb *cb);
+extern void unregister_vmcore_cb(struct vmcore_cb *cb);
 
 #else /* !CONFIG_CRASH_DUMP */
 static inline bool is_kdump_kernel(void) { return 0; }
_
