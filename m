Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3494C19F28
	for <mm-commits@archiver.kernel.org>; Wed,  3 Aug 2022 18:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbiHCSl1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Aug 2022 14:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238292AbiHCSl1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2022 14:41:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40875167E8
        for <mm-commits@vger.kernel.org>; Wed,  3 Aug 2022 11:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E90D1B82366
        for <mm-commits@vger.kernel.org>; Wed,  3 Aug 2022 18:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BE3C433C1;
        Wed,  3 Aug 2022 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659552083;
        bh=GGdV7trLg9pALuwkj9Xf+4lLxLWrV9VoF/5wpUKdmiI=;
        h=Date:To:From:Subject:From;
        b=O4PP2/XhTt0YBMjsLvSZ39iIxP6aq4t1PGYz+dO8AsQ/HCyrPOH0N8e2bCJlXGHjl
         bgC5z6gbU5EAGMybfnQU9RauY7O11l/akluRDFH7enXIM1bGXERLZwopdVBhHdwQRL
         f7Cjg6uzZ7EVZgQ1JZmg4HVYXqEUp8GNINrh28EU=
Date:   Wed, 03 Aug 2022 11:41:22 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com, lkp@intel.com,
        apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-selftests-vm-hmm-testsc-fix-build.patch removed from -mm tree
Message-Id: <20220803184123.A6BE3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/testing/selftests/vm/hmm-tests.c: fix build
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-vm-hmm-testsc-fix-build.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools/testing/selftests/vm/hmm-tests.c: fix build
Date: Tue Aug  2 06:03:03 PM PDT 2022

hmm-tests.c:1607:42: error: 'HMM_DMIRROR_MIGRATE' undeclared (first use in this function); did you mean 'HMM_DMIRROR_WRITE'?

Fixes: f6c3e1ae0114cd0 ("mm/hmm: add a test for cross device private faults")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
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


