From: akpm@linux-foundation.org
Subject: - reiser4-export-remove_from_page_cache-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:56:19 -0800
Message-ID: <200703060156.l261uJig008527@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46538 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965668AbXCFB7c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     unexport {,__}remove_from_page_cache
has been removed from the -mm tree.  Its filename was
     reiser4-export-remove_from_page_cache-fix.patch

This patch was dropped because it was folded into reiser4-export-remove_from_page_cache.patch

------------------------------------------------------
Subject: unexport {,__}remove_from_page_cache
From: Adrian Bunk <bunk@stusta.de>

This patch removes the no longer required export of
{,__}remove_from_page_cache introduced by
reiser4-export-remove_from_page_cache.patch.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/filemap.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/filemap.c~reiser4-export-remove_from_page_cache-fix mm/filemap.c
--- a/mm/filemap.c~reiser4-export-remove_from_page_cache-fix
+++ a/mm/filemap.c
@@ -121,7 +121,6 @@ void __remove_from_page_cache(struct pag
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 }
-EXPORT_SYMBOL(__remove_from_page_cache);
 
 void remove_from_page_cache(struct page *page)
 {
@@ -133,7 +132,6 @@ void remove_from_page_cache(struct page 
 	__remove_from_page_cache(page);
 	write_unlock_irq(&mapping->tree_lock);
 }
-EXPORT_SYMBOL(remove_from_page_cache);
 
 static int sleep_on_page(void *word, wait_queue_t *wait)
 {
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
