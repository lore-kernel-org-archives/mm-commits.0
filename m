From: akpm@linux-foundation.org
Subject: + lib-add-test-for-bitmap_parselist-fix.patch added to -mm tree
Date: Wed, 09 Aug 2017 13:29:04 -0700
Message-ID: <598b7090.+N4CT8/kiQOsqhCS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdHIU3F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2017 16:29:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mchehab@kernel.org, noamca@mellanox.com, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-add-test-for-bitmap_parselist-fix
has been added to the -mm tree.  Its filename is
     lib-add-test-for-bitmap_parselist-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-test-for-bitmap_parselist-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-test-for-bitmap_parselist-fix.patch

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
Subject: lib-add-test-for-bitmap_parselist-fix

fix printk warning

Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Noam Camus <noamca@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/test_bitmap.c~lib-add-test-for-bitmap_parselist-fix lib/test_bitmap.c
--- a/lib/test_bitmap.c~lib-add-test-for-bitmap_parselist-fix
+++ a/lib/test_bitmap.c
@@ -232,8 +232,9 @@ static void __init test_bitmap_parselist
 		}
 
 		if (ptest.flags & PARSE_TIME)
-			pr_err("test %d: input is '%s' OK, Time: %lu\n",
-					i, ptest.in, cycles);
+			pr_err("test %d: input is '%s' OK, Time: %llu\n",
+					i, ptest.in,
+					(unsigned long long)cycles);
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-make-tlb_flush_pending-global-fix.patch
mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
add-testcases-for-memset16-32-64-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

