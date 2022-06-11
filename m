Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5BBC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 22:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiFKWEy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 18:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiFKWEx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 18:04:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F8A3B1
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 15:04:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7D23B80B4D
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 22:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FD6C34116;
        Sat, 11 Jun 2022 22:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654985090;
        bh=s2oI7TffJcSK+KYMjs8K+J1vn7eK3xYoWMu7sXeUIgM=;
        h=Date:To:From:Subject:From;
        b=P48QOeuWB0mCw9gLZFDvsSoFGlLzdmfbCfQ5e4JPzlyGQ1SJ2UUTKFOeDoNsGdqmy
         WndPES0Ys9BdpVsFScbJdaYPtqfdHDj4h1sBdb6aGYV6oJee0ROTQCduf6GlBbEmuX
         BpSCRUDQs31mmuBY4fsaitlLUNx1o58eCNDhbu/c=
Date:   Sat, 11 Jun 2022 15:04:49 -0700
To:     mm-commits@vger.kernel.org, wangxiang@cdjrlc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-selftests-fix-typo-in-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20220611220450.89FD6C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: fix typo in comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     userfaultfd-selftests-fix-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-selftests-fix-typo-in-comment.patch

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
From: Xiang wangx <wangxiang@cdjrlc.com>
Subject: userfaultfd/selftests: fix typo in comment
Date: Fri, 10 Jun 2022 15:12:44 +0800

Delete the redundant word 'in'.

Link: https://lkml.kernel.org/r/20220610071244.59679-1-wangxiang@cdjrlc.com
Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-typo-in-comment
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -860,7 +860,7 @@ static int stress(struct uffd_stats *uff
 	/*
 	 * Be strict and immediately zap area_src, the whole area has
 	 * been transferred already by the background treads. The
-	 * area_src could then be faulted in in a racy way by still
+	 * area_src could then be faulted in a racy way by still
 	 * running uffdio_threads reading zeropages after we zapped
 	 * area_src (but they're guaranteed to get -EEXIST from
 	 * UFFDIO_COPY without writing zero pages into area_dst
_

Patches currently in -mm which might be from wangxiang@cdjrlc.com are

userfaultfd-selftests-fix-typo-in-comment.patch

