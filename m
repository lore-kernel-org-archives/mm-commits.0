Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FECCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344850AbjJRVht (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbjJRVg6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC66D45
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB67C433CB;
        Wed, 18 Oct 2023 21:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664974;
        bh=3CWsiSCekkllZTvAxNIikTzIe3CT9D/Q+TJVNJ1dB2o=;
        h=Date:To:From:Subject:From;
        b=PcYfs9z2ziKTKQL4Cw3LXfeO4ltSXva9vA/V4ZNz/05G2ChOs0BEa2VzUDZaF4ijD
         60R6zIdWDz21pZw1XXh0UHcxSyNKXzAmFTXo6bS+iK1Jfe12UbVMRqJBfUD01M/k6M
         w7uMwb+Dsc73I9MJlC/zlQpkd+UWBh38WbFTJ3l0=
Date:   Wed, 18 Oct 2023 14:36:13 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-tried-regions-update-time-interval.patch removed from -mm tree
Message-Id: <20231018213614.3BB67C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for tried regions update time interval
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-tried-regions-update-time-interval.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


