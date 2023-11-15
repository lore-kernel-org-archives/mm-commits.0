Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC79C5AE4A
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 23:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbjKOXbA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 18:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbjKOXa4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 18:30:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A0BE6;
        Wed, 15 Nov 2023 15:30:52 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A50FC433C8;
        Wed, 15 Nov 2023 23:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700091052;
        bh=p0dzPuqCWA5RxfCuOmYhXNppH/ikxn1W75A9Re44uyo=;
        h=Date:To:From:Subject:From;
        b=uLsYmjkuOSmpECdIYN82vjCb77uJ9EpbxEgcwg2bdeH5/WF0qZrQf3u9/rKlfl1+k
         6PXxKXffSUXCLlCHXDbZBpZ4VrB9MbQeLtI8ygDVCfU7+Km4EwbDhNky/JxEfRTXPH
         c6mp4eD9dP8VMj/YtUYMyt5VQ33RHMjrDSYyQYag=
Date:   Wed, 15 Nov 2023 15:30:51 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        hyeongtak.ji@sk.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-corec-avoid-unintentional-filtering-out-of-schemes.patch removed from -mm tree
Message-Id: <20231115233052.8A50FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core.c: avoid unintentional filtering out of schemes
has been removed from the -mm tree.  Its filename was
     mm-damon-corec-avoid-unintentional-filtering-out-of-schemes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeongtak Ji <hyeongtak.ji@sk.com>
Subject: mm/damon/core.c: avoid unintentional filtering out of schemes
Date: Fri, 10 Nov 2023 14:37:09 +0900

The function '__damos_filter_out()' causes DAMON to always filter out
schemes whose filter type is anon or memcg if its matching value is set
to false.

This commit addresses the issue by ensuring that '__damos_filter_out()'
no longer applies to filters whose type is 'anon' or 'memcg'.

Link: https://lkml.kernel.org/r/1699594629-3816-1-git-send-email-hyeongtak.ji@gmail.com
Fixes: ab9bda001b681 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-corec-avoid-unintentional-filtering-out-of-schemes
+++ a/mm/damon/core.c
@@ -924,7 +924,7 @@ static bool __damos_filter_out(struct da
 		matched = true;
 		break;
 	default:
-		break;
+		return false;
 	}
 
 	return matched == filter->matching;
_

Patches currently in -mm which might be from hyeongtak.ji@sk.com are


