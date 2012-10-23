From: akpm@linux-foundation.org
Subject: + random-fix-debug-format-strings-fix.patch added to -mm tree
Date: Tue, 23 Oct 2012 14:54:11 -0700
Message-ID: <20121023215412.7A86D5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:61218 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2JWVyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 17:54:15 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so257574bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 14:54:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jkosina@suse.cz, tytso@mit.edu


The patch titled
     Subject: random-fix-debug-format-strings-fix
has been added to the -mm tree.  Its filename is
     random-fix-debug-format-strings-fix.patch

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

revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
random-fix-debug-format-strings-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

