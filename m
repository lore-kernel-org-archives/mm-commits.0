From: akpm@linux-foundation.org
Subject: +
 mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration-fix.patch added to -mm tree
Date: Thu, 16 Mar 2017 15:58:32 -0700
Message-ID: <58cb1898.BJUTFLEi9gs0vSsp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752072AbdCPW6e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 18:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jglisse@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration-fix
has been added to the -mm tree.  Its filename is
     mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration-fix.patch

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
Subject: mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration-fix

sync with mm-remove-swap_.patch

Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration-fix mm/rmap.c
--- a/mm/rmap.c~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration-fix
+++ a/mm/rmap.c
@@ -1311,7 +1311,7 @@ static bool try_to_unmap_one(struct page
 
 	if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION) &&
 	    is_zone_device_page(page) && !dev_page_allow_migrate(page))
-		return SWAP_AGAIN;
+		return true;
 
 	if (flags & TTU_SPLIT_HUGE_PMD) {
 		split_huge_pmd_address(vma, address,
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
mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration-fix.patch
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

