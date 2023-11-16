Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9769C47071
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 21:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjKPVfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 16:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjKPVfV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 16:35:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65C61A8
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 13:35:17 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67459C433C7;
        Thu, 16 Nov 2023 21:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700170517;
        bh=tbkxgPzCNuzakw1Kj4Y4uP0CkcwmDxAvK7JT2KUMy3Q=;
        h=Date:To:From:Subject:From;
        b=Rw19Az28NoxbNVVrZaYAeiRDPjT3XncBfh+DxqZO7pyuR2Os6dXW/HjEqG+q/gYHc
         XLV8f4vYTvd5JwIi3rzHQ4TWf/ysJgAH4cpY50x1Q5nvuORx+YxMJhfeAV5iiiHtnR
         j8FkpKFRb/Xa8AdCmJHPuK+cdClfbtOB9deatE+E=
Date:   Thu, 16 Nov 2023 13:35:16 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        david@redhat.com, avagin@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch added to mm-hotfixes-unstable branch
Message-Id: <20231116213517.67459C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagemap: fix wr-protect even if PM_SCAN_WP_MATCHING not set
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch

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
Cc: Andrei Vagin <avagin@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
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

mm-pagemap-fix-ioctlpagemap_scan-on-vma-check.patch
mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch
mm-selftests-fix-pagemap_ioctl-memory-map-test.patch

