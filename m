Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3402EC41513
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjGXR1o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjGXR1n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:27:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97931E76
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B9BB61202
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804B2C433C8;
        Mon, 24 Jul 2023 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690219655;
        bh=SurLfypRsANx5F58etHLyjmypH72gTbFvwlXWbwB770=;
        h=Date:To:From:Subject:From;
        b=yNJFmy92b67sRk1h/SHCwPQgr4376G7VhLaOr7s6+x8oV/MnvJZL96nEa+JmkPz+S
         46AUbgNRzD9GvwXNWga2QCaH9nN/Jki9EG3K4vd+CKSIOgASkOK4AZrQgBeSxj/3op
         UjE5dkGFovSbOmdufGyeB3swWKj0TFWbGOIMHEEY=
Date:   Mon, 24 Jul 2023 10:27:34 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages.patch added to mm-unstable branch
Message-Id: <20230724172735.804B2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: correct comment of candidate pfn in fast_isolate_freepages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages.patch

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
From: Kemeng Shi <shikemeng@huawei.com>
Subject: mm/compaction: correct comment of candidate pfn in fast_isolate_freepages
Date: Fri, 21 Jul 2023 23:09:56 +0800

Patch series "Two minor cleanups for compaction", v2.

This series contains two random cleanups for compaction.


This patch (of 2):

If no preferred one was not found, we will use candidate page with maximum
pfn > min_pfn which is saved in high_pfn.  Correct "minimum" to "maximum
candidate" in comment.

Link: https://lkml.kernel.org/r/20230721150957.2058634-1-shikemeng@huawei.com
Link: https://lkml.kernel.org/r/20230721150957.2058634-2-shikemeng@huawei.com
Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages
+++ a/mm/compaction.c
@@ -1549,7 +1549,7 @@ static void fast_isolate_freepages(struc
 				break;
 		}
 
-		/* Use a minimum pfn if a preferred one was not found */
+		/* Use a maximum candidate pfn if a preferred one was not found */
 		if (!page && high_pfn) {
 			page = pfn_to_page(high_pfn);
 
_

Patches currently in -mm which might be from shikemeng@huawei.com are

mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages.patch
mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set.patch

