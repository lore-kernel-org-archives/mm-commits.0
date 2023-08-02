Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D905BC00528
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjHBVvz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjHBVvy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:51:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613E5E7D
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5F5061B53
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44729C43395;
        Wed,  2 Aug 2023 21:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691013112;
        bh=M37LgHPUzts2tfrs4IpNOSGDS6W1po86qpWvXfSYPUQ=;
        h=Date:To:From:Subject:From;
        b=Ral2d4uXhCmfXwQT6OX7dvCFkPUnaJAKyz3RsYbqjGBwFo6Jd8MvDTrZwVzwKUDK5
         0JZUE9DwE8qAd7q7S1664DQ2l993CG1E4LLQwcRdGbdCvJaowpJhWwdiiI5ELQC46a
         GY5hCAE9TFVpQYHdipJ4xkg3Fv6kJ/DvSkfpgUYU=
Date:   Wed, 02 Aug 2023 14:51:51 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-update-for-address-range-filters.patch added to mm-unstable branch
Message-Id: <20230802215152.44729C43395@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: update for address range filters
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-update-for-address-range-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-address-range-filters.patch

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
Subject: Docs/mm/damon/design: update for address range filters
Date: Wed, 2 Aug 2023 21:43:04 +0000

Update DAMON design document's DAMOS filters section for address range
DAMOS filters.  Because address range filters are handled by the core
layer and it makes difference in schemes tried regions and schemes
statistics, clearly describe it.

Link: https://lkml.kernel.org/r/20230802214312.110532-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-address-range-filters
+++ a/Documentation/mm/damon/design.rst
@@ -380,12 +380,21 @@ number of filters for each scheme.  Each
 memory, and whether it should exclude the memory of the type (filter-out), or
 all except the memory of the type (filter-in).
 
-As of this writing, anonymous page type and memory cgroup type are supported by
-the feature.  Some filter target types can require additional arguments.  For
-example, the memory cgroup filter type asks users to specify the file path of
-the memory cgroup for the filter.  Hence, users can apply specific schemes to
-only anonymous pages, non-anonymous pages, pages of specific cgroups, all pages
-excluding those of specific cgroups, and any combination of those.
+Currently, anonymous page, memory cgroup, and address range type filters are
+supported by the feature.  Some filter target types can require additional
+arguments.  For example, the memory cgroup filter type asks users to specify
+the file path of the memory cgroup for the filter, while the address range type
+asks the start and end addresses of the range.  Hence, users can apply specific
+schemes to only anonymous pages, non-anonymous pages, pages of specific
+cgroups, all pages excluding those of specific cgroups, pages in specific
+address range, and any combination of those.
+
+To handle filters efficiently, the address range type filter is handled by the
+core layer, while others are handled by operations set.  If a memory region is
+filtered by the core layer-handled filter, it is not counted as the scheme has
+tried to the region.  In contrast, if a memory regions is filtered by an
+operations set layer-handled filter, it is counted as the scheme has tried.
+The difference in accounting leads to changes in the statistics.
 
 
 Application Programming Interface
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch
mm-damon-core-test-add-a-test-for-damos_new_filter.patch
mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch
mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch
selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch
docs-abi-damon-update-for-tried_regions-total_bytes.patch
docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch
mm-damon-core-introduce-address-range-type-damos-filter.patch
mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch
mm-damon-core-test-add-a-unit-test-for-__damos_filter_out.patch
selftests-damon-sysfs-test-address-range-damos-filter.patch
docs-mm-damon-design-update-for-address-range-filters.patch
docs-abi-damon-update-for-address-range-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-address-range-type-damos-filter.patch
mm-damon-core-implement-target-type-damos-filter.patch
mm-damon-sysfs-schemes-support-target-damos-filter.patch
selftests-damon-sysfs-test-damon_target-filter.patch
docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch
docs-abi-damon-update-for-damon-monitoring-target-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch

