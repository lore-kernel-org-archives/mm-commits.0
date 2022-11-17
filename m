Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2418EC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 20:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiKQU6P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 15:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiKQU6L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 15:58:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C828382202
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 12:58:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99BDEB820C1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 20:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D78FC433C1;
        Thu, 17 Nov 2022 20:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668718683;
        bh=tdkTFTEIe0BQxRFTt/7bfBctvnLxNXibkCvFf8ahu+Y=;
        h=Date:To:From:Subject:From;
        b=mQbMB5QCeNBoDWKy9Is12ePcKVfBhRh0FEGhIen66NfcSOyMxJ0F2mP+aQ7zibf2L
         vGi6df0D7gnR1JY0gPgtgL4QmgwM1OhNvysXxdzlHwwAMtUlx8Oi00i/BhE4zuPc3N
         vY+qlspqEP6iMmISKXzNo58xE1iDvogXgQ+PI4R4=
Date:   Thu, 17 Nov 2022 12:58:02 -0800
To:     mm-commits@vger.kernel.org, jsavitz@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-enable-running-select-groups-of-tests-fix-2.patch added to mm-unstable branch
Message-Id: <20221117205803.3D78FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: remove extraneous echo
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-enable-running-select-groups-of-tests-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-enable-running-select-groups-of-tests-fix-2.patch

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
From: Joel Savitz <jsavitz@redhat.com>
Subject: selftests/vm: remove extraneous echo
Date: Wed, 16 Nov 2022 20:06:32 -0400

There is an extra echo statement in run_test(). Remove it.

Link: https://lkml.kernel.org/r/20221117000632.254027-1-jsavitz@redhat.com
Fixes: 98b3add737b4 ("selftests/vm: enable running select groups of tests")
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-enable-running-select-groups-of-tests-fix-2
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -142,7 +142,6 @@ echo "$ARCH64STR" | grep "$ARCH" &>/dev/
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
-		echo "running: $1"
 		local title="running $*"
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
 		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep"
_

Patches currently in -mm which might be from jsavitz@redhat.com are

selftests-vm-enable-running-select-groups-of-tests.patch
selftests-vm-enable-running-select-groups-of-tests-fix.patch
selftests-vm-enable-running-select-groups-of-tests-fix-2.patch
selftests-vm-add-ksm-unmerge-tests-fix.patch

