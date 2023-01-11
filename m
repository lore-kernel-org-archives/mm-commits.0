Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789FBC46467
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjAKVly (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbjAKVlw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 16:41:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE312DF33
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 13:41:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60172B81D76
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 21:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F297DC433EF;
        Wed, 11 Jan 2023 21:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673473307;
        bh=DN6XeFehDG1JG0bLDqoCFr5gtghzPlqzPhVTDWJRNBA=;
        h=Date:To:From:Subject:From;
        b=pY3gHiAsLXgSAua0pw44ZiJzGVgdL2n3LeuBZRebXIuKNY2/cAZH95DO24qdW+Dgh
         pGyi/AuEdxhL0PwCZHNkZXGziBQPF97tse6BT3mBvvOD6fdGBn+I+Pv2ttFsJ8Yu21
         X8e6D/iKxJ46BmuHpEoxaMmlkpj9o3ZvEGfl3Prc=
Date:   Wed, 11 Jan 2023 13:41:46 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, javierm@redhat.com,
        pengfei.xu@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-filesystems-grant-executable-permission-to-run_fat_testssh.patch added to mm-nonmm-stable branch
Message-Id: <20230111214146.F297DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/filesystems: grant executable permission to run_fat_tests.sh
has been added to the -mm mm-nonmm-stable branch.  Its filename is
     selftests-filesystems-grant-executable-permission-to-run_fat_testssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-filesystems-grant-executable-permission-to-run_fat_testssh.patch

This patch will later appear in the mm-nonmm-stable branch at
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
From: Pengfei Xu <pengfei.xu@intel.com>
Subject: selftests/filesystems: grant executable permission to run_fat_tests.sh
Date: Wed, 11 Jan 2023 16:15:31 +0800

When use tools/testing/selftests/kselftest_install.sh to make the
kselftest-list.txt under tools/testing/selftests/kselftest_install.

Then use tools/testing/selftests/kselftest_install/run_kselftest.sh to run
all the kselftests in kselftest-list.txt, it will be blocked by case
"filesystems/fat: run_fat_tests.sh" with "Warning: file run_fat_tests.sh
is not executable", so grant executable permission to run_fat_tests.sh to
fix this issue.

Link: https://lkml.kernel.org/r/dfdbba6df8a1ab34bb1e81cd8bd7ca3f9ed5c369.1673424747.git.pengfei.xu@intel.com
Fixes: dd7c9be330d8 ("selftests/filesystems: add a vfat RENAME_EXCHANGE test")
Signed-off-by: Pengfei Xu <pengfei.xu@intel.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/fat/run_fat_tests.sh | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/filesystems/fat/run_fat_tests.sh

diff --git a/tools/testing/selftests/filesystems/fat/run_fat_tests.sh b/tools/testing/selftests/filesystems/fat/run_fat_tests.sh
old mode 100644
new mode 100755


Patches currently in -mm which might be from pengfei.xu@intel.com are

selftests-filesystems-grant-executable-permission-to-run_fat_testssh.patch

