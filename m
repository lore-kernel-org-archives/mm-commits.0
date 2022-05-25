Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9FEC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245754AbiEYRt0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343526AbiEYRtP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:49:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C6EB0400
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1966B81E76
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B9CC34113;
        Wed, 25 May 2022 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500944;
        bh=Okb1NT3f3dFCzfDOmT/5i2EjFcY7E2oInr1Y9KmEiXE=;
        h=Date:To:From:Subject:From;
        b=navMr40HbgNxVwERtLjFMP60ePVXneaosXs5HbKFCyd3zirI2HEqEoCYoNRs/5jVh
         6BAbN/dqXpJG7S4WzUzPzAHVfTbz8OeCIx23xK5HehXESRrIUWSPdj0n5fGcpzRFXN
         dzLajbSSmAbH3liDG3mrfVw/9q0zABhBIR1slX9o=
Date:   Wed, 25 May 2022 10:49:03 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        patrick.wang.shcn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-add-the-settings-file-with-timeout-variable.patch removed from -mm tree
Message-Id: <20220525174904.67B9CC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: add the "settings" file with timeout variable
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-the-settings-file-with-timeout-variable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: selftests: vm: add the "settings" file with timeout variable
Date: Sat, 21 May 2022 16:38:25 +0800

The default "timeout" for one kselftest is 45 seconds, while some cases in
run_vmtests.sh require more time.  This will cause testing timeout like:

  not ok 4 selftests: vm: run_vmtests.sh # TIMEOUT 45 seconds

Therefore, add the "settings" file with timeout variable so users can set
the "timeout" value.

Link: https://lkml.kernel.org/r/20220521083825.319654-4-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/settings |    1 +
 1 file changed, 1 insertion(+)

--- /dev/null
+++ a/tools/testing/selftests/vm/settings
@@ -0,0 +1 @@
+timeout=45
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are


