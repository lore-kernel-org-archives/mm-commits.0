Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A62C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441852AbjLGANU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441862AbjLGANR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32650D3
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0A8C433C7;
        Thu,  7 Dec 2023 00:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908003;
        bh=/avjehKPqB0HH4bw6NYwmqpYTOOr2hazQtrTD0GzfT4=;
        h=Date:To:From:Subject:From;
        b=RLVJY2KZebtP8PclGSDnnHVj7wQByLCok67iE+RP9elFmFmz2YyuJntAajicXQaLL
         p/EwizOiKJlCyiG11rg3u8ZDZ1AYAqFOrKImQlH5NT0sqSk5/Q4Zwg9zXOhJTw2IxE
         JvyLLH5UHgle4vhyhLWJ5w4dlagwuzvs+801rrx0=
Date:   Wed, 06 Dec 2023 16:13:23 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        david@redhat.com, avagin@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch removed from -mm tree
Message-Id: <20231207001323.BC0A8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pagemap: fix wr-protect even if PM_SCAN_WP_MATCHING not set
has been removed from the -mm tree.  Its filename was
     mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/pagemap: fix wr-protect even if PM_SCAN_WP_MATCHING not set
Date: Thu, 16 Nov 2023 15:15:46 -0500

The new pagemap ioctl contains a fast path for wr-protections without
looking into category masks.  It forgets to check PM_SCAN_WP_MATCHING
before applying the wr-protections.  It can cause, e.g., pte markers
installed on archs that do not even support uffd wr-protect.

WARNING: CPU: 0 PID: 5059 at mm/memory.c:1520 zap_pte_range mm/memory.c:1520 [inline]

Link: https://lkml.kernel.org/r/20231116201547.536857-3-peterx@redhat.com
Fixes: 12f6b01a0bcb ("fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: syzbot+7ca4b2719dc742b8d0a4@syzkaller.appspotmail.com
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Andrei Vagin <avagin@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set
+++ a/fs/proc/task_mmu.c
@@ -2156,7 +2156,7 @@ static int pagemap_scan_pmd_entry(pmd_t
 		return 0;
 	}
 
-	if (!p->vec_out) {
+	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
 		/* Fast path for performing exclusive WP */
 		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
 			if (pte_uffd_wp(ptep_get(pte)))
_

Patches currently in -mm which might be from peterx@redhat.com are

fs-kconfig-make-hugetlbfs-a-menuconfig.patch
mm-gup-fix-follow_devmap_pd-on-page==null-handling.patch

