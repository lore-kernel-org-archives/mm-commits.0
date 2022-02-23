Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD69CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Feb 2022 03:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiBWD7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiBWD7e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 22:59:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F47C5EDF2
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 19:59:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42BCFB81E5B
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 03:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72DBC340E7;
        Wed, 23 Feb 2022 03:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645588745;
        bh=Hrrv8bhOjF9LaGC5YdPYzyfoRlaVOyEKSBxPIMuFYOI=;
        h=Date:To:From:Subject:From;
        b=Tex2yS9YfCKhJr3JcbRM8qb81H0zwbtriOwK1FH2RQvRtttz7FnZgNDRZGBoel1KV
         9Ze5NAqa0SK5eD2GCgDVPbKbSIs4kBNZcUELKp5gd50MZnpHtBOT0zwc3VOsv7HQkw
         10T3DCVB3PgtYhEKA6QNtF8RGhaDaDpW4+gCdTiI=
Date:   Tue, 22 Feb 2022 19:59:04 -0800
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-damon-update-outdated-term-regions-update-interval.patch added to -mm tree
Message-Id: <20220223035904.E72DBC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/damon: update outdated term 'regions update interval'
has been added to the -mm tree.  Its filename is
     docs-damon-update-outdated-term-regions-update-interval.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-damon-update-outdated-term-regions-update-interval.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-damon-update-outdated-term-regions-update-interval.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/damon: update outdated term 'regions update interval'

Before DAMON is merged in the mainline, the concept of 'regions update
interval' has generalized to be used as the time interval for update of
any monitoring operations related data structure, but the document has not
updated properly.  This commit updates the document for better
consistency.

Link: https://lkml.kernel.org/r/20220222170100.17068-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    6 +++---
 Documentation/vm/damon/design.rst            |   12 +++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-damon-update-outdated-term-regions-update-interval
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -47,7 +47,7 @@ Attributes
 ----------
 
 Users can get and set the ``sampling interval``, ``aggregation interval``,
-``regions update interval``, and min/max number of monitoring target regions by
+``update interval``, and min/max number of monitoring target regions by
 reading from and writing to the ``attrs`` file.  To know about the monitoring
 attributes in detail, please refer to the :doc:`/vm/damon/design`.  For
 example, below commands set those values to 5 ms, 100 ms, 1,000 ms, 10 and
@@ -128,8 +128,8 @@ ranges, ``20-40`` and ``50-100`` as that
 
 Note that this sets the initial monitoring target regions only.  In case of
 virtual memory monitoring, DAMON will automatically updates the boundary of the
-regions after one ``regions update interval``.  Therefore, users should set the
-``regions update interval`` large enough in this case, if they don't want the
+regions after one ``update interval``.  Therefore, users should set the
+``update interval`` large enough in this case, if they don't want the
 update.
 
 
--- a/Documentation/vm/damon/design.rst~docs-damon-update-outdated-term-regions-update-interval
+++ a/Documentation/vm/damon/design.rst
@@ -95,8 +95,8 @@ Address Space Independent Core Mechanism
 
 Below four sections describe each of the DAMON core mechanisms and the five
 monitoring attributes, ``sampling interval``, ``aggregation interval``,
-``regions update interval``, ``minimum number of regions``, and ``maximum
-number of regions``.
+``update interval``, ``minimum number of regions``, and ``maximum number of
+regions``.
 
 
 Access Frequency Monitoring
@@ -169,6 +169,8 @@ The monitoring target address range coul
 virtual memory could be dynamically mapped and unmapped.  Physical memory could
 be hot-plugged.
 
-As the changes could be quite frequent in some cases, DAMON checks the dynamic
-memory mapping changes and applies it to the abstracted target area only for
-each of a user-specified time interval (``regions update interval``).
+As the changes could be quite frequent in some cases, DAMON allows the
+monitoring operations to check dynamic changes including memory mapping changes
+and applies it to monitoring operations-related data structures such as the
+abstracted monitoring target memory area only for each of a user-specified time
+interval (``update interval``).
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch
docs-vm-damon-call-low-level-monitoring-primitives-the-operations.patch
docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch
docs-damon-update-outdated-term-regions-update-interval.patch

