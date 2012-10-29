From: akpm@linux-foundation.org
Subject: [wrecked] random-make-it-possible-to-enable-debugging-without-rebuild-fix.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:49:06 -0700
Message-ID: <20121029194906.B0FBB100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35343 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2J2TtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:49:08 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so375340qae.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:49:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, jkosina@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: random-make-it-possible-to-enable-debugging-without-rebuild-fix
has been removed from the -mm tree.  Its filename was
     random-make-it-possible-to-enable-debugging-without-rebuild-fix.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: random-make-it-possible-to-enable-debugging-without-rebuild-fix

fix resulting printk warnings

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Wu Fengguang <fengguang.wu@intel.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/random.c~random-make-it-possible-to-enable-debugging-without-rebuild-fix drivers/char/random.c
--- a/drivers/char/random.c~random-make-it-possible-to-enable-debugging-without-rebuild-fix
+++ a/drivers/char/random.c
@@ -825,7 +825,7 @@ static void xfer_secondary_pool(struct e
 		bytes = min_t(int, bytes, sizeof(tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
-			  "(%d of %d requested)\n",
+			  "(%zu of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
@@ -856,7 +856,7 @@ static size_t account(struct entropy_sto
 	spin_lock_irqsave(&r->lock, flags);
 
 	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
-	DEBUG_ENT("trying to extract %d bits from %s\n",
+	DEBUG_ENT("trying to extract %zu bits from %s\n",
 		  nbytes * 8, r->name);
 
 	/* Can we pull enough? */
@@ -878,7 +878,7 @@ static size_t account(struct entropy_sto
 		}
 	}
 
-	DEBUG_ENT("debiting %d entropy credits from %s%s\n",
+	DEBUG_ENT("debiting %zu entropy credits from %s%s\n",
 		  nbytes * 8, r->name, r->limit ? "" : " (unlimited)");
 
 	spin_unlock_irqrestore(&r->lock, flags);
@@ -1138,11 +1138,11 @@ random_read(struct file *file, char __us
 		if (n > SEC_XFER_SIZE)
 			n = SEC_XFER_SIZE;
 
-		DEBUG_ENT("reading %d bits\n", n*8);
+		DEBUG_ENT("reading %zd bits\n", n*8);
 
 		n = extract_entropy_user(&blocking_pool, buf, n);
 
-		DEBUG_ENT("read got %d bits (%d still needed)\n",
+		DEBUG_ENT("read got %zd bits (%zd still needed)\n",
 			  n*8, (nbytes-n)*8);
 
 		if (n == 0) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
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
selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

