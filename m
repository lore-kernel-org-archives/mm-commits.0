Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4C5FA3742
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbiJ0ULp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236908AbiJ0ULh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:11:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7438997B
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67987B82615
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD73CC433D6;
        Thu, 27 Oct 2022 20:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901493;
        bh=lOWsJOtoHV9x1PXMS0/FqyJOFX+K7TGVU/8AnTcXg9w=;
        h=Date:To:From:Subject:From;
        b=kSzZhAMSn5h7AlUgdrx/G4gO/JTr/6CF4c8MA+a17rvWy9kQo5EyKSUwxalPoZ62v
         zueCWRjuKaeoJpD048T9N7ZaUu0pHqX2JXuWnQ3PLaM7VZHqyEO3a1Y4XxjSIj49f9
         H0K9OGsoPGdPfkIlUnjw+XAAOatiiQanJn3O3OLk=
Date:   Thu, 27 Oct 2022 13:11:31 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch added to mm-unstable branch
Message-Id: <20221027201132.DD73CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: split out scheme stat update logic into a new function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: split out scheme stat update logic into a new function
Date: Wed, 26 Oct 2022 22:59:34 +0000

The function for applying a given DAMON scheme action to a given DAMON
region, 'damos_apply_scheme()' is not quite short.  Make it better to read
by splitting out the stat update logic into a new function.

Link: https://lkml.kernel.org/r/20221026225943.100429-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/core.c~mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function
+++ a/mm/damon/core.c
@@ -755,6 +755,16 @@ static bool damos_skip_charged_region(st
 	return false;
 }
 
+static void damos_update_stat(struct damos *s,
+		unsigned long sz_tried, unsigned long sz_applied)
+{
+	s->stat.nr_tried++;
+	s->stat.sz_tried += sz_tried;
+	if (sz_applied)
+		s->stat.nr_applied++;
+	s->stat.sz_applied += sz_applied;
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -786,11 +796,7 @@ static void damos_apply_scheme(struct da
 		r->age = 0;
 
 update_stat:
-	s->stat.nr_tried++;
-	s->stat.sz_tried += sz;
-	if (sz_applied)
-		s->stat.nr_applied++;
-	s->stat.sz_applied += sz_applied;
+	damos_update_stat(s, sz, sz_applied);
 }
 
 static void damon_do_apply_schemes(struct damon_ctx *c,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch

