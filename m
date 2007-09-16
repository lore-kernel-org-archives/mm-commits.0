From: akpm@linux-foundation.org
Subject: - lguest-fix-guest-crash-when-config_x86_use_3dnow=y.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:38 -0700
Message-ID: <200709160926.l8G9QcdP009196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbXIPJi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, michael.rasenberger@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     lguest: fix guest crash when CONFIG_X86_USE_3DNOW=y
has been removed from the -mm tree.  Its filename was
     lguest-fix-guest-crash-when-config_x86_use_3dnow=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: fix guest crash when CONFIG_X86_USE_3DNOW=y
From: Rusty Russell <rusty@rustcorp.com.au>

One of the very first things lguest_init() does is a memcpy.  On
Athlon/Duron/K7 or CyrixIII/VIA-C3 or Geode GX/LX, this tries to use MMX.

memcpy -> _mmx_memcpy -> kernel_fpu_begin -> clts -> paravirt_ops.clts

But we haven't set paravirt_ops.clts yet, so we do the native version
and crash.  The simplest solution is to use __memcpy.

Thanks to Michael Rasenberger for the bug report.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael Rasenberger <michael.rasenberger@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-fix-guest-crash-when-config_x86_use_3dnow=y drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-fix-guest-crash-when-config_x86_use_3dnow=y
+++ a/drivers/lguest/lguest.c
@@ -964,11 +964,12 @@ __init void lguest_init(void *boot)
 {
 	/* Copy boot parameters first: the Launcher put the physical location
 	 * in %esi, and head.S converted that to a virtual address and handed
-	 * it to us. */
-	memcpy(&boot_params, boot, PARAM_SIZE);
+	 * it to us.  We use "__memcpy" because "memcpy" sometimes tries to do
+	 * tricky things to go faster, and we're not ready for that. */
+	__memcpy(&boot_params, boot, PARAM_SIZE);
 	/* The boot parameters also tell us where the command-line is: save
 	 * that, too. */
-	memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
+	__memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
 	       COMMAND_LINE_SIZE);
 
 	/* We're under lguest, paravirt is enabled, and we're running at
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
enforce-noreplace-smp-in-alternative_instructions.patch
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
modpost-detect-unterminated-device-id-lists.patch
modpost-detect-unterminated-device-id-lists-fix.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
