From: akpm@linux-foundation.org
Subject: + mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch added to -mm tree
Date: Fri, 08 Jan 2010 18:01:17 -0800
Message-ID: <201001090201.o0921HnC027389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab0AICBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 21:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mhiramat@redhat.com


The patch titled
     mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix
has been added to the -mm tree.  Its filename is
     mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch

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
Subject: mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix merge

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |    2 +-
 fs/binfmt_elf_fdpic.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix
+++ a/fs/binfmt_elf.c
@@ -1979,7 +1979,7 @@ static int elf_core_dump(struct coredump
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	offset += elf_core_vma_data_size(gate_vma, mm_flags);
+	offset += elf_core_vma_data_size(gate_vma, cprm->mm_flags);
 	offset += elf_core_extra_data_size();
 	e_shoff = offset;
 
diff -puN fs/binfmt_elf_fdpic.c~mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix
+++ a/fs/binfmt_elf_fdpic.c
@@ -1765,7 +1765,7 @@ static int elf_fdpic_core_dump(struct co
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	offset += elf_core_vma_data_size(mm_flags);
+	offset += elf_core_vma_data_size(cprm->mm_flags);
 	offset += elf_core_extra_data_size();
 	e_shoff = offset;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
proc-revert-procfs-provide-stack-information-for-threads.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

