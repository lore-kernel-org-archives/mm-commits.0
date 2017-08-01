From: akpm@linux-foundation.org
Subject: + treewide-remove-gfp_temporary-allocation-flag-fix.patch added
 to -mm tree
Date: Tue, 01 Aug 2017 15:33:54 -0700
Message-ID: <598101d2.u9qvoDm2oVRP/TQq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40708 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbdHAWdz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2017 18:33:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mhocko@suse.com, neilb@suse.de, sfr@canb.auug.org.au, tytso@mit.edu, vbabka@suse.cz, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-remove-gfp_temporary-allocation-flag-fix
has been added to the -mm tree.  Its filename is
     treewide-remove-gfp_temporary-allocation-flag-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-remove-gfp_temporary-allocation-flag-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-remove-gfp_temporary-allocation-flag-fix.patch

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
Subject: treewide-remove-gfp_temporary-allocation-flag-fix

fix typo

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/rtas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/rtas.c~treewide-remove-gfp_temporary-allocation-flag-fix arch/powerpc/kernel/rtas.c
--- a/arch/powerpc/kernel/rtas.c~treewide-remove-gfp_temporary-allocation-flag-fix
+++ a/arch/powerpc/kernel/rtas.c
@@ -914,7 +914,7 @@ int rtas_online_cpus_mask(cpumask_var_t
 	if (ret) {
 		cpumask_var_t tmp_mask;
 
-		if (!alloc_cpumask_var(&tmp_mask, GFP_KENREL))
+		if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL))
 			return ret;
 
 		/* Use tmp_mask to preserve cpus mask from first failure */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix-fix.patch
fortify-use-warn-instead-of-bug-for-now-fix.patch
swap-fix-oops-during-block-io-poll-in-swapin-path-fix.patch
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
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

