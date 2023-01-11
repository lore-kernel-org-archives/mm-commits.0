Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBCCC5479D
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbjAKVmS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbjAKVmR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 16:42:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E93B1EC56
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 13:42:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A92461E89
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 21:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B2EC433EF;
        Wed, 11 Jan 2023 21:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673473335;
        bh=jt8SBfy6hg/ZqYmLL7XKQLAuom0bq9v1TmkGk3K1kTg=;
        h=Date:To:From:Subject:From;
        b=Dk7G8sue2r0GTw5PLjmmejHznPZUiX0JnhVJYcT8pmIow3sYef63QF579vKjWBcUA
         aEJbzGMKOnNzGFgNfcMglS1NphQ8/+fQeppoll1ubsOd7o1pMZG0EdBjUOTajK6bhI
         1SCiDAzfaLwbRaIHCMjw9PZb5NPGzY7guIeHa72o=
Date:   Wed, 11 Jan 2023 13:42:15 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, javierm@redhat.com,
        pengfei.xu@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-filesystems-grant-executable-permission-to-run_fat_testssh.patch removed from -mm tree
Message-Id: <20230111214215.85B2EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/filesystems: grant executable permission to run_fat_tests.sh
has been removed from the -mm tree.  Its filename was
     selftests-filesystems-grant-executable-permission-to-run_fat_testssh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


