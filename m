From: akpm@linux-foundation.org
Subject: + x86-atomic-move-__atomic_add_unless-out-of-line-fix.patch added to -mm tree
Date: Thu, 16 Mar 2017 11:46:22 -0700
Message-ID: <58cadd7e.Kg0Sx+i93OEqh9sw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752318AbdCPSqY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 14:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, dvyukov@google.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-atomic-move-__atomic_add_unless-out-of-line-fix
has been added to the -mm tree.  Its filename is
     x86-atomic-move-__atomic_add_unless-out-of-line-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-atomic-move-__atomic_add_unless-out-of-line-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-atomic-move-__atomic_add_unless-out-of-line-fix.patch

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
Subject: x86-atomic-move-__atomic_add_unless-out-of-line-fix

fix rejects fix

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/atomic.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/include/asm/atomic.h~x86-atomic-move-__atomic_add_unless-out-of-line-fix arch/x86/include/asm/atomic.h
--- a/arch/x86/include/asm/atomic.h~x86-atomic-move-__atomic_add_unless-out-of-line-fix
+++ a/arch/x86/include/asm/atomic.h
@@ -235,6 +235,8 @@ ATOMIC_OPS(xor, ^)
 #undef ATOMIC_FETCH_OP
 #undef ATOMIC_OP
 
+int __arch_atomic_add_unless(atomic_t *v, int a, int u);
+
 /**
  * arch_atomic_inc_short - increment of a short integer
  * @v: pointer to type int
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-selftests-i915_selftestc-fix-build-with-gcc-444.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
x86-atomic-move-__atomic_add_unless-out-of-line-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

