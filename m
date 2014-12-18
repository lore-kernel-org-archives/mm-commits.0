From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 17 Dec 2014 17:07:18 -0800
Message-ID: <549228c6.o+sHDc5jfM6nAJb6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaLRBHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 20:07:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/input/gpio-keys.txt |    9 ---
 arch/arm/mm/dma-mapping.c                             |    7 --
 arch/x86/include/asm/xen/page.h                       |   17 ------
 arch/x86/xen/mmu.c                                    |    4 -
 arch/x86/xen/p2m.c                                    |    8 ---
 drivers/input/keyboard/gpio_keys.c                    |   26 ----------
 include/linux/user_namespace.h                        |    3 -
 kernel/user.c                                         |    3 -
 kernel/user_namespace.c                               |    3 -
 9 files changed, 80 deletions(-)

diff -puN Documentation/devicetree/bindings/input/gpio-keys.txt~linux-next-git-rejects Documentation/devicetree/bindings/input/gpio-keys.txt
--- a/Documentation/devicetree/bindings/input/gpio-keys.txt~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/input/gpio-keys.txt
@@ -10,14 +10,6 @@ Optional properties:
 Each button (key) is represented as a sub-node of "gpio-keys":
 Subnode properties:
 
-<<<<<<< HEAD
-	- label: Descriptive name of the key.
-	- linux,code: Keycode to emit.
-
-Required mutual exclusive subnode-properties:
-	- gpios: OF device-tree gpio specification.
-	- interrupts: the interrupt line for that input
-=======
 	- gpios: OF device-tree gpio specification.
 	- interrupts: the interrupt line for that input.
 	- label: Descriptive name of the key.
@@ -25,7 +17,6 @@ Required mutual exclusive subnode-proper
 
 Note that either "interrupts" or "gpios" properties can be omitted, but not
 both at the same time. Specifying both properties is allowed.
->>>>>>> linux-next/akpm-base
 
 Optional subnode-properties:
 	- linux,input-type: Specify event type this button/key generates.
diff -puN arch/arm/mm/dma-mapping.c~linux-next-git-rejects arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~linux-next-git-rejects
+++ a/arch/arm/mm/dma-mapping.c
@@ -2053,19 +2053,12 @@ void arch_setup_dma_ops(struct device *d
 {
 	struct dma_map_ops *dma_ops;
 
-<<<<<<< HEAD
-	dev->archdata.dma_coherent = coherent;
-=======
->>>>>>> linux-next/akpm-base
 	if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
 		dma_ops = arm_get_iommu_dma_map_ops(coherent);
 	else
 		dma_ops = arm_get_dma_map_ops(coherent);
 
-<<<<<<< HEAD
-=======
 	dev->archdata.dma_coherent = coherent;
->>>>>>> linux-next/akpm-base
 	set_dma_ops(dev, dma_ops);
 }
 
diff -puN arch/x86/include/asm/xen/page.h~linux-next-git-rejects arch/x86/include/asm/xen/page.h
--- a/arch/x86/include/asm/xen/page.h~linux-next-git-rejects
+++ a/arch/x86/include/asm/xen/page.h
@@ -60,23 +60,6 @@ extern int clear_foreign_p2m_mapping(str
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
 /*
-<<<<<<< HEAD
- * Helper functions to write or read unsigned long values to/from
- * memory, when the access may fault.
- */
-static inline int xen_safe_write_ulong(unsigned long *addr, unsigned long val)
-{
-	return __put_user(val, (unsigned long __user *)addr);
-}
-
-static inline int xen_safe_read_ulong(unsigned long *addr, unsigned long *val)
-{
-	return __get_user(*val, (unsigned long __user *)addr);
-}
-
-/*
-=======
->>>>>>> linux-next/akpm-base
  * When to use pfn_to_mfn(), __pfn_to_mfn() or get_phys_to_machine():
  * - pfn_to_mfn() returns either INVALID_P2M_ENTRY or the mfn. No indicator
  *   bits (identity or foreign) are set.
diff -puN arch/x86/xen/mmu.c~linux-next-git-rejects arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~linux-next-git-rejects
+++ a/arch/x86/xen/mmu.c
@@ -1180,10 +1180,6 @@ static void __init xen_pagetable_p2m_set
 static void __init xen_pagetable_init(void)
 {
 	paging_init();
-<<<<<<< HEAD
-	xen_post_allocator_init();
-=======
->>>>>>> linux-next/akpm-base
 
 	xen_pagetable_p2m_setup();
 
diff -puN arch/x86/xen/p2m.c~linux-next-git-rejects arch/x86/xen/p2m.c
--- a/arch/x86/xen/p2m.c~linux-next-git-rejects
+++ a/arch/x86/xen/p2m.c
@@ -554,11 +554,7 @@ static bool alloc_p2m(unsigned long pfn)
 		mid_mfn = NULL;
 	}
 
-<<<<<<< HEAD
-	p2m_pfn = pte_pfn(ACCESS_ONCE(*ptep));
-=======
 	p2m_pfn = pte_pfn(READ_ONCE(*ptep));
->>>>>>> linux-next/akpm-base
 	if (p2m_pfn == PFN_DOWN(__pa(p2m_identity)) ||
 	    p2m_pfn == PFN_DOWN(__pa(p2m_missing))) {
 		/* p2m leaf page is missing */
@@ -629,11 +625,7 @@ bool __set_phys_to_machine(unsigned long
 		return true;
 	}
 
-<<<<<<< HEAD
-	if (likely(!xen_safe_write_ulong(xen_p2m_addr + pfn, mfn)))
-=======
 	if (likely(!__put_user(mfn, xen_p2m_addr + pfn)))
->>>>>>> linux-next/akpm-base
 		return true;
 
 	ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn), &level);
