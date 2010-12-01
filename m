From: akpm@linux-foundation.org
Subject: + documentation-filesystems-vfstxt-fix-repeasepage-description.patch added to -mm tree
Date: Wed, 01 Dec 2010 14:43:18 -0800
Message-ID: <201012012243.oB1MhI2f016062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735Ab0LAWnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 17:43:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Trond.Myklebust@netapp.com, neilb@suse.de


The patch titled
     Documentation/filesystems/vfs.txt: fix ->repeasepage() description
has been added to the -mm tree.  Its filename is
     documentation-filesystems-vfstxt-fix-repeasepage-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/filesystems/vfs.txt: fix ->repeasepage() description
From: Andrew Morton <akpm@linux-foundation.org>

->releasepage() does not remove the page from the mapping.

Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~documentation-filesystems-vfstxt-fix-repeasepage-description Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~documentation-filesystems-vfstxt-fix-repeasepage-description
+++ a/Documentation/filesystems/vfs.txt
@@ -660,11 +660,10 @@ struct address_space_operations {
   releasepage: releasepage is called on PagePrivate pages to indicate
         that the page should be freed if possible.  ->releasepage
         should remove any private data from the page and clear the
-        PagePrivate flag.  It may also remove the page from the
-        address_space.  If this fails for some reason, it may indicate
-        failure with a 0 return value.
-	This is used in two distinct though related cases.  The first
-        is when the VM finds a clean page with no active users and
+        PagePrivate flag. If releasepage() fails for some reason, it must
+	indicate failure with a 0 return value.
+	releasepage() is used in two distinct though related cases.  The
+	first is when the VM finds a clean page with no active users and
         wants to make it a free page.  If ->releasepage succeeds, the
         page will be removed from the address_space and become free.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
documentation-filesystems-vfstxt-fix-repeasepage-description.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
headers_check-better-search-for-functions-in-headers-fix.patch
headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

