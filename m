Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9579AE7C4FD
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244551AbjJDUXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245005AbjJDUWc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9A5D7
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FCCC433C7;
        Wed,  4 Oct 2023 20:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450934;
        bh=llaV9C50+7DtEVjMHuSuzyFDORcUOFNiarhT8pCKwqc=;
        h=Date:To:From:Subject:From;
        b=tZhMIYI2Xz80/cUMfJ4e8ZoaYGwLCQQq3Zz4d3LJ+QfE4lf3p9aK7bvN4594cP57e
         U9OFcHGiK9UctsO0SID+W+9IBfMDP027HqYUfiCfHYHZGwIEhv0hWXBZJ6nkK3l/TI
         3RX1gcnAv/9n9rZ2YYWTlLIiv92RuYr/DKrx+LqQ=
Date:   Wed, 04 Oct 2023 13:22:12 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch removed from -mm tree
Message-Id: <20231004202214.62FCCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: mark damon_moving_sum() as a static function
has been removed from the -mm tree.  Its filename was
     mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: mark damon_moving_sum() as a static function
Date: Fri, 15 Sep 2023 02:52:51 +0000

The function is used by only mm/damon/core.c.  Mark it as a static
function.

Link: https://lkml.kernel.org/r/20230915025251.72816-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 --
 mm/damon/core.c       |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-mark-damon_moving_sum-as-a-static-function
+++ a/include/linux/damon.h
@@ -632,8 +632,6 @@ void damon_add_region(struct damon_regio
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges);
-unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
-		unsigned int len_window, unsigned int new_value);
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
 		struct damon_attrs *attrs);
 
--- a/mm/damon/core.c~mm-damon-core-mark-damon_moving_sum-as-a-static-function
+++ a/mm/damon/core.c
@@ -1587,7 +1587,7 @@ int damon_set_region_biggest_system_ram_
  *
  * Return: Pseudo-moving average after getting the @new_value.
  */
-unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
+static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
 		unsigned int len_window, unsigned int new_value)
 {
 	return mvsum - nomvsum / len_window + new_value;
_

Patches currently in -mm which might be from sj@kernel.org are


