From: akpm@linux-foundation.org
Subject: - uml-smp-locking-commentary.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:09 -0800
Message-ID: <200802052237.m15Mbom2012897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762422AbYBEWlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: SMP locking commentary
has been removed from the -mm tree.  Its filename was
     uml-smp-locking-commentary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
