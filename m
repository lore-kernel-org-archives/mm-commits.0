Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FA2C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 23:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357863AbhLBXZP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 18:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356451AbhLBXZO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 18:25:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11E7C06174A
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 15:21:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87253628B3
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 23:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC08C00446;
        Thu,  2 Dec 2021 23:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638487311;
        bh=rAb1/22i24nJsDI5qYwnJaeXoYq1woIQa/HezaH7Ctc=;
        h=Date:From:To:Subject:From;
        b=QXeFHPW2m+GM2u+L9YDheTLpPS2bR5jWh2oPxmSvg8P2M4igkyuNbb7muYb6059ny
         EDr2DeUTWb82y4SIL3TF2NTzOHg5qYTocyGp3Bih2SIvAouyzZt389EvfvnZfIj+Zy
         txeXjP2Yy0Y5bFtqCApmIzkrF1BcacvzpQWbxxBQ=
Date:   Thu, 02 Dec 2021 15:21:50 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com
Subject:  +
 =?US-ASCII?Q?mm-shmem-dont-truncate-page-if-memory-failure-happens-checkp?=
 =?US-ASCII?Q?atch-fixes.patch?= added to -mm tree
Message-ID: <20211202232150.eW9TWXKIR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch

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
Subject: mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#20: 
 slight different implementation from what Ajay Garg <ajaygargnsit@gmail.com>

WARNING: suspect code indent for conditional statements (16, 23)
#148: FILE: mm/shmem.c:3129:
+		if (!page)
+		       return ERR_PTR(-ECHILD);

WARNING: Statements should start on a tabstop
#149: FILE: mm/shmem.c:3130:
+		       return ERR_PTR(-ECHILD);

total: 0 errors, 3 warnings, 150 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-shmem-dont-truncate-page-if-memory-failure-happens.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes
+++ a/mm/shmem.c
@@ -3127,7 +3127,7 @@ static const char *shmem_get_link(struct
 		if (error)
 			return ERR_PTR(error);
 		if (!page)
-		       return ERR_PTR(-ECHILD);
+			return ERR_PTR(-ECHILD);
 		if (PageHWPoison(page)) {
 			unlock_page(page);
 			put_page(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

