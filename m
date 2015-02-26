From: akpm@linux-foundation.org
Subject: + mm-cma-release-trigger-fixpatch.patch added to -mm tree
Date: Thu, 26 Feb 2015 12:45:50 -0800
Message-ID: <54ef85fe./D2UX83FVVoAVig0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbbBZUpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 15:45:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, fengguang.wu@gmail.com, sasha.levin@oracle.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-release-trigger-fix
has been added to the -mm tree.  Its filename is
     mm-cma-release-trigger-fixpatch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-release-trigger-fixpatch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-release-trigger-fixpatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-cma-release-trigger-fix

allmodconfig fails with
mm/cma_debug.c: In function `cma_free_mem':
mm/cma_debug.c:71:4: error: invalid use of undefined type `struct page'
    mem->p += count;

Fix it by including mm_types.h

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/cma_debug.c~mm-cma-release-trigger-fixpatch mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-release-trigger-fixpatch
+++ a/mm/cma_debug.c
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/mm_types.h>
 
 #include "cma.h"
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-fix-low-limit-calculation.patch
mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch
mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change.patch
mm-memcontrol-update-copyright-notice.patch
mm-cma-release-trigger-fixpatch.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

