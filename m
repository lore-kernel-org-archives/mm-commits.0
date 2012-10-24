From: akpm@linux-foundation.org
Subject: [to-be-updated] random-fix-debug-format-strings-fix.patch removed from -mm tree
Date: Wed, 24 Oct 2012 12:23:48 -0700
Message-ID: <20121024192348.95F8E1E004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:65272 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab2JXTXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 15:23:50 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so98222vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 12:23:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jkosina@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: random-fix-debug-format-strings-fix
has been removed from the -mm tree.  Its filename was
     random-fix-debug-format-strings-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: random-fix-debug-format-strings-fix

s/%zd/%zu/ for unsigned `size_t'

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/random.c~random-fix-debug-format-strings-fix drivers/char/random.c
--- a/drivers/char/random.c~random-fix-debug-format-strings-fix
+++ a/drivers/char/random.c
@@ -825,7 +825,7 @@ static void xfer_secondary_pool(struct e
 		bytes = min_t(int, bytes, sizeof(tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
-			  "(%zd of %d requested)\n",
+			  "(%zu of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
@@ -856,7 +856,7 @@ static size_t account(struct entropy_sto
 	spin_lock_irqsave(&r->lock, flags);
 
 	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
-	DEBUG_ENT("trying to extract %zd bits from %s\n",
+	DEBUG_ENT("trying to extract %zu bits from %s\n",
 		  nbytes * 8, r->name);
 
 	/* Can we pull enough? */
@@ -878,7 +878,7 @@ static size_t account(struct entropy_sto
 		}
 	}
 
-	DEBUG_ENT("debiting %zd entropy credits from %s%s\n",
+	DEBUG_ENT("debiting %zu entropy credits from %s%s\n",
 		  nbytes * 8, r->name, r->limit ? "" : " (unlimited)");
 
 	spin_unlock_irqrestore(&r->lock, flags);
@@ -1138,11 +1138,11 @@ random_read(struct file *file, char __us
 		if (n > SEC_XFER_SIZE)
 			n = SEC_XFER_SIZE;
 
-		DEBUG_ENT("reading %zd bits\n", n*8);
+		DEBUG_ENT("reading %zu bits\n", n*8);
 
 		n = extract_entropy_user(&blocking_pool, buf, n);
 
-		DEBUG_ENT("read got %zd bits (%zd still needed)\n",
+		DEBUG_ENT("read got %zu bits (%zu still needed)\n",
 			  n*8, (nbytes-n)*8);
 
 		if (n == 0) {
@@ -1210,7 +1210,7 @@ write_pool(struct entropy_store *r, cons
 	const char __user *p = buffer;
 
 	while (count > 0) {
-		bytes = min(count, sizeof(buf));
+		bytes = min_t(size_t, count, sizeof(buf));
 		if (copy_from_user(&buf, p, bytes))
 			return -EFAULT;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch
revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

