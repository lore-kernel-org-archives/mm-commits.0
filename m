From: akpm@linux-foundation.org
Subject: +
 genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
 added to -mm tree
Date: Thu, 09 Jul 2015 12:14:21 -0700
Message-ID: <559ec80d.NWFqASQbG3RIBdge%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbGITOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vladimir_zapolskiy@mentor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix
has been added to the -mm tree.  Its filename is
     genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch

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
Subject: genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix

gen_pool_get() cleanup

Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/genalloc.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix lib/genalloc.c
--- a/lib/genalloc.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix
+++ a/lib/genalloc.c
@@ -579,9 +579,9 @@ static void devm_gen_pool_release(struct
  */
 struct gen_pool *gen_pool_get(struct device *dev, const char *name)
 {
-	struct gen_pool **p = devres_find(dev, devm_gen_pool_release,
-					  NULL, NULL);
+	struct gen_pool **p;
 
+	p = devres_find(dev, devm_gen_pool_release, NULL, NULL);
 	if (!p)
 		return NULL;
 	return *p;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
openrisc-fix-config_uid16-setting.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

