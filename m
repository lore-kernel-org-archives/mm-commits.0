Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1B9C5519F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F28D7221E9
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1pqc75Ni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgKMA4Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKMA4Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:56:16 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 498B020B80;
        Fri, 13 Nov 2020 00:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605228975;
        bh=k9hifeyOys6OSVm/LVznhZYyzvcnkDRmXY+HntiSIc4=;
        h=Date:From:To:Subject:From;
        b=1pqc75NiPGl9sFYVcX6onwZmyOp8D9XKHYIeaBjw1cf7xv/o7ZtEWS5Q2UnYOZaO6
         oQKSX99MGh/7FvA7QfABrk05R9gAWObXeSxDimZB6TfmFtO0EW7gvEqOHkkIEFIkVd
         toA9nHZhS1Lbkx0M7JiQoxUKQgWXVu7tr8LWbARI=
Date:   Thu, 12 Nov 2020 16:56:14 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jgg@nvidia.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
 added to -mm tree
Message-ID: <20201113005614.XGGSOzoCk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes

WARNING: Unknown commit id '70e806e4e645', maybe rebased or not pulled?
#4: 
Since commit 70e806e4e645 ("mm: Do early cow for pinned pages during

WARNING: Unknown commit id 'f3c64eda3e50', maybe rebased or not pulled?
#34: 
problems (and was missing a barrrier), see commit f3c64eda3e50 ("mm: avoid

WARNING: Unknown commit id 'f3c64eda3e50', maybe rebased or not pulled?
#46: 
Fixes: f3c64eda3e50 ("mm: avoid early COW write protect games during fork()")

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
#136: FILE: mm/gup.c:2687:
+	unsigned seq;

WARNING: Block comments should align the * on each line
#191: FILE: mm/memory.c:1180:
+		 * lockdep complaining about preemptibility.
+		*/

total: 0 errors, 5 warnings, 109 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes
+++ a/mm/memory.c
@@ -1177,7 +1177,7 @@ copy_page_range(struct vm_area_struct *d
 		 *
 		 * Use the raw variant of the seqcount_t write API to avoid
 		 * lockdep complaining about preemptibility.
-		*/
+		 */
 		mmap_assert_write_locked(src_mm);
 		raw_write_seqcount_begin(&src_mm->write_protect_seq);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-rejects.patch
kasan-split-out-shadowc-from-commonc-fix.patch
kasan-mm-check-kasan_enabled-in-annotations-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

