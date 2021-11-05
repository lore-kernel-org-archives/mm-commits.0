Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06608C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEE6E61216
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhKESvn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbhKESvf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:51:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F5F06120D;
        Fri,  5 Nov 2021 18:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636138135;
        bh=RZPbfbxn6zFoLfW3VGx/cihZgGswONJa5DVmspJHeZs=;
        h=Date:From:To:Subject:From;
        b=wpHfwLulovvP5I6yp5JfJHAwr9vG08Rj9yDshGs+L9WkWSnSxxkn5RfRLyjIMILO8
         UelMKlPxrNuNxRP7PiyvFhJBQZnN6cLLKZww49l4vDxMmFlsRwMKwViA9wWPAZJusy
         ucCUkPn6pbfmSXo/2JoTapTJzYkAk7uIJ1JMMONc=
Date:   Fri, 05 Nov 2021 11:48:54 -0700
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au, sj@kernel.org
Subject:  [folded-merged]
 mm-damon-vaddr-separate-commonly-usable-functions-fix.patch removed from
 -mm tree
Message-ID: <20211105184854.5eZNWKt2d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: include 'highmem.h' to fix a build failure
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-separate-commonly-usable-functions-fix.patch

This patch was dropped because it was folded into mm-damon-vaddr-separate-commonly-usable-functions.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: include 'highmem.h' to fix a build failure

Commit 0ff28922686c ("mm/damon/vaddr: separate commonly usable functions")
in -mm tree[1] moves include of 'highmem.h' from 'vaddr.c' to
'prmtv-common.c', though the code for the header is still in 'vaddr.c'. 
As a result, build with 'CONFIG_HIGHPTE' fails as below:

    In file included from ../include/linux/mm.h:33:0,
                      from ../include/linux/kallsyms.h:13,
                      from ../include/linux/bpf.h:20,
                      from ../include/linux/bpf-cgroup.h:5,
                      from ../include/linux/cgroup-defs.h:22,
                      from ../include/linux/cgroup.h:28,
                      from ../include/linux/hugetlb.h:9,
                      from ../mm/damon/vaddr.c:11:
    ../mm/damon/vaddr.c: In function `damon_mkold_pmd_entry':
    ../include/linux/pgtable.h:97:12: error: implicit declaration of function `kmap_atomic'; did you mean `mcopy_atomic'? [-Werror=implicit-function-declaration]
       ((pte_t *)kmap_atomic(pmd_page(*(dir))) +  \
                 ^
    ../include/linux/mm.h:2376:17: note: in expansion of macro `pte_offset_map'
       pte_t *__pte = pte_offset_map(pmd, address); \
                      ^~~~~~~~~~~~~~
    ../mm/damon/vaddr.c:387:8: note: in expansion of macro `pte_offset_map_lock'
       pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
             ^~~~~~~~~~~~~~~~~~~
    ../include/linux/pgtable.h:99:24: error: implicit declaration of function `kunmap_atomic'; did you mean `in_atomic'? [-Werror=implicit-function-declaration]
      #define pte_unmap(pte) kunmap_atomic((pte))
                             ^
    ../include/linux/mm.h:2384:2: note: in expansion of macro `pte_unmap'
       pte_unmap(pte);     \
       ^~~~~~~~~
    ../mm/damon/vaddr.c:392:2: note: in expansion of macro `pte_unmap_unlock'
       pte_unmap_unlock(pte, ptl);
       ^~~~~~~~~~~~~~~~

This commit fixes the issue by moving the include back to 'vaddr.c'.

[1] https://github.com/hnaz/linux-mm/commit/0ff28922686c

Link: https://lkml.kernel.org/r/20211014110848.5204-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/prmtv-common.c |    1 -
 mm/damon/vaddr.c        |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/prmtv-common.c~mm-damon-vaddr-separate-commonly-usable-functions-fix
+++ a/mm/damon/prmtv-common.c
@@ -5,7 +5,6 @@
  * Author: SeongJae Park <sj@kernel.org>
  */
 
-#include <linux/highmem.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
 #include <linux/pagemap.h>
--- a/mm/damon/vaddr.c~mm-damon-vaddr-separate-commonly-usable-functions-fix
+++ a/mm/damon/vaddr.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt) "damon-va: " fmt
 
 #include <asm-generic/mman-common.h>
+#include <linux/highmem.h>
 #include <linux/hugetlb.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch
mm-damon-paddr-support-the-pageout-scheme.patch
mm-damon-paddr-support-the-pageout-scheme-fix.patch
mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
mm-damon-schemes-skip-already-charged-targets-and-regions.patch
mm-damon-schemes-implement-time-quota.patch
mm-damon-dbgfs-support-quotas-of-schemes.patch
mm-damon-selftests-support-schemes-quotas.patch
mm-damon-schemes-prioritize-regions-within-the-quotas.patch
mm-damon-vaddrpaddr-support-pageout-prioritization.patch
mm-damon-dbgfs-support-prioritization-weights.patch
tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
mm-damon-dbgfs-support-watermarks.patch
selftests-damon-support-watermarks.patch
mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch
documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch
docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch
docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch
docs-admin-guide-mm-damon-start-simplify-the-content.patch
docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch

