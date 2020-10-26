Return-Path: <SRS0=L/bp=EB=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398E9C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD9AF21D41
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603740237;
	bh=SlvKWcad1n8b5BQiGfKyq39Eut1s3T3pCZGUlfn2xgk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FVBVoK6HItZBtNDluoj/clN8S2U+2uakDTU5OSsm70Hq/pIUYVXW12X7Ag48W0uxa
	 ArC5YvXfgFuKynkTQJTzng3jUBU7mXhDm21OgKz+7a+1I9BgluI4vwy/LZJ2gjcWro
	 E8IsA7v4V76XJsAA2AZGOBP4+Q/GXC/mOgYge8R4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1792987AbgJZTX5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784580AbgJZTX5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 26 Oct 2020 15:23:57 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5AE82085B;
        Mon, 26 Oct 2020 19:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603740236;
        bh=SlvKWcad1n8b5BQiGfKyq39Eut1s3T3pCZGUlfn2xgk=;
        h=Date:From:To:Subject:From;
        b=SRmaJ4vmcbIT9Ir/XomRZFDyevRaOFmMj+PqfmmvUtZOIG02ZUwDMfcUTEkn1LuCZ
         EvaIXAOtTYuBtZqJS1Qs4+DrucL/jf9OhpJRQUpMHS9OrbbqvF0k7KQH5miglms/3O
         Oeq4BgAFILLios8gwCKkFhDOtikxIWffAF5q6k4c=
Date:   Mon, 26 Oct 2020 12:23:56 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sh_def@163.com, mhocko@kernel.org,
        akpm@linux-foundation.org
Subject:  +
 mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix.patch added to -mm
 tree
Message-ID: <20201026192356.CThwA%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix
has been added to the -mm tree.  Its filename is
     mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix

remove incorrect kerneldoc token

Cc: Hui Su <sh_def@163.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix
+++ a/mm/oom_kill.c
@@ -170,7 +170,7 @@ static bool oom_unkillable_task(struct t
 	return false;
 }
 
-/**
+/*
  * Check whether unreclaimable slabs amount is greater than
  * all user memory(LRU pages).
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