diff -puN drivers/input/keyboard/gpio_keys.c~linux-next-git-rejects drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~linux-next-git-rejects
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -619,45 +619,20 @@ gpio_keys_get_devtree_pdata(struct devic
 
 	i = 0;
 	for_each_child_of_node(node, pp) {
-<<<<<<< HEAD
-		int gpio = -1;
-=======
->>>>>>> linux-next/akpm-base
 		enum of_gpio_flags flags;
 
 		button = &pdata->buttons[i++];
 
-<<<<<<< HEAD
-		if (!of_find_property(pp, "gpios", NULL)) {
-			button->irq = irq_of_parse_and_map(pp, 0);
-			if (button->irq == 0) {
-				i--;
-				pdata->nbuttons--;
-				dev_warn(dev, "Found button without gpios or irqs\n");
-				continue;
-			}
-		} else {
-			gpio = of_get_gpio_flags(pp, 0, &flags);
-			if (gpio < 0) {
-				error = gpio;
-=======
 		button->gpio = of_get_gpio_flags(pp, 0, &flags);
 		if (button->gpio < 0) {
 			error = button->gpio;
 			if (error != -ENOENT) {
->>>>>>> linux-next/akpm-base
 				if (error != -EPROBE_DEFER)
 					dev_err(dev,
 						"Failed to get gpio flags, error: %d\n",
 						error);
 				return ERR_PTR(error);
 			}
-<<<<<<< HEAD
-		}
-
-		button->gpio = gpio;
-		button->active_low = flags & OF_GPIO_ACTIVE_LOW;
-=======
 		} else {
 			button->active_low = flags & OF_GPIO_ACTIVE_LOW;
 		}
@@ -668,7 +643,6 @@ gpio_keys_get_devtree_pdata(struct devic
 			dev_err(dev, "Found button without gpios or irqs\n");
 			return ERR_PTR(-EINVAL);
 		}
->>>>>>> linux-next/akpm-base
 
 		if (of_property_read_u32(pp, "linux,code", &button->code)) {
 			dev_err(dev, "Button without keycode: 0x%x\n",
diff -puN include/linux/user_namespace.h~linux-next-git-rejects include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~linux-next-git-rejects
+++ a/include/linux/user_namespace.h
@@ -32,10 +32,7 @@ struct user_namespace {
 	kuid_t			owner;
 	kgid_t			group;
 	struct ns_common	ns;
-<<<<<<< HEAD
-=======
 	unsigned long		flags;
->>>>>>> linux-next/akpm-base
 
 	/* Register of per-UID persistent keyrings for this namespace */
 #ifdef CONFIG_PERSISTENT_KEYRINGS
diff -puN kernel/user.c~linux-next-git-rejects kernel/user.c
--- a/kernel/user.c~linux-next-git-rejects
+++ a/kernel/user.c
@@ -54,10 +54,7 @@ struct user_namespace init_user_ns = {
 #ifdef CONFIG_USER_NS
 	.ns.ops = &userns_operations,
 #endif
-<<<<<<< HEAD
-=======
 	.flags = USERNS_INIT_FLAGS,
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	.persistent_keyring_register_sem =
 	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
diff -puN kernel/user_namespace.c~linux-next-git-rejects kernel/user_namespace.c
--- a/kernel/user_namespace.c~linux-next-git-rejects
+++ a/kernel/user_namespace.c
@@ -855,8 +855,6 @@ static inline struct user_namespace *to_
 	return container_of(ns, struct user_namespace, ns);
 }
 
-<<<<<<< HEAD
-=======
 int proc_setgroups_show(struct seq_file *seq, void *v)
 {
 	struct user_namespace *ns = seq->private;
@@ -951,7 +949,6 @@ bool userns_may_setgroups(const struct u
 	return allowed;
 }
 
->>>>>>> linux-next/akpm-base
 static struct ns_common *userns_get(struct task_struct *task)
 {
 	struct user_namespace *user_ns;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
mailmap-update-akpm-osdlorg.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

