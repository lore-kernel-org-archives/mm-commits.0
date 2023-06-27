Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49F1EB64D9
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jun 2023 19:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjF0T32 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jun 2023 15:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF0T32 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2023 15:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5538F19A9
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 12:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E550D611EE
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 19:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AE5C433C8;
        Tue, 27 Jun 2023 19:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687894166;
        bh=QpPw5hnp8lOF5k3mDqWCWZXGVEvPHM5VrJN+2pg8fuU=;
        h=Date:To:From:Subject:From;
        b=N6xX2FlRl0yymQb2pHvte6CxWgxwUDxiqOcg+O32VYMlO/ssoQQyTNm5LebLIMhWQ
         GT5cUSnut3t3+jEbzEpHBf4fmTzh85MxN2JzKSVbzC6n/k+ww4cYYoAoGpQLOfhi6F
         JDAUNs58l+RAbEhbq3VHg34ak+OTUvLi4E4ewdf0=
Date:   Tue, 27 Jun 2023 12:29:25 -0700
To:     mm-commits@vger.kernel.org, mawupeng1@huawei.com, hughd@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20230627192926.43AE5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes
Date: Tue Jun 27 12:28:53 PM PDT 2023

fix typo in comment

WARNING: 'avaliable' may be misspelled - perhaps 'available'?
#60: FILE: mm/swapfile.c:2332:
+	/* add to avaliable list iff swap device is not full */
 	          ^^^^^^^^^

total: 0 errors, 1 warnings, 11 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/swap-stop-add-to-avail-list-is-swap-is-full.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hugh Dickins <hughd@google.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes
+++ a/mm/swapfile.c
@@ -2329,7 +2329,7 @@ static void _enable_swap_info(struct swa
 	 */
 	plist_add(&p->list, &swap_active_head);
 
-	/* add to avaliable list iff swap device is not full */
+	/* add to available list iff swap device is not full */
 	if (p->highest_bit)
 		add_to_avail_list(p);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch

