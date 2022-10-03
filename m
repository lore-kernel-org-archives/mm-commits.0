Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6E1C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiJCVND (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiJCVLi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A2951A28
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93020611F9
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75A1C433D6;
        Mon,  3 Oct 2022 21:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831233;
        bh=GpCI729Fpu1fdUMSUVd1vh1u+z2COsGOj00KmBKQU8s=;
        h=Date:To:From:Subject:From;
        b=PHNAu2wij8XzUIdP2s72nUcipZaWi8TiU16QrPhWEF8vTNxq7xDGQXUiKPFudlGZf
         WOLGRknSoQN3l077U2wVkwk5Rh60x4LsvwWf4UxjXxtUyIY1fr6JIzNUSNmeUbJRcE
         sacGUmu6xrrc9jL8UFzyUCw8Ju9GHkJIKcei6tus=
Date:   Mon, 03 Oct 2022 14:07:12 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch removed from -mm tree
Message-Id: <20221003210712.E75A1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: make supported DAMOS actions of paddr clear
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: make supported DAMOS actions of paddr clear
Date: Tue, 13 Sep 2022 17:44:28 +0000

Patch series "mm/damon: cleanup code".

DAMON code was not so clean from the beginning, but it has been too much
nowadays, especially due to the duplicates in DAMON_RECLAIM and
DAMON_LRU_SORT.  This patchset cleans some of the mess.


This patch (of 22):

The 'switch-case' statement in 'damon_va_apply_scheme()' function provides
a 'case' for every supported DAMOS action while all not-yet-supported
DAMOS actions fall through the 'default' case, and comment it so that
people can easily know which actions are supported.  Its counterpart in
'paddr', 'damon_pa_apply_scheme()', however, doesn't.  This commit makes
the 'paddr' side function follows the pattern of 'vaddr' for better
readability and consistency.

Link: https://lkml.kernel.org/r/20220913174449.50645-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220913174449.50645-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-make-supported-damos-actions-of-paddr-clear
+++ a/mm/damon/paddr.c
@@ -275,7 +275,10 @@ static unsigned long damon_pa_apply_sche
 		return damon_pa_mark_accessed(r);
 	case DAMOS_LRU_DEPRIO:
 		return damon_pa_deactivate_pages(r);
+	case DAMOS_STAT:
+		break;
 	default:
+		/* DAMOS actions that not yet supported by 'paddr'. */
 		break;
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

