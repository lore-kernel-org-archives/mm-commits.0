From: akpm@linux-foundation.org
Subject: + mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
 added to -mm tree
Date: Fri, 05 Jan 2018 12:57:41 -0800
Message-ID: <5a4fe6c5.Lauz7vs9J9puOpD2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60286 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbeAEU5m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jan 2018 15:57:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory-failure: fix migration callback
has been added to the -mm tree.  Its filename is
     mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory-failure: fix migration callback

kbuild robot has noticed
>> mm/memory-failure.c:1587:33: error: passing argument 2 of 'migrate_pages' from incompatible pointer type [-Werror=incompatible-pointer-types]
     ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
                                    ^~~~~~~~
   In file included from mm/memory-failure.c:51:0:
   include/linux/migrate.h:68:12: note: expected 'struct page * (*)(struct page *, long unsigned int)' but argument is of type 'struct page * (*)(struct page *, long unsigned int,  int **)'
    extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
               ^~~~~~~~~~~~~
   mm/memory-failure.c: In function '__soft_offline_page':
   mm/memory-failure.c:1665:34: error: passing argument 2 of 'migrate_pages' from incompatible pointer type [-Werror=incompatible-pointer-types]
      ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
                                     ^~~~~~~~
   In file included from mm/memory-failure.c:51:0:
   include/linux/migrate.h:68:12: note: expected 'struct page * (*)(struct page *, long unsigned int)' but argument is of type 'struct page * (*)(struct page *, long unsigned int,  int **)'
    extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
               ^~~~~~~~~~~~~

Fix this by removing the excessive argument.

Link: http://lkml.kernel.org/r/20180105085259.GH2801@dhcp22.suse.cz
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-migrate-remove-reason-argument-from-new_page_t-fix-3 mm/memory-failure.c
--- a/mm/memory-failure.c~mm-migrate-remove-reason-argument-from-new_page_t-fix-3
+++ a/mm/memory-failure.c
@@ -1483,7 +1483,7 @@ int unpoison_memory(unsigned long pfn)
 }
 EXPORT_SYMBOL(unpoison_memory);
 
-static struct page *new_page(struct page *p, unsigned long private, int **x)
+static struct page *new_page(struct page *p, unsigned long private)
 {
 	int nid = page_to_nid(p);
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
mm-unclutter-thp-migration.patch
mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch
mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch
mm-hugetlb-further-simplify-hugetlb-allocation-api.patch
hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch
a.patch

