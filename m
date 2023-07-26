Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6369BC001DC
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jul 2023 19:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjGZTQY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jul 2023 15:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjGZTQY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2023 15:16:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2C9211C
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 12:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F5A761CAA
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 19:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3FAC433C7;
        Wed, 26 Jul 2023 19:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690398982;
        bh=kUxs9JxiqAIUaCr2ycGI+4YLy5yTMwDAHNvF/q29atA=;
        h=Date:To:From:Subject:From;
        b=ujz1UgfGrRJbZkJv6WD+v4C7lib9u+dffR4Wp1YMsO/THnMht3Vn1lYKpFGdAuHUU
         tzy3jgzJtLBEuJoU1n+p9LKD0FB3vigilrG5FDfE1R/cBN0VnXRS33rN5lhaECuUMT
         AWISAdfvlAiWK295Sxd3RTBrA1OPY/Vwn3OjuPNo=
Date:   Wed, 26 Jul 2023 12:16:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        hughd@google.com, david@redhat.com, liubo254@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps.patch added to mm-hotfixes-unstable branch
Message-Id: <20230726191621.EA3FAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: smaps: fix the abnormal memory statistics obtained through /proc/pid/smaps
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: liubo <liubo254@huawei.com>
Subject: smaps: fix the abnormal memory statistics obtained through /proc/pid/smaps
Date: Wed, 26 Jul 2023 15:34:09 +0800

In commit 474098edac26 ("mm/gup: replace FOLL_NUMA by
gup_can_follow_protnone()"), FOLL_NUMA was removed and replaced by the
gup_can_follow_protnone interface.

However, for the case where the user-mode process uses transparent huge
pages, when analyzing the memory usage through /proc/pid/smaps_rollup, the
obtained memory usage is not consistent with the RSS in /proc/pid/status.

Related examples are as follows:
cat /proc/15427/status
VmRSS:  20973024 kB
RssAnon:        20971616 kB
RssFile:            1408 kB
RssShmem:              0 kB

cat /proc/15427/smaps_rollup
00400000-7ffcc372d000 ---p 00000000 00:00 0 [rollup]
Rss:            14419432 kB
Pss:            14418079 kB
Pss_Dirty:      14418016 kB
Pss_Anon:       14418016 kB
Pss_File:             63 kB
Pss_Shmem:             0 kB
Anonymous:      14418016 kB
LazyFree:              0 kB
AnonHugePages:  14417920 kB

The root cause is that in the traversal of the page tables, the number of
pages obtained by smaps_pmd_entry does not include the pages corresponding
to PROTNONE, resulting in a different situation.

Therefore, when obtaining pages through the follow_trans_huge_pmd
interface, add the FOLL_FORCE flag to count the pages corresponding to
PROTNONE to solve the above problem.

Link: https://lkml.kernel.org/r/20230726073409.631838-1-liubo254@huawei.com
Signed-off-by: liubo <liubo254@huawei.com>
Fixes: 474098edac26 ("mm/gup: replace FOLL_NUMA by gup_can_follow_protnone()")
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -587,8 +587,10 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	bool migration = false;
 
 	if (pmd_present(*pmd)) {
-		/* FOLL_DUMP will return -EFAULT on huge zero page */
-		page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
+		/* FOLL_DUMP will return -EFAULT on huge zero page
+		 * FOLL_FORCE follow a PROT_NONE mapped page
+		 */
+		page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP | FOLL_FORCE);
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
_

Patches currently in -mm which might be from liubo254@huawei.com are

smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps.patch

