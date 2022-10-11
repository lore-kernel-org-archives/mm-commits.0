Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2B2C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 23:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJKXzr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 19:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJKXzr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 19:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BED253025
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 16:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB1C461134
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 23:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505FDC433C1;
        Tue, 11 Oct 2022 23:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665532545;
        bh=nxJok/Y7Wq0dgvauOo3Ft0ae/FMPjcqKxMjI7CgaPw4=;
        h=Date:To:From:Subject:From;
        b=fupWqYFFL+piOwz8+7Fy0FQPDvKX4LVt70l49qonGzUdu9N4jCuzkEn2QBIN+OF2i
         5FIxjM8t1LFpyLti862YIjqiUaAmeKzPyhVVFP02v/BLn8hdS4QOr7nJ4JAJ6bzZvC
         GlDKVaqmeHrL1NFexHQEecmuCxqR96l/GYitKi7E=
Date:   Tue, 11 Oct 2022 16:55:44 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-more-vma-cache-removal.patch added to mm-unstable branch
Message-Id: <20221011235545.505FDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: more vma cache removal
has been added to the -mm mm-unstable branch.  Its filename is
     mm-more-vma-cache-removal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-more-vma-cache-removal.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: mm: more vma cache removal
Date: Tue, 11 Oct 2022 20:55:31 +0300

Link: https://lkml.kernel.org/r/Y0WuE3Riv4iy5Jx8@localhost.localdomain
Fixes: 7964cf8caa4d ("mm: remove vmacache")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/sched.h~mm-more-vma-cache-removal
+++ a/include/linux/sched.h
@@ -861,8 +861,6 @@ struct task_struct {
 	struct mm_struct		*mm;
 	struct mm_struct		*active_mm;
 
-	/* Per-thread vma caching: */
-
 #ifdef SPLIT_RSS_COUNTING
 	struct task_rss_stat		rss_stat;
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

mm-more-vma-cache-removal.patch
proc-test-how-it-holds-up-with-mappingless-process.patch

