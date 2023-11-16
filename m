Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B60C197A0
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 21:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbjKPVfU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 16:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjKPVfT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 16:35:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312E4A7
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 13:35:16 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0342C433C7;
        Thu, 16 Nov 2023 21:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700170515;
        bh=99FkIEAnWk/edsrf3RfjFNq9FaGm0WG5+ektIpgt1fc=;
        h=Date:To:From:Subject:From;
        b=GkPm51ABSS6kQxpl8Xso3/YdK3kOi4033HmqcrSKHtS6C+Oe6Lws8jTkoAL2YxAQF
         +mSTZSK64X6MeIMQsw84oY8EYvDj0A5En1dkCixOVgAgNxX+nQnGZ5vNfrYlipJUJF
         TsX8Q3cesXo+XwmSgp+16Nb4H0VVPLUlHWON8Rv0=
Date:   Thu, 16 Nov 2023 13:35:14 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        david@redhat.com, avagin@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagemap-fix-ioctlpagemap_scan-on-vma-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20231116213515.B0342C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagemap: fix ioctl(PAGEMAP_SCAN) on vma check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-pagemap-fix-ioctlpagemap_scan-on-vma-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagemap-fix-ioctlpagemap_scan-on-vma-check.patch

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
Subject: mm/pagemap: fix ioctl(PAGEMAP_SCAN) on vma check
Date: Thu, 16 Nov 2023 15:15:45 -0500

Patch series "mm/pagemap: A few fixes to the recent PAGEMAP_SCAN".

This series should fix two known reports from syzbot on the new
PAGEMAP_SCAN ioctl():

https://lore.kernel.org/all/000000000000b0e576060a30ee3b@google.com/
https://lore.kernel.org/all/000000000000773fa7060a31e2cc@google.com/

The 3rd patch is something I found when testing these patches.


This patch (of 3):

The new ioctl(PAGEMAP_SCAN) relies on vma wr-protect capability provided
by userfault, however in the vma test it didn't explicitly require the vma
to have wr-protect function enabled, even if PM_SCAN_WP_MATCHING flag is
set.

It means the pagemap code can now apply uffd-wp bit to a page in the vma
even if not registered to userfaultfd at all.

Then in whatever way as long as the pte got written and page fault
resolved, we'll apply the write bit even if uffd-wp bit is set.  We'll see
a pte that has both UFFD_WP and WRITE bit set.  Anything later that looks
up the pte for uffd-wp bit will trigger the warning:

WARNING: CPU: 1 PID: 5071 at arch/x86/include/asm/pgtable.h:403 pte_uffd_wp arch/x86/include/asm/pgtable.h:403 [inline]

Fix it by doing proper check over the vma attributes when
PM_SCAN_WP_MATCHING is specified.

Link: https://lkml.kernel.org/r/20231116201547.536857-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20231116201547.536857-2-peterx@redhat.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: syzbot+e94c5aaf7890901ebf9b@syzkaller.appspotmail.com
Cc: Andrei Vagin <avagin@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/fs/proc/task_mmu.c~mm-pagemap-fix-ioctlpagemap_scan-on-vma-check
+++ a/fs/proc/task_mmu.c
@@ -1982,15 +1982,31 @@ static int pagemap_scan_test_walk(unsign
 	struct pagemap_scan_private *p = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	unsigned long vma_category = 0;
+	bool wp_allowed = userfaultfd_wp_async(vma) &&
+	    userfaultfd_wp_use_markers(vma);
 
-	if (userfaultfd_wp_async(vma) && userfaultfd_wp_use_markers(vma))
-		vma_category |= PAGE_IS_WPALLOWED;
-	else if (p->arg.flags & PM_SCAN_CHECK_WPASYNC)
-		return -EPERM;
+	if (!wp_allowed) {
+		/* User requested explicit failure over wp-async capability */
+		if (p->arg.flags & PM_SCAN_CHECK_WPASYNC)
+			return -EPERM;
+		/*
+		 * User requires wr-protect, and allows silently skipping
+		 * unsupported vmas.
+		 */
+		if (p->arg.flags & PM_SCAN_WP_MATCHING)
+			return 1;
+		/*
+		 * Then the request doesn't involve wr-protects at all,
+		 * fall through to the rest checks, and allow vma walk.
+		 */
+	}
 
 	if (vma->vm_flags & VM_PFNMAP)
 		return 1;
 
+	if (wp_allowed)
+		vma_category |= PAGE_IS_WPALLOWED;
+
 	if (!pagemap_scan_is_interesting_vma(vma_category, p))
 		return 1;
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-pagemap-fix-ioctlpagemap_scan-on-vma-check.patch
mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch
mm-selftests-fix-pagemap_ioctl-memory-map-test.patch

