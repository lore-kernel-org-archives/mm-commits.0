Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF1CC04FE0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjHBVwK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjHBVwJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:52:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8079211F
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 845D661B40
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49D9C433C8;
        Wed,  2 Aug 2023 21:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691013126;
        bh=/Bt9/V6QmEd5hmMq49kQ7l8Oex9jiZrbHazPTXHo9cg=;
        h=Date:To:From:Subject:From;
        b=twwOFXUecCegJ6miBwVCCKupImPrP4Eq3EBZIIKUVKUFVGia14GPyXASkdhfizj3H
         KvzrMBhs3qm7dEfHISkiXaszj1FAG/2wbYPwjPE/RS2p+w4pMQIilf/pEeTd6ynd+S
         USE5m2lYy+s6iK1aYScGGFzRcQVeYFUnon3iJIx4=
Date:   Wed, 02 Aug 2023 14:52:06 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch added to mm-unstable branch
Message-Id: <20230802215206.D49D9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: update for DAMON monitoring target type DAMOS filter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch

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
Subject: Docs/mm/damon/design: update for DAMON monitoring target type DAMOS filter
Date: Wed, 2 Aug 2023 21:43:10 +0000

Update DAMON design document for the newly added DAMON monitoring target
type DAMOS filter.

Link: https://lkml.kernel.org/r/20230802214312.110532-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   31 +++++++++++++++-------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter
+++ a/Documentation/mm/damon/design.rst
@@ -380,21 +380,24 @@ number of filters for each scheme.  Each
 memory, and whether it should exclude the memory of the type (filter-out), or
 all except the memory of the type (filter-in).
 
-Currently, anonymous page, memory cgroup, and address range type filters are
-supported by the feature.  Some filter target types can require additional
-arguments.  For example, the memory cgroup filter type asks users to specify
-the file path of the memory cgroup for the filter, while the address range type
-asks the start and end addresses of the range.  Hence, users can apply specific
-schemes to only anonymous pages, non-anonymous pages, pages of specific
-cgroups, all pages excluding those of specific cgroups, pages in specific
-address range, and any combination of those.
+Currently, anonymous page, memory cgroup, address range, and DAMON monitoring
+target type filters are supported by the feature.  Some filter target types
+require additional arguments.  The memory cgroup filter type asks users to
+specify the file path of the memory cgroup for the filter.  The address range
+type asks the start and end addresses of the range.  The DAMON monitoring
+target type asks the index of the target from the context's monitoring targets
+list.  Hence, users can apply specific schemes to only anonymous pages,
+non-anonymous pages, pages of specific cgroups, all pages excluding those of
+specific cgroups, pages in specific address range, pages in specific DAMON
+monitoring targets, and any combination of those.
 
-To handle filters efficiently, the address range type filter is handled by the
-core layer, while others are handled by operations set.  If a memory region is
-filtered by the core layer-handled filter, it is not counted as the scheme has
-tried to the region.  In contrast, if a memory regions is filtered by an
-operations set layer-handled filter, it is counted as the scheme has tried.
-The difference in accounting leads to changes in the statistics.
+To handle filters efficiently, the address range and DAMON monitoring target
+type filters are handled by the core layer, while others are handled by
+operations set.  If a memory region is filtered by a core layer-handled filter,
+it is not counted as the scheme has tried to the region.  In contrast, if a
+memory regions is filtered by an operations set layer-handled filter, it is
+counted as the scheme has tried.  The difference in accounting leads to changes
+in the statistics.
 
 
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

