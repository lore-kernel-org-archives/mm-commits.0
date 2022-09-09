Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67685ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiIIVac (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiIIVab (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:30:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FAB754BF
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD7F7B80E3E
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F599C433C1;
        Fri,  9 Sep 2022 21:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662759028;
        bh=WMWfmYao8TfIhwl8EI7nkvsjB0khNTPqQvwz8ZzQtps=;
        h=Date:To:From:Subject:From;
        b=kZYgWBCZAEb8+Rb4g3qW5b5zedgQRmTTx//WxW7V2UOWUyjx7sOPjHdfti1H0NQqw
         xgS9c8Ast9Ql7o6suxvYa7a4BxYQFLV4H0IXsh3QLmrT0hGoAbm13GoJSNvHhaeG8i
         4rgl1G0rsPou2BQnRRjy9VnZhPfcIxROLAXL5gro=
Date:   Fri, 09 Sep 2022 14:30:27 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch added to mm-unstable branch
Message-Id: <20220909213028.4F599C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: avoid holes in newly set monitoring target ranges
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch

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
Subject: mm/damon/core: avoid holes in newly set monitoring target ranges
Date: Fri, 9 Sep 2022 20:28:56 +0000

When there are two or more non-contiguous regions intersecting with given
new ranges, 'damon_set_regions()' does not fill the holes.  This commit
makes the function to fill the holes with newly created regions.

Link: https://lkml.kernel.org/r/20220909202901.57977-3-sj@kernel.org
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Yun Levi <ppbuk5246@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges
+++ a/mm/damon/core.c
@@ -169,6 +169,27 @@ static bool damon_intersect(struct damon
 }
 
 /*
+ * Fill holes in regions with new regions.
+ */
+static void damon_fill_regions_holes(struct damon_region *first,
+		struct damon_region *last, struct damon_target *t)
+{
+	struct damon_region *r = first;
+
+	damon_for_each_region_from(r, t) {
+		struct damon_region *next, *newr;
+
+		if (r == last)
+			break;
+		next = damon_next_region(r);
+		if (r->ar.end != next->ar.start) {
+			newr = damon_new_region(r->ar.end, next->ar.start);
+			damon_insert_region(newr, r, next, t);
+		}
+	}
+}
+
+/*
  * damon_set_regions() - Set regions of a target for given address ranges.
  * @t:		the given target.
  * @ranges:	array of new monitoring target ranges.
@@ -226,6 +247,9 @@ int damon_set_regions(struct damon_targe
 			first->ar.start = ALIGN_DOWN(range->start,
 					DAMON_MIN_REGION);
 			last->ar.end = ALIGN(range->end, DAMON_MIN_REGION);
+
+			/* fill possible holes in the range */
+			damon_fill_regions_holes(first, last, t);
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch

