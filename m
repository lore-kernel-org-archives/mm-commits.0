Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A925BE7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbjJDUS6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244057AbjJDUSv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3283C9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A147C433C7;
        Wed,  4 Oct 2023 20:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450723;
        bh=m6Hq7PgrDUJebNz8G2J7rX4ZD/P6FuPuqKQZ1cCix/c=;
        h=Date:To:From:Subject:From;
        b=x/fdIb4tg7ZVcV0ql0lN1pldf8Zw+VCKJa+AXoDHdjtb2dhBkqUMMTzXBlI6DFE2d
         11+Q2cZukgKlGgE4HJ6DDDX1hMfAh79/u4BgWfHoT7E2YEQ0CqXusCIyUqRDWzg+6t
         VaEYkTImwIZkPotyaiWnNcX6s5+WqkLw5+j88u1g=
Date:   Wed, 04 Oct 2023 13:18:41 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch removed from -mm tree
Message-Id: <20231004201843.4A147C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: remove duplicated comment for watermarks-based deactivation
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove duplicated comment for watermarks-based deactivation
Date: Thu, 7 Sep 2023 02:29:28 +0000

The comment for explaining about watermarks-based monitoring part
deactivation is duplicated in two paragraphs.  Remove one.

Link: https://lkml.kernel.org/r/20230907022929.91361-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation
+++ a/include/linux/damon.h
@@ -317,9 +317,6 @@ struct damos_access_pattern {
  * monitoring context are inactive, DAMON stops monitoring either, and just
  * repeatedly checks the watermarks.
  *
- * If all schemes that registered to a &struct damon_ctx are inactive, DAMON
- * stops monitoring and just repeatedly checks the watermarks.
- *
  * Before applying the &action to a memory region, &struct damon_operations
  * implementation could check pages of the region and skip &action to respect
  * &filters
_

Patches currently in -mm which might be from sj@kernel.org are


