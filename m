Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3CCEE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjHUUkl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjHUUkS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14A2E47
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2EA164AFB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37500C433C8;
        Mon, 21 Aug 2023 20:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650389;
        bh=0j8MU/ciLNBd1iJL+u463XG3l5c19/bVWlQ+sJv/rFA=;
        h=Date:To:From:Subject:From;
        b=CskfhT3ZP5KGscrKx1pvV21PVa1l5QcAZnnB2QEqO9o9b4/XSj56+VFSLcZ2AbB4Y
         ptBsfCii3h6hRde6UVbiH313VaCeKehJcpacYrYF7JnhDZVptOsMVn0uMM7cretKy3
         LiUPQd9UuBk0J4wA/OpclbQ8BeEWTPgtV6XPFLeU=
Date:   Mon, 21 Aug 2023 13:39:48 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-address-range-type-damos-filter.patch removed from -mm tree
Message-Id: <20230821203949.37500C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for address range type DAMOS filter
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-address-range-type-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for address range type DAMOS filter
Date: Wed, 2 Aug 2023 21:43:06 +0000

Update DAMON usage document for the newly added address range type DAMOS
filter.

Link: https://lkml.kernel.org/r/20230802214312.110532-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   31 ++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-address-range-type-damos-filter
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -363,15 +363,18 @@ number (``N``) to the file creates the n
 to ``N-1``.  Each directory represents each filter.  The filters are evaluated
 in the numeric order.
 
-Each filter directory contains three files, namely ``type``, ``matcing``, and
-``memcg_path``.  You can write one of two special keywords, ``anon`` for
-anonymous pages, or ``memcg`` for specific memory cgroup filtering.  In case of
-the memory cgroup filtering, you can specify the memory cgroup of the interest
-by writing the path of the memory cgroup from the cgroups mount point to
-``memcg_path`` file.  You can write ``Y`` or ``N`` to ``matching`` file to
-filter out pages that does or does not match to the type, respectively.  Then,
-the scheme's action will not be applied to the pages that specified to be
-filtered out.
+Each filter directory contains five files, namely ``type``, ``matcing``,
+``memcg_path``, ``addr_start``, and ``addr_end``.  To ``type`` file, you can
+write one of three special keywords: ``anon`` for anonymous pages, ``memcg``
+for specific memory cgroup, or ``addr`` for specific address range (an
+open-ended interval) filtering.  In case of the memory cgroup filtering, you
+can specify the memory cgroup of the interest by writing the path of the memory
+cgroup from the cgroups mount point to ``memcg_path`` file.  In case of the
+address range filtering, you can specify the start and end address of the range
+to ``addr_start`` and ``addr_end`` files, respectively.  You can write ``Y`` or
+``N`` to ``matching`` file to filter out pages that does or does not match to
+the type, respectively.  Then, the scheme's action will not be applied to the
+pages that specified to be filtered out.
 
 For example, below restricts a DAMOS action to be applied to only non-anonymous
 pages of all memory cgroups except ``/having_care_already``.::
@@ -385,8 +388,14 @@ pages of all memory cgroups except ``/ha
     echo /having_care_already > 1/memcg_path
     echo N > 1/matching
 
-Note that filters are currently supported only when ``paddr``
-`implementation <sysfs_contexts>` is being used.
+Note that ``anon`` and ``memcg`` filters are currently supported only when
+``paddr`` `implementation <sysfs_contexts>` is being used.
+
+Also, memory regions that are filtered out by ``addr`` filters are not counted
+as the scheme has tried to those, while regions that filtered out by other type
+filters are counted as the scheme has tried to.  The difference is applied to
+:ref:`stats <damos_stats>` and :ref:`tried regions
+<sysfs_schemes_tried_regions>`.
 
 .. _sysfs_schemes_stats:
 
_

Patches currently in -mm which might be from sj@kernel.org are


