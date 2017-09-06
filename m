From: akpm@linux-foundation.org
Subject: + mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix.patch
 added to -mm tree
Date: Wed, 06 Sep 2017 14:57:41 -0700
Message-ID: <59b06f55.evPNtForNbDk+QaB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbdIFV5m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 17:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, dave.hansen@intel.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, mingo@elte.hu, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix.patch

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
Subject: mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix

fix sparc32, per Zi Yan

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/swapops.h~mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix include/linux/swapops.h
--- a/include/linux/swapops.h~mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix
+++ a/include/linux/swapops.h
@@ -221,7 +221,7 @@ static inline swp_entry_t pmd_to_swp_ent
 
 static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
 {
-	return __pmd(0);
+	return (pmd_t){};
 }
 
 static inline int is_pmd_migration_entry(pmd_t pmd)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
mmfork-introduce-madv_wipeonfork-fix.patch
mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch

