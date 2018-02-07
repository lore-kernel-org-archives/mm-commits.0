From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 14:50:16 -0800
Message-ID: <5a7b82a8.sRYLgB0UW81T/twq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbeBGWuR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 17:50:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory-failure: fix migration callback
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch

This patch was dropped because it was folded into mm-migrate-remove-reason-argument-from-new_page_t.patch

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
@@ -1473,7 +1473,7 @@ int unpoison_memory(unsigned long pfn)
 }
 EXPORT_SYMBOL(unpoison_memory);
 
-static struct page *new_page(struct page *p, unsigned long private, int **x)
+static struct page *new_page(struct page *p, unsigned long private)
 {
 	int nid = page_to_nid(p);
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-unclutter-thp-migration.patch
net-netfilter-x_tablesc-remove-size-check.patch

