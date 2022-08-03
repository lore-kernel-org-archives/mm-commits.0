Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D66C00140
	for <mm-commits@archiver.kernel.org>; Wed,  3 Aug 2022 01:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiHCBKG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Aug 2022 21:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiHCBKF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2022 21:10:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB66558E4
        for <mm-commits@vger.kernel.org>; Tue,  2 Aug 2022 18:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2551B82010
        for <mm-commits@vger.kernel.org>; Wed,  3 Aug 2022 01:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B70EC433D6;
        Wed,  3 Aug 2022 01:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659489001;
        bh=0EWGv39ZE3e+B+AUWnOO7OMFUPaib4TabbQZMMz/DIo=;
        h=Date:To:From:Subject:From;
        b=UvaUhWmTS5NGs5ZajXDzNEtx4xBpIBcnVTpAICGrJBueY3nlBARjQvx9OrDnRXB0Z
         epGT3nxrH+bbgibE4vK3AnY8R9TA0eoM2MuRO0LvA8Tken9bpivqVqYptPpi3rSna8
         1ADa74vpBDpo5MjSh7yljGMCbLoi03aRiCZxvknw=
Date:   Tue, 02 Aug 2022 18:10:00 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com, lkp@intel.com,
        apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-vm-hmm-testsc-fix-build.patch added to mm-unstable branch
Message-Id: <20220803011001.8B70EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/hmm-tests.c: fix build
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-selftests-vm-hmm-testsc-fix-build.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-vm-hmm-testsc-fix-build.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools/testing/selftests/vm/hmm-tests.c: fix build
Date: Tue Aug  2 06:03:03 PM PDT 2022

hmm-tests.c:1607:42: error: 'HMM_DMIRROR_MIGRATE' undeclared (first use in this function); did you mean 'HMM_DMIRROR_WRITE'?

Fixes: f6c3e1ae0114cd0 ("mm/hmm: add a test for cross device private faults")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hmm-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/hmm-tests.c~tools-testing-selftests-vm-hmm-testsc-fix-build
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -1604,7 +1604,7 @@ TEST_F(hmm2, double_map)
 		ASSERT_EQ(ptr[i], i);
 
 	/* Migrate pages to device 1 and try to read from device 0. */
-	ret = hmm_dmirror_cmd(self->fd1, HMM_DMIRROR_MIGRATE, buffer, npages);
+	ret = hmm_migrate_sys_to_dev(self->fd1, buffer, npages);
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

tools-testing-selftests-vm-hmm-testsc-fix-build.patch

