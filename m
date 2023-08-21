Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467F8EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjHUUks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjHUUkY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2593DE5A
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 446F464B17
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFF0C433C7;
        Mon, 21 Aug 2023 20:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650395;
        bh=6XKKKwpRQ0hQgEEh8GVkw1al+r+AYsmTiz20QRAWYBQ=;
        h=Date:To:From:Subject:From;
        b=T1iHw/0M1fzFGNDrMyZVId/c0Qdw9jjo7DQzJKcyn1T0onIG3ooWCjIITbPLzGMHA
         z4ekCdH/O1uwyNzKu5uOUoq7OOj0lwvzKM1RXIFxDfW2uVGWKSi+if6HLyPpK6drIk
         VXDCYT3Pb/X0ab14KfoO+Yre0nPw6X3yiZldo6zs=
Date:   Mon, 21 Aug 2023 13:39:55 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch removed from -mm tree
Message-Id: <20230821203955.9CFF0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for DAMON monitoring target type DAMOS filter
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


