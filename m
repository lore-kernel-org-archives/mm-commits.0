Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2448DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D8B6120A
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbhJOVEv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 17:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232377AbhJOVEu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 17:04:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBA060E0B;
        Fri, 15 Oct 2021 21:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634331764;
        bh=rf3Jtu4F9r7xWpF3g7/U6JAeAscEVtWPCxKpp20hN1U=;
        h=Date:From:To:Subject:From;
        b=o9lO/5rHnmweCpswYGL53izWYtKS6I8e9k+3nMPupJuvgyvBo4EH5gmHNvvAuhruY
         WTOOCa8uZ6ylRDXP7Q37xtDO54MA9s5U5jbD6w3UqFC7HY4pGlJYWBgcgCXSGyle5p
         /mO1FKdp14HPqRYaVooeD3al8J5A7vv0Pyh/uNMg=
Date:   Fri, 15 Oct 2021 14:02:43 -0700
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au, sj@kernel.org
Subject:  +
 mm-damon-vaddr-separate-commonly-usable-functions-fix.patch added to -mm
 tree
Message-ID: <20211015210243.eeCjoe7dZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: include 'highmem.h' to fix a build failure
has been added to the -mm tree.  Its filename is
     mm-damon-vaddr-separate-commonly-usable-functions-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-vaddr-separate-commonly-usable-functions-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-vaddr-separate-commonly-usable-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-damon-vaddr-separate-commonly-usable-functions-fix.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch

