From: akpm@linux-foundation.org
Subject: - ia64-rename-partial_page.patch removed from -mm tree
Date: Wed, 25 Jul 2007 21:24:01 -0700
Message-ID: <200707260424.l6Q4O1uw013753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51007 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbXGZEYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 00:24:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: rename partial_page
has been removed from the -mm tree.  Its filename was
     ia64-rename-partial_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: rename partial_page
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/linux/net.h:23,
                 from include/net/scm.h:5,
                 from arch/ia64/ia32/sys_ia32.c:62:
include/linux/splice.h:42: error: redefinition of `struct partial_page'

Jens has added a partial_apge thing in splice whcih conflicts with the ia64
one.  Rename ia64 out of the way.  (ia64 chose poorly).

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/ia32_support.c |    8 +--
 arch/ia64/ia32/ia32priv.h     |   12 ++--
 arch/ia64/ia32/sys_ia32.c     |   81 ++++++++++++++++----------------
 arch/ia64/kernel/process.c    |    7 +-
 include/asm-ia64/ia32.h       |    9 +--
 include/asm-ia64/processor.h  |    4 -
 6 files changed, 62 insertions(+), 59 deletions(-)

diff -puN arch/ia64/ia32/ia32_support.c~ia64-rename-partial_page arch/ia64/ia32/ia32_support.c
--- a/arch/ia64/ia32/ia32_support.c~ia64-rename-partial_page
+++ a/arch/ia64/ia32/ia32_support.c
@@ -249,11 +249,11 @@ ia32_init (void)
 
 #if PAGE_SHIFT > IA32_PAGE_SHIFT
 	{
-		extern struct kmem_cache *partial_page_cachep;
+		extern struct kmem_cache *ia64_partial_page_cachep;
 
-		partial_page_cachep = kmem_cache_create("partial_page_cache",
-						sizeof(struct partial_page),
-						0, SLAB_PANIC, NULL);
+		ia64_partial_page_cachep = kmem_cache_create("ia64_partial_page_cache",
+					sizeof(struct ia64_partial_page),
+					0, SLAB_PANIC, NULL);
 	}
 #endif
 	return 0;
diff -puN arch/ia64/ia32/ia32priv.h~ia64-rename-partial_page arch/ia64/ia32/ia32priv.h
--- a/arch/ia64/ia32/ia32priv.h~ia64-rename-partial_page
+++ a/arch/ia64/ia32/ia32priv.h
@@ -25,8 +25,8 @@
  * partially mapped pages provide precise accounting of which 4k sub pages
  * are mapped and which ones are not, thereby improving IA-32 compatibility.
  */
-struct partial_page {
-	struct partial_page	*next; /* linked list, sorted by address */
+struct ia64_partial_page {
+	struct ia64_partial_page *next; /* linked list, sorted by address */
 	struct rb_node		pp_rb;
 	/* 64K is the largest "normal" page supported by ia64 ABI. So 4K*64
 	 * should suffice.*/
@@ -34,17 +34,17 @@ struct partial_page {
 	unsigned int		base;
 };
 
-struct partial_page_list {
-	struct partial_page	*pp_head; /* list head, points to the lowest
+struct ia64_partial_page_list {
+	struct ia64_partial_page *pp_head; /* list head, points to the lowest
 					   * addressed partial page */
 	struct rb_root		ppl_rb;
-	struct partial_page	*pp_hint; /* pp_hint->next is the last
+	struct ia64_partial_page *pp_hint; /* pp_hint->next is the last
 					   * accessed partial page */
 	atomic_t		pp_count; /* reference count */
 };
 
 #if PAGE_SHIFT > IA32_PAGE_SHIFT
-struct partial_page_list* ia32_init_pp_list (void);
+struct ia64_partial_page_list* ia32_init_pp_list (void);
 #else
 # define ia32_init_pp_list()	0
 #endif
diff -puN arch/ia64/ia32/sys_ia32.c~ia64-rename-partial_page arch/ia64/ia32/sys_ia32.c
--- a/arch/ia64/ia32/sys_ia32.c~ia64-rename-partial_page
+++ a/arch/ia64/ia32/sys_ia32.c
@@ -253,17 +253,17 @@ mmap_subpage (struct file *file, unsigne
 	return ret;
 }
 
-/* SLAB cache for partial_page structures */
-struct kmem_cache *partial_page_cachep;
+/* SLAB cache for ia64_partial_page structures */
+struct kmem_cache *ia64_partial_page_cachep;
 
 /*
- * init partial_page_list.
+ * init ia64_partial_page_list.
  * return 0 means kmalloc fail.
  */
-struct partial_page_list*
+struct ia64_partial_page_list*
 ia32_init_pp_list(void)
 {
-	struct partial_page_list *p;
+	struct ia64_partial_page_list *p;
 
 	if ((p = kmalloc(sizeof(*p), GFP_KERNEL)) == NULL)
 		return p;
@@ -280,12 +280,12 @@ ia32_init_pp_list(void)
  * Else, return 0 and provide @pprev, @rb_link, @rb_parent to
  * be used by later __ia32_insert_pp().
  */
-static struct partial_page *
-__ia32_find_pp(struct partial_page_list *ppl, unsigned int start,
-	struct partial_page **pprev, struct rb_node ***rb_link,
+static struct ia64_partial_page *
+__ia32_find_pp(struct ia64_partial_page_list *ppl, unsigned int start,
+	struct ia64_partial_page **pprev, struct rb_node ***rb_link,
 	struct rb_node **rb_parent)
 {
-	struct partial_page *pp;
+	struct ia64_partial_page *pp;
 	struct rb_node **__rb_link, *__rb_parent, *rb_prev;
 
 	pp = ppl->pp_hint;
@@ -297,7 +297,7 @@ __ia32_find_pp(struct partial_page_list 
 
 	while (*__rb_link) {
 		__rb_parent = *__rb_link;
-		pp = rb_entry(__rb_parent, struct partial_page, pp_rb);
+		pp = rb_entry(__rb_parent, struct ia64_partial_page, pp_rb);
 
 		if (pp->base == start) {
 			ppl->pp_hint = pp;
@@ -314,7 +314,7 @@ __ia32_find_pp(struct partial_page_list 
 	*rb_parent = __rb_parent;
 	*pprev = NULL;
 	if (rb_prev)
-		*pprev = rb_entry(rb_prev, struct partial_page, pp_rb);
+		*pprev = rb_entry(rb_prev, struct ia64_partial_page, pp_rb);
 	return NULL;
 }
 
@@ -322,9 +322,9 @@ __ia32_find_pp(struct partial_page_list 
  * insert @pp into @ppl.
  */
 static void
-__ia32_insert_pp(struct partial_page_list *ppl, struct partial_page *pp,
-	 struct partial_page *prev, struct rb_node **rb_link,
-	struct rb_node *rb_parent)
+__ia32_insert_pp(struct ia64_partial_page_list *ppl,
+	struct ia64_partial_page *pp, struct ia64_partial_page *prev,
+	struct rb_node **rb_link, struct rb_node *rb_parent)
 {
 	/* link list */
 	if (prev) {
@@ -334,7 +334,7 @@ __ia32_insert_pp(struct partial_page_lis
 		ppl->pp_head = pp;
 		if (rb_parent)
 			pp->next = rb_entry(rb_parent,
-				struct partial_page, pp_rb);
+				struct ia64_partial_page, pp_rb);
 		else
 			pp->next = NULL;
 	}
@@ -350,8 +350,8 @@ __ia32_insert_pp(struct partial_page_lis
  * delete @pp from partial page list @ppl.
  */
 static void
-__ia32_delete_pp(struct partial_page_list *ppl, struct partial_page *pp,
-	struct partial_page *prev)
+__ia32_delete_pp(struct ia64_partial_page_list *ppl,
+	struct ia64_partial_page *pp, struct ia64_partial_page *prev)
 {
 	if (prev) {
 		prev->next = pp->next;
@@ -363,15 +363,15 @@ __ia32_delete_pp(struct partial_page_lis
 			ppl->pp_hint = pp->next;
 	}
 	rb_erase(&pp->pp_rb, &ppl->ppl_rb);
-	kmem_cache_free(partial_page_cachep, pp);
+	kmem_cache_free(ia64_partial_page_cachep, pp);
 }
 
-static struct partial_page *
-__pp_prev(struct partial_page *pp)
+static struct ia64_partial_page *
+__pp_prev(struct ia64_partial_page *pp)
 {
 	struct rb_node *prev = rb_prev(&pp->pp_rb);
 	if (prev)
-		return rb_entry(prev, struct partial_page, pp_rb);
+		return rb_entry(prev, struct ia64_partial_page, pp_rb);
 	else
 		return NULL;
 }
@@ -383,7 +383,7 @@ __pp_prev(struct partial_page *pp)
 static void
 __ia32_delete_pp_range(unsigned int start, unsigned int end)
 {
-	struct partial_page *pp, *prev;
+	struct ia64_partial_page *pp, *prev;
 	struct rb_node **rb_link, *rb_parent;
 
 	if (start >= end)
@@ -401,7 +401,7 @@ __ia32_delete_pp_range(unsigned int star
 	}
 
 	while (pp && pp->base < end) {
-		struct partial_page *tmp = pp->next;
+		struct ia64_partial_page *tmp = pp->next;
 		__ia32_delete_pp(current->thread.ppl, pp, prev);
 		pp = tmp;
 	}
@@ -414,7 +414,7 @@ __ia32_delete_pp_range(unsigned int star
 static int
 __ia32_set_pp(unsigned int start, unsigned int end, int flags)
 {
-	struct partial_page *pp, *prev;
+	struct ia64_partial_page *pp, *prev;
 	struct rb_node ** rb_link, *rb_parent;
 	unsigned int pstart, start_bit, end_bit, i;
 
@@ -450,8 +450,8 @@ __ia32_set_pp(unsigned int start, unsign
 			return 0;
 	}
 
-	/* new a partial_page */
-	pp = kmem_cache_alloc(partial_page_cachep, GFP_KERNEL);
+	/* new a ia64_partial_page */
+	pp = kmem_cache_alloc(ia64_partial_page_cachep, GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
 	pp->base = pstart;
@@ -504,7 +504,7 @@ ia32_set_pp(unsigned int start, unsigned
 static int
 __ia32_unset_pp(unsigned int start, unsigned int end)
 {
-	struct partial_page *pp, *prev;
+	struct ia64_partial_page *pp, *prev;
 	struct rb_node ** rb_link, *rb_parent;
 	unsigned int pstart, start_bit, end_bit, i;
 	struct vm_area_struct *vma;
@@ -532,8 +532,8 @@ __ia32_unset_pp(unsigned int start, unsi
 		return -ENOMEM;
 	}
 
-	/* new a partial_page */
-	pp = kmem_cache_alloc(partial_page_cachep, GFP_KERNEL);
+	/* new a ia64_partial_page */
+	pp = kmem_cache_alloc(ia64_partial_page_cachep, GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
 	pp->base = pstart;
@@ -605,7 +605,7 @@ ia32_unset_pp(unsigned int *startp, unsi
 static int
 __ia32_compare_pp(unsigned int start, unsigned int end)
 {
-	struct partial_page *pp, *prev;
+	struct ia64_partial_page *pp, *prev;
 	struct rb_node ** rb_link, *rb_parent;
 	unsigned int pstart, start_bit, end_bit, size;
 	unsigned int first_bit, next_zero_bit;	/* the first range in bitmap */
@@ -682,13 +682,13 @@ ia32_compare_pp(unsigned int *startp, un
 }
 
 static void
-__ia32_drop_pp_list(struct partial_page_list *ppl)
+__ia32_drop_pp_list(struct ia64_partial_page_list *ppl)
 {
-	struct partial_page *pp = ppl->pp_head;
+	struct ia64_partial_page *pp = ppl->pp_head;
 
 	while (pp) {
-		struct partial_page *next = pp->next;
-		kmem_cache_free(partial_page_cachep, pp);
+		struct ia64_partial_page *next = pp->next;
+		kmem_cache_free(ia64_partial_page_cachep, pp);
 		pp = next;
 	}
 
@@ -696,9 +696,9 @@ __ia32_drop_pp_list(struct partial_page_
 }
 
 void
-ia32_drop_partial_page_list(struct task_struct *task)
+ia32_drop_ia64_partial_page_list(struct task_struct *task)
 {
-	struct partial_page_list* ppl = task->thread.ppl;
+	struct ia64_partial_page_list* ppl = task->thread.ppl;
 
 	if (ppl && atomic_dec_and_test(&ppl->pp_count))
 		__ia32_drop_pp_list(ppl);
@@ -708,9 +708,9 @@ ia32_drop_partial_page_list(struct task_
  * Copy current->thread.ppl to ppl (already initialized).
  */
 static int
-__ia32_copy_pp_list(struct partial_page_list *ppl)
+__ia32_copy_pp_list(struct ia64_partial_page_list *ppl)
 {
-	struct partial_page *pp, *tmp, *prev;
+	struct ia64_partial_page *pp, *tmp, *prev;
 	struct rb_node **rb_link, *rb_parent;
 
 	ppl->pp_head = NULL;
@@ -721,7 +721,7 @@ __ia32_copy_pp_list(struct partial_page_
 	prev = NULL;
 
 	for (pp = current->thread.ppl->pp_head; pp; pp = pp->next) {
-		tmp = kmem_cache_alloc(partial_page_cachep, GFP_KERNEL);
+		tmp = kmem_cache_alloc(ia64_partial_page_cachep, GFP_KERNEL);
 		if (!tmp)
 			return -ENOMEM;
 		*tmp = *pp;
@@ -734,7 +734,8 @@ __ia32_copy_pp_list(struct partial_page_
 }
 
 int
-ia32_copy_partial_page_list(struct task_struct *p, unsigned long clone_flags)
+ia32_copy_ia64_partial_page_list(struct task_struct *p,
+				unsigned long clone_flags)
 {
 	int retval = 0;
 
diff -puN arch/ia64/kernel/process.c~ia64-rename-partial_page arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~ia64-rename-partial_page
+++ a/arch/ia64/kernel/process.c
@@ -499,7 +499,8 @@ copy_thread (int nr, unsigned long clone
 
 		/* Copy partially mapped page list */
 		if (!retval)
-			retval = ia32_copy_partial_page_list(p, clone_flags);
+			retval = ia32_copy_ia64_partial_page_list(p,
+								clone_flags);
 	}
 #endif
 
@@ -728,7 +729,7 @@ flush_thread (void)
 	ia64_drop_fpu(current);
 #ifdef CONFIG_IA32_SUPPORT
 	if (IS_IA32_PROCESS(task_pt_regs(current))) {
-		ia32_drop_partial_page_list(current);
+		ia32_drop_ia64_partial_page_list(current);
 		current->thread.task_size = IA32_PAGE_OFFSET;
 		set_fs(USER_DS);
 	}
@@ -754,7 +755,7 @@ exit_thread (void)
 		pfm_release_debug_registers(current);
 #endif
 	if (IS_IA32_PROCESS(task_pt_regs(current)))
-		ia32_drop_partial_page_list(current);
+		ia32_drop_ia64_partial_page_list(current);
 }
 
 unsigned long
diff -puN include/asm-ia64/ia32.h~ia64-rename-partial_page include/asm-ia64/ia32.h
--- a/include/asm-ia64/ia32.h~ia64-rename-partial_page
+++ a/include/asm-ia64/ia32.h
@@ -27,11 +27,12 @@ extern int ia32_clone_tls (struct task_s
 extern int ia32_setup_frame1 (int sig, struct k_sigaction *ka, siginfo_t *info,
 			      sigset_t *set, struct pt_regs *regs);
 #if PAGE_SHIFT > IA32_PAGE_SHIFT
-extern int ia32_copy_partial_page_list (struct task_struct *, unsigned long);
-extern void ia32_drop_partial_page_list (struct task_struct *);
+extern int ia32_copy_ia64_partial_page_list(struct task_struct *,
+					unsigned long);
+extern void ia32_drop_ia64_partial_page_list(struct task_struct *);
 #else
-# define ia32_copy_partial_page_list(a1, a2)	0
-# define ia32_drop_partial_page_list(a1)	do { ; } while (0)
+# define ia32_copy_ia64_partial_page_list(a1, a2)	0
+# define ia32_drop_ia64_partial_page_list(a1)	do { ; } while (0)
 #endif
 
 #endif /* !__ASSEMBLY__ */
diff -puN include/asm-ia64/processor.h~ia64-rename-partial_page include/asm-ia64/processor.h
--- a/include/asm-ia64/processor.h~ia64-rename-partial_page
+++ a/include/asm-ia64/processor.h
@@ -220,7 +220,7 @@ struct desc_struct {
 
 #define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8)
 
-struct partial_page_list;
+struct ia64_partial_page_list;
 #endif
 
 struct thread_struct {
@@ -242,7 +242,7 @@ struct thread_struct {
 	__u64 fdr;			/* IA32 fp except. data reg */
 	__u64 old_k1;			/* old value of ar.k1 */
 	__u64 old_iob;			/* old IOBase value */
-	struct partial_page_list *ppl;	/* partial page list for 4K page size issue */
+	struct ia64_partial_page_list *ppl; /* partial page list for 4K page size issue */
         /* cached TLS descriptors. */
 	struct desc_struct tls_array[GDT_ENTRY_TLS_ENTRIES];
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-stk17ta8-update-for-sysfs-api-change.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
ufs-printk-warning-fix.patch
i2c-ds1682-warning-fix.patch
edac-is-bust-on-mips.patch
kdebugh-forward-declare-struct-struct-notifier_block.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
git-kvm-fixup.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
ide-bodge-things-around-to-make-arm-work.patch
mmc-build-fix.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
ip_auto_config-fix-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-scsi-rc-fixes.patch
git-scsi-target-fixup.patch
git-block-fix-headers_check.patch
git-block-whoops.patch
git-unionfs.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
git-watchdog.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-list_head-in-binfmt-handling-fix.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
ip2main-warning-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
tpm_tis-debug.patch
w1-build-fix.patch
