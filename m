Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174A6C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E67BB61C15
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240630AbhKPEJQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:09:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240304AbhKPEIQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:08:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E43661BFE;
        Tue, 16 Nov 2021 04:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637035519;
        bh=Ne5Fq2zDCuOImFo5xnovMrqcdBuUcOWRkUcuD/qzOFE=;
        h=Date:From:To:Subject:From;
        b=yHg7DNNEXobSwl5Ko+jkr71yuCbBL5Jch7E9YdoSiRULYSTbucr/RDbM65+wx6Ljg
         ObILBbmjda/v0JO9vGE5SgwyZ7VfPklOHvIsTCvKAYypevt6MkMhbJtl1EpKYhNW1Q
         CWeFHEC3DOUrh+jzr8Ifg/vZpbJvXTzSuX9guP4M=
Date:   Mon, 15 Nov 2021 20:05:18 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        zhengqi.arch@bytedance.com
Subject:  +
 =?US-ASCII?Q?mm-remove-redundant-check-about-fault=5Fflag=5Fallow=5Fretr?=
 =?US-ASCII?Q?y-bit-checkpatch-fixes.patch?= added to -mm tree
Message-ID: <20211116040518.b4P2zza7K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch

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
Subject: mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes

WARNING: Block comments use a trailing */ on a separate line
#407: FILE: arch/s390/mm/fault.c:459:
+			 * mmap_lock has not been released */

total: 0 errors, 1 warnings, 444 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/fault.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes
+++ a/arch/s390/mm/fault.c
@@ -455,8 +455,10 @@ retry:
 	if (fault & VM_FAULT_RETRY) {
 		if (IS_ENABLED(CONFIG_PGSTE) && gmap &&
 			(flags & FAULT_FLAG_RETRY_NOWAIT)) {
-			/* FAULT_FLAG_RETRY_NOWAIT has been set,
-			 * mmap_lock has not been released */
+			/*
+			 * FAULT_FLAG_RETRY_NOWAIT has been set, mmap_lock has
+			 * not been released
+			 */
 			current->thread.gmap_pfault = 1;
 			fault = VM_FAULT_PFAULT;
 			goto out_up;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

