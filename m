Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3E9EE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjHUUko (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjHUUkV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A24E52
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4747864B0E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADA6C433C9;
        Mon, 21 Aug 2023 20:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650393;
        bh=WyD6NKL2bf65yvy002FQ/JR9xLwXAEtWsX0RVUKXs0E=;
        h=Date:To:From:Subject:From;
        b=ZTYAGCBfTTU01CiuHIRAiCd/s9ZLZpCBXazZAE8nHRmQ6pGGs4JR0sPdgoKAlJ96V
         yQw8Z+NsYzp2+uwswWviFixXBCjVWBpEgv/3+ybxrrxAYPLx3o0izF3HV3g2AEE/Ii
         54Htq6HKle/xmVsCO8R2KkMqG3Yu3Jg6cQ5xloSU=
Date:   Mon, 21 Aug 2023 13:39:53 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch removed from -mm tree
Message-Id: <20230821203953.9ADA6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: update for DAMON monitoring target type DAMOS filter
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


