Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D83032C71
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 06:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xBzQuhZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F52C433C7;
	Wed, 10 Jan 2024 06:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704867802;
	bh=qnjgGaR8XXRWZ+tmQDxfC6xYsq2ZeUCM7Fsyt9KaU+s=;
	h=Date:To:From:Subject:From;
	b=xBzQuhZkwhAuF3XcfaMnmMmOczJx+WcGLf8SgQas2p3WC3XCGqVfboVXZ5qQ7wyjB
	 ayC+dnA0/M5f+FOAteEtDeZtzTLv3BQU+IIN4tdhKi5ubLL1xUoLVwovght/WcEyVR
	 hFwnOcQk2/yzL9WWRXdp9H0F8spbRCM8fpVfzF2I=
Date: Tue, 09 Jan 2024 22:23:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,urezki@gmail.com,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-remove-vmap_area_list.patch added to mm-unstable branch
Message-Id: <20240110062322.D3F52C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: remove vmap_area_list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-remove-vmap_area_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-remove-vmap_area_list.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: remove vmap_area_list
Date: Tue, 2 Jan 2024 19:46:27 +0100

Earlier, vmap_area_list is exported to vmcoreinfo so that makedumpfile get
the base address of vmalloc area.  Now, vmap_area_list is empty, so export
VMALLOC_START to vmcoreinfo instead, and remove vmap_area_list.

Link: https://lkml.kernel.org/r/20240102184633.748113-6-urezki@gmail.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    8 ++++----
 arch/arm64/kernel/crash_core.c                 |    1 -
 arch/riscv/kernel/crash_core.c                 |    1 -
 include/linux/vmalloc.h                        |    1 -
 kernel/crash_core.c                            |    4 +---
 kernel/kallsyms_selftest.c                     |    1 -
 mm/nommu.c                                     |    2 --
 mm/vmalloc.c                                   |    2 --
 8 files changed, 5 insertions(+), 15 deletions(-)

--- a/arch/arm64/kernel/crash_core.c~mm-vmalloc-remove-vmap_area_list
+++ a/arch/arm64/kernel/crash_core.c
@@ -23,7 +23,6 @@ void arch_crash_save_vmcoreinfo(void)
 	/* Please note VMCOREINFO_NUMBER() uses "%d", not "%x" */
 	vmcoreinfo_append_str("NUMBER(MODULES_VADDR)=0x%lx\n", MODULES_VADDR);
 	vmcoreinfo_append_str("NUMBER(MODULES_END)=0x%lx\n", MODULES_END);
-	vmcoreinfo_append_str("NUMBER(VMALLOC_START)=0x%lx\n", VMALLOC_START);
 	vmcoreinfo_append_str("NUMBER(VMALLOC_END)=0x%lx\n", VMALLOC_END);
 	vmcoreinfo_append_str("NUMBER(VMEMMAP_START)=0x%lx\n", VMEMMAP_START);
 	vmcoreinfo_append_str("NUMBER(VMEMMAP_END)=0x%lx\n", VMEMMAP_END);
--- a/arch/riscv/kernel/crash_core.c~mm-vmalloc-remove-vmap_area_list
+++ a/arch/riscv/kernel/crash_core.c
@@ -8,7 +8,6 @@ void arch_crash_save_vmcoreinfo(void)
 	VMCOREINFO_NUMBER(phys_ram_base);
 
 	vmcoreinfo_append_str("NUMBER(PAGE_OFFSET)=0x%lx\n", PAGE_OFFSET);
-	vmcoreinfo_append_str("NUMBER(VMALLOC_START)=0x%lx\n", VMALLOC_START);
 	vmcoreinfo_append_str("NUMBER(VMALLOC_END)=0x%lx\n", VMALLOC_END);
 #ifdef CONFIG_MMU
 	VMCOREINFO_NUMBER(VA_BITS);
--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~mm-vmalloc-remove-vmap_area_list
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -65,11 +65,11 @@ Defines the beginning of the text sectio
 the kernel start address. Used to convert a virtual address from the
 direct kernel map to a physical address.
 
-vmap_area_list
---------------
+VMALLOC_START
+-------------
 
-Stores the virtual area list. makedumpfile gets the vmalloc start value
-from this variable and its value is necessary for vmalloc translation.
+Stores the base address of vmalloc area. makedumpfile gets this value
+since is necessary for vmalloc translation.
 
 mem_map
 -------
--- a/include/linux/vmalloc.h~mm-vmalloc-remove-vmap_area_list
+++ a/include/linux/vmalloc.h
@@ -253,7 +253,6 @@ extern long vread_iter(struct iov_iter *
 /*
  *	Internals.  Don't use..
  */
-extern struct list_head vmap_area_list;
 extern __init void vm_area_add_early(struct vm_struct *vm);
 extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
 
--- a/kernel/crash_core.c~mm-vmalloc-remove-vmap_area_list
+++ a/kernel/crash_core.c
@@ -748,7 +748,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_SYMBOL_ARRAY(swapper_pg_dir);
 #endif
 	VMCOREINFO_SYMBOL(_stext);
-	VMCOREINFO_SYMBOL(vmap_area_list);
+	vmcoreinfo_append_str("NUMBER(VMALLOC_START)=0x%lx\n", VMALLOC_START);
 
 #ifndef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(mem_map);
@@ -789,8 +789,6 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(free_area, free_list);
 	VMCOREINFO_OFFSET(list_head, next);
 	VMCOREINFO_OFFSET(list_head, prev);
-	VMCOREINFO_OFFSET(vmap_area, va_start);
-	VMCOREINFO_OFFSET(vmap_area, list);
 	VMCOREINFO_LENGTH(zone.free_area, NR_PAGE_ORDERS);
 	log_buf_vmcoreinfo_setup();
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
--- a/kernel/kallsyms_selftest.c~mm-vmalloc-remove-vmap_area_list
+++ a/kernel/kallsyms_selftest.c
@@ -89,7 +89,6 @@ static struct test_item test_items[] = {
 	ITEM_DATA(kallsyms_test_var_data_static),
 	ITEM_DATA(kallsyms_test_var_bss),
 	ITEM_DATA(kallsyms_test_var_data),
-	ITEM_DATA(vmap_area_list),
 #endif
 };
 
--- a/mm/nommu.c~mm-vmalloc-remove-vmap_area_list
+++ a/mm/nommu.c
@@ -131,8 +131,6 @@ int follow_pfn(struct vm_area_struct *vm
 }
 EXPORT_SYMBOL(follow_pfn);
 
-LIST_HEAD(vmap_area_list);
-
 void vfree(const void *addr)
 {
 	kfree(addr);
--- a/mm/vmalloc.c~mm-vmalloc-remove-vmap_area_list
+++ a/mm/vmalloc.c
@@ -729,8 +729,6 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 
 
 static DEFINE_SPINLOCK(free_vmap_area_lock);
-/* Export for kexec only */
-LIST_HEAD(vmap_area_list);
 static bool vmap_initialized __read_mostly;
 
 static struct rb_root purge_vmap_area_root = RB_ROOT;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-vmap_area_list.patch
panic-suppress-gnu_printf-warning.patch

