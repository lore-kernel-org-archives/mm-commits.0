From: akpm@linux-foundation.org
Subject: + dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch added to -mm tree
Date: Mon, 05 Nov 2012 12:05:44 -0800
Message-ID: <20121105200545.111D61000AE@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:45852 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUFp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:05:45 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so719185yen.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:05:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, matthieu.castet@parrot.com


The patch titled
     Subject: dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix
has been added to the -mm tree.  Its filename is
     dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch

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
Subject: dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix

tidy code, fix comment, use sizeof(page->offset), use pr_err()

Cc: Matthieu Castet <matthieu.castet@parrot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/dmapool.c~dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix mm/dmapool.c
--- a/mm/dmapool.c~dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix
+++ a/mm/dmapool.c
@@ -350,23 +350,24 @@ void *dma_pool_alloc(struct dma_pool *po
 		int i;
 		u8 *data = retval;
 		/* page->offset is stored in first 4 bytes */
-		for (i = sizeof(int); i < pool->size; i++) {
-			if (data[i] != POOL_POISON_FREED) {
-				if (pool->dev)
-					dev_err(pool->dev,
-							"dma_pool_alloc %s, %p (corruped)\n",
-							pool->name, retval);
-				else
-					printk(KERN_ERR
-							"dma_pool_alloc %s, %p (corruped)\n",
-							pool->name, retval);
-
-				/* we dump the first 4 bytes even if there are not
-				   POOL_POISON_FREED */
-				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
-						data, pool->size, 1);
-				break;
-			}
+		for (i = sizeof(page->offset); i < pool->size; i++) {
+			if (data[i] == POOL_POISON_FREED)
+				continue;
+			if (pool->dev)
+				dev_err(pool->dev,
+					"dma_pool_alloc %s, %p (corruped)\n",
+					pool->name, retval);
+			else
+				pr_err("dma_pool_alloc %s, %p (corruped)\n",
+					pool->name, retval);
+
+			/*
+			 * Dump the first 4 bytes even if they are not
+			 * POOL_POISON_FREED
+			*/
+			print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
+					data, pool->size, 1);
+			break;
 		}
 	}
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

