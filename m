From: akpm@linux-foundation.org
Subject: + memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch added to -mm tree
Date: Thu, 13 Sep 2007 17:56:02 -0700
Message-ID: <200709140056.l8E0u2Kf014267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152AbXINA4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 20:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, balbir@linux.vnet.ibm.com


The patch titled
     mm/memcontrol.c: clenups
has been added to the -mm tree.  Its filename is
     memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/memcontrol.c: clenups
From: Adrian Bunk <bunk@kernel.org>

- lock_page_container()
- unlock_page_container()
- __mem_container_move_lists()

Additionally, there was no reason for the "mem_control_type" object.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup
+++ a/mm/memcontrol.c
@@ -91,7 +91,7 @@ enum {
 	MEM_CONTAINER_TYPE_CACHED,
 	MEM_CONTAINER_TYPE_ALL,
 	MEM_CONTAINER_TYPE_MAX,
-} mem_control_type;
+};
 
 static struct mem_container init_mem_container;
 
@@ -151,18 +151,18 @@ struct page_container *page_get_page_con
 		(page->page_container & ~PAGE_CONTAINER_LOCK);
 }
 
-void __always_inline lock_page_container(struct page *page)
+static void __always_inline lock_page_container(struct page *page)
 {
 	bit_spin_lock(PAGE_CONTAINER_LOCK_BIT, &page->page_container);
 	VM_BUG_ON(!page_container_locked(page));
 }
 
-void __always_inline unlock_page_container(struct page *page)
+static void __always_inline unlock_page_container(struct page *page)
 {
 	bit_spin_unlock(PAGE_CONTAINER_LOCK_BIT, &page->page_container);
 }
 
-void __mem_container_move_lists(struct page_container *pc, bool active)
+static void __mem_container_move_lists(struct page_container *pc, bool active)
 {
 	if (active)
 		list_move(&pc->lru, &pc->mem_container->active_list);
_

Patches currently in -mm which might be from bunk@kernel.org are

fix-serial_core_console-driver-dependencies.patch
git-alsa.patch
arm-extern-inline-static-inline.patch
omap1-leds-innovatorc-remove-dead-code.patch
ppc-remove-apus-support.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
