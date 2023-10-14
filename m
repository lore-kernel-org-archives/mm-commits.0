Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE57CDB482
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbjJNWdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjJNWdc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:33:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A75C9
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 15:33:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6143EC433C7;
        Sat, 14 Oct 2023 22:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697322810;
        bh=hHFWTgte5AVfWxgVjhuDuzE70Kc1p/V2l+7g2pOlEfE=;
        h=Date:To:From:Subject:From;
        b=wWdhMkVu5xazP+KloT2pwlq062FbsNwxDg+lJNg4r0saw9e+YtzRmYeyN4o1YkN/F
         jlC+VOrIrsghsR+K4ByDPsPEdwr2O+DQy5Huu39OEwpdyPtWVG1mOSQ99KIO2RYufx
         e5a7bNkMNPYSeyI4rvhuQQh+6NdnILFjAfQpqAJU=
Date:   Sat, 14 Oct 2023 15:33:26 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-tried-regions-update-time-interval.patch added to mm-unstable branch
Message-Id: <20231014223330.6143EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for tried regions update time interval
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-tried-regions-update-time-interval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-tried-regions-update-time-interval.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for tried regions update time interval
Date: Thu, 12 Oct 2023 19:22:55 +0000

The documentation says DAMOS tried regions update feature of DAMON sysfs
interface is doing the update for one aggregation interval after the
request is made.  Since the introduction of the per-scheme apply interval,
that behavior makes no much sense.  Hence the implementation has changed
to update the regions for each scheme for only its apply interval. 
Further update the document to reflect the real behavior.

Link: https://lkml.kernel.org/r/20231012192256.33556-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-tried-regions-update-time-interval
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -432,9 +432,9 @@ that reading it returns the total size o
 directories named integer starting from ``0`` under this directory.  Each
 directory contains files exposing detailed information about each of the memory
 region that the corresponding scheme's ``action`` has tried to be applied under
-this directory, during next :ref:`aggregation interval
-<sysfs_monitoring_attrs>`.  The information includes address range,
-``nr_accesses``, and ``age`` of the region.
+this directory, during next :ref:`apply interval <damon_design_damos>` of the
+corresponding scheme.  The information includes address range, ``nr_accesses``,
+and ``age`` of the region.
 
 Writing ``update_schemes_tried_bytes`` to the relevant ``kdamonds/<N>/state``
 file will only update the ``total_bytes`` file, and will not create the
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-check-damos-regions-update-progress-from-before_terminate.patch
mm-damon-sysfs-schemes-do-not-update-tried-regions-more-than-one-damon-snapshot.patch
mm-damon-sysfs-avoid-empty-scheme-tried-regions-for-large-apply-interval.patch
docs-admin-guide-mm-damon-usage-update-for-tried-regions-update-time-interval.patch

