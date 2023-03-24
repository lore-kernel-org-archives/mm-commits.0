Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDC0C6FD1C
	for <mm-commits@archiver.kernel.org>; Fri, 24 Mar 2023 19:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjCXTUT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjCXTUS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Mar 2023 15:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D581B566
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 12:19:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5010262BD1
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 19:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6117C4339B;
        Fri, 24 Mar 2023 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679685589;
        bh=n7aRNMi/yDf93+vjVrWsQtKGjhmAU3QinmSRT73Fiew=;
        h=Date:To:From:Subject:From;
        b=yLISsSz1bfjiVkHvbtZ/MDZfJoCMref1Zd35iR2IuOywmsZ5g5dXXPiBv0kbCpqmJ
         Ylq9BQIpYMq/EKIhpajwLoxF2BZs+JbC3lmkFwBwNSqKBt9LRCy3vtUn0r4EfwdnqB
         9prccoG+aGGyNNEhog/pMBksT6YqPojycD57kn5Y=
Date:   Fri, 24 Mar 2023 12:19:48 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, linux@weissschuh.ne,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-make-more-kobj_type-structures-constant.patch added to mm-unstable branch
Message-Id: <20230324191949.A6117C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: make more kobj_type structures constant
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-make-more-kobj_type-structures-constant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-make-more-kobj_type-structures-constant.patch

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
From: Thomas Weißschuh <linux@weissschuh.ne
Subject: mm/damon/sysfs: make more kobj_type structures constant
Date: Fri, 24 Mar 2023 15:35:27 +0000

Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.") the
driver core allows the usage of const struct kobj_type.

Take advantage of this to constify the structure definition to prevent
modification at runtime.

These structures were not constified in commit e56397e8c40d
("mm/damon/sysfs: make kobj_type structures constant") as they didn't
exist when that patch was written.

Link: https://lkml.kernel.org/r/20230324-b4-kobj_type-damon2-v1-1-48ddbf1c8fcf@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-make-more-kobj_type-structures-constant
+++ a/mm/damon/sysfs-schemes.c
@@ -384,7 +384,7 @@ static struct attribute *damon_sysfs_sch
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme_filter);
 
-static struct kobj_type damon_sysfs_scheme_filter_ktype = {
+static const struct kobj_type damon_sysfs_scheme_filter_ktype = {
 	.release = damon_sysfs_scheme_filter_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_scheme_filter_groups,
@@ -503,7 +503,7 @@ static struct attribute *damon_sysfs_sch
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme_filters);
 
-static struct kobj_type damon_sysfs_scheme_filters_ktype = {
+static const struct kobj_type damon_sysfs_scheme_filters_ktype = {
 	.release = damon_sysfs_scheme_filters_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_scheme_filters_groups,
_

Patches currently in -mm which might be from linux@weissschuh.ne are

mm-cma-make-kobj_type-structure-constant.patch
mm-damon-sysfs-make-more-kobj_type-structures-constant.patch

