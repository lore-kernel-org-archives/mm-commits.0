Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2A2C43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6617721897
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600486319;
	bh=ZbfBNFZd1Bm6qm+eSJT3eI8OMJKujjp7GZtQQcSNRo8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HsYibtwFpSaBq9KKwJowljiPjo9TPVB3ImUvYnxMoH4OOLyfznPRkqgRSmcZRWxE2
	 jUr4DsMrOt+PgCw6qVRXlnvw0rnDCtW4WJePx+tmcAkHQXsJpbJk9nGdrBFIIFOX5u
	 i/dBo4U1j2uSio4DKx2NElF8S4MTH+NR9XFZhNis=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgISDb7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgISDb6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 23:31:58 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51713206FB;
        Sat, 19 Sep 2020 03:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600486318;
        bh=ZbfBNFZd1Bm6qm+eSJT3eI8OMJKujjp7GZtQQcSNRo8=;
        h=Date:From:To:Subject:From;
        b=ppjd2q3jn4dYtObDOCuKxiym2X5NxieRa57AcXFwpaalUvst44W+mfx9CcswOdW4g
         wsaDwLqRe5wsI3mM0snvZ3JFeHOc9SHXLB1JLkPXOH34ej9XYKzq8omMrO2ErCMMOi
         ZYBk2QL4fMZawgekutTOHf9AB6dd7RYTjHoaIewI=
Date:   Fri, 18 Sep 2020 20:31:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, guro@fb.com,
        linmiaohe@huawei.com
Subject:  +
 =?us-ascii?Q?mm-page=5Fcounter-correct-the-obsolete-func-name-in-the-comm?=
 =?us-ascii?Q?ent-of-page=5Fcounter=5Ftry=5Fcharge.patch?= added to -mm
 tree
Message-ID: <20200919033157.hMm1k%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_counter: correct the obsolete func name in the comment of page_counter_try_charge()
has been added to the -mm tree.  Its filename is
     mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch

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
Subject: mm/page_counter: correct the obsolete func name in the comment of page_counter_try_charge()

Since commit bbec2e15170a ("mm: rename page_counter's count/limit into
usage/max"), page_counter_limit() is renamed to page_counter_set_max().
So replace page_counter_limit with page_counter_set_max in comment.

Link: https://lkml.kernel.org/r/20200917113629.14382-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_counter.c~mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge
+++ a/mm/page_counter.c
@@ -109,7 +109,7 @@ bool page_counter_try_charge(struct page
 		 *
 		 * The atomic_long_add_return() implies a full memory
 		 * barrier between incrementing the count and reading
-		 * the limit.  When racing with page_counter_limit(),
+		 * the limit.  When racing with page_counter_set_max(),
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

