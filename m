Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4D1EE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjHUUkj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjHUUkQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EBAE42
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E05C464B00
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39547C433C7;
        Mon, 21 Aug 2023 20:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650387;
        bh=OE6gJlXrLL9gcO/F4WNTDFkh4Y13pxp7uq5da1QIGr8=;
        h=Date:To:From:Subject:From;
        b=n2613WJgkFB9SGoZlkS3CrNCEOUBShdG2QYGyVwEIWtXECJGvLRR+WTjkmhPRLqNe
         P9vTC1GHmAK1bRJ7h+1SzB0NFrVdNyk0Tos/9f/acnYqHfdqhzo8O5wNH8HM8u1VIe
         V2RftO8yTej2DVb4/XemCWNxTtqBisge66IFN1wI=
Date:   Mon, 21 Aug 2023 13:39:46 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-update-for-address-range-filters.patch removed from -mm tree
Message-Id: <20230821203947.39547C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: update for address range filters
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-update-for-address-range-filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


