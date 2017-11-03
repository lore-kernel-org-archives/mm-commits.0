From: akpm@linux-foundation.org
Subject: + slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch added
 to -mm tree
Date: Fri, 03 Nov 2017 12:08:28 -0700
Message-ID: <59fcbeac.fED7hhXY+MT/o7QA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56404 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdKCTI3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 15:08:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-slub-slob-convert-slab_flags_t-to-32-bit-fix
has been added to the -mm tree.  Its filename is
     slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch

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
Subject: slab-slub-slob-convert-slab_flags_t-to-32-bit-fix

fix printk warning

mm/slub.c:3660: warning: format '%lx' expects type 'long unsigned int', but argument 7 has type 'slab_flags_t'

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slab-slub-slob-convert-slab_flags_t-to-32-bit-fix mm/slub.c
--- a/mm/slub.c~slab-slub-slob-convert-slab_flags_t-to-32-bit-fix
+++ a/mm/slub.c
@@ -3657,7 +3657,7 @@ error:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slab %s size=%lu realsize=%u order=%u offset=%u flags=%lx\n",
 		      s->name, (unsigned long)s->size, s->size,
-		      oo_order(s->oo), s->offset, flags);
+		      oo_order(s->oo), s->offset, (unsigned long)flags);
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

