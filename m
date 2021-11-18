Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58413C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B03D61A89
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhKRV1R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 16:27:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230274AbhKRV1R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 16:27:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2FF261AEC;
        Thu, 18 Nov 2021 21:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637270656;
        bh=PzNHy7rtvTrdrvBVvgus6nG4LVjBf2zvy1gkG7BTSqI=;
        h=Date:From:To:Subject:From;
        b=Nl+BdQdu+3Yi0CLfToIJBXRFWVkFuP/Gfy+rKLlaNMJo4d79oTwOaND8GRlB6sc/k
         OzsRESI60tlhxutMK2QysgxOCtMBLqK7BZk1epHnOG3wozbr9CfOpibLX1yFTYDiQC
         cf0ze290emHfIxsIPT4RbxaLxLZ3uBpuJ6OA4wbQ=
Date:   Thu, 18 Nov 2021 13:24:16 -0800
From:   akpm@linux-foundation.org
To:     dqiao@redhat.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org
Subject:  +
 mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage.patch
 added to -mm tree
Message-ID: <20211118212416.CPFRUVslu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_counter: remove an incorrect call to propagate_protected_usage()
has been added to the -mm tree.  Its filename is
     mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Donghai Qiao <dqiao@redhat.com>
Subject: mm/page_counter: remove an incorrect call to propagate_protected_usage()

propagate_protected_usage() is called to propagate the usage change in the
page_counter structure.  But there is a call to this function from
page_counter_try_charge() when there is actually no usage change.  Hence
this call should be removed.

Link: https://lkml.kernel.org/r/20211118181125.3918222-1-dqiao@redhat.com
Signed-off-by: Donghai Qiao <dqiao@redhat.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_counter.c~mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage
+++ a/mm/page_counter.c
@@ -120,7 +120,6 @@ bool page_counter_try_charge(struct page
 		new = atomic_long_add_return(nr_pages, &c->usage);
 		if (new > c->max) {
 			atomic_long_sub(nr_pages, &c->usage);
-			propagate_protected_usage(c, new);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
_

Patches currently in -mm which might be from dqiao@redhat.com are

mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage.patch

