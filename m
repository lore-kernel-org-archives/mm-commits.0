From: akpm@linux-foundation.org
Subject: + fortify-use-warn-instead-of-bug-for-now-fix.patch added to -mm
 tree
Date: Wed, 26 Jul 2017 14:27:18 -0700
Message-ID: <59790936.9iAwwcuZxnNbsnaC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60648 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdGZV1T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:27:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, danielmicay@gmail.com, jpoimboe@redhat.com, keescook@chromium.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fortify-use-warn-instead-of-bug-for-now-fix
has been added to the -mm tree.  Its filename is
     fortify-use-warn-instead-of-bug-for-now-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fortify-use-warn-instead-of-bug-for-now-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fortify-use-warn-instead-of-bug-for-now-fix.patch

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
Subject: fortify-use-warn-instead-of-bug-for-now-fix

remove fortify_overflow from tools/objtool/check.c:global_noreturns, per Josh

Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/objtool/check.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN tools/objtool/check.c~fortify-use-warn-instead-of-bug-for-now-fix tools/objtool/check.c
--- a/tools/objtool/check.c~fortify-use-warn-instead-of-bug-for-now-fix
+++ a/tools/objtool/check.c
@@ -156,7 +156,6 @@ static int __dead_end_function(struct ob
 		"kvm_spurious_fault",
 		"__reiserfs_panic",
 		"lbug_with_loc",
-		"fortify_overflow",
 	};
 
 	if (func->bind == STB_WEAK)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix-fix.patch
fortify-use-warn-instead-of-bug-for-now-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

