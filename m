Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E012EE49A4
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjIJUr6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjIJUr5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:47:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E46188
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:47:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD7EC433C9;
        Sun, 10 Sep 2023 20:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378873;
        bh=hj6qgSF6uUm415OKyx1lP6Yif2w1UGNA4YFaD1ZvQ80=;
        h=Date:To:From:Subject:From;
        b=uWmhqdxiSzcGhnMoscRpBGJ1ni6S499Oma6ltp390PSw87R9l7fvI2YMOmZDveDPL
         Su/w0f5DjV0vj/aTKEkMn7M477Bd5Jj8W+FORE2S5g7PdodfNaK7WKnm5KoqA8N4Ux
         qIy6cFbSCQPOtTAkK80PuQ6dO1yuIEQIb6LYeeAQ=
Date:   Sun, 10 Sep 2023 13:47:52 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch added to mm-unstable branch
Message-Id: <20230910204753.2FD7EC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: place debugfs usage at the bottom
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch

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
Subject: Docs/admin-guide/mm/damon/usage: place debugfs usage at the bottom
Date: Thu, 7 Sep 2023 02:29:20 +0000

debugfs interface is deprecated.  Put it at the bottom of the document
so that readers have less chances to read it.

Link: https://lkml.kernel.org/r/20230907022929.91361-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   39 ++++++++---------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -495,6 +495,25 @@ Please note that it's highly recommended
 <https://github.com/awslabs/damo>`_ rather than manually reading and writing
 the files as above.  Above is only for an example.
 
+.. _tracepoint:
+
+Tracepoint for Monitoring Results
+=================================
+
+Users can get the monitoring results via the :ref:`tried_regions
+<sysfs_schemes_tried_regions>` or a tracepoint, ``damon:damon_aggregated``.
+While the tried regions directory is useful for getting a snapshot, the
+tracepoint is useful for getting a full record of the results.  While the
+monitoring is turned on, you could record the tracepoint events and show
+results using tracepoint supporting tools like ``perf``.  For example::
+
+    # echo on > monitor_on
+    # perf record -e damon:damon_aggregated &
+    # sleep 5
+    # kill 9 $(pidof perf)
+    # echo off > monitor_on
+    # perf script
+
 .. _debugfs_interface:
 
 debugfs Interface (DEPRECATED!)
@@ -790,23 +809,3 @@ directory by putting the name of the con
 
 Note that ``mk_contexts``, ``rm_contexts``, and ``monitor_on`` files are in the
 root directory only.
-
-
-.. _tracepoint:
-
-Tracepoint for Monitoring Results
-=================================
-
-Users can get the monitoring results via the :ref:`tried_regions
-<sysfs_schemes_tried_regions>` or a tracepoint, ``damon:damon_aggregated``.
-While the tried regions directory is useful for getting a snapshot, the
-tracepoint is useful for getting a full record of the results.  While the
-monitoring is turned on, you could record the tracepoint events and show
-results using tracepoint supporting tools like ``perf``.  For example::
-
-    # echo on > monitor_on
-    # perf record -e damon:damon_aggregated &
-    # sleep 5
-    # kill 9 $(pidof perf)
-    # echo off > monitor_on
-    # perf script
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

