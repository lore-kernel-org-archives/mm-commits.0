Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7CBC7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjFIXdS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjFIXcH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265A63A81
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06E9165D0C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FA7C433D2;
        Fri,  9 Jun 2023 23:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353383;
        bh=2hJH9jQb1kfG4toIbFZpZl15t2xvrHuqF4BSfRyZRV8=;
        h=Date:To:From:Subject:From;
        b=NhFf4Ete54Mt4zggXWRkYD+gAyz+wDouVXd3ydVZGxWZA1bhTez6yDc2N4sKqtLg9
         DepsWXCGTIBS8qzr9GmlnV12LU2a8w9WQcCtJii8JoxU/xxU+bk5PEa9M3sv4quYza
         X+lhFiviXPwjVZezsoS2pHBo3teAFByYYV7j9PHw=
Date:   Fri, 09 Jun 2023 16:29:42 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-update-the-layout-based-on-the-layers.patch removed from -mm tree
Message-Id: <20230609232943.59FA7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: update the layout based on the layers
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-update-the-layout-based-on-the-layers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: update the layout based on the layers
Date: Thu, 25 May 2023 21:43:08 +0000

DAMON design document is describing only the operations set layer and
monitoring part of the core logic.  Update the layout based on the DAMON's
layers, so that more parts of DAMON including DAMOS core logic and DAMON
modules can easily be added.

Link: https://lkml.kernel.org/r/20230525214314.5204-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-the-layout-based-on-the-layers
+++ a/Documentation/mm/damon/design.rst
@@ -19,8 +19,8 @@ DAMON subsystem is configured with three
   interfaces for the user space, on top of the core layer.
 
 
-Configurable Layers
-===================
+Configurable Operations Set
+---------------------------
 
 DAMON provides data access monitoring functionality while making the accuracy
 and the overhead controllable.  The fundamental access monitorings require
@@ -42,8 +42,8 @@ Also, if some architectures or devices s
 primitives, those will be easily configurable.
 
 
-Reference Implementations of Address Space Specific Monitoring Operations
-=========================================================================
+Operations Set Layer
+====================
 
 The monitoring operations are defined in two parts:
 
@@ -105,8 +105,12 @@ conflict with the reclaim logic using ``
 as Idle page tracking does.
 
 
-Address Space Independent Core Mechanisms
-=========================================
+Core Logics
+===========
+
+
+Monitoring
+----------
 
 Below four sections describe each of the DAMON core mechanisms and the five
 monitoring attributes, ``sampling interval``, ``aggregation interval``,
@@ -115,7 +119,7 @@ regions``.
 
 
 Access Frequency Monitoring
----------------------------
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The output of DAMON says what pages are how frequently accessed for a given
 duration.  The resolution of the access frequency is controlled by setting
@@ -142,7 +146,7 @@ size of the target workload grows.
 
 
 Region Based Sampling
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 To avoid the unbounded increase of the overhead, DAMON groups adjacent pages
 that assumed to have the same access frequencies into a region.  As long as the
@@ -159,7 +163,7 @@ assumption is not guaranteed.
 
 
 Adaptive Regions Adjustment
----------------------------
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Even somehow the initial monitoring target regions are well constructed to
 fulfill the assumption (pages in same region have similar access frequencies),
@@ -178,7 +182,7 @@ keeping the bounds users set for their t
 
 
 Dynamic Target Space Updates Handling
--------------------------------------
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The monitoring target address range could dynamically changed.  For example,
 virtual memory could be dynamically mapped and unmapped.  Physical memory could
_

Patches currently in -mm which might be from sj@kernel.org are


