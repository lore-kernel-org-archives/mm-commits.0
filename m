From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 01 Aug 2014 11:54:47 -0700
Message-ID: <53dbe277.YnbpRNkHUNrbh4Dn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:37369 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaHASys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Aug 2014 14:54:48 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so1289289iec.3
        for <mm-commits@vger.kernel.org>; Fri, 01 Aug 2014 11:54:47 -0700 (PDT)
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

 drivers/pnp/pnpacpi/core.c |   37 -----------------------------------
 1 file changed, 37 deletions(-)

diff -puN drivers/pnp/pnpacpi/core.c~linux-next-git-rejects drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~linux-next-git-rejects
+++ a/drivers/pnp/pnpacpi/core.c
@@ -310,43 +310,6 @@ static acpi_status __init pnpacpi_add_de
 	return AE_OK;
 }
 
-<<<<<<< HEAD
-static int __init acpi_pnp_match(struct device *dev, void *_pnp)
-{
-	struct acpi_device *acpi = to_acpi_device(dev);
-	struct pnp_dev *pnp = _pnp;
-
-	/* true means it matched */
-	return pnp->data == acpi;
-}
-
-static struct acpi_device * __init acpi_pnp_find_companion(struct device *dev)
-{
-	dev = bus_find_device(&acpi_bus_type, NULL, to_pnp_dev(dev),
-			      acpi_pnp_match);
-	if (!dev)
-		return NULL;
-
-	put_device(dev);
-	return to_acpi_device(dev);
-}
-
-/* complete initialization of a PNPACPI device includes having
- * pnpdev->dev.archdata.acpi_handle point to its ACPI sibling.
- */
-static bool acpi_pnp_bus_match(struct device *dev)
-{
-	return dev->bus == &pnp_bus_type;
-}
-
-static struct acpi_bus_type __initdata acpi_pnp_bus = {
-	.name	     = "PNP",
-	.match	     = acpi_pnp_bus_match,
-	.find_companion = acpi_pnp_find_companion,
-};
-
-=======
->>>>>>> linux-next/akpm-base
 int pnpacpi_disabled __initdata;
 static int __init pnpacpi_init(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

