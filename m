Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674D4E7C4F7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244024AbjJDUSe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243904AbjJDUSa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D249AD
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF405C433C7;
        Wed,  4 Oct 2023 20:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450706;
        bh=n5vLFGFrtS3909pOZbbMHuXH74BNtgYuwOdU1+Xmw9w=;
        h=Date:To:From:Subject:From;
        b=aAGt7q2oilA7BPM8wZY9ceiuC2iuoh0ABvPgCFXvuJYZaKyBy7d2nvMlwgFka6c1W
         3SQZ6Kxk+Na5ZWejzgt7F2ikx44EFN81vE83wvQ1rsL7e3a4XICA4mB2M3wTQmbboC
         i2EIR/UYuLWga8llCI91nLx9XXaZQoKfvuEafywo=
Date:   Wed, 04 Oct 2023 13:18:24 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch removed from -mm tree
Message-Id: <20231004201825.AF405C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: link design doc for details of kdamond and context
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


