From: akpm@linux-foundation.org
Subject: + uml-smp-locking-commentary.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:23:12 -0800
Message-ID: <200801280524.m0S5O66N013741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbYA1FYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:24:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: SMP locking commentary
has been added to the -mm tree.  Its filename is
     uml-smp-locking-commentary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: SMP locking commentary
From: Jeff Dike <jdike@addtoit.com>

Add some more commentary about various pieces of global data not needing
locking.

Also got rid of unmap_physmem since that is no longer used.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |    7 ++++++-
 arch/um/include/mem_user.h |    1 -
 arch/um/kernel/mem.c       |   13 ++++++++-----
 arch/um/kernel/physmem.c   |    6 +++---
 4 files changed, 17 insertions(+), 10 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-smp-locking-commentary arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-smp-locking-commentary
+++ a/arch/um/drivers/net_kern.c
@@ -368,7 +368,6 @@ static struct platform_driver uml_net_dr
 		.name  = DRIVER_NAME,
 	},
 };
-static int driver_registered;
 
 static void net_device_release(struct device *dev)
 {
@@ -383,6 +382,12 @@ static void net_device_release(struct de
 	free_netdev(netdev);
 }
 
+/*
+ * Ensures that platform_driver_register is called only once by
+ * eth_configure.  Will be set in an initcall.
+ */
+static int driver_registered;
+
 static void eth_configure(int n, void *init, char *mac,
 			  struct transport *transport)
 {
diff -puN arch/um/include/mem_user.h~uml-smp-locking-commentary arch/um/include/mem_user.h
--- a/arch/um/include/mem_user.h~uml-smp-locking-commentary
+++ a/arch/um/include/mem_user.h
@@ -56,7 +56,6 @@ extern void setup_physmem(unsigned long 
 			  unsigned long len, unsigned long long highmem);
 extern void add_iomem(char *name, int fd, unsigned long size);
 extern unsigned long phys_offset(unsigned long phys);
-extern void unmap_physmem(void);
 extern void map_memory(unsigned long virt, unsigned long phys,
 		       unsigned long len, int r, int w, int x);
 
diff -puN arch/um/kernel/mem.c~uml-smp-locking-commentary arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-smp-locking-commentary
+++ a/arch/um/kernel/mem.c
@@ -22,17 +22,20 @@
 unsigned long *empty_zero_page = NULL;
 /* allocated in paging_init and unchanged thereafter */
 unsigned long *empty_bad_page = NULL;
+
+/*
+ * Initialized during boot, and readonly for initializing page tables
+ * afterwards
+ */
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
+
+/* Initialized at boot time, and readonly after that */
 unsigned long long highmem;
 int kmalloc_ok = 0;
 
+/* Used during early boot */
 static unsigned long brk_end;
 
-void unmap_physmem(void)
-{
-	os_unmap_memory((void *) brk_end, uml_reserved - brk_end);
-}
-
 static void map_cb(void *unused)
 {
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
diff -puN arch/um/kernel/physmem.c~uml-smp-locking-commentary arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-smp-locking-commentary
+++ a/arch/um/kernel/physmem.c
@@ -164,10 +164,10 @@ __uml_setup("iomem=", parse_iomem,
  * setup_iomem, both of which run during early boot.  Afterwards, it's
  * unchanged.
  */
-struct iomem_region *iomem_regions = NULL;
+struct iomem_region *iomem_regions;
 
-/* Initialized in parse_iomem */
-int iomem_size = 0;
+/* Initialized in parse_iomem and unchanged thereafter */
+int iomem_size;
 
 unsigned long find_iomem(char *driver, unsigned long *len_out)
 {
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-header-untangling-fix.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-signal-handling-tidying.patch
uml-remove-init_irq_signals.patch
uml-smp-locking-commentary.patch
uml-implement-o_append.patch
uml-remove-fakehd.patch
uml-debug_shirq-fixes.patch
uml-add-back-config_hz.patch
uml-style-fixes-in-arch-um-sys-x86_64.patch
uml-add-newlines-to-printks.patch
uml-move-register-initialization.patch
uml-remove-unused-fields-from-mm_context.patch
uml-remove-map_cb.patch
uml-use-of-a-public-mac-is-a-warning-not-an-error.patch
uml-defconfig-tweaks.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
