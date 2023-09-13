Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AADEE020D
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjIMUQg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbjIMUQg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:16:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECF91BC6
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:16:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD25C433C7;
        Wed, 13 Sep 2023 20:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694636191;
        bh=ddrWdhjQ3cMR83F5x491boIyzc8GiLvg2h10hECsOFI=;
        h=Date:To:From:Subject:From;
        b=ifE8+WEIFeCOgaSZo5swDYarScrYzWmQLGAC5nnxZDOWS+0/odGop0QUfOjvTqPTy
         YPIjHRhhK2M8GWiVE5cjXMuJkQqLoYZuzgdzFmoRbYCbg35vjUM9PkHLtiyYORBR2w
         AfiRvk4jX+y0wkBg/r/yBPD8asTUBiccmzg2xj+A=
Date:   Wed, 13 Sep 2023 13:16:31 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch added to mm-unstable branch
Message-Id: <20230913201631.BCD25C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document damos_before_apply tracepoint
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document damos_before_apply tracepoint
Date: Wed, 13 Sep 2023 02:20:50 +0000

Document damos_before_apply tracepoint on the usage document.

Link: https://lkml.kernel.org/r/20230913022050.2109-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   37 +++++++++++++----
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -496,15 +496,24 @@ the files as above.  Above is only for a
 
 .. _tracepoint:
 
-Tracepoint for Monitoring Results
-=================================
+Tracepoints for Monitoring Results
+==================================
 
 Users can get the monitoring results via the :ref:`tried_regions
-<sysfs_schemes_tried_regions>` or a tracepoint, ``damon:damon_aggregated``.
-While the tried regions directory is useful for getting a snapshot, the
-tracepoint is useful for getting a full record of the results.  While the
-monitoring is turned on, you could record the tracepoint events and show
-results using tracepoint supporting tools like ``perf``.  For example::
+<sysfs_schemes_tried_regions>`.  The interface is useful for getting a
+snapshot, but it could be inefficient for fully recording all the monitoring
+results.  For the purpose, two trace points, namely ``damon:damon_aggregated``
+and ``damon:damos_before_apply``, are provided.  ``damon:damon_aggregated``
+provides the whole monitoring results, while ``damon:damos_before_apply``
+provides the monitoring results for regions that each DAMON-based Operation
+Scheme (:ref:`DAMOS <damon_design_damos>`) is gonna be applied.  Hence,
+``damon:damos_before_apply`` is more useful for recording internal behavior of
+DAMOS, or DAMOS target access
+:ref:`pattern <damon_design_damos_access_pattern>` based query-like efficient
+monitoring results recording.
+
+While the monitoring is turned on, you could record the tracepoint events and
+show results using tracepoint supporting tools like ``perf``.  For example::
 
     # echo on > monitor_on
     # perf record -e damon:damon_aggregated &
@@ -527,6 +536,20 @@ counter).  Finally the tenth field (``X`
 (refer to :ref:`design <damon_design_age_tracking>` for more details of the
 counter).
 
+If the event was ``damon:damos_beofre_apply``, the ``perf script`` output would
+be somewhat like below::
+
+    kdamond.0 47293 [000] 80801.060214: damon:damos_before_apply: ctx_idx=0 scheme_idx=0 target_idx=0 nr_regions=11 121932607488-135128711168: 0 136
+    [...]
+
+Each line of the output represents each monitoring region that each DAMON-based
+Operation Scheme was about to be applied at the traced time.  The first five
+fields are as usual.  It shows the index of the DAMON context (``ctx_idx=X``)
+of the scheme in the list of the contexts of the context's kdamond, the index
+of the scheme (``scheme_idx=X``) in the list of the schemes of the context, in
+addition to the output of ``damon_aggregated`` tracepoint.
+
+
 .. _debugfs_interface:
 
 debugfs Interface (DEPRECATED!)
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
mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions.patch
docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch

