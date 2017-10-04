From: akpm@linux-foundation.org
Subject: + dax-stop-using-vm_mixedmap-for-dax-fix.patch added to -mm tree
Date: Tue, 03 Oct 2017 17:07:48 -0700
Message-ID: <59d42654.vCfcZFws1tXNrubz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJDAHt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 20:07:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-stop-using-vm_mixedmap-for-dax-fix
has been added to the -mm tree.  Its filename is
     dax-stop-using-vm_mixedmap-for-dax-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-stop-using-vm_mixedmap-for-dax-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-stop-using-vm_mixedmap-for-dax-fix.patch

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
Subject: dax-stop-using-vm_mixedmap-for-dax-fix

fix typo

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~dax-stop-using-vm_mixedmap-for-dax-fix mm/migrate.c
--- a/mm/migrate.c~dax-stop-using-vm_mixedmap-for-dax-fix
+++ a/mm/migrate.c
@@ -2929,7 +2929,7 @@ int migrate_vma(const struct migrate_vma
 	start &= PAGE_MASK;
 	end &= PAGE_MASK;
 	if (!vma || is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_SPECIAL)
-			|| vma_is_dax(dma))
+			|| vma_is_dax(vma))
 		return -EINVAL;
 	if (start < vma->vm_start || start >= vma->vm_end)
 		return -EINVAL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-stop-using-vm_mixedmap-for-dax-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

