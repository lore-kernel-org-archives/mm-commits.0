From: akpm@linux-foundation.org
Subject: - enable-lguest-drivers-in-kconfig.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:07:43 -0700
Message-ID: <200708081907.l78J7hU9025789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762368AbXHHTIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Enable lguest drivers in Kconfig
has been removed from the -mm tree.  Its filename was
     enable-lguest-drivers-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Enable lguest drivers in Kconfig
From: Rusty Russell <rusty@rustcorp.com.au>

Lguest drivers need to default to "Y" otherwise they're never selected for
new builds.  (We don't bother prompting, because they're less than 4k
combined, and implied by selecting lguest support).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/Kconfig |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/lguest/Kconfig~enable-lguest-drivers-in-kconfig drivers/lguest/Kconfig
--- a/drivers/lguest/Kconfig~enable-lguest-drivers-in-kconfig
+++ a/drivers/lguest/Kconfig
@@ -21,8 +21,10 @@ config LGUEST_GUEST
 
 config LGUEST_NET
 	tristate
+	default y
 	depends on LGUEST_GUEST && NET
 
 config LGUEST_BLOCK
 	tristate
+	default y
 	depends on LGUEST_GUEST && BLOCK
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
