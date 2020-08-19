Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7F5C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 986EC2078D
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597873402;
	bh=uwQy/KvfDyPiTan9gQo+ZoSQCC9UgkP1qPTTygc6Mf8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=J3WukHqOJ1K39GIDlYLmtLNFKpk5xbgv3Ny2nAgrJ/dbxHE8s0isqdKU2Kj1huS1Y
	 ZAv09XsW0ZE8aGblReTrpBzlQoqI0BB388X8kqO1AE8DE6hRWULHkpAy2klFxpaRlD
	 HJbzBFcZSenAx84k6qR6e19LmTtfv9+eEtd+YvKA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHSVnW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgHSVnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 17:43:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B47D20888;
        Wed, 19 Aug 2020 21:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597873401;
        bh=uwQy/KvfDyPiTan9gQo+ZoSQCC9UgkP1qPTTygc6Mf8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dcg+fIRMOWUaY+cGI7Ax0iUHu1cj7xGUe5XNiWj912oIyguLXI2R9E5jkg5+PGJbo
         B/wS66EQmcu+w/qt/+0ctCmVwrdaWySEowA/58y6ktZexTdkcNZEaGrvMVR8Fk39Hd
         bFCnJwcBulC5HiYWYndf0leBHliSQloe28vTjcME=
Date:   Wed, 19 Aug 2020 14:43:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     gustavoars@kernel.org, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  +
 =?US-ASCII?Q?mm-memcontrol-use-the-preferred-form-for-passing-the-size-o?=
 =?US-ASCII?Q?f-a-structure-type.patch?= added to -mm tree
Message-ID: <20200819214320.3H3FyPz-_%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: Use the preferred form for passing the size of a structure type
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-the-preferred-form-for-passing-the-size-of-a-structure-type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-the-preferred-form-for-passing-the-size-of-a-structure-type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-the-preferred-form-for-passing-the-size-of-a-structure-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: mm: memcontrol: Use the preferred form for passing the size of a structure type

Use the preferred form for passing the size of a structure type.  The
alternative form where the structure type is spelled out hurts readability
and introduces an opportunity for a bug when the object type is changed
but the corresponding object identifier to which the sizeof operator is
applied is not.

Link: https://lkml.kernel.org/r/773e013ff2f07fe2a0b47153f14dea054c0c04f1.1596214831.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-the-preferred-form-for-passing-the-size-of-a-structure-type
+++ a/mm/memcontrol.c
@@ -4262,7 +4262,7 @@ static int __mem_cgroup_usage_register_e
 	new->entries[size - 1].threshold = threshold;
 
 	/* Sort thresholds. Registering of new threshold isn't time-critical */
-	sort(new->entries, size, sizeof(struct mem_cgroup_threshold),
+	sort(new->entries, size, sizeof(*new->entries),
 			compare_thresholds, NULL);
 
 	/* Find current threshold */
_

Patches currently in -mm which might be from gustavoars@kernel.org are

mm-memcontrol-use-flex_array_size-helper-in-memcpy.patch
mm-memcontrol-use-the-preferred-form-for-passing-the-size-of-a-structure-type.patch

