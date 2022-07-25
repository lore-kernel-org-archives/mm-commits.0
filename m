Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF29FC43334
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 22:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiGYWLL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiGYWLC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 18:11:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A824977
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 15:11:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4D2A611E7
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 22:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16416C341C8;
        Mon, 25 Jul 2022 22:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658787061;
        bh=nErJe23DQFbdI9LysTHhKmxVbVul5U7Bhu+MqxMjQts=;
        h=Date:To:From:Subject:From;
        b=Z++VVAtxeFHJV1C2uAcpLTJtJjmMJXgYpe+WYdwfNWnCeqB3Unpq3Tv0RsO9RZ3sC
         9fLCCA3sxtiLABBnv6sHpswEmMhruzR5ZrxgNw5+2c0svosXCMetlPC8IaGmN8FDaZ
         SQNh7u/fRL/Lvle798YZ3Cef5YU9htatpN8Mi07o=
Date:   Mon, 25 Jul 2022 15:11:00 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com, david@redhat.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-add-soft-dirty-into-run_vmtestssh.patch added to mm-unstable branch
Message-Id: <20220725221101.16416C341C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add soft-dirty into run_vmtests.sh
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-add-soft-dirty-into-run_vmtestssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-add-soft-dirty-into-run_vmtestssh.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests: add soft-dirty into run_vmtests.sh
Date: Mon, 25 Jul 2022 10:20:48 -0400

Link: https://lkml.kernel.org/r/20220725142048.30450-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-add-soft-dirty-into-run_vmtestssh
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -190,4 +190,6 @@ then
 	run_test ./protection_keys_64
 fi
 
+run_test ./soft-dirty
+
 exit $exitcode
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch
selftests-soft-dirty-add-test-for-mprotect.patch
selftests-add-soft-dirty-into-run_vmtestssh.patch

