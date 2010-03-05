From: akpm@linux-foundation.org
Subject: [folded] mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:24:49 -0800
Message-ID: <201003052124.o25LOns3028485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740Ab0CEV0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:26:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhiramat@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix
has been removed from the -mm tree.  Its filename was
     mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch

This patch was dropped because it was folded into mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch

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
@@ -1956,7 +1956,7 @@ static int elf_core_dump(struct coredump
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	offset += elf_core_vma_data_size(gate_vma, mm_flags);
+	offset += elf_core_vma_data_size(gate_vma, cprm->mm_flags);
 	offset += elf_core_extra_data_size();
 	e_shoff = offset;
 
diff -puN fs/binfmt_elf_fdpic.c~mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix
+++ a/fs/binfmt_elf_fdpic.c
@@ -1768,7 +1768,7 @@ static int elf_fdpic_core_dump(struct co
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	offset += elf_core_vma_data_size(mm_flags);
+	offset += elf_core_vma_data_size(cprm->mm_flags);
 	offset += elf_core_extra_data_size();
 	e_shoff = offset;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference.patch
lib-more-scalable-list_sort.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch

