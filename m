Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11B9C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbjIJUsO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjIJUsM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:48:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B9D19C
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:48:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9C6C433C8;
        Sun, 10 Sep 2023 20:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378885;
        bh=wjyq8tRSY54vRLWp5CDBpWd4oEz4jrurT01KS2+IMR0=;
        h=Date:To:From:Subject:From;
        b=BwFNjkrIoyAvZwPY1dAPGYcH41WbOjo2Q9Siuja2BkgVQh7v7CN05WlBtx79zN8w9
         wO/TOTU9q/y4LxERATX9TPLf0ONDnzIKqaCoBKabtMBO2gIJWJEYv8n+TRv8dg/XAm
         NNTRueRUg7DBK7JVWPaaR0kPiL/PIqBGfM1I29f0=
Date:   Sun, 10 Sep 2023 13:48:05 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch added to mm-unstable branch
Message-Id: <20230910204805.CE9C6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: link design doc for details of kdamond and context
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch

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
Subject: Docs/admin-guide/mm/damon/usage: link design doc for details of kdamond and context
Date: Thu, 7 Sep 2023 02:29:25 +0000

The explanation of kdamond and context is duplicated in the design and
the usage documents.  Replace that in the usage with links to those in
the design document.

Link: https://lkml.kernel.org/r/20230907022929.91361-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   19 ++++++++---------
 Documentation/mm/damon/design.rst            |    2 +
 2 files changed, 11 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -105,14 +105,12 @@ having the root permission could use thi
 kdamonds/
 ---------
 
-The monitoring-related information including request specifications and results
-are called DAMON context.  DAMON executes each context with a kernel thread
-called kdamond, and multiple kdamonds could run in parallel.
-
 Under the ``admin`` directory, one directory, ``kdamonds``, which has files for
-controlling the kdamonds exist.  In the beginning, this directory has only one
-file, ``nr_kdamonds``.  Writing a number (``N``) to the file creates the number
-of child directories named ``0`` to ``N-1``.  Each directory represents each
+controlling the kdamonds (refer to
+:ref:`design <damon_design_execution_model_and_data_structures>` for more
+details) exists.  In the beginning, this directory has only one file,
+``nr_kdamonds``.  Writing a number (``N``) to the file creates the number of
+child directories named ``0`` to ``N-1``.  Each directory represents each
 kdamond.
 
 kdamonds/<N>/
@@ -150,9 +148,10 @@ kdamonds/<N>/contexts/
 
 In the beginning, this directory has only one file, ``nr_contexts``.  Writing a
 number (``N``) to the file creates the number of child directories named as
-``0`` to ``N-1``.  Each directory represents each monitoring context.  At the
-moment, only one context per kdamond is supported, so only ``0`` or ``1`` can
-be written to the file.
+``0`` to ``N-1``.  Each directory represents each monitoring context (refer to
+:ref:`design <damon_design_execution_model_and_data_structures>` for more
+details).  At the moment, only one context per kdamond is supported, so only
+``0`` or ``1`` can be written to the file.
 
 .. _sysfs_contexts:
 
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context
+++ a/Documentation/mm/damon/design.rst
@@ -478,6 +478,8 @@ more detail, please read the usage docum
 :doc:`/admin-guide/mm/damon/lru_sort`).
 
 
+.. _damon_design_execution_model_and_data_structures:
+
 Execution Model and Data Structures
 ===================================
 
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

