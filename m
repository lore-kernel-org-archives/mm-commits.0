From: akpm@linux-foundation.org
Subject: + net-netfilter-x_tablesc-remove-size-check.patch added to -mm
 tree
Date: Wed, 31 Jan 2018 12:04:27 -0800
Message-ID: <5a72214b.Q53pA1imK4zvfh2t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbeAaUE2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 15:04:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, akpm@linux-foundation.org, davem@davemloft.net, fw@strlen.de, mm-commits@vger.kernel.org


The patch titled
     Subject: net/netfilter/x_tables.c: remove size check
has been added to the -mm tree.  Its filename is
     net-netfilter-x_tablesc-remove-size-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-netfilter-x_tablesc-remove-size-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-netfilter-x_tablesc-remove-size-check.patch

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
Subject: net/netfilter/x_tables.c: remove size check

Back in 2002 vmalloc used to BUG on too large sizes.  We are much better
behaved these days and vmalloc simply returns NULL for those.  Remove the
check as it simply not needed and the comment is even misleading.

Link: http://lkml.kernel.org/r/20180131081916.GO21609@dhcp22.suse.cz
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/x_tables.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN net/netfilter/x_tables.c~net-netfilter-x_tablesc-remove-size-check net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~net-netfilter-x_tablesc-remove-size-check
+++ a/net/netfilter/x_tables.c
@@ -1004,10 +1004,6 @@ struct xt_table_info *xt_alloc_table_inf
 	if (sz < sizeof(*info))
 		return NULL;
 
-	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
-	if ((size >> PAGE_SHIFT) + 2 > totalram_pages)
-		return NULL;
-
 	/* __GFP_NORETRY is not fully supported by kvmalloc but it should
 	 * work reasonably well if sz is too large and bail out rather
 	 * than shoot all processes down before realizing there is nothing
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch
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
hugetlb-mbind-fall-back-to-default-policy-if-vma-is-null.patch
mm-memory_hotplug-fix-memmap-initialization.patch
net-netfilter-x_tablesc-remove-size-check.patch

