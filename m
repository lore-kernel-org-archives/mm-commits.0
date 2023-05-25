Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842A2C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241954AbjEYVvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241959AbjEYVu7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4731186
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7E8764B85
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A418C433EF;
        Thu, 25 May 2023 21:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051416;
        bh=uwCqdMy1U7FcBxpL7Dwrxe3Kf0QrxiR+PbnqBxAMM1A=;
        h=Date:To:From:Subject:From;
        b=xWmQIPe2rTP0tiTOrx9Ih8tUgL83KFneZRS3yZD+GkycRYjN+rmiA6FJQ+1nqIWZ3
         9uBCjqNSkomqgNs3d6DwphkoXv7jYpUzpcyPLzgxv5+UUUKQGIJjWRSADG4JLJnoXv
         wfODOypqkMKkKq/+jFEACTJ7sbtehqr+MkYtBpwk=
Date:   Thu, 25 May 2023 14:50:15 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-update-the-layout-based-on-the-layers.patch added to mm-unstable branch
Message-Id: <20230525215016.0A418C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: update the layout based on the layers
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-update-the-layout-based-on-the-layers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-the-layout-based-on-the-layers.patch

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

docs-mm-damon-faq-remove-old-questions.patch
docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors.patch
docs-mm-damon-design-add-a-section-for-overall-architecture.patch
docs-mm-damon-design-update-the-layout-based-on-the-layers.patch
docs-mm-damon-design-rewrite-configurable-layers.patch
docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer.patch
docs-mm-damon-design-add-sections-for-basic-parts-of-damos.patch
docs-mm-damon-design-add-sections-for-advanced-features-of-damos.patch
docs-mm-damon-design-add-a-section-for-damon-core-api.patch
docs-mm-damon-design-add-a-section-for-the-modules-layer.patch

