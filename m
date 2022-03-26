Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E94C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 00:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiCZAZ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 20:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiCZAZ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 20:25:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9C52F03C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 17:23:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34273B829F2
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 00:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26E8C2BBE4;
        Sat, 26 Mar 2022 00:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648254227;
        bh=zfW2Z5ohwJ58XiQise2QFsv9btiDs0Od+che8vhV51I=;
        h=Date:To:From:Subject:From;
        b=sQDPxoP+BbbN00j+4qIYVYPlB+6Wg4acmg9yARt6fhdVGfPyzTWup/8+SVWEMsC97
         2XoHeVBtbCSAe2mUqi/uFPsBW7IDMfG+7wAjje31ViPtnVx8Q7cc8IVk1ktmHO/dlX
         YvFN3Jfy7VP2ew592JkOEKOkIeJpdwFyf/Rupgp8=
Date:   Fri, 25 Mar 2022 17:23:47 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-use-helper-isolation_suitable.patch added to -mm tree
Message-Id: <20220326002347.C26E8C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: use helper isolation_suitable()
has been added to the -mm tree.  Its filename is
     mm-compaction-use-helper-isolation_suitable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-use-helper-isolation_suitable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-use-helper-isolation_suitable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: compaction: use helper isolation_suitable()

Use helper isolation_suitable() to check whether page is suitable to
isolate to simplify the code.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220322110750.60311-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-use-helper-isolation_suitable
+++ a/mm/compaction.c
@@ -899,7 +899,7 @@ isolate_migratepages_block(struct compac
 		 * not falsely conclude that the block should be skipped.
 		 */
 		if (!valid_page && IS_ALIGNED(low_pfn, pageblock_nr_pages)) {
-			if (!cc->ignore_skip_hint && get_pageblock_skip(page)) {
+			if (!isolation_suitable(cc, page)) {
 				low_pfn = end_pfn;
 				page = NULL;
 				goto isolate_abort;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mremap-use-helper-mlock_future_check.patch
mm-compaction-use-helper-isolation_suitable.patch

