Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C7EC41513
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjHBVwU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjHBVwN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:52:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E827211F
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:52:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CDD261B1F
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719A1C433C9;
        Wed,  2 Aug 2023 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691013130;
        bh=wBwjdlh84i+G7LZfWiFF5DuRwioGBayghL3asN95wj0=;
        h=Date:To:From:Subject:From;
        b=RGfoqnYYrTYuu2dKMYyTryzqo5u83QMvIiRv7PxxMxzAZFUsrgklZP2gt2GwUc+/6
         cPAS0qDas/JTjQ//X6iQH4MDOJkZOYNLm/ZsTJGUkGd83Ozz9RdKdaxh//ZwZt2hvi
         Oj5m7gVzzanZikMp7LE2bta8rQFYBSjkv6RYx/Xo=
Date:   Wed, 02 Aug 2023 14:52:09 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch added to mm-unstable branch
Message-Id: <20230802215210.719A1C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for DAMON monitoring target type DAMOS filter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for DAMON monitoring target type DAMOS filter
Date: Wed, 2 Aug 2023 21:43:12 +0000

Update DAMON usage document for newly added DAMON monitoring target type
DAMOS filter.

Link: https://lkml.kernel.org/r/20230802214312.110532-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   37 +++++++++--------
 1 file changed, 20 insertions(+), 17 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -363,18 +363,21 @@ number (``N``) to the file creates the n
 to ``N-1``.  Each directory represents each filter.  The filters are evaluated
 in the numeric order.
 
-Each filter directory contains five files, namely ``type``, ``matcing``,
-``memcg_path``, ``addr_start``, and ``addr_end``.  To ``type`` file, you can
-write one of three special keywords: ``anon`` for anonymous pages, ``memcg``
-for specific memory cgroup, or ``addr`` for specific address range (an
-open-ended interval) filtering.  In case of the memory cgroup filtering, you
-can specify the memory cgroup of the interest by writing the path of the memory
-cgroup from the cgroups mount point to ``memcg_path`` file.  In case of the
-address range filtering, you can specify the start and end address of the range
-to ``addr_start`` and ``addr_end`` files, respectively.  You can write ``Y`` or
-``N`` to ``matching`` file to filter out pages that does or does not match to
-the type, respectively.  Then, the scheme's action will not be applied to the
-pages that specified to be filtered out.
+Each filter directory contains six files, namely ``type``, ``matcing``,
+``memcg_path``, ``addr_start``, ``addr_end``, and ``target_idx``.  To ``type``
+file, you can write one of four special keywords: ``anon`` for anonymous pages,
+``memcg`` for specific memory cgroup, ``addr`` for specific address range (an
+open-ended interval), or ``target`` for specific DAMON monitoring target
+filtering.  In case of the memory cgroup filtering, you can specify the memory
+cgroup of the interest by writing the path of the memory cgroup from the
+cgroups mount point to ``memcg_path`` file.  In case of the address range
+filtering, you can specify the start and end address of the range to
+``addr_start`` and ``addr_end`` files, respectively.  For the DAMON monitoring
+target filtering, you can specify the index of the target between the list of
+the DAMON context's monitoring targets list to ``target_idx`` file.  You can
+write ``Y`` or ``N`` to ``matching`` file to filter out pages that does or does
+not match to the type, respectively.  Then, the scheme's action will not be
+applied to the pages that specified to be filtered out.
 
 For example, below restricts a DAMOS action to be applied to only non-anonymous
 pages of all memory cgroups except ``/having_care_already``.::
@@ -391,11 +394,11 @@ pages of all memory cgroups except ``/ha
 Note that ``anon`` and ``memcg`` filters are currently supported only when
 ``paddr`` `implementation <sysfs_contexts>` is being used.
 
-Also, memory regions that are filtered out by ``addr`` filters are not counted
-as the scheme has tried to those, while regions that filtered out by other type
-filters are counted as the scheme has tried to.  The difference is applied to
-:ref:`stats <damos_stats>` and :ref:`tried regions
-<sysfs_schemes_tried_regions>`.
+Also, memory regions that are filtered out by ``addr`` or ``target`` filters
+are not counted as the scheme has tried to those, while regions that filtered
+out by other type filters are counted as the scheme has tried to.  The
+difference is applied to :ref:`stats <damos_stats>` and
+:ref:`tried regions <sysfs_schemes_tried_regions>`.
 
 .. _sysfs_schemes_stats:
 
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

