Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93445C0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 18:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjG0SVa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 14:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjG0SV3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 14:21:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5052D64
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 11:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C7F561EF7
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 18:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A372BC433C8;
        Thu, 27 Jul 2023 18:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690482087;
        bh=WoCqwbKsJN9biwQXQ8oGioh3TEe8Qjw5dCpLzOtFzfE=;
        h=Date:To:From:Subject:From;
        b=Bl1wa15KepQhyNoo8qcIaNdyYzG0s6ayvxuP2PKW0zMUpCE7/6fte9ZMa8JP7TAYV
         yp5A4fqfug5/E8lHUDuTPirT7Hog4iTAfcnXG5Lx1Jd1kAGbRS4zauNzRqSN5sGENm
         yuIQNTdvqREckdr3YOQTMAI15Vf0M56OjueSmeC4=
Date:   Thu, 27 Jul 2023 11:21:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        hughd@google.com, david@redhat.com, liubo254@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps.patch removed from -mm tree
Message-Id: <20230727182127.A372BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: smaps: fix the abnormal memory statistics obtained through /proc/pid/smaps
has been removed from the -mm tree.  Its filename was
     smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps.patch

This patch was dropped because an updated version will be merged

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

[akpm@linux-foundation.org: tweak comment and code layout]
Link: https://lkml.kernel.org/r/20230726073409.631838-1-liubo254@huawei.com
Signed-off-by: liubo <liubo254@huawei.com>
Fixes: 474098edac26 ("mm/gup: replace FOLL_NUMA by gup_can_follow_protnone()")
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -587,8 +587,12 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	bool migration = false;
 
 	if (pmd_present(*pmd)) {
-		/* FOLL_DUMP will return -EFAULT on huge zero page */
-		page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
+		/*
+		 * FOLL_DUMP: return -EFAULT on huge zero page
+		 * FOLL_FORCE: follow a PROT_NONE mapped page
+		 */
+		page = follow_trans_huge_pmd(vma, addr, pmd,
+					     FOLL_DUMP | FOLL_FORCE);
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
_

Patches currently in -mm which might be from liubo254@huawei.com are


