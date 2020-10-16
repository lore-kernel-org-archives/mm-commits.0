Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7672CC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 080ED20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814767;
	bh=lxBgceZxEe5tY7ooSQW1A3bbhEDnFFaXX/n/uNrAi3c=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ezQTMhiYQ0ys22e3IZPlF9CZA/sT/tT4DGwm2E7sAJg6bUey8zijBa7YTvTsx+/do
	 FE+iC7wfp8E9u6dqH/ne8GMeRELnOnQMS4MJWkFxf9ci6AtmHvvcdCEvZZph+YMKaZ
	 Z71UgjSoSMpR5ygI1nNcf41w5HHUk6cwE5xE0TeQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731863AbgJPCT0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731436AbgJPCT0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:19:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDCC620878;
        Fri, 16 Oct 2020 02:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814766;
        bh=lxBgceZxEe5tY7ooSQW1A3bbhEDnFFaXX/n/uNrAi3c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yBbPtUyJHKqe65z8Z/qUCEUlaPX0R0B2YYJEFLThjGuIR5gOSjGpwFYxQ7lLqIsx0
         TxZkeU2ulrDjj0PilJQ0uVPWpze/rSCM+HwRrq2vB3wCNXSdQR+LiGm5qgK/TVYu9W
         zKwv+2q1XJf4bLuOBHYllEs7iojXBb8b+Cw2TsU4=
Date:   Thu, 15 Oct 2020 19:19:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 checkpatch-warn-on-self-assignments-checkpatch-fixes.patch removed from -mm
 tree
Message-ID: <20201016021925.ysTt6X7pY%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-warn-on-self-assignments-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-self-assignments-checkpatch-fixes.patch

This patch was dropped because it was folded into checkpatch-warn-on-self-assignments.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-warn-on-self-assignments-checkpatch-fixes

WARNING: Unknown commit id '63a0895d960a', maybe rebased or not pulled?
#4: 
The uninitialized_var() macro was removed recently via commit 63a0895d960a

WARNING: 'assigments' may be misspelled - perhaps 'assignments'?
#30: FILE: scripts/checkpatch.pl:3904:
+# check for self assigments used to avoid compiler warnings

total: 0 errors, 2 warnings, 17 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/checkpatch-warn-on-self-assignments.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-warn-on-self-assignments-checkpatch-fixes
+++ a/scripts/checkpatch.pl
@@ -3899,7 +3899,7 @@ sub process {
 #ignore lines not being added
 		next if ($line =~ /^[^\+]/);
 
-# check for self assigments used to avoid compiler warnings
+# check for self assignments used to avoid compiler warnings
 # e.g.:	int foo = foo, *bar = NULL;
 #	struct foo bar = *(&(bar));
 		if ($line =~ /^\+\s*(?:$Declare)?([A-Za-z_][A-Za-z\d_]*)\s*=/) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

checkpatch-warn-on-self-assignments.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

