From: akpm@linux-foundation.org
Subject: +
 support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
 added to -mm tree
Date: Fri, 03 Nov 2017 10:48:02 -0700
Message-ID: <59fcabd2.Ka+Ax/S4dZ2zhVKN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59160 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756087AbdKCRsD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 13:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix
has been added to the -mm tree.  Its filename is
     support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch

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
Subject: support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix

clear BUGFLAG_DONE in clear_once_table(), per mpe

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bug.c~support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix lib/bug.c
--- a/lib/bug.c~support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix
+++ a/lib/bug.c
@@ -202,7 +202,7 @@ static void clear_once_table(struct bug_
 	struct bug_entry *bug;
 
 	for (bug = start; bug < end; bug++)
-		bug->flags &= ~BUGFLAG_ONCE;
+		bug->flags &= ~BUGFLAG_DONE;
 }
 
 void generic_bug_clear_once(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
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

