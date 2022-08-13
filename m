Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7186AC19F2D
	for <mm-commits@archiver.kernel.org>; Sat, 13 Aug 2022 23:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiHMXRf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Aug 2022 19:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiHMXRf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 13 Aug 2022 19:17:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD67C8A7D3
        for <mm-commits@vger.kernel.org>; Sat, 13 Aug 2022 16:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 737D3B80AE9
        for <mm-commits@vger.kernel.org>; Sat, 13 Aug 2022 23:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3E6C433C1;
        Sat, 13 Aug 2022 23:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660432651;
        bh=zMrr4z5xfgTSCZS874ommB2EGxa8YBVCINCWLGiupFE=;
        h=Date:To:From:Subject:From;
        b=HnwWYy5CxkW6FnNssnUH/EeDqL1GM4iDIxs4DWBfHmHWpZlwNkL0OXJ8ckgn8Ftd1
         +w1jOJUOnlUXeHaVf4OovgiWOOfDB7eeJFJ5ERquSxbJqI874F3yyu7teo2S65T19V
         yiwaY8gvB2UfnFMMAB8i8ir9xzjo6h7IMOylXktQ=
Date:   Sat, 13 Aug 2022 16:17:30 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, cgel.zte@gmail.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place.patch added to mm-unstable branch
Message-Id: <20220813231731.2E3E6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: make the annotations of refaults code at the right place
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place.patch

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
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/vmscan: make the annotations of refaults code at the right place
Date: Sat, 13 Aug 2022 08:07:58 +0000

After patch "mm/workingset: prepare the workingset detection
infrastructure for anon LRU", we can handle the refaults of anonymous
pages too.  So the annotations of refaults should cover both of anonymous
pages and file pages.

Link: https://lkml.kernel.org/r/20220813080757.59131-1-yang.yang29@zte.com.cn
Fixes: 170b04b7ae4963 ("mm/workingset: prepare the workingset detection infrastructure for anon LRU")
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place
+++ a/mm/vmscan.c
@@ -3226,6 +3226,11 @@ again:
 	if (!sc->force_deactivate) {
 		unsigned long refaults;
 
+		/*
+		 * When refaults are being observed, it means a new
+		 * workingset is being established. Deactivate to get
+		 * rid of any stale active pages quickly.
+		 */
 		refaults = lruvec_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_ANON);
 		if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
@@ -3234,11 +3239,6 @@ again:
 		else
 			sc->may_deactivate &= ~DEACTIVATE_ANON;
 
-		/*
-		 * When refaults are being observed, it means a new
-		 * workingset is being established. Deactivate to get
-		 * rid of any stale active pages quickly.
-		 */
 		refaults = lruvec_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_FILE);
 		if (refaults != target_lruvec->refaults[WORKINGSET_FILE] ||
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch
filemap-make-the-accounting-of-thrashing-more-consistent.patch
mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place.patch

