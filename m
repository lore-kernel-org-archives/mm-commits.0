From: akpm@linux-foundation.org
Subject: +
 userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch added
 to -mm tree
Date: Wed, 02 Aug 2017 15:27:48 -0700
Message-ID: <598251e4.jIxB5dCX3YNuWrvs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751727AbdHBW1t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 18:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.perevalov@samsung.com, aarcange@redhat.com, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix
has been added to the -mm tree.  Its filename is
     userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch

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
Subject: userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix

fix uffdio_zeropage(), per Mike Kravetz

Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -813,13 +813,14 @@ static int uffdio_zeropage(int ufd, unsi
 		if (uffdio_zeropage.zeropage != page_size) {
 			fprintf(stderr, "UFFDIO_ZEROPAGE unexpected %Ld\n",
 				uffdio_zeropage.zeropage), exit(1);
-		} else
+		} else {
 			if (test_uffdio_zeropage_eexist) {
 				test_uffdio_zeropage_eexist = false;
 				retry_uffdio_zeropage(ufd, &uffdio_zeropage,
 						      offset);
 			}
 			return 1;
+		}
 	} else {
 		fprintf(stderr,
 			"UFFDIO_ZEROPAGE succeeded %Ld\n",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
add-testcases-for-memset16-32-64-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

