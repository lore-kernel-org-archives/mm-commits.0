From: akpm@linux-foundation.org
Subject: + treewide-decouple-cacheflushh-and-set_memoryh-fix.patch added
 to -mm tree
Date: Mon, 06 Mar 2017 15:11:49 -0800
Message-ID: <58bdecb5.hrRxGDKMG5yVl3t+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60632 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbdCFXMZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 18:12:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-decouple-cacheflushh-and-set_memoryh-fix
has been added to the -mm tree.  Its filename is
     treewide-decouple-cacheflushh-and-set_memoryh-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-decouple-cacheflushh-and-set_memoryh-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-decouple-cacheflushh-and-set_memoryh-fix.patch

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
Subject: treewide-decouple-cacheflushh-and-set_memoryh-fix

fix i386 allnoconfig

arch/x86/mm/init_32.c: In function 'set_kernel_text_rw':
arch/x86/mm/init_32.c:880: error: implicit declaration of function 'set_pages_rw'
arch/x86/mm/init_32.c: In function 'set_kernel_text_ro':
arch/x86/mm/init_32.c:894: error: implicit declaration of function 'set_pages_ro'
arch/x86/mm/init_32.c: In function 'mark_nxdata_nx':
arch/x86/mm/init_32.c:911: error: implicit declaration of function 'set_pages_nx'
Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_32.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh-fix arch/arm/include/asm/cacheflush.h
diff -puN arch/arm64/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh-fix arch/arm64/include/asm/cacheflush.h
diff -puN arch/s390/include/asm/Kbuild~treewide-decouple-cacheflushh-and-set_memoryh-fix arch/s390/include/asm/Kbuild
diff -puN /dev/null /dev/null
diff -puN arch/x86/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh-fix arch/x86/include/asm/cacheflush.h
diff -puN arch/x86/mm/init_32.c~treewide-decouple-cacheflushh-and-set_memoryh-fix arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~treewide-decouple-cacheflushh-and-set_memoryh-fix
+++ a/arch/x86/mm/init_32.c
@@ -46,6 +46,7 @@
 #include <asm/olpc_ofw.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
+#include <asm/set_memory.h>
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 #include <asm/cacheflush.h>
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
linux-next-rejects.patch
treewide-move-set_memory_-functions-away-from-cacheflushh-fix.patch
arm64-use-set_memoryh-header-fix.patch
treewide-decouple-cacheflushh-and-set_memoryh-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
a.patch

