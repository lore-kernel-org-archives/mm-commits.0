Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0416C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjIJUsG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjIJUsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:48:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163B9188
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:48:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4298C433C7;
        Sun, 10 Sep 2023 20:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378881;
        bh=ZEsPjwMw9BAA0tLaTsSX72gNGONfQMAYoxaS16AWAfE=;
        h=Date:To:From:Subject:From;
        b=1kIidDSShdzDzOibUF+PvRPkFuScVmyorAnWaily8B4CdPBisaTvoCrkjlOr8shd4
         MPb/FfnFdVGLFytwlBXRpdn2FFAHsjHpus7dAqIwaIQKPlChWizZrYKP58l+uFit2A
         xleb+SkV59/8KufgjcNkzvIB/6yLQb2gdoZJPG4g=
Date:   Sun, 10 Sep 2023 13:48:01 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch added to mm-unstable branch
Message-Id: <20230910204801.A4298C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: explain the format of damon_aggregate tracepoint
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch

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
Subject: Docs/admin-guide/mm/damon/usage: explain the format of damon_aggregate tracepoint
Date: Thu, 7 Sep 2023 02:29:23 +0000

The example of the section for damon_aggregated tracepoint is not
explaining how the output looks like, and how it can be interpreted.
Add it.

Link: https://lkml.kernel.org/r/20230907022929.91361-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   14 ++++++++++++++
 Documentation/mm/damon/design.rst            |    4 ++++
 2 files changed, 18 insertions(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -513,6 +513,20 @@ results using tracepoint supporting tool
     # kill 9 $(pidof perf)
     # echo off > monitor_on
     # perf script
+    kdamond.0 46568 [027] 79357.842179: damon:damon_aggregated: target_id=0 nr_regions=11 122509119488-135708762112: 0 864
+    [...]
+
+Each line of the perf script output represents each monitoring region.  The
+first five fields are as usual other tracepoint outputs.  The sixth field
+(``target_id=X``) shows the ide of the monitoring target of the region.  The
+seventh field (``nr_regions=X``) shows the total number of monitoring regions
+for the target.  The eighth field (``X-Y:``) shows the start (``X``) and end
+(``Y``) addresses of the region in bytes.  The ninth field (``X``) shows the
+``nr_accesses`` of the region (refer to
+:ref:`design <damon_design_region_based_sampling>` for more details of the
+counter).  Finally the tenth field (``X``) shows the ``age`` of the region
+(refer to :ref:`design <damon_design_age_tracking>` for more details of the
+counter).
 
 .. _debugfs_interface:
 
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint
+++ a/Documentation/mm/damon/design.rst
@@ -154,6 +154,8 @@ The monitoring overhead of this mechanis
 size of the target workload grows.
 
 
+.. _damon_design_region_based_sampling:
+
 Region Based Sampling
 ~~~~~~~~~~~~~~~~~~~~~
 
@@ -191,6 +193,8 @@ In this way, DAMON provides its best-eff
 keeping the bounds users set for their trade-off.
 
 
+.. _damon_design_age_tracking:
+
 Age Tracking
 ~~~~~~~~~~~~
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch

