Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262C3C54EE9
	for <mm-commits@archiver.kernel.org>; Thu,  8 Sep 2022 22:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiIHWln (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Sep 2022 18:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiIHWln (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2022 18:41:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEE1F3406
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 15:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33D0F61E4D
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 22:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E70C433C1;
        Thu,  8 Sep 2022 22:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662676898;
        bh=7pmzp5v/Z8ssKZyEetoVfXqnA3hBLPVEUNYX1VuFhC8=;
        h=Date:To:From:Subject:From;
        b=YAyb7D9UkOYCmltj95856C9jfSIaFYMkjhoBidGor1MIzhTYlWpfm9TO0MjWu1Q7t
         5rYolcfES/hh++IQrBDRvogrzJ73fVgYvRkSAuzE2/S4GP6+ZWlJWkxHuWfWrU9B+D
         hUvMHjSs4hBFQuJQFS/5LLwnauIRlpss/jbKmA1E=
Date:   Thu, 08 Sep 2022 15:41:37 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch added to mm-unstable branch
Message-Id: <20220908224138.82E70C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: add a comment for 'default' case in damon_va_apply_scheme()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch

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
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon/vaddr: add a comment for 'default' case in damon_va_apply_scheme()
Date: Thu, 8 Sep 2022 11:13:17 +0800

The switch case 'DAMOS_STAT' and switch case 'default' have same return
value in damon_va_apply_scheme(), and the 'default' case is for DAMOS
actions that not supported by 'vaddr'.  It might make sense to add a
comment here.

Link: https://lkml.kernel.org/r/1662606797-23534-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme
+++ a/mm/damon/vaddr.c
@@ -658,6 +658,9 @@ static unsigned long damon_va_apply_sche
 	case DAMOS_STAT:
 		return 0;
 	default:
+		/*
+		 * DAMOS actions that not yet supported by 'vaddr'.
+		 */
 		return 0;
 	}
 
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-core-simplify-the-parameter-passing-for-region-split-operation.patch
mm-damon-simplify-the-parameter-passing-for-check_accesses.patch
mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch
mm-damon-get-the-hotness-from-damon_hot_score-in-damon_pageout_score.patch
mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch

