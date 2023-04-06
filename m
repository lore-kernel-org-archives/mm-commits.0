Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12567C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbjDFCtO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbjDFCsX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D663A5CD
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F24C64230
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988B3C433D2;
        Thu,  6 Apr 2023 02:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749147;
        bh=AvnFt3oMO0GxgsAalTPuhtxiX3laXs2j5N08bDIR7n8=;
        h=Date:To:From:Subject:From;
        b=2Kc5eX87tWuxkWHjQtnxTcCHNgrFaJehEHRUxKbAYyYkCFUsW0a+sMItXl9dnSCXr
         lJLwAexlETp+23kL/SLaiadU/j2Sh/d4wKbgA1QDXBekmBOvQVeqwgSZt91XH91Z9U
         mL8hWGiKnoAmXfUr/Woab3UAzdnSv4lceFqEosYM=
Date:   Wed, 05 Apr 2023 19:45:47 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        sj@kernel.org, linux@weissschuh.ne, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-make-more-kobj_type-structures-constant.patch removed from -mm tree
Message-Id: <20230406024547.988B3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: make more kobj_type structures constant
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-make-more-kobj_type-structures-constant.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
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


